local CURRENT_MODULE_NAME = ...
local TablePart = import(".TablePart")
local XYTablePart = class("XYTablePart",TablePart)

XYTablePart.DEFAULT_PART = {
	'ReadyPart',
	'CardPart',
	"TeamVoicePart",
	"ChatPart",
	"NaozhuangPart",
	"WifiAndNetPart",
	'GameEndPart',
	"SmallUserInfoPart",
	"VipOverPart",
	"BroadcastPart",--加入小喇叭节点
	"DissolvePart",
	"RoomSettingPart",--设置组件（牌局内）
	"RoomMenuPart", -- 菜单组件
	"GpsPart",
	"GpsTipPart",
	"SettingsPart",--设置组件（牌局内）
	"XiazuiPart",
	"PlayWayPart",
	"ReadyMatchPart",   -- 比赛准备
    "WinMatchPart",     -- 比赛胜利
    "LoseMatchPart",    -- 比赛淘汰
    "MatchOverPart",    -- 比赛结算
    "TipsPart",
    "NtfUploadLogPart",
}
XYTablePart.DEFAULT_VIEW = "XYTableScene"
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".game_start_message_pb")
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".player_table_operation_msg_pb")
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".PlayerOperationNotifyMsg_pb")
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".PlayerTableOperationMsg_pb")
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".xymj_message_pb")
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".xy_player_game_over_ack_pb")

function XYTablePart:activate(gameId,data)
	if data and data.tableinfo and data.tableinfo.playwaytype then
		self.playwaytype = data.tableinfo.playwaytype
	end

	--进入游戏场不需要延时断线
	XYTablePart.super.activate(self,gameId,data)
	---------------------------------------------------------
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:registerMsgListener(SocketConfig.MSG_PLAYER_OPERATION_NTF,handler(self,XYTablePart.ntfOperationHandleXY)) --提醒玩家进行操作
	net_mode:registerMsgListener(SocketConfig.MSG_PLAYER_OPERATION,handler(self,XYTablePart.playerOperation))
	net_mode:registerMsgListener(SocketConfig.MSG_GAME_START,handler(self,XYTablePart.gameStartNtf)) --牌局开始
	net_mode:registerMsgListener(SocketConfig.MSG_GAME_OVER_ACK,handler(self,XYTablePart.gameOverAck))

	-- @ todo jarry
	-- @ 比赛初始化，data为空表{}，请把逻辑写入到 if not self.match_mode then end 里面；


	if not self.match_mode then
		self.in_voice_room = false
		self.tableinfo =data.tableinfo
		self.playwaytype = self.tableinfo.playwaytype
		self.view:updateTableShow(data.tableinfo) 
	end
end

