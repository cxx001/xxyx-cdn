--[[
*名称:HelpLayer
*描述:玩法介绍界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local HelpPart = class("HelpPart",cc.load('mvc').PartBase) --登录模块
HelpPart.DEFAULT_VIEW = "HelpLayer"

--[
-- @brief 构造函数
--]
function HelpPart:ctor(owner)
    HelpPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function HelpPart:initialize()
	
end

--激活模块
function HelpPart:activate(gameId,data)
    self.game_id = gameId
	HelpPart.super.activate(self,CURRENT_MODULE_NAME)
end

function HelpPart:deactivate()
	if self.view ~= nil then
		self.view:removeSelf()
  		self.view = nil
  	end
end

function HelpPart:selectChoose(rule_type)
	-- body
	self.view:selectChoose(rule_type)
end

function HelpPart:selectrule(rule_type)
	-- body
	self.view:selectrule(rule_type)
end

function HelpPart:getPartId()
	-- body
	return "HelpPart"
end

return HelpPart 