--
-- Author: Your Name
-- Date: 2016-12-05 22:03:35
--

local CURRENT_MODULE_NAME = ...
local CreateRoomPart = import(".CreateRoomPart")
local XTCreateRoomPart = class("XTCreateRoomPart",CreateRoomPart) --创建房间
XTCreateRoomPart.DEFAULT_VIEW = "XTCreateRoomLayer"

require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".CreateVipRoomMsg_pb")

XTCreateRoomPart.PAYMENT_CREATOR = 1
XTCreateRoomPart.PAYMENT_AVERAGE = 2

XTCreateRoomPart.payType = {
	[XTCreateRoomPart.PAYMENT_CREATOR] = 0,  -- 房主支付
	[XTCreateRoomPart.PAYMENT_AVERAGE] = 1,  -- AA支付
}

XTCreateRoomPart.PLAYWAY1 = 1 --玩法1 对照RoomConfig.Rule
XTCreateRoomPart.PLAYWAY2 = 2 --玩法2 对照RoomConfig.Rule
XTCreateRoomPart.PLAYWAY3 = 3 --玩法3 对照RoomConfig.Rule

function XTCreateRoomPart:activate(data)
	if nil == self.cur_play_way2 then
		self.cur_play_way2 = {0,0,0}  
	end  
	XTCreateRoomPart.super.activate(self, data) 
	self:selectPlayWay(XTCreateRoomPart.PLAYWAY2)
	self:selectPlayWay2(-1)
	self:selectPayment(XTCreateRoomPart.PAYMENT_AVERAGE)
end

function XTCreateRoomPart:selectPayment(payment)
	self.cur_payment = payment
	self.view:setSelectPayment(self.cur_payment)
	self:updateDiamondOnPart()
end

function XTCreateRoomPart:selectPlayWay(type) 
	self.cur_play_way = type  
	self.view:showSelectPlayWay2(self.cur_play_way == XTCreateRoomPart.PLAYWAY2) 
	self.view:setSelectPlayWay(self.cur_play_way)
end

function XTCreateRoomPart:selectPlayWay2(type)   
	--再次选择则状态取非
	if type > 0 then 
		if self.cur_play_way2[type] > 0 then
			self.cur_play_way2[type] = 0
		else
			self.cur_play_way2[type] = type
		end 
	elseif type == -1 then
		self.cur_play_way2[1] = 0
		self.cur_play_way2[2] = 0
		self.cur_play_way2[3] = 0 
	end 
	self.view:setSelectPlayWay2(self.cur_play_way2)
end

function XTCreateRoomPart:createGame()
	-- body
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local create_vip_room = CreateVipRoomMsg_pb.CreateVipRoomMsg()
	create_vip_room.roomid = 2002 --vip场，湖北
	create_vip_room.gametype = 1

	local quanNum = CreateRoomPart["TIMAES"..self.cur_times]
	print("------------quanNum : ",quanNum)
	create_vip_room.quanNum = quanNum

	local play_way = RoomConfig.Rule[self.cur_play_way].value  

	if self.cur_play_way == XTCreateRoomPart.PLAYWAY2 then
		for i,v in ipairs(self.cur_play_way2) do
			if v > 0 then
	        	play_way = bit._or(play_way,RoomConfig.Rule2[v].value)
	    	end 
		end  
	end  
      
	create_vip_room.selectWayNum = play_way  
	create_vip_room.payType = XTCreateRoomPart.payType[self.cur_payment]

 	print(string.format("###[CreateRoomPart:createGame]  play_way %x  payType %d dizhu %d", 
 		play_way,create_vip_room.payType, create_vip_room.diZhu))
 
	self.owner:startLoading()
	net_mode:sendProtoMsg(create_vip_room,SocketConfig.MSG_CREATE_VIP_ROOM,SocketConfig.GAME_ID)
end

function XTCreateRoomPart:calcDiamondCost()
	local originCost = XTCreateRoomPart.super.calcDiamondCost(self)
	if self.cur_payment == XTCreateRoomPart.PAYMENT_AVERAGE then
		originCost = originCost / 4
	end
	return originCost
end

return XTCreateRoomPart