function XYTablePart:playerOperation(data,appId)
	local card_part = self:getPart("CardPart")
	local ready_part = self:getPart("ReadyPart")
	local naozhuang_part = self:getPart("NaozhuangPart")
	local player_operaction = xymj_message_pb.PlayerTableOperationMsg()
	player_operaction:ParseFromString(data)
    print("XYTablePart:playerOperation=",player_operaction)
    local xy_operaction_extend = player_operaction.Extensions[xymj_message_pb.XYPlayerTableOperationMsg.xyExt]

    if bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_CHU) ~= RoomConfig.MAHJONG_OPERTAION_CHU 
		and bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_AN_GANG) ~= RoomConfig.MAHJONG_OPERTAION_AN_GANG 
		and bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_MING_GANG) ~= RoomConfig.MAHJONG_OPERTAION_MING_GANG 
		and bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_BU_GANG) ~= RoomConfig.MAHJONG_OPERTAION_BU_GANG
		and bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_PENG) ~= RoomConfig.MAHJONG_OPERTAION_PENG
		and player_operaction.operation ~= RoomConfig.MAHJONG_OPERTAION_XIAZUI
		and player_operaction.operation ~= RoomConfig.MAHJONG_OPERTAION_CHOOSE_XIAZUI 
		and player_operaction.operation ~=  RoomConfig.MAHJONG_OPERTAION_OVERTIME_XIAZUI then
    		XYTablePart.super.playerOperationHandle(self, player_operaction, appId)
    end

	local cur_seat_id = player_operaction.player_table_pos
	local cur_view_id = self:changeSeatToView(cur_seat_id)
	
	if player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_XIAZUI then --通知可以下嘴
		release_print(os.date("%c") .. "[info] 信阳牌桌收到可以下嘴通知")
		local xiazui_part = self:getPart("XiazuiPart")
		if xiazui_part then
			xiazui_part:activate(player_operaction.opValue)
		end
		if ready_part then
			ready_part:hideReadyBtn()
		end
	elseif player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_CHOOSE_XIAZUI then --服务器通知下嘴结果
		release_print(os.date("%c") .. "[info] 信阳牌桌收到下嘴结果通知")
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
		release_print(os.date("%c") .. "[info] 信阳牌桌收到下嘴超时通知")
		local xiazui_part = self:getPart("XiazuiPart")
		if xiazui_part then
			xiazui_part:deactivate()
			if ready_part and ready_part.showXiazuiTips then
				ready_part:showXiazuiTips()
			end
		end
	elseif player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_EXTEND_CARD_REMIND then --砍牌成功
		release_print(os.date("%c") .. "[info] 信阳牌桌收到坎牌成功通知")
		card_part:onKanPaiSucceed(cur_view_id)
	elseif player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_SHUAIPAI then --甩牌成功
		release_print(os.date("%c") .. "[info] 信阳牌桌收到玩家甩牌通知")		
		card_part:onNotifyThrowCard(xy_operaction_extend.playerShuaiPaiStates, xy_operaction_extend.shuaiPaiNums)
	elseif player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_EXTEND_CARD_SUCCESSFULLY then --砍牌取消成功或超时取消
		release_print(os.date("%c") .. "[info] 信阳牌桌收到坎牌取消或者超时的通知")
		card_part:onKanPaiCancle(cur_view_id)
	elseif player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_NOTIFY_NAO_ZHUANG then --可以闹庄
		release_print(os.date("%c") .. "[info] 信阳牌桌收到可以闹庄通知")
		naozhuang_part:activate()
		naozhuang_part:onNotifyNaozhuang(cur_view_id)
	elseif player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_NAO_ZHUANG then --有人选择闹庄通知
		release_print(os.date("%c") .. "[info] 信阳牌桌收到有人闹庄的通知，操作玩家本地位置: ", cur_view_id)
		self:onNotifySelectNaozhuan(cur_view_id)
	elseif player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_CANCLE_NAO_ZHUANG then --有人选择不闹庄通知
		--do nothing
		release_print(os.date("%c") .. "[info] 信阳牌桌收到有人选择不闹庄的通知")	
	elseif player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_NOTIFY_TONG_NAO then --可以通闹
		release_print(os.date("%c") .. "[info] 信阳牌桌收到可以通闹的通知")
		naozhuang_part:activate()
		naozhuang_part:onNotifyTongnao(cur_view_id)
	elseif player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_TONG_NAO then --有人通闹通知
		release_print(os.date("%c") .. "[info] 信阳牌桌收到有人通闹的通知，操作玩家本地位置: ", cur_view_id)
		self:onNotifySelectTongnao(cur_view_id)	
	elseif player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_CANCLE_TONG_NAO then --有人选择不通闹通知
		--do nothing
		release_print(os.date("%c") .. "[info] 信阳牌桌收到有人选择不通闹的通知")
	elseif player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_NAO_CHAOSHI then --闹庄和通闹超时
		release_print(os.date("%c") .. "[info] 信阳牌桌收到通闹和通闹超时的通知，操作玩家本地位置: ", cur_view_id)
		naozhuang_part:onNotifySelectNaoChaoshi()
		if cur_seat_id == self.m_seat_id then
			card_part:showAutoOutCard(card_value) --托管需要出牌
			card_part:refreshMyCard(player_operaction.handCards or {},player_operaction.downCards,player_operaction.beforeCards,card_value)
			card_part:resetNaozhuangCard(player_operaction.naoZhuangCards or {})
		end
	elseif bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_CHU) == RoomConfig.MAHJONG_OPERTAION_CHU then --其他玩家出牌
		print("###[XYTablePart:playerOperation] 玩家出牌回包")
		release_print(os.date("%c") .. "[info] 信阳牌桌收到有人出牌的通知，操作玩家本地位置，下发的牌值 ", cur_view_id, player_operaction.card_value)
		local card_value = bit._and(player_operaction.card_value, 0xff) 
		if cur_seat_id == self.m_seat_id and #player_operaction.handCards  > 0 then --如果是自己就刷新手牌 
			card_part:showAutoOutCard(card_value) --托管需要出牌
			card_part:refreshMyCard(player_operaction.handCards,player_operaction.downCards,player_operaction.beforeCards,card_value)
			card_part:resetNaozhuangCard(player_operaction.naoZhuangCards or {})
			card_part:resetShuaiPaiScript(xy_operaction_extend.playerShuaiPaiCards)
		elseif cur_seat_id == self.m_seat_id then
			card_part:showAutoOutCard(card_value) --托管需要出牌
			card_part:refreshMyCard({},player_operaction.downCards,player_operaction.beforeCards,card_value)
			card_part:resetNaozhuangCard(player_operaction.naoZhuangCards or {})			
		elseif cur_seat_id ~= self.m_seat_id then  
			card_part:showOutCard(cur_view_id,card_value)
		end
	elseif bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_AN_GANG) == RoomConfig.MAHJONG_OPERTAION_AN_GANG or bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_MING_GANG) == RoomConfig.MAHJONG_OPERTAION_MING_GANG or bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_BU_GANG) == RoomConfig.MAHJONG_OPERTAION_BU_GANG then
        print("###[XYTablePart:playerOperation] 点杠操作回包")
        release_print(os.date("%c") .. "[info] 信阳牌桌收到有人杠牌的通知，操作玩家本地位置，下发的牌值 ", cur_view_id, player_operaction.opValue, player_operaction.useXiaoNum or 0)
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
		local card_data = {mcard={card[1],card[2],card[3]},ocard=card[4]}

		if bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_AN_GANG) == RoomConfig.MAHJONG_OPERTAION_AN_GANG then
			release_print(os.date("%c") .. "[info] 信阳牌桌暗杠 ", card[4])
			--card_data = {mcard={RoomConfig.EmptyCard,RoomConfig.EmptyCard,RoomConfig.EmptyCard,RoomConfig.EmptyCard},kanpai={}}
			--if cur_seat_id == self.m_seat_id then --我自己可以看见第二张牌
				card_data = {mcard= {RoomConfig.EmptyCard,RoomConfig.EmptyCard,RoomConfig.EmptyCard,card[4]},kanpai={},shuaipai={}}
			--end
		elseif bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_BU_GANG) == RoomConfig.MAHJONG_OPERTAION_BU_GANG then
			release_print(os.date("%c") .. "[info] 信阳牌桌补杠 ", card[1])
			card_data = {mcard={card[1]},kanpai={},shuaipai={}} --补杠只有一张牌
        elseif bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_MING_GANG) == RoomConfig.MAHJONG_OPERTAION_MING_GANG then
            release_print(os.date("%c") .. "[info] 信阳牌桌明杠 ", c1)
            card_data = {mcard={c1,c2,c3},ocard=c4,kanpai={},shuaipai={}}
        end

        local moCardNum = #(card_data.mcard)
		for i=1,player_operaction.useXiaoNum or 0 do
			if bit._and(self.playwaytype, 0x40400) ~= 0x40400 then --0x40400 信阳甩张玩法
				card_data.kanpai[i] = card_data.mcard[moCardNum+1-i]
			else
				card_data.shuaipai[i] = card_data.mcard[moCardNum+1-i]
			end
			card_data.mcard[moCardNum+1-i]=nil
		end
		
		print("player_operaction.useXiaoNum==="..player_operaction.useXiaoNum)
		dump(card_data.kanpai)

		local playerkanpainum = player_operaction.playerKanPaiNums[cur_seat_id+1] or 0
		card_part:optCard(cur_view_id,player_operaction.operation,card_data,nil,playerkanpainum)

		if cur_seat_id == self.m_seat_id then
			card_part:resetShuaiPaiScript(xy_operaction_extend.playerShuaiPaiCards)
		end

	elseif bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_PENG) == RoomConfig.MAHJONG_OPERTAION_PENG then --碰
		print("###[XYTablePart:playerOperation] 点碰操作回包")
		release_print(os.date("%c") .. "[info] 信阳牌桌收到有人碰牌的通知，操作玩家本地位置，下发的牌值 ", cur_view_id, player_operaction.opValue, player_operaction.useXiaoNum or 0)

		local opvalue = player_operaction.opValue
		local c1 = bit._and(opvalue,0xff)
		local c2 = bit._and(bit.rshift(opvalue,8),0xff)
		local c3 = bit._and(bit.rshift(opvalue,16),0xff)
		print("this is  peng:",c1,c2,c3)
		local cur_seat_id = player_operaction.player_table_pos
		local cur_view_id = self:changeSeatToView(cur_seat_id)
		local card_data = {mcard={c1,c2},ocard=c3,kanpai={},shuaipai={}}

		for i=1,player_operaction.useXiaoNum or 0 do
			if bit._and(self.playwaytype, 0x40400) ~= 0x40400 then --0x40400 信阳甩张玩法
				card_data.kanpai[i] = card_data.mcard[3-i]
			else
				card_data.shuaipai[i] = card_data.mcard[3-i]
			end
			card_data.mcard[3-i]=nil
		end

		local playerkanpainum = player_operaction.playerKanPaiNums[cur_seat_id+1] or 0
		card_part:optCard(cur_view_id,RoomConfig.MAHJONG_OPERTAION_PENG,card_data,nil,playerkanpainum)

		if cur_seat_id == self.m_seat_id then
			card_part:resetShuaiPaiScript(xy_operaction_extend.playerShuaiPaiCards)
		end
	end	
