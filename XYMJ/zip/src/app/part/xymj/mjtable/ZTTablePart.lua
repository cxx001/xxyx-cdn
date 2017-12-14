local CURRENT_MODULE_NAME = ...
local TablePart = import(".TablePart")
local ZTTablePart = class("ZTTablePart",TablePart)
ZTTablePart.DEFAULT_VIEW = "TableScene"

function ZTTablePart:activate(data)
	--进入游戏场不需要延时断线
	ZTTablePart.super.activate(self,data)
	---------------------------------------------------------
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:registerMsgListener(SocketConfig.MSG_PLAYER_OPERATION_NTF,handler(self,ZTTablePart.ntfOperation)) --提醒玩家进行操作
	net_mode:registerMsgListener(SocketConfig.MSG_PLAYER_OPERATION,handler(self,ZTTablePart.playerOperation))
end

--自己摸了一张牌
function ZTTablePart:operationChu(data)
	-- body
	local card_part = self:getPart("CardPart")
	if data.chicardvalue ~= 0 then --是否摸了新牌，如果是断线回来，这个通知里面没有新牌
		card_part:getCard(data.chicardvalue)
	end
	
	print("ZTTablePart:operationChu--data=", data)

	local opt_type = nil
	local card_value = {}
	--如果玩家听牌
	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_HU) == RoomConfig.MAHJONG_OPERTAION_HU then
		opt_type = RoomConfig.MAHJONG_OPERTAION_HU
		card_value.mcard = {}
		card_part:addOpt(RoomConfig.MAHJONG_OPERTAION_HU)
	end

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_AN_GANG) == RoomConfig.MAHJONG_OPERTAION_AN_GANG then
		opt_type = RoomConfig.AN_GANG
		card_value.mcard = {data.pengcardvalue,data.pengcardvalue,data.pengcardvalue,data.pengcardvalue}
		card_part:addOpt(RoomConfig.Gang)
	end

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_BU_GANG) == RoomConfig.MAHJONG_OPERTAION_BU_GANG then
		opt_type = RoomConfig.BU_GANG
		card_value.mcard = {data.pengcardvalue}
		card_part:addOpt(RoomConfig.Gang)
	end

	if opt_type then
		card_part:showAddOpt(data.pengcardvalue,true) --自己摸牌不显示过
	end
end




function ZTTablePart:operationCard(data)
	-- body
	local card_part = self:getPart("CardPart")
	local dis_play_guo = true --是否显示过牌
	print("ZTTablePart:operationCard--",bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_PENG),bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_AN_GANG),bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_MING_GANG))
	print("ZTTablePart:operationCard--it is hu card",bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_HU))


	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_CHU) == RoomConfig.MAHJONG_OPERTAION_CHU  then
		if data.chicardvalue ~= 0 then
			card_part:getCard(data.chicardvalue)
		end
	end

	if bit._and(data.operation,RoomConfig.Gang) == RoomConfig.Gang and bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_HU) ~= RoomConfig.MAHJONG_OPERTAION_HU then
  		local card_data = data.gangList
  		print("This is YNTablePart operationCard:",data.operation,RoomConfig.MAHJONG_OPERTAION_CHU,bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_CHU))
  		if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_CHU) == RoomConfig.MAHJONG_OPERTAION_CHU  then
  			dis_play_guo = false --自己出牌不显示过  
   		else
  			card_part:addOpt(RoomConfig.Gang)		
  		end
  		card_part:ntfGangList(card_data)
  	elseif bit._and(data.operation,RoomConfig.Gang) == RoomConfig.Gang then
		local card_data = data.gangList
		card_part:addOpt(RoomConfig.Gang)
		card_part:ntfGangList(card_data)	
	end

	

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_PENG) == RoomConfig.MAHJONG_OPERTAION_PENG then
		local c1 = bit._and(data.pengcardvalue,0xff)
		local c2 = bit._and(bit.rshift(data.pengcardvalue,8),0xff)
		local cur_seat_id = data.playertablepos
		local cur_view_id = self:changeSeatToView(cur_seat_id)
		local card_data = {mcard={c1,c2},ocard=c1}
		-- card_part:ntfOpt(RoomConfig.Peng,card_data,data.pengcardvalue)
		card_part:addOpt(RoomConfig.Peng)
	end

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_CHI) == RoomConfig.MAHJONG_OPERTAION_CHI then
		card_part:setChiList(data.chicardvalue,data.targetcard)
		card_part:addOpt(RoomConfig.Chi)
	end

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_HU) == RoomConfig.MAHJONG_OPERTAION_HU then
		card_part:addOpt(RoomConfig.MAHJONG_OPERTAION_HU)
	end

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_POP_LAST) == RoomConfig.MAHJONG_OPERTAION_POP_LAST then
		--显示2张 可点击的尾牌
		local cur_seat_id = data.playertablepos
		local cur_view_id = self:changeSeatToView(cur_seat_id)
		local card_data = {mcard={},ocard=data.targetcard}
		card_part:ntfOpt(RoomConfig.MAHJONG_OPERTAION_POP_LAST,card_data,data.targetcard)
		return
	end

	card_part:showAddOpt(data.pengcardvalue,dis_play_guo)
	--用于昭通麻将摆牌后，自动出牌阶段的，杠胡的检测
	card_part:showAddOpt_AutoOutCard(data.pengcardvalue,dis_play_guo)

