--[[
*名称:NoticeLayer
*描述:通知界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local NoticeLayer = class("NoticeLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
function NoticeLayer:onCreate(data) --传入数据
	-- body
	self:addMask()
	self:initWithFilePath("NoticeLayer",CURRENT_MODULE_NAME)
    local scale = display.width/1280
	self.node.bg:setScale(scale)
end


function NoticeLayer:CloseClick()
    global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
	self.part:deactivate()
end

function NoticeLayer:setNoticeInfo(str)
	-- body
	self.node.notice_txt:setString(str)
end

return NoticeLayer
