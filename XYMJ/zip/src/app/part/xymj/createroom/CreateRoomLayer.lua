--[[
*名称:CreateRoomLayer
*描述:创建房间界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local CreateRoomLayer = class("CreateRoomLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
function CreateRoomLayer:onCreate()
	-- body
	self:addMask()
	self:initWithFilePath("CreateRoomLayer",CURRENT_MODULE_NAME)
    local scale = display.width/1280
	self.node.bg:setScale(scale)
	if self.node.game_select1 then
		self.node.game_select1:setTouchEnabled(false)
		self.node.game_select2:hide()
	end
end

function CreateRoomLayer:onEnter()
	print("###[CreateRoomPart:onEnter")  
	self.costTextInit = self.node.cost_imply and self.node.cost_imply:getString() or nil
end

function CreateRoomLayer:CreateGameClick()
	self.part:createGame()
end

local MaCount = 3
local PlayWayCount = 3
local TimesCount = 4

for i=1, MaCount do
	CreateRoomLayer["MaSelectEvent" .. i] = function(self)
		-- body
		self.part:selectMa(i)
	end
end

for i=1, PlayWayCount do
	CreateRoomLayer["PlayWaySelectEvent" .. i] = function(self)
		self.part:selectPlayWay(i)
	end
end

for i=1, TimesCount do
	CreateRoomLayer["TimesSelectEvent" .. i] = function(self)
		-- body
		self.part:selectTimes(i)
	end
end

function CreateRoomLayer:CloseClick()    
	self.part:deactivate()
end

function CreateRoomLayer:setSelectTimes(type)
	print("###[CreateRoomLayer:setSelectTimes] type ", type)
	-- body
	for i=1, TimesCount do --关闭当前选择
		if self.node["times_select" .. i] then
			if i ~= type then
				self.node["times_select" .. i]:setSelected(false)
				self.node["times_select" .. i]:setTouchEnabled(true) 
			else
				self.node["times_select" .. i]:setSelected(true)
				self.node["times_select" .. i]:setTouchEnabled(false)
			end
		end
	end
	
end

function CreateRoomLayer:setSelectPlayWay(type)
	-- body
		for i=1, PlayWayCount do
			if self.node["playway_select" .. i] then
				if i ~= type then
					self.node["playway_select" .. i]:setSelected(false)
					self.node["playway_select" .. i]:setTouchEnabled(true)
				else 
					self.node["playway_select" .. i]:setTouchEnabled(false)
					self.node["playway_select" .. i]:setSelected(true)
				end
			end
		end

		for i=1, MaCount do
			if self.node["ma_select" .. i] then
				if type == self.part.PLAYWAY1 then
					self.node["ma_select" .. i]:show()
				else
					self.node["ma_select" .. i]:hide()
				end	
			end
		end
end



function CreateRoomLayer:setSelectMa(type)
	-- body
	for i=1, MaCount do
		if self.node["ma_select" .. i] then
			if i ~= type then
				self.node["ma_select" .. i]:setSelected(false)
				self.node["ma_select" .. i]:setTouchEnabled(true)
			else 
				self.node["ma_select" .. i]:setTouchEnabled(false)
			end
		end
	end

end

function CreateRoomLayer:updateCostDiamondOnView(costDiamond)
	print("##CreateRoomLayer:updateCostDiamondOnView: " .. tostring(costDiamond))
	if self.costTextInit then
		self.node.cost_imply:setString(string.format(self.costTextInit,costDiamond))
	end
end

function CreateRoomLayer:setSelectPayment(payment)
	print("###[CreateRoomLayer:setSelectPayment] payment ", payment)
	for i = 1, 2 do --关闭当前选择
		local paymentNode = self.node["payment_select" .. i]
		if paymentNode then
			paymentNode:setSelected(i == payment)
			paymentNode:setTouchEnabled(i ~= payment)
		end
	end
end

function CreateRoomLayer:switchToGroupManager(show)
	print("###[NewCreateRoomLayer:switchToGroupManager] show ", show)
	if nil == self.node.title_bg2 then
		print("###[NewCreateRoomLayer:switchToGroupManager] nil == self.node.title_bg2 ") 
		return
	end
	self.node.title_bg:setVisible(not show)
	self.node.title_bg2:setVisible(show)
	--self.node.aa_panel:setVisible(not show)
end

function CreateRoomLayer:switchToRoomList(show)  
	print("###[CreateRoomLayer:switchToRoomList] show ", show)
	if nil == self.node.roomList_panel or nil == self.node.createRoom_panel then
		print("###[CreateRoomLayer:switchToRoomList] nil == self.node.roomList_panel or nil == self.node.createRoom_panel ") 
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

function CreateRoomLayer:onSelfRoom(obj)
    --已经在我的房间界面里，则点击无作用
    if not self.showSelfRoom then
        self:switchToRoomList(true)
    end
end

function CreateRoomLayer:onCreateRoom(obj)
    --不在我的房间而在创建房间界面
    if self.showSelfRoom then
        self:switchToRoomList(false)
    end
end

function CreateRoomLayer:updateRedPoint(num)
	print("###[CreateRoomLayer:updateRedPoint] num ", num)
	if nil == self.node.title_bg2 then
		print("###[CreateRoomLayer:updateRedPoint] nil == self.node.title_bg2 ") 
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

function CreateRoomLayer:getRoomListPanel()
	return self.node.roomList_panel
end

return CreateRoomLayer