end

function XYTablePart:ntfOperationHandleXY(data,appId)
	local ntf_operation = PlayerOperationNotifyMsg_pb.PlayerOperationNotifyMsg()
	ntf_operation:ParseFromString(data)
	print(string.format("###[XYTablePart:ntfOperationHandleXY]  0x%02x", ntf_operation.operation))

	local ready_part = self:getPart("ReadyPart")
	local naozhuang_part = self:getPart("NaozhuangPart")
	if ntf_operation.operation == RoomConfig.MAHJONG_OPERTAION_WAITING_TONG_NAO then
		release_print(os.date("%c") .. "[info] 信阳牌桌收到等待通闹的通知")
		naozhuang_part:activate()
		naozhuang_part:onNotifyWaitTongnao()
	elseif ntf_operation.operation == RoomConfig.MAHJONG_OPERTAION_WAITING_NAO_ZHUANG then
		release_print(os.date("%c") .. "[info] 信阳牌桌收到等待闹庄的通知")
		naozhuang_part:activate()
		naozhuang_part:onNotifyWaitNaozhuang()
	else
		self:ntfOperationHandle(ntf_operation, appId)
	end
end

function XYTablePart:onKanpaiMenuShow()
	self.view:startCountTime(5)
end

function XYTablePart:gameStartNtf(data,appId)
	release_print(os.date("%c") .. "[info] 信阳牌桌收到开局通知")
	-- local game_start = game_start_message_pb.GameStartMsg()
	local game_start = xymj_message_pb.GameStartMsg()
	game_start:ParseFromString(data)
	self.playerwin = game_start.playerwin
	print("XYTablePart:gameStartNtf=",game_start)
	local ready_part = self:getPart("ReadyPart")
	ready_part:hideView()

	-- for i=1,4 do
	-- 	local view_id = self:changeSeatToView(i-1)

	-- 	if game_start.playerisnaozhuang and game_start.playerisnaozhuang[i] and (game_start.playerisnaozhuang[i] == 1) then
	-- 		if (i - 1) == game_start.dealerpos then
	-- 			self:onNotifySelectTongnao(view_id)
	-- 		else
	-- 			self:onNotifySelectNaozhuan(view_id)
	-- 		end
	-- 	end
	-- end
	
	self.dealerpos = game_start.dealerpos
	self:startGame(game_start)