end


function ZTTablePart:ntfOperation(data,appId)
	ZTTablePart.super.ntfOperation(self, data, appId)
	
	local ntf_operation = ycmj_message_pb.PlayerOperationNotifyMsg()
	ntf_operation:ParseFromString(data)
	print("ZTTablePart:ntfOperation=",ntf_operation)
	local card_part = self:getPart("CardPart")
	
	if bit._and(ntf_operation.operation,RoomConfig.MAHJONG_OPERTAION_AUTO_CHU) == RoomConfig.MAHJONG_OPERTAION_AUTO_CHU then --服务器下发自动出牌
		print("ZTTablePart:ntfOperation--摆牌后，服务器下发自动出牌通知")
		local card_value = ntf_operation.chicardvalue
		card_part:showAutoOutCard(card_value) 		--显示自动出牌
		card_part:requestOutCard_auto(card_value)	--发送自动出牌请求
		--card_part:refreshMyCard(ntf_operation.handCards,ntf_operation.downCards,ntf_operation.beforeCards,card_value)
	end
end


function ZTTablePart:playerOperation(data,appId)
	ZTTablePart.super.playerOperation(self, data, appId)
	
	local card_part = self:getPart("CardPart")
	local player_operaction = ycmj_message_pb.PlayerTableOperationMsg()
	player_operaction:ParseFromString(data)
    print("ZTTablePart:playerOperation=",player_operaction)
	local cur_seat_id = player_operaction.player_table_pos
	local cur_view_id = self:changeSeatToView(cur_seat_id)
	
	if player_operaction.operation == RoomConfig.PLAYER_OPERATION_BAIPAI then --玩家点击摆牌回应
		if #player_operaction.handCards == 0 then
			print("ZTTablePart:playerOperation--不能摆牌--提示玩家")
			  local tips_part = require('app.part.tips.TipsPart').new(self)
			if tips_part then
				tips_part:activate({info_txt=string_table.current_no_baipai--[[, left_click=function()
					-- body
					global:activatePart("LoginPart")
				end--]]})
			end
		else
			print("ZTTablePart:playerOperation--能摆牌--处理摆牌")
			--处理摆牌操作表现和逻辑
			print("TablePart:playerOperation--服务器下发座位号=", cur_view_id)
			local cur_seat_id = player_operaction.player_table_pos
			local cur_view_id = self:changeSeatToView(cur_seat_id)
			print("TablePart:playerOperation--客户端转换座位号=", cur_view_id)
			card_part:baipaiShowCards(cur_view_id, player_operaction.handCards)
		end
	end
	
	
end





return ZTTablePart
