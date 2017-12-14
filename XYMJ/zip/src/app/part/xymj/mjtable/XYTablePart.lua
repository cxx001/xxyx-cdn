local CURRENT_MODULE_NAME = ...
local TablePart = import(".TablePart")
local XYTablePart = class("XYTablePart",TablePart)

XYTablePart.DEFAULT_PART = {
	'NormalReadyPart',
	'NormalCardPart',
	"ChatPart",
	"NaozhuangPart",
	"WifiAndNetPart",
	'GameEndPart',
	"SmallUserInfoPart",
	"VipOverPart",
	"BroadcastPart",--加入小喇叭节点
	"DissolvePart",
	"RoomSettingPart",--设置组件（牌局内）
	"GpsPart",
	"GpsTipPart",
	"TipsPart",
	"XiazuiPart",
	'RedpacketMgrPart',	--红包管理界面组件
	'RedpacketTipsPart',	--红包展示组件
	'RewardTipsPart',	--红包奖励展示组件
	"XiazuiPart",
	"ReadyMatchPart",   -- 比赛准备
    "WinMatchPart",     -- 比赛胜利
    "LoseMatchPart",    -- 比赛淘汰
    "MatchOverPart",    -- 比赛结算
}
XYTablePart.DEFAULT_VIEW = "XYTableScene"
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".game_start_message_pb")
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".player_table_operation_msg_pb")

function XYTablePart:activate(gameId,data)
	--进入游戏场不需要延时断线
	XYTablePart.super.activate(self,gameId,data)
	---------------------------------------------------------
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:registerMsgListener(SocketConfig.MSG_PLAYER_OPERATION_NTF,handler(self,XYTablePart.ntfOperationHandle)) --提醒玩家进行操作
	net_mode:registerMsgListener(SocketConfig.MSG_PLAYER_OPERATION,handler(self,XYTablePart.playerOperation))
	net_mode:registerMsgListener(SocketConfig.MSG_GAME_START,handler(self,XYTablePart.gameStartNtf)) --牌局开始
end

