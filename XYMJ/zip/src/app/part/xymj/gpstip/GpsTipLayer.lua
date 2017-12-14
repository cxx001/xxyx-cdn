--[[
*名称:GpsTipLayer
*描述:通知界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local GpsTipLayer = class("GpsTipLayer",cc.load("mvc").ViewBase)
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
local CURRENT_MODULE_NAME = ...
function GpsTipLayer:onCreate(data) --传入数据
	-- body
	self:initWithFilePath("GpsTipLayer",CURRENT_MODULE_NAME)
end

function GpsTipLayer:CloseVipRoomClick()
	--body
	self:CancelClick()
	self.part:closeVipRoom()
end

function GpsTipLayer:setInfo(index,distance,name1,name2)
	-- body
	self:setShow(true)
	self.node.distance:setString(distance)
	self.node.player_name1:setString(name1)
	self.node.player_name2:setString(name2)
end

function GpsTipLayer:setShow(flag)
	-- body
	if flag == true then
		self.node.bg:show()
	else
		self.node.bg:hide()
	end
end

function GpsTipLayer:CancelClick()
	--body
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	--self.part:deactivate()
	self.node.bg:hide()
end

return GpsTipLayer