end

function XYTablePart:startGame(data)
	-- body
	local roomMenuPart = self:getPart("RoomMenuPart") 
	if roomMenuPart then
		roomMenuPart:activate() 
    	roomMenuPart:hideDissolveBtn(self.tableid > 1)
	end

	local chat_part = self:getPart("ChatPart")
    if chat_part then
    	local pos_table = self.view:getPosTable()
    	local voiceRoomID = tostring(self.game_id) .. "_" .. tostring(self.tableid)
    	if self.in_voice_room then
    		voiceRoomID = ""
        else
            print("to join voice room, ,voice room id : ", voiceRoomID, self.tableid)
            if self.tableid <= 1 then
            	voiceRoomID = ""
            end
            chat_part:activate(self.game_id,pos_table,voiceRoomID)
            chat_part:hideSzBtn()
            self.in_voice_room = true
    	end
    end
    local teamVoicePart = self:getPart("TeamVoicePart")
    if  teamVoicePart and self.tableid > 0 then
    	teamVoicePart:setOriginPos()
    end
	local card_part = self:getPart("CardPart")
	card_part:deactivate()
	card_part.majorViewId = self:changeSeatToView(data.dealerpos) -- @Deek 保存庄家座位号
    card_part:activate(self.game_id,data)

       --设置方位
    self.view:setBearingByBanker(card_part.majorViewId)

    if not self.wifi_and_net then
	    local wifi_and_net = self:getPart("WifiAndNetPart")
	    if wifi_and_net then
	    	wifi_and_net:activate(self.game_id,self.view.node.wifi_and_net)
	    	self.wifi_and_net = wifi_and_net
	    end
    end

    release_print(os.date("%c") .. "[info] 信阳牌桌开局")

    if self.tableid > 1 then ----显示当前局数和总局数  1/4局
    	local quanTotal = bit._and(data.serviceGold,0xff)
    	release_print(os.date("%c") .. "[info] 信阳牌桌，当前圈数，总圈数 ", data.quannum,quanTotal)
    	self.view:dispalyQuan(data.quannum,quanTotal)
    	self.cur_hand = data.quannum --当前局数
    	self.total_hand =quanTotal --总局数
    end

	self.last_card_num = 0
	self.m_seat_id = data.mtablePos
	self.view:initTableWithData(self.player_list,data)
	card_part:initTableWithData(self.player_list,data)
