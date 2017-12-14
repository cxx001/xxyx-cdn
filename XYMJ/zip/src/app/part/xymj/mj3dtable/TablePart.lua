--[[
*名称:TableLayer
*描述:牌桌界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期: 2017.3.17
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local TablePart = class("TablePart",cc.load('mvc').PartBase) --登录模块
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".PlayerOperationNotifyMsg_pb")
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".PlayerTableOperationMsg_pb")
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".ycmj_message_vipend_pb")
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".StartGameMsgAck_pb")
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".ReqStartGame_pb")
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".game_start_message_pb")
TablePart.DEFAULT_PART = {
	'ReadyPart',
	'CardPart',
	"ChatPart",
	"WifiAndNetPart",
	"PreparePart",
	"RoomMenuPart", -- 菜单组件
	'RecordStopPart',
	'GameEndPart',
	"TipsPart",
	"SmallUserInfoPart",
	"VipOverPart",
	--'BroadcastPart',--加入小喇叭节点
	"DissolvePart",
	"SettingsPart",--设置组件（牌局内）
	"GpsPart",
	"GpsTipPart",
	"NtfUploadLogPart",
}
TablePart.DEFAULT_VIEW = "TableScene"
TablePart.CMD = {
	MSG_GAME_LOGIN_ACK = 0xc30023, --子游戏登录返回
	ACK_LOGIN = 0xf00002, --大厅登录返回
	MSG_GAME_LOGIN = 0xc30001,
	MSG_GAME_LOGIN_ACK = 0xc30023, --登录返回
	MSG_REQUEST_START_GAME     = 0xc30003,
    MSG_REQUEST_START_GAME_ACK = 0xc30004,
    CREATE_RED_PACKET_RSP_CMD = 0X01020001,--下发红包
    MATCH_BATTLE_BEGIN_MSG 	 = 0x01010027,
    MAHJONG_OPERTAION_CONFIRM = 0x20040000, --取消胡确认
}
--[
-- @brief 构造函数
--]
function TablePart:ctor(owner)
    TablePart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function TablePart:initialize()

end

--断线重连机制
function TablePart:registerLoginCMD()
	-- body
	local netManager = global:getModuleWithId(ModuleDef.NET_MOD)
    netManager:registerMsgListener(TablePart.CMD.MSG_GAME_LOGIN_ACK,handler(self,TablePart.onLoginAck))
    netManager:registerMsgListener(TablePart.CMD.ACK_LOGIN,handler(self,TablePart.onLobbyLoginAck))
    netManager:registerMsgListener(TablePart.CMD.MSG_REQUEST_START_GAME_ACK,handler(self,TablePart.onReconnectAck))
    netManager:registerMsgListener(TablePart.CMD.MATCH_BATTLE_BEGIN_MSG, handler(self, TablePart.MatchNotify))
end

function TablePart:unRegisterLoginCMD()
	-- body
	local netManager = global:getModuleWithId(ModuleDef.NET_MOD)
    netManager:unRegisterMsgListener(TablePart.CMD.MSG_GAME_LOGIN_ACK)
    netManager:unRegisterMsgListener(TablePart.CMD.ACK_LOGIN)
    netManager:unRegisterMsgListener(TablePart.CMD.MSG_REQUEST_START_GAME_ACK)
    netManager:unRegisterMsgListener(TablePart.CMD.MATCH_BATTLE_BEGIN_MSG)
end

function TablePart:onLobbyLoginAck(data,gameId)
	-- body
	local login_ack = login_pb.LoginResp()
	login_ack:ParseFromString(data)
	print("TablePart--LoginPart:onLobbyLoginAck--登录返回数据=", login_ack)

	if login_ack.result == CommonSocketConfig.SUCESS then
		if login_ack.userToken then
			local user_default = cc.UserDefault:getInstance()
			user_default:setStringForKey(enUserData.ASSETS_TOKEN,login_ack.userToken)
			user_default:flush()
		end 
		local user = global:getGameUser()
		user:setProp("name",login_ack.nickname)
		user:setProp("photo",login_ack.headImg)
		user:setProp("uid",login_ack.userId)
		user:setProp("sex",login_ack.sex)

		if login_ack.playerInfo and login_ack.playerInfo.gameId then
			self.reconnect_flag = login_ack.playerInfo.gameId
		end

		if tonumber(self.reconnect_flag) == tonumber(self.game_id) then
			self:requestGameLogin()
		else --断线重连的子游戏不是当前子游戏切换到登录界面
			self:returnLogin()
		end
	else --断线重连登录不成功切换到登录界面
		self:returnLogin()
	end
end

--返回登录界面
function TablePart:returnLogin()
	-- body
	local user = global:getGameUser()
	self:deactivate()
	local login_part = global:createPart("LoginPart",user)
    user:addPart(login_part)
    login_part:activate(LOBBY_GAME_ID)
    login_part:showLogin()
end

--请求子游戏登录
function TablePart:requestGameLogin()
	-- body
	self:startLoading()
	local login_msg = wllobby_message_pb.LoginMsg()
	login_msg.machineCode = DEVICE_INFO.imei or ""
	local net_manager = global:getModuleWithId(ModuleDef.NET_MOD)
	local buff_str = login_msg:SerializeToString()
	local buff_lenth = login_msg:ByteSize()
    net_manager:sendMsg(buff_str,buff_lenth,TablePart.CMD.MSG_GAME_LOGIN,self.game_id)
end

--子游戏登录返回
function TablePart:onLoginAck(data,gameId)
	-- body
	local login_ack = login_pb.LoginResp()
	login_ack:ParseFromString(data)
    self:reconnectRequest() --重连后制空重连标记
end

--重连请求
function TablePart:reconnectRequest()
	-- body
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local req_enter_room = ReqStartGame_pb.ReqStartGame()
	req_enter_room.roomid = 2002
	req_enter_room.gametype = 1
	req_enter_room.psw = "1" --信阳罗山玩法用于做兼容性的临时方案
	net_mode:sendProtoMsg(req_enter_room,TablePart.CMD.MSG_REQUEST_START_GAME,self.game_id)
end

--重连请求返回
function TablePart:onReconnectAck(data,gameId)
	-- body
	self:endLoading()
	local enter_room_ack = StartGameMsgAck_pb.StartGameMsgAck()
	enter_room_ack:ParseFromString(data)
	print(enter_room_ack)


	local function revertMJRoom()
		self:deactivate()
		self:activate(self.game_id,enter_room_ack, nil, true)
		if self.match_mode then
			self:activateDefualtPart(enter_room_ack)
			self.view:updateTableShow(enter_room_ack.tableinfo)
		end
	end

	--@ 在vip房间
	local cpt_ack 	= enter_room_ack.tableinfo.Extensions[competition_pb.StartGameMsgAckExt.cptExt]
	if not cpt_ack then
		-- if self.match_mode then
		-- 	self.cpt_info.state = 4
		-- end
		revertMJRoom()
		return 
	end

	--@ 在赛事中
	local player_position	= cpt_ack.player_position
	if player_position == 2 then
		local query_ack = cpt_ack.cptInfo
		local state  	= query_ack.state
		if state == 4 then
			--@ 在赛事中, 正在打牌
			revertMJRoom()
		else
			--@ 正在准备区
			self:revertMatch(enter_room_ack)
		end
		return 
	end

	if enter_room_ack.result == 0 then --进入房间
		-- if self.match_mode then
		-- 	self.cpt_info.state = 4
		-- end		
		revertMJRoom()
	else --没有重连进房间需要切换到子游戏大厅
		self:returnLobby()
	end
end


--[[
1：对家手牌居中
2： 金币场放在左上角
3：结算界面一致
4：我的资料框干掉
5：碰杠特效合入
6: 大结算房主标识更加明显
==合入
恩施3期优化：
1:玩家头像为正方形
2:对家层级的调整
2：添加浮标特效和头像光环特效
3：特效位置的调整
--]]

