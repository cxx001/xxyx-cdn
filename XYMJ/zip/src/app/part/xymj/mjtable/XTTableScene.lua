
local XTTableScene = class("XTTableScene", import(".HBTableScene"))
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]

local function getPlayWayTexs(playwaytype)
	local mainPlayWay      = bit._and(playwaytype, 0xf)
	local optionalPlayWays = playwaytype - mainPlayWay

	local mainPlayWayTex = nil
	for _, v in ipairs(RoomConfig.Rule) do
		if v.value == mainPlayWay then
			mainPlayWayTex = v.tex
			break
		end
	end

	local optionalPlayWayTex = nil
	for _, v in ipairs(RoomConfig.Rule2) do
		if bit.check(optionalPlayWays, v.value) then
			optionalPlayWayTex = v.tex
			break
		end
	end

	return mainPlayWayTex, optionalPlayWayTex
end

function XTTableScene:updateTableShow(tableInfo)
	local mainPlayWayTex, optionalPlayWayTex = getPlayWayTexs(tableInfo.playwaytype)
	print("=========XTTableScene:updateTableShow(%s, %s)", tostring(mainPlayWayTex), tostring(optionalPlayWayTex))

	if not mainPlayWayTex then
		return
	end

	local visiblePlayWay = nil
	if optionalPlayWayTex then
		self.node.playway:setVisible(false)
		self.node.playway_with_option:setVisible(true)
		visiblePlayWay = self.node.playway_with_option
	else
		self.node.playway:setVisible(true)
		self.node.playway_with_option:setVisible(false)
		visiblePlayWay = self.node.playway
	end

	local tableResBase = self.res_base .. "/"

	local mainPlayImage = visiblePlayWay:getChildByName("main")
	if mainPlayImage then
		mainPlayImage:ignoreContentAdaptWithSize(true)
		mainPlayImage:loadTexture(tableResBase .. mainPlayWayTex, 1)
	end

	local optionalPlayImage = visiblePlayWay:getChildByName("option")
	if optionalPlayImage then
		optionalPlayImage:ignoreContentAdaptWithSize(true)
		optionalPlayImage:loadTexture(tableResBase .. optionalPlayWayTex, 1)
	end
end


return XTTableScene
