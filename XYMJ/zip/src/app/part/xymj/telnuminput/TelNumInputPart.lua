--[[
*名称:TelNumInputLayer
*描述:收入手机号界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local TelNumInputPart = class("TelNumInputPart",cc.load('mvc').PartBase) --登录模块
TelNumInputPart.DEFAULT_VIEW = "TelNumInputLayer"
TelNumInputPart.ZORDER = 255

--[
-- @brief 构造函数
--]
function TelNumInputPart:ctor(owner)
    TelNumInputPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function TelNumInputPart:initialize()
	
end

--激活模块
function TelNumInputPart:activate(gameId, callback)

	print("XXXXXXXX TelNumInputPart:Active ", gameId, callback)

    self.zorder = TelNumInputPart.ZORDER
    self.game_id = gameId
    self.ok_callback = callback

    print("XXXXXXXX TelNumInputPart:Active self.ok_callback ", self.ok_callback)


    TelNumInputPart.super.activate(self,CURRENT_MODULE_NAME)
end

function TelNumInputPart:getTelNum()
	local ret = ""
	if self.view then
		ret = self.view:getTelNum()
	end
	return ret
end

function TelNumInputPart:notScroll()
	if self.view then
		self.view:notScroll()
	end
end

function TelNumInputPart:deactivate()
	if self.view then
		self.view:removeFromParent()
		self.view = nil 
	end
end

function TelNumInputPart:onOkClick(telNum)
	print("TelNumInputLayer ---3---- ", self.ok_callback)
	if self.ok_callback then
		print("TelNumInputLayer ---4----")
		self.ok_callback(telNum)
	end
end

function TelNumInputPart:getPartId()
	return "TelNumInputPart"
end

return TelNumInputPart 