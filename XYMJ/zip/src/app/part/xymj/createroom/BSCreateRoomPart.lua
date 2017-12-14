--
-- Author: Your Name
-- Date: 2016-12-05 22:03:35
--

local CURRENT_MODULE_NAME = ...
local CreateRoomPart = import(".CreateRoomPart")
local BSCreateRoomPart = class("BSCreateRoomPart",CreateRoomPart) --创建房间

function BSCreateRoomPart:createGame()
	-- body
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local create_vip_room = wllobby_message_pb.CreateVipRoomMsg()
	create_vip_room.roomid = 2002 --vip场，个旧的roomid
	create_vip_room.gametype = 1

	local quanNum = CreateRoomPart["TIMAES"..self.cur_times]
	print("------------quanNum_GJMJ : ",quanNum)
	create_vip_room.quanNum = quanNum

    --[[
	local play_way = RoomConfig.Rule[self.cur_play_way]
	if play_way == RoomConfig.Rule[1] then --红中麻将
		play_way = bit._or(play_way,RoomConfig.RuleMa[self.cur_ma])
		print("this is cur play way_GJMJ:",play_way,RoomConfig.RuleMa[self.cur_ma],RoomConfig.Rule[1])
	else
		print("this is cur play way_GJMJ new")
	end
	create_vip_room.selectWayNum = play_way
	]]

	create_vip_room.selectWayNum = RoomConfig.PlayRule[1]
	print("create_vip_room.selectWayNum->",create_vip_room.selectWayNum)
	self.owner:startLoading()
	net_mode:sendProtoMsg(create_vip_room,SocketConfig.MSG_CREATE_VIP_ROOM,SocketConfig.GAME_ID)
end

return BSCreateRoomPart