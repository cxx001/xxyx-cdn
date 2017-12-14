--[[
*名称:TelNumInputLayer
*描述:输入手机号界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local TelNumInputLayer = class("TelNumInputLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
function TelNumInputLayer:onCreate(data) --传入数据
	-- body
	self:addMask()
	self:initWithFilePath("TelNumInputLayer",CURRENT_MODULE_NAME)
    self.node.bg:show()
    self.node.bg2:hide()
end

function TelNumInputLayer:notScroll()
    local scrollInfo = self.node.info_scorll 
    if scrollInfo then
        scrollInfo:setEnabled(false)
    end
end

function TelNumInputLayer:OkClick()
	print("TelNumInputLayer ---1----")
	if self.part and self.part.onOkClick then
		print("TelNumInputLayer ---2----")
		self.part:onOkClick(self.node.input_telnum:getString())
	end
	
	if self.part then
		self.part:deactivate()
	end  
end

function TelNumInputLayer:CancelClick()
	if self.part then
		self.part:deactivate()
	end
end

function TelNumInputLayer:getTelNum()
    local ret = ""
    if self.node.input_telnum then
        ret = self.node.input_telnum:getString()
    end
    return ret
end

return TelNumInputLayer