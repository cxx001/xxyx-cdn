--[[
*名称:DuihuanRecordLayer
*描述:兑换记录界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local DuiHuanRecordPart = class("DuiHuanRecordPart",cc.load('mvc').PartBase) --登录模块
DuiHuanRecordPart.DEFAULT_VIEW = "DuiHuanRecordLayer"

DuiHuanRecordPart.CMD = {
	MSG_GET_VIP_RECORD_DETAIL		= 0xc30065,					--查询玩家战绩详情
	MSG_GET_VIP_RECORD_DETAIL_ACK	= 0xc30066,					--vip战绩详情列表
}

--[
-- @brief 构造函数
--]
function DuiHuanRecordPart:ctor(owner)
    DuiHuanRecordPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function DuiHuanRecordPart:initialize()
	
end

--激活模块
function DuiHuanRecordPart:activate(gameId, data)
	--self:getDuihuanRecordList(data)

print("onDuihuanRecordResp -----4-----")
	self.game_id = gameId
	DuiHuanRecordPart.super.activate(self,CURRENT_MODULE_NAME)	
	self:updateUI(data)
end

function DuiHuanRecordPart:updateUI(data)

print("onDuihuanRecordResp -----5-----")


	if self.view then
		self.view:updateUI(data)
	end
end

function DuiHuanRecordPart:getDuihuanRecordList(data)
	-- local net_manager = global:getNetManager()
	-- local proto_msg = tablePlayback_pb.GetVipGameRecordMsg()

	-- local user = global:getGameUser()
 --    local props = user:getProps()
 --    local playerID = props["gameplayer" .. SocketConfig.GAME_ID].playerIndex

 --    -- @ player_id
	-- proto_msg.roomID = tostring(data.roomIndex)

	-- -- @ end_time
	-- proto_msg.time = data.endTime

	-- net_manager:sendProtoMsg(proto_msg,self.CMD.MSG_GET_VIP_RECORD_DETAIL, game_id or SocketConfig.GAME_ID)
	-- if not game_id then
	-- 	self.owner:startLoading()
	-- end
end

function DuiHuanRecordPart:getDuihuanRecordListAck(data, appId)
	self.owner:endLoading()
	local net_manager = global:getNetManager()
	local proto_msg = tablePlayback_pb.GetVipGameRecordMsgAck()
	proto_msg:ParseFromString(data)

	print(proto_msg)
	-- @parse proto
	self:parseDuihuanRecordDate(proto_msg)
	-- @ update
	self.view:updateUI(self.room_list, self.room_data)
end

function DuiHuanRecordPart:parseDuihuanRecordDate(proto_msg)
	local battles = proto_msg.record
	self.room_list = {}
	for i, battle in ipairs(battles) do
		local handIndex = battle.handIndex
		local node = {
			roomid 		= battle.roomid,
			playerID 	= battle.playerID,
			playerName 	= battle.playerName,
			gameScore 	= battle.gameScore,
			handIndex 	= battle.handIndex,
			recordTime  = battle.recordTime,
		}
		if not self.room_list[handIndex] then
			self.room_list[handIndex] = {}
		end
		table.insert(self.room_list[handIndex], node)
	end
end

function DuiHuanRecordPart:deactivate()
	-- local net_mode = global:getNetManager()
	-- net_mode:unRegisterMsgListener(self.CMD.MSG_GET_VIP_RECORD_DETAIL_ACK)

	self.view:removeSelf()
 	self.view =  nil
end

function DuiHuanRecordPart:getPartId()
	-- body
	return "DuiHuanRecordPart"
end

function DuiHuanRecordPart:onDuihuanClick(dhCode)
	if self.owner and self.owner.sendDhCode then
		self.owner:sendDhCode(dhCode)
		self:deactivate()
	end
end

return DuiHuanRecordPart 