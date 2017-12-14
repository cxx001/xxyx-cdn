--[[
*名称:RecordLayer
*描述:战绩记录界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local BattlePart = class("BattlePart",cc.load('mvc').PartBase) --登录模块
BattlePart.DEFAULT_VIEW = "BattleLayer"

local LOAD_DOTA_URL		 = 'http://testapi.xiaoxiongyouxi.com/game-log/get-file-data?code='
local GET_SHARE_CORE_URL = 'http://testapi.xiaoxiongyouxi.com/game-log/fetch-share-code?'

BattlePart.CMD = {
	MSG_GET_VIP_ROOM_RECORD 	= 0xc30063,
	MSG_GET_VIP_ROOM_RECORD_ACK = 0xc30064,
}

--[
-- @brief 构造函数
--]
function BattlePart:ctor(owner)
    BattlePart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function BattlePart:initialize()
	require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".ycmj_message_pb")
	require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".tablePlayback_pb")
end

--激活模块
function BattlePart:activate(playerID,name)
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	net_mode:registerMsgListener(self.CMD.MSG_GET_VIP_ROOM_RECORD_ACK,handler(self,BattlePart.getVipRoomListMsgAck))

	BattlePart.super.activate(self,CURRENT_MODULE_NAME)
	self:getGameIds()

	self.name = name
	if #self.ids > 0 then
		self:getVipRoomListMsg(playerID)
	else
		self.view:updateUI({}, {})
	end
end

function BattlePart:deactivate()
	local net_mode = global:getNetManager()
	net_mode:unRegisterMsgListener(SocketConfig.MSG_GET_VIP_ROOM_RECORD_ACK)
	self.view:removeSelf()
 	self.view =  nil
end

function BattlePart:getPartId()
	-- body
	return "BattlePart"
end

--[[
@ 获取本地存在的游戏列表
]]
function BattlePart:getLocalIds()
	
end

--[[
@ 获取本地游戏列表
]]
function BattlePart:getGameIds()
	local game_list_str = cc.UserDefault:getInstance():getStringForKey('ynhj_game_list')
	local game_list = Util.split('game_list_str', ",")

	-- @ 当前绕过自动子游戏更新，所以直接写死
	self.ids = {}
	local game_list = Util.split('262401,262402,262405,262407', ',')
	for i, id in ipairs(game_list) do
		table.insert(self.ids, tonumber(id))
	end
end

--[[
@ 打开战绩详情
]]
function BattlePart:openBattleDetail(data)
	local battle_detail_part = self.owner:getPart('BattleDetailPart')
	if battle_detail_part then
		battle_detail_part:activate(data)
	end
	--self:deactivate()
end

--[[
@ 打开分享码页面
]]
function BattlePart:openOtherBattle()
	local other_battle_part = self.owner:getPart('OtherBattlePart')
	if other_battle_part then
		other_battle_part:activate()
	end

	--self:deactivate()
end

--[[
@ 刷新游戏列表
]]
function BattlePart:refreshGameTypes(index)
	local user = global:getGameUser()
    local props = user:getProps()
    local playerID = props["gameplayer" .. SocketConfig.GAME_ID].playerIndex

    self:getVipRoomListMsg(playerID, index)
end

function BattlePart:getVipRoomListMsg(playerid, id)
	-- @ 选中了这个游戏select_id
	local game_id 
	if not id then
		self.select_id = 1
		for i, id in ipairs(self.ids) do
			if id == tonumber(SocketConfig.GAME_ID) then
				self.select_id = i
			end
		end
	else
		self.select_id = id
	end

	local net_manager = global:getNetManager()
	local get_vip_room_list_msg = wllobby_message_pb.GetVipRoomListMsg()

	get_vip_room_list_msg.playerid = tostring(playerid)
	net_manager:sendProtoMsg(get_vip_room_list_msg,self.CMD.MSG_GET_VIP_ROOM_RECORD, game_id or SocketConfig.GAME_ID)
	if not game_id then
		self.owner:startLoading()
	end
end

function BattlePart:getVipRoomListMsgAck(data,appId)
	self.owner:endLoading()
	local net_manager = global:getNetManager()
	local get_vip_room_list_msg_ack = wllobby_message_pb.GetVipRoomListMsgAck()
	get_vip_room_list_msg_ack:ParseFromString(data)

	self:parseBattle(get_vip_room_list_msg_ack.record)
	print(get_vip_room_list_msg_ack)
	self.view:updateUI(self.room_list, self.ids, self.select_id)
end

function BattlePart:parseBattle(records)
	self.room_list = {}
	for i, record in ipairs(records) do
		local players = {}
		for i, player in ipairs(record.player) do
			local player_data = {
				score 		= player.score,
				playerID 	= player.playerID,
				headImg 	= player.headImg,
				name 		= player.name,
			}
			table.insert(players, player_data)
		end

		local node = {
			roomid 		= record.roomid,
			roomIndex 	= record.roomIndex,
			hostId 		= record.hostId,
			startTime 	= record.startTime,
			endTime 	= record.endTime,
			player      = players,
		}
		table.insert(self.room_list, node)
	end
end

return BattlePart 