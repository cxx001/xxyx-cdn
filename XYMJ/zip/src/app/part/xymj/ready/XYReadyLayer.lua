
local ReadyLayer = import(".ReadyLayer")
local XYReadyLayer = class("XYReadyLayer",ReadyLayer)

function XYReadyLayer:showNaozhuangPanel()
	-- self.node.naozhuang_panel:show()
	-- self.node.dipan:show()
	-- self.node.tip_wait_naozhuang_bg:show()
	-- self.node.tip_wait_naozhuang:show()
	-- self.node.tip_wait_tongnao:hide()
	-- self.node.naozhuang_tip:show()
	-- self.node.btn_nao:show()
	-- self.node.image_naozhuang:show()
	-- self.node.image_tongnao:hide()
	-- self.node.btn_bunao:show()
	-- self.node.image_bunao:show()
	-- self.node.ready_img:hide()
	-- self:startCountTime(5)
end

function XYReadyLayer:showTongnaoPanel()
	-- self.node.naozhuang_panel:show()
	-- self.node.dipan:show()
	-- self.node.tip_wait_naozhuang_bg:show()
	-- self.node.tip_wait_naozhuang:hide()
	-- self.node.tip_wait_tongnao:show()
	-- self.node.naozhuang_tip:show()
	-- self.node.btn_nao:show()
	-- self.node.image_naozhuang:hide()
	-- self.node.image_tongnao:show()
	-- self.node.btn_bunao:show()
	-- self.node.image_bunao:show()
	-- self.node.ready_img:hide()
	-- self:startCountTime(5)	
end

function XYReadyLayer:showWaitNaozhuangPanel()
	-- self.node.naozhuang_panel:show()
	-- self.node.dipan:show()
	-- self.node.tip_wait_naozhuang_bg:show()
	-- self.node.tip_wait_naozhuang:show()
	-- self.node.tip_wait_tongnao:hide()
	-- self.node.naozhuang_tip:hide()
	-- self.node.btn_nao:hide()
	-- self.node.image_naozhuang:hide()
	-- self.node.image_tongnao:hide()
	-- self.node.btn_bunao:hide()
	-- self.node.image_bunao:hide()
	-- self.node.ready_img:hide()
	-- self:startCountTime(5)
end

function XYReadyLayer:showWaitTongnaoPanel()
	-- self.node.naozhuang_panel:show()
	-- self.node.dipan:show()
	-- self.node.tip_wait_naozhuang_bg:show()
	-- self.node.tip_wait_naozhuang:hide()
	-- self.node.tip_wait_tongnao:show()
	-- self.node.naozhuang_tip:hide()
	-- self.node.btn_nao:hide()
	-- self.node.image_naozhuang:hide()
	-- self.node.image_tongnao:hide()
	-- self.node.btn_bunao:hide()
	-- self.node.image_bunao:hide()
	-- self.node.ready_img:hide()	
	-- self:startCountTime(5)
end

function XYReadyLayer:onSelectNao()
	-- print("xymj readylayer on select nao")
	-- self.node.btn_nao:hide()
	-- self.node.btn_bunao:hide()

	-- if self.node.image_naozhuang and self.node.image_naozhuang:isVisible() then
	-- 	print("xymj readylayer on select nao zhuang")
	-- 	self.part:onSelectNaozhuang()
	-- else
	-- 	print("xymj readylayer on select tong nao")
	-- 	self.part:onSelectTongnao()
	-- end
end

function XYReadyLayer:onSelectBunao()
	-- print("XYReadyLayer:onSelectBunao")
	-- self.node.btn_nao:hide()
	-- self.node.btn_bunao:hide()

	-- if self.node.image_naozhuang and self.node.image_naozhuang:isVisible() then
	-- 	print("xymj readylayer on select bu nao zhuang")
	-- 	self.part:onSelectCancleNaozhuang()
	-- else
	-- 	print("xymj readylayer on select bu tong nao")
	-- 	self.part:onSelectCancleTongnao()
	-- end
end

function XYReadyLayer:hideNaozhuangPanel()
	-- self.node.naozhuang_panel:hide()
	-- self.node.ready_img:show()
end

function XYReadyLayer:showNaozhuangIcon(viewId)
	-- local naozhuangIcon = self.node['icon_naozhuang' .. viewId]
	-- if naozhuangIcon then
	-- 	naozhuangIcon:show()
	-- end
end

function XYReadyLayer:showTongnaoIcon(viewId)
	-- local tongnaoIcon = self.node['icon_tongnao' .. viewId]
	-- if tongnaoIcon then
	-- 	tongnaoIcon:show()
	-- end
end

--开始倒计时
function XYReadyLayer:startCountTime(lastTime)
	-- -- body
	-- local cur_time = 1
	-- local wait_time = RoomConfig.WaitTime

	-- if lastTime then
	-- 	wait_time = lastTime
	-- end

	-- if self.time_entry then --如果正在计时就重新开始
	-- 	self:unScheduler(self.time_entry)
	-- end
	-- self.node.bearing_time:show()
	-- self.node.bearing_time:setString(wait_time)
	-- self.time_entry = self:schedulerFunc(function()
	-- 	-- body
	-- 	if cur_time > wait_time then
	-- 		-- self.node.bearing_time:hide()
	-- 		self:unScheduler(self.time_entry)
	-- 		return
	-- 	end
	-- 	local time = wait_time - cur_time
	-- 	if time < 10 then
	-- 		time = "0" .. time
	-- 	end
	-- 	self.node.bearing_time:setString(time)
	-- 	cur_time = cur_time + 1
	-- end,1,false)
end

return XYReadyLayer