function XYTablePart:playerOperation(data,appId)
	local card_part = self:getPart("NormalCardPart")
	local ready_part = self:getPart("NormalReadyPart")
	local naozhuang_part = self:getPart("NaozhuangPart")
	local player_operaction = player_table_operation_msg_pb.PlayerTableOperationMsg()
	player_operaction:ParseFromString(data)
    print("XYTablePart:playerOperation=",player_operaction)

    if bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_CHU) ~= RoomConfig.MAHJONG_OPERTAION_CHU 
		and bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_AN_GANG) ~= RoomConfig.MAHJONG_OPERTAION_AN_GANG 
		and bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_MING_GANG) ~= RoomConfig.MAHJONG_OPERTAION_MING_GANG 
		and bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_BU_GANG) ~= RoomConfig.MAHJONG_OPERTAION_BU_GANG
		and bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_PENG) ~= RoomConfig.MAHJONG_OPERTAION_PENG
		and player_operaction.operation ~= RoomConfig.MAHJONG_OPERTAION_XIAZUI 
		and player_operaction.operation ~= RoomConfig.MAHJONG_OPERTAION_CHOOSE_XIAZUI 
		and player_operaction.operation ~=  RoomConfig.MAHJONG_OPERTAION_OVERTIME_XIAZUI then
    		XYTablePart.super.playerOperation(self, player_operaction, appId)
    end

	local cur_seat_id = player_operaction.player_table_pos
	local cur_view_id = self:changeSeatToView(cur_seat_id)
	
	if player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_XIAZUI then --通知可以下嘴
		local xiazui_part = self:getPart("XiazuiPart")
		if xiazui_part then
			xiazui_part:activate(player_operaction.opValue)
		end
		if ready_part then
			ready_part:hideReadyBtn()
		end
	elseif player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_CHOOSE_XIAZUI then --服务器通知下嘴结果
		self:setXiazuiVal(cur_view_id, player_operaction.opValue)
		if cur_view_id == RoomConfig.MySeat then
			local xiazui_part = self:getPart("XiazuiPart")
			if xiazui_part then
				xiazui_part:deactivate()
			end
			if ready_part and ready_part.showXiazuiTips then
				ready_part:showXiazuiTips()
			end
		end
	elseif player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_OVERTIME_XIAZUI then --客户端选择下嘴超时操作
		local xiazui_part = self:getPart("XiazuiPart")
		if xiazui_part then
			xiazui_part:deactivate()
			if ready_part and ready_part.showXiazuiTips then
				ready_part:showXiazuiTips()
			end
		end
	elseif player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_EXTEND_CARD_REMIND then --砍牌成功
		card_part:onKanPaiSucceed(cur_view_id)
	elseif player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_EXTEND_CARD_SUCCESSFULLY then --砍牌取消成功或超时取消
		card_part:onKanPaiCancle(cur_view_id)
	elseif player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_NOTIFY_NAO_ZHUANG then --可以闹庄
		naozhuang_part:activate()
		naozhuang_part:onNotifyNaozhuang(cur_view_id)
	elseif player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_NAO_ZHUANG then --有人选择闹庄通知
		self:onNotifySelectNaozhuan(cur_view_id)
	elseif player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_CANCLE_NAO_ZHUANG then --有人选择不闹庄通知
		--do nothing	
	elseif player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_NOTIFY_TONG_NAO then --可以通闹
		naozhuang_part:activate()
		naozhuang_part:onNotifyTongnao(cur_view_id)
	elseif player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_TONG_NAO then --有人通闹通知
		self:onNotifySelectTongnao(cur_view_id)	
	elseif player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_CANCLE_TONG_NAO then --有人选择不通闹通知
		--do nothing
	elseif player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_NAO_CHAOSHI then --闹庄和通闹超时
		naozhuang_part:onNotifySelectNaoChaoshi()
		if cur_seat_id == self.m_seat_id then
			card_part:showAutoOutCard(card_value) --托管需要出牌
			card_part:refreshMyCard(player_operaction.handCards or {},player_operaction.downCards,player_operaction.beforeCards,card_value)
			card_part:resetNaozhuangCard(player_operaction.naoZhuangCards or {})
		end
	elseif bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_CHU) == RoomConfig.MAHJONG_OPERTAION_CHU then --其他玩家出牌
		print("###[XYTablePart:playerOperation] 玩家出牌回包")
		local card_value = bit._and(player_operaction.card_value, 0xff) 
		if cur_seat_id == self.m_seat_id and #player_operaction.handCards  > 0 then --如果是自己就刷新手牌 
			card_part:showAutoOutCard(card_value) --托管需要出牌
			card_part:refreshMyCard(player_operaction.handCards,player_operaction.downCards,player_operaction.beforeCards,card_value)
			card_part:resetNaozhuangCard(player_operaction.naoZhuangCards or {})
		elseif cur_seat_id == self.m_seat_id then
			card_part:showAutoOutCard(card_value) --托管需要出牌
			card_part:refreshMyCard({},player_operaction.downCards,player_operaction.beforeCards,card_value)
			card_part:resetNaozhuangCard(player_operaction.naoZhuangCards or {})			
		elseif cur_seat_id ~= self.m_seat_id then  
			card_part:showOutCard(cur_view_id,card_value)
		end
	elseif bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_AN_GANG) == RoomConfig.MAHJONG_OPERTAION_AN_GANG or bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_MING_GANG) == RoomConfig.MAHJONG_OPERTAION_MING_GANG or bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_BU_GANG) == RoomConfig.MAHJONG_OPERTAION_BU_GANG then
        print("###[XYTablePart:playerOperation] 点杠操作回包")
        if player_operaction.opValue == RoomConfig.MAHJONG_OPERTAION_GANG_NOTIFY  then
        	print("###[XYTablePart:playerOperation] player_operaction.opValue == RoomConfig.MAHJONG_OPERTAION_GANG_NOTIFY")
         	return
        end 

        local card_value = player_operaction.opValue
        local c1 = bit._and(card_value,0xff)
        local c2 = bit._and(bit.rshift(card_value,8),0xff)
        local c3 = bit._and(bit.rshift(card_value,16),0xff)
        local c4 = bit._and(bit.rshift(card_value,24),0xff)

        if player_operaction.opValue == RoomConfig.MAHJONG_OPERTAION_GANG_NOTIFY  then
         	return
        end

		local op_card = 0
		if c1 == c4 then
		  op_card = bit._or(bit._or(bit.lshift(c3,16),bit.lshift(c1,8)),c2)
		elseif c3 == c4 then
		  op_card = bit._or(bit._or(bit.lshift(c2,16),bit.lshift(c3,8)),c1)
        else
          op_card = bit._or(player_operaction.opValue,0xffffff)
        end

		op_card = bit._or(op_card,bit.lshift(c2,24))

		local card = {}
		for i=1, 4 do
		  	card[i] = bit._and(bit.rshift(op_card,(i-1)*8),0xff)
		end
		local cur_seat_id = player_operaction.player_table_pos
		local cur_view_id = self:changeSeatToView(cur_seat_id)
		local card_data = {mcard={card[1],card[2],card[3]},ocard=card[4],kanpai={}}

		if bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_AN_GANG) == RoomConfig.MAHJONG_OPERTAION_AN_GANG then
			card_data = {mcard={RoomConfig.EmptyCard,RoomConfig.EmptyCard,RoomConfig.EmptyCard,RoomConfig.EmptyCard},kanpai={}}
			if cur_seat_id == self.m_seat_id then --我自己可以看见第二张牌
				card_data = {mcard= {RoomConfig.EmptyCard,RoomConfig.EmptyCard,RoomConfig.EmptyCard,card[4]},kanpai={}}
			end
		elseif bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_BU_GANG) == RoomConfig.MAHJONG_OPERTAION_BU_GANG then
			card_data = {mcard={card[1]},kanpai={}} --补杠只有一张牌
        elseif bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_MING_GANG) == RoomConfig.MAHJONG_OPERTAION_MING_GANG then
            card_data = {mcard={c1,c2,c3},ocard=c4,kanpai={}}
        end

        local moCardNum = #(card_data.mcard)
		for i=1,player_operaction.useXiaoNum or 0 do
			card_data.kanpai[i] = card_data.mcard[moCardNum+1-i]
			card_data.mcard[moCardNum+1-i]=nil
		end

		local playerkanpainum = player_operaction.playerkanpainums[cur_seat_id+1] or 0
		card_part:optCard(cur_view_id,player_operaction.operation,card_data,nil,playerkanpainum)

	elseif bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_PENG) == RoomConfig.MAHJONG_OPERTAION_PENG then --碰
		print("###[XYTablePart:playerOperation] 点碰操作回包")

		local opvalue = player_operaction.opValue
		local c1 = bit._and(opvalue,0xff)
		local c2 = bit._and(bit.rshift(opvalue,8),0xff)
		local c3 = bit._and(bit.rshift(opvalue,16),0xff)
		print("this is  peng:",c1,c2,c3)
		local cur_seat_id = player_operaction.player_table_pos
		local cur_view_id = self:changeSeatToView(cur_seat_id)
		local card_data = {mcard={c1,c2},ocard=c3,kanpai={}}

		for i=1,player_operaction.useXiaoNum or 0 do
			card_data.kanpai[i] = card_data.mcard[3-i]
			card_data.mcard[3-i]=nil
		end

		local playerkanpainum = player_operaction.playerkanpainums[cur_seat_id+1] or 0
		card_part:optCard(cur_view_id,RoomConfig.MAHJONG_OPERTAION_PENG,card_data,nil,playerkanpainum)
	end	
