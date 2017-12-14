--[[
*名称:LoadingLayer
*描述:加载动画界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local LoadingPart = class("LoadingPart",cc.load('mvc').PartBase) --登录模块
LoadingPart.DEFAULT_VIEW = "LoadingLayer"
LoadingPart.ZORDER = 0xff

--[
-- @brief 构造函数
--]
function LoadingPart:ctor(owner)
    LoadingPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function LoadingPart:initialize()
	
end

--激活模块
function LoadingPart:activate(gameID)
    self.game_id = gameID
    self.zorder = LoadingPart.ZORDER
	LoadingPart.super.activate(self,CURRENT_MODULE_NAME)
end

function LoadingPart:deactivate()
	if self.view then
		self.view:removeSelf()
		self.view = nil
	end
end

function LoadingPart:getPartId()
	-- body
	return "LoadingPart"
end

return LoadingPart 