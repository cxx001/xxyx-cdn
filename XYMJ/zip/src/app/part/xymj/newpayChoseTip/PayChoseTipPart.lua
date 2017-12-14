--[[
*名称:PayChoseTipPart
*描述:提示界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local PayChoseTipPart = class("PayChoseTipPart",cc.load('mvc').PartBase) --登录模块
PayChoseTipPart.DEFAULT_VIEW = "PayChoseTipLayer"
--[
-- @brief 构造函数
--]
function PayChoseTipPart:ctor(owner)
    PayChoseTipPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function PayChoseTipPart:initialize()
	
end

--激活模块
function PayChoseTipPart:activate(index)
    PayChoseTipPart.super.activate(self,CURRENT_MODULE_NAME)
    self.selectIndex = index
end

--微信支付
function PayChoseTipPart:payWeiXin()
	print("payWeiXin:"..self.selectIndex)
	self.owner:requestOrder(self.owner.WX_PAY,self.selectIndex)
end

--支付宝支付
function PayChoseTipPart:payAiLi()
	print("payAiLi:"..self.selectIndex)
	self.owner:requestOrder(self.owner.ALI_PAY,self.selectIndex)
end
--苹果支付
function PayChoseTipPart:payApple()
	-- print("payApple:"..self.selectIndex)
	print("payApple:"..self.owner.IAP_PAY)
	self.owner:requestOrder(self.owner.IAP_PAY,1)
end

function PayChoseTipPart:deactivate()
	if self.view then
		self.view:removeFromParent()
		self.view = nil 
	end
end

function PayChoseTipPart:getPartId()
	-- body
	return "PayChoseTipPart"
end

return PayChoseTipPart 