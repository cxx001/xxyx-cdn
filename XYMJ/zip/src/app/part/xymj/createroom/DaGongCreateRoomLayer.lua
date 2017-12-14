	--[[
*名称:DaGongCreateRoomLayer
*描述:创建房间界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local DaGongCreateRoomLayer = class("DaGongCreateRoomLayer",import(".NewCreateRoomLayer"))

function DaGongCreateRoomLayer:initWithFilePath(unusedName, ...)
	DaGongCreateRoomLayer.super.initWithFilePath(self, self.__cname, ...)
end

--[[
	handler
--]]
function DaGongCreateRoomLayer:PlayWaySelectEvent1()
	self.part:selectPlayWay(1)
end

function DaGongCreateRoomLayer:TimesSelectEvent2()
	self.part:selectTimes(2)
end

function DaGongCreateRoomLayer:TimesSelectEvent3()
	self.part:selectTimes(2)
end

function DaGongCreateRoomLayer:PaymentSelectEvent1()
	self.part:selectPayment(1)
end

--[[
	updater
--]]
function DaGongCreateRoomLayer:setSelectPayment(payment)
	print("###[DaGongCreateRoomLayer:setSelectPayment] payment ", payment)
	for i = 1, 4 do --关闭当前选择
		local paymentNode = self.node["payment_select" .. i]
		if paymentNode then
			paymentNode:setSelected(i == payment)
			paymentNode:setTouchEnabled(i ~= payment)
		end
	end
end

return DaGongCreateRoomLayer