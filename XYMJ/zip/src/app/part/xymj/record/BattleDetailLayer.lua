--[[
*名称:RecordLayer
*描述:战绩记录界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local BattleDetailLayer = class("BattleDetailLayer",cc.load("mvc").ViewBase)
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
local CURRENT_MODULE_NAME = ...

function BattleDetailLayer:onCreate(data) --传入数据
	-- body
	self:addMask()
	self:initWithFilePath("BattleDetailLayer", CURRENT_MODULE_NAME)

	self.node.slider:addEventListener(handler(self, BattleDetailLayer.sliderEvent))
	self.node.listView:addScrollViewEventListener(handler(self, BattleDetailLayer.listViewEvent))
end


function BattleDetailLayer:CloseClick()
    global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self.part:deactivate()
end

function BattleDetailLayer:sliderEvent()
	local percent = self.node.slider:getPercent()
	self.node.listView:jumpToPercentVertical(percent)
end

function BattleDetailLayer:listViewEvent(sender, event)
	if event == ccui.ScrollviewEventType.scrolling or
	event == ccui.ScrollviewEventType.containerMoved then
		local listView = self.node.listView
		local pInner = listView:getInnerContainer()
		local listheight = listView:getLayoutSize().height - pInner:getContentSize().height
		local percent = (pInner:getPositionY()/listheight) * 100.0
		self.node.slider:setPercent(100-percent)
	end
end

function BattleDetailLayer:updateUI(room_list, room_data)
	self.room_list = room_list
	self.room_data = room_data

	local user = global:getGameUser()
	local props = user:getProps()
	local game_player = user:getProp("gameplayer"..SocketConfig.GAME_ID)
	local playerID = game_player.playerIndex
	local name = props.name
	playerID = playerID .. '-' .. name
	self.room_data.player[1].playerID = playerID

	-- @ 用户索引列表
	self.player_indexs = {}
	for i, player in ipairs(self.room_data.player) do
		local player_ids = Util.split(player.playerID, '-')
		self.player_indexs[player_ids[1]] = i
	end

	self:refreshBattle(self.room_list)
	self:refreshAllScore(self.room_data)
	self:refreshRoomInfo()
end

function BattleDetailLayer:refreshRoomInfo()
	local time = self.room_data.endTime
	local index = self.room_data.roomIndex
	self.node.time:setString(time)
	self.node.room_id:setString(index)
end

function BattleDetailLayer:refreshAllScore(room_data)
	local win_index = 0
	local max_score = 0
	local players = room_data.player
	for i, player in ipairs(players) do
		if player.score > max_score then
			win_index 		= i
			max_score 	= player.score
		end
	end

	for i=1, 4 do
		local player = players[i]
		local item = self.node['item_'..i]
		local ui_fang = item:getChildByName('fang')
		local ui_name = item:getChildByName('name')
		local ui_win  = item:getChildByName('win')

		if i == win_index then
			ui_win:setVisible(true)
		else
			ui_win:setVisible(false)
		end

		local host_id = room_data.hostId
		if player.playerID == host_id then
			ui_fang:setVisible(true)
		else
			ui_fang:setVisible(false)
			ui_name:setTextColor({r=0x94,g=0x6c,b=0x54})
		end
		local names = Util.split(player.playerID, '-')
		local name = names[2]

		ui_name:setString(name or '')
	end
end

function BattleDetailLayer:refreshBattle(room_list)
	local listView = self.node.listView
	listView:removeAllItems()
	listView:setItemModel(self.node.battle_item)
	listView:setScrollBarEnabled(false)

	-- @ 记录不满一屏幕，slider屏蔽
	if #self.room_list <= 4 then
		self.node.slider:setTouchEnabled(false)
	else
		self.node.slider:setTouchEnabled(true)
	end

	for i, room_data in ipairs(self.room_list) do
		local item = listView:getItem(i-1)
		if not item then
			listView:pushBackDefaultItem()
			item = listView:getItem(i-1)
		end

		local ui_ju = item:getChildByName('ju')
		local btn_share = item:getChildByName('btn_share')
		local btn_record = item:getChildByName('btn_record')
		ui_ju:setString(i)
		btn_share:setTag(i)
		btn_record:setTag(i)

		btn_share:addClickEventListener(function(sender, event)
			-- @ 分享
			local tag = sender:getTag()
			local room_data = self.room_list[tag][1]
			self.part:shareCode(room_data.roomid, tag)
		end)

		btn_record:addClickEventListener(function(sender, event)
			-- @ 回放
			local tag = sender:getTag()
			local room_data = self.room_list[tag][1]
			self.part:startRecord(room_data.roomid, tag, #self.room_list)
		end)

		for i, player in ipairs(room_data) do
			local player_ids = Util.split(player.playerName, '-')
			local index = self.player_indexs[player_ids[1]]
			if index then
				local ui_win_score = item:getChildByName('win_score_' .. index )
				local ui_lose_score = item:getChildByName('lose_score_' .. index )

				local score = player.gameScore
				if score > 0 then
					ui_lose_score:setVisible(false)
					ui_win_score:setVisible(true)
					ui_win_score:setString( '/' .. score)
				else
					ui_lose_score:setVisible(true)
					ui_win_score:setVisible(false)
					if score == 0 then
						ui_lose_score:setString(score)
					else
						ui_lose_score:setString( '/' .. score)
					end
				end
			end
		end
	end
end

return BattleDetailLayer
