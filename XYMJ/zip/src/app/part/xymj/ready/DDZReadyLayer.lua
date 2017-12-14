local DDZReadyLayer = class("DDZReadyLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
function DDZReadyLayer:onCreate() --传入数据
	-- body
	self:initWithFilePath("ReadyLayer",CURRENT_MODULE_NAME)
end

--显示所有玩家
function DDZReadyLayer:initPlayer(playerList)
	-- 自己永远是node1
	if playerList then
		for k,v in ipairs(playerList) do
			if k > 3 then
				return
			else
				self:showPlayer(v)
			end
		end

		local player_size = #playerList 
		if player_size >= 3 then --房间满人不需要邀请
			self.node.invite_btn:hide()
			--该显示底牌了
			self.node.roomInfo1:hide()
			self.node.roomInfo2:show()						
		else
			self.node.invite_btn:show()

			self.node.roomInfo1:show()	
			self.node.roomInfo2:hide()
		end
	end
end

function DDZReadyLayer:nextGame(playerList)
	-- body
	if playerList then
		for k,v in ipairs(playerList) do
			if k > 3 then
				return
			else
				self:showPlayer(v)
			end
		end
	end

end

function DDZReadyLayer:showPlayer(playerInfo)
	-- body
	if playerInfo.view_id and playerInfo.view_id >= 1 and playerInfo.view_id <= 3 then
		local head_node = self.node["head_node" .. playerInfo.view_id]
		local name = self.node['name' .. playerInfo.view_id]
		local coin = self.node['coin' .. playerInfo.view_id]
		local ready_icon = self.node['read_icon' .. playerInfo.view_id]
		local state_icon = self.node["state_icon" .. playerInfo.view_id]
		head_node:show()
		if playerInfo.gamestate == 4 then --未准备
			ready_icon:hide()
		else
			ready_icon:show()
		end
		name:setString(playerInfo.name)
		name:setColor({r=255,g=255,b=255})		--初始化白色
		coin:setString(playerInfo.coin)
		
		if playerInfo.intable ~= 0 then --跟麻将正好相反为0代表在牌桌上
            self:offlinePlayer(playerInfo.view_id,false)
		end

		if playerInfo.headImgUrl and playerInfo.headImgUrl ~= "" then
			self.part:loadHeadImg(playerInfo.headImgUrl,head_node)
		end
	end
end

function DDZReadyLayer:hidePlayer(num)
	local head_node = self.node["head_node" .. num]
	head_node:hide()
end

function DDZReadyLayer:offlinePlayer(offlinePos,online)
	local name = self.node['name' .. offlinePos]
	if online then
	   name:setColor({r=255,g=255,b=255})
    else
        name:setColor({r=0,g=0,b=0})
    end

    local ready_icon = self.node['read_icon' .. offlinePos]
	if online then --未准备
		ready_icon:show()
	else
		ready_icon:hide()
	end
end

function DDZReadyLayer:setTableID(tableId)
	-- body
	print("房间号:->",string.format(string_table.room_id_txt,tableId))
	self.node.room_id_txt:setString(string.format(string_table.room_id_txt,tableId))
end

--获取座位坐标列表
function DDZReadyLayer:getPosTable()
	-- body
	local pos_table = {}
	for i=1,DdzConfig.TableSeatNum do
		local head_node = self.node["head_bg" .. i]
		local head_content = head_node:getContentSize()
		local pos = nil
		if i == RoomConfig.DownSeat or i == RoomConfig.FrontSeat then
			pos = cc.pSub(cc.p(head_node:getPosition()),cc.p(head_content.width*2/5,0))
		else 
			pos = cc.pAdd(cc.p(head_node:getPosition()),cc.p(head_content.width*4/5,0)) 
		end
		table.insert(pos_table,pos)
	end
	return pos_table
end

function DDZReadyLayer:showVipInfo(data)
	-- body
	self.node.vip_layer:show()
	--cell
	local lowestSore = self.node.Text_cell:setString(string_table.cellscore..data.lowestSore)
	--multy cur_room_quan
	local multy = self.node.Text_multy:setString(string_table.multy..data.baseMultiple)
	--cur round
	local curRound = self.node.Text_round:setString(data.gameCount)	
end

--邀请好友
function DDZReadyLayer:InviteFriendsClick()
	-- body
	self.part:inviteFriends()
end

--解散房间
function DDZReadyLayer:CloseRoomClick()
	-- body
	self.part:closeRoom()
end

function DDZReadyLayer:MaskClick()
	-- body
	self.part:maskClick()
end

function DDZReadyLayer:ExitClick()
	self.part:exitClick()
end

function DDZReadyLayer:MicClick()
	self.part:micClick()
end

function DDZReadyLayer:TrustClick()
	self.part:trustClick()
end

function DDZReadyLayer:ChatClick()
	self.part:chatClick()
end

function DDZReadyLayer:SettingClick()
	self.part:settingClick()
end

--不抢地主
function DDZReadyLayer:NotGrabClick(  )
	-- body
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)	
	self.part:callScore(0)
	self:hideOptLayer()
