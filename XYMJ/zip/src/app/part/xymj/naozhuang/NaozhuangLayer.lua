--[[
*名称:NaozhuangLayer
*描述:闹庄界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local NaozhuangLayer = class("NaozhuangLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]

function NaozhuangLayer:onCreate() --传入数据
	-- body
	self:initWithFilePath("NaozhuangLayer",CURRENT_MODULE_NAME)
end

function NaozhuangLayer:MaskClick()
	-- body
	self.part:maskClick()
end

function NaozhuangLayer:showNaozhuangPanel()
	self.node.naozhuang_panel:show()
	self.node.dipan:show()
	self.node.tip_wait_naozhuang_bg:show()
	self.node.tip_wait_naozhuang:show()
	self.node.tip_wait_tongnao:hide()
	self.node.naozhuang_tip:show()
	self.node.btn_nao:show()
	self.node.image_naozhuang:show()
	self.node.image_tongnao:hide()
	self.node.btn_bunao:show()
	self.node.image_bunao:show()
	self:startCountTime(5)
end

function NaozhuangLayer:showTongnaoPanel()
	self.node.naozhuang_panel:show()
	self.node.dipan:show()
	self.node.tip_wait_naozhuang_bg:show()
	self.node.tip_wait_naozhuang:hide()
	self.node.tip_wait_tongnao:show()
	self.node.naozhuang_tip:show()
	self.node.btn_nao:show()
	self.node.image_naozhuang:hide()
	self.node.image_tongnao:show()
	self.node.btn_bunao:show()
	self.node.image_bunao:show()
	self:startCountTime(5)	
end

function NaozhuangLayer:showWaitNaozhuangPanel()
	self.node.naozhuang_panel:show()
	self.node.dipan:show()
	self.node.tip_wait_naozhuang_bg:show()
	self.node.tip_wait_naozhuang:show()
	self.node.tip_wait_tongnao:hide()
	self.node.naozhuang_tip:hide()
	self.node.btn_nao:hide()
	self.node.image_naozhuang:hide()
	self.node.image_tongnao:hide()
	self.node.btn_bunao:hide()
	self.node.image_bunao:hide()
	self:startCountTime(5)
end

function NaozhuangLayer:showWaitTongnaoPanel()
	self.node.naozhuang_panel:show()
	self.node.dipan:show()
	self.node.tip_wait_naozhuang_bg:show()
	self.node.tip_wait_naozhuang:hide()
	self.node.tip_wait_tongnao:show()
	self.node.naozhuang_tip:hide()
	self.node.btn_nao:hide()
	self.node.image_naozhuang:hide()
	self.node.image_tongnao:hide()
	self.node.btn_bunao:hide()
	self.node.image_bunao:hide()	
	self:startCountTime(5)
end

function NaozhuangLayer:onSelectNao()
	print("naozhuang layer on select nao")
	self.node.btn_nao:hide()
	self.node.btn_bunao:hide()

	if self.node.image_naozhuang and self.node.image_naozhuang:isVisible() then
		print("naozhuang layer on select nao zhuang")
		self.part:onSelectNaozhuang()
	else
		print("naozhuang layer on select tong nao")
		self.part:onSelectTongnao()
	end
end

function NaozhuangLayer:onSelectBunao()
	print("naozhuang layer on select bu nao")
	self.node.btn_nao:hide()
	self.node.btn_bunao:hide()

	if self.node.image_naozhuang and self.node.image_naozhuang:isVisible() then
		print("naozhuang rlayer on select bu nao zhuang")
		self.part:onSelectCancleNaozhuang()
	else
		print("naozhuang layer on select bu tong nao")
		self.part:onSelectCancleTongnao()
	end
end

function NaozhuangLayer:hideNaozhuangPanel()
	self.node.naozhuang_panel:hide()
end

function NaozhuangLayer:showTongnaoIcon(viewId)
	local tongnaoIcon = self.node['icon_tongnao' .. viewId]
	if tongnaoIcon then
		tongnaoIcon:show()
	end
end

--开始倒计时
function NaozhuangLayer:startCountTime(lastTime)
	-- body
	local cur_time = 1
	local wait_time = RoomConfig.WaitTime

	if lastTime then
		wait_time = lastTime
	end

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

return NaozhuangLayer