--激活模块
function TablePart:activate(gameId,data)
	-- gameId = 262401 --临时调试用
	self.game_id = gameId

	local config = {
    width = 1280,
    height = 720,
    autoscale = "FIXED_WIDTH",
    callback = function(framesize)

        local ratio = framesize.width / framesize.height
        if ratio > 1.7 then
            return {autoscale = "SHOW_ALL"}
        end
    end
	}
	display.setAutoScale(config)


	--进入游戏场不需要延时断线
	if IOS_BACK_DELAY == true then
		IOS_BACK_DELAY = false
		local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
		if lua_bridge.setBackDelayTime then
			lua_bridge:setBackDelayTime(10)
		end
	end
	----------------------------------------------------------------------
	local partId = self:getPartId()
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD) 
	net_mode:registerMsgListener(SocketConfig.MSG_GAME_START,handler(self,TablePart.gameStartNtf)) --牌局开始
	net_mode:registerMsgListener(SocketConfig.MSG_GAME_VIP_ROOM_CLOSE,handler(self,TablePart.closeVipRoomAck))  --解散房间通知,展示解散房间页面
	net_mode:registerMsgListener(SocketConfig.MSG_GAME_OPERATION_ACK ,handler(self,TablePart.gameOperationAck)) --添加、移除用户 关闭房间的服务器返回
	net_mode:registerMsgListener(SocketConfig.MSG_GAME_UPDATE_PLAYER_PROPERTY,handler(self,TablePart.updatePlayerProperty)) --更新玩家信息 没有操作
	net_mode:registerMsgListener(SocketConfig.MSG_PLAYER_OPERATION_NTF,handler(self,TablePart.ntfOperationAck)) --提醒玩家进行操作
	net_mode:registerMsgListener(SocketConfig.MSG_PLAYER_OPERATION,handler(self,TablePart.playerOperationAck))
	net_mode:registerMsgListener(SocketConfig.MSG_GAME_OVER_ACK,handler(self,TablePart.gameOverAck))
	net_mode:registerMsgListener(SocketConfig.MSG_GAME_OTHERLOGIN_ACK,handler(self,TablePart.otherLogin))
	net_mode:registerMsgListener(SocketConfig.MSG_GAME_SEND_SCROLL_MES,handler(self,TablePart.scrollMsgAck),partId)
	net_mode:registerMsgListener(SocketConfig.MSG_CLOSE_VIP_TABLE_ACK,handler(self,TablePart.closeVipTableAck))
	net_mode:registerMsgListener(SocketConfig.MSG_NOTIFY_SEQ_TO_CLIENT_MSG ,handler(self,TablePart.notifySeqToClienTMsg))
	self:registerLoginCMD()

	TablePart.super.activate(self, CURRENT_MODULE_NAME)
	global:setCurrentPart(self)

	if not self.match_mode then
		self:activateDefualtPart(data)
	else
		self:activateMatchPart(data)		
	end
end

