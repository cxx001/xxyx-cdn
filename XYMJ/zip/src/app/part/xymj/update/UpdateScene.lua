--[[
*名称:UpdateLayer
*描述:检查更新界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local UpdateScene = class("UpdateScene",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
function UpdateScene:onCreate()
	-- body
	self:initWithFilePath("UpdateScene",CURRENT_MODULE_NAME)
--[[	if self.schedule_start_update then -- 添加一个延迟，等页面渲染完毕再开始执行检查更新，避免出现收不到版本检测消息的情况
		self:unScheduler(self.schedule_start_update)
		self.schedule_start_update = nil
	end

	self.schedule_start_update = self:schedulerFunc(function()
		self:unScheduler(self.schedule_start_update)
		self.schedule_start_update = nil
		print("UpdateScene:onCreate()--开始热更新流程")
		self.part:startUpdateFile()
	end,1,false)--]]
end

function UpdateScene:updateProgress(percent)
	-- body
	self.node.update_progress:show()
	self.node.update_progress:setPercent(percent)
	if not ISAPPSTORE then
		self.node.update_info:setString("正在更新文件，稍等片刻，精彩游戏马上开始！")--string.format("%d%%",percent))
	end
end

function UpdateScene:ClickUpdateInfo(...)
	self.part:ClickUpdateInfo(...)
end

function UpdateScene:showUpdateMessage(strMsg)
	self.node.update_info:setString(strMsg)
end

function UpdateScene:setVisibleUpdateInfo(isVisible)
	-- body
	self.node.update_info:setVisible(isVisible)
end

return UpdateScene