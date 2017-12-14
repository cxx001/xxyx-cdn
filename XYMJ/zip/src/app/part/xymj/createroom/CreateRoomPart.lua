--[[
*名称:CreateRoomLayer
*描述:创建房间界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local CreateRoomPart = class("CreateRoomPart",cc.load('mvc').PartBase) --登录模块
CreateRoomPart.DEFAULT_PART = {}
CreateRoomPart.DEFAULT_VIEW = "CreateRoomLayer"
CreateRoomPart.TIMAES1 = 4 --4局
CreateRoomPart.TIMAES2 = 8 --8局
CreateRoomPart.TIMAES3 = 16 --16局
CreateRoomPart.TIMAES4 = 32 --32局 

CreateRoomPart.PLAYWAY1 = 1 --玩法1 红中随配
CreateRoomPart.PLAYWAY2 = 2 --玩法2 点炮胡牌
CreateRoomPart.PLAYWAY3 = 3 --玩法3 合肥自摸

CreateRoomPart.MA1 = 1 --2个码
CreateRoomPart.MA2 = 2 --4个码
CreateRoomPart.MA3 = 3 --6个码
CreateRoomPart.CMD = {
    MSG_CREATE_VIP_ROOM = 0xc30100, --创建vip房间
}

CreateRoomPart.PAYMENT_CREATOR = 1
CreateRoomPart.PAYMENT_AVERAGE = 2

CreateRoomPart.payType = {
	[CreateRoomPart.PAYMENT_CREATOR] = 0,  -- 房主支付
	[CreateRoomPart.PAYMENT_AVERAGE] = 1,  -- AA支付
}

local function isCostConfigId(id)
	return 7001 == id
		or 7002 == id
		or 7003 == id
		or 7004 == id
end

require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".CreateVipRoomMsg_pb")

--[
-- @brief 构造函数
--]
function CreateRoomPart:ctor(owner)
    CreateRoomPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function CreateRoomPart:initialize()
	
end

--激活模块
function CreateRoomPart:activate(gameId,data)
    -- gameId = 262401 --临时调试用
    self.game_id = gameId
	CreateRoomPart.super.activate(self,CURRENT_MODULE_NAME)
	print("###[CreateRoomPart:activate]self.cur_times ", self.cur_times)
   	self:selectTimes(2)
	self:selectPlayWay(CreateRoomPart.PLAYWAY2)
	self:selectMa(CreateRoomPart.MA1)
	self:selectPayment(CreateRoomPart.PAYMENT_CREATOR)
	self:switchToGroupManager()
end

function CreateRoomPart:switchToGroupManager()
	local user = global:getGameUser()
	local game_player = user:getProp("gameplayer"..self.game_id)
	self.agentFlag = game_player.agentFlag 
	local enable = self.agentFlag == 1 and true or false
	--enable = true 
	print("###NewCreateRoomPart:switchToGroupManager enable ", enable) 
	self:updateRedPoint(0)
	if not enable then
		self.view:switchToGroupManager(enable) 
		return
	end
	self.roomListPart = global:createPart("RoomListPart",self) 
	local parentNode = self.view:getRoomListPanel()
	if nil == self.roomListPart or nil == parentNode then
		print("###[NewCreateRoomPart:switchToGroupManager] nil == self.roomListPart ") 
		return
	end
	self.roomListPart:activate(self.game_id,cc.p(0,0), parentNode)  
	self.view:switchToGroupManager(enable)
	self:switchToRoomList(false)  --默认打开创建房间列表
end

function CreateRoomPart:switchToRoomList(enable)
	print("###[NewCreateRoomPart:switchToRoomList] enable is ", enable)
	if enable then
		self:updateRedPoint(0)
	end
	self.view:switchToRoomList(enable) 
end

function CreateRoomPart:updateRedPoint(num)
	self.view:updateRedPoint(num)
end

function CreateRoomPart:deactivate()
	if self.view then
		self.view:removeSelf()
		self.view = nil
	end
end

function CreateRoomPart:selectPayment(payment)
	print("###[CreateRoomPart:selectPayment]payment ", payment)
	self.cur_payment = payment
	self.view:setSelectPayment(self.cur_payment)
	self:updateDiamondOnPart()
end

function CreateRoomPart:selectTimes(type)
	print("###[CreateRoomPart:selectTimes]self.cur_times ", type)
	-- body
	self.cur_times = type
	self.view:setSelectTimes(self.cur_times)
	self:updateDiamondOnPart()
end

function CreateRoomPart:selectPlayWay(type)
	-- body
	self.cur_play_way = type
	self.view:setSelectPlayWay(self.cur_play_way)
end
 

function CreateRoomPart:selectMa(type)
	-- body
	self.cur_ma = type
	self.view:setSelectMa(self.cur_ma)
end

function CreateRoomPart:getPartId()
	-- body
	return "CreateRoomPart"
end

function CreateRoomPart:updateDiamondOnPart()
	local costDiamond = self:calcDiamondCost()
	print(string.format("###[CreateRoomPart:updateDiamondOnPart] costDiamond is %d", costDiamond)) 
	self.view:updateCostDiamondOnView(costDiamond)
end

function CreateRoomPart:createGame()
	-- body
	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local create_vip_room = self:createCreateVipRoomMsg()
	net_mode:sendProtoMsg(create_vip_room,CreateRoomPart.CMD.MSG_CREATE_VIP_ROOM,self.game_id)
end

function CreateRoomPart:createCreateVipRoomMsg()
	local create_vip_room = wllobby_message_pb.CreateVipRoomMsg()
	create_vip_room.roomid = 2002
	create_vip_room.gametype = 1

	local quanNum = CreateRoomPart["TIMAES"..self.cur_times]
	print("------------quanNum : ",quanNum)
	create_vip_room.quanNum = quanNum

	local play_way = RoomConfig.Rule[self.cur_play_way].value
	if play_way == RoomConfig.Rule[1].value then --红中麻将
		play_way = bit._or(play_way,RoomConfig.RuleMa[self.cur_ma])
		print("this is cur play way:",play_way,RoomConfig.RuleMa[self.cur_ma],RoomConfig.Rule[1].value)
	end
	create_vip_room.selectWayNum = play_way
	create_vip_room.payType = CreateRoomPart.payType[self.cur_payment]

	return create_vip_room
end

function CreateRoomPart:calcDiamondCost()
	-- body
	local type = self.cur_times
	local quanCount = CreateRoomPart["TIMAES"..type]
	print("CreateRoomPart:calcDiamondCost",quanCount)

	--通过圈数 循环遍历服务器的数据，如果相等，则得到对应的消费 钻石个数
	local costDiamond = 1
	local user = global:getGameUser()
    local props = user:getProps()
    local gameConfigList = props["gameplayer" .. self.game_id].gameConfigList

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
		print("###[CreateRoomPart:calcDiamondCost] costDiamond == 1 and type == 4 ")
		costDiamond = 16
	end
	print("###[CreateRoomPart:calcDiamondCost] costDiamond is ", costDiamond)
	return costDiamond
end

function CreateRoomPart:requestCurrentList()
	print("###NewCreateRoomPart:requestCurrentList")
	if self.roomListPart and self.agentFlag then
		self.roomListPart:requestCurrentList(true)
	end 
end

return CreateRoomPart 