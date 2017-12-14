--[[
*名称:LobbyLayer
*描述:大厅界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local LobbyPart = class("LobbyPart",cc.load('mvc').PartBase) --大厅模块
LobbyPart.DEFAULT_PART = { --默认存在的固有组件
	'AdPart',--轮播图
	'NoticePart', -- 公告组件
	'HelpPart', --帮助组件
	-- 'RecordPart', --战绩组件
	'SettingsPart', --设置组件
	'UserInfoPart', --个人信息组件
	'AddRoomPart',--加入房间组件
	'CreateRoomPart',--创建房间组件
	'BroadcastPart',--加入小喇叭节点
	'TablePart', --3D桌子组件
	'NormalTablePart', --2D桌子组件
	"PurchasePart",--支付组件
	"ReferrerPart",--推荐人界面
	'WebViewPart',
	'BattlePart', --战绩组件
	'BattleDetailPart', --战绩组件
	'OtherBattlePart',
	'RecordMainPart',	-- 回放
	'FankuiPart', -- 反馈（日志上报）组件
	--'SelectMatchPart',	-- 赛事列表
	'RedpacketMgrPart',	--红包管理界面组件
	'RedpacketTipsPart',	--红包展示组件
	'RewardTipsPart',	--红包奖励展示组件
    	'TipsPart',
	'MatchMainPart',	-- 比赛主页面
	'SelectMatchPart',	-- 赛事列表
	'DuihuanPart', 		--兑换组件
	'DuiHuanRecordPart', --兑换记录组件
	'DuihuanTipsPart',  --兑换内容提示组件
	'TelNumInputPart',  --电话号码输入组件
	'NtfUploadLogPart', --服务器下推上传日志组件
}
LobbyPart.DEFAULT_VIEW = "LobbyScene"
local cjson = require("cjson")
local HttpManager = class("HttpManager")
local version_low = "更新完毕，请点击按钮关闭游戏，重新进入"

require("app.model.config.RoomConfig")
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".StartGameMsgAck_pb")
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".ycmj_message_pb")
require("app.model.protobufmsg.wllobby_message_pb")
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".ReqStartGame_pb")
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".game_start_message_pb")
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".vip_over_data_pb")
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".player_info_pb")
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".card_info_pb")
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".card_down_pb")
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".card_down_list_pb")
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".player_game_over_ack_pb")
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".competition_pb")
require("app.model.config.ClientParamConfig")
require("app.utils.md5")

LobbyPart.CMD = {
    MSG_GAME_OTHERLOGIN_ACK = 0xc30205, --异地登录
    MSG_REQUEST_START_GAME = 0xc30003,
    MSG_REQUEST_START_GAME_ACK = 0xc30004,
    MSG_GAME_SEND_SCROLL_MES = 0xc30015,		            --跑马灯协议
    MSG_SYSTEM_NOTIFY_MSG =0xc30500,		            --系统消息
    MSG_GET_GAME_CONFIG_RSP =0x01000008,				--申请代理ack
    MSG_GET_GAME_CONFIG_REQ =0x01000007,				--申请代理req
    MSG_GAME_UPDATE_PLAYER_PROPERTY = 0xc30002,         --属性更新通知
    MSG_LOGIC_SERVER_FAKE_DEATH = 0xC30503, --服务器断线
    MSG_ENTER_VIP_ROOM = 0xc30102,
    MSG_EXIT_GAME_LOBBY = 0Xf00008,--退出子游戏
    CREATE_RED_PACKET_RSP_CMD = 0X01020001, --
    SPLIT_RED_PACKET_RSP_CMD = 0x01020003,
    QUERY_RED_PACKET_REQ_MSG = 0X01020006, --查询红包
    QUERY_RED_PACKET_RSP_MSG = 0X01020007,
    MATCH_BATTLE_BEGIN_MSG 	 = 0x01010027,
	MSG_GET_DH_CONFIG_REQ = 0x01000013,
	MSG_GET_DH_CONFIG_RSP = 0x01000014,
}
--[
-- @brief 构造函数
--]
function LobbyPart:ctor(owner)
    LobbyPart.super.ctor(self, owner)
    self:initialize()
end
--[
-- @override
--]
function LobbyPart:initialize()
	self.cur_game_id = -1
end

function LobbyPart:otherLogin(data,appId)
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


--激活大厅模块
function LobbyPart:activate(gameID,data)
	print("###[LobbyPart:activate]gameID ",gameID)
    self.game_id = gameID
    local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
	if IOS_BACK_DELAY == false then
		IOS_BACK_DELAY = true
		lua_bridge:setBackDelayTime(30000)
	end
	lua_bridge:changeActivityOrientation(1)
	LobbyPart.super.activate(self,CURRENT_MODULE_NAME)
	self:checkVersion()
	global:setCurrentPart(self)

	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	self:registerMsgListener(net_mode) 
	net_mode:enableSeq(true)        	--是否开启双序号 true 开启 false 关闭  
	self.reconnect_flag = nil 

    local user = global:getGameUser()
    local props = user:getProps()
    local game_info = props["gameplayer" .. self.game_id]
    --local table_data = cjson.encode(props)

    self.view:updateUserInfo(props,game_info)
    self.playerID = props["gameplayer" .. self.game_id].playerIndex
    self.name = props.name

	local game_player = user:getProp("gameplayer"..self.game_id)
	local agentFlag = game_player.agentFlag

    if agentFlag == 1 then
    	self.view:changeAgent()
    end

	self.view:ResetGameTitle(self.game_id)

    --print("table_data->",table_data,self.playerID,self.name)
    lua_bridge:startDownloadImg(props.photo,self.view:getHeadNode())			-- wind 容易引起self.view:getHeadNode() CRASH
    local broadcast_node = self:getPart("BroadcastPart")
    if broadcast_node then
    	broadcast_node:activate(self.game_id,self.view.node.broadcast_node)
    end
    
    local ad_part = self:getPart("AdPart")
    if ad_part then --新版代码，轮播图的协议处理全部由自己内部处理
        ad_part:activate(self.game_id,self.view.node.rank_node)
    end

    local ntfUploadLogPart = self:getPart("NtfUploadLogPart")
    if ntfUploadLogPart then
    	ntfUploadLogPart:activate(self.game_id)
	end

    self.customListenerFg = cc.EventListenerCustom:create("magicWindowWakeUp", function()
        self:checkMWStat()
    end)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(self.customListenerFg, 1)

    self.http_manager = HttpClientManager:new()
    self.http_manager:registerScriptHandler(handler(self,LobbyPart.onHttpResponse))

   	self.dh_key = ""
   	self.dh_url = ""
   	self:getConfigFromServer()
end

