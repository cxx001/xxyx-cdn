--[[
*名称:XiazuiLayer
*描述:提示界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local XiazuiLayer = class("XiazuiLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
function XiazuiLayer:onCreate(data) --传入数据
	-- body
	self:addMask()
	self:initWithFilePath("XiazuiLayer",CURRENT_MODULE_NAME)
	self:initCheckList()
	self:startCountTime(10)
end

function XiazuiLayer:setAreaType(xiazui_type)
	if xiazui_type and xiazui_type == 1 then
		self:showZhuangArea()
	else
		self:showNormalArea()
	end
end

function XiazuiLayer:initCheckList()
	self._ctTb = {}
	self._ctTb[1]= self.node.choose_menqing
	self._ctTb[2]= self.node.choose_jiazi
	self._ctTb[3]= self.node.choose_duanmen
	self._ctTb[4]= self.node.choose_bazhang
	self._ctTb[5]= self.node.choose_zhadan
	self._ctTb[6]= self.node.choose_paozi
	self:updateSelectState()
end

function XiazuiLayer:updateSelectState()
	for k,v in pairs(self._ctTb) do
		local title = v:getChildByName("times_txt")
		local titleSelected = v:getChildByName("times_txt_0")
		if title and titleSelected  then
			if v:isSelected() then
				title:hide()
				titleSelected:show()
			else
				title:show()
				titleSelected:hide()
			end
		end
	end
end

function XiazuiLayer:showZhuangArea()
	self.node.choose_paozi:show()
end

function XiazuiLayer:showNormalArea()
	self.node.choose_paozi:hide()
end

function XiazuiLayer:onSelectMenqing(_, sender, event)
	if event == ccui.CheckBoxEventType.selected then
		self.node.choose_menqing:setSelected(true)
		self:updateSelectState()
	elseif event == ccui.CheckBoxEventType.unselected then
		self.node.choose_menqing:setSelected(false)
		self:updateSelectState()
	else
		--do nothing
	end	
end

function XiazuiLayer:onSelectJiazi(_, sender, event)
	if event == ccui.CheckBoxEventType.selected then
		self.node.choose_jiazi:setSelected(true)
		self:updateSelectState()
	elseif event == ccui.CheckBoxEventType.unselected then
		self.node.choose_jiazi:setSelected(false)
		self:updateSelectState()
	else
		--do nothing
	end	
end

function XiazuiLayer:onSelectDuanmen(_, sender, event)
	if event == ccui.CheckBoxEventType.selected then
		self.node.choose_duanmen:setSelected(true)
		self:updateSelectState()
	elseif event == ccui.CheckBoxEventType.unselected then
		self.node.choose_duanmen:setSelected(false)
		self:updateSelectState()
	else
		--do nothing
	end	
end

function XiazuiLayer:onSelectBazhang(_, sender, event)
	if event == ccui.CheckBoxEventType.selected then
		self.node.choose_bazhang:setSelected(true)
		self:updateSelectState()
	elseif event == ccui.CheckBoxEventType.unselected then
		self.node.choose_bazhang:setSelected(false)
		self:updateSelectState()
	else
		--do nothing
	end	
end

function XiazuiLayer:onSelectZhadan(_, sender, event)
	if event == ccui.CheckBoxEventType.selected then
		self.node.choose_zhadan:setSelected(true)
		self:updateSelectState()
	elseif event == ccui.CheckBoxEventType.unselected then
		self.node.choose_zhadan:setSelected(false)
		self:updateSelectState()
	else
		--do nothing
	end	
end

function XiazuiLayer:onSelectPaozi(_, sender, event)
	if event == ccui.CheckBoxEventType.selected then
		self.node.choose_paozi:setSelected(true)
		self:updateSelectState()
	elseif event == ccui.CheckBoxEventType.unselected then
		self.node.choose_paozi:setSelected(false)
		self:updateSelectState()
	else
		--do nothing
	end	
end

function XiazuiLayer:isMenqingSelected()
	local ret = false
	if self.node.choose_menqing and self.node.choose_menqing:isSelected() then
		ret = true
	end
	return ret
end

function XiazuiLayer:isJiaziSelected()
	local ret = false
	if self.node.choose_jiazi and self.node.choose_jiazi:isSelected() then
		ret = true
	end
	return ret
end

function XiazuiLayer:isDuamenSelected()
	local ret = false
	if self.node.choose_duanmen and self.node.choose_duanmen:isSelected() then
		ret = true
	end
	return ret
end

function XiazuiLayer:isBazhangSelected()
	local ret = false
	if self.node.choose_bazhang and self.node.choose_bazhang:isSelected() then
		ret = true
	end
	return ret
end

function XiazuiLayer:isZhadanSelected()
	local ret = false
	if self.node.choose_zhadan and self.node.choose_zhadan:isSelected() then
		ret = true
	end
	return ret
end

function XiazuiLayer:isPaoziSelected()
	local ret = false
	if self.node.choose_paozi and self.node.choose_paozi:isSelected() then
		ret = true
	end
	return ret
end

function XiazuiLayer:OKClick()
	self.part:onSelectOK()

	if self.part then
		self.part:deactivate()
	end  
end

function XiazuiLayer:CloseClick()
	self.part:onSelectCancle()

	if self.part then
		self.part:deactivate()
	end 
end

--开始倒计时
function XiazuiLayer:startCountTime(lastTime)
	-- body
	local cur_time = 1
	local wait_time = lastTime

	if self.time_entry then --如果正在计时就重新开始
		self:unScheduler(self.time_entry)
	end
	self.node.bearing_time:show()
	self.node.bearing_time:setString(wait_time)
	self.time_entry = self:schedulerFunc(function()
		-- body
		if cur_time > wait_time then
			-- self.node.bearing_time:hide()
			self:unScheduler(self.time_entry)
			return
		end
		local time = wait_time - cur_time
		if time < 10 then
			time = "0" .. time
		end
		self.node.bearing_time:setString(time)
		cur_time = cur_time + 1
	end,1,false)
end

return XiazuiLayer