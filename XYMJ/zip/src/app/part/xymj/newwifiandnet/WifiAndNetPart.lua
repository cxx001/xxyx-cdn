--[[
*名称:WifiAndNetLayer
*描述:网络状况界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local WifiAndNetPart = class("WifiAndNetPart",cc.load('mvc').PartBase) --登录模块

WifiAndNetPart.DEFAULT_VIEW = "WifiAndNetNode"
--[
-- @brief 构造函数
--]
function WifiAndNetPart:ctor(owner)
    WifiAndNetPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function WifiAndNetPart:initialize()
	self.frame_count = 30
end

--激活模块
function WifiAndNetPart:activate(gameId,node)
    	self.game_id = gameId
	WifiAndNetPart.super.activate(self, CURRENT_MODULE_NAME,node)
	self.view:startUpdate()
end

function WifiAndNetPart:deactivate()
	self.view:removeSelf()
	self.view =  nil
end

function WifiAndNetPart:getPartId()
	-- body
	return "WifiAndNetPart"
end

function WifiAndNetPart:checkUpdateInfo()
	-- body
	local n_time = os.date("%H/%M") -- 艺术数字'/'显示位':'
	self.view:updateTime(n_time)
	local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
	local battery_status = lua_bridge:getBatteryStatus()
	local net_status = lua_bridge:getNetStatus()
	self.view:updateBattery(battery_status)
	self.view:updateWifi(net_status,100)
end

return WifiAndNetPart 