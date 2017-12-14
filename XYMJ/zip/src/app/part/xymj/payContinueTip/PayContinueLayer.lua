--[[
*名称:PayChoseTipLayer
*描述:提示界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local PayContinueLayer = class("PayContinueLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]

function PayContinueLayer:onCreate(data) --传入数据
	-- body
	self:addMask()
	self:initWithFilePath("PayContinueLayer",CURRENT_MODULE_NAME)
end

function PayContinueLayer:updateZuanPrice( bindPrice , unBindPrice )
	self.node.Text_price2:setString(string.format("%d元",bindPrice))
	self.node.Text_price1:setString(string.format("%d元",unBindPrice))
end

function PayContinueLayer:continuePayClick( ... )
	self.part:continuePay()
	self.part:deactivate()
end

function PayContinueLayer:bindClick( ... )
	print("bindAgent ----33333")
	self.part:createBindPart()
	self.part:deactivate()
end

return PayContinueLayer