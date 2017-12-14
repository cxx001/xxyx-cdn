local CURRENT_MODULE_NAME = ...
local HBTablePart = class("HBTablePart", import(".TablePart"))
HBTablePart.DEFAULT_VIEW = "HBTableScene" 

function HBTablePart:activate(gameId,data)
	self.game_id = gameId
	HBTablePart.super.activate(self,gameId,data)
	local tableInfo = data.tableinfo
	self.view:updateTableShow(tableInfo)
end


--自己摸了一张牌
function HBTablePart:operationChu(data)
	print("###[HBTablePart:operationChu]")
	-- body
	local card_part = self:getPart("CardPart")
	if data.chicardvalue ~= 0 then --是否摸了新牌，如果是断线回来，这个通知里面没有新牌
		card_part:getCard(data.chicardvalue)
	end

	local opt_type = false
	local card_value = {}
	--如果玩家听牌
	if bit._check(data.operation,RoomConfig.MAHJONG_OPERTAION_HU) then
		opt_type = true  
		if data.hutype == 1 then
			card_part:addOpt(RoomConfig.MAHJONG_OPERTAION_ZIMO)
		else
			card_part:addOpt(RoomConfig.MAHJONG_OPERTAION_HU)
		end
		
		print("###[HBTablePart:operationChu] RoomConfig.MAHJONG_OPERTAION_HU data.hutype is ", data.hutype)
	end

	if bit._check(data.operation,RoomConfig.MAHJONG_OPERTAION_AN_GANG) then
		opt_type = true 
		card_part:addOpt(RoomConfig.Gang)
		print("###[HBTablePart:operationChu] RoomConfig.AN_GANG")
	end

	if bit._check(data.operation,RoomConfig.MAHJONG_OPERTAION_BU_GANG) then
		opt_type = true 
		card_part:addOpt(RoomConfig.Gang)
	end 
	print("data.operation is ", data.operation)
	print("###[HBTablePart:operationChu]opt_type ", opt_type)
	card_part:showAddOpt(data.pengcardvalue,opt_type) --自己非摸牌显示过
end

function HBTablePart:ntfOperation(ntf_operation,appId)
	if bit._check(ntf_operation.operation, RoomConfig.PIZI_NOTIFY) then --处理亮牌提示 
		self:operationCard(ntf_operation)
	else
		HBTablePart.super.ntfOperation(self, ntf_operation, appId)
	end
end



--吃椪杠后服务器回传通知
function HBTablePart:playerOperation(player_operaction,appId)
	if bit._check(player_operaction.operation,RoomConfig.PIZI_NOTIFY) then
		print("###[HBTablePart:playerOperation]服务器下发吃椪杠后亮牌提示")
		local c1,c2,c3,c4 = bit._split32(player_operaction.opValue)
		local card_data = {mcard={c1,c2,c3}}
		local cur_seat_id = player_operaction.player_table_pos
		local cur_view_id = self:changeSeatToView(cur_seat_id)
		print(string.format("HBTablePart:playerOperation:%d, %d, %d, %d", c1, c2, c3, c4))
		self:getPart("CardPart"):optCard(cur_view_id,RoomConfig.PIZI_NOTIFY,card_data)
	else
		HBTablePart.super.playerOperation(self, player_operaction, appId)
	end
end

function HBTablePart:doGangShowLogic(seatID, gangType, card_value)  
	print(string.format("HBTablePart:doGangShowLogic gangType %x", gangType))

    local card,baseCard = self:getSrcGangCard(card_value) 

	local card_data = {mcard={card[1],card[2],card[3]},ocard=card[4]}

	local cardPart = self:getPart("CardPart")
	local viewID = self:changeSeatToView(seatID)

    if cardPart:isPiZi(card[1]) then
    	if bit._and(gangType,RoomConfig.MAHJONG_OPERTAION_MING_GANG) == RoomConfig.MAHJONG_OPERTAION_MING_GANG then
    		card_data = {mcard={card[1],card[2]},ocard=card[4]}
    		cardPart:optCard(viewID, RoomConfig.PIZI_NOTIFY, card_data)
    	else
    		card_data = {mcard={card[1],card[2],card[3]}}
    		cardPart:optCard(viewID, RoomConfig.PIZI_NOTIFY_AN, card_data)
    	end 
    	
    	return
    end 

	if bit._and(gangType,RoomConfig.MAHJONG_OPERTAION_AN_GANG) == RoomConfig.MAHJONG_OPERTAION_AN_GANG then
		card_data = {mcard={RoomConfig.EmptyCard,RoomConfig.EmptyCard,RoomConfig.EmptyCard,card[4]}}
		if seatID == self.m_seat_id then --我自己可以看见第二张牌
			card_data = {mcard= {RoomConfig.EmptyCard,RoomConfig.EmptyCard,RoomConfig.EmptyCard,card[4]}}
		end
	elseif bit._and(gangType,RoomConfig.MAHJONG_OPERTAION_BU_GANG) == RoomConfig.MAHJONG_OPERTAION_BU_GANG then
		card_data = {mcard={card[1]}} --补杠只有一张牌
    elseif bit._and(gangType,RoomConfig.MAHJONG_OPERTAION_MING_GANG) == RoomConfig.MAHJONG_OPERTAION_MING_GANG  then
        card_data = {mcard={baseCard[1],baseCard[2],baseCard[3]},ocard=baseCard[4]}
    end  

    cardPart:optCard(viewID, gangType, card_data) 
end


function HBTablePart:gameEnd(data)
	-- body
	local game_end = self:getPart("GameEndPart")
	local card_part =self:getPart("CardPart")
	self.view:hideMenu()
	if game_end then
		local last_round = false
		
		if self.cur_hand > 0 and self.tableid > 1 and self.cur_hand >= self.total_hand then --vip场才有显示战绩
			last_round = true
		end
		
		game_end:activate(self.game_id, data, self.m_seat_id,last_round, card_part:getPizi(), card_part:getLaizi())
		if self.tableid > 1 then
			game_end:hideBackBtn() -- vip场小结算隐藏返回按钮
		end
	end

	if card_part then
		card_part:deactivate()
	end

	if self.smalluserinfo_part then
		self.smalluserinfo_part:deactivate()
	end
end

function HBTablePart:scrollMsgAck(data,appId)		--跑马灯消息
	-- body
	if tonumber(appId) == tonumber(SocketConfig.GAME_ID) then
		local broadcast_node = self:getPart("BroadcastPart")
	    if nil == broadcast_node then
	    	return
	    end
	    --产品说牌局内暂时去掉跑马灯
	    if nil ~= broadcast_node then
	    	broadcast_node:isShowBroadcastNode(false)
	    	return
	    end
		local net_manager = global:getNetManager()
		local scroll_msg = wllobby_message_pb.ScrollMsg()
		scroll_msg:ParseFromString(data) 
		local msg = scroll_msg.msg
		local loopNum = scroll_msg.loopNum
		local removeAll = scroll_msg.removeAll 
		broadcast_node:isShowBroadcastNode(true)
		broadcast_node:startBroadcast(msg,loopNum,removeAll,true,appId)

		local ready_part = self:getPart("ReadyPart")
		if ready_part then
			ready_part:scrollMsgAck(data,appId)
		end
	end
end

 
return HBTablePart
