--
-- Author: Your Name
-- Date: 2016-12-05 22:03:35
--

local CURRENT_MODULE_NAME = ...
local CreateRoomPart = import(".CreateRoomPart")
local XYCreateRoomPart = class("XYCreateRoomPart",CreateRoomPart) --创建房间
XYCreateRoomPart.DEFAULT_VIEW = "XYCreateRoomLayer"

CreateRoomPart.TIMAES2 = 6 --6局

function XYCreateRoomPart:initialize()
	self.default_times = CreateRoomPart.TIMAES1
	self.default_play_way = CreateRoomPart.PLAYWAY1
	self.default_ma = CreateRoomPart.MA1

	self.cur_times = 1
	self.cur_play_way = self.default_play_way
	self.cur_ma = self.default_ma
end

--激活模块
function XYCreateRoomPart:activate(data)
	XYCreateRoomPart.super.activate(self,data)
   	--self.view:setSelectTimes(1)
   	self.view:initXyCreateroom()
   	self:selectTimes(1)
end

function XYCreateRoomPart:createGame()
	if self.view:isXYMJSelected() then
		self:createXYMJGame()
	elseif self.view:isBDYSelected() then
		self:createBDYGame()
	elseif self.view:isLS13579Selected() then
		self:createLS13579Game()
	else
		self:createLSGame()
	end
end

function XYCreateRoomPart:createXYMJGame()
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local create_vip_room = CreateVipRoomMsg_pb.CreateVipRoomMsg()
	create_vip_room.roomid = 2002 --vip场，个旧的roomid
	create_vip_room.gametype = 1
	create_vip_room.supportReadyBeforePlaying = 2

	--local quanNum = CreateRoomPart["TIMAES"..self.cur_times]
	print("xymj create_room self.cur_times : ", self.cur_times)
	if self.cur_times and self.cur_times == 1 then
		create_vip_room.quanNum = 4
	else
		create_vip_room.quanNum = 6
	end
	print("xymj create_room quanshu : ", create_vip_room.quanNum)

	local specialRule = 0
	if self.view:isYFSelected() then
		specialRule = specialRule + 0x20 --有风
	end
	if self.view:isYKPSelected() then
		specialRule = specialRule + 0x100 --有坎牌
	end
	if self.view:isYNZSelected() then
		specialRule = specialRule + 0x200 --有闹庄
	end

	if self.view:isWF01Selected() then
		specialRule = specialRule + 0x0 --点炮输三家
	elseif self.view:isWF02Selected() then
		specialRule = specialRule + 0x400 --点炮输一家
	elseif self.view:isWF03Selected() then
		specialRule = specialRule + 0x1000 --自摸胡
	end

	if self.view:isBGZSelected() then
		create_vip_room.selectWayNum = 0x10040 + specialRule --五大嘴&八公嘴
	elseif self.view:isMTPSelected() then
		create_vip_room.selectWayNum = 0x10080 + specialRule --五大嘴&满堂跑
	else
		create_vip_room.selectWayNum = 0 + specialRule --五大嘴
	end

	-- 80000

	print("self.cur_payment,  CreateRoomPart.payType[self.cur_payment] ", self.cur_payment,  CreateRoomPart.payType[self.cur_payment])
	create_vip_room.payType = CreateRoomPart.payType[self.cur_payment]
	print("create_vip_room.payType ", create_vip_room.payType)

	local user = global:getGameUser()
	local game_player = user:getProp("gameplayer"..self.game_id)
	if game_player.agentFlag and game_player.agentFlag == 1 and (create_vip_room.payType ~=  CreateRoomPart.payType[CreateRoomPart.PAYMENT_AVERAGE]) then
		create_vip_room.createVipRoomWay = 1
	else
		create_vip_room.createVipRoomWay = 0
	end

	print("create_vip_room.createVipRoomWay ", create_vip_room.createVipRoomWay)
	print("xymj create_room selectWayNum ", create_vip_room.selectWayNum)
	self.owner:startLoading()
	net_mode:sendProtoMsg(create_vip_room,CreateRoomPart.CMD.MSG_CREATE_VIP_ROOM,SocketConfig.GAME_ID)
