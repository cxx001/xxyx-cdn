--
-- Author: Your Name
-- Date: 2016-12-05 22:03:35
--

local CURRENT_MODULE_NAME = ...
local NewCreateRoomPart = import(".NewCreateRoomPart")
local ESCreateRoomPart = class("ESCreateRoomPart",NewCreateRoomPart) --创建房间
ESCreateRoomPart.DEFAULT_VIEW = "ESCreateRoomLayer"

require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".CreateVipRoomMsg_pb")

ESCreateRoomPart.PAYMENT_CREATOR = 1
ESCreateRoomPart.PAYMENT_AVERAGE = 2

ESCreateRoomPart.payType = RoomConfig.PlayType

ESCreateRoomPart.DIFEN_1 = 1
ESCreateRoomPart.DIFEN_2 = 2
ESCreateRoomPart.DIFEN_3 = 3
ESCreateRoomPart.DIFEN_5 = 4
ESCreateRoomPart.DIFEN_10 = 5

ESCreateRoomPart.difen = RoomConfig.DiZhu

ESCreateRoomPart.playTimes = RoomConfig.PlayTimes

ESCreateRoomPart.PLAYWAY1 = 1 --玩法1 对照RoomConfig.Rule
ESCreateRoomPart.PLAYWAY2 = 2 --玩法2 对照RoomConfig.Rule
ESCreateRoomPart.PLAYWAY3 = 3 --玩法3 对照RoomConfig.Rule

function ESCreateRoomPart:activate(data) 
	print("###[ESCreateRoomPart:activate]")
	ESCreateRoomPart.super.activate(self, data) 
	self:selectPlayWay(ESCreateRoomPart.PLAYWAY2) 
	self.cur_play_way2 = {}
	self:selectPlayWay2(-1)
	self:selectDifen(ESCreateRoomPart.DIFEN_2)
	self:selectPayment(ESCreateRoomPart.PAYMENT_AVERAGE)
end

function ESCreateRoomPart:selectPayment(payment)
	self.cur_payment = payment
	self.view:setSelectPayment(self.cur_payment)
	self:updateDiamondOnPart()
end

function ESCreateRoomPart:selectPlayWay(type) 
	self.cur_play_way = type    
	self.cur_play_way2 = {}
	self.view:setSelectPlayWay(self.cur_play_way)
	self.view:updaetUI(self.cur_play_way)
end

function ESCreateRoomPart:selectPlayWay2(type)   
	local selectType = tonumber(type)
	if nil == next(self.cur_play_way2) or nil == self.cur_play_way2[selectType] then
		self.cur_play_way2[selectType] = 0
	end
	--再次选择则状态取非
	if selectType > 0 then  
		if self.cur_play_way2[selectType] > 0 then
			self.cur_play_way2[selectType] = 0
		else
			self.cur_play_way2[selectType] = selectType
		end 
	elseif selectType == -1 then
		self.cur_play_way2 = {}
		for k,v in pairs(self.cur_play_way2) do
			v = 0
		end
	end  
	self.view:setSelectPlayWay2(self.cur_play_way2)
end

function ESCreateRoomPart:selectDifen(difen)
	self.cur_difen = difen
	self.view:setSelectDifen(difen) 
end

function ESCreateRoomPart:createGame()
	-- body
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local create_vip_room = CreateVipRoomMsg_pb.CreateVipRoomMsg()
	create_vip_room.roomid = 2002 --vip场，湖北
	create_vip_room.gametype = 1

	local quanNum = ESCreateRoomPart["TIMAES"..self.cur_times]
	print("------------quanNum : ",quanNum)
	create_vip_room.quanNum = quanNum

	local play_way = RoomConfig.Rule[self.cur_play_way].value   
	print("###[ESCreateRoomPart:createGame]play_way is ", play_way) 
	for k,v in pairs(self.cur_play_way2) do
		if v > 0 then
			local value2 = RoomConfig.Rule2[v].value
			print(string.format("###[ESCreateRoomPart:createGame ]value2: %2x", value2))
        	play_way = bit._or(play_way,value2)
    	end 
	end     

	create_vip_room.selectWayNum = play_way  
	create_vip_room.payType = ESCreateRoomPart.payType[self.cur_payment].value  
	create_vip_room.diZhu =  ESCreateRoomPart.difen[self.cur_difen].value
 
 	print(string.format("###[ESCreateRoomPart:createGame]  play_way %x  payType %d dizhu %d", 
 		play_way,create_vip_room.payType, create_vip_room.diZhu))
 
	self.owner:startLoading() 
	net_mode:sendProtoMsg(create_vip_room, ESCreateRoomPart.CMD.MSG_CREATE_VIP_ROOM, SocketConfig.GAME_ID)
end

function ESCreateRoomPart:calcDiamondCost()
	local originCost = ESCreateRoomPart.super.calcDiamondCost(self)
	if self.cur_payment == ESCreateRoomPart.PAYMENT_AVERAGE then
		originCost = originCost / 4
	end
	return originCost
end

function ESCreateRoomPart:enableAAPayment(enable)
	self.view:enableAAPayment(enable)
end

return ESCreateRoomPart
