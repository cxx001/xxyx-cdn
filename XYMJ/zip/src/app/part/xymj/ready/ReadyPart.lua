--[[
*名称:ReadyLayer
*描述:准备界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local ReadyPart = class("ReadyPart",cc.load('mvc').PartBase) --登录模块
ReadyPart.DEFAULT_PART = {
	"ChatPart",
	'BroadcastPart',--加入小喇叭节点
	"SharePart",
}
ReadyPart.DEFAULT_VIEW = "ReadyLayer"
ReadyPart.CMD = {
	MSG_PLAYER_OPERATION = SocketConfig.MSG_PLAYER_OPERATION,
}

local ePlayerState = {
	ISREADY = 1,
	NOREADY = 4,

}
ReadyPart.ePlayerState = ePlayerState
--[
-- @brief 构造函数
--]
ReadyPart.Ai_Debug = false


function ReadyPart:ctor(owner)
    ReadyPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function ReadyPart:initialize()
	self.player_list = {}
	self.m_pos = -1
	self.vip_table_id = -1
end

--[[激活模块
	playerList = { --玩家列表
		[1] = {
			seat_id = 1,
			name = "test",
			sex = 1,
			img_rul = "",
			coin = 1000,
		},
		[2] = {
			seat_id = 2,
			name = "test1",
			sex = 0,
			img_rul = "",
			coin  = 1000
		}
	}
--]]
function ReadyPart:activate(gameId,data,mySeatID)
	ReadyPart.super.activate(self, CURRENT_MODULE_NAME)
    self.game_id = gameId
	local chat_part = self:getPart("ChatPart")
	if chat_part then
		local pos_table = self.view:getPosTable()
		--local voiceRoomID = tostring(self.game_id) .. "_" .. tostring(data.tableinfo.roomid)
		chat_part:activate(self.game_id,pos_table,"")
	end

	local broadcast_node = self:getPart("BroadcastPart")
    if broadcast_node then
    	broadcast_node:activate(self.view.node.broadcast_node)
    	broadcast_node:isShowBroadcastNode(false)
    end
	if data ~= nil then
		self.m_tableInfo = 	data.tableinfo 
		self.m_pos = self.m_tableInfo.tablepos 	

		--加入界面坐标
		self.player_list = {}
		print("###[ReadyPart:activate]#self.m_tableInfo.players", #self.m_tableInfo.players)
		for k,v in ipairs(self.m_tableInfo.players) do
			self.player_list[k] = self:decodePlayerInfo(v)
			if v.tablepos then
				self.player_list[k].view_id = self:changeSeatToView(v.tablepos)
			end
			--print(k,v)
		end
		self.owner:updatePlayer(clone(self.player_list))
		self.view:initPlayer(self.player_list)

		if self.m_tableInfo.viptableid > 0 then
			self.vip_table_id = self.m_tableInfo.viptableid
			self.view:showVipInfo()
			self.view:setTableID(self.m_tableInfo.viptableid)
			self.m_totalhand = self.m_tableInfo.totalhand
			self.playwaytype = self.m_tableInfo.playwaytype
		end

		if self.m_tableInfo.currenthand and self.m_tableInfo.currenthand > 0 then
			self.view:hideSitAndInviteBtn()
		end

		if ReadyPart.Ai_Debug then
			local ai_mod = global:getModuleWithId(ModuleDef.AI_MOD)
			ai_mod:init(self,self.owner:getPart("CardPart"),self.owner)
			local user = global:getGameUser()
			local prop = user:getProps()
			local my_info = {
				name = prop.name,
				sex = 0,
				img_rul = prop.photo,
				uid = prop.uid
			}
			ai_mod:addPlayer(my_info)
		end
	end
	self.isReady = false

	self.mySeatID = mySeatID
	self:registNetMsg(true) 
	if self.m_tableInfo.viptableid <= 1 then
		self.view:updateVIPOpBtn(false)
	end

	local sharePart = self:getPart("SharePart")
	if nil ~= sharePart then
    sharePart:activate(self.game_id)
   	end
end

function ReadyPart:registNetMsg(isReg)
	local partId = self:getPartId()
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	if isReg then
		net_mode:registerMsgListener(ReadyPart.CMD.MSG_PLAYER_OPERATION,handler(self,ReadyPart.gameOperation), partId)
	else
		net_mode:unRegisterMsgListener(ReadyPart.CMD.MSG_PLAYER_OPERATION, partId)
	end
end

function ReadyPart:deactivate()
	self:registNetMsg(false)
	local chatPart = self:getPart("ChatPart")
	if chatPart then
		chatPart:deactivate()
	end

	if self.view then
		self.view:removeSelf()
		self.view =  nil
	end
end

function ReadyPart:getPartId()
	-- body
	return "NormalReadyPart"
end

function ReadyPart:decodePlayerInfo(playerInfo)
	-- body
	local player = {}
	player.uid = playerInfo.uid
	player.name = playerInfo.name
	player.headImgUrl = playerInfo.headImgUrl
	player.targetPlayerName = playerInfo.targetPlayerName
	player.sex = playerInfo.sex
	player.coin = playerInfo.coin or playerInfo.gold
--	player.coin = playerInfo.coin
--	player.gold = playerInfo.gold
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

--将逻辑座位转换为界面座位
function ReadyPart:changeSeatToView(seatId) --座位顺时针方向增加 1 - 4
	-- body
	if self.m_pos then
		return (seatId - self.m_pos + 4)%4 + 1
	end
end

function ReadyPart:loadHeadImg(url,node)
	-- body
	local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
	lua_bridge:startDownloadImg(url,node)
end

function ReadyPart:offlinePlayer(pos,online)
	-- body
	if self.view then
		self.view:offlinePlayer(pos,online)
	end
end

--隐藏准备界面
function ReadyPart:hideView()
	-- body
	self:registNetMsg(false)
	local chatPart = self:getPart("ChatPart")
	if chatPart then
		chatPart:deactivate()
	end
	if self.view then
		self.view:hide()
	end
end

--显示准备界面
function ReadyPart:showView()
	-- body
	self:registNetMsg(true)
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
function ReadyPart:addPlayer(playerInfo) 
	-- body
	if playerInfo and playerInfo.tablepos then 
		print("###[ReadyPart:addPlayer]seatID viewID", playerInfo.tablepos, playerInfo.view_id)
		playerInfo.view_id = self:changeSeatToView(playerInfo.tablepos)
		local exist_player,index = self:getPlayerInfo(playerInfo.view_id)
		if exist_player == nil then --防止断线重连重复添加
			table.insert(self.player_list,playerInfo)
		else
			playerInfo.gamestate = 1
			self.player_list[index] = playerInfo
		end
		self.owner:updatePlayer(clone(self.player_list))
	end
	print("###[ReadyPart:addPlayer]seatID viewID", playerInfo.tablepos, playerInfo.view_id)
	if self.view then
		self.view:showPlayer(playerInfo)
	end
end

function ReadyPart:getPlayerInfo(viewId)
	-- body
	for i,v in ipairs(self.player_list) do
		if v.view_id == viewId then
			return v,i
		end
	end
	return nil
end

function ReadyPart:startGame(data)
	-- body
	self.owner:startGame(data)
	self:deactivate()
	self.player_list = {}
end

if ReadyPart.Ai_Debug then
ReadyPart.debug_index = 1
function ReadyPart:getDebugPlayer()
	-- body
	self.debug_index = self.debug_index + 1
	return {
		uid = self.debug_index,
		name = "test" .. self.debug_index,
		sex = 0,
		img_rul = "http://wx.qlogo.cn/mmopen/Vt3en7SeZMnc4t2XACP0I2v0SAoHDlDsqtUsrgsy5yIv6icUzwR1Xm2Tesib2U4iaVlLXaOazo8EsrF8xSJF8GEM1xmURV9AMNe/0",
		coin = 1000
	}
end
end

function ReadyPart:inviteFriends()
	-- body
	print("tablewating_inviteFriends1")
	if ReadyPart.Ai_Debug then
		local player_info = self:getDebugPlayer()
		local ai_mod = global:getModuleWithId(ModuleDef.AI_MOD)
		ai_mod:addPlayer(player_info)
	else
		print("tablewating_inviteFriends2",string_table.game_name[tonumber(self.game_id)],self.game_id)
		local title = string_table.game_title_yi_chang

		if self.m_totalhand == nil or self.m_totalhand == 0 then
			self.m_totalhand = 4
		end
		print("###[RoomListNode:onViteFriend]")
		local sharePart = self:getPart("SharePart")
		if nil ~= sharePart then
			sharePart:inviteFriends(self.m_tableInfo)
		end

		-- local shareContent = self:createShareContent()
		-- local shareUrl = self:createShareUrl()
		-- print("###[ReadyPart:inviteFriends] shareContent is ", shareContent)
		-- global:getModuleWithId(ModuleDef.BRIDGE_MOD):ShareToWX(1,shareContent,shareUrl)
	end
	-- self:addPlayer(player_info)
end



function ReadyPart:createShareContent(tableInfo)
	string_table.vip_table_invite_wechat="正宗潜江麻将,真实防作弊!房号:%d，局数:%d,%s%s,底分%d分,%s支付,战个痛快!"
	local tmpStr1 = string_table.vip_table_invite_wechat

	local playWayStr = ""
	local playWay1 = tableInfo.playwaytype
	for k,v in pairs(RoomConfig.Rule) do 
		if bit._and(playWay1,v.value) == v.value and 0 ~= v.value then
			playWayStr = v.name
			break
		end
	end 


	local playWayStr2 = "" 
	for k,v in pairs(RoomConfig.Rule2) do 
		if bit._and(playWay1,v.value) == v.value and 0 ~= v.value then 
			print("### v.name ", v.name)
			playWayStr2 = playWayStr2 ~= "" and playWayStr2 ..","..v.name or v.name 
		end
	end  
	playWayStr2 = playWayStr2 ~= "" and "("..playWayStr2..")" or ""
	if "" ~= playWayStr2 then
		tmpStr1 = "潜江麻将,房号:%d,局数:%d,%s%s,底分%d分,%s支付"
	end

	local difenStr = tableInfo.diZhu 
	local payType = tableInfo.payType == 0 and "房主" or "AA" 
		
	if string_table.game_name[tonumber(self.game_id)] then
		tmpStr1 = string_table.game_name[tonumber(self.game_id)] .. "," .. tmpStr1
	end		
	return string.format(tmpStr1, tableInfo.viptableid, tableInfo.totalhand, playWayStr, playWayStr2, difenStr, payType)
end

function ReadyPart:createShareUrl()
	local shareUrl = string_table.share_weixin_android_url
	--分享内容和分享链接都是从服务器上拉取的
	local gameConfigList = global:getGameUser():getProps()["gameplayer" .. self.game_id].gameConfigList

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
	return shareUrl
end

function ReadyPart:closeRoom()
	-- body
	print("this is close room------------------------------")
	self.owner:closeVipRoom(true)
end

function ReadyPart:exitClick()
	print("this is exit room------------------------------")
	self:registNetMsg(false)
	self.owner:exitClick()
end

function ReadyPart:maskClick()
	-- body
	local chat_part = self:getPart("ChatPart")
	if chat_part then
		chat_part:hideSz()
	end
end

function ReadyPart:hideIndex(num)
	-- body
	self.view:hidePlayer(num)
end

function ReadyPart:scrollMsgAck(data,appId)		--跑马灯消息
	-- body
	if tonumber(appId) == tonumber(self.game_id) then
		local broadcast_node = self:getPart("BroadcastPart")
	    if broadcast_node then
	    	broadcast_node:isShowBroadcastNode(true)
	    end

		local net_manager = global:getNetManager()
		local scroll_msg = wllobby_message_pb.ScrollMsg()
		scroll_msg:ParseFromString(data)
		print("----scrollMsgAck ReadyPart: ",scroll_msg)
		local msg = scroll_msg.msg
		local loopNum = scroll_msg.loopNum
		local removeAll = scroll_msg.removeAll

		local broadcast_node = self:getPart("BroadcastPart")
		broadcast_node:startBroadcast(msg,loopNum,removeAll,true,appId)
	end
end


function ReadyPart:gameOperation(data,appId)
	local player_operaction = ycmj_message_pb.PlayerTableOperationMsg()
	player_operaction:ParseFromString(data)

	local cur_seat_id = player_operaction.player_table_pos

	print("XXXXX ccur_seat_id  ur ", cur_seat_id)

	local cur_view_id = self:changeSeatToView(cur_seat_id)

	if player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_CANCEL_SITDOWN 
	or player_operaction.operation == RoomConfig.MAHJONG_OPERTAION_SITDOWN then --玩家点击准备与取消
		
	 	local value = player_operaction.opValue
	 	--测试数据
	 	--value = 0x1 
	 	print("XXXXX ----4---- self.mySeatID ", self.mySeatID)
	 	local myViewID = self:changeSeatToView(self.mySeatID)
	 	local mySeatID = self.mySeatID
	 	print(string.format("###[TablePart:playerOperation] 玩家点击准备与取消mySeatID %d myViewID %d  viewID %d  value %x  ", mySeatID, myViewID, cur_view_id, value))
	 	local info = {} 
	 	info[self:changeSeatToView(0)] = { state = bit._and(value,0x1) == 0x1, viewId = self:changeSeatToView(0)}
	 	info[self:changeSeatToView(1)] = { state = bit._and(value,0x2) == 0x2, viewId = self:changeSeatToView(1)} 
	 	info[self:changeSeatToView(2)] = { state = bit._and(value,0x4) == 0x4, viewId = self:changeSeatToView(2)}
	 	info[self:changeSeatToView(3)] = { state = bit._and(value,0x8) == 0x8, viewId = self:changeSeatToView(3)}  
	 	self:doUpdatePlayer(info, myViewID)
	 	
	end
end


function ReadyPart:requestToStart(ret)
	--发送一条协议
	self:startLoading() 
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local player_table_operation = ycmj_message_pb.PlayerTableOperationMsg()
	player_table_operation.operation = ret and RoomConfig.MAHJONG_OPERTAION_SITDOWN or RoomConfig.MAHJONG_OPERTAION_CANCEL_SITDOWN
	print("###[ReadyPart:requestToStart]", player_table_operation.operation)
	--net_mode:sendProtoMsg(player_table_operation,ReadyPart.CMD.MSG_PLAYER_OPERATION,self.game_id)
   	if SocketConfig.IS_SEQ == false then	
    	local buff_str = player_table_operation:SerializeToString()
    	local buff_lenth = player_table_operation:ByteSize()
    	net_mode:sendMsg(buff_str,buff_lenth,SocketConfig.MSG_PLAYER_OPERATION,self.game_id)
    elseif SocketConfig.IS_SEQ == true then
   		net_mode:sendProtoMsgWithSeq(player_table_operation,SocketConfig.MSG_PLAYER_OPERATION,self.game_id)
   	end	   
end

 
function ReadyPart:getReadyState()
	return self.isReady
end

function ReadyPart:doUpdatePlayer(infos, myViewID)
	self:endLoading() 
	dump(infos)
	for k1,playerInfo in pairs(self.player_list) do
		print(string.format("###[ReadyPart:doUpdatePlayer] myViewID %d  playerInfo.view_id:%d", myViewID, playerInfo.view_id))
		local stateInfo = infos[playerInfo.view_id] 
		dump(stateInfo)
		if nil ~= stateInfo then
			self.view:updatePlayerShow(stateInfo.viewId, stateInfo.state) 
			if playerInfo.view_id == myViewID then
				self.view:switchToReadyState(stateInfo.state)
			end 
		end 
	end
end


function ReadyPart:startLoading()
	-- body
	local loading_part = global:createPart("LoadingPart",self)
	self:addPart(loading_part)
	loading_part:activate()
end

function ReadyPart:endLoading(eventCode)
	-- body
	local loading_part = self:getPart("LoadingPart")
	if loading_part then
		loading_part:deactivate()
	end 
end

function ReadyPart:chatClick()
	-- body
	print("this is chat click -----------------------------------------")
	local chat_part =self:getPart("ChatPart")
	if chat_part then
		chat_part:showSz()
	end
end


return ReadyPart