end

function XYCreateRoomPart:createBDYGame()
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local create_vip_room = CreateVipRoomMsg_pb.CreateVipRoomMsg()
	create_vip_room.roomid = 2002 --vip场，个旧的roomid
	create_vip_room.gametype = 1
	create_vip_room.supportReadyBeforePlaying = 2

	--local quanNum = CreateRoomPart["TIMAES"..self.cur_times]
	print("xymj create_room self.cur_times : ", self.cur_times)
	if self.cur_times and self.cur_times == 1 then
		create_vip_room.quanNum = 4
	else
		create_vip_room.quanNum = 6
	end
	print("xymj create_room quanshu : ", create_vip_room.quanNum)

	local specialRule = 0
	if self.view:isWDZSelected() then
		specialRule = specialRule --点炮输三家
	elseif self.view:isBGZSelected() then
		specialRule = specialRule + 0x80 --点炮输一家
	else
		specialRule = specialRule + 0x20 --自摸胡
	end

	if self.view:isWF01Selected() then
		specialRule = specialRule --乱三风
	else
		specialRule = specialRule + 0x40 --无风
	end

	if self.view:isYFSelected() then
		specialRule = specialRule + 0x200 --有跑子
	else
		specialRule = specialRule --无跑子
	end

	create_vip_room.selectWayNum = 0x20000 + specialRule

	print("self.cur_payment,  CreateRoomPart.payType[self.cur_payment] ", self.cur_payment,  CreateRoomPart.payType[self.cur_payment])
	create_vip_room.payType = CreateRoomPart.payType[self.cur_payment]
	print("create_vip_room.payType ", create_vip_room.payType)

	local user = global:getGameUser()
	local game_player = user:getProp("gameplayer"..self.game_id)
	if game_player.agentFlag and game_player.agentFlag == 1 and (create_vip_room.payType ~=  CreateRoomPart.payType[CreateRoomPart.PAYMENT_AVERAGE]) then
		create_vip_room.createVipRoomWay = 1
	else
		create_vip_room.createVipRoomWay = 0
	end

	print("xymj create_room selectWayNum ", create_vip_room.selectWayNum)
	self.owner:startLoading()
	net_mode:sendProtoMsg(create_vip_room,CreateRoomPart.CMD.MSG_CREATE_VIP_ROOM,SocketConfig.GAME_ID)
end

function XYCreateRoomPart:createLSGame()
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local create_vip_room = CreateVipRoomMsg_pb.CreateVipRoomMsg()
	create_vip_room.roomid = 2002 --vip场，个旧的roomid
	create_vip_room.gametype = 1
	create_vip_room.supportReadyBeforePlaying = 2

	--local quanNum = CreateRoomPart["TIMAES"..self.cur_times]
	print("xymj create_room self.cur_times : ", self.cur_times)
	if self.cur_times and self.cur_times == 1 then
		create_vip_room.quanNum = 4
	else
		create_vip_room.quanNum = 6
	end
	print("xymj create_room quanshu : ", create_vip_room.quanNum)

	local specialRule = 0
	if self.view:isWDZSelected() then
		specialRule = specialRule + 0x20 --活嘴
	elseif self.view:isBGZSelected() then
		specialRule = specialRule + 0x40 --死嘴
	else
		specialRule = specialRule + 0x80 --坎金
	end

	if self.view:isWF01Selected() then
		specialRule = specialRule  --点炮输三家
	elseif self.view:isWF02Selected() then
		specialRule = specialRule + 0x200 --点炮输一家
	elseif self.view:isWF03Selected() then
		specialRule = specialRule + 0x100 --自摸胡
	end

	if self.view:isYFSelected() then
		specialRule = specialRule + 0x400 --有甩张
	elseif self.view:isWFSelected() then
		specialRule = specialRule --无甩张
	end

	create_vip_room.selectWayNum = 0x40000 + specialRule

	print("self.cur_payment,  CreateRoomPart.payType[self.cur_payment] ", self.cur_payment,  CreateRoomPart.payType[self.cur_payment])
	create_vip_room.payType = CreateRoomPart.payType[self.cur_payment]
	print("create_vip_room.payType ", create_vip_room.payType)

	local user = global:getGameUser()
	local game_player = user:getProp("gameplayer"..self.game_id)
	if game_player.agentFlag and game_player.agentFlag == 1 and (create_vip_room.payType ~=  CreateRoomPart.payType[CreateRoomPart.PAYMENT_AVERAGE]) then
		create_vip_room.createVipRoomWay = 1
	else
		create_vip_room.createVipRoomWay = 0
	end

	print("xymj create_room selectWayNum ", create_vip_room.selectWayNum)
	self.owner:startLoading()
	net_mode:sendProtoMsg(create_vip_room,CreateRoomPart.CMD.MSG_CREATE_VIP_ROOM,SocketConfig.GAME_ID)
