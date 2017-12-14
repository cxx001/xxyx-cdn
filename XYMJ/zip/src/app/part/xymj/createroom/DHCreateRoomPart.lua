--
-- Author: Your Name
-- Date: 2016-12-05 22:03:35
--

local CURRENT_MODULE_NAME = ...
local CreateRoomPart = import(".CreateRoomPart")
local DHCreateRoomPart = class("DHCreateRoomPart",CreateRoomPart) --创建房间

function DHCreateRoomPart:createGame()
	-- body
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local create_vip_room = wllobby_message_pb.CreateVipRoomMsg()
	create_vip_room.roomid = 2002 --vip场，个旧的roomid
	create_vip_room.gametype = 1

	local quanNum = CreateRoomPart["TIMAES"..self.cur_times]
	print("------------quanNum_DHMJ : ",quanNum)
	create_vip_room.quanNum = quanNum

	print("cur_play:",self.cur_play_way)
	if self.cur_play_way == 2 then
		create_vip_room.selectWayNum = 0x01 -- 三家赔
	elseif self.cur_play_way == 1 then  
		create_vip_room.selectWayNum = 0x02 -- 一家赔
	end
	print("create_vip_room.selectWayNum->",create_vip_room.selectWayNum)
	self.owner:startLoading()
	net_mode:sendProtoMsg(create_vip_room,MsgDef.MSG_CREATE_VIP_ROOM,SocketConfig.GAME_ID)
end

return DHCreateRoomPart