end

--不叫地主
function DDZReadyLayer:NotCallClick(  )
	-- body
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)	
	self.part:callScore(0)
	self:hideOptLayer()
end

--抢地主
function DDZReadyLayer:GrabDizhuClick(  )
	-- body
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)	
	self.part:callScore(1)
	self:hideOptLayer()
end

--叫地主
function DDZReadyLayer:CallDizhuClick(  )
	-- body
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)	
	self.part:callScore(1)
	self:hideOptLayer()
end

--玩家叫分
function DDZReadyLayer:playerCallScore(viewId,flag,score)
	-- body
	if viewId and viewId >= 1 and viewId <= 3 then
		local ready_icon = self.node['read_icon' .. viewId]
		local state_icon = self.node["state_icon" .. viewId]
		ready_icon:hide()
		if 1 == flag then --抢地主
			if 1 == score then
				state_icon:loadTexture("ddz/room/resource/bn_GamePlay_QiangDiZhu_Action.png",1)	--抢
			else
				state_icon:loadTexture("ddz/room/resource/bn_GamePlay_BuQiang_Action.png",1)	--不抢
			end
		elseif 0 == flag then	--叫地主
			if 1 == score then
				state_icon:loadTexture("ddz/room/resource/bn_GamePlay_JiaoDiZhu_Action.png",1)	--叫
			else
				state_icon:loadTexture("ddz/room/resource/bn_GamePlay_BuYao_Action.png",1)	--不叫
			end		
		end
		
		-- if playerInfo.intable ~= 0 then --跟麻将正好相反为0代表在牌桌上
  --           self:offlinePlayer(playerInfo.privSide,false)
		-- end

		-- if playerInfo.headImgUrl and playerInfo.headImgUrl ~= "" then
		-- 	self.part:loadHeadImg(playerInfo.headImgUrl,head_node)
		-- end
	end	
end

function DDZReadyLayer:showState(viewId,state)
	-- body
	print("this is DDZReadyLayer showState -----------------:",viewId,state)
	if viewId == DdzConfig.MySeat then
		if state == 0 then --叫地主阶段
			self.node.opt_layer2:show()
			self.node.opt_layer1:hide()
		elseif state == 1 then -- 抢地主阶段
			self.node.opt_layer2:hide()
			self.node.opt_layer1:show()
		end
	else
		self.node.opt_layer2:hide()
		self.node.opt_layer1:hide()
	end
end

--轮到某个位置
--seat 逻辑座位 1 -3
function DDZReadyLayer:turnSeat(seat,time)
	-- body
	for i=1,DdzConfig.TableSeatNum do
		self.node["clock_img"..i]:stopAllActions()
		self.node["clock_img"..i]:hide()
	end
	local cur_clock = self.node["clock_img" .. seat]
	cur_clock:show()
	-- local seq = cc.Sequence:create(cc.ScaleTo:create(1,0.5),cc.ScaleTo:create(1,1))
	-- local action = cc.Repeat:create(seq,DdzConfig.WaitTime/2)
	-- cur_clock:runAction(action)
	self:startCountTime(seat,time)
end

--开始倒计时
function DDZReadyLayer:startCountTime(i,lastTime)
	-- body
	local cur_time = 1
	local wait_time = DdzConfig.WaitTime

	if lastTime then
		wait_time = lastTime
	end

	if self.time_entry then --如果正在计时就重新开始
		self:unScheduler(self.time_entry)
	end
	self.node["clock_time"..i]:show()
	self.node["clock_time"..i]:setString(wait_time)
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
		self.node["clock_time"..i]:setString(time)
		cur_time = cur_time + 1
	end,1,false)
end

function DDZReadyLayer:hideOptLayer()
	-- body
	self.node.opt_layer1:hide()
	self.node.opt_layer2:hide()
	--停止并隐藏 计时器
	for i=1,DdzConfig.TableSeatNum do
		self.node["clock_img"..i]:stopAllActions()
		self.node["clock_img" .. i]:hide()
	end	
end

return DDZReadyLayer