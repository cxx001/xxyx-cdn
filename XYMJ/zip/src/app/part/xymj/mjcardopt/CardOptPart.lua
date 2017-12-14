--[[
*名称:CardOptLayer
*描述:类
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local CardOptPart = class("CardOptPart",cc.load('mvc').PartBase) --登录模块
CardOptPart.DEFAULT_PART = {}
CardOptPart.DEFAULT_VIEW = "CardOptNode"
--[
-- @brief 构造函数
--]
function CardOptPart:ctor(owner)
    CardOptPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function CardOptPart:initialize()
	
end

--激活模块
function CardOptPart:activate(gameId,pos,type,node)
	-- gameId = 262401 --临时调试用
	self.game_id = gameId
	print("###[CardOptPart:activate] 操作动画")
	self.view = global:importViewWithName(CURRENT_MODULE_NAME,self.DEFAULT_VIEW,self)
	self.view:setPosition(pos)
    -- self.view:bindPart(self) --界面绑定到当前组件
   	-- if self.owner.view ~= nil then
   	-- 	self.owner.view:addChild(self.view)
   	-- end
   	node:addChild(self.view, 999)
   	self.view:playAnimate(type)
end

function CardOptPart:deactivate()
    if self.view ~= nil then
    	self.view:removeSelf()
    	self.view =  nil
	end
	print("this is deactivate------:",self.view)
end

local view_id = 2
function CardOptPart:animateOver()
	-- body
	self:deactivate()
	if RoomConfig.Ai_Debug then
		local ai_mode = global:getModuleWithId(ModuleDef.AI_MOD)
		ai_mode:requestOpt(1)
	end
end

function CardOptPart:getPartId()
	-- body
	return "CardOptPart"
end

return CardOptPart 