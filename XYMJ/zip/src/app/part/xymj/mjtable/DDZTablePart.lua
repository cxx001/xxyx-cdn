local CURRENT_MODULE_NAME = ...
local DDZTablePart = class("DDZTablePart",cc.load('mvc').PartBase)
DDZTablePart.DEFAULT_VIEW = "DDZTableScene"
DDZTablePart.DEFAULT_PART = {
	'ReadyPart',
	'CardPart',
	"ChatPart",
	"WifiAndNetPart",
	'GameEndPart',
	"TipsPart",
	"SmallUserInfoPart",
	"VipOverPart",
	--'BroadcastPart',--加入小喇叭节点
	"DissolvePart",
	"RoomSettingPart"--设置组件（牌局内）
}

function DDZTablePart:ctor(owner)
    DDZTablePart.super.ctor(self, owner)
    self.roomTableInfo = {}
end

function DDZTablePart:activate(data)
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:registerMsgListener(DdzConfig.ADDPLAYER_NTF,handler(self,DDZTablePart.addPlayer))  -- 玩家加入返回
	net_mode:registerMsgListener(DdzConfig.SEND_CARD_NTF,handler(self,DDZTablePart.sendCard)) --发牌
	net_mode:registerMsgListener(DdzConfig.NTF_END_CARD,handler(self,DDZTablePart.ntfEndGame)) --结束游戏
	net_mode:registerMsgListener(DdzConfig.ACK_AUTO_OUTCARD,handler(self,DDZTablePart.autoCardAck)) --托管状态	
	net_mode:registerMsgListener(SocketConfig.MSG_GAME_OTHERLOGIN_ACK,handler(self,DDZTablePart.otherLogin))	--异地登录
	net_mode:registerMsgListener(SocketConfig.MSG_GAME_OPERATION_ACK,handler(self,DDZTablePart.gameOperationAck)) --添加、移除用户 关闭房间的服务器返回

	DDZTablePart.super.activate(self, CURRENT_MODULE_NAME)

    self.roomTableInfo["createId"] = data.objGameTable.creatorid
    self.roomTableInfo.tableId = data.objGameTable.tableId
    self.roomTableInfo.baseMultiple = data.objGameTable.baseMultiple
    self.roomTableInfo.lowestSore = data.objGameTable.lowestSore
    self.roomTableInfo.gameCount = data.gameCount

    --获取自己位置
    local game_user = global:getGameUser()
	local m_index = tonumber(game_user:getProp("gameplayer" ..SocketConfig.GAME_ID).playerIndex)
	for i,v in ipairs(data.objGameTable.playerArray) do
		if tonumber(v.playerIndex) == m_index then
			 self.m_seat_id = v.tablepos
			break
		end
	end

	--更新玩家列表 player_list 信息
    self.player_list = {}
	for i,v in ipairs(data.objGameTable.playerArray) do
		local player_info = self:decodePlayer(v)
		player_info.view_id = self:changeSeatToView(v.tablepos)
		table.insert(self.player_list,player_info)
	end

	--初始化玩家UI
	self.view:initTableInfo(data,self.player_list)

	if data.gameStatus ~= nil then --断线重连
		local card_part = self:getPart("CardPart")
		card_part:activate(data,self.m_seat_id)
		
		if data.gameStatus < 4 and data.gameStatus > 0 then
			local ready_part = self:getPart("ReadyPart")
		    if ready_part then
		    	ready_part:activate(data)
		    end
		elseif data.gameStatus == 4 then --开始游戏
			local cur_side = self:changeSeatToView(data.m_curSide)
			card_part:turnSeat(cur_side)
		end
	else
		local ready_part = self:getPart("ReadyPart")

	    if ready_part then
	    	ready_part:activate(data)
	    end
	end
end

function DDZTablePart:addPlayer(data)
	-- body
	local game_table = ddz_message_pb.GameTable()
	game_table:ParseFromString(data)
	print("--------------DDZTablePart:AddPlayer-----------------:")
	-- print("--------------DDZTablePart:AddPlayer-----------------:",game_table)

	local ready_part = self:getPart("ReadyPart")

    if ready_part then
    	ready_part:addPlayer(game_table)
    end
end

function DDZTablePart:sendCard(data)
	-- body
	local game_start = ddz_message_pb.RevOnGameStart()
	game_start:ParseFromString(data)

	print("------------------sendCard---------------:")
	-- print("------------------sendCard---------------:",game_start)
	local ready_part = self:getPart("ReadyPart") --游戏开始移除准备界面
	local view_id = self:changeSeatToView(game_start.curPlayer)
	ready_part:showState(view_id,game_start.lastCallScoreFlag)
	--叫分计时器
	ready_part:turnSeat(view_id)

	local card_part = self:getPart("CardPart")
    card_part:activate(game_start,self.m_seat_id)
end