function TablePart:activateDefualtPart(data)
	self.room_id = data.tableinfo.roomid
	self.roomCreator_id = data.tableinfo.creatorid
	self.roomCreator_name = data.tableinfo.craetorname

	--@初始化回放记录
	self:initRecord(data)

	-- local wifi_and_net = self:getPart("WifiAndNetPart")
 --    if wifi_and_net then
 --    	wifi_and_net:activate(self.game_id,self.view.node.wifi_net_node)
 --    end

    -- local broadcast_node = self:getPart("BroadcastPart")
    -- if broadcast_node then
    -- 	broadcast_node:activate(self.view.node.broadcast_node)
    -- 	broadcast_node:isShowBroadcastNode(false)
    -- end

    local dissolve_part = self:getPart("DissolvePart")
	if dissolve_part then
		dissolve_part:activate(self.game_id)
	end
    
    self.m_seat_id = data.tableinfo.tablepos
    self.tableid = data.tableinfo.viptableid --判断是不是vip场

    --显示房号
    self.view:setRoomID(data)
    
    local ready_part = self:getPart("ReadyPart")
    if ready_part and not self.record_mode and not self.match_mode then
    	ready_part:activate(self.game_id, data, self.m_seat_id)
    end
    
    local gps_part = self:getPart("GpsPart")
    if gps_part and not self.record_mode and not self.match_mode then
	    gps_part:activate(self.game_id, self.m_seat_id,self.tableid)
    end

    local gpsTip_part = self:getPart("GpsTipPart")
    if gpsTip_part and not self.record_mode and not self.match_mode then
	    gpsTip_part:activate()
    end

    local stop_part = self:getPart('RecordStopPart')
	if stop_part and self.record_mode and not self.match_mode then
		stop_part:activate()
	end

    self.player_list = {}
    local user = global:getGameUser()
   	local game_player = user:getProp("gameplayer"..self.game_id)
	self.playerIndex = game_player.playerIndex

    --整理玩家信息
	for k,v in ipairs(data.tableinfo.players) do
		self.player_list[k] = self:decodePlayer(v)

		if v.tablepos then
			self.player_list[k].view_id = self:changeSeatToView(v.tablepos)
		end

		if tonumber(v.playerIndex) == tonumber(self.playerIndex) then
			self.uid = v.uid
		end

		if v.intable == 0 then --离线
			self:offlinePlayer(self.player_list[k].view_id,false)
		end
	end

	print("self.player_list==========:"..#data.tableinfo.players)
	dump(self.player_list)

    self.createid = data.tableinfo.creatorid
    self.createName = data.tableinfo.craetorname
    self.tableid = data.tableinfo.viptableid --判断是不是vip场
    self.cur_hand = data.tableinfo.currenthand --当前局数
    self.total_hand = data.tableinfo.totalhand --总局数
	print("------------self.tableid : ",self.tableid,self.cur_hand)
	
	--是否显示解散房间按钮
    if self.tableid > 1 then
    	self.view:isShowCloseBtn(true)
    	self.view:showGoldOrVipText(true,self.tableid)  
    else 
    	self.view:isShowCloseBtn(false)
    	self.view:showGoldOrVipText(false) 
    end

	--self.wifi_and_net = nil 
	--[[ TODO: 准备功能, 需要服务器
	if(self.tableid ~= 0) then
	    local prepare_part = self:getPart("PreparePart")
	    if prepare_part then
		    prepare_part:activate(self.m_seat_id,self.tableid)
	    end
	end]]	

	local teamVoicePart = self:getPart("TeamVoicePart")
    if teamVoicePart and self.tableid > 0 then --金币场没有语音
     	local voiceRoomID = ""
  		if self.roomCreator_id and self.roomCreator_id ~= "" then
      		voiceRoomID = tostring(self.game_id) .. "_" .. self.roomCreator_id .. self.room_id
     	end
  			teamVoicePart:activate(self.game_id)
        if self.teamVoicePart == nil then
            teamVoicePart:enterVoiceRoom(voiceRoomID)
        end
        teamVoicePart:setReadyPos()
  		self.teamVoicePart = teamVoicePart
    end

	local ntfUploadLogPart = self:getPart("NtfUploadLogPart")
    ntfUploadLogPart:activate(self.game_id)
end

function TablePart:initRecord(data) 
	if not data.record_mode then
		return 
	end

	-- @ 回放模式
	self.record_mode = true
end


function TablePart:turnSeat(viewId,time)
	-- body
	self.view:turnSeat(viewId,time)
end

function TablePart:updatePlayer(playerList)
	-- body
	self.player_list = playerList
end

function TablePart:offlinePlayer(pos,online)
	-- body
	-- self.view:offlinePlayer(pos,online)
 	local cardPart = self:getPart("CardPart")
 	if cardPart then
 	    cardPart:offlinePlayer(pos,online)	
 	end

	local ready_part = self:getPart("ReadyPart")

    if ready_part then
    	ready_part:offlinePlayer(pos,online)
    end
end

function TablePart:deactivate()
	local partId = self:getPartId()
    local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:unRegisterMsgListener(SocketConfig.MSG_GAME_OPERATION)
	net_mode:unRegisterMsgListener(SocketConfig.MSG_GAME_VIP_ROOM_CLOSE)
	net_mode:unRegisterMsgListener(SocketConfig.MSG_GAME_OPERATION_ACK)
	net_mode:unRegisterMsgListener(SocketConfig.MSG_GAME_UPDATE_PLAYER_PROPERTY)
	net_mode:unRegisterMsgListener(SocketConfig.MSG_PLAYER_OPERATION_NTF)
	net_mode:unRegisterMsgListener(SocketConfig.MSG_GAME_START)
	net_mode:unRegisterMsgListener(SocketConfig.MSG_PLAYER_OPERATION)
	net_mode:unRegisterMsgListener(SocketConfig.MSG_GAME_OVER_ACK)
	net_mode:unRegisterMsgListener(SocketConfig.MSG_GAME_OTHERLOGIN_ACK)
	net_mode:unRegisterMsgListener(SocketConfig.MSG_GAME_SEND_SCROLL_MES,partId)
	net_mode:unRegisterMsgListener(SocketConfig.MSG_CLOSE_VIP_TABLE_ACK)
	self:unRegisterLoginCMD()

	local chat_part = self:getPart("ChatPart")
    chat_part:deactivate()

    if self.wifi_and_net then
    	self.wifi_and_net:deactivate()
    	self.wifi_and_net = nil
    end

	self:reSet()
    
	if self.view ~= nil then
		local card_part = self:getPart("CardPart")
        card_part:deactivate()
		self.view:removeSelf()
		self.view =  nil
	end
end

function TablePart:getPartId()
	-- body
	return "TablePart"
end

function TablePart:otherLogin(data)
	-- body
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:disconnect()
	local tips_part = global:createPart("TipsPart",self)
	if tips_part then
		tips_part:activate({info_txt=string_table.other_login,left_click = function()
			-- body
			cc.Director:getInstance():endToLua()
		end})
	end
end

function TablePart:startGame(data)
	release_print(os.date("%c") .. "[info] 牌桌开局")

	local roomMenuPart = self:getPart("RoomMenuPart") 
	if roomMenuPart then
		roomMenuPart:activate() 
    	roomMenuPart:hideDissolveBtn(self.tableid > 1)
	end

    local chat_part = self:getPart("ChatPart")
    if chat_part and (not self.chat_part) then
    	local pos_table = self.view:getPosTable()

    	local voiceRoomID = ""
		if self.roomCreator_id and self.roomCreator_id ~= "" then
    		voiceRoomID = tostring(self.game_id) .. "_" .. self.roomCreator_id
    	end
		chat_part:activate(self.game_id,pos_table,voiceRoomID)
		self.chat_part = chat_part
		-- chat_part:hideSzBtn()
    end

    local card_part = self:getPart("CardPart")
	card_part.majorViewId = self:changeSeatToView(data.dealerpos) -- @Deek 保存庄家座位号
    card_part:activate(self.game_id,data)

    --设置方位
    self.view:setBearingByBanker(card_part.majorViewId)

    local wifi_and_net = self:getPart("WifiAndNetPart")
    if wifi_and_net then
    	wifi_and_net:activate(self.game_id,self.view.node.wifi_and_net)
    end

    if self.tableid > 1 then ----显示当前局数和总局数  1/4局
    	local quanTotal = bit._and(data.serviceGold,0xff)
    	release_print(os.date("%c") .. "[info] 牌桌开局, 当前局数，总局数 ", data.quannum,quanTotal)
    	self.view:dispalyQuan(data.quannum,quanTotal)
    	self.cur_hand = data.quannum --当前局数
    	self.total_hand =quanTotal --总局数
    end

	self.last_card_num = 0
	self.m_seat_id = data.mtablePos

	card_part:initTableWithData(self.player_list,data)
end

function TablePart:getPlayerInfo(viewId)
	-- body
	for i,v in ipairs(self.player_list) do
		if v.view_id == viewId then
			return v
		end
	end
	return nil
end

function TablePart:get_Retain_card_num()
	return self.last_card_num
end

function TablePart:getCard()
	-- -- body
	-- self.last_card_num = self.last_card_num - 1

	-- self:updateLastCardNum(self.last_card_num)
end

function TablePart:updateLastCardNum(num)
	release_print(os.date("%c") .. "[info] 牌桌剩余牌的数量 ", num)
	local card_part = self:getPart("CardPart")
	card_part:updateLastCardNum(num)
end

function TablePart:loadHeadImg(url,node)
	-- body
	local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
	lua_bridge:startDownloadImg(url,node)
end

function TablePart:chatClick()
	-- body
	print("this is chat click -----------------------------------------")
	local chat_part =self:getPart("ChatPart")
	if chat_part then
		chat_part:showSz()
	end
end

function TablePart:settingsClick()
	-- body

	if not self.record_mode then
		local roomsetting_part =self:getPart("SettingsPart")
		if roomsetting_part then
			roomsetting_part:activate(self.tableid)
			roomsetting_part:setSwitch3DEnable(false)
			roomsetting_part:setCallback(function()
				local cardPart = self:getPart("CardPart")
				if cardPart then
					print("DialectsetttingCallBack")
					cardPart:resetDialect()
				end 
			end)
		end		
	else
		self:exitClick()
	end
end

function TablePart:IsSetDialect()
	local cardPart = self:getPart("CardPart")
	if cardPart then
		return cardPart:IsSetDialect()
	end
	return false
end

function TablePart:getGameAssetsPath()
	local cardPart = self:getPart("CardPart")
	if cardPart then
		return cardPart:getGameAssetsPath()
	end
	return ""
end

function TablePart:menuCtlClick(sender)
    local roommenu_part = self:getPart("RoomMenuPart");
	
	if roommenu_part then
		roommenu_part:activate(self.tableid)
		sender:setVisible(false);
	end
end

function TablePart:exitClick()
	-- body
 	print("TablePart:exitClick")
	local tips_part = self:getPart("TipsPart")

	if tips_part then
		local str_tips = string_table.is_back_to_lobby
		if self.match_mode then
			str_tips = '离开由机器人代打，淘汰前不能进入其他房间'
		end
		tips_part:activate({info_txt=str_tips,left_click=function()
			-- body
			print("exitClick()------------")
			self:returnLobby()
		end})
		tips_part:notScroll()
	end
end

function TablePart:returnLobby()
	release_print(os.date("%c") .. "[info] 牌桌返回大厅")
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local opt_msg = ycmj_message_pb.PlayerGameOpertaion()
	opt_msg.opid = RoomConfig.GAME_OPERATION_PLAYER_LEFT_TABLE
	net_mode:sendProtoMsg(opt_msg,SocketConfig.MSG_GAME_OPERATION,self.game_id)
	self:returnGame()
end

function TablePart:gameEnd(data)
	release_print(os.date("%c") .. "[info] 牌桌一小局结束， 当前局数，总局数 ", self.cur_hand, self.total_hand)
	local card_part =self:getPart("CardPart")
	local game_end = self:getPart("GameEndPart")
	self.view:hideMenu()
	if game_end then
		local last_round = false
		
		if self.cur_hand > 0 and self.tableid > 1 and self.cur_hand >= self.total_hand then --vip场才有显示战绩
			last_round = true
		end

		print("self.m_seat_id:"..self.m_seat_id)
		print("self.cur_hand:"..self.cur_hand)
		print("self.total_hand:"..self.total_hand)

		game_end:activate(self.game_id,data , self.m_seat_id,last_round,self.cur_hand,self.total_hand, card_part)
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
 
function TablePart:nextGame()
	-- body
    -- local ready_part = self:getPart("ReadyPart")
    -- if ready_part then
    -- 	ready_part:showView()
    -- end
    release_print(os.date("%c") .. "[info] 牌桌请求开启下一句")
    self.owner:creatNewPlayerGame()
end


function TablePart:returnGame()
	-- body
	self:deactivate()
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:refreshSeq()
	print("------------------------客户端主动刷新双序号")
	local user = global:getGameUser()
	local lobby_part = global:createPart("LobbyPart",user)
	lobby_part:activate(self.game_id)
end

function TablePart:gameOperationAck(data,appId)
	-- body
	local game_op_ack = ycmj_message_pb.PlayerGameOpertaionAck()
	game_op_ack:ParseFromString(data)
	print("this is  game op ack:",game_op_ack)
	if game_op_ack.opertaionID == RoomConfig.GAME_OPERATION_TABLE_ADD_NEW_PLAYER then
		release_print(os.date("%c") .. "[info] 牌桌玩家上线 ", game_op_ack.tablePos)
		local player = self:decodePlayer(game_op_ack)
		player.view_id = self:changeSeatToView(player.tablepos)
		local ready_part = self:getPart("ReadyPart")
		ready_part:addPlayer(player)
		if self:getPlayerInfo(player.view_id) then --上线线重连通知
			self:offlinePlayer(player.view_id,true)
		end
	elseif game_op_ack.opertaionID == RoomConfig.MAHJONG_OPERTAION_WAITING_OR_CLOSE_VIP then
		--self:showCloseVipRoomTips(game_op_ack.playerName , game_op_ack.playerIndex)
	elseif game_op_ack.opertaionID == RoomConfig.GAME_OPERATION_PLAYER_LEFT_TABLE then
		release_print(os.date("%c") .. "[info] 牌桌玩家下线 ", game_op_ack.tablePos)
		local ready_part = self:getPart("ReadyPart")
		local pos = self:changeSeatToView(game_op_ack.tablePos)
		ready_part:hideIndex(pos)
		local gps_part = self:getPart("GpsPart")
		if gps_part then
			gps_part:sendGpsMsg(self.game_id, self.m_seat_id,self.tableid,true)
			gps_part:setIsShow(true)
		end
	end
end

function TablePart:decodePlayer(playerInfo)
	-- body
	local player = {}
	player.uid = playerInfo.playerIndex or playerInfo.uid 
	player.name = playerInfo.name or playerInfo.playerName
	player.headImgUrl = playerInfo.headImgUrl
	player.targetPlayerName = playerInfo.targetPlayerName
	player.sex = playerInfo.sex
	player.coin = playerInfo.coin or playerInfo.gold
	player.tablepos = playerInfo.tablepos or playerInfo.tablePos
	player.desc = playerInfo.desc
	player.fan = playerInfo.fan
	player.gameresult = playerInfo.gameresult
	player.canfrind = playerInfo.canfrind
	player.intable= playerInfo.intable
	player.vipoverdata = playerInfo.vipoverdata
	player.ip = playerInfo.ip
	player.gamestate = playerInfo.gamestate
	player.playerIndex = playerInfo.playerIndex
	return player
end

function TablePart:closeVipRoomAck(data,appId)
	-- body
	--self:returnGame()
	--local ai_mod = global:getModuleWithId(ModuleDef.AI_MOD)
    --data = ai_mod:vipEndOverData()
    print("###[TablePart:closeVipRoomAck]")
    release_print(os.date("%c") .. "[info] 牌桌收到房间结束的通知")
    local dissolve_part = self:getPart("DissolvePart")
	if dissolve_part then
		dissolve_part:closeClick()
	end

	local tips_part = self:getPart("TipsPart")
	if tips_part then
		tips_part:deactivate()
	end

    local game_over_ack = ycmj_message_vipend_pb.VipRoomClose()
	game_over_ack:ParseFromString(data)
	print("###[TablePart:closeVipRoomAck]:",game_over_ack)

	local chat_part = self:getPart("ChatPart")
	if chat_part then
		--chat_part:exitVoiceRoom()
	end
	
	local vip_over_part =self:getPart("VipOverPart")
	if vip_over_part then
		vip_over_part:activate(self.game_id,game_over_ack , self.tableid, self.createid, self.createName)
	end
	
	--组队语音
	local teamVoicePart = self:getPart("TeamVoicePart")
	if teamVoicePart then
		teamVoicePart:exitVoiceRoom()
	end
	--
end

--更新玩家属性
function TablePart:updatePlayerProperty(data,appId)
	local player_property = comm_struct_pb.UpdatePlayerPropertyMsg()
	player_property:ParseFromString(data)
	print("this is update player property :", player_property)

	local user = global:getGameUser()
	local player_info = user:getProp("gameplayer" .. self.game_id)

	player_info.gold = player_property.gold
	player_info.diamond = player_property.diamond

	release_print(os.date("%c") .. "[info] 牌桌收到更新玩家信息 ", player_info.gold, player_info.diamond)
	
	user:setProp("gameplayer" .. self.game_id,player_info) 
end

function TablePart:ntfOperationAck(data,appId)
	local ntf_operation = PlayerOperationNotifyMsg_pb.PlayerOperationNotifyMsg()
	ntf_operation:ParseFromString(data) 
	self:ntfOperationHandle(ntf_operation)
end

function TablePart:ntfOperationHandle(ntf_operation)
	local cur_seat_id = ntf_operation.playertablepos
	local cur_view_id = self:changeSeatToView(cur_seat_id)
	print("###[TablePart:ntfOperationHandle]cur_view_id ntf_operation:",cur_view_id ,ntf_operation,os.date())

	if ntf_operation.operation == RoomConfig.MAHJONG_OPERTAION_GAME_OVER then --游戏结束
		release_print(os.date("%c") .. "[info] 牌桌收到游戏结束的通知")
	elseif ntf_operation.operation ==RoomConfig.MAHJONG_OPERTAION_OFFLINE then --玩家离线
		release_print(os.date("%c") .. "[info] 牌桌收到玩家离线的通知")
		self:operationOffline(ntf_operation)
	elseif ntf_operation.operation == RoomConfig.MAHJONG_OPERTAION_HU_CARD_LIST_UPDATE then --提醒玩家可以胡的牌
		release_print(os.date("%c") .. "[info] 牌桌收到提醒玩家可以胡的牌")
		self:updateHuCard(ntf_operation)
	elseif ntf_operation.operation == RoomConfig.MAHJONG_OPERTAION_ONLINE then --下线后又上线
		release_print(os.date("%c") .. "[info] 牌桌收到提醒玩家下线后又上线") 
        self:operationOffline(ntf_operation)
	elseif ntf_operation.operation == RoomConfig.MAHJONG_OPERTAION_REMOE_CHU_CARD then --玩家打出的牌，被吃碰杠走了
		release_print(os.date("%c") .. "[info] 牌桌收到玩家打出的牌，被吃碰杠走了")
		self:removeOutCard(ntf_operation)
	elseif ntf_operation.operation == RoomConfig.MAHJONG_OPERTAION_OVERTIME_AUTO_CHU then --超时自动出牌
		release_print(os.date("%c") .. "[info] 牌桌收到自动出牌 ")
		self:autoOutCard(ntf_operation)
	elseif bit._and(ntf_operation.operation,TablePart.CMD.MAHJONG_OPERTAION_CONFIRM) == TablePart.CMD.MAHJONG_OPERTAION_CONFIRM then
		release_print(os.date("%c") .. "[info] 取消胡")
		self:CancelHuOperation()
	elseif bit._and(ntf_operation.operation,RoomConfig.MAHJONG_OPERTAION_CHI) == RoomConfig.MAHJONG_OPERTAION_CHI 
		or bit._and(ntf_operation.operation,RoomConfig.MAHJONG_OPERTAION_PENG) == RoomConfig.MAHJONG_OPERTAION_PENG 
		or bit._and(ntf_operation.operation,RoomConfig.MAHJONG_OPERTAION_BU_GANG) == RoomConfig.MAHJONG_OPERTAION_BU_GANG
		or bit._and(ntf_operation.operation,RoomConfig.MAHJONG_OPERTAION_AN_GANG) == RoomConfig.MAHJONG_OPERTAION_AN_GANG 
		or bit._and(ntf_operation.operation,RoomConfig.MAHJONG_OPERTAION_MING_GANG) == RoomConfig.MAHJONG_OPERTAION_MING_GANG 
		or bit._and(ntf_operation.operation,RoomConfig.Gang) == RoomConfig.Gang then --服务器通知轮到玩家吃牌血流杠会冲突
		release_print(os.date("%c") .. "[info] 牌桌收到服务器通知轮到玩家吃碰杠 ") 
		self:operationCard(ntf_operation)
	elseif ntf_operation.operation == RoomConfig.MAHJONG_OPERTAION_HU then
		release_print(os.date("%c") .. "[info] 牌桌收到服务器通知轮到玩家胡牌 ") 
		self:operationCard(ntf_operation)
	elseif bit._and(ntf_operation.operation,RoomConfig.MAHJONG_OPERTAION_CHU) == RoomConfig.MAHJONG_OPERTAION_CHU then --轮到玩家出牌
		release_print(os.date("%c") .. "[info] 牌桌收到轮到玩家出牌的通知 ") 
		self:operationChu(ntf_operation)
	elseif ntf_operation.operation == RoomConfig.MAHJONG_OPERTAION_ADD_CHU_CARD then --玩家出牌结束，牌没有被吃碰杠
		release_print(os.date("%c") .. "[info] 牌桌收到玩家出牌结束，牌没有被吃碰杠 ")
		self:addOutCard(ntf_operation)
	elseif ntf_operation.operation == RoomConfig.MAHJONG_OPERTAION_TIP_MO_CARD  then
		print("###[TablePart:ntfOperation]RoomConfig.MAHJONG_OPERTAION_TIP_MO_CARD四家摸牌")
		release_print(os.date("%c") .. "[info] 牌桌收到四家摸牌的通知 ")
		-- local card_part = self:getPart("CardPart")
  --       card_part:drawOneCard()
  --       self.last_card_num = self.last_card_num - 1
		-- self:updateLastCardNum(self.last_card_num)
	elseif ntf_operation.operation ==RoomConfig.MAHJONG_OPERTAION_TIP then --提示当前谁在操作
		release_print(os.date("%c") .. "[info] 牌桌收到提示当前谁在操作的通知 ")
		self:operationTip(ntf_operation)
	elseif ntf_operation.operation == RoomConfig.MAHJONG_OPERTAION_CANCEL then --吃碰听超时
	elseif ntf_operation.operation == RoomConfig.MAHJONG_OPERTAION_WAITING_OR_CLOSE_VIP then --提醒玩家有人掉线是否等待
	elseif ntf_operation.operation == RoomConfig.MAHJONG_OPERTAION_NO_START_CLOSE_VIP then -- VIP房间超时未开始游戏，房间结束
	elseif ntf_operation.operation == RoomConfig.MAHJONG_OPERTAION_UPDATE_PLAYER_GOLD then --更新桌上金币
	elseif ntf_operation.operation == RoomConfig.MAHJONG_OPERTAION_PLAYER_HU_CONFIRMED then --玩家胡
		print("###[TablePart:ntfOperation]RoomConfig.MAHJONG_OPERTAION_PLAYER_HU_CONFIRMED 胡")
		release_print(os.date("%c") .. "[info] 牌桌收到玩家胡的通知 ")
		self:operationHu(ntf_operation)
	elseif bit._and(ntf_operation.operation,RoomConfig.MAHJONG_OPERTAION_POP_LAST) == RoomConfig.MAHJONG_OPERTAION_POP_LAST then
		--提示抓尾，即显示抓尾的2张牌
		release_print(os.date("%c") .. "[info] 牌桌收到提示抓尾的通知 ")
		self:operationCard(ntf_operation)
	elseif ntf_operation.operation == RoomConfig.MAHJONG_OPERTAION_PUSH_OVER then --牌局内结束推倒牌
		print("###[TablePart:ntfOperation]RoomConfig.MAHJONG_OPERTAION_PUSH_OVER")
		local card_part = self:getPart("CardPart")
		if card_part then
			card_part:pushOverHandCard(ntf_operation.handcard)
		end
	elseif bit._and(ntf_operation.operation,RoomConfig.MAHJONG_OPERTAION_TING) == RoomConfig.MAHJONG_OPERTAION_TING then --听牌
		local card_part = self:getPart("CardPart")
			print("下发哪些牌打出可以听牌")
			-- repeated uint32 tinglist=9
			print("tinglist:",ntf_operation)
		if card_part then
			card_part:drawingHandCardTip(ntf_operation.tinglist)
		end
	elseif ntf_operation.operation == RoomConfig.MAHJONG_OPERTAION_SELECT_CARD_TING then
		print("currenthand:"..self.cur_hand)
		print("RoomConfig.MAHJONG_OPERTAION_SELECT_CARD_TING:",ntf_operation)
		--
		local card_part = self:getPart("CardPart")
		if card_part then
			card_part:onlyTingCard(ntf_operation)
		end
	end
end

function TablePart:CancelHuOperation(data,appId)
	local tips_part = global:createPart("TipsPart",self)
	if tips_part then
		tips_part:activate({info_txt=string_table.opt_cancle_tips,left_click=function()
			-- body 
			print("确定取消")
		 	self:SureCancelHu(1)
		end,right_click=function()
			-- body
			print("取消确定")
		 	self:SureCancelHu(2)
		end})
	end
end

function TablePart:SureCancelHu(num)
	-- body
	local player_table_operation = ycmj_message_pb.PlayerTableOperationMsg()
    player_table_operation.operation = TablePart.CMD.MAHJONG_OPERTAION_CONFIRM
    player_table_operation.card_value = num

	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)

	if SocketConfig.IS_SEQ == false then		
		local buff_str = player_table_operation:SerializeToString()
		local buff_lenth = player_table_operation:ByteSize()
		net_mode:sendMsg(buff_str,buff_lenth,SocketConfig.MSG_PLAYER_OPERATION,self.game_id)
	elseif SocketConfig.IS_SEQ == true then
		net_mode:sendProtoMsgWithSeq(player_table_operation,SocketConfig.MSG_PLAYER_OPERATION,self.game_id)
	end
