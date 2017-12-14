--[[
*名称:PlayWayLayer
*描述:提示界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local PlayWayLayer = class("PlayWayLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
function PlayWayLayer:onCreate(data) --传入数据
	-- body
	self:addMask()
	self:initWithFilePath("PlayWayLayer",CURRENT_MODULE_NAME)
end

function PlayWayLayer:updatePlayWay(info)

	self.node.txt_numInfo:setString(info.playWayGameNumInfo)
	self.node.txt_play:setString(info.playWayStr)
	for i=1,6 do	--目前只支持六条
		self.node["txt_"..i]:hide()
	end
	for i,v in ipairs(info.playWaySelectStr) do
		local txtSelPlayWay =self.node["txt_"..i]
		if txtSelPlayWay then
			txtSelPlayWay:setString(v)
			txtSelPlayWay:show()
		end
	end
end

function PlayWayLayer:CloseClick()
	self.part:deactivate()
end

return PlayWayLayer