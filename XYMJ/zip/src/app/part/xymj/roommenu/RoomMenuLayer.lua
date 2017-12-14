--[[
*名称:RoomMenuLayer
*描述:游戏菜单页面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local CURRENT_MODULE_NAME = ...

local RoomMenuLayer = class("RoomMenuLayer",cc.load("mvc").ViewBase)
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
function RoomMenuLayer:onCreate()
	-- body

	self:initWithFilePath("RoomMenuLayer",CURRENT_MODULE_NAME)
	-- self.node.text_list:setItemModel(self.node.text_panel) --设置文字默认模版
	if(self.part.tableid == 0) then
	    self.node.close_room_btn:loadTextureNormal("ynmj/common/resource/exit_room_btn.png")
		self.node.close_room_btn:loadTexturePressed("ynmj/common/resource/exit_room_btn_light.png")
		self.node.gps_btn:setVisible(false)
		self.node.close_room_btn:setPositionY(self.node.gps_btn:getPositionY())
		-- self.node.setting_btn:setPositionY(self.node.gps_btn:getPositionY())
		-- self.node.close_room_btn:hide()
		-- self.node.gps_btn:hide()
		-- self.node.leave_room_coin_btn:show()
	end

	self:hideShowList()

	self._touchListener = cc.EventListenerTouchOneByOne:create()
    self._touchListener:setSwallowTouches(false)
    self._touchListener:registerScriptHandler(handler(self, RoomMenuLayer.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self._touchListener:registerScriptHandler(handler(self, RoomMenuLayer.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self._touchListener:registerScriptHandler(handler(self, RoomMenuLayer.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(self._touchListener, self)
end

function RoomMenuLayer:LeaveRoomClick()
	self:CloseRoomClick()
end



function RoomMenuLayer:onTouchBegan(touches,event)
	return true
end

function RoomMenuLayer:onTouchMoved(touches,event)
end

function RoomMenuLayer:onTouchEnded(touches,event)
	if self.node.menu_panel:isVisible() then
		self.node.menu_ctl:show()
		self.node.menu_panel:hide()
	end
end

function RoomMenuLayer:menu_panel_click()
	if self.node.menu_panel:isVisible() then
		self.node.menu_ctl:show()
		self.node.menu_panel:hide()
	end
end


function RoomMenuLayer:hideShowList()
	self.node.menu_ctl:show()
	self.node.menu_panel:hide()

end

function RoomMenuLayer:menuShowList()
	self.node.menu_panel:show()
	self.node.menu_ctl:hide()
end
function RoomMenuLayer:CollapseClick()
	-- body
	--[[
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	local tableScene = self:getParent();
	tableScene.node.menu_ctl:setVisible(true);
	self.part:deactivate()
	--]]
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self:hideShowList()
	self.node.menu_ctl:show()
end

function RoomMenuLayer:RulesClick()
	self:getParent():openPlayWay()
end

function RoomMenuLayer:GpsClick(node,touch,event)
    if event == ccui.TouchEventType.began then
	   global:getAudioModule():playSound("res/sound/Button32.mp3",false)
    end
    self:getParent().part:gpsClick(node,touch,event)
end

function RoomMenuLayer:CloseRoomClick()
    self:getParent():CloseRoomClick()
end

function RoomMenuLayer:SettingsClick()
    self:getParent():SettingsClick()
end

function RoomMenuLayer:LeaveRoomClick()
	self:getParent():ExitClick()
end

function RoomMenuLayer:hideDissolveBtn(ret)
	self.node.close_room_btn:setVisible(ret)
	self.node.leave_room_btn:setVisible(not ret)
	if self.node.rules_btn then
		self.node.rules_btn:setVisible(ret)
	end
end


return RoomMenuLayer