end

function XYCreateRoomPart:createLS13579Game()



	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local create_vip_room = CreateVipRoomMsg_pb.CreateVipRoomMsg()
	create_vip_room.roomid = 2002 --vip场，个旧的roomid
	create_vip_room.gametype = 1
	create_vip_room.supportReadyBeforePlaying = 2

	--local quanNum = CreateRoomPart["TIMAES"..self.cur_times]
	print("xymj create_room self.cur_times : ", self.cur_times)
	if self.cur_times and self.cur_times == 1 then
		create_vip_room.quanNum = 4
	else
		create_vip_room.quanNum = 6
	end
	print("xymj create_room quanshu : ", create_vip_room.quanNum)

	local specialRule = 0
	if self.view:isWDZSelected() then
		specialRule = specialRule  --点炮输三家
	elseif self.view:isBGZSelected() then
		specialRule = specialRule + 0x100 --点炮输一家
	else
		specialRule = specialRule + 0x80 --自摸胡
	end

	if self.view:isWF01Selected() then
		specialRule = specialRule + 0x0 --五套
	elseif self.view:isWF02Selected() then
		specialRule = specialRule + 0x20 --八套
	elseif self.view:isWF03Selected() then
		specialRule = specialRule + 0x40 --十套
	end

	if self.view:isYFSelected() then
		specialRule = specialRule + 0x200 --独赢
	elseif self.view:isWFSelected() then
		specialRule = specialRule --无独赢
	end

	create_vip_room.selectWayNum = 0x80000 + specialRule

	print("self.cur_payment,  CreateRoomPart.payType[self.cur_payment] ", self.cur_payment,  CreateRoomPart.payType[self.cur_payment])
	create_vip_room.payType = CreateRoomPart.payType[self.cur_payment]
	print("create_vip_room.payType ", create_vip_room.payType)

	local user = global:getGameUser()
	local game_player = user:getProp("gameplayer"..self.game_id)
	if game_player.agentFlag and game_player.agentFlag == 1 and (create_vip_room.payType ~=  CreateRoomPart.payType[CreateRoomPart.PAYMENT_AVERAGE]) then
		create_vip_room.createVipRoomWay = 1
	else
		create_vip_room.createVipRoomWay = 0
	end

	print("xymj create_room selectWayNum ", create_vip_room.selectWayNum)
	self.owner:startLoading()
	net_mode:sendProtoMsg(create_vip_room,CreateRoomPart.CMD.MSG_CREATE_VIP_ROOM,SocketConfig.GAME_ID)
end

function XYCreateRoomPart:calcDiamondCost()
	local originCost = XYCreateRoomPart.super.calcDiamondCost(self)
	if self.cur_payment == XYCreateRoomPart.PAYMENT_AVERAGE then
		originCost = originCost / 4
	end
	return originCost
end

return XYCreateRoomPart