end

function XYTablePart:playerOperationHandle(data,appId)
	release_print(os.date("%c") .. "[info] XYTablePart:playerOperationHandle ", debug.traceback())
	local player_operaction = ycmj_message_pb.PlayerTableOperationMsg()
	player_operaction:ParseFromString(data)
    print("TablePart:playerOperation:",player_operaction,bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_BU_GANG))
	self:playerOperation(player_operaction, appId)
end

function XYTablePart:onNotifySelectNaozhuan(viewId)
	print("XYTablePart:onNotifySelectNaozhuan")
	--self.view:showNaozhuangIcon(viewId)
	local card_part = self:getPart("CardPart")
	if card_part then
		card_part:showNaozhuangIcon(viewId)
	end
end

function XYTablePart:onNotifySelectTongnao(viewId)
	print("XYTablePart:onNotifySelectTongnao")
	--self.view:showTongnaoIcon(viewId)
	local card_part = self:getPart("CardPart")
	if card_part then
		card_part:showTongnaoIcon(viewId)
	end
end

-- 服务器通知轮到自己出牌
function XYTablePart:operationChu(data)
	release_print(os.date("%c") .. "[info] 信阳牌桌服务器通知轮到自己出牌 ", data.operation)
	local card_part = self:getPart("CardPart")
	if data.chicardvalue ~= 0 then --是否摸了新牌，如果是断线回来，这个通知里面没有新牌
		card_part:getCard(data.chicardvalue)
	end

	local opt_type = nil
	local card_value = {}
	--如果玩家听牌
	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_HU) == RoomConfig.MAHJONG_OPERTAION_HU then
		release_print(os.date("%c") .. "[info] 信阳牌桌服务器通知可以胡")
		opt_type = RoomConfig.MAHJONG_OPERTAION_HU
		card_value.mcard = {}
		card_part:addOpt(RoomConfig.MAHJONG_OPERTAION_HU)
	end

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_AN_GANG) == RoomConfig.MAHJONG_OPERTAION_AN_GANG then
		release_print(os.date("%c") .. "[info] 信阳牌桌服务器通知可以暗杠")
		opt_type = RoomConfig.MAHJONG_OPERTAION_AN_GANG
		card_value.mcard = {data.pengcardvalue,data.pengcardvalue,data.pengcardvalue,data.pengcardvalue}
		card_part:addOpt(RoomConfig.Gang)
	end

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_BU_GANG) == RoomConfig.MAHJONG_OPERTAION_BU_GANG then
		release_print(os.date("%c") .. "[info] 信阳牌桌服务器通知可以补杠")
		opt_type = RoomConfig.MAHJONG_OPERTAION_BU_GANG
		card_value.mcard = {data.pengcardvalue}
		card_part:addOpt(RoomConfig.Gang)
	end

	print("data.operation-------------:",data.operation)
	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_TING) == RoomConfig.MAHJONG_OPERTAION_TING then --听牌提示
		print("RoomConfig.MAHJONG_OPERTAION_TING")
		print("RoomConfig.tingRecords",data)
		print("下发哪些牌打出可以听牌")
		-- repeated uint32 tinglist=9
		print("tinglist:",data.tinglist)
		if card_part then
	    	card_part:drawingHandCardTip(data)
		end
	end

	if opt_type then
		card_part:showAddOpt(data,true,self.last_card_num) --自己摸牌不显示过
	end
end