end

function TablePart:operationOffline(data)
	print("operationOffline");
    local offline_pos = self:changeSeatToView(data.playertablepos)
    local online = true --默认在线
    if data.operation == RoomConfig.MAHJONG_OPERTAION_OFFLINE then
        online = false
    end
    self:offlinePlayer(offline_pos,online)
end

function TablePart:operationHu(data)
	-- body
	local hu_pos = data.playertablepos
	local hu_card = data.targetcard
	local view_id = self:changeSeatToView(hu_pos)
	local card_part = self:getPart("CardPart")
	local ma1 = data.chiflag
	local ma2 = data.pengcardvalue
	local m_winner_ma = bit._or(ma1,bit.lshift(ma2,30))
	--解析码牌搞不懂为什么之前的人要写的这么蛋疼
	local m_table = {}
	local function checkMa(i)
		-- body
		local temp = bit._and(bit.rshift(m_winner_ma,6*i),0x3f)
		print("this is decode ma -------:",temp)
		if temp > 0 then
			table.insert(m_table,temp)
			checkMa(i+1)
		else

			print("-----data-------",data)

			dump(data)

			local huType = data.huCardSource

			print("huType:"..huType)

			card_part:setLastCardViewPos()
			if huType == 1 then	
				print("自摸")
				card_part:showHuCardSp(view_id,hu_card,0.0)
			else
				--胡牌时间延迟为1秒，自摸不延迟
				print("胡牌")
				card_part:showHuCardSp(view_id,hu_card,1.0)
			end	
				card_part:showHuAnimate(view_id,m_table,huType)
		end
	end
	checkMa(0)
 
