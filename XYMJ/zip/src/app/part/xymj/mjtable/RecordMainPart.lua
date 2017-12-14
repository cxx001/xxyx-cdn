--[[
*名称:RecordMainPart
*描述:回放主逻辑
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local TablePart = import(".YNTablePart")
local RecordMainPart = class("RecordMainPart", TablePart) --登录模块
RecordMainPart.DEFAULT_VIEW = "TableScene"

--[[
@ 获取分享码url
@ 根据分享码load数据url
]]
local LOAD_DOTA_URL		 = 'http://testapi.xiaoxiongyouxi.com/game-log/get-file-data?code='
local GET_SHARE_CORE_URL = 'http://testapi.xiaoxiongyouxi.com/game-log/fetch-share-code?'

--[[
@ 获取游戏之前数据,用来激活UI
]]
function RecordMainPart:getActiveteData(frames, over_data)
	-- @ table_id
	local table_id = over_data.roomid
	local players = self:adjustUserPos(frames[1].players)

	-- @ 构造一个回放模式数据
	local battle_data 	= {
		record_mode   	= true,
		tableinfo 	  	= {
			tablepos 		= self.m_seat_id,
			viptableid 		= table_id,
			serviceGold		= frames[1].handsTotal,
			creatorid		= frames[1].dealerPos,
			currenthand		= frames[1].quanNum,
			totalhand		= frames[1].handsTotal,
			players			= players,
		},
	}

	return battle_data
end


--激活模块
function RecordMainPart:activate(game_id, data, ext_data, load_over)
	-- @ 进入桌面
	self.game_id = game_id
	local record_data = tablePlayback_pb.tablePlayback()
	record_data:ParseFromString(data)
	self:initFrameData(record_data)
	self:initOverData(record_data)

	self.hide_ready_view = false
	self.m_seat_id		= 1
	self.cur_frame		= 0
	self.record_mode	= true
	self.game_over 		= false
	self.ext_data 		= ext_data

	local battle_data = self:getActiveteData(self.frame_data, self.over_data)
	if not load_over then
		RecordMainPart.super.activate(self, self.game_id, battle_data)
	end
	self:adjustRecordUI()
	self:start()
end

--[[
@ 执行上一局、下一局操作
]]
function RecordMainPart:refreshGame(data, ext_data)
	local game_end = self:getPart("GameEndPart")
	if game_end and game_end.view then
		return 
	end

	local record_stop_part = self:getPart('RecordStopPart')
	if record_stop_part then
		local cur_ju = ext_data.bid
		local total_ju = ext_data.total_ju
		record_stop_part.view:resetUI(cur_ju, total_ju)
	end
	self.view.node.root:stopAllActions()

	self.frame_data = {}
	self.over_data = {}
	self:activate(data, ext_data, true)
	self:processCmd()
end

function RecordMainPart:deactivate()
	self.view:removeSelf()
	self.view =  nil
end

function RecordMainPart:getPartId()
	-- body
	return "RecordMainPart"
end

function RecordMainPart:clickEvent(event)
	if event == 'next_step_event' then
		self:nextFrame()		
	elseif event == 'last_step_event' then
		self:lastFrame()
	elseif event == 'next_ju_event' then
		self:nextJu()
	elseif event == 'last_ju_event' then
		self:lastJu()
	elseif event == 'stop_event' then

	elseif event == 'play_event' then

	end
end

function RecordMainPart:startLoading()
	local loading_part = global:createPart("LoadingPart",self)
	self:addPart(loading_part)
	loading_part:activate()
end

function RecordMainPart:endLoading()
	local loading_part = self:getPart("LoadingPart")
	if loading_part then
		loading_part:deactivate()
	end
end

--[[
@上一局、下一局错误提示
]]
function RecordMainPart:OtherBattleTips(str)
	local tips_part = global:createPart("TipsPart",self)
	if tips_part then
		tips_part:activate({info_txt=str})
	end
end

--[[
@ 下一局
]]
function RecordMainPart:nextJu()
	if not self.ext_data then
		self:OtherBattleTips(string_table.share_code_error)
		return 
	end

	if self.ext_data.bid >= self.ext_data.total_ju then
		self:OtherBattleTips(string_table.next_battle_error)
		return 
	end

	local ext_data = self.ext_data
	local tid = ext_data.tid 
	local bid = ext_data.bid + 1
	self:startLoading()
	local getBattleData = require('app.part.record.GetBattleData').new()
	getBattleData:reqShareCore(tid, bid, function(code, data)
		self:endLoading()
		local cjson = require("cjson")
		local server_data = cjson.decode(data)
		if code == 200 and server_data.code == 0 then
			local share_code = server_data.data

			-- @loading
			self:startLoading()
			getBattleData:loadRecordData(share_code, function(code, data)
				self:endLoading()
				if code == 200 then
					local ext_data = {
						tid = tid,
						bid = bid,
						total_ju = self.ext_data.total_ju,
					}
					self:refreshGame(data, ext_data)
				else 
					local str = ''
					if code == 400 then
						str = string_table.not_battle_data
					else
						str = string.format(string_table.load_battle_error, code)
					end
					-- @ error
					local tips_part = global:createPart("TipsPart",self)
					if tips_part then
						tips_part:activate({info_txt=str})
					end
				end
			end)
		else
			-- @ error
			local tips_part = global:createPart("TipsPart",self)
			if tips_part then
				tips_part:activate({info_txt=server_data.msg})
			end
		end
	end)
end

--[[
@ 上一局
]]
function RecordMainPart:lastJu()
	if not self.ext_data then
		self:OtherBattleTips(string_table.share_code_error)
		return 
	end

	if self.ext_data.bid <= 1 then
		self:OtherBattleTips(string_table.last_battle_error)
		return 
	end

	local ext_data = self.ext_data
	local tid = ext_data.tid 
	local bid = ext_data.bid - 1
	self:startLoading()
	local getBattleData = require('app.part.record.GetBattleData').new()
	getBattleData:reqShareCore(tid, bid, function(code, data)
		self:endLoading()
		local cjson = require("cjson")
		local server_data = cjson.decode(data)
		if code == 200 and server_data.code == 0 then
			local share_code = server_data.data

			-- @loading
			self:startLoading()
			getBattleData:loadRecordData(share_code, function(code, data)
				self:endLoading()
				if code == 200 then
					local ext_data = {
						tid = tid,
						bid = bid,
						total_ju = self.ext_data.total_ju,
					}
					self:refreshGame(data, ext_data)
				else 
					local str = ''
					if code == 400 then
						str = string_table.not_battle_data
					else
						str = string.format(string_table.load_battle_error, code)
					end
					-- @ error
					local tips_part = global:createPart("TipsPart",self)
					if tips_part then
						tips_part:activate({info_txt=str})
					end
				end
			end)
		else
			-- @ error
			local tips_part = global:createPart("TipsPart",self)
			if tips_part then
				tips_part:activate({info_txt=server_data.msg})
			end
		end
	end)	
end

--[[
@ 开始回放
]]
function RecordMainPart:start()
	-- @ 先播放第一帧
	--self:processCmd()

	-- @ 连续播放
	local delay_time = cc.DelayTime:create(1.5)
	local call_back = cc.CallFunc:create(function()
		local stop_part = self:getPart('RecordStopPart')
		if stop_part.view:isStop() then
			-- @ todo stop status
		else
			self:processCmd()
		end
	end)
	local seq = cc.Sequence:create(delay_time, call_back)
	self.view.node.root:runAction(cc.RepeatForever:create(seq))
end

--[[
@ 上一帧
]]
function RecordMainPart:lastFrame()
	self.cur_frame = self.cur_frame - 2
	self.view.node.root:stopAllActions()
	self:processCmd()

	self:start()
end

--[[
@ 下一帧
]]
function RecordMainPart:nextFrame()
	if self.cur_frame > 0 then
		self.cur_frame = self.cur_frame + 1
	end

	self.view.node.root:stopAllActions()
	self:processCmd()
	self:start()
end


--[[
@ 执行一条命令
]]
function RecordMainPart:processCmd(adjust_view)
	if self.cur_frame <= 0 then
		self.cur_frame = 1
		local data = self.frame_data[1]
		self:adjustUserPos(data.players)
		self:adjustRecordUI()
		self.view:initTableWithData(data.players, {dealerpos = data.dealerPos})
		return 
	end

	if self.game_over then
		--self:deactivate()
		return 
	end

	if self.cur_frame > #self.frame_data then
		self.game_over = true
		self:gameOverByRecord()
		self:endLoading()
		return 
	end

	local data = self.frame_data[self.cur_frame]
	self:adjustUserPos(data.players)
	if adjust_view then
		self.view:initTableWithData(data.players, {dealerpos = data.dealerPos})
		self:updatePlayer(data.players)
	end
	self:adjustRecordUI()
	self:refreshMJ(data, adjust_view)
	self.cur_frame = self.cur_frame + 1
end

--[[
@ 调整4个用户位置
]]
function RecordMainPart:adjustUserPos(player_list)
	for k,v in ipairs(player_list) do
		if v.tablepos then
			v.view_id = self:changeSeatToView(v.tablepos)
		end
	end

	return player_list
end

--[[
@ 获取是谁摸牌
]]
function RecordMainPart:getMoUser(frame_data)
	local seat_id = frame_data.currentOpPlayerIndex
	if seat_id < 0 or seat_id > 3 then
		return 
	end

	if seat_id == 3 then
		return 0
	else
		return seat_id + 1
	end
end

--[[
@ 回放数据、逻辑处理
]]
function RecordMainPart:refreshMJ(frame_data, adjust_view)
	-- @这是摸牌、补张
	local seat_id = frame_data.currentOpPlayerIndex
	local seat_id = self:getMoUser(frame_data)
	local card_data = {
		mtablePos			= self.m_seat_id,
		mcards				= {
			cardvalue 		= frame_data.playerCardsInHand[self.m_seat_id + 1],
		},
		--@ 原来代码的数据结构要求
		playercard 			= {frame_data.playerOutCards[1],frame_data.playerOutCards[2],frame_data.playerOutCards[3],frame_data.playerOutCards[4]},
		playerdowncards 	= 
		 {
		 frame_data.playerCardsDown[1],frame_data.playerCardsDown[2],frame_data.playerCardsDown[3],frame_data.playerCardsDown[4]
		},
		playerhucards 		= {},
		chucardplayerindex	= frame_data.currentOpPlayerIndex,
		playeroperationtime = 0,
		baocard				= frame_data.baoCard,
		hands 				= frame_data.playerCardsInHand,

		record_mode 		= true,
	}

	if seat_id == self.m_seat_id and 
	frame_data.moCard > 0 and not adjust_view then
		table.insert(card_data.mcards.cardvalue, frame_data.moCard)
	end

	local ready_part = self:getPart("ReadyPart")
	if ready_part and not self.hide_ready_view then
		self.hide_ready_view = true
	end

	local card_part = self:getPart('CardPart')
	if not card_part.view then
		card_part:activate(self.game_id, card_data)
	end
	card_part.auto_opt = true
	
	local player_table_pos = frame_data.currentOpPlayerIndex + 1
	local operation_data = {
		operation 			= frame_data.opertaionID,
		player_table_pos	= frame_data.currentOpPlayerIndex,
		card_value			= frame_data.opCard,
		opValue 			= frame_data.opCard,
		handCards 			= frame_data.playerCardsInHand[player_table_pos],
		downCards 			= frame_data.playerCardsDown[player_table_pos],
		playerdowncards 	= 
		{
			{cards 			= frame_data.playerCardsDown[1]},
			{cards 			= frame_data.playerCardsDown[2]},
			{cards 			= frame_data.playerCardsDown[3]},
			{cards 			= frame_data.playerCardsDown[4]},
		},
		beforeCards 		= frame_data.playerOutCards[player_table_pos],
	}

	self:adjustOpValue(operation_data)
	if adjust_view then
		operation_data.operation = 0
	end
	if frame_data.opertaionID == 16 and 
		frame_data.opCard == 0 then
		operation_data.operation = 0
	end
	card_part:resetCardDataExt(card_data,operation_data)
	-- self:operationActions(operation_data)
end

--[[
@ 调整opValue, 针对吃、碰、杠
]]
function RecordMainPart:adjustOpValue(opt_data)
	if opt_data.player_table_pos < 0 or 
		opt_data.player_table_pos > 3 then
		return 
	end

	local seat_id = opt_data.player_table_pos + 1
	local cards = opt_data.playerdowncards[seat_id].cards
	if opt_data.operation == RoomConfig.MAHJONG_OPERTAION_PENG or 
		opt_data.operation == RoomConfig.MAHJONG_OPERTAION_CHI or 
		opt_data.operation == RoomConfig.MAHJONG_OPERTAION_AN_GANG or
		opt_data.operation == RoomConfig.MAHJONG_OPERTAION_MING_GANG then
		opt_data.opValue = cards[#cards].cardValue
	end
end

--[[
@ 回放结算、逻辑处理
]]
function RecordMainPart:gameOverByRecord()
	local over_part = self:getPart('GameEndPart')
	if over_part and over_part.view then
		-- @ 当前处于激活状态
		return 		
	end

	self.over_data.record_mode = true
	self:gameEnd(self.over_data)
end

--[[
@ 回放结束
]]
function RecordMainPart:recordOver()
	self.view.node.root:stopAllActions()
	self:deactivate()
end

--[[
@ 切换用视觉
]]
function RecordMainPart:headClick( player_info , posX , posY , viewId )
	self.m_seat_id = player_info.tablepos
	if self.cur_frame > 1 then
		self.cur_frame = self.cur_frame - 1
	end
	local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
	lua_bridge:clearDownImgList()
	self:processCmd(true)
end

function RecordMainPart:initFrameData(record_data)
	local frame_data 	= {}
	for i, frame in ipairs(record_data.frames) do
		frame_data[i] 	= {
			opertaionID				= frame.opertaionID,
			opCard					= frame.opCard,
			currentOpPlayerIndex	= frame.currentOpPlayerIndex,
			dealerPos 				= frame.dealerPos,
			quanNum 				= frame.quanNum,
			newPlayWay 				= frame.newPlayWay,
			baoCard 				= frame.baoCard,
			moCard 					= frame.moCard,
			leftCardNum 			= frame.leftCardNum,
			handsTotal 				= frame.handsTotal,
			playerWinLoseEqual 		= {},
			playerCardsInHand		= {},
			playerOutCards			= {},
			playerCardsDown 		= {},
			players 				= {},
		}

		-- @ playerWinLoseEqual
		local tab = {}
		for i,v in ipairs(frame.playerWinLoseEqual) do
			table.insert(tab, v)
		end
		frame_data[i].playerWinLoseEqual = tab

		-- @ playerCardsInHand
		local tab = {}
		for i, CardInfo in ipairs(frame.playerCardsInHand) do
			local cards = {}
			for i, card in ipairs(CardInfo.cardvalue) do
				table.insert(cards, card)
			end
			table.insert(tab, cards)
		end
		frame_data[i].playerCardsInHand = tab

		-- @playerOutCards
		local tab = {}
		for i, CardInfo in ipairs(frame.playerOutCards) do
			local cards = {}
			for i, card in ipairs(CardInfo.cardvalue) do
				table.insert(cards, card)
			end
			table.insert(tab, cards)
		end
		frame_data[i].playerOutCards = tab

		-- @playerCardsDown
		local tab = {}
		for _, card_down in ipairs(frame.playerCardsDown) do
			local cards = {}
			for i,v in ipairs(card_down.cards) do
				local v = {
					type = v.type,
					cardValue = v.cardValue,
					chuOffset = v.chuOffset,
					usexiaojinum = v.usexiaojinum,
				}
				table.insert(cards, v)
			end
			table.insert(tab, cards)
		end
		frame_data[i].playerCardsDown = tab	
		
		-- @PlayerInfo
		local tab = {}
		for i, player in ipairs(frame.players) do
			local player_data = {
				uid 			= player.uid,
				name            = player.name,
				headImg 		= player.headImg,
				headImgUrl 		= player.headImgUrl,
				coin 			= player.coin,
				tablepos 		= player.tablepos,
				desc 			= player.desc,
				fan 			= player.fan,
				gameresult 		= player.gameresult,
				canfrind 		= player.canfrind,
				intable 		= player.intable,
				ip 				= player.ip,
				gamestate 		= player.gamestate,
				playerIndex 	= player.playerIndex,
				dimaond 		= player.dimaond,
				score 			= player.score,
				wins 			= player.wins,
				lose 			= player.lose,
			}

			-- @vip
			local vip = {
				zhuangcount				= player.vipoverdata.zhuangcount,
				wincount				= player.vipoverdata.wincount,
				dianpaocount			= player.vipoverdata.dianpaocount,
				hithorsecount			= player.vipoverdata.hithorsecount,
				gangcount				= player.vipoverdata.gangcount,
			}
			player_data.vip 			= vip,

			table.insert(tab, player_data)
		end
		frame_data[i].players = tab
	end
	self.frame_data = frame_data
end

function RecordMainPart:initOverData(record_data)
	local over_data = record_data.gameInfo

	local players 		= {}
	local handcard 		= {}
	local downcards 	= {
		{cards = {}},
		{cards = {}},
		{cards = {}},
		{cards = {}},
	}
	local hucards		= {}
	local macard		= {}

	-- @PlayerInfo
	for i, player in ipairs(over_data.players) do
		local player_data = {
			uid 			= player.uid,
			name            = player.name,
			headImg 		= player.headImg,
			headImgUrl 		= player.headImgUrl,
			coin 			= player.coin,
			tablepos 		= player.tablepos,
			desc 			= player.desc,
			fan 			= player.fan,
			gameresult 		= player.gameresult,
			canfrind 		= player.canfrind,
			intable 		= player.intable,
			ip 				= player.ip,
			gamestate 		= player.gamestate,
			playerIndex 	= player.playerIndex,
			dimaond 		= player.dimaond,
			score 			= player.score,
			wins 			= player.wins,
			lose 			= player.lose,
		}

		-- @vip
		local vip = {
			zhuangcount				= player.vipoverdata.zhuangcount,
			wincount				= player.vipoverdata.wincount,
			dianpaocount			= player.vipoverdata.dianpaocount,
			hithorsecount			= player.vipoverdata.hithorsecount,
			gangcount				= player.vipoverdata.gangcount,
		}
		player_data.vip 			= vip,

		table.insert(players, player_data)
	end

	-- @ playerCardsInHand
	for i, CardInfo in ipairs(over_data.handcard) do
		local cards = {cardvalue = {}}
		for i, card in ipairs(CardInfo.cardvalue) do
			table.insert(cards.cardvalue, card)
		end
		table.insert(handcard, cards)
	end

	-- downcards
	for t, card_down in ipairs(over_data.downcards) do
		for i,v in ipairs(card_down.cards) do
			local cards = {
				type = v.type,
				cardValue = v.cardValue,
				chuOffset = v.chuOffset,
				usexiaojinum = v.usexiaojinum,
			}
			table.insert(downcards[t].cards, cards)
		end
	end

	-- @hucards
	for _, card in ipairs(over_data.hucards) do
		table.insert(hucards, card)
	end

	-- @macard
	for _, card in ipairs(over_data.macard) do
		table.insert(macard, card)
	end

	self.over_data = {
		roomid			= over_data.roomid,
		dealerpos 		= over_data.dealerpos,
		huCard 			= over_data.huCard,
		stage			= over_data.stage,
		isviptable		= over_data.isviptable,
		readytime 		= over_data.readytime,
		baocard 		= over_data.baocard,
		huois 			= over_data.huois,
		players 		= players,
		handcard 		= handcard,
		downcards 		= downcards,
		hucards			= hucards,
		macard 			= macard,
	}
end

--[[
@ 调整牌局回放ui
]]
function RecordMainPart:adjustRecordUI()
	local settings_btn 	= self.view.node.settings_btn
	local chat_btn		= self.view.node.chat_btn
	local ui_remain 	= self.view.node.table_info_txt
	if settings_btn then
		--settings_btn:setVisible(false)
		settings_btn:loadTextureNormal('app/part/record/res/battle_room/pz_jsfj1.png', 1)
		settings_btn:loadTexturePressed('app/part/record/res/battle_room/pz_jsfj2.png', 1)
	end

	if ui_remain then
		ui_remain:setVisible(false)
	end

	if chat_btn then
		chat_btn:setVisible(false)
	end

	local card_part = self:getPart('CardPart')
	if card_part and card_part.view then
		local ui_gang = card_part.view.node.gang_pic_btn
		if ui_gang then
			ui_gang:setVisible(false)
		end
	end

	local ready_part = self:getPart("ReadyPart")
	if ready_part and ready_part.view then
		local ui_exit_btn = ready_part.view.node.exit_btn
		ui_exit_btn:setVisible(false)
	end
end

--[[
@ 返回按键
]]
function RecordMainPart:backEvent()
	self:exitClick()
end

return RecordMainPart