function XYTablePart:operationCard(data)
	-- body
	local card_part = self:getPart("CardPart")
	local dis_play_guo = true --是否显示过牌
	print("This is YNTablePart operationCard:",bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_PENG),bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_AN_GANG),bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_MING_GANG))

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_CHU) == RoomConfig.MAHJONG_OPERTAION_CHU  then
		if data.chicardvalue ~= 0 then
			release_print(os.date("%c") .. "[info] 信阳牌桌oc，服务器通知摸了一张牌 ", data.chicardvalue)
			card_part:getCard(data.chicardvalue)
		end
	end

	-- if bit._and(data.operation,RoomConfig.Gang) == RoomConfig.Gang and bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_HU) ~= RoomConfig.MAHJONG_OPERTAION_HU then
 --  		local card_data = data.gangList
 --  		print("This is YNTablePart operationCard:",data.operation,RoomConfig.MAHJONG_OPERTAION_CHU,bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_CHU))
 --  		if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_CHU) == RoomConfig.MAHJONG_OPERTAION_CHU  then
 --  			dis_play_guo = false --自己出牌不显示过  
 --   		else
 --  			card_part:addOpt(RoomConfig.Gang)		
 --  		end
 --  		card_part:ntfGangList(card_data)
 --  	elseif bit._and(data.operation,RoomConfig.Gang) == RoomConfig.Gang then
	-- 	local card_data = data.gangList
	-- 	card_part:addOpt(RoomConfig.Gang)
	-- 	card_part:ntfGangList(card_data)	
	-- end
	
	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_TING) == RoomConfig.MAHJONG_OPERTAION_TING then --听牌
  		local card_part = self:getPart("CardPart")
   		print("operationCard--下发哪些牌打出可以听牌")   
   		print("operationCard--tinglist:",data)
  		if card_part then
   			card_part:drawingHandCardTip(data)
  		end
 	end


	if bit._and(data.operation,RoomConfig.Gang) == RoomConfig.Gang  then
  		print("###[XYTablePart:operationCard] RoomConfig.Gang")
  		release_print(os.date("%c") .. "[info] 信阳牌桌oc，服务器通知可以杠")
  		local card_data = data.gangList
  		card_part:ntfGangList(card_data)
  		card_part:addOpt(RoomConfig.Gang) 
	end

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_PENG) == RoomConfig.MAHJONG_OPERTAION_PENG then
		release_print(os.date("%c") .. "[info] 信阳牌桌oc，服务器通知可以碰")
		local c1 = bit._and(data.pengcardvalue,0xff)
		local c2 = bit._and(bit.rshift(data.pengcardvalue,8),0xff)
		local cur_seat_id = data.playertablepos
		local cur_view_id = self:changeSeatToView(cur_seat_id)
		local card_data = {mcard={c1,c2},ocard=c1}
		-- card_part:ntfOpt(RoomConfig.Peng,card_data,data.pengcardvalue)
		card_part:addOpt(RoomConfig.MAHJONG_OPERTAION_PENG)
	end

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_CHI) == RoomConfig.MAHJONG_OPERTAION_CHI then
		release_print(os.date("%c") .. "[info] 信阳牌桌oc，服务器通知可以吃")
		card_part:setChiList(data.chicardvalue,data.targetcard)
		card_part:addOpt(RoomConfig.MAHJONG_OPERTAION_CHI)
	end

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_HU) == RoomConfig.MAHJONG_OPERTAION_HU then
		release_print(os.date("%c") .. "[info] 信阳牌桌oc，服务器通知可以胡")
		card_part:addOpt(RoomConfig.MAHJONG_OPERTAION_HU)
	end

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_POP_LAST) == RoomConfig.MAHJONG_OPERTAION_POP_LAST then
		--显示2张 可点击的尾牌
		release_print(os.date("%c") .. "[info] 信阳牌桌oc，服务器通知选择尾牌")
		local cur_seat_id = data.playertablepos
		local cur_view_id = self:changeSeatToView(cur_seat_id)
		local card_data = {mcard={},ocard=data.targetcard}
		card_part:ntfOpt(RoomConfig.MAHJONG_OPERTAION_POP_LAST,card_data,data.targetcard)
		return
	end

	card_part:showAddOpt(data,dis_play_guo,self.last_card_num)
end

function XYTablePart:isNaozhuangIconShow()
	return self.view:isNaozhuangIconShow()
end

-- function XYTablePart:settingsClick()
-- 	-- body
-- 	local settings_part = self:getPart("RoomSettingPart")
-- 	if settings_part then
-- 		settings_part:activate(self.tableid)
-- 	end
-- end


local function isCostConfigId(id)
	return 7001 == id
		or 7002 == id
		or 7003 == id
		or 7004 == id