end


--更新听牌
function TablePart:updateHuCard(data)
	-- body
	if data.tinglist and #(data.tinglist) > 0 then
    	self.last_card_num = data.cardleftnum
    	--self.view:updateLastCardNum(self.last_card_num)
    	self:updateLastCardNum(data.cardleftnum)
    	local ting_list = data.tinglist
    	local card_part = self:getPart("CardPart")
	    card_part:tingCard(ting_list)
	elseif #(data.tinglist) == 0 then
		local ting_list = data.tinglist
    	local card_part = self:getPart("CardPart")
	    card_part:tingCard(ting_list)
	end
end

--玩家牌被吃碰了移除最后出的牌
function TablePart:removeOutCard(data)
	release_print(os.date("%c") .. "[info] 牌桌玩家牌被吃碰了移除最后出的牌 ", data.targetcard)
	local card_part = self:getPart("CardPart")
	local view_id = self:changeSeatToView(data.playertablepos)
	card_part:removeLastCard(view_id,data.targetcard)
end

function TablePart:operationTip(data)
	-- body
	-- self.last_card_num = data.cardleftnum
	--self.view:updateLastCardNum(self.last_card_num)
	self:updateLastCardNum(data.cardleftnum)
	local card_part = self:getPart("CardPart")
	if card_part then
		local cur_view_id = self:changeSeatToView(data.playertablepos)
		card_part:turnSeat(cur_view_id)
	end
