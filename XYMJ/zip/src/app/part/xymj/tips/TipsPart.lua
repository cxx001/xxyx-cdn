--[[
*名称:TipsLayer
*描述:提示界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local TipsPart = class("TipsPart",cc.load('mvc').PartBase) --登录模块
TipsPart.DEFAULT_VIEW = "TipsLayer"
TipsPart.ZORDER = 255

--[
-- @brief 构造函数
--]
function TipsPart:ctor(owner)
    TipsPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function TipsPart:initialize()
	
end

--激活模块
function TipsPart:activate(info)
    self.zorder = TipsPart.ZORDER
    TipsPart.super.activate(self,CURRENT_MODULE_NAME)
	self.view:setInfo(info)
end

function TipsPart:notScroll()
	if self.view then
		self.view:notScroll()
	end
end

function TipsPart:deactivate()
	if self.view then
		self.view:removeFromParent()
		self.view = nil 
	end
end

function TipsPart:getPartId()
	-- body
	return "TipsPart"
end

return TipsPart 