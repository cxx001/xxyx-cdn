local CURRENT_MODULE_NAME = ...
local DDZReadyPart = class("DDZReadyPart",cc.load('mvc').PartBase)
DDZReadyPart.DEFAULT_PART = {
	"ChatPart",		--加入聊天节点
	-- 'BroadcastPart',--加入小喇叭节点
}
DDZReadyPart.DEFAULT_VIEW = "DDZReadyLayer"
--[
-- @brief 构造函数
--]
function DDZReadyPart:ctor(owner)
    DDZReadyPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function DDZReadyPart:initialize()
	self.player_list = {}
	self.m_pos = -1
	self.vip_table_id = -1
end

function DDZReadyPart:activate(gameId,data)
    -- gameId = 262401 --临时调试用
    self.game_id = gameId
    DDZReadyPart.super.activate(self, CURRENT_MODULE_NAME)

	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:registerMsgListener(DdzConfig.ACK_PLAYER_READY,handler(self,DDZReadyPart.ReadyPlayerAck))  -- 玩家准备 服务器返回
	net_mode:registerMsgListener(DdzConfig.ACK_PLAYER_CALL,handler(self,DDZReadyPart.PlayerCallScoreAck))  -- 玩家叫分 服务器返回	 

    --激活聊天模块
	local chat_part = self:getPart("ChatPart")
	if chat_part then
		local pos_table = self.view:getPosTable()
		chat_part:activate(pos_table)
	end

	if data ~= nil then		
		--加入界面坐标
		self.player_list = {}
		local game_user = global:getGameUser()
		local m_index = tonumber(game_user:getProp("gameplayer" ..SocketConfig.GAME_ID).playerIndex)
		
		--获取本人位置
		for i,v in ipairs(data.objGameTable.playerArray) do
			if tonumber(v.playerIndex) == m_index then
				self.m_pos = v.tablepos
				break
			end
		end

		--获取其他玩家信息
		for k,v in ipairs(data.objGameTable.playerArray) do
			self.player_list[k] = self:decodePlayerInfo(v)
			if v.tablepos then
				self.player_list[k].view_id = self.owner:changeSeatToView(v.tablepos)
			end
		end

		--更新TableScene、ReadyLayer 个人信息UI
		self.owner:updatePlayer(clone(self.player_list))
		self.view:initPlayer(self.player_list)

		--显示房间信息
		if data.objGameTable.tableId > 0 then
			self.vip_table_id = data.objGameTable.tableId
			self.view:showVipInfo(data.objGameTable)
			self.view:setTableID(data.objGameTable.tableId)
			self.m_totalhand = 0--data.tableinfo.totalhand
		end
	end

	self:reqReady()	
	if data.m_curSide == self.m_pos then --轮到我操作
		self:showState(DdzConfig.MySeat,data.callScoreFlag)
	end
end

--发送准备请求
function DDZReadyPart:reqReady()
	-- body
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:sendMsg("",0,DdzConfig.REQ_PLAYER_READY,self.game_id)
end

--准备请求返回
function DDZReadyPart:ReadyPlayerAck( data )
	-- body
	local game_table = ddz_message_pb.GameTable()
	game_table:ParseFromString(data)
	print("DDZReadyPart:ReadyPlayerAck",data)
end

--斗地主叫分
function DDZReadyPart:callScore(score)
	-- body
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    local opt_msg = ddz_message_pb.SendOnPlayerCallScore()
    opt_msg.seatPos = self.m_pos	     -- 玩家位置
   	opt_msg.landScore = score    -- 玩家叫分
   	if SocketConfig.IS_SEQ == false then	
    	local buff_str = opt_msg:SerializeToString()
    	local buff_lenth = opt_msg:ByteSize()
    	net_mode:sendMsg(buff_str,buff_lenth,DdzConfig.REQ_PLAYER_CALL,self.game_id)
    elseif SocketConfig.IS_SEQ == true then
   		net_mode:sendProtoMsgWithSeq(opt_msg,DdzConfig.REQ_PLAYER_CALL,self.game_id)
   	end	