function LobbyPart:registerMsgListener(net_mode) 
	local partId = self:getPartId()
	net_mode:registerMsgListener(LobbyPart.CMD.MSG_GAME_OTHERLOGIN_ACK,handler(self,LobbyPart.otherLogin)) 
	net_mode:registerMsgListener(LobbyPart.CMD.MSG_REQUEST_START_GAME_ACK,handler(self,LobbyPart.onEnterRoomAck))
	net_mode:registerMsgListener(LobbyPart.CMD.MSG_GAME_SEND_SCROLL_MES,handler(self,LobbyPart.scrollMsgAck),partId)
	net_mode:registerMsgListener(LobbyPart.CMD.MSG_SYSTEM_NOTIFY_MSG,handler(self,LobbyPart.notifyMsgAck))
	net_mode:registerMsgListener(LobbyPart.CMD.MSG_GET_GAME_CONFIG_RSP,handler(self,LobbyPart.msgGameConfigRsp))
	net_mode:registerMsgListener(LobbyPart.CMD.MSG_GAME_UPDATE_PLAYER_PROPERTY,handler(self,LobbyPart.updatePlayerProperty)) --更新玩家信息 没有操作
	net_mode:registerMsgListener(LobbyPart.CMD.MSG_LOGIC_SERVER_FAKE_DEATH,handler(self,LobbyPart.onServerError))
	net_mode:registerMsgListener(LobbyPart.CMD.MSG_GET_DH_CONFIG_RSP,handler(self,LobbyPart.onGetConfigFromServer), partId)
	--net_mode:registerMsgListener(LobbyPart.CMD.MSG_GET_LUNBOTU_RSP,handler(self,LobbyPart.onGetAdImgUrllist))  --v2.0轮播图已经内部处理
end

--服务器下发红包回掉
function LobbyPart:createRedPacketRsp(data)
	self.redpacket_part = self:getPart("RedpacketTipsPart")
    local createRedPacket_resp = RedPacketMessage_pb.SendRedPacketMsg()
    createRedPacket_resp:ParseFromString(data)
    if createRedPacket_resp.resultCode == 200 then
		if self.redpacket_part then
			global:setRedPacket(createRedPacket_resp)--缓存
			self.redpacket_part:activate(self.game_id,createRedPacket_resp)
			global:clearRedPacket()--清空
		end
	end
end

function LobbyPart:cacheCreateRedpacket(data)
	if data and data.gameId == self.game_id then
		self.redpacket_part = self:getPart("RedpacketTipsPart")
		if self.redpacket_part then
				self.redpacket_part:activate(self.game_id,data)
				global:clearRedPacket()--清空
		end
	end
end

--拆红包消息返回
function LobbyPart:SplitRedPacketRsp(data)
    -- body 解析package
    local openRedPacket_resp = RedPacketMessage_pb.OpenRedPacketRspMsg()
    openRedPacket_resp:ParseFromString(data)
    if openRedPacket_resp.resultCode == 200 then  --success
        if self.redpacket_part ~= nil then
            self.redpacket_part:onClose()
            self.redpacket_part = nil
        end
        local rewardtips_part = self:getPart("RewardTipsPart")
        if rewardtips_part then
            rewardtips_part:activate(self.game_id,openRedPacket_resp)
        end
    end
end

function LobbyPart:QueryRedPacketRspMsg(data)
    local queryRedPacket_resp = RedPacketMessage_pb.QueryRedPacketRspMsg()
    queryRedPacket_resp:ParseFromString(data)
    
    if queryRedPacket_resp.resultCode == 200 then  --success
        --查询红包信息成功
        local hasRedpacket = false
        for _,k in ipairs(queryRedPacket_resp.redPackets) do
            if k.packetStatus ~= 2 then
                hasRedpacket = true
                break
            end
        end
        
        if self.view ~= nil then
            self.view:showRedPacket(true,hasRedpacket)
        end
        
    elseif queryRedPacket_resp.resultCode == 512 then
        --沒有紅包活動
        if self.view ~= nil then
            self.view:showRedPacket(false,false)
        end
    end
end

--查询红包
function LobbyPart:onQueryRedPacketReqMsg()
    local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    local opt_msg = RedPacketMessage_pb.QueryRedPacketReqMsg()
    local user = global:getGameUser()
    local props = user:getProps()
    local game_info = props["gameplayer" .. self.game_id]

    opt_msg.userId = tonumber(game_info.playerIndex)
    --opt_msg.opid = RoomConfig.GAME_OPERATION_PLAYER_LEFT_TABLE
    opt_msg.playerName = props.name
    opt_msg.gameId = tostring(self.game_id)

    net_mode:sendProtoMsg(opt_msg,LobbyPart.CMD.QUERY_RED_PACKET_REQ_MSG,self.game_id)
end

function LobbyPart:deactivate()
	local partId = self:getPartId()
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:unRegisterMsgListener(LobbyPart.CMD.MSG_GAME_OTHERLOGIN_ACK)
	net_mode:unRegisterMsgListener(LobbyPart.CMD.MSG_GET_GAME_CONFIG_RSP)
	net_mode:unRegisterMsgListener(LobbyPart.CMD.MSG_GAME_SEND_SCROLL_MES,partId)
	net_mode:unRegisterMsgListener(LobbyPart.CMD.MSG_LOGIC_SERVER_FAKE_DEATH)
	net_mode:unRegisterMsgListener(LobbyPart.CMD.MSG_GET_DH_CONFIG_RSP)
	--net_mode:unRegisterMsgListener(LobbyPart.CMD.MSG_REQUEST_START_GAME_ACK)

	if self.customListenerFg then
		cc.Director:getInstance():getEventDispatcher():removeEventListener(self.customListenerFg)
		self.customListenerFg = nil
	end

	-- if self.http_manager then
	-- 	self.http_manager:unregisterScriptHandler()
	-- 	self.http_manager = nil
	-- end 

	
	if self.view == nil then
		return
	else
		self.view:removeSelf()
		self.view =  nil
	end
end

function LobbyPart:checkMWStat()
	print("lobby part checkMWStat")
	local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
	if lua_bridge:getMWLobbyStatus() then
	    --可以唤醒进入房间
		local roomId = tonumber(lua_bridge:getMWRoomID())
		local gameId = tonumber(lua_bridge:getMWGameID())
		print("lobby part activate auto join room id:" .. roomId .. ";" .. gameId)
	    self:reconnectRequest(gameId,gameId)
	end
end

function LobbyPart:unRegisterMsgListenerRp()
    local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    net_mode:unRegisterMsgListener(LobbyPart.CMD.CREATE_RED_PACKET_RSP_CMD,"LobbyPart")
    net_mode:unRegisterMsgListener(LobbyPart.CMD.SPLIT_RED_PACKET_RSP_CMD,"LobbyPart")
    net_mode:unRegisterMsgListener(LobbyPart.CMD.QUERY_RED_PACKET_RSP_MSG,"LobbyPart")
    net_mode:unRegisterMsgListener(LobbyPart.CMD.MATCH_BATTLE_BEGIN_MSG, 'LobbyPart')
end

function LobbyPart:registerMsgListenerRp()
    local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
    net_mode:registerMsgListener(LobbyPart.CMD.CREATE_RED_PACKET_RSP_CMD,handler(self,LobbyPart.createRedPacketRsp),"LobbyPart")
    net_mode:registerMsgListener(LobbyPart.CMD.SPLIT_RED_PACKET_RSP_CMD,handler(self,LobbyPart.SplitRedPacketRsp),"LobbyPart")
    net_mode:registerMsgListener(LobbyPart.CMD.QUERY_RED_PACKET_RSP_MSG,handler(self,LobbyPart.QueryRedPacketRspMsg),"LobbyPart")
    net_mode:registerMsgListener(LobbyPart.CMD.MATCH_BATTLE_BEGIN_MSG, handler(self, LobbyPart.MatchNotify))