function DDZTablePart:ntfEndGame(data)
	-- body
	local ntf_end_game = ddzRoom_message_pb.RevOnGameEnd()
	ntf_end_game:ParseFromString(data)
	print("----------------CardPart:ntfEndGame------------------:",ntf_end_game)
	local game_end_layer = self:getPart("GameEndPart")
	game_end_layer:activate(ntf_end_game)

end

function DDZTablePart:autoCardAck(data)
	-- body
	local auto_card_ack = ddz_message_pb.RevOnIsAutoOutCard()
	auto_card_ack:ParseFromString(data)
	print("----------------CardPart:autoCardAck------------------:",auto_card_ack)

end

function DDZTablePart:otherLogin(data)
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

function DDZTablePart:gameOperationAck(data,appId)
	-- body
	local game_op_ack = ycmj_message_pb.PlayerGameOpertaionAck()
	game_op_ack:ParseFromString(data)
	print("this is  game op ack:",game_op_ack)
	if game_op_ack.opertaionID == RoomConfig.GAME_OPERATION_TABLE_ADD_NEW_PLAYER then
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
		local ready_part = self:getPart("ReadyPart")
		local pos = self:changeSeatToView(game_op_ack.tablePos)
		ready_part:hideIndex(pos)
	end
end

function DDZTablePart:decodePlayer(playerInfo)
	-- body
	local player = {}
	player.uid = playerInfo.uid
	player.name = playerInfo.name
	player.headImgUrl = playerInfo.headImgUrl
	player.sex = playerInfo.sex
	player.coin = playerInfo.coin
	player.tablepos = playerInfo.tablepos
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


function DDZTablePart:loadHeadImg(url,node)
	-- body
	local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
	lua_bridge:startDownloadImg(url,node)
end

function DDZTablePart:getPartId()
	-- body
	return "TablePart"
end

function DDZTablePart:updateLastCardNum( data )
	-- body
	self.view:updateLastCardNum(data)
end

function DDZTablePart:updatePlayer(playerList)
	-- body
	self.player_list = playerList
end

--斗地主开始游戏
function DDZTablePart:startGame(data)
	-- body
	local chat_part = self:getPart("ChatPart")
    if chat_part then
    	local pos_table = self.view:getPosTable()
		chat_part:activate(pos_table)
		chat_part:hideSzBtn()
    end

	local card_part = self:getPart("CardPart")
	local view_id = self:changeSeatToView(data.curSide)	
	card_part:showBackCard(view_id,data.backCardList)
	card_part:turnSeat(view_id)
 --    card_part:activate(data)
	self.view:updatePlayerInfo(self.player_list)
end

function DDZTablePart:turnSeat( viewId, time )
	-- body
	self.view:turnSeat(viewId, time)
end

--发送语音消息
function DDZTablePart:MicClick()
	--
end

--请求托管
function DDZTablePart:trustClick()
	--
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    local opt_msg = ddz_message_pb.SendOnIsAutoOutCard()
    opt_msg.seatPos = self.m_pos	     -- 玩家位置
   	opt_msg.isAuto = 1    -- 玩家是否请求托管 否:0 是:1
   	if SocketConfig.IS_SEQ == false then	
    	local buff_str = opt_msg:SerializeToString()
    	local buff_lenth = opt_msg:ByteSize()
    	net_mode:sendMsg(buff_str,buff_lenth,DdzConfig.REQ_AUTO_OUTCARD,SocketConfig.GAME_ID)
    elseif SocketConfig.IS_SEQ == true then
   		net_mode:sendProtoMsgWithSeq(opt_msg,DdzConfig.REQ_AUTO_OUTCARD,SocketConfig.GAME_ID)
   	end	
end

--请求托管
function DDZTablePart:distrustClick()
	--
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    local opt_msg = ddz_message_pb.SendOnIsAutoOutCard()
    opt_msg.seatPos = self.m_pos	     -- 玩家位置
   	opt_msg.isAuto = 0    -- 玩家是否请求托管 否:0 是:1
   	if SocketConfig.IS_SEQ == false then	
    	local buff_str = opt_msg:SerializeToString()
    	local buff_lenth = opt_msg:ByteSize()
    	net_mode:sendMsg(buff_str,buff_lenth,DdzConfig.REQ_AUTO_OUTCARD,SocketConfig.GAME_ID)
    elseif SocketConfig.IS_SEQ == true then
   		net_mode:sendProtoMsgWithSeq(opt_msg,DdzConfig.REQ_AUTO_OUTCARD,SocketConfig.GAME_ID)
   	end	
end

function DDZTablePart:chatClick()
	-- body
	local chat_part =self:getPart("ChatPart")
	if chat_part then
		chat_part:showSz()
	end
end

function DDZTablePart:settingsClick()

	local roomsetting_part =self:getPart("RoomSettingPart")
	if roomsetting_part then
		roomsetting_part:activate(self.roomTableInfo.tableId)
	end
end

