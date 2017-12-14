local ESCreateRoomLayer = class("ESCreateRoomLayer", import(".NewCreateRoomLayer"))
local CURRENT_MODULE_NAME = ...
local DizhuNum = 4
local PaytypeNum = 2
local PlayWayCount = 4
local TimesCount = 4
ESCreateRoomLayer.UINode = "ESCreateRoomLayer"

function ESCreateRoomLayer:onCreate()
	print("###[QJCreateRoomLayer:onCreate]")
	ESCreateRoomLayer.super.onCreate(self, ESCreateRoomLayer.UINode) 
end

function ESCreateRoomLayer:initUI()
	print("###[ESCreateRoomLayer:initUI]")
	self.playway2List = {} 
	self.refPanel = self.node.playway2Desc_panel
	self.refPanel:hide() 

	self.downUIList = {} 
	self.node.difen_panel.basePosY = self.node.difen_panel:getPositionY()
	self.node.times_panel.basePosY = self.node.times_panel:getPositionY()
	self.node.payment_panel.basePosY = self.node.payment_panel:getPositionY()
	table.insert(self.downUIList, self.node.difen_panel)
	table.insert(self.downUIList, self.node.times_panel)
	table.insert(self.downUIList, self.node.payment_panel)  
end

--更新可选玩法下方的UI
function ESCreateRoomLayer:updateDownUI(offsetHeight)
	for i,v in ipairs(self.downUIList) do
		v:setPositionY(v.basePosY + offsetHeight)
	end
end


--更新小玩法的显示
function ESCreateRoomLayer:updaetUI(rule1) 
	print("###[ESCreateRoomLayer:updaetUI] rule1 is ", rule1)

	local ruleCfg = RoomConfig.Rule[rule1] 
	if nil == ruleCfg then
		print("###[ESCreateRoomLayer:updaetUI] nil == ruleCfg")
		return
	end 

	local rule2List = ruleCfg.Rule2 
	if nil == rule2List then
		print("###[ESCreateRoomLayer:updaetUI] nil == rule2List")
		return
	end 
 

	for k,v in pairs(self.playway2List) do  
		v:removeSelf()
	end
	self.playway2List = {} 

	local refPanel = self.refPanel
	refPanel:hide() 
	local refPos = cc.p(refPanel:getPositionX(), refPanel:getPositionY()) 
	local refSize = refPanel:getContentSize()
	local offsetSize = cc.size(refSize.width * 0.1, refSize.height * 0.1) 
	local index = 0
	local colNum = 3 
	local totalHeight = 0
	local rowNum = (#rule2List % colNum) == 0 and math.floor(#rule2List / colNum) or math.floor(#rule2List / colNum) + 1 
	if rowNum == 0 then
		totalHeight = self.node.playway2_panel:getContentSize().height
		self.node.playway2_panel:hide()
	else
		self.node.playway2_panel:show()
	end
	for i,v in ipairs(rule2List) do
		local curCol = index % colNum
		local curRow = math.floor(index / colNum)
		local curX = curCol
		local curY = curRow * -1 

		local offPosX = curX * (refSize.width + offsetSize.width)
		local offPosY = curY * (refSize.height + offsetSize.height)
		local newPos = cc.p(refPos.x + offPosX , refPos.y + offPosY) 

		local panel = refPanel:clone()
		panel:show()
		local playwaySelect = panel:getChildByName("playway2_select")
		playwaySelect.selectType =  v
		playwaySelect:addClickEventListener(function(sender) 
			self.part:selectPlayWay2(sender.selectType)
		end)
		local playwayTxt = playwaySelect:getChildByName("playway2_txt")
		playwayTxt:setString(RoomConfig.Rule2[v].name)

		self.node.playway2_panel:addChild(panel)
		panel:setPosition(newPos) 

		totalHeight = offPosY 
		index = index + 1  
		self.playway2List[v] = panel 
	end 

	self:updateDownUI(totalHeight) 
end


for i = 1, PaytypeNum do
	ESCreateRoomLayer["PaymentSelectEvent" .. i] = function(self)
		self.part:selectPayment(i)
	end
end 

for i =1, DizhuNum do
	ESCreateRoomLayer["DifenSelectEvent" .. i] = function(self)
		self.part:selectDifen(i)
	end
end

for i=1, PlayWayCount do
	ESCreateRoomLayer["PlayWaySelectEvent" .. i] = function(self)
		self.part:selectPlayWay(i)
	end
end

for i=1, TimesCount do
	ESCreateRoomLayer["TimesSelectEvent" .. i] = function(self)
		-- body
		self.part:selectTimes(i)
	end
end

function ESCreateRoomLayer:setSelectPlayWay(type)
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
end


function ESCreateRoomLayer:setSelectPayment(payment)
	print("###[ESCreateRoomLayer:setSelectPayment] payment ", payment)
	for i = 1, PaytypeNum do --关闭当前选择
		local paymentNode = self.node["payment_select" .. i]
		paymentNode:setSelected(i == payment)
		paymentNode:setTouchEnabled(i ~= payment)
	end
end



function ESCreateRoomLayer:setSelectPlayWay2(selectList)  
	if next(self.playway2List) == 0 then
		return
	end 
	for k,v in pairs(selectList) do  
		local playway2Select = self.playway2List[k]:getChildByName("playway2_select") 
		playway2Select:setSelected(v > 0)
	end  
end

function ESCreateRoomLayer:setSelectTimes(type)
	print("###[ESCreateRoomLayer:setSelectTimes] type ", type)
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
	print("self.part.playTimes[1].value ", self.part.playTimes[1].value)
	if type == self.part.playTimes[1].index then
		self.part:enableAAPayment(false)
	else
		self.part:enableAAPayment(true)
	end 
end

function ESCreateRoomLayer:enableAAPayment(enable)
	print("###[ESCreateRoomLayer:enableAAPayment] enable ", enable)
	local paymentNode = self.node["payment_select" .. self.part.PAYMENT_AVERAGE]
	paymentNode:setVisible(enable)
end

function ESCreateRoomLayer:setSelectDifen(type)
	print("###[ESCreateRoomLayer:setSelectDifen] type ", type) 
	for i = 1, DizhuNum do --关闭当前选择
		local difenNode = self.node["difen_select" .. i]
		difenNode:setSelected(i == type)
		difenNode:setTouchEnabled(i ~= type)
	end
end

function ESCreateRoomLayer:showSelectPlayWay2()
	print("###[ESCreateRoomLayer:showSelectPlayWay2] isShow ", isShow) 
	self.part:selectPlayWay2(0)
end

return ESCreateRoomLayer