end

function XYTablePart:ntfOperationHandle(data,appId)
	local ntf_operation = ycmj_message_pb.PlayerOperationNotifyMsg()
	ntf_operation:ParseFromString(data)
	print(string.format("###[XYTablePart:ntfOperationHandle]  0x%02x", ntf_operation.operation))

	local ready_part = self:getPart("NormalReadyPart")
	local naozhuang_part = self:getPart("NaozhuangPart")
	if ntf_operation.operation == RoomConfig.MAHJONG_OPERTAION_WAITING_TONG_NAO then
		naozhuang_part:activate()
		naozhuang_part:onNotifyWaitTongnao()
	elseif ntf_operation.operation == RoomConfig.MAHJONG_OPERTAION_WAITING_NAO_ZHUANG then
		naozhuang_part:activate()
		naozhuang_part:onNotifyWaitNaozhuang()
	else
		self:ntfOperation(ntf_operation, appId)
	end
end

function XYTablePart:onKanpaiMenuShow()
	self.view:startCountTime(5)
end

function XYTablePart:gameStartNtf(data,appId)
	local game_start = game_start_message_pb.GameStartMsg()
	game_start:ParseFromString(data)
	self.playerwin = game_start.playerwin
	print("XYTablePart:gameStartNtf=",game_start)
	local ready_part = self:getPart("NormalReadyPart")
	ready_part:hideView()

	for i=1,4 do
		local view_id = self:changeSeatToView(i-1)

		if game_start.playerisnaozhuang and game_start.playerisnaozhuang[i] and (game_start.playerisnaozhuang[i] == 1) then
			if (i - 1) == game_start.dealerpos then
				self:onNotifySelectTongnao(view_id)
			else
				self:onNotifySelectNaozhuan(view_id)
			end
		end
	end
	
	local playWay = game_start.newplayway or 0
	local playWayStr = string_table.playway_type_bgz_only
	if bit._and(playWay, 0x40) == 0x40 then
		playWayStr = string_table.playway_type_bgz
	elseif bit._and(playWay, 0x80) == 0x80 then
		playWayStr = string_table.playway_type_mtp
	end
	self:setPlayWay(playWayStr)
	
	self.dealerpos = game_start.dealerpos
	self:startGame(game_start)
