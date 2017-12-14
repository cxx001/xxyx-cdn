--[[
*名称:RecordLayer
*描述:战绩记录界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local RecordStopLayer = class("RecordStopLayer",cc.load("mvc").ViewBase)
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
local CURRENT_MODULE_NAME = ...


function RecordStopLayer:onCreate(data) --传入数据
	-- body
	self:initWithFilePath("RecordStopLayer", CURRENT_MODULE_NAME)
	
	self:initUI()
	self:updateUI()
end

function RecordStopLayer:initUI()
	self.node.play:setVisible(false)

	self.pos_x = self.node.stop_root:getPositionX()
	self.pos_y = self.node.stop_root:getPositionY()
	self:addEvent()
end

function RecordStopLayer:updateUI(game_data)
	
end

--[[
@ 重置 播放、暂停按钮
]]
function RecordStopLayer:resetUI(cur_ju, total_ju)
	if not cur_ju or not total_ju then
		return 
	end

	self.node.stop:setVisible(true)
	self.node.play:setVisible(false)
end

function RecordStopLayer:addEvent()
	-- @ 初始化位置
	self.node.stop_panel:setSwallowTouches(false)
	self.node.stop_panel:addTouchEventListener(function(sender, event)
		if event == ccui.TouchEventType.began then
			-- @ 开始弹入屏幕
			local ui_stop = self.node.stop_root
			ui_stop:stopAllActions()

			if ui_stop:getPositionY() > -self.pos_y then
				self:hideStopRoot(0.1)
			else
				ui_stop:runAction(cc.MoveTo:create(0.2, cc.p(self.pos_x, self.pos_y)))
			end
		elseif event == ccui.TouchEventType.ended or event == ccui.TouchEventType.canceled then
			-- @ 开始倒计时缩回
			self:hideStopRoot()
		end
	end)

	self:hideStopRoot()
end

function RecordStopLayer:hideStopRoot(delay)
	if not delay then
		delay = 3
	end
	local delay_time = cc.DelayTime:create(delay)
	local move_to = cc.MoveTo:create(0.2, cc.p(self.pos_x, -(self.pos_y) ))
	local seq = cc.Sequence:create(delay_time, move_to)
	self.node.stop_root:runAction(seq)	
end

function RecordStopLayer:lastJuClick()
	self.part:clickEvent('last_ju_event')
end

function RecordStopLayer:lastStepClick()
	self.part:clickEvent('last_step_event')
end

function RecordStopLayer:playClick()
	self.node.stop:setVisible(true)
	self.node.play:setVisible(false)

	self.part:clickEvent('play_event')
end

function RecordStopLayer:stopClick()
	self.node.stop:setVisible(false)
	self.node.play:setVisible(true)

	self.part:clickEvent('stop_event')
end

function RecordStopLayer:nextStepClick()
	self.part:clickEvent('next_step_event')
end

function RecordStopLayer:nextJuClick()
	self.part:clickEvent('next_ju_event')
end

function RecordStopLayer:isStop()
	if self.node.stop:isVisible() then
		return false
	end
	return true
end

function RecordStopLayer:backEvent()
	self.part:backEvent()
end

return RecordStopLayer