end

--斗地主叫分返回
function DDZReadyPart:PlayerCallScoreAck( data )
	-- body
	local game_table = ddz_message_pb.RevOnPlayerCallScore()
	game_table:ParseFromString(data)
	print("--------------DDZReadyPart:PlayerCallScoreAck-----------------:",game_table)
	if game_table.SUB_S_OUT_CARD == true then
		self:startGame(game_table)
		--更新地主、农民头像
		local view_id = self.owner:changeSeatToView(game_table.curSide)
		if game_table.backCardList and 4 == #game_table.backCardList then
			for i = 1, DdzConfig.TableSeatNum do
				if i == view_id then
					self.owner:showBankerState(i,true)
				else
					self.owner:showBankerState(i,false)
				end
			end
		end
	else
		local priv_view_id = self.owner:changeSeatToView(game_table.privSide)
		self.view:playerCallScore(priv_view_id,game_table.callScoreFlag,game_table.scoreState[game_table.privSide])
		local view_id = self.owner:changeSeatToView(game_table.curSide)
		self.view:showState(view_id,game_table.callScoreFlag)
		--叫分计时器
		self:turnSeat(view_id)
	end
end

function DDZReadyPart:showState(viewId,state)
	-- body
	self.view:showState(viewId,state)
end

function DDZReadyPart:turnSeat( viewId ,time)
	-- body
	self.view:turnSeat(viewId,time)
end



function DDZReadyPart:deactivate()
	local chatPart = self:getPart("ChatPart")
	if chatPart then
		chatPart:deactivate()
	end

	if self.view then
		self.view:removeSelf()
		self.view =  nil
	end
end

function DDZReadyPart:getPartId()
	-- body
	return "ReadyPart"
end

function DDZReadyPart:decodePlayerInfo(playerInfo)
	-- body
	local player = {}
	player.uid = playerInfo.uid
	player.name = playerInfo.name
	player.headImgUrl = playerInfo.headImgUrl
	-- player.targetPlayerName = playerInfo.name
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

function DDZReadyPart:loadHeadImg(url,node)
	-- body
	local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
	lua_bridge:startDownloadImg(url,node)
end

function DDZReadyPart:offlinePlayer(pos,online)
	-- body
	if self.view then
		self.view:offlinePlayer(pos,online)
	end
end

--隐藏准备界面
function DDZReadyPart:hideView()
	-- body
	local chatPart = self:getPart("ChatPart")
	if chatPart then
		chatPart:deactivate()
	end
	self.view:hide()
end

--显示准备界面
function DDZReadyPart:showView()
	-- body
	self.player_list = {}
	self.view:nextGame(self.player_list) --将准备玩家状态置为未准备
	self.view:show()
end

--[[ 加入新的玩家
	{
		seat_id = 2,
		name = "test1",
		sex = 0,
		img_rul = "",
		coin  = 1000
	}
--]]
function DDZReadyPart:addPlayer(data)
	-- body
			--获取其他玩家信息
	for k,v in ipairs(data.playerArray) do
		self.player_list[k] = self:decodePlayerInfo(v)
		if v.tablepos then
			self.player_list[k].view_id = self.owner:changeSeatToView(v.tablepos)
		end
	end
	self.owner:updatePlayer(clone(self.player_list))
	self.view:initPlayer(self.player_list)
end

function DDZReadyPart:getPlayerInfo(viewId)
	-- body
	for i,v in ipairs(self.player_list) do
		if v.view_id == viewId then
			return v,i
		end
	end
	return nil
end

function DDZReadyPart:startGame(data)
	-- body
	self.owner:startGame(data)
	self:deactivate()
	self.player_list = {}
end

