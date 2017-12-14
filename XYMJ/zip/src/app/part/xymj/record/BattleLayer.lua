--[[
*名称:RecordLayer
*描述:战绩记录界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local BattleLayer = class("BattleLayer",cc.load("mvc").ViewBase)
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]

local CURRENT_MODULE_NAME = ...

function BattleLayer:onCreate(data) --传入数据
	-- body
	self:addMask()
	self:initWithFilePath("BattleLayer", CURRENT_MODULE_NAME)
	self.node.slider:addEventListener(handler(self, BattleLayer.sliderEvent))
	self.node.battle_listView:addScrollViewEventListener(handler(self, BattleLayer.listViewEvent))
	--self.node.clock_bg:setVisible(false)
    local scale = display.width/1280
    self.node.battle_panel:setScale(scale)
end


function BattleLayer:CloseClick()
    global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self.part:deactivate()
end

function BattleLayer:sliderEvent()
	local percent = self.node.slider:getPercent()
	self.node.battle_listView:jumpToPercentVertical(percent)
end

function BattleLayer:listViewEvent(sender, event)
	if event == ccui.ScrollviewEventType.scrolling or
	event == ccui.ScrollviewEventType.containerMoved then
		local listView = self.node.battle_listView
		local pInner = listView:getInnerContainer()
		local listheight = listView:getLayoutSize().height - pInner:getContentSize().height
		local percent = (pInner:getPositionY()/listheight) * 100.0
		self.node.slider:setPercent(100-percent)
	end
end

function BattleLayer:queryOtherClick()
	self.part:openOtherBattle()
end

function BattleLayer:selectGame(index, event)
	local listView = self.node.game_listView
	for i, id in ipairs(self.game_ids) do
		local item = listView:getItem(i-1)
		local ui_btn = item:getChildByName('game_btn')
		local ui_bg  = item:getChildByName('game_bg')
		local ui_name = item:getChildByName('game_name')

		local frame = string.format('ynhj/ynhjlobby/resource/battle/battle_room/normal_game_%d.png', id)
		ui_name:loadTexture(frame, 1)

		if index == i then
			-- @选中这个ui
			ui_btn:setBrightStyle(1)
			if event == 0 and index ~= self.select_id then
				self.part:refreshGameTypes(index)
			end
		else
			ui_btn:setBrightStyle(0)
		end
	end

	-- @select
	local item = listView:getItem(index-1)
	local ui_name = item:getChildByName('game_name')

	local id = self.game_ids[index]
	local frame = string.format('ynhj/ynhjlobby/resource/battle/battle_room/select_game_%d.png', id)
	ui_name:loadTexture(frame, 1)
end

function BattleLayer:OtherGameTips(id)
	local game_name = string_table.game_name[tonumber(id)]
	local tips = string.format(string_table.other_game_tips, game_name)
	local ui_text = self.node.other_game_tips:clone()

	local ui_root = self.node.root
	ui_root:removeChildByName('game_tips')

	local size = ui_root:getContentSize()
	ui_text:setPosition(cc.p(size.width/2, size.height/2))
	ui_root:addChild(ui_text)
	ui_text:setName('game_tips')
	ui_text:setString(tips)

	local delay_time = cc.DelayTime:create(0.3)
	local call_func = cc.CallFunc:create(function()
		ui_text:removeFromParent()	
	end)
	local move_to = cc.MoveTo:create(0.5, cc.p(size.width/2, size.height/2 + 100))
	local seq = cc.Sequence:create(delay_time, move_to, call_func)
	ui_text:runAction(seq)
end

function BattleLayer:refreshGames(game_ids)
	self.game_ids = game_ids
	local listView = self.node.game_listView
	listView:removeAllItems()
	listView:setItemModel(self.node.game_items)
	listView:setScrollBarEnabled(false)
	for i, id in ipairs(game_ids) do
		local item = listView:getItem(i-1)
		if not item then
			listView:pushBackDefaultItem()
			item = listView:getItem(i-1)
		end
		local ui_btn = item:getChildByName('game_btn')
		local ui_bg  = item:getChildByName('game_bg')
		local ui_name = item:getChildByName('game_name')

		local frame = string.format('ynhj/ynhjlobby/resource/battle/battle_room/normal_game_%d.png', id)
		ui_name:loadTexture(frame, 1)

		if i == self.select_id then
			ui_btn:setBrightStyle(1)
		end

		ui_btn:setTag(i)
		ui_btn:addTouchEventListener(function(sender, event)
			if id == tonumber(SocketConfig.GAME_ID) then
				local index = sender:getTag()
				self:selectGame(index, event)
			else
				-- @ 提示切换其他子游戏查看战绩
				if event == 2 then
					self:OtherGameTips(id)
				end
			end
		end)
	end
end

function BattleLayer:refreshBattles(room_list)
	self.room_list = room_list
	local listView = self.node.battle_listView
	listView:removeAllItems()
	listView:setItemModel(self.node.battle_item)
	listView:setScrollBarEnabled(false)

	-- @ 记录为空
	-- if #self.room_list == 0 then
	-- 	self.node.clock_bg:setVisible(false)
	-- else
	-- 	self.node.clock_bg:setVisible(true)
	-- end

	-- @ 记录不满一屏幕，slider屏蔽
	if #self.room_list <= 3 then
		self.node.slider:hide()
		self.node.slider:setTouchEnabled(false)
	else
		self.node.slider:hide()
		self.node.slider:setTouchEnabled(true)
	end
	
	-- -- @ 更新时钟
	-- for i=1, 3 do
	-- 	local ui_clock_root = self.node.clock_bg
	-- 	local ui_clock = ui_clock_root:getChildByName('clock_' .. i ) 
	-- 	ui_clock:setVisible(false)
	-- end
	-- for i, _ in ipairs(self.room_list) do
	-- 	if i < 4 then
	-- 		local ui_clock_root = self.node.clock_bg
	-- 		local ui_clock = ui_clock_root:getChildByName('clock_' .. i ) 
	-- 		ui_clock:setVisible(true)
	-- 	end
	-- end

	for i, room in ipairs(self.room_list) do
		local item = listView:getItem(i-1)
		if not item then
			listView:pushBackDefaultItem()
			item = listView:getItem(i-1)
		end

		local bg = item:getChildByName('bg')
		local ui_room_id = bg:getChildByName("Image_16"):getChildByName('room_id')
		local ui_day 		= bg:getChildByName('day')
		local ui_time 		= bg:getChildByName('time')
		local ui_btn	= bg:getChildByName('record')
		ui_btn:setTag(i)

		for idx=1, 4 do
			local ui_name 	= bg:getChildByName('name_' .. idx )
			local ui_win 	= ui_name:getChildByName('win_score')
			local ui_lose 	= ui_name:getChildByName('lose_score')

			local player_data 	= room.player[idx]
			local playerID 		= player_data.playerID
			local name 			= player_data.playerID
			local score 		= player_data.score

			if idx == 1 then
				local user = global:getGameUser()
	    		local props = user:getProps()
	    		local game_player = user:getProp("gameplayer"..SocketConfig.GAME_ID)
	    		playerID = game_player.playerIndex
	    		name = props.name
	    	else
	    		local data = Util.split(name, '-')
	    		name = data[2]
	    		playerID = data[1]
			end
			ui_name:setString(name or '')

			if host_id == playerID then
				-- @ 庄家变色
			end

			if score > 0 then
				ui_win:setVisible(true)
				ui_lose:setVisible(false)
				ui_win:setString('/' .. score)
			else
				ui_win:setVisible(false)
				ui_lose:setVisible(true)
				if score == 0 then
					ui_lose:setString(score)
				else
					ui_lose:setString('/' .. score )
				end
				ui_name:setTextColor({r=0x94,g=0x6c,b=0x54})
			end

			ui_btn:addClickEventListener(function()
				local room_data = self.room_list[i]
				self.part:openBattleDetail(room_data)
			end)
		end

		ui_room_id:setString(room.roomIndex)
		local time = Util.split(room.endTime, ' ')
		ui_day:setString(time[1])
		ui_time:setString(time[2])
		--end
	end
end

function BattleLayer:updateUI(room_list, game_ids, select_id)
	-- if #game_ids == 0 then
	-- 	self.node.clock_bg:setVisible(false)
	-- 	return 
	-- else
	-- 	self.node.clock_bg:setVisible(true)
	-- end

	self.select_id = select_id

	--self:refreshGames(game_ids)

	print(json.encode(room_list))
	self:refreshBattles(room_list)

	--self:selectGame(self.select_id)
end

return BattleLayer