end

XYTablePart.TIMAES1 = 4 --4局
XYTablePart.TIMAES2 = 6 --6局

function XYTablePart:calcDiamondCost()
	-- body
	--信阳只有4 ，六局
	--type ==4--- 1 
	--type ==6--- 2

	local tbGameNum = {4,6}
	local function getIndex(tp)
		local index = 1
		for i,v in ipairs(tbGameNum) do
			if v == tp then
				index = i
				break
			end
		end
		return index
	end
	local types = getIndex(self.total_hand)
	print("XYTableParttypes:"..types)
	local quanCount = XYTablePart["TIMAES"..types]
	print("XYTablePart:calcDiamondCost",quanCount)
	--通过圈数 循环遍历服务器的数据，如果相等，则得到对应的消费 钻石个数
	local costDiamond = 1
	local user = global:getGameUser()
    local props = user:getProps()
    local gameConfigList = props["gameplayer" .. self.game_id].gameConfigList

    for i,v in ipairs(gameConfigList) do
		local gameParam = gameConfigList[i]
		print("gameParam.paraId,gameParam.valueInt,gameParam.pro1->",gameParam.paraId,gameParam.valueInt,gameParam.pro1)
		if isCostConfigId(gameParam.paraId) then
			if quanCount == gameParam.valueInt then
				costDiamond = (gameParam.pro1 and gameParam.pro1 or 0)
				break
			end
			print("gameParam.paraId:"..gameParam.paraId)
			print("gameParam.valueInt:"..gameParam.valueInt)
		end
	end

	if costDiamond == 1 and types == 4 then
		print("###[XYTablePart:calcDiamondCost] costDiamond == 1 and type == 4 ")
		costDiamond = 16
	end
	print("###[XYTablePart:calcDiamondCost] costDiamond is ", costDiamond)
	return costDiamond
end

function XYTablePart:initPlayWay()
	local tableInfo = self.tableinfo
	self._playWayGameNumInfo= nil  --玩法局数信息
	self._playWayStr = nil         --对应的玩法
	self._playWaySelectStr = {}    --可选择的玩法

	local diamondNum = self:calcDiamondCost()
	self.payType = tableInfo.payType
	if tableInfo.payType ~=0 then --AA支付
		diamondNum = diamondNum/4
	end
	local totalHand = self.total_hand..string_table.playway_ju..string_table.playway_zuan_shi..diamondNum..")"
	self._playWayGameNumInfo = totalHand
	local playWay = tableInfo.playwaytype

	print("payType:"..self.payType)
	if bit._and(playWay, 0x10000) == 0x10000 then --信阳麻将
		self._playWayStr = string_table.playway_type_xymj
		if bit._and(playWay, 0x40) == 0x40 then	--五大嘴，八共醉
			table.insert(self._playWaySelectStr,string_table.xymj_playway1)
			table.insert(self._playWaySelectStr,string_table.xymj_playway2)
		elseif bit._and(playWay, 0x80) == 0x80 then --满堂跑
			table.insert(self._playWaySelectStr,string_table.playway_type_mtp)
		end

		if bit._and(playWay, 0x400) == 0x400 then	
			table.insert(self._playWaySelectStr,string_table.bdy_playway3) --点炮输一家
		elseif bit._and(playWay, 0x1000) == 0x1000 then
			table.insert(self._playWaySelectStr,string_table.bdy_playway1) --自摸胡
		else
			table.insert(self._playWaySelectStr,string_table.bdy_playway2) ---点炮输三家
		end

		if bit._and(playWay, 0x20) == 0x20 then	--有风
			table.insert(self._playWaySelectStr,string_table.playway_type_yf)
		else
			table.insert(self._playWaySelectStr,string_table.playway_type_wf)
		end
		if bit._and(playWay, 0x100) == 0x100 then --有坎牌
			table.insert(self._playWaySelectStr,string_table.playway_type_ykp)
		else
			table.insert(self._playWaySelectStr,string_table.playway_type_wkp)
		end
		if bit._and(playWay, 0x200) == 0x200 then --有闹庄
			table.insert(self._playWaySelectStr,string_table.playway_type_ynz)
		else
			table.insert(self._playWaySelectStr,string_table.playway_type_wnz)
		end
	elseif bit._and(playWay, 0x20000) == 0x20000 then --扳倒赢
		self._playWayStr = string_table.playway_type_bdy
		if bit._and(playWay, 0x20) == 0x20 then
			table.insert(self._playWaySelectStr, string_table.bdy_playway1)
		elseif bit._and(playWay, 0x80) == 0x80 then
			table.insert(self._playWaySelectStr, string_table.bdy_playway3)
		else
			table.insert(self._playWaySelectStr, string_table.bdy_playway2)
		end

		if bit._and(playWay, 0x40) == 0x40 then
			table.insert(self._playWaySelectStr,string_table.bdy_playway5) --无风
		else
			table.insert(self._playWaySelectStr,string_table.bdy_playway4) --乱三风
		end
		if bit._and(playWay, 0x200) == 0x200 then
			table.insert(self._playWaySelectStr,string_table.bdy_playway6) --跑子
		else
			table.insert(self._playWaySelectStr,string_table.bdy_playway7) --无跑子
		end
	elseif bit._and(playWay, 0x40000) == 0x40000 then --罗山玩法
		self._playWayStr = string_table.playway_type_ls
		if bit._and(playWay, 0x20) == 0x20 then
			table.insert(self._playWaySelectStr, string_table.ls_playway1) --活嘴
		elseif bit._and(playWay, 0x40) == 0x40 then
			table.insert(self._playWaySelectStr, string_table.ls_playway2) --死嘴
		else
			table.insert(self._playWaySelectStr, string_table.ls_playway3) --坎金
		end				
	elseif bit._and(playWay, 0x80000) == 0x80000 then --罗山13579玩法
		self._playWayStr = string_table.playway_type_ls13579
		if bit._and(playWay, 0x20) == 0x20 then
			table.insert(self._playWaySelectStr, string_table.ls13579_playway2) --8套
		elseif bit._and(playWay, 0x40) == 0x40 then
			table.insert(self._playWaySelectStr, string_table.ls13579_playway3) --10套
		else
			table.insert(self._playWaySelectStr, string_table.ls13579_playway1) --5套
		end

		if bit._and(playWay, 0x200) == 0x200 then
			table.insert(self._playWaySelectStr, string_table.ls13579_playway4) -- 独赢
		else
			table.insert(self._playWaySelectStr, string_table.ls13579_playway5) -- 无独赢
		end
	end
	print("playWayStr:"..self._playWayStr)
	print("playWaySelectStr:")
	dump(self._playWaySelectStr)
