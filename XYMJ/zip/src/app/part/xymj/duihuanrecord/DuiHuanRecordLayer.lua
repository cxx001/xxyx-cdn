--[[
*名称:RecordLayer
*描述:兑换记录界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local DuihuanRecordLayer = class("DuihuanRecordLayer",cc.load("mvc").ViewBase)
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
local CURRENT_MODULE_NAME = ...

function DuihuanRecordLayer:onCreate(data) --传入数据
	-- body
	self:addMask()
	self:initWithFilePath("DuiHuanRecordLayer", CURRENT_MODULE_NAME)

	self.node.slider:addEventListener(handler(self, DuihuanRecordLayer.sliderEvent))
	self.node.listView:addScrollViewEventListener(handler(self, DuihuanRecordLayer.listViewEvent))
end


function DuihuanRecordLayer:CloseClick()
    global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self.part:deactivate()
end

function DuihuanRecordLayer:sliderEvent()
	local percent = self.node.slider:getPercent()
	self.node.listView:jumpToPercentVertical(percent)
end

function DuihuanRecordLayer:listViewEvent(sender, event)
	if event == ccui.ScrollviewEventType.scrolling or
	event == ccui.ScrollviewEventType.containerMoved then
		local listView = self.node.listView
		local pInner = listView:getInnerContainer()
		local listheight = listView:getLayoutSize().height - pInner:getContentSize().height
		local percent = (pInner:getPositionY()/listheight) * 100.0
		self.node.slider:setPercent(100-percent)
	end
end

function DuihuanRecordLayer:updateUI(recordList)
	-- self.room_list = room_list
	-- self.room_data = room_data

	-- local user = global:getGameUser()
	-- local props = user:getProps()
	-- local game_player = user:getProp("gameplayer"..SocketConfig.GAME_ID)
	-- local playerID = game_player.playerIndex
	-- local name = props.name
	-- playerID = playerID .. '-' .. name
	-- self.room_data.player[1].playerID = playerID

	-- -- @ 用户索引列表
	-- self.player_indexs = {}
	-- for i, player in ipairs(self.room_data.player) do
	-- 	local player_ids = Util.split(player.playerID, '-')
	-- 	self.player_indexs[player_ids[1]] = i
	-- end

print("onDuihuanRecordResp -----6-----")

	self.record_list = recordList
	self:refreshRecordList(recordList)
	--self:refreshAllScore(self.room_data)
	--self:refreshRoomInfo()
end

-- function DuihuanRecordLayer:refreshRoomInfo()
-- 	local time = self.room_data.endTime
-- 	local index = self.room_data.roomIndex
-- 	self.node.time:setString(time)
-- 	self.node.room_id:setString(index)
-- end

-- function DuihuanRecordLayer:refreshAllScore(room_data)
-- 	local win_index = 0
-- 	local max_score = 0
-- 	local players = room_data.player
-- 	for i, player in ipairs(players) do
-- 		if player.score > max_score then
-- 			win_index 		= i
-- 			max_score 	= player.score
-- 		end
-- 	end

-- 	for i=1, 4 do
-- 		local player = players[i]
-- 		local item = self.node['item_'..i]
-- 		local ui_fang = item:getChildByName('fang')
-- 		local ui_name = item:getChildByName('name')
-- 		local ui_win  = item:getChildByName('win')

-- 		if i == win_index then
-- 			ui_win:setVisible(true)
-- 		else
-- 			ui_win:setVisible(false)
-- 		end

-- 		local host_id = room_data.hostId
-- 		if player.playerID == host_id then
-- 			ui_fang:setVisible(true)
-- 		else
-- 			ui_fang:setVisible(false)
-- 			ui_name:setTextColor({r=0x94,g=0x6c,b=0x54})
-- 		end
-- 		local names = Util.split(player.playerID, '-')
-- 		local name = names[2]

-- 		ui_name:setString(name or '')
-- 	end
-- end

function DuihuanRecordLayer:refreshRecordList(recordList)

print("onDuihuanRecordResp -----7-----")

	local listView = self.node.listView
	listView:removeAllItems()
	listView:setItemModel(self.node.duihuan_item)
	listView:setScrollBarEnabled(false)

	-- @ 记录不满一屏幕，slider屏蔽
	if #recordList <= 4 then
		self.node.slider:setTouchEnabled(false)
	else
		self.node.slider:setTouchEnabled(true)
	end

	for i, item_data in ipairs(recordList) do
		local item = listView:getItem(i-1)
		if not item then
			listView:pushBackDefaultItem()
			item = listView:getItem(i-1)
		end

		local endDataText = item:getChildByName('text_end_date')
		local nameText = item:getChildByName('text_name')
		local btn_duihuan = item:getChildByName('btn_duihuan')
		local text_state = item:getChildByName('text_state')
		endDataText:setString(item_data.exchange_end_time)
		nameText:setString(item_data.award_product)
		btn_duihuan:setTag(i)--(item_data.cdkey)
		print("XXXXXXBBBBBCCCCDDDDDEEEE i ", i)

		local status = item_data.status--text_state:setString(item_data.status)
		if status == "1" then  --已兑换
			text_state:setString("已兑换")
			text_state:show()
			btn_duihuan:hide()
		else
			text_state:hide()
			btn_duihuan:show()
		end


		btn_duihuan:addClickEventListener(function(sender, event)
			-- @ 兑换
			local index = sender:getTag()

			print("XXXXXXAAAAAAA index ", index)

			local itemData = self.record_list[index]
			local duihuanCode = itemData.cdkey
			self.part:onDuihuanClick(duihuanCode)
		end)
	end
end

return DuihuanRecordLayer