end

function TablePart:addOutCard(data)
	-- body
	-- self.last_card_num = data.cardleftnum
	--self.view:updateLastCardNum(self.last_card_num)
	self:updateLastCardNum(data.cardleftnum)

	--把牌加到已出牌队列中
	local card_part = self:getPart("CardPart")
	local cur_seat_id = data.playertablepos 
	local cur_view_id = self:changeSeatToView(cur_seat_id)
	local card_value = data.targetcard
	card_part:outCard(cur_view_id,card_value)
end

function TablePart:operationCard(data)

	local card_part = self:getPart("CardPart")
	local dis_play_guo = true --是否显示过牌
	print("###[TablePart:operationCard] data.operation ", data.operation)

	if bit._and(data.operation,RoomConfig.Gang) == RoomConfig.Gang  then
  		print(os.date("%c") .. "###[TablePart:operationCard] RoomConfig.Gang")
  		release_print("[info] 牌桌toc收到可以杠牌的通知 ") 
  		local card_data = data.gangList
  		
  		--产品说要加上过
  		--dis_play_guo = true
  		-- if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_CHU) == RoomConfig.MAHJONG_OPERTAION_CHU  then
  		-- 	dis_play_guo = false --自己出牌不显示过
  		-- end  
  		card_part:ntfGangList(card_data)
  		card_part:addOpt(RoomConfig.Gang) 
	end

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_CHU) == RoomConfig.MAHJONG_OPERTAION_CHU  then --自己摸了一张牌
		print(os.date("%c") .. "###[TablePart:operationCard] RoomConfig.MAHJONG_OPERTAION_CHU")
		release_print("[info] 牌桌toc摸了一张牌 ", data.chicardvalue) 
		if data.chicardvalue ~= 0 then
			card_part:getCard(data.chicardvalue)
		end
   	end

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_PENG) == RoomConfig.MAHJONG_OPERTAION_PENG then
		release_print(os.date("%c") .. "[info] 牌桌toc可以碰 ", data.pengcardvalue)
		local c1 = bit._and(data.pengcardvalue,0xff)
		local c2 = bit._and(bit.rshift(data.pengcardvalue,8),0xff)
		local cur_seat_id = data.playertablepos
		local cur_view_id = self:changeSeatToView(cur_seat_id)
		local card_data = {mcard={c1,c2},ocard=c1}
		card_part:addOpt(RoomConfig.Peng)
	end

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_CHI) == RoomConfig.MAHJONG_OPERTAION_CHI then
		release_print(os.date("%c") .. "[info] 牌桌toc可以吃 ", data.targetcard)
		card_part:setChiList(data.chicardvalue,data.targetcard)
		card_part:addOpt(RoomConfig.Chi)
	end

	--[[
	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_HU) == RoomConfig.MAHJONG_OPERTAION_HU then 
		--黑摸 
		if data.hutype == 1 then
			card_part:addOpt(RoomConfig.MAHJONG_OPERTAION_ZIMO)
		else
			card_part:addOpt(RoomConfig.MAHJONG_OPERTAION_HU)
		end 
		print("###[TablePart:operationCard] RoomConfig.MAHJONG_OPERTAION_HU hutype is ", data.hutype)
		dis_play_guo = true
	end
	--]]

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_HU) == RoomConfig.MAHJONG_OPERTAION_HU 
		or bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_ZIMO) == RoomConfig.MAHJONG_OPERTAION_ZIMO then
		release_print(os.date("%c") .. "[info] 牌桌toc可以胡 ")
		card_part:addOpt(RoomConfig.MAHJONG_OPERTAION_HU)
	end

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_POP_LAST) == RoomConfig.MAHJONG_OPERTAION_POP_LAST then
		--显示2张 可点击的尾牌
		release_print(os.date("%c") .. "[info] 牌桌toc可以选择尾牌 ", data.targetcard)
		local cur_seat_id = data.playertablepos
		local cur_view_id = self:changeSeatToView(cur_seat_id)
		local card_data = {mcard={},ocard=data.targetcard}
		card_part:ntfOpt(RoomConfig.MAHJONG_OPERTAION_POP_LAST,card_data,data.targetcard)
		return
	end

	card_part:showAddOpt(data,dis_play_guo)
end


--服务器通知轮到自己出牌
function TablePart:operationChu(data)
	release_print(os.date("%c") .. "[info] 牌桌toc服务器通知轮到自己出牌 ", data.chicardvalue)

	local card_part = self:getPart("CardPart")
	if data.chicardvalue ~= 0 then --是否摸了新牌，如果是断线回来，这个通知里面没有新牌
		card_part:getCard(data.chicardvalue)
	end

	local opt_type = nil
	local card_value = {}
	--如果玩家听牌
	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_HU) == RoomConfig.MAHJONG_OPERTAION_HU then
		release_print(os.date("%c") .. "[info] 牌桌toc服务器通知轮到自己胡牌 ")
		opt_type = RoomConfig.MAHJONG_OPERTAION_HU
		card_value.mcard = {}
	end

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_AN_GANG) == RoomConfig.MAHJONG_OPERTAION_AN_GANG then
		release_print(os.date("%c") .. "[info] 牌桌toc服务器通知轮到自己暗杠 ", data.pengcardvalue)
		opt_type = RoomConfig.AN_GANG
		card_value.mcard = {data.pengcardvalue,data.pengcardvalue,data.pengcardvalue,data.pengcardvalue}
	end

	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_BU_GANG) == RoomConfig.MAHJONG_OPERTAION_BU_GANG then
		release_print(os.date("%c") .. "[info] 牌桌toc服务器通知轮到自己补杠 ", data.pengcardvalue)
		opt_type = RoomConfig.BU_GANG
		card_value.mcard = {data.pengcardvalue}
	end

    --自摸胡操作
	if bit._and(data.operation,RoomConfig.MAHJONG_OPERTAION_ZIMO) == RoomConfig.MAHJONG_OPERTAION_ZIMO then
		release_print(os.date("%c") .. "[info] 牌桌toc服务器通知轮到自己自摸 ", data.pengcardvalue)
		card_part:addOpt(RoomConfig.MAHJONG_OPERTAION_HU)
		card_part:showAddOpt(data,true)
		return
	end
 
	if opt_type then
		card_part:ntfOpt(opt_type,card_value)
	end
end

--自动出牌显示托管状态
function TablePart:autoOutCard(data)
	-- body
	local card_part = self:getPart("CardPart")
	if card_part then
		card_part:setAutoOutCard(true)
	end
end

function TablePart:gameStartNtf(data,appId)
	release_print(os.date("%c") .. "[info] 牌桌收到开局通知")
	local game_start = game_start_message_pb.GameStartMsg()
	game_start:ParseFromString(data)
	self.playerwin = game_start.playerwin
	print("TablePart:gameStartNtf:",game_start)
	local ready_part = self:getPart("ReadyPart")
	if ready_part then 
		ready_part:hideView()
	end
	self:startGame(game_start)
end

function TablePart:headClick(player_info , posX , posY , viewId )
	self.smalluserinfo_part = self:getPart("SmallUserInfoPart") 
	if self.smalluserinfo_part then
		self.smalluserinfo_part:deactivate()
		local is_vip = false
		if self.tableid > 1 then
			is_vip = true
		end
		self.smalluserinfo_part:activate(self.game_id,player_info , posX , posY , viewId ,self.playerwin,is_vip)
	end
end

function TablePart:showAnGang() --是否显示暗杠的牌
	-- body
	return false
end

function TablePart:playerOperationAck(data,appId)
	release_print(os.date("%c") .. "[info] 牌桌收到玩家操作回应数据 ")
	local player_operaction = PlayerTableOperationMsg_pb.PlayerTableOperationMsg()
	player_operaction:ParseFromString(data)
    print("TablePart:playerOperationAck--收到玩家操作回应数据=",player_operaction)
    self:playerOperationHandle(player_operaction)
end