end

--红包管理界面
function LobbyPart:ClickRedPacketEvent()
	-- body
	local redmgr_part = self:getPart("RedpacketMgrPart")
	if redmgr_part then
		redmgr_part:activate(self.game_id)
	end
end

--服务器繁忙
function LobbyPart:onServerError(data,gameID)
	-- body
	local tips_part = global:createPart("TipsPart",self)
	if tips_part then
		tips_part:activate({
			info_txt=string_table.server_is_busy})
	end	
end

function LobbyPart:getPartId()
	-- body
	return "LobbyPart"
end

function LobbyPart:noticeClick() --激活通知部件
	-- body
	local notice_part = self:getPart("NoticePart")
	if notice_part then
		notice_part:activate(self.game_id)
	end
end

--更新玩家属性
function LobbyPart:updatePlayerProperty(data,appId)
	 local player_property = comm_struct_pb.UpdatePlayerPropertyMsg()
	 player_property:ParseFromString(data)
	 print("this is update player property :", player_property)

	 local user = global:getGameUser()
	 local player_info = user:getProp("gameplayer" .. self.game_id)

	 player_info.gold = player_property.gold
	 player_info.diamond = player_property.diamond
	
	 user:setProp("gameplayer" .. self.game_id,player_info)
	 local props = user:getProps()
     self.view:updateUserInfo(user:getProps(),props["gameplayer" .. self.game_id])
end

function LobbyPart:helpClick()
	-- body
	local help_part = self:getPart("HelpPart")
	if help_part then
		help_part:activate(self.game_id)
	end
end

function LobbyPart:recordClick()
	-- body
	 local record_part = self:getPart("BattlePart")
	 if record_part then
	 	record_part:activate(self.game_id,self.name)
	 end
end

function LobbyPart:startRecrod(code, data, ext_data)
	local RecordMainPart = self:getPart('RecordMainPart')
	if RecordMainPart then
		RecordMainPart:activate(self.game_id, data, ext_data)
	else
		-- @ todo
		print('load_record_data error code, data', code, data)
	end
end

function LobbyPart:startMatch(cpt_info, tableinfo)
	local match_match_part = self:getPart('MatchMainPart')
	if match_match_part then
		self:deactivate()
		match_match_part:activate(self.game_id, tableinfo, cpt_info)
	end
end

function LobbyPart:matchClick()
	local select_match_part = self:getPart('SelectMatchPart')
	if select_match_part then
		select_match_part:activate(self.game_id)
	end
	--self:showUnopenTips()
end

--zhongqy

function LobbyPart:settingsClick()
	-- body
	local settings_part = self:getPart("SettingsPart")
	if settings_part then
		settings_part:activate(self.game_id)
		settings_part:setSwitch3DEnable(true)
	end
end

function LobbyPart:shareClick()
	-- body
	local title = string_table.game_title_yi_chang
	local bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
	local shareContent = string_table.wx_one_friend
	local shareUrl = string_table.share_weixin_android_url
	--分享内容和分享链接都是从服务器上拉取的

	local user = global:getGameUser()
    local props = user:getProps()
    local gameConfigList = props["gameplayer" .. self.game_id].gameConfigList

    for i,v in ipairs(gameConfigList) do
		local gameParam = gameConfigList[i]
		print("paraid,valueInt->",gameParam.paraId,gameParam.valueInt)
		if gameParam.paraId == ClientParamConfig.WEIXIN_SHARE_CONTENT then
			if gameParam.valueStr then
				shareContent = gameParam.valueStr --分享内容
			end
		end

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
		else --windows
			if gameParam.paraId == ClientParamConfig.WEIXIN_SHARE_URL_ANDROID then
				if gameParam.valueStr then
					shareUrl = gameParam.valueStr --分享链接
				end
			end
		end
	end

	print("shareContent,shareUrl->",shareContent,shareUrl)

	bridge:ShareToWX(1,shareContent,shareUrl)
end

function LobbyPart:headClick()
	-- body
	local user = global:getGameUser()
	local recommender_Id = user:getProp("recommender_Id"..self.game_id)
	local recommenderId = recommender_Id.recommenderId
	local type = ""
	if recommenderId == 0 then
		type = nil
	else
		type = "apply_agency"
	end
	local user_info_part = self:getPart("UserInfoPart")
	if user_info_part then
		user_info_part:activate(self.game_id,type)
	end
end

function LobbyPart:addZuan()
	-- body
	self:shopClick()
end

function LobbyPart:createRoomClick()
	-- body
	self.cur_select_btn = 1
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local req_enter_room = ReqStartGame_pb.ReqStartGame()
	req_enter_room.roomid = 2002
	req_enter_room.gametype = 1
	req_enter_room.supportReadyBeforePlaying = 2
	req_enter_room.psw = "1" --信阳罗山玩法用于做兼容性的临时方案
	self:startLoading()
	net_mode:sendProtoMsg(req_enter_room,LobbyPart.CMD.MSG_REQUEST_START_GAME,SocketConfig.GAME_ID)
end

--加入房间
function LobbyPart:addRoomClick()
	self.cur_select_btn = 2
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local req_enter_room = ReqStartGame_pb.ReqStartGame()
	req_enter_room.roomid = 2002
	req_enter_room.gametype = 1
	req_enter_room.supportReadyBeforePlaying = 2
	req_enter_room.psw = "1" --信阳罗山玩法用于做兼容性的临时方案
	self:startLoading()
	net_mode:sendProtoMsg(req_enter_room,LobbyPart.CMD.MSG_REQUEST_START_GAME,SocketConfig.GAME_ID)
end

--首先进行重连判断如果没有重连就进入子游戏大厅
function LobbyPart:reconnectRequest(reconnectFlag,gameId)
	-- body
	self.game_id = gameId
	print("this is ziyouxi reconnect -----------------------------------------------")
    local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
	if IOS_BACK_DELAY == false then
		IOS_BACK_DELAY = true
		
		lua_bridge:setBackDelayTime(30000)
	end
	lua_bridge:changeActivityOrientation(1) 
	
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:enableSeq(true)        	--是否开启双序号 true 开启 false 关闭  
	self:registerMsgListener(net_mode) 
	--self:startLoading()
    self.reconnect_flag = reconnectFlag
	local req_enter_room = ReqStartGame_pb.ReqStartGame()
	req_enter_room.roomid = 2002
	req_enter_room.gametype = 1
	req_enter_room.supportReadyBeforePlaying = 2
	req_enter_room.psw = "1" --信阳罗山玩法用于做兼容性的临时方案
	net_mode:sendProtoMsg(req_enter_room,LobbyPart.CMD.MSG_REQUEST_START_GAME,self.game_id)
end