end

function XYTablePart:startGame(data)
	local chat_part = self:getPart("ChatPart")
	if chat_part then
    	local pos_table = self.view:getPosTable()
    	local voiceRoomID = tostring(self.game_id) .. "_" .. tostring(self.room_id)
    	chat_part:activate(self.game_id,pos_table,voiceRoomID)
		chat_part:hideSzBtn()
    end

	local card_part = self:getPart("NormalCardPart")
	card_part:deactivate()
    card_part:activate(self.game_id,data)

    if self.tableid > 1 then ----显示当前局数和总局数  1/4局
    	local quanTotal = bit._and(data.serviceGold,0xff)
    	self.view:dispalyQuan(data.quannum,quanTotal)
    	self.cur_hand = data.quannum --当前局数
    	self.total_hand =quanTotal --总局数
    end

	self.last_card_num = 0
	self.m_seat_id = data.mtablePos
	self.view:initTableWithData(self.player_list,data)
end

function XYTablePart:playerOperationHandle(data,appId)
	local player_operaction = ycmj_message_pb.PlayerTableOperationMsg()
	player_operaction:ParseFromString(data)
    print("TablePart:playerOperation:",player_operaction,bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_BU_GANG))
	self:playerOperation(player_operaction, appId)
end

function XYTablePart:onNotifySelectNaozhuan(viewId)
	print("XYTablePart:onNotifySelectNaozhuan")
	self.view:showNaozhuangIcon(viewId)
	-- local card_part = self:getPart("NormalCardPart")
	-- if card_part then
	-- 	card_part:showNaozhuangIcon(viewId)
	-- end
end

function XYTablePart:onNotifySelectTongnao(viewId)
	print("XYTablePart:onNotifySelectTongnao")
	self.view:showTongnaoIcon(viewId)
	-- local card_part = self:getPart("NormalCardPart")
	-- if card_part then
	-- 	card_part:showTongnaoIcon(viewId)
	-- end
end

--自己摸了一张牌
function XYTablePart:operationChu(data)
	-- body
	local card_part = self:getPart("NormalCardPart")
	if data.chicardvalue ~= 0 then --是否摸了新牌，如果是断线回来，这个通知里面没有新牌
		card_part:getCard(data.chicardvalue)
	end

	local opt_type = nil
	local card_value = {}
	--如果玩家听牌
	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_HU) == RoomConfig.MAHJONG_OPERTAION_HU then
		opt_type = RoomConfig.MAHJONG_OPERTAION_HU
		card_value.mcard = {}
		card_part:addOpt(RoomConfig.MAHJONG_OPERTAION_HU)
	end

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_AN_GANG) == RoomConfig.MAHJONG_OPERTAION_AN_GANG then
		opt_type = RoomConfig.MAHJONG_OPERTAION_AN_GANG
		card_value.mcard = {data.pengcardvalue,data.pengcardvalue,data.pengcardvalue,data.pengcardvalue}
		card_part:addOpt(RoomConfig.Gang)
	end

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_BU_GANG) == RoomConfig.MAHJONG_OPERTAION_BU_GANG then
		opt_type = RoomConfig.MAHJONG_OPERTAION_BU_GANG
		card_value.mcard = {data.pengcardvalue}
		card_part:addOpt(RoomConfig.Gang)
	end

	if opt_type then
		card_part:showAddOpt(data.pengcardvalue,true,self.last_card_num) --自己摸牌不显示过
	end
end