function TablePart:playerOperationHandle(player_operaction)
	-- body
	local card_part = self:getPart("CardPart") 
	local cur_seat_id = player_operaction.player_table_pos
	local cur_view_id = self:changeSeatToView(cur_seat_id)

	if player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_POP_LAST then --刷新左上角的尾牌
		release_print(os.date("%c") .. "[info] 牌桌收到刷新尾牌的通知 ", player_operaction.card_value)
		local card_data = {mcard={},ocard=player_operaction.card_value}
		card_part:optCard(cur_view_id,RoomConfig.MAHJONG_OPERTAION_POP_LAST,card_data)
	elseif bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_CHU) == RoomConfig.MAHJONG_OPERTAION_CHU then --其他玩家出牌
		release_print(os.date("%c") .. "[info] 牌桌收到玩家出牌的通知，本地位置，牌值 ", cur_seat_id, player_operaction.card_value)
		local card_value = bit._and(player_operaction.card_value, 0xff) 
		if cur_seat_id == self.m_seat_id and #player_operaction.handCards  > 0 then --如果是自己就刷新手牌 
			card_part:showAutoOutCard(card_value) --托管需要出牌
			card_part:refreshMyCard(player_operaction.handCards,player_operaction.downCards,player_operaction.beforeCards,card_value)
		elseif cur_seat_id ~= self.m_seat_id then
			local card_value = player_operaction.card_value 
			card_part:showOutCard(cur_view_id,card_value)
		end  
	elseif player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_AN_GANG
		or player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_MING_GANG
		or player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_BU_GANG
		or player_operaction.operation == RoomConfig.LaiziGang then
		release_print(os.date("%c") .. "[info] 牌桌收到玩家杠牌的通知，本地位置，牌值 ", cur_seat_id, player_operaction.card_value)
        local card_value = player_operaction.opValue
        local c1 = bit._and(card_value,0xff)
        local c2 = bit._and(bit.rshift(card_value,8),0xff)
        local c3 = bit._and(bit.rshift(card_value,16),0xff)
        local c4 = bit._and(bit.rshift(card_value,32),0xff)

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
		local card_data = {mcard={card[1],card[2],card[3]},ocard=card[4]}

		if bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_AN_GANG) == RoomConfig.MAHJONG_OPERTAION_AN_GANG then
			release_print(os.date("%c") .. "[info] 牌桌暗杠 ", card[4])
			card_data = {mcard={RoomConfig.EmptyCard,RoomConfig.EmptyCard,RoomConfig.EmptyCard,RoomConfig.EmptyCard}}
			if (cur_seat_id == self.m_seat_id) or self:showAnGang() then --我自己可以看见第二张牌
				card_data = {mcard= {RoomConfig.EmptyCard,RoomConfig.EmptyCard,RoomConfig.EmptyCard,card[4]}}
			end
		elseif bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_BU_GANG) == RoomConfig.MAHJONG_OPERTAION_BU_GANG then
			release_print(os.date("%c") .. "[info] 牌桌补杠 ", card[1])
			card_data = {mcard={card[1]}} --补杠只有一张牌
        elseif bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_MING_GANG) == RoomConfig.MAHJONG_OPERTAION_MING_GANG then
        	release_print(os.date("%c") .. "[info] 牌桌明杠 ", c1)
            card_data = {mcard={c1,c2,c3},ocard=c4}
        end
		card_part:optCard(cur_view_id,player_operaction.operation,card_data)
	elseif bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_PENG ) == RoomConfig.MAHJONG_OPERTAION_PENG  then --碰
		release_print(os.date("%c") .. "[info] 牌桌收到玩家碰牌的通知，本地位置，牌值 ", cur_seat_id, player_operaction.opValue)
		local opvalue = player_operaction.opValue
		local c1 = bit._and(opvalue,0xff)
		local c2 = bit._and(bit.rshift(opvalue,8),0xff)
		local c3 = bit._and(bit.rshift(opvalue,16),0xff)
		print("this is  peng:",c1,c2,c3)		
		local card_data = {mcard={c1,c2},ocard=c3}
		card_part:optCard(cur_view_id,RoomConfig.Peng,card_data)
		-- card_part:ntfOpt(RoomConfig.Peng,card_data)

	elseif bit._and(player_operaction.operation,RoomConfig.MAHJONG_OPERTAION_CHI) ==RoomConfig.MAHJONG_OPERTAION_CHI then --吃
		release_print(os.date("%c") .. "[info] 牌桌收到玩家吃牌的通知，本地位置，牌值 ", cur_seat_id, player_operaction.opValue)
		local opvalue = player_operaction.opValue
		local c = {}
		for i=1,4 do
			table.insert(c,bit._and(bit.rshift(opvalue,(i-1)*8),0xff))
		end
		print("this is  chi:",c[1],c[2],c[3],c[4])
		local card_data = {mcard={c1,c2},ocard=c3}
		if c[4] ~= 0 then --服务端逻辑很诡异判断下为好
			card_data.mcard = {}
			for i=1,3 do
				if c[i] ~= c[4] then
					table.insert(card_data.mcard,c[i])
				end
			end
			card_data.ocard = c[4]
		end
		card_part:optCard(cur_view_id,RoomConfig.Chi,card_data)
	elseif player_operaction.operation == RoomConfig.PLAYER_OPERATION_BAIPAI then
		release_print(os.date("%c") .. "[info] 牌桌收到玩家摆牌的通知，本地位置，牌值 ", cur_seat_id)
		if #player_operaction.handCards == 0 then
			print("TablePart:playerOperation--不能摆牌--提示玩家")
			  local tips_part = require('app.part.tips.TipsPart').new(self)
			if tips_part then
				tips_part:activate({info_txt=string_table.current_no_baipai--[[, left_click=function()
					-- body
					global:activatePart("LoginPart")
				end--]]})
			end
		else
			print("TablePart:playerOperation--能摆牌--处理摆牌")
			--处理摆牌操作表现和逻辑
			print("TablePart:playerOperation--服务器下发座位号=", cur_seat_id) 
			print("TablePart:playerOperation--客户端转换座位号=", cur_view_id)
			card_part:baipaiShowCards(cur_view_id, player_operaction.handCards)
		end
	end
end


--牌結束的時候
function TablePart:gameOverAck(data,appId)
	-- body

	--[[
	local game_over_ack = ycmj_message_pb.PlayerGameOverAck()
	game_over_ack:ParseFromString(data) 
	print("TablePart:gameOverAck:",game_over_ack)

	local jsonData = json.encode(game_over_ack)
	local user_default = cc.UserDefault:getInstance()
	user_default:setStringForKey("datakssss", jsonData)
	user_default:flush()

	local jsonStr = user_default:getStringForKey("datakssss")
	game_over_ack= json.decode(jsonStr)
	self:gameEnd(game_over_ack)
    --]]
	local game_over_ack = ycmj_message_pb.PlayerGameOverAck()
	game_over_ack:ParseFromString(data) 
	print("TablePart:gameOverAck:",game_over_ack)
	self:gameEnd(game_over_ack)
end

function TablePart:changeSeatToView(seatId)
	-- body
	if self.m_seat_id then
		return (seatId - self.m_seat_id + 4)%4 + 1
	end
end

