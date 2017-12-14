--[[
*名称:RecordLayer
*描述:战绩记录界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local RecordStopPart = class("RecordStopPart",cc.load('mvc').PartBase) --登录模块
RecordStopPart.DEFAULT_VIEW = "RecordStopLayer"

--[
-- @brief 构造函数
--]
function RecordStopPart:ctor(owner)
    RecordStopPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function RecordStopPart:initialize()
	
end

--激活模块
function RecordStopPart:activate()
	RecordStopPart.super.activate(self,CURRENT_MODULE_NAME)
end

function RecordStopPart:deactivate()
	self.view:removeSelf()
 	self.view =  nil
end

function RecordStopPart:getPartId()
	-- body
	return "RecordStopPart"
end

function RecordStopPart:clickEvent(event)
	self.owner:clickEvent(event)
end


function RecordStopPart:backEvent()
	self.owner:backEvent()
end

return RecordStopPart 