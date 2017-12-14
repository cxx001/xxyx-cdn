--
-- Author: Your Name
-- Date: 2016-12-05 22:03:35
--

local CURRENT_MODULE_NAME = ...
local NewCreateRoomPart = import(".NewCreateRoomPart")
local QJCreateRoomPart = class("QJCreateRoomPart",NewCreateRoomPart) --创建房间
QJCreateRoomPart.DEFAULT_VIEW = "QJCreateRoomLayer"

require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".CreateVipRoomMsg_pb")

QJCreateRoomPart.PAYMENT_CREATOR = 1
QJCreateRoomPart.PAYMENT_AVERAGE = 2

QJCreateRoomPart.payType = {
	[QJCreateRoomPart.PAYMENT_CREATOR] = 0,  -- 房主支付
	[QJCreateRoomPart.PAYMENT_AVERAGE] = 1,  -- AA支付
}

QJCreateRoomPart.DIFEN_1 = 1
QJCreateRoomPart.DIFEN_2 = 2
QJCreateRoomPart.DIFEN_3 = 3
QJCreateRoomPart.DIFEN_5 = 4
QJCreateRoomPart.DIFEN_10 = 5

QJCreateRoomPart.difen = {
	[QJCreateRoomPart.DIFEN_1] = 1,
	[QJCreateRoomPart.DIFEN_2] = 2,
	[QJCreateRoomPart.DIFEN_3] = 3,
	[QJCreateRoomPart.DIFEN_5] = 5,
	[QJCreateRoomPart.DIFEN_10] = 10,
}

QJCreateRoomPart.PLAYWAY1 = 1 --玩法1 对照RoomConfig.Rule
QJCreateRoomPart.PLAYWAY2 = 2 --玩法2 对照RoomConfig.Rule
QJCreateRoomPart.PLAYWAY3 = 3 --玩法3 对照RoomConfig.Rule

function QJCreateRoomPart:activate(data) 
	print("###[QJCreateRoomPart:activate]")
	QJCreateRoomPart.super.activate(self, data) 
	self:selectPlayWay(QJCreateRoomPart.PLAYWAY2) 
	self.cur_play_way2 = {}
	self:selectPlayWay2(-1)
	self:selectDifen(QJCreateRoomPart.DIFEN_2)
	self:selectPayment(QJCreateRoomPart.PAYMENT_AVERAGE)
end

function QJCreateRoomPart:selectPayment(payment)
	self.cur_payment = payment
	self.view:setSelectPayment(self.cur_payment)
	self:updateDiamondOnPart()
end

function QJCreateRoomPart:selectPlayWay(type) 
	self.cur_play_way = type    
	self.cur_play_way2 = {}
	self.view:setSelectPlayWay(self.cur_play_way)
	self.view:updaetUI(self.cur_play_way)
end

function QJCreateRoomPart:selectPlayWay2(type)   
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

function QJCreateRoomPart:selectDifen(difen)
	self.cur_difen = difen
	self.view:setSelectDifen(difen) 
end

function QJCreateRoomPart:createGame()
	-- body
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local create_vip_room = CreateVipRoomMsg_pb.CreateVipRoomMsg()
	create_vip_room.roomid = 2002 --vip场，湖北
	create_vip_room.gametype = 1

	local quanNum = QJCreateRoomPart["TIMAES"..self.cur_times]
	print("------------quanNum : ",quanNum)
	create_vip_room.quanNum = quanNum

	local play_way = RoomConfig.Rule[self.cur_play_way].value   
	for k,v in pairs(self.cur_play_way2) do
		if v > 0 then
        	play_way = bit._or(play_way,RoomConfig.Rule2[v].value)
    	end 
	end     

	create_vip_room.selectWayNum = play_way  
	create_vip_room.payType = QJCreateRoomPart.payType[self.cur_payment]
	create_vip_room.diZhu =  QJCreateRoomPart.difen[self.cur_difen]
 
 	print(string.format("###[QJCreateRoomPart:createGame]  play_way %x  payType %d dizhu %d", 
 		play_way,create_vip_room.payType, create_vip_room.diZhu))
 
	self.owner:startLoading() 
	net_mode:sendProtoMsg(create_vip_room, QJCreateRoomPart.CMD.MSG_CREATE_VIP_ROOM, SocketConfig.GAME_ID)
end

function QJCreateRoomPart:calcDiamondCost()
	local originCost = QJCreateRoomPart.super.calcDiamondCost(self)
	if self.cur_payment == QJCreateRoomPart.PAYMENT_AVERAGE then
		originCost = originCost / 4
	end
	return originCost
end

return QJCreateRoomPart
