--[[
*名称:DuihuanLayer
*描述:通知界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local DuihuanLayer = class("DuihuanLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
function DuihuanLayer:onCreate(data) --传入数据
	-- body
	self:addMask()
	self:initWithFilePath("DuihuanLayer",CURRENT_MODULE_NAME)
    local scale = display.width/1280
	self.node.bg:setScale(scale)

	self.node.button_send:setEnabled(true)
	self.node.btn_record:setEnabled(true)
end


function DuihuanLayer:CloseClick()
    global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
	self.part:deactivate()
end

function DuihuanLayer:onOkClick()
	print("on send click")
	self.node.button_send:setEnabled(false)
	local dhCode = string.sub(self.node.text_field:getString(), 1, -1)
	self.part:sendDhCode(dhCode)
end

function DuihuanLayer:onRecordClick()
	print("DuihuanRecord -----1------")
	self.part:showRecordLayer()
	self.node.btn_record:setEnabled(false)
end

function DuihuanLayer:onTextfieldCallback(_, sender, event)
	--do nothing
end

function DuihuanLayer:resetRecordBtn()
	if self.node.btn_record then
		self.node.btn_record:setEnabled(true)
	end
end

function DuihuanLayer:resetSendDhCodeBtn()
	if self.node.button_send then
		self.node.button_send:setEnabled(true)
	end
end

return DuihuanLayer
