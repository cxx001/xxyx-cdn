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
local DaGongCreateRoomPart = class("DaGongCreateRoomPart",import(".NewCreateRoomPart")) --登录模块
DaGongCreateRoomPart.DEFAULT_PART = {}
DaGongCreateRoomPart.DEFAULT_VIEW = "DaGongCreateRoomLayer" 

DaGongCreateRoomPart.PAYMENT_CREATOR = 1
DaGongCreateRoomPart.PAYMENT_AVERAGE = 2

DaGongCreateRoomPart.payType = {
	[DaGongCreateRoomPart.PAYMENT_CREATOR] = 0,  -- 房主支付
	[DaGongCreateRoomPart.PAYMENT_AVERAGE] = 1,  -- AA支付
}

--激活模块
function DaGongCreateRoomPart:activate(gameId,data) 
    DaGongCreateRoomPart.super.activate(self, gameId,data)
	self:selectPlayWay(CreateRoomPart.PLAYWAY1)
	self:setSelectPayment(DaGongCreateRoomPart.PAYMENT_CREATOR)
end

function DaGongCreateRoomLayer:setSelectPayment(payment)
	self.cur_payment = payment
	self.view:setSelectPayment(payment)
end

function DaGongCreateRoomPart:createCreateVipRoomMsg()
	local create_vip_room = DaGongCreateRoomPart.super.createCreateVipRoomMsg(self)
	create_vip_room.payType = DaGongCreateRoomPart.payType[self.cur_payment]
	return create_vip_room
end

return DaGongCreateRoomPart