--金币场
function LobbyPart:creatNewPlayerGame()
	self:startLoading()
	if RoomConfig.Ai_Debug then
		local data = {result= 0,
					tableinfo ={
					    tablepos= 0,
					    currenthand= 0,
					    viptableid= 0,
					    creatorname="" ,
					    totalhand= 0,
					    playwaytype= 5,
					    players={
					        canfrind= 0,
					        intable= 1,
					        vipoverdata= {
					            gangcount= 0,
					            zhuangcount= 0,
					            wincount= 0,
					            dianpaocount= 0,
					            hithorsecount= 0,
					        	},
					        uid= "390A4AE35DF844279047691FC48896C8",
					        name= "鹅鹅鹅鹅",
					        gamestate= 1,
					        headImg= 4,
					        headImgUrl= "",
					        sex= 0,
					        coin= 99620,
					        tablepos= 0,
					        desc= "",
					        fan= 0,
					        gameresult= 0,
					        ip= "192.168.1.178",
					    	},
					    roomid= 2004
						}
					}
		self:enterRoom(data)
	else
		local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
		local req_enter_room = ReqStartGame_pb.ReqStartGame()
		if self.game_id == 0x10101 then
			req_enter_room.roomid = 2004
		else
			req_enter_room.roomid = 2005
		end
		req_enter_room.gametype = 1
		req_enter_room.supportReadyBeforePlaying = 2
		req_enter_room.psw = "1" --信阳罗山玩法用于做兼容性的临时方案
		net_mode:sendProtoMsg(req_enter_room,LobbyPart.CMD.MSG_REQUEST_START_GAME,self.game_id)
	end
end

--加入房间
function LobbyPart:friendGameClick()
	-- body
	self.cur_select_btn = 2
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local req_enter_room = ReqStartGame_pb.ReqStartGame()
	req_enter_room.roomid = 2002
	req_enter_room.gametype = 1
	req_enter_room.supportReadyBeforePlaying = 2
	req_enter_room.psw = "1" --信阳罗山玩法用于做兼容性的临时方案
	net_mode:sendProtoMsg(req_enter_room,LobbyPart.CMD.MSG_REQUEST_START_GAME,self.game_id)
end

function LobbyPart:onEnterRoomAck(data,appID) 
	-- 这里要根据游戏类型跳转到不同的游戏进行处理
	self:endLoading()
	local enter_room_ack = StartGameMsgAck_pb.StartGameMsgAck()
	enter_room_ack:ParseFromString(data)
	print("###[LobbyPart:onEnterRoomAck] this is enter room ack:",enter_room_ack)
		--@ 如果在赛事中
	local cpt_ack = enter_room_ack.tableinfo.Extensions[competition_pb.StartGameMsgAckExt.cptExt]
	if cpt_ack and cpt_ack.player_position == 2 then
		self:startMJByMatch(cpt_ack, enter_room_ack)
		return 
	end

	if enter_room_ack.result == SocketConfig.MsgResult.GOLD_LOW_THAN_MIN_LIMIT then -- 金币低于下限
		local tips_part = global:createPart("TipsPart",self)
		if tips_part then
			tips_part:activate({info_txt=string_table.gold_low})
		end
	elseif enter_room_ack.result == SocketConfig.MsgResult.GOLD_HIGH_THAN_MAX_LIMIT then -- 金币超过上限
	elseif enter_room_ack.result == SocketConfig.MsgResult.CAN_ENTER_VIP_ROOM then -- 可以进入VIP房间
    	local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
        if lua_bridge:getMWLobbyStatus() then
            lua_bridge:setMWStatus(false)
            --可以唤醒进入房间
    		local roomId = tonumber(lua_bridge:getMWRoomID())
    		local gameId = tonumber(lua_bridge:getMWGameID())
			print("auto join room id:" .. roomId .. ";" .. gameId)
            self:askEnterRoom(roomId)
        else
			if self.reconnect_flag then --异常容错，正常情况，有重连标记就应该重连进入房间，如果服务端数据错误，保证还很显示大厅
				global:exitLobby()
				self:activate(self.game_id)
			elseif self.cur_select_btn == 1 then
				self:createRoom()
			elseif self.cur_select_btn == 2 then
				self:addRoom()
			end
        end
	elseif enter_room_ack.result == SocketConfig.MsgResult.VIP_TABLE_IS_FULL then -- vip桌 子已经满座了
		local tips_part = global:createPart("TipsPart",self)
		if tips_part then
			tips_part:activate({info_txt=string_table.vip_table_is_full})
		end
	elseif enter_room_ack.result == SocketConfig.MsgResult.VIP_TABLE_IS_GAME_OVER then -- 正在游戏中不能进入其他房间
		local tips_part = global:createPart("TipsPart",self)
		if tips_part then
			tips_part:activate({info_txt=string_table.vip_table_is_over})
		end
	elseif enter_room_ack.result == SocketConfig.MsgResult.IS_PLAYING_CAN_NOT_ENTER_ROOM then -- 正在游戏中不能进入其他房间
		local tips_part = global:createPart("TipsPart",self)
		if tips_part then
			tips_part:activate({info_txt=string_table.is_playing_cannot_enter})
		end
	elseif enter_room_ack.result == SocketConfig.MsgResult.TODAY_GAME_RECORD_OUT_LIMIT_IN_ROOM then -- 今日输赢超过房间上限
		local tips_part = global:createPart("TipsPart",self)
		if tips_part then
			tips_part:activate({info_txt=string.format(string_table.room_record_out_limit,enter_room_ack.gold)})
		end
	elseif enter_room_ack.result == SocketConfig.MsgResult.TODAY_GAME_RECORD_OUT_LIMIT_IN_GAME then -- 今日输赢超过游戏上限
		local tips_part = global:createPart("TipsPart",self)
		if tips_part then
			tips_part:activate({info_txt=string.format(string_table.game_record_out_limit,enter_room_ack.gold)})
		end
	elseif enter_room_ack.result == SocketConfig.MsgResult.VIP_TABLE_NOT_FOUND then -- 桌子未找到
		-- local add_room_part = self:getPart("AddRoomPart")
		-- if add_room_part then
		-- 	add_room_part:deactivate()
		-- end
		local tips_part = global:createPart("TipsPart",self)
		if tips_part then
			tips_part:activate({info_txt=string_table.room_id_wrong})
		end
	elseif enter_room_ack.result == SocketConfig.MsgResult.FANGKIA_NOT_FOUND then --钻石不足
		local tips_part = global:createPart("TipsPart",self)
		if tips_part then
			tips_part:activate({info_txt=string_table.fangka_not_found})
		end
	elseif enter_room_ack.result == SocketConfig.MsgResult.VIP_TABLE_ASK_OK then 
		self:askTableInfo(enter_room_ack)
	elseif enter_room_ack.result == SocketConfig.MsgResult.CMD_EXE_OK then --进入房间
		self:enterRoom(enter_room_ack)
	elseif enter_room_ack.result == SocketConfig.MsgResult.GROUP_CREATEROOM then
		print("群主创建房间")
		local createRoomPart = self:getPart("CreateRoomPart")
		createRoomPart:requestCurrentList() 
	end
end

