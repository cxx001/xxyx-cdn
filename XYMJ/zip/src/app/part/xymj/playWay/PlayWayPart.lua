--[[
*名称:PlayWayPart
*描述:提示界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local PlayWayPart = class("PlayWayPart",cc.load('mvc').PartBase) --登录模块
PlayWayPart.DEFAULT_VIEW = "PlayWayLayer"
--[
-- @brief 构造函数
--]
function PlayWayPart:ctor(owner)
    PlayWayPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function PlayWayPart:initialize()
	
end

--激活模块
function PlayWayPart:activate(info)
	local pInfo = clone(info)
    PlayWayPart.super.activate(self,CURRENT_MODULE_NAME)
    if self.view then
    	self.view:updatePlayWay(pInfo)
    end
end


function PlayWayPart:deactivate()
	if self.view then
		self.view:removeFromParent()
		self.view = nil 
	end
end

function PlayWayPart:getPartId()
	-- body
	return "PlayWayPart"
end

return PlayWayPart 