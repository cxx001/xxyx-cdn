--[[
*名称:PayChoseTipLayer
*描述:提示界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local PayChoseTipLayer = class("PayChoseTipLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]

function PayChoseTipLayer:onCreate(data) --传入数据
	-- body
	self:addMask()
	self:initWithFilePath("PayChoseTipLayer",CURRENT_MODULE_NAME)
end

function PayChoseTipLayer:AiliPayClick()
	self.part:payAiLi()
	self.part:deactivate()
end

function PayChoseTipLayer:WxPayClick()
	self.part:payWeiXin()
	self.part:deactivate()
end

function PayChoseTipLayer:closeClick()
	self.part:deactivate()
end

return PayChoseTipLayer