function LobbyPart:startMJByMatch(cpt_ack, data)
	local cptUniqId			= cpt_ack.position_id
	local query_ack 		= cpt_ack.cptInfo

	--@1、已报名准备区；2、淘汰赛准备区；3、八强赛准备区; 4、决赛准备区
	local state  	= query_ack.state
	local roundNum 	= query_ack.roundNum
	local totalScore= query_ack.totalScore

	local championAwards = {}
	local cpt_info 	= query_ack.cptInfo

	local championAward = {}
	for i,award in ipairs(cpt_info.championAward.rewardItem) do
		local award_temp = {
			rewardType	= award.rewardType,
			rewardCount	= award.rewardCount,
		}
		table.insert(championAward, award_temp)
	end

	local entrys 		= {}
	local info 			= query_ack.cptInfo
	local entrys_temp	= query_ack.cptInfo.cptEntryInfo
	for i, entry in ipairs(entrys_temp) do
		local entry_node= {
			entryIconType 	= entry.entryIconType,
			entryIconCount	= entry.entryIconCount,
		}
		table.insert(entrys, entry_node)
	end

	--@ table_node
	self.cpt_info 		= {
		cptId 			= info.cptId,
		cptNameCode		= info.cptNameCode,
		cptSize 		= info.cptSize,
		cptJoinNum		= info.cptJoinNum,
		cptBeginTime 	= info.cptBeginTime,
		cptEndTime 		= info.cptEndTime,
		cptTitle 		= info.cptTitle,
		cptRule 		= info.cptRule,
		lastAction		= info.lastAction,
		championAward	= championAward or {},
		cptEntryInfo	= entrys or {},
		state 			= query_ack.state,
		roundNum		= query_ack.roundNum,
		totalScore		= query_ack.totalScore,
		cptUniqId 		= cptUniqId,
		curTime			= os.time(),
		remainTime		= info.cptEndTime,
	}

	self.tableinfo 			= data.tableinfo
	self:startMatch(self.cpt_info, data or {})
end

--进入房间
function LobbyPart:enterRoom(data)
	local function startVipRoom()
		local table_part = self:getPart("NormalTablePart")

		local use3d = cc.UserDefault:getInstance():getBoolForKey("key_use3d", true)
		if use3d then
			table_part = self:getPart("TablePart")
		end

		if table_part then
			self:deactivate()
			table_part:activate(self.game_id,data)
		end
	end

	local cpt_ack 			= data.tableinfo.Extensions[competition_pb.StartGameMsgAckExt.cptExt]
	if not cpt_ack then
		--@ 在vip房间
		startVipRoom()
		return 
	end

	local player_position	= cpt_ack.player_position
	if player_position ~= 2 then
		--@ 在vip房间
		startVipRoom()
		return 
	end

	self:startMJByMatch(cpt_ack)
end

--[[
@ 查询玩家状态信息 
]]
function LobbyPart:queryCptInfo(cptUniqId)
	local request 			= competition_pb.queryPlayerCptInfo()
	request.cptUUId			= cptUniqId	
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:sendProtoMsg(request, self.CMD.CPT_QUERY_PLAYER_INFO, self.game_id)
	self:startLoading()
end

--[[
@ 查询玩家信息返回
]]
function LobbyPart:queryCptInfoAck(data)
	self:endLoading()
	local query_ack = competition_pb.queryPlayerCptInfoAck()
	query_ack:ParseFromString(data)



	
end

--创建房间
function LobbyPart:createRoom()
	local create_room_part = self:getPart("CreateRoomPart")
	if not create_room_part.view then --TODO ： 临时做法，为了解决创建房间页面弹出来两次的问题，需要改进
		create_room_part:activate(self.game_id)
	end
end

function LobbyPart:addRoom()
	-- body
	local add_room_part = self:getPart("AddRoomPart")
	add_room_part:activate(self.game_id,1)
end

function LobbyPart:backEvent()
	-- body
	local tips_part = global:createPart("TipsPart",self)
	if tips_part then
		tips_part:activate({info_txt=string_table.isExitGame,left_click = function()
			-- body
			cc.Director:getInstance():endToLua()
		end})
	end
end

function LobbyPart:scrollMsgAck(data,appId)		--跑马灯消息
	-- body
	local net_manager = global:getModuleWithId(ModuleDef.NET_MOD)
	local scroll_msg = wllobby_message_pb.ScrollMsg()
	scroll_msg:ParseFromString(data)
	print("----scrollMsgAck appId : ",appId)
	print("----scrollMsgAck : ",scroll_msg)
	
	local msg = scroll_msg.msg
	local loopNum = scroll_msg.loopNum
	local removeAll = scroll_msg.removeAll

	local broadcast_node = self:getPart("BroadcastPart")
	broadcast_node:startBroadcast(msg,loopNum,removeAll,false,appId)
end


function LobbyPart:notifyMsgAck(data,appId)		--系统消息
	-- body
	local net_manager = global:getModuleWithId(ModuleDef.NET_MOD)
	local notify_Msg = wllobby_message_pb.SystemNotifyMsg()
	notify_Msg:ParseFromString(data)
	print("----scrollMsgAck : ",notify_Msg)
end


function LobbyPart:exitRequest()
	-- body
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:sendMsg("",0,LobbyPart.CMD.MSG_EXIT_GAME_LOBBY,self.game_id)
end

--返回合集大厅
function LobbyPart:returnLobby()
	-- body
	self:exitRequest()
	self:deactivate()
	package.loaded[PART_CONFIG] = nil --清空配置信息
    require(PART_CONFIG) 
	local hj_lobby_part = global:createPart(PartConfig.MainLobby,global:getGameUser())
	if hj_lobby_part then
		hj_lobby_part:activate(LOBBY_GAME_ID)
	end
end

function LobbyPart:startLoading()
	-- body
	if self.view then
		local loading_part = global:createPart("LoadingPart",self)
		self:addPart(loading_part)
		loading_part:activate(self.game_id)
	end
end

function LobbyPart:endLoading()
	-- body
	if self.view then
		local loading_part = self:getPart("LoadingPart")
		if loading_part then
			loading_part:deactivate()
		end
	end
end

function LobbyPart:agentClick()
	self:getAgenConfig(1)
end

function LobbyPart:updatePlayerProperty(data,appId)
	 local player_property = comm_struct_pb.UpdatePlayerPropertyMsg()
	 player_property:ParseFromString(data)
	 print("this is update player property :", player_property)

	 local user = global:getGameUser()
	 local player_info = user:getProp("gameplayer" .. self.game_id)

	 player_info.gold = player_property.gold
	 player_info.diamond = player_property.diamond
	
	 user:setProp("gameplayer" .. self.game_id,player_info)
	 local props = user:getProps()
     self.view:updateUserInfo(user:getProps(),props["gameplayer" .. self.game_id])
end


function LobbyPart:shopClick() --点击商城
	if ISAPPSTORE then
		local purchase_part = self:getPart("PurchasePart")
		if purchase_part then
			purchase_part:activate(self.game_id)
		end
		return
	end

	self:getAgenConfig(3)
end

function LobbyPart:getAgenConfig(flag)
 	self.bind_agen = flag
 	self:startLoading()
 	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
 	local apply_agency_req = hjlobby_message_pb.GetGameConfigReq()
 	apply_agency_req.type = 4
 	net_mode:sendProtoMsg(apply_agency_req,SocketConfig.MSG_GET_GAME_CONFIG_REQ,SocketConfig.GAME_ID)
 end

