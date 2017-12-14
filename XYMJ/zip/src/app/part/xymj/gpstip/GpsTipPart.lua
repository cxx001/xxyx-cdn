--[[
*名称:GpsTipLayer
*描述:通知界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local GpsTipPart = class("GpsTipPart",cc.load('mvc').PartBase) --登录模块
GpsTipPart.DEFAULT_VIEW = "GpsTipLayer"

--[
-- @brief 构造函数
--]
function GpsTipPart:ctor(owner)
    GpsTipPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function GpsTipPart:initialize()
	
end

--激活模块
function GpsTipPart:activate(gameId)
	-- gameId = 262401 --临时调试用
	self.game_id = gameId
	GpsTipPart.super.activate(self,CURRENT_MODULE_NAME)
	self.view:setShow(false)
end

function GpsTipPart:setInfo(index,distance)
	-- body
	print("GpsTipPart:setInfo : ",index,distance)

	local player1 = {}
	local player2 = {}
    if index == 1 then
        player1 = self:getPlayerInfo(1)
        player2 = self:getPlayerInfo(2)
    elseif index == 2 then
        player1 = self:getPlayerInfo(1)
        player2 = self:getPlayerInfo(3)
    elseif index == 3 then
        player1 = self:getPlayerInfo(1)
        player2 = self:getPlayerInfo(4)
    elseif index == 4 then
        player1 = self:getPlayerInfo(2)
        player2 = self:getPlayerInfo(3)
    elseif index == 5 then
        player1 = self:getPlayerInfo(2)
		player2 = self:getPlayerInfo(4)
	elseif index == 6 then
		player1 = self:getPlayerInfo(3)
		player2 = self:getPlayerInfo(4)
	end
		self.view:setInfo(index,distance,player1.name,player2.name)
end

function GpsTipPart:getPlayerInfo(viewId)
	-- body
	return self.owner:getPlayerInfo(viewId)
end

function GpsTipPart:deactivate()
	if self.view ~= nil then
		self.view:removeSelf()
  		self.view = nil
  	end
end

function GpsTipPart:closeVipRoom()
    -- body
    self.owner:closeVipRoom(true)
end

function GpsTipPart:getPartId()
	-- body
	return "GpsTipPart"
end

return GpsTipPart 
