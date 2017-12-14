-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local LobbyPart = import(".LobbyPart")
local YNLobbyPart = class("YNLobbyPart",LobbyPart) --大厅模块
local VIP_TABLE_ASK_OK  = 2000  -- 临时处理避免强更
-- require("app.model.protobufmsg.StartGameMsgAck_pb")
function YNLobbyPart:createRoomClick()
	-- body
	self.cur_select_btn = 1
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local req_enter_room = wllobby_message_pb.ReqStartGame()
	req_enter_room.roomid = 2002
	req_enter_room.gametype = 1
	self:startLoading()
	net_mode:sendProtoMsg(req_enter_room,SocketConfig.MSG_REQUEST_START_GAME,SocketConfig.GAME_ID)
	-- self:createRoom()
end

function YNLobbyPart:addRoomClick()
	-- body
	self.cur_select_btn = 2
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local req_enter_room = wllobby_message_pb.ReqStartGame()
	req_enter_room.roomid = 2002
	req_enter_room.gametype = 1
	self:startLoading()
	net_mode:sendProtoMsg(req_enter_room,SocketConfig.MSG_REQUEST_START_GAME,SocketConfig.GAME_ID)
	-- self:createRoom()
end

function YNLobbyPart:registerMsgListener(net_mode) 
	local partId = self:getPartId()
	net_mode:registerMsgListener(LobbyPart.CMD.MSG_GAME_OTHERLOGIN_ACK,handler(self,YNLobbyPart.otherLogin)) 
	net_mode:registerMsgListener(LobbyPart.CMD.MSG_REQUEST_START_GAME_ACK,handler(self,YNLobbyPart.onEnterRoomAck))
	net_mode:registerMsgListener(LobbyPart.CMD.MSG_GAME_SEND_SCROLL_MES,handler(self,YNLobbyPart.scrollMsgAck),partId)
	net_mode:registerMsgListener(LobbyPart.CMD.MSG_SYSTEM_NOTIFY_MSG,handler(self,YNLobbyPart.notifyMsgAck))
	net_mode:registerMsgListener(LobbyPart.CMD.MSG_GET_GAME_CONFIG_RSP,handler(self,YNLobbyPart.msgGameConfigRsp))
	net_mode:registerMsgListener(LobbyPart.CMD.MSG_GAME_UPDATE_PLAYER_PROPERTY,handler(self,YNLobbyPart.updatePlayerProperty)) --更新玩家信息 没有操作
	--net_mode:registerMsgListener(LobbyPart.CMD.MSG_GET_LUNBOTU_RSP,handler(self,LobbyPart.onGetAdImgUrllist))  --v2.0轮播图已经内部处理
end

function YNLobbyPart:onEnterRoomAck(data,appID)
	-- 这里要根据游戏类型跳转到不同的游戏进行处理
	self:endLoading()
	local enter_room_ack = StartGameMsgAck_pb.StartGameMsgAck()  
	enter_room_ack:ParseFromString(data)
	print("###[YNLobbyPart:onEnterRoomAck] this is enter room ack result is ",enter_room_ack.result)
	if enter_room_ack.result == SocketConfig.MsgResult.GOLD_LOW_THAN_MIN_LIMIT then -- 金币低于下限
		local tips_part = global:createPart("TipsPart",self)
		if tips_part then
			tips_part:activate({info_txt=string_table.gold_low})
		end
	elseif enter_room_ack.result == SocketConfig.MsgResult.GOLD_HIGH_THAN_MAX_LIMIT then -- 金币超过上限
	elseif enter_room_ack.result == SocketConfig.MsgResult.CAN_ENTER_VIP_ROOM then -- 可以进入VIP房间
		if self.reconnect_flag then --异常容错，正常情况，有重连标记就应该重连进入房间，如果服务端数据错误，保证还很显示大厅
			global:exitLobby()
			self:activate(self.game_id)
		elseif self.cur_select_btn == 1 then
			self:createRoom()
		elseif self.cur_select_btn == 2 then
			self:addRoom()
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
		local tips_part = global:createPart("TipsPart",self)
		if tips_part then
			tips_part:activate({info_txt=string_table.room_id_wrong})
		end
	elseif enter_room_ack.result == SocketConfig.MsgResult.FANGKIA_NOT_FOUND then --钻石不足
		local tips_part = global:createPart("TipsPart",self)
		if tips_part then
			tips_part:activate({info_txt=string_table.fangka_not_found})
		end
	elseif enter_room_ack.result == SocketConfig.MsgResult.CMD_EXE_OK then --进入房间
		self:enterRoom(enter_room_ack) 
	elseif enter_room_ack.result == SocketConfig.MsgResult.VIP_TABLE_ASK_OK then 
		self:askTableInfo(enter_room_ack)
	elseif enter_room_ack.result == SocketConfig.MsgResult.GROUP_CREATEROOM then
		print("群主创建房间")
		local createRoomPart = self:getPart("CreateRoomPart")
		createRoomPart:requestCurrentList()
		return 
	end
end

function YNLobbyPart:askTableInfo(data) 
	print("###[YNLobbyPart:askTableInfo]")
	local tableInfo = data.tableinfo 
	if tableInfo.payType == 1 then
		print("###[YNLobbyPart:askTableInfo]打开AA支付对话框")
		self:createJoinRoomTips(tableInfo) 
	else
		self:askEnterRoom(tableInfo.viptableid)
	end 
end

function YNLobbyPart:askEnterRoom(viptableid)
	print("###[YNLobbyPart:askEnterRoom] viptableid is ",  viptableid)
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local enter_vip_room = wllobby_message_pb.ReqStartGame()
	enter_vip_room.roomid = viptableid
	enter_vip_room.gametype = 1
	enter_vip_room.tableid = "enter_room"
	self:startLoading()
	net_mode:sendProtoMsg(enter_vip_room,SocketConfig.MSG_ENTER_VIP_ROOM,SocketConfig.GAME_ID)
end

 --进入房间
function YNLobbyPart:enterRoom(data) 
	print("###[YNLobbyPart:enterRoom]")
	local table_part = self:getPart("TablePart")
	if table_part then
		self:deactivate()
		table_part:activate(self.game_id,data)
	end 
end

local function isCostConfigId(id)
	return 7001 == id
		or 7002 == id
		or 7003 == id
		or 7004 == id
end

function YNLobbyPart:createJoinRoomTips(tableInfo)
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
			playWayStr2 = playWayStr2 ~= "" and playWayStr2 ..","..v.name or v.name 
		end
	end  
	playWayStr2 = playWayStr2 ~= "" and "("..playWayStr2..")" or "" 

	local needDiamond = self:getNeedDiamond(tableInfo.totalhand, 1)

	local contentStr = string.format("当前进入的是%s%s玩法，%d局（四人支付模式),您需要支付%d钻石进入游戏", 
		playWayStr, playWayStr2, tableInfo.totalhand, needDiamond)
	print("###[YNLobbyPart:askTableInfo] contentStr is ",contentStr)

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

function YNLobbyPart:getNeedDiamond(quanCount, payType)
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
		print("###[YNLobbyPart:getNeedDiamond] costDiamond == 1 and type == 4 ")
		costDiamond = 16
	end
	if payType == 1 then
		costDiamond = costDiamond / 4
	end
	return costDiamond
end

return YNLobbyPart