function LobbyPart:msgGameConfigRsp(data)
	-- body
	self:endLoading()
	local get_game_config_rsp = hjlobby_message_pb.GetGameConfigRsp()
	get_game_config_rsp:ParseFromString(data)
	print("lobby_rsp :　",get_game_config_rsp,self.bind_agen)

	local url = get_game_config_rsp.msg[2] --"http://dltest.xiaoxiongyouxi.com:81"
	local width =  get_game_config_rsp.msg[3]
	local height =  get_game_config_rsp.msg[4]
	local keyword =  get_game_config_rsp.msg[5]
	local inputParam = get_game_config_rsp.msg[6]


	local user = global:getGameUser()
 	local uid = user:getProp("uid")
 	local logintime = os.time() 							     --时间戳
 	local sign = md5.sumhexa(keyword .. logintime .. uid)	     --签名md5加密
 	local time_uid = "&logintime=" .. logintime.. "&uid="..uid
 	if self.bind_agen == 2 then --绑定代理
 		local webviewpart = self:getPart("WebViewPart")
 		if webviewpart then
 			url = url.."?gid="..SocketConfig.GAME_ID.."&r=wx/route&url=bind-member&sign="..sign..time_uid
 			print("加了签名的url1 ： ",url)
 			webviewpart:activate(0,url,keyword,inputParam)
 			webviewpart:setTransprent(false)   
 		end
 	elseif self.bind_agen == 1 then --代理后台
 		local webviewpart = self:getPart("WebViewPart")
 		if webviewpart then
 			url = url.."?gid="..SocketConfig.GAME_ID.."&r=wx/route&url=index&sign="..sign..time_uid
 			print("加了签名的url2 ： ",url)
 			webviewpart:activate(0,url,keyword,inputParam)
 			webviewpart:setTransprent(false)
 		end
 	elseif self.bind_agen == 3 then --点击商城
 		local purchase_part = self:getPart("PurchasePart")
 		if purchase_part then
 			purchase_part:activate(self.game_id)
 			if purchase_part.view then
				local user = global:getGameUser()
			 	local props = user:getProps()
			    local playerInfo = props["gameplayer" .. self.game_id]
				purchase_part.view:setDiamond(playerInfo.diamond)
				purchase_part.view:setCoin(playerInfo.gold)
			end
 		end
 	end
end

function LobbyPart:askEnterRoom(roomid)
	print("LobbyPart:askEnterRoom : ", roomid)
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local enter_vip_room = ReqStartGame_pb.ReqStartGame()
	enter_vip_room.roomid = roomid
	enter_vip_room.gametype = 1
	enter_vip_room.tableid = "enter_room"
	enter_vip_room.supportReadyBeforePlaying = 2
	enter_vip_room.psw = "1" --信阳罗山玩法用于做兼容性的临时方案
	net_mode:sendProtoMsg(enter_vip_room,LobbyPart.CMD.MSG_ENTER_VIP_ROOM,self.game_id)
end

function LobbyPart:activeFankuiPart()
	local fankui_part = self:getPart("FankuiPart")
	if fankui_part then
		fankui_part:activate(self.game_id)
	end
end

function LobbyPart:showUnopenTips()
	local tips_part = global:createPart("TipsPart",self)
	if tips_part then
		tips_part:activate({info_txt=string_table.opening_soon_txt})
	end
end

function LobbyPart:askTableInfo(data) 
	print("###[LobbyPart:askTableInfo]")
	local tableInfo = data.tableinfo 
	if tableInfo.payType == 1 then
		print("###[LobbyPart:askTableInfo]打开AA支付对话框")
		self:createJoinRoomTips(tableInfo) 
	else
		self:askEnterRoom(tableInfo.viptableid)
	end 
end

function LobbyPart:createJoinRoomTips(tableInfo)
	local callback = function(ret)  
		if ret then
			self:askEnterRoom(tableInfo.viptableid)
		else
			local joinPart = self:getPart("AddRoomPart")
			if nil ~= joinPart then
				joinPart:deactivate()
			end
		end
	end
	 
	-- local playWayStr = ""
	-- local playWay1 = tableInfo.playwaytype
	-- for k,v in pairs(RoomConfig.Rule) do 
	-- 	if bit._and(playWay1,v.value) == v.value and 0 ~= v.value then
	-- 		playWayStr = v.name
	-- 		break
	-- 	end
	-- end  

	-- local playWayStr2 = "" 
	-- for k,v in pairs(RoomConfig.Rule2) do 
	-- 	if bit._and(playWay1,v.value) == v.value and 0 ~= v.value then  
	-- 		playWayStr2 = playWayStr2 ~= "" and playWayStr2 ..","..v.name or v.name 
	-- 	end
	-- end  
	-- playWayStr2 = playWayStr2 ~= "" and "("..playWayStr2..")" or "" 

	local needDiamond = self:getNeedDiamond(tableInfo.totalhand, 1)

	local contentStr = string.format("当前进入的是四人支付模式,您需要支付%d钻石进入游戏", needDiamond)
	print("###[LobbyPart:askTableInfo] contentStr is ",contentStr)

	local tips_part = global:createPart("TipsPart",self)
	if tips_part then
		tips_part:activate({
			info_txt = contentStr,
			left_click = function() 
				callback(true) 
			end,
			right_click = function()
				callback(false)
			end,tipType=1})
	end
end

local function isCostConfigId(id)
	return 7001 == id
		or 7002 == id
		or 7003 == id
		or 7004 == id
end

function LobbyPart:getNeedDiamond(quanCount, payType)
	local user = global:getGameUser()
    local props = user:getProps()
    local gameConfigList = props["gameplayer" .. SocketConfig.GAME_ID].gameConfigList
    local costDiamond = 1
    for i,v in ipairs(gameConfigList) do
		local gameParam = gameConfigList[i]
		print("gameParam.paraId,gameParam.valueInt,gameParam.pro1->",gameParam.paraId,gameParam.valueInt,gameParam.pro1)
		if isCostConfigId(gameParam.paraId) then
			if quanCount == gameParam.valueInt then
				costDiamond = (gameParam.pro1 and gameParam.pro1 or 0)
				break
			end
		end
	end
	if costDiamond == 1 and type == 4 then
		print("###[LobbyPart:getNeedDiamond] costDiamond == 1 and type == 4 ")
		costDiamond = 16
	end
	if payType == 1 then
		costDiamond = costDiamond / 4
	end
	return costDiamond
end

function LobbyPart:showTips(tips)
    local delay_time = cc.DelayTime:create(1)
	local call_func = cc.CallFunc:create(function()
        local tips_part = global:createPart("TipsPart",self)
        if tips_part then
            tips_part:activate({info_txt=tips})
        end
        global:setShareState(false)
        global:setShareRedPacketState(false)
	end)

	local seq = cc.Sequence:create(delay_time,call_func)
	self.view.node.bg:runAction(seq)

end

function LobbyPart:onEnter()
    self:registerMsgListenerRp()
    self.customListenerFg = cc.EventListenerCustom:create("shareCircleFriendSucess", function()
        --self:showTips("请去朋友圈中领取红包奖励")
        if global:getShareRedPacketState() then
	        global:setShareState(true)
	        if global:getShareState() ~= nil and global:getShareState() then
	            self:showTips("请去朋友圈中领取红包奖励")
	        end
	    end
    end)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(self.customListenerFg, 1)
    
    self.customListenerRp = cc.EventListenerCustom:create("hideredpoint", function()
        self.view:showRedPacket(true,false)
    end)
    if global:getShareState() ~= nil and global:getShareState() then
    	self:showTips("请去朋友圈中领取红包奖励")
   	end
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(self.customListenerRp, 1)
    self:cacheCreateRedpacket(global:getRedPacket())
