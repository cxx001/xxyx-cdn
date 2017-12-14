local RoomListNode = class("RoomListNode",cc.load("mvc").ViewBase)
local rowNum = 10
local CURRENT_MODULE_NAME = ...
function RoomListNode:onCreate()
	-- body
	self:initWithFilePath("RoomListNode",CURRENT_MODULE_NAME) 
	self.historyCurPage = 1
	self.historyTotalPage = 1
	self.schedulerID = 0
	self:initUI()
end
 

function RoomListNode:initUI()
	self.ListView_CurrentList = self.node.Panel_CurrentList:getChildByName("ListView_CurrentList") 
	self.Panel_CurrentItem = self.node.Panel_CurrentList:getChildByName("Panel_CurrentItem") 
	self.ListView_CurrentList:setItemModel(self.Panel_CurrentItem)
	self.ListView_CurrentList:setTouchEnabled(false)
	self.ListView_CurrentList:setScrollBarEnabled(false)
		

	self.ListView_HistoryList = self.node.Panel_HistoryList:getChildByName("ListView_HistoryList") 
	self.Panel_HistoryItem = self.node.Panel_HistoryList:getChildByName("Panel_HistoryItem") 
	self.ListView_HistoryList:setItemModel(self.Panel_HistoryItem)
 	self.ListView_HistoryList:setTouchEnabled(false)
 	self.ListView_HistoryList:setScrollBarEnabled(false)

 	self:updateCurrentList({})
end

function RoomListNode:switchToCurrentList(show)
	print("###[RoomListNode:switchToCurrentList]show ", show)
	self.node.Panel_CurrentList:setVisible(show)
	self.node.Panel_HistoryList:setVisible(not show)
end


function RoomListNode:updateCurrentList(roomList)
	print("###[RoomListNode:updateCurrentList]") 
	self:switchToCurrentList(true) 
	self:clearCurListView()  

	local maxLeftSecond = 0
	for i, roomInfo in ipairs(roomList) do
		local newItem = self.Panel_CurrentItem:clone() 
		newItem:addClickEventListener(handler(self, RoomListNode.onEnterRoom)) 

		local Txt_TableID = newItem:getChildByName("Txt_TableID")
		Txt_TableID:setString(roomInfo.tableID)

		local Txt_PlayerNum = newItem:getChildByName("Txt_PlayerNum")
		Txt_PlayerNum:setString(roomInfo.playerNum)

		local Txt_TimeNum = newItem:getChildByName("Txt_TimeNum")
		Txt_TimeNum:setString(roomInfo.timeNum)

		local Txt_LeftTime = newItem:getChildByName("Txt_LeftTime")
		local leftTime = self:getLeftTime(roomInfo.leftSecond)
		Txt_LeftTime:setString(leftTime)

		maxLeftSecond = tonumber(roomInfo.leftSecond) > maxLeftSecond and tonumber(roomInfo.leftSecond) or maxLeftSecond

		local tableInfo = {}
		tableInfo.tableID = roomInfo.tableID
		tableInfo.viptableid = roomInfo.tableID
		tableInfo.timeNum = roomInfo.timeNum
		tableInfo.playerNum = roomInfo.playerNum
		tableInfo.playwaytype = roomInfo.playwaytype
		tableInfo.leftSecond = roomInfo.leftSecond
		tableInfo.diZhu = roomInfo.diZhu
		tableInfo.payType = roomInfo.payType
		tableInfo.totalhand = roomInfo.timeNum

		local Btn_Invite= newItem:getChildByName("Btn_Invite")
		Btn_Invite.tableInfo = tableInfo  
		Btn_Invite:addClickEventListener(handler(self, RoomListNode.onViteFriend))  

		
		self.ListView_CurrentList:insertCustomItem(newItem, i-1) 
	end
	if next(roomList) ~= nil then
		self.maxLeftSecond = maxLeftSecond
	end
end


function RoomListNode:updateHistoryList(roomList)
	print("###[RoomListNode:updateHistoryList] roomList ")  
	self:switchToCurrentList(false)

	self.ListView_HistoryList:removeAllChildren()
	for i, roomInfo in ipairs(roomList) do
		local newItem = self.Panel_HistoryItem:clone()

		local Txt_TableID = newItem:getChildByName("Txt_TableID")
		Txt_TableID:setString(roomInfo.tableID) 

		local Txt_TimeNum = newItem:getChildByName("Txt_TimeNum")
		Txt_TimeNum:setString(roomInfo.timeNum)

		local Txt_Winner = newItem:getChildByName("Txt_Winner")
		Txt_Winner:setString(roomInfo.winnerID)

		local Txt_Nickname = newItem:getChildByName("Txt_Nickname")
		Txt_Nickname:setString(roomInfo.winnerName)

		local Txt_PayType = newItem:getChildByName("Txt_PayType")
		Txt_PayType:setString(roomInfo.payType == 1 and "AA支付" or "房主支付")

		local Txt_EndTime = newItem:getChildByName("Txt_EndTime")
		Txt_EndTime:setString(roomInfo.endTime) 
		 
		self.ListView_HistoryList:insertCustomItem(newItem, i-1) 
	end
