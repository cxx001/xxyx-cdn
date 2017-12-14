
local TableScene = import(".TableScene")
local XYTableScene = class("XYTableScene",TableScene)

function XYTableScene:onCreate()
	XYTableScene.super.onCreate(self)
end

function XYTableScene:showNaozhuangIcon(viewId)
	local naozhuangIcon = self.node['icon_naozhuang' .. viewId]
	if naozhuangIcon then
		naozhuangIcon:show()
	end
end

function XYTableScene:showTongnaoIcon(viewId)
	local tongnaoIcon = self.node['icon_tongnao' .. viewId]
	if tongnaoIcon then
		tongnaoIcon:show()
	end
end

function XYTableScene:isNaozhuangIconShow()
	local ret = false

	if self.node.icon_naozhuang1 and self.node.icon_naozhuang1:isVisible() then
		ret = true
	elseif self.node.icon_tongnao1 and self.node.icon_tongnao1:isVisible() then
		ret = true
	end

	return ret
end

--剩下多少张
function XYTableScene:updateLastCardNum(num)
	-- body
	self.node.table_info_txt:setString(string.format(string_table.cards_left_txt,num) .. " " .. self.part:getPlayWay())
end

return XYTableScene