end

function LobbyPart:onExit()
    self:unRegisterMsgListenerRp()
    cc.Director:getInstance():getEventDispatcher():removeEventListener(self.customListenerFg)
    cc.Director:getInstance():getEventDispatcher():removeEventListener(self.customListenerRp)
    self.customListenerFg = nil
    self.customListenerRp= nil
    
end

function LobbyPart:MatchNotify(data)
	local match_notify = competition_pb.commNotify()
	match_notify:ParseFromString(data)

	-- @ 防止服务器重复推送
	if self.tips_part then
		self.tips_part:deactivate()
	end
	self.tips_part = global:createPart("TipsPart",self)
	if self.tips_part then
		self.tips_part:activate({info_txt=match_notify.tips})
		self.tips_part:notScroll()
	end
end

function LobbyPart:showDuihuanMainLayer()
	local duihuan_part = self:getPart("DuihuanPart",self)
	if duihuan_part then
		duihuan_part:activate()
	end
end

--设置页面点击兑换码按钮回调
function LobbyPart:onDuihuanClick()
	self:showDuihuanMainLayer()
end

function LobbyPart:sendDhCode(code)
	if (not code) or (code == "") then
		local tips_part = global:createPart("TipsPart",self)
		if tips_part then
			tips_part:activate({
				info_txt=string_table.no_empty_dhcode})
		end

		local duihuan_part = self:getPart("DuihuanPart",self)
		if duihuan_part then
			duihuan_part:resetSendDhCodeBtn()
		end
		
		return	
	end

	local url = (self.dh_url and self.dh_url ~= "") and self.dh_url or  "http://testhuodong.sparkingfuture.com:58589/"
	url = url .. "cdk/exchange"

	local user = global:getGameUser()
 	local uid = user:getProp("uid")
	local user_default = cc.UserDefault:getInstance()
	local unionid = user_default:getStringForKey(enUserData.WXOPEN_ID, "")
	local key = (self.dh_key and self.dh_key ~= "") and self.dh_key or "testcdkkey"
	self.code = code

    local dataTable = {}
    dataTable.current_time = os.time()
    dataTable.game_id = self.game_id
    dataTable.player_index = uid
    dataTable.cdkey = code
    dataTable.unionid = unionid

    print("XXXXXXXx  dataTable.current_time ", dataTable.current_time)
    print("XXXXXXXx  dataTable.game_id ", dataTable.game_id)
    print("XXXXXXXx  dataTable.player_index ", dataTable.player_index)
    print("XXXXXXXx  dataTable.cdkey ", dataTable.cdkey)
    print("XXXXXXXx  dataTable.unionid ", dataTable.unionid)

    local signData = "cdkey=" .. dataTable.cdkey .. "&current_time=" .. dataTable.current_time .. "&game_id=" .. dataTable.game_id .. "&player_index=" .. dataTable.player_index .. "&unionid=" .. dataTable.unionid
    
	print("XXXXXXXx  signData ", signData)
	print("XXXXXXXx  key ", self.dh_key)

    local sign = md5.sumhexa(signData .. "&key=" .. key)

	print("XXXXXXXx  sign ", sign)

    --dataTable.sign = sign

    local dataStr = signData .. "&sign=" .. string.upper(sign) -- tostring(cjson.encode(dataTable))

    print("AAAAAAAA Data Str ", dataStr)

	self.http_manager:createHttpConnect(url,"send_dh_code",dataStr,string.len(dataStr),1,false)
end


function LobbyPart:sendDuihuanReq(telNum)
	local url = (self.dh_url and self.dh_url ~= "") and self.dh_url or  "http://testhuodong.sparkingfuture.com:58589/"
	url = url .. "cdk/exchange"

	local user = global:getGameUser()
 	local uid = user:getProp("uid")
	local user_default = cc.UserDefault:getInstance()
	local unionid = user_default:getStringForKey(enUserData.WXOPEN_ID, "")
	local key = (self.dh_key and self.dh_key ~= "") and self.dh_key or "testcdkkey"

    local dataTable = {}
    dataTable.current_time = os.time()
    dataTable.game_id = self.game_id
    dataTable.player_index = uid
    dataTable.cdkey = self.code
    dataTable.unionid = unionid
    dataTable.phone = telNum
    dataTable.type = "bill"

    print("XXXXXXXxsendDuihuanReq  dataTable.current_time ", dataTable.current_time)
    print("XXXXXXXxsendDuihuanReq  dataTable.game_id ", dataTable.game_id)
    print("XXXXXXXxsendDuihuanReq  dataTable.player_index ", dataTable.player_index)
    print("XXXXXXXxsendDuihuanReq  dataTable.cdkey ", dataTable.cdkey)
    print("XXXXXXXxsendDuihuanReq  dataTable.unionid ", dataTable.unionid)

    local signData = "cdkey=" .. dataTable.cdkey .. "&current_time=" .. dataTable.current_time .. "&game_id=" .. dataTable.game_id .. "&phone=" .. dataTable.phone .. "&player_index=" .. dataTable.player_index .. "&type=" .. dataTable.type .. "&unionid=" .. dataTable.unionid
    
	print("XXXXXXXxsendDuihuanReq  signData ", signData)

    local sign = md5.sumhexa(signData .. "&key=" .. key)

	print("XXXXXXXxsendDuihuanReq  sign ", sign)

    --dataTable.sign = sign

    local dataStr = signData .. "&sign=" .. string.upper(sign) -- tostring(cjson.encode(dataTable))

    print("AAAAAAAAsendDuihuanReq Data Str ", dataStr)

	self.http_manager:createHttpConnect(url,"send_dh_bill_req",dataStr,string.len(dataStr),1,false)
end


