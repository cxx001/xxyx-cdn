--[[
*名称:DuihuanLayer
*描述:兑换界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local DuihuanPart = class("DuihuanPart",cc.load('mvc').PartBase) --登录模块
DuihuanPart.DEFAULT_VIEW = "DuihuanLayer"

--[
-- @brief 构造函数
--]
function DuihuanPart:ctor(owner)
    DuihuanPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function DuihuanPart:initialize()
	
end

--激活模块
function DuihuanPart:activate(gameId)
	self.gameId = gameId
	DuihuanPart.super.activate(self,CURRENT_MODULE_NAME)
end

function DuihuanPart:deactivate()
	if self.view then
		self.view:removeSelf()
	  	self.view =  nil
	end
end

function DuihuanPart:getPartId()
	-- body
	return "DuihuanPart"
end

function DuihuanPart:sendDhCode(dhCode)
	if self.owner and self.owner.sendDhCode then
		self.owner:sendDhCode(dhCode)
	end
end

function DuihuanPart:showRecordLayer()
	print("DuihuanRecord -----2------")
	if self.owner and self.owner.onShowDuihuanRecordClick then
		self.owner:onShowDuihuanRecordClick()
	end
end

function DuihuanPart:resetRecordBtn()
	if self.view then
		self.view:resetRecordBtn()
	end
end

function DuihuanPart:resetSendDhCodeBtn()
	if self.view then
		self.view:resetSendDhCodeBtn()
	end
end

return DuihuanPart
