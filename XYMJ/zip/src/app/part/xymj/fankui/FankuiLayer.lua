--[[
*名称:FankuiLayer
*描述:通知界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local FankuiLayer = class("FankuiLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
function FankuiLayer:onCreate(data) --传入数据
	-- body
	self:addMask()
	self:initWithFilePath("FankuiLayer",CURRENT_MODULE_NAME)
    local scale = display.width/1280
	self.node.bg:setScale(scale)

	self.node.text_field_down_bg:hide()
	self.node.text_field_down:hide()
end


function FankuiLayer:CloseClick()
    global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
	self.part:deactivate()
end

function FankuiLayer:onSendClick()
	print("on send click")
	self.part:uploadLogFile(self.node.text_field:getString())
end

function FankuiLayer:onTextfieldCallback(_, sender, event)
	if self.timer then --如果正在计时就重新开始
		self:unScheduler(self.timer)
		self.timer = nil
	end

	if event == ccui.TextFiledEventType.attach_with_ime then
		self.node.text_field_down_bg:show()
		self.node.text_field_down:show()
	elseif event == ccui.TextFiledEventType.detach_with_ime then
		self.node.text_field_down_bg:hide()
		self.node.text_field_down:hide()
	elseif event == ccui.TextFiledEventType.insert_text or event == ccui.TextFiledEventType.delete_backward then
		self.node.text_field_down_bg:show()
		self.node.text_field_down:show()
		self.node.text_field_down:setString(self.node.text_field:getString())
	end

	self.timer = self:schedulerFunc(function()
		-- body
		if self.timer then
			self:unScheduler(self.timer)
			self.timer = nil
		end

		self.node.text_field_down_bg:hide()
		self.node.text_field_down:hide()
	end,5,false) 
end

return FankuiLayer
