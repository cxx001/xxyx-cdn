--[[
*名称:NewCreateRoomLayer
*描述:创建房间界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local NewCreateRoomLayer = class("NewCreateRoomLayer",import(".CreateRoomLayer"))
local CURRENT_MODULE_NAME = ... 
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
function NewCreateRoomLayer:onCreate(UINode)
	-- body
	self:addMask()
	self:initWithFilePath(UINode,CURRENT_MODULE_NAME)
    local scale = display.width/1280
	self.node.bg:setScale(scale)
	if self.node.game_select1 then
		self.node.game_select1:setTouchEnabled(false)
		self.node.game_select2:hide()
	end 
	self:switchToRoomList(false)
	self:initUI()
    self.showSelfRoom = false
end

function NewCreateRoomLayer:initUI()
end

function NewCreateRoomLayer:onEnter()
	print("###[CreateRoomPart:onEnter")  
	self.costTextInit = self.node.cost_imply:getString()
end


function NewCreateRoomLayer:getRoomListPanel()
	return self.node.roomList_panel
end 

function NewCreateRoomLayer:switchToRoomList(show)  
	print("###[NewCreateRoomLayer:switchToRoomList] show ", show)
	if nil == self.node.roomList_panel or nil == self.node.createRoom_panel then
		print("###[NewCreateRoomLayer:switchToRoomList] nil == self.node.roomList_panel or nil == self.node.createRoom_panel ") 
		return
	end

	self.node.roomList_panel:setVisible(show)
	self.node.createRoom_panel:setVisible(not show) 

    local img_title = self.node.title_bg2
	local btn_crTitle1 = self.node.createroom_btn
	local btn_myTitle2 = self.node.myroom_btn

	if show then
        img_title:loadTexture(self.res_base.."/title1.png",1)
		btn_crTitle1:loadTextures(self.res_base.."/cjfj_title0.png",self.res_base.."/cjfj_title0.png","",1)
        btn_crTitle1:setPositionX(160)
		btn_myTitle2:loadTextures(self.res_base.."/wdfj_title1.png",self.res_base.."/wdfj_title1.png","",1) 
        btn_myTitle2:setPositionX(460)
	else
        img_title:loadTexture(self.res_base.."/title0.png",1)
		btn_crTitle1:loadTextures(self.res_base.."/title.png",self.res_base.."/title.png","",1)
        btn_crTitle1:setPositionX(253)
		btn_myTitle2:loadTextures(self.res_base.."/wdfj_title0.png",self.res_base.."/wdfj_title0.png","",1) 
        btn_myTitle2:setPositionX(545)
	end
    self.showSelfRoom = show
end

function NewCreateRoomLayer:onSwitchPanel(obj) 
	self.part:switchToRoomList(obj:isSelected()) 
end

function NewCreateRoomLayer:switchToGroupManager(show)
	print("###[NewCreateRoomLayer:switchToGroupManager] show ", show)
	if nil == self.node.title_bg2 then
		print("###[NewCreateRoomLayer:switchToGroupManager] nil == self.node.title_bg2 ") 
		return
	end
	self.node.title_bg1:setVisible(not show)
	self.node.title_bg2:setVisible(show)
end

function NewCreateRoomLayer:updateRedPoint(num)
	print("###[NewCreateRoomLayer:updateRedPoint] num ", num)
	if nil == self.node.title_bg2 then
		print("###[NewCreateRoomLayer:updateRedPoint] nil == self.node.title_bg2 ") 
		return
	end
	local redpoint_img = self.node.title_bg2:getChildByName("redpoint_img") 
	local redPointNum_txt = redpoint_img:getChildByName("redPointNum_txt")
	if num == 0 then
		redpoint_img:setVisible(false)
	else
		redpoint_img:setVisible(true)
		redPointNum_txt:setString(tostring(num))
	end
end

function NewCreateRoomLayer:onSelfRoom(obj)
    --已经在我的房间界面里，则点击无作用
    if not self.showSelfRoom then
        self:switchToRoomList(true)
    end
end

function NewCreateRoomLayer:onCreateRoom(obj)
    --不在我的房间而在创建房间界面
    if self.showSelfRoom then
        self:switchToRoomList(false)
    end
end

return NewCreateRoomLayer