function DDZTablePart:getPlayerInfo(viewId)
	-- body
	for i,v in ipairs(self.player_list) do
		if v.view_id == viewId then
			return v
		end
	end
	return nil
end

function DDZTablePart:headClick(player_info , posX , posY , viewId )
	self.smalluserinfo_part = self:getPart("SmallUserInfoPart") 
	if self.smalluserinfo_part then
		self.smalluserinfo_part:deactivate()
		local is_vip = false
		print("------------------------this is DDZTablePart:headClick", self.roomTableInfo.tableId)
		if self.roomTableInfo.tableId > 1 then
			is_vip = true
		end
		self.smalluserinfo_part:activate(player_info , posX , posY , viewId ,self.playerwin,is_vip)
	end
end


function DDZTablePart:exitClick()
	-- body
	-- local tips_part = self:getPart("TipsPart")

	-- if tips_part then
	-- 	tips_part:activate({info_txt=string_table.is_back_to_lobby,left_click=function()
	-- 		-- body
	-- 		self:BackToLobby()
	-- 	end})
	-- end
	self:BackToLobby()
end

function DDZTablePart:BackToLobby()

	local tips_part = global:createPart("TipsPart",self)
	if tips_part then
		tips_part:activate({info_txt=string_table.isExitGame,left_click=function()
			-- body
			local SendOnOutTable = ddz_message_pb.SendOnOutTable()
			--SendOnOutTable.type = 0
			local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	
			net_mode:sendProtoMsg(SendOnOutTable,SocketConfig.MSG_DDZ_SEND_LEISURE_OUT_LEISURE,SocketConfig.GAME_ID)

			local game_user = global:getGameUser()
			local lobby_part = global:createPart("LobbyPart",game_user)
			lobby_part:activate()
			self:deactivate()
			print("back to lobby")
		end})
	end
	local tips_part = self:getPart("TipsPart")
	if tips_part then
		tips_part:deactivate()
	end
	--table_part:activate(data)
end

--请求托管
function DDZTablePart:reqAutoCard()
	-- body
	local card_part = self:getPart("CardPart")
	card_part:reqAutoCard()
end

function DDZTablePart:ntfEndGame(data)
	-- body
	local ntf_end_game = ddzRoom_message_pb.RevOnGameEnd()
	ntf_end_game:ParseFromString(data)
	print("----------------CardPart:ntfEndGame------------------:",ntf_end_game)
	local game_end_layer = self:getPart("GameEndPart")
	game_end_layer:activate(ntf_end_game)

end

function DDZTablePart:returnLobby()
	-- body
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local opt_msg = ycmj_message_pb.PlayerGameOpertaion()
	opt_msg.opid = RoomConfig.GAME_OPERATION_PLAYER_LEFT_TABLE
	net_mode:sendProtoMsg(opt_msg,SocketConfig.MSG_GAME_OPERATION,SocketConfig.GAME_ID)
	self:returnGame()
end

function DDZTablePart:returnGame()
	-- body
	self:deactivate()
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:refreshSeq()
	print("------------------------客户端主动刷新双序号")
	local lobby_part = global:createPart("LobbyPart",user)
	lobby_part:activate()
end

function DDZTablePart:nextGame()
	-- body
	print("--------------------this is DDZTablePart:nextGame")
    local ready_part = self:getPart("ReadyPart")
    if ready_part then
    	ready_part:showView()
    end

    self.owner:creatNewPlayerGame()
end

function DDZTablePart:changeSeatToView(seatId)
	-- body
	if self.m_seat_id then
		return (seatId - self.m_seat_id + 3)%3 + 1
	end
end

--显示 地主、农民 图标
function  DDZTablePart:showBankerState( seat, is_Banker )
	-- body
	self.view:showBankerState(seat, is_Banker)
end

--显示玩家Pass
function DDZTablePart:showPassCard( view_id, is_show )
	-- body
	self.view:showPassCard( view_id,is_show )
end

--出牌规则无效
function DDZTablePart:invalidOutCard(type)
	-- body
	self.view:invalidOutCard(type)
end

function DDZTablePart:deactivate()
	-- body
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)

	net_mode:unRegisterMsgListener(DdzConfig.ADDPLAYER_NTF)  -- 玩家加入返回
	net_mode:unRegisterMsgListener(DdzConfig.SEND_CARD_NTF) --发牌
	net_mode:unRegisterMsgListener(DdzConfig.NTF_END_CARD) --结束游戏
	net_mode:unRegisterMsgListener(DdzConfig.ACK_AUTO_OUTCARD) --托管状态			
	net_mode:unRegisterMsgListener(SocketConfig.MSG_GAME_OTHERLOGIN_ACK)	--异地登录
	net_mode:unRegisterMsgListener(SocketConfig.MSG_GAME_OPERATION_ACK)	--玩家掉线重连

	self.view:removeSelf()
	self.view =  nil	
end


return DDZTablePart