end

function XYTablePart:openPlayWay()
	-- self._playWayGameNumInfo= nil  --玩法局数信息
	-- self._playWayStr = nil         --对应的玩法
	-- self._playWaySelectStr = {}    --可选择的玩法
	self:initPlayWay()
	local playInfo = {}
	playInfo.playWayGameNumInfo = self._playWayGameNumInfo
	playInfo.playWayStr = self._playWayStr
	playInfo.playWaySelectStr = self._playWaySelectStr

	print("XYTablePartopenPlayWay")
	local playWayPart = self:getPart("PlayWayPart")
	if playWayPart then
		print("playWayPartActive")
		playWayPart:activate(playInfo)
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
	self.dealerpos = self.dealerpos or 0

	local hasPaozi = false
	for i=1, 4 do
		local val = self.xiazuiVal[i] or 0
		if bit._and(val, 0x1000) == 0x1000 then
			hasPaozi = true
			break
		end
	end

	print(" self.dealerpos, curSeatId, self.m_seat_id ", self.dealerpos, curSeatId, self.m_seat_id, hasPaozi)
	print(" (self.dealerpos - self.m_seat_id), (curSeatId - 1) ", (self.dealerpos - self.m_seat_id), (curSeatId - 1))
	print(" (self.dealerpos - self.m_seat_id + 4), (curSeatId - 1) ", (self.dealerpos - self.m_seat_id + 4), (curSeatId - 1))
	if hasPaozi and (((self.dealerpos - self.m_seat_id) == (curSeatId - 1)) or ((self.dealerpos - self.m_seat_id + 4) == (curSeatId - 1))) then
		desc = desc .. string_table.bdy_paozi
	end

	print(" xiazuiVal, curSeatId, desc ", xiazuiVal, curSeatId, desc)
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

	print(" desc ", desc)
	return desc
end

function XYTablePart:gameOverAck(data,appId)
	local game_over_ack = player_game_over_ack_pb.PlayerGameOverAck()
	game_over_ack:ParseFromString(data) 
	print("TablePart:gameOverAck:",game_over_ack)
	self:gameEnd(game_over_ack)
end

function XYTablePart:getPlaywayType()
	return self.playwaytype
end

return XYTablePart
