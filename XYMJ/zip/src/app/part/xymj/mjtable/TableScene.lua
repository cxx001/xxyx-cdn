--[[
*名称:TableLayer
*描述:牌桌界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local TableScene = class("TableScene",cc.load("mvc").ViewBase)
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
local CURRENT_MODULE_NAME = ...
TableScene.MENU_ZORDER = 4
function TableScene:onCreate()
	-- body
	self:initWithFilePath("TableScene",CURRENT_MODULE_NAME)
	local date_txt =os.date("%Y-%m-%d")
	self.node.day_txt:setString(date_txt)
	--[[local temp_node = self.node.menu_select_right:clone()
	temp_node:hide()
	temp_node:setName("menu_select_node")
	self:addChild(temp_node,TableScene.MENU_ZORDER)]]--
end

--点击向左按钮，则弹出设置 退出等按钮
function TableScene:MenuLeftClick()
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	--self:turnSeat(1)
	self.node.menu_select_left:hide()
	local temp_node = self:getChildByName("menu_select_node")
	temp_node:show()
	local pz_bg = temp_node:getChildByName("pz_bg")
	local close_room_btn = pz_bg:getChildByName("close_room_btn")
	local exit_btn = pz_bg:getChildByName("exit_btn")

	local tableId = self.part:getTableid()
	if tableId and tableId > 0 then
		close_room_btn:show()
		exit_btn:hide()
	else
		close_room_btn:hide()
		exit_btn:show()
	end
end

-- 点击向右按钮，则隐藏设置 退出等按钮
function TableScene:MenuRightClick()
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self.node.menu_select_left:show()
	-- self.node.menu_select_right:hide()
	-- local temp_node = self:getChildByName("menu_select_node")
	-- temp_node:hide()
end

function TableScene:hideMenu()
	-- body
	-- local temp_node = self:getChildByName("menu_select_node")
	-- temp_node:hide()
end

function TableScene:ExitClick()
	global:getAudioModule():playSound("res/sound/confirm.mp3",false)
	self.part:exitClick()
end

function TableScene:SettingsClick()
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self.part:settingsClick()
end

function TableScene:ChatClick()
	-- body
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self.part:chatClick()
end

function TableScene:OneClick()
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self:HeadClick(1)
end

function TableScene:TwoClick()
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self:HeadClick(2)
end

function TableScene:ThreeClick()
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self:HeadClick(3)
end

function TableScene:FourClick()
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self:HeadClick(4)
end

function TableScene:DissolveClick()
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self.part:closeVipRoom()
end

function TableScene:HeadClick(viewId)
	local player_info = self.part:getPlayerInfo(viewId)
	print("HeadClick player_info :",player_info)
	local posX = self.node['head_bg'..viewId]:getPositionX()
	local posY = self.node['head_bg'..viewId]:getPositionY()
	self.part:headClick(player_info , posX , posY , viewId)
end

function TableScene:initTableWithData(playerList,data)
	-- body
	for i,v in ipairs(playerList) do
		if i > 4 then
			return
		else
			self:showPlayer(v)
			print("this is show banker:",v.tablepos,data.dealerpos)
			if v.tablepos == data.dealerpos then
				self.node["bank_icon" .. v.view_id]:show()
			end
		end
	end
end

function TableScene:initTableInfo(data)
	--roomid
	local roomId = self.node.Text_roomid:setString(string_table.roomid..data.tableId)
	--cell
	local lowestSore = self.node.Text_cell:setString(string_table.cellscore..data.lowestSore)
	--multy cur_room_quan
	local multy = self.node.Text_multy:setString(string_table.multy..data.baseMultiple)
	--cur round
	local curRound = self.node.Text_round:setString(data.gameCount)
end

function TableScene:dispalyQuan(currentQuan,totalQuan) --显示当前局数和总局数 1/4局
	local quanStr = string.format("%d/%d%s",currentQuan,totalQuan,string_table.ju_shu)
	self.node.quanBg:show()
	self.node.quanLabel:setString(quanStr)
end

function TableScene:offlinePlayer(offlinePos,online)
	-- local name = self.node['name' .. offlinePos]
	-- if online then
	--     name:setColor({r=255,g=255,b=255})
 --    else
 --        name:setColor({r=0,g=0,b=0})
 --    end
	if online then
		self.node['offline_icon' .. offlinePos]:hide()
	else
		self.node['offline_icon' .. offlinePos]:show()
	end
end

--剩下多少张
function TableScene:updateLastCardNum(num)
	-- body
	self.node.table_info_txt:setString(string.format(string_table.cards_left_txt,num))
end

--根据玩家信息显示玩家
-- view_id 是经过转换的界面位置
function TableScene:showPlayer(playerInfo)
	-- body
	if playerInfo.view_id and playerInfo.view_id >= 1 and playerInfo.view_id <= 4 then
		local head_node = self.node["head_node" .. playerInfo.view_id]
		local name = self.node['name' .. playerInfo.view_id]
		local coin = self.node['coin' .. playerInfo.view_id]
		head_node:show()
		name:setString(playerInfo.name)
		coin:setString(playerInfo.coin)

		print("---playerInfo.targetPlayerName : ",playerInfo.targetPlayerName)
		print("---playerInfo.headImgUrl : ",playerInfo.headImgUrl)
		if playerInfo.targetPlayerName ~= nil then
			if playerInfo.targetPlayerName and playerInfo.targetPlayerName ~= "" then
				self.part:loadHeadImg(playerInfo.targetPlayerName,head_node)
			end
		else 	
			if playerInfo.headImgUrl and playerInfo.headImgUrl ~= "" then
				self.part:loadHeadImg(playerInfo.headImgUrl,head_node)
			end
		end
	end
end

function TableScene:updatePlayerInfo(playerList)
	-- body
	for i,v in ipairs(playerList) do
		if i > 4 then
			return
		else
			self:showPlayer(v)
		end
	end
end

function TableScene:showGoldOrVipText(isVip,tableId)
	if self.node.goldOrRoomIdLabel then
		if isVip == true  then
			local roomId = string.format(string_table.room_idx_txt,tableId)
			self.node.goldOrRoomIdLabel:setString(roomId)
		else
			self.node.goldOrRoomIdLabel:setString(string_table.gold_play_txt)
		end
	end
end


 --返回座位坐标用于播放表情动画
function TableScene:getPosTable()
	-- body
	local pos_table = {}
	for i=1,RoomConfig.TableSeatNum do
		local head_node = self.node["head_bg" .. i]
		local head_content = head_node:getContentSize()
		local pos 
		if i == RoomConfig.DownSeat or i == RoomConfig.FrontSeat then
			pos = cc.pSub(cc.p(head_node:getPosition()),cc.p(head_content.width*2/5,0))
		else 
			pos = cc.pAdd(cc.p(head_node:getPosition()),cc.p(head_content.width*4/5,0)) 
		end
		table.insert(pos_table,pos)
	end
	return pos_table
end

--轮到某个位置
--seat 逻辑座位 1 -4
function TableScene:turnSeat(seat,time)
	-- body
	for i=1,RoomConfig.TableSeatNum do
		self.node["bearing"..i-1]:stopAllActions()
		self.node["bearing" .. i-1]:hide()
	end
	local cur_bearing = self.node["bearing" .. seat-1]
	cur_bearing:show()
	local seq = cc.Sequence:create(cc.FadeOut:create(1),cc.FadeIn:create(1))
	local action = cc.Repeat:create(seq,RoomConfig.WaitTime/2)
	cur_bearing:runAction(action)
	self:startCountTime(time)
end

function TableScene:CloseRoomClick()
	-- body
	self.part:closeVipRoom()
end


--开始倒计时
function TableScene:startCountTime(lastTime)
	-- body
	local cur_time = 1
	local wait_time = RoomConfig.WaitTime

	if lastTime then
		wait_time = lastTime
	end

	if self.time_entry then --如果正在计时就重新开始
		self:unScheduler(self.time_entry)
	end
	self.node.bearing_time:show()
	self.node.bearing_time:setString(wait_time)
	self.time_entry = self:schedulerFunc(function()
		-- body
		if cur_time > wait_time then
			-- self.node.bearing_time:hide()
			self:unScheduler(self.time_entry)
			return
		end
		local time = wait_time - cur_time
		if time < 10 then
			time = "0" .. time
		end
		self.node.bearing_time:setString(time)
		cur_time = cur_time + 1
	end,1,false)
end

--是否显示解散房间按钮
function TableScene:isShowCloseBtn(flag)
	if flag == true then 
		-- self.node.close_room_btn:show()
	else
		-- self.node.close_room_btn:hide()
	end
end

function TableScene:BackToLobby( ref )
	self.part:BackToLobby()
end
function TableScene:onEnter()
    self.part:onEnter()
end

function TableScene:onExit()
    self.part:onExit()
end


function TableScene:playerScoreEffect(ui_head, ui_score, ui_total_score, score, totalScore)
	local size 	= ui_head:getContentSize()
	ui_score:setAnchorPoint(cc.p(0.5, 1))
	ui_score:setPosition(cc.p(size.width/2, size.height))
	ui_score:setString('/' .. math.abs(score))
	ui_head:addChild(ui_score)
	
	local move_to = cc.MoveTo:create(0.462, cc.p(size.width/2, size.height + 70))
	local call_back = cc.CallFunc:create(function()
		ui_score:removeFromParent()
	end)
	local seq1 = cc.Sequence:create(move_to, call_back)

	local delay_time 	= cc.DelayTime:create(0.33)
	local fade_out		= cc.FadeOut:create(0.132)
	local seq2 			= cc.Sequence:create(delay_time, fade_out)

	local spawn			= cc.Spawn:create(seq1, seq2)
	local call_back		= cc.CallFunc:create(function()
		local path_name = 'app/part/mjtable/res/jingyaneffect'
		local ui_effect = Util.createSpineAnimation(path_name, '1', nil, true)
		local size 		= ui_total_score:getContentSize()
		ui_effect:setAnchorPoint(cc.p(0.5, 0.5))
		ui_effect:setPosition(cc.p(size.width/2, size.height/2))
		ui_total_score:addChild(ui_effect)
		ui_total_score:setString(totalScore)
	end)
	local seq 			= cc.Sequence:create(spawn, call_back)
	ui_score:runAction(seq)
end

function TableScene:updateScoreNtf(score_ntf)
	for i=1, 4 do
		local ui_head 	= self.node['head_node' .. i ]
		ui_head:setVisible(true)
	end

	for i, player_score in ipairs(score_ntf.playerScore) do
		local uid 		= player_score.uid
		local score 	= player_score.score
		local totalScore= player_score.totalScore

		local seat_id, player = self.part:getPlayerByUid(uid)
		if not seat_id or not player then
			print('update match score error:', uid, seat_id, json.encode(player))
			return 
		end

		local view_id 			= self.part:changeSeatToView(seat_id) 
		local ui_head 			= self.node["head_node" .. view_id]
		local ui_total_score 	= self.node['coin' .. view_id ]
		local ui_win_score	 	= ccui.TextAtlas:create('',
													"app/part/mjtable/res/win_score_number.png",
													40,
													47,
													"/")

		local ui_lose_score = ccui.TextAtlas:create('',
													"app/part/mjtable/res/lose_score_number.png",
													40,
													47,
													"/")
		ui_head:setVisible(true)
		if score == 0 then
			local ui_score 	= self.node['coin' .. view_id]
			ui_score:setString(totalScore)
		elseif score > 0 then
			local ui_head 	= self.node["head_node" .. view_id]
			self:playerScoreEffect(ui_head, ui_win_score, ui_total_score, score, totalScore)
		elseif score < 0 then
			local ui_head 	= self.node["head_node" .. view_id]
			self:playerScoreEffect(ui_head, ui_lose_score, ui_total_score, score, totalScore)
		end
	end
end

return TableScene