end

--更新剩余
function RoomListNode:refreshRoomList()  
	print("###[RoomListNode:refreshRoomList]")
	if 0 == self.maxLeftSecond then
		return 
	end

	if 0 ~= self.schedulerID then 
		self:unScheduler(self.schedulerID) 
	end

	self.schedulerID = self:schedulerFunc(function()
		local removeItemTb = {}
		local itemList = self.ListView_CurrentList:getItems()
		for i = #itemList, 1, -1 do
			local item = self.ListView_CurrentList:getItem(i-1)
			local Btn_Invite= item:getChildByName("Btn_Invite")
			local tableInfo = Btn_Invite.tableInfo
			local leftSecond = tonumber(tableInfo.leftSecond)
			leftSecond = leftSecond - 1.0
			self.part:updateRoomLeftTime(tableInfo.tableID, leftSecond)
			if leftSecond <= 0 then 
				print("removeOne i ", i)
				local item = self.ListView_CurrentList:getItem(i-1) 
				Btn_Invite.tableInfo  = nil 
				self.ListView_CurrentList:removeItem(self.ListView_CurrentList:getIndex(item)) 
			else
				--print("cur time ", leftSecond) 
				local leftTime = self:getLeftTime(leftSecond)
				local Txt_LeftTime = item:getChildByName("Txt_LeftTime")  
				Txt_LeftTime:setString(leftTime)
				Btn_Invite.tableInfo.leftSecond = leftSecond
			end  
		end  

		self.maxLeftSecond = self.maxLeftSecond - 1
		if self.maxLeftSecond == 0 then
			print("stop")
			self:clearCurListView() 
			self:unScheduler(self.schedulerID)
		end
		--print("maxLeftSecond ", self.maxLeftSecond)
	end, 1.0, false)
end

function RoomListNode:getLeftTime(second)
	second = tonumber(second) 
	local min = math.floor(second / 60)
	local leftSecond = math.floor(second % 60)
	return string.format("%02d:%02d", min, leftSecond)
end

function RoomListNode:onViteFriend(obj)
	print("###[RoomListNode:onViteFriend]")
	local sharePart = self.part:getPart("SharePart")
	if nil ~= sharePart then
		sharePart:inviteFriends(obj.tableInfo)
	end
end
 
function RoomListNode:clearCurListView()
	for i,item in ipairs(self.ListView_CurrentList:getItems()) do 
		local Btn_Invite= item:getChildByName("Btn_Invite")
		Btn_Invite.tableInfo  = nil 
	end
	self.ListView_CurrentList:removeAllItems()
end

function RoomListNode:onEnterRoom(obj)
	local Btn_Invite= obj:getChildByName("Btn_Invite")
	local tableInfo = Btn_Invite.tableInfo
	self.part:requestEnterRoom(tableInfo)
end
  
--ccs按钮事件
function RoomListNode:onHistoryList()
	self.part:requestHistoryList(true)
end

function RoomListNode:onCurrentList()
	self.part:requestCurrentList(false)
end

function RoomListNode:setHistoryTotalPage(totalNum)
	self.historyTotalPage = totalNum % rowNum ==0 and math.floor(totalNum / rowNum) or (math.floor(totalNum / rowNum) +1)
end

function RoomListNode:onPrePage()
	self.historyCurPage = self.historyCurPage - 1
	if self.historyCurPage <= 0 then
		self.historyCurPage = 1
	end
	print("###[RoomListNode:onPrePage]self.historyCurPage ", self.historyCurPage)
	local recordList = self:getHistoryListByPage(self.historyCurPage)
	self:updateHistoryList(recordList)
end


function RoomListNode:onNextPage()
	self.historyCurPage = self.historyCurPage + 1
	if self.historyCurPage > self.historyTotalPage then
		self.historyCurPage = self.historyTotalPage
	end
	print("###[RoomListNode:onNextPage]self.historyCurPage ", self.historyCurPage)
	local recordList = self:getHistoryListByPage(self.historyCurPage)
	self:updateHistoryList(recordList)
end

function RoomListNode:getHistoryListByPage(pageIndex)
	local retList = {}
	local startIndex = (pageIndex - 1) * rowNum 
	local totalList = self.part:getHistoryList()
	local endIndex =  startIndex + rowNum <= #totalList and startIndex + rowNum or #totalList 
	print(string.format("###[RoomListNode:getHistoryListByPage] startIndex:%d  endIndex:%d", startIndex, endIndex))
	for i = startIndex, endIndex - 1, 1 do
		table.insert(retList, totalList[i + 1])
	end 
	local Txt_Page = self.node.Panel_HistoryList:getChildByName("Txt_Page")
	Txt_Page:setString(string.format("%d/%d", self.historyCurPage, self.historyTotalPage))
	return retList
end

return RoomListNode