function DDZReadyPart:inviteFriends()
	-- body
	print("tablewating_inviteFriends1")
	if RoomConfig.Ai_Debug then
		local player_info = self:getDebugPlayer()
		local ai_mod = global:getModuleWithId(ModuleDef.AI_MOD)
		ai_mod:addPlayer(player_info)
	else
		print("tablewating_inviteFriends2",string_table.game_name[tonumber(self.game_id)],self.game_id)
		local title = string_table.game_title_yi_chang
		local bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
		--string_table.vip_table_invite_wechat="房号：%d，%d局，%s速度来战"
		local tmpStr1 = string_table.vip_table_invite_wechat
		if self.m_totalhand == nil or self.m_totalhand == 0 then
			self.m_totalhand = 4
		end

		if string_table.game_name[tonumber(self.game_id)] then
			tmpStr1 = string_table.game_name[tonumber(self.game_id)] .. "," .. tmpStr1
		end
		
		local shareContent = string.format(tmpStr1,self.vip_table_id,self.m_totalhand,"")
		local shareUrl = string_table.share_weixin_android_url
		--分享内容和分享链接都是从服务器上拉取的
		
		local user = global:getGameUser()
	    local props = user:getProps()
	    local gameConfigList = props["gameplayer" .. self.game_id].gameConfigList

	    for i,v in ipairs(gameConfigList) do
	    	local gameParam = gameConfigList[i]
			if device.platform == "android" then
				if gameParam.paraId == ClientParamConfig.WEIXIN_SHARE_URL_ANDROID then
					if gameParam.valueStr then
						shareUrl = gameParam.valueStr --分享链接
					end
				end
			elseif device.platform == "ios" then
				if gameParam.paraId == ClientParamConfig.WEIXIN_SHARE_URL_IOS then
					if gameParam.valueStr then
						shareUrl = gameParam.valueStr --分享链接
					end
				end
			end
		end

		bridge:ShareToWX(1,shareContent,shareUrl)
	end
	-- self:addPlayer(player_info)
end

function DDZReadyPart:closeRoom()
	-- body
	print("this is close room------------------------------")
	self.owner:closeVipRoom(true)
end

function DDZReadyPart:exitClick()
	print("this is exit room------------------------------")
	self.owner:exitClick()
end

function DDZReadyPart:micClick()
	self.owner:micClick()
end

function DDZReadyPart:trustClick()
	self.owner:trustClick()
end

function DDZReadyPart:ChatClick()
	self.owner:chatClick()
end

function DDZReadyPart:SettingClick()
	self.owner:settingsClick()
end

function DDZReadyPart:maskClick()
	-- body
	local chat_part = self:getPart("ChatPart")
	if chat_part then
		chat_part:hideSz()
	end
end


-- --不抢地主
-- function DDZReadyPart:NotGrabClick(  )
-- 	-- body

-- end

-- --不叫地主
-- function DDZReadyPart:NotCallClick(  )
-- 	-- body

-- end

-- --抢地主
-- function DDZReadyPart:GrabDizhuClick(  )
-- 	-- body

-- end

-- --叫地主
-- function DDZReadyPart:CallDizhuClick(  )
-- 	-- body

-- end

function DDZReadyPart:hideIndex(num)
	-- body
	self.view:hidePlayer(num)
end

function DDZReadyPart:scrollMsgAck(data,appId)		--跑马灯消息
	-- body
	if tonumber(appId) == tonumber(self.game_id) then
		local broadcast_node = self:getPart("BroadcastPart")
	    if broadcast_node then
	    	broadcast_node:isShowBroadcastNode(true)
	    end

		local net_manager = global:getNetManager()
		local scroll_msg = wllobby_message_pb.ScrollMsg()
		scroll_msg:ParseFromString(data)
		print("----scrollMsgAck DDZReadyPart: ",scroll_msg)
		local msg = scroll_msg.msg
		local loopNum = scroll_msg.loopNum
		local removeAll = scroll_msg.removeAll

		local broadcast_node = self:getPart("BroadcastPart")
		broadcast_node:startBroadcast(msg,loopNum,removeAll,true,appId)
	end
end

return DDZReadyPart