--发送申请解散VIP房间
function TablePart:closeVipRoom(readyCall)
	-- body
	local tips_part = global:createPart("TipsPart",self)
	if tips_part then
		tips_part:activate({info_txt=string_table.close_vip_room_tip,left_click=function()
			-- -- 	测试
			-- 	local vip_over_part =self:getPart("VipOverPart")
			-- 	if vip_over_part then
			-- 		vip_over_part:activate(self.game_id,game_over_ack , self.tableid,self.createid)
			-- 		return 
			-- 	end
			
			if readyCall and self.cur_hand <= 0   then --准备界面调起
				local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
			    local opt_msg = ycmj_message_pb.PlayerGameOpertaion()
			    opt_msg.opid = RoomConfig.GAME_OPERATION_APPLY_CLOSE_VIP_ROOM	     -- 房主申请解散VIP房间
			   	opt_msg.opvalue = self.tableid                           -- 1:请求解散 2：同意解散
			    net_mode:sendProtoMsg(opt_msg,SocketConfig.MSG_GAME_OPERATION,self.game_id)
			    print("-------------------------------------------------------------------------self.uid self.createid : ",self.uid ,self.createid)
			    if self.uid ~= self.createid then --不是房主直接离开
			    	print("################" .. tostring(self.uid))
			    	self:returnGame()
			    end
			else --请求解散房间
				local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
			    local opt_msg = PlayerTableOperationMsg_pb.PlayerTableOperationMsg()
			    opt_msg.operation = RoomConfig.MAHJONG_OPERTAION_WAITING_OR_CLOSE_VIP	     -- 房主申请解散VIP房间
			   	opt_msg.opValue = 1                           -- 1:请求解散 2：同意解散
			   	if SocketConfig.IS_SEQ == false then	
			    	local buff_str = opt_msg:SerializeToString()
			    	local buff_lenth = opt_msg:ByteSize()
			    	net_mode:sendMsg(buff_str,buff_lenth,SocketConfig.MSG_PLAYER_OPERATION,self.game_id)
			    elseif SocketConfig.IS_SEQ == true then
			   		net_mode:sendProtoMsgWithSeq(opt_msg,SocketConfig.MSG_PLAYER_OPERATION,self.game_id)
			   	end
			end
		end})
		tips_part:notScroll()
	end

end

function TablePart:showCloseVipRoomTips( playerName,playerIndex)
	-- body
	print("---------showCloseVipRoomTips : ",playerName,playerIndex)
	local string_info = string.format(string_table.player_close_room_req,playerName,playerIndex)
	local tips_part = self:getPart("TipsPart")
	if tips_part then
		tips_part:activate({info_txt=string_info,left_click=function()
			-- body 
			print("同意解散")
		 	self:sureCloseVipRoom(2)
		end,right_click=function()
			-- body
			print("取消解散")
		 	self:sureCloseVipRoom(3)
		end})
	end
end

--同意解散房间
function TablePart:sureCloseVipRoom(op_id)
	-- body
	print("-----sureCloseVipRoom op_id ：",op_id)
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    local opt_msg = PlayerTableOperationMsg_pb.PlayerTableOperationMsg()
    opt_msg.operation = RoomConfig.MAHJONG_OPERTAION_WAITING_OR_CLOSE_VIP 	     -- 房主申请解散VIP房间
   	opt_msg.opValue = op_id                           -- 1:请求解散 2：同意解散 3:取消解散
   	if SocketConfig.IS_SEQ == false then
	    net_mode:sendProtoMsg(opt_msg,SocketConfig.MSG_PLAYER_OPERATION,self.game_id)
	elseif SocketConfig.IS_SEQ == true then
    	net_mode:sendProtoMsgWithSeq(opt_msg,SocketConfig.MSG_PLAYER_OPERATION,self.game_id)
    end
end

function TablePart:scrollMsgAck(data,appId)		--跑马灯消息
	-- body
	if tonumber(appId) == tonumber(self.game_id) then
		-- local broadcast_node = self:getPart("BroadcastPart")
	 --    if broadcast_node then
	 --    	broadcast_node:isShowBroadcastNode(true)
	 --    end

		local net_manager = global:getNetManager()
		local scroll_msg = wllobby_message_pb.ScrollMsg()
		scroll_msg:ParseFromString(data)
		print("----scrollMsgAck: ",scroll_msg)
		local msg = scroll_msg.msg
		local loopNum = scroll_msg.loopNum
		local removeAll = scroll_msg.removeAll

		-- local broadcast_node = self:getPart("BroadcastPart")
		-- broadcast_node:startBroadcast(msg,loopNum,removeAll,true,appId)

		local ready_part = self:getPart("ReadyPart")
		if ready_part then
			ready_part:scrollMsgAck(data,appId)
		end
	end
end
--是否同意解散房间用户列表
function TablePart:closeVipTableAck(data,appId)
	print("###[TablePart:closeVipTableAck]")
	local close_vip_tablemsg_ack = ycmj_message_pb.CloseVipTableMsgAck()
	close_vip_tablemsg_ack:ParseFromString(data)
	print("DissolvePart:closeVipTableAck:",close_vip_tablemsg_ack)

	local dissolve_part = self:getPart("DissolvePart")
	if dissolve_part then
		dissolve_part:setData(close_vip_tablemsg_ack , self.player_list ,self.m_seat_id)
	end

	if close_vip_tablemsg_ack.mCloseStatus ~= 1 then
		local tips_part = self:getPart("TipsPart")
		if tips_part and tips_part.view then
			tips_part:deactivate()
		end
	end
end

function TablePart:notifySeqToClienTMsg()
	print("###[TablePart:notifySeqToClienTMsg]")
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local ntf_operation = PlayerOperationNotifyMsg_pb.PlayerOperationNotifyMsg()
	ntf_operation.operation = RoomConfig.MAHJONG_OPERATION_GET_CLOSE_VIP_ROOM_MSG
	if SocketConfig.IS_SEQ == false then
	    net_mode:sendProtoMsg(ntf_operation,SocketConfig.MSG_PLAYER_OPERATION,self.game_id)
	elseif SocketConfig.IS_SEQ == true then
    	net_mode:sendProtoMsgWithSeq(ntf_operation,SocketConfig.MSG_PLAYER_OPERATION,self.game_id)
    end
end

function TablePart:getTableid()
	-- body
	return self.tableid
end

function TablePart:startLoading()
	-- body
	local loading_part = global:createPart("LoadingPart",self)
	self:addPart(loading_part)
	loading_part:activate(self.game_id)
end

function TablePart:endLoading()
	-- body
	local loading_part = self:getPart("LoadingPart")
	if loading_part then
		loading_part:deactivate()
	end
end

function TablePart:showGpsTip(index,distance)
	-- body
	print("TablePart:showGpsTip : ",index,distance)
	if self.tableid > 1 then
		local gpsTip_part = self:getPart("GpsTipPart")
		if gpsTip_part then
			gpsTip_part:setInfo(index,distance)
		end
	end
end

function TablePart:gpsClick(node,touch,event)
    local gps_part = self:getPart("GpsPart")
	if gps_part then
		gps_part:Gps_Click(node,touch,event)
  --       if(gps_part.customactived) then
		--     gps_part:deactivate();
  --           gps_part.customactived = false;
		-- else
  --          gps_part:activate(self.m_seat_id,self.tableid, true)
		--    gps_part.customactived = true;
  --       end
	end
end
function TablePart:onEnter()
    self:registerMsgListenerRp()
end

function TablePart:unRegisterMsgListenerRp()
    local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    net_mode:unRegisterMsgListener(TablePart.CMD.CREATE_RED_PACKET_RSP_CMD,"TablePart")
end

function TablePart:registerMsgListenerRp()
    local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    net_mode:registerMsgListener(TablePart.CMD.CREATE_RED_PACKET_RSP_CMD,handler(self,TablePart.createRedPacketRsp),"TablePart")
end

function TablePart:onExit()
    self:unRegisterMsgListenerRp()
end

--服务器下发红包回掉
function TablePart:createRedPacketRsp(data)
	release_print(os.date("%c") .. "[info] 牌桌收到有红包的通知 ")
    local createRedPacket_resp = RedPacketMessage_pb.SendRedPacketMsg()
    createRedPacket_resp:ParseFromString(data)
	if createRedPacket_resp.resultCode == 200 then
		global:setRedPacket(createRedPacket_resp)--缓存
	end
end

--重置
function TablePart:reSet()
	local teamVoicePart = self:getPart("TeamVoicePart")
	if teamVoicePart then
		teamVoicePart:deactivate()
		self.teamVoicePart = nil
	end
end

function TablePart:MatchNotify(data)
	local match_notify = competition_pb.commNotify()
	match_notify:ParseFromString(data)

	print(match_notify)
	local tips_part = self:getPart('TipsPart')
	if tips_part and not tips_part.view then
		tips_part:activate({info_txt=match_notify.tips})
		tips_part:notScroll()
	end
end

function TablePart:onVipOverPartDeactivate()
	self:returnGame()
end

return TablePart