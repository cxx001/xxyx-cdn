--[[
*名称:ReferrerLayer
*描述:关联界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local ReferrerLayer = class("ReferrerLayer",cc.load("mvc").ViewBase)
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
function ReferrerLayer:onCreate(data) --传入数据
	-- body
	self:addMask()
	self:init("ReferrerLayer")
	self.ReferrerId = 0
end

function ReferrerLayer:OkClick()
	-- body
	local txt = tonumber(self.node.input_feild:getString())
	print("--------------txt : ",txt)
	self.part:okClick(txt)
end

function ReferrerLayer:cancelClick()
	-- body
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self.part:deactivate()
end

return ReferrerLayer