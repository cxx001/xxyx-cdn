
local CURRENT_MODULE_NAME = ...
local GameEndPart = import(".GameEndPart")
local XYGameEndPart = class("XYGameEndPart",GameEndPart) --登录模块
XYGameEndPart.DEFAULT_VIEW = "XYGameEndLayer"

function XYGameEndPart:setPlaywayStr(playwatStr)
	self.view:setPlaywayStr(playwatStr)
end

function XYGameEndPart:getPlaywayType()
	if self.owner and self.owner.getPlaywayType then
		return self.owner:getPlaywayType()
	end
end

return XYGameEndPart 