function XYTablePart:operationCard(data)
	-- body
	local card_part = self:getPart("NormalCardPart")
	local dis_play_guo = true --是否显示过牌
	print("This is YNTablePart operationCard:",bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_PENG),bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_AN_GANG),bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_MING_GANG))

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
		card_part:addOpt(RoomConfig.MAHJONG_OPERTAION_PENG)
	end

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_CHI) == RoomConfig.MAHJONG_OPERTAION_CHI then
		card_part:setChiList(data.chicardvalue,data.targetcard)
		card_part:addOpt(RoomConfig.MAHJONG_OPERTAION_CHI)
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

	card_part:showAddOpt(data.pengcardvalue,dis_play_guo,self.last_card_num)
end

function XYTablePart:isNaozhuangIconShow()
	return self.view:isNaozhuangIconShow()
end

function XYTablePart:settingsClick()
	-- body
	local settings_part = self:getPart("RoomSettingPart")
	if settings_part then
		settings_part:activate(self.tableid)
	end
end

function XYTablePart:setPlayWay(playwayStr)
	self.playwatStr = playwayStr
end

function XYTablePart:getPlayWay()
	return self.playwatStr or ""
end

function XYTablePart:gameEnd(data)
	XYTablePart.super.gameEnd(self, data)
	local game_end = self:getPart("GameEndPart")
	if game_end.setPlaywayStr then
		game_end:setPlaywayStr(self.playwatStr)
	end
end

function XYTablePart:headClick(player_info , posX , posY , viewId )
	self.smalluserinfo_part = self:getPart("SmallUserInfoPart") 
	if self.smalluserinfo_part then
		self.smalluserinfo_part:deactivate()
		local is_vip = false
		if self.tableid > 1 then
			is_vip = true
		end

		local desc = self:getXiazuiDesc(viewId) or ""
		self.smalluserinfo_part:activate(self.game_id, player_info , posX , posY , viewId ,self.playerwin,is_vip, desc)
	end
end

function XYTablePart:setXiazuiVal(curSeatId, xiazuiVal)
	if not self.xiazuiVal then
		self.xiazuiVal = {}
	end

	self.xiazuiVal[curSeatId] = xiazuiVal
	-- if bit._and(xiazuiVal, 0x1000) == 0x1000 then
	-- 	for i=1,4 do
	-- 		self.xiazuiVal[curSeatId] = bit._or(self.xiazuiVal[curSeatId], 0x1000)
	-- 	end
	-- end
end

function XYTablePart:getXiazuiDesc(curSeatId)
	local desc = ""

	if not self.xiazuiVal then
		self.xiazuiVal = {}
		return desc
	end
	
	local xiazuiVal = self.xiazuiVal[curSeatId] or 0
	local dealerpos = self.dealerpos or 0

	local hasPaozi = false
	for i=1, 4 do
		local val = self.xiazuiVal[i] or 0
		if bit._and(val, 0x1000) == 0x1000 then
			hasPaozi = true
			break
		end
	end

	print("XXXXXXX self.dealerpos, curSeatId, self.m_seat_id ", self.dealerpos, curSeatId, self.m_seat_id, hasPaozi)
	print("XXXXXXX (self.dealerpos - self.m_seat_id), (curSeatId - 1) ", (self.dealerpos - self.m_seat_id), (curSeatId - 1))
	print("XXXXXXX (self.dealerpos - self.m_seat_id + 4), (curSeatId - 1) ", (self.dealerpos - self.m_seat_id + 4), (curSeatId - 1))
	if hasPaozi and (((self.dealerpos - self.m_seat_id) == (curSeatId - 1)) or ((self.dealerpos - self.m_seat_id + 4) == (curSeatId - 1))) then
		desc = desc .. string_table.bdy_paozi
	end

	print("XXXXXXX xiazuiVal, curSeatId, desc ", xiazuiVal, curSeatId, desc)
	if bit._and(xiazuiVal, 0x800) == 0x800 then
		desc = desc .. string_table.bdy_zhadan
	end

	if bit._and(xiazuiVal, 0x80) == 0x80 then
		desc = desc .. string_table.bdy_menqing
	end

	if bit._and(xiazuiVal, 0x200) == 0x200 then
		desc = desc .. string_table.bdy_duanmen
	end

	if bit._and(xiazuiVal, 0x100) == 0x100 then
		desc = desc .. string_table.bdy_jiazi
	end

	if bit._and(xiazuiVal, 0x400) == 0x400 then
		desc = desc .. string_table.bdy_bazhang
	end

	print("XXXXXXX desc ", desc)
	return desc
end

return XYTablePart