--根据兑换码请求兑换的回调
function LobbyPart:onDuihuanResp(responseData)
	local server_data = cjson.decode(responseData)

	if server_data.code == 0 then --兑换成功
		local typeTab = {gold = 1, diamond = 1, bill = 5, redpack = 6, goods = 4, virtual_good = 4}

		local data = {}
		if server_data.data.shareinfo then
			data.txtType = typeTab.redpack
			data.txtLines = {server_data.msg}
			data.shareInfo = server_data.data.shareinfo
		else
			data.txtType = typeTab[(server_data.data)[1].type]
			data.txtLines = Util.split(server_data.msg, ";") 
		end
		data.btnType = data.txtType

		local left_click
		local right_click
		local mid_click

	    if data.btnType == 1 or data.btnType == 2 then
	        mid_click = function ()
	        	local duihuan_tips_part = self:getPart("DuihuanTipsPart",self)
				if duihuan_tips_part then
					duihuan_tips_part:deactivate()
				end
	        end
	    elseif data.btnType == 3 then
	        mid_click = function (duihuanCode)
	        	local input_right_click = function (telNum)
	        		self:sendDuihuanReq(telNum)
	        	end
				local telnum_input_part = self:getPart("TelNumInputPart",self)
				if telnum_input_part then
					telnum_input_part:activate(self.game_Id, input_right_click)
				end        	
	        end
	    elseif data.btnType == 4 then
	        mid_click = function ()
	        	local duihuan_tips_part = self:getPart("DuihuanTipsPart",self)
				if duihuan_tips_part then
					duihuan_tips_part:deactivate()
				end
	        end
	    elseif data.btnType == 5 then
			left_click = function (duihuanCode)
	        	local input_right_click = function (telNum)
	        		self:sendDuihuanReq(telNum)
	        	end
				local telnum_input_part = self:getPart("TelNumInputPart",self)
				if telnum_input_part then
					telnum_input_part:activate(self.game_Id, input_right_click)
				end        	
	        end
	        right_click = function ()
	        	local duihuan_tips_part = self:getPart("DuihuanTipsPart",self)
				if duihuan_tips_part then
					duihuan_tips_part:deactivate()
				end
	        end
	    elseif data.btnType == 6 then
			left_click = function ()
				local bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
				bridge:shareRedPacketToWxCirleOfFriend(data.shareInfo.title,data.shareInfo.content,data.shareInfo.url,"rplogo")
	        end
	        right_click = function ()
	        	local duihuan_tips_part = self:getPart("DuihuanTipsPart",self)
				if duihuan_tips_part then
					duihuan_tips_part:deactivate()
				end
	        end
	    end

	    data.left_click = left_click
	    data.mid_click = mid_click
	    data.right_click = right_click

		local duihuan_tips_part = self:getPart("DuihuanTipsPart",self)
		if duihuan_tips_part then
			duihuan_tips_part:activate(self.game_Id, data)
		end
	else
		local tips_part = global:createPart("TipsPart",self)
		if tips_part then
			tips_part:activate({
				info_txt=server_data.msg})
		end	
	end

	local duihuan_part = self:getPart("DuihuanPart",self)
	if duihuan_part then
		duihuan_part:resetSendDhCodeBtn()
	end
end

function LobbyPart:onDuihuanBillResp(responseData)
	local server_data = cjson.decode(responseData)
	if server_data.msg then --展示兑换信息，成功或失败
		local tips_part = global:createPart("TipsPart",self)
		if tips_part then
			tips_part:activate({
				info_txt=server_data.msg})
		end
	end
end

function LobbyPart:onShowDuihuanRecordClick()
	local url = (self.dh_url and self.dh_url ~= "") and self.dh_url or  "http://testhuodong.sparkingfuture.com:58589/"
	url = url .. "cdk/history"

	local user = global:getGameUser()
 	local uid = user:getProp("uid")
	local user_default = cc.UserDefault:getInstance()
	local unionid = user_default:getStringForKey(enUserData.WXOPEN_ID, "")
	local key = (self.dh_key and self.dh_key ~= "") and self.dh_key or "testcdkkey"

    local dataTable = {}
    dataTable.current_time = os.time()
    dataTable.game_id = self.game_id
    dataTable.player_index = uid
    local signData = "current_time=" .. dataTable.current_time .. "&game_id=" .. dataTable.game_id .. "&player_index=" .. dataTable.player_index
	print("onShowDuihuanRecordClick  signData ", signData)
    local sign = md5.sumhexa(signData .. "&key=" .. key)
	print("onShowDuihuanRecordClick  sign ", sign)
    local dataStr = signData .. "&sign=" .. string.upper(sign) -- tostring(cjson.encode(dataTable))
    print("onShowDuihuanRecordClick Data Str ", dataStr)

	self.http_manager:createHttpConnect(url,"get_dh_record",dataStr,string.len(dataStr),1,false)
end

--兑换历史返回
function LobbyPart:onDuihuanRecordResp(responseData)
	local recordData = {}
	local server_data = cjson.decode(responseData)
	if server_data.code == 0 then
		for _,itemData in pairs(server_data.data) do
			table.insert(recordData, itemData)
		end
		self:showDuihuanRecord(recordData)
	else
		local tips_part = global:createPart("TipsPart",self)
		if tips_part then
			tips_part:activate({
				info_txt=server_data.msg})
		end
	end
	local duihuan_part = self:getPart("DuihuanPart",self)
	if duihuan_part then
		duihuan_part:resetRecordBtn()
	end
end

--展示兑换记录页面
function LobbyPart:showDuihuanRecord(data)
	local duihuan_record_part = self:getPart("DuiHuanRecordPart",self)
	if duihuan_record_part then
		duihuan_record_part:activate(self.game_Id, data)
	end	
end

function LobbyPart:onHttpResponse(resultCode,tag,data)
	printInfo("LobbyPart:onHttpResponse: resultCode:%d tag:%s data:%s",resultCode,tag,data)
	if tag == "send_dh_code" then
		self:onDuihuanResp(data)
	elseif tag == "send_dh_bill_req" then
		--兑换话费
		self:onDuihuanBillResp(data)	
	elseif tag == "get_dh_record" then
		self:onDuihuanRecordResp(data)
	else

	end
end

function LobbyPart:getConfigFromServer()
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local get_config_req = get_config_message_pb.GetAnnoucementReq()
	get_config_req.type = 101
	net_mode:sendProtoMsg(get_config_req,LobbyPart.CMD.MSG_GET_DH_CONFIG_REQ,self.game_id)
end

function LobbyPart:onGetConfigFromServer(data,appId)
	local get_config_rsp = get_config_message_pb.GetAnnouncementRsp()
	get_config_rsp:ParseFromString(data)
	print("LobbyPart:onGetConfigFromServer:", get_config_rsp)

	if get_config_rsp then
		local msg = {} 
		for i,v in ipairs(get_config_rsp.msg) do
			if v.paraId == 101 then
				self.dh_key = v.pro2
				self.dh_url = v.pro1
			end
		end
		print("this is duihuan key : ", self.dh_key)
	end
end

function LobbyPart:realodConfigFile()--重载
 	-- body
 	package.loaded["app.model.config.RoomConfig"] = nil
	require("app.model.config.RoomConfig")
	 
	package.loaded["app.model.config.xymj.RoomConfig"] = nil
	pcall(require,"app.model.config.xymj.RoomConfig")

	package.loaded["app.module.language.string_zh"] = nil
	require("app.module.language.string_zh")
	package.loaded["app.module.language.xymj.string_zh"] = nil
	pcall(require,"app.module.language.xymj.string_zh")
end 

function LobbyPart:checkVersion()
	local version1 = cc.UserDefault:getInstance():getIntegerForKey("Version", 0)
    local version2 = 100000004--GameVerInfo:getGameVersionNumber()
    print("###[LobbyPart:checkVersion]version1,version2 ",version1,version2)
    if version1 < version2 then
		local tips_part = global:createPart("TipsPart", self)
		if tips_part then
			local exit_func = function()
				cc.UserDefault:getInstance():setIntegerForKey("Version", version2)
				cc.UserDefault:getInstance():flush() 
				os.exit(0)
			end

			tips_part:activate({info_txt = version_low, mid_click = exit_func, close_click = exit_func})
		end
    end
end


return LobbyPart
