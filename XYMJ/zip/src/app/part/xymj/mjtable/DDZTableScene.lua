local TableScene = import(".TableScene")
local DDZTableScene = class("DDZTableScene",TableScene)

function DDZTableScene:initTableInfo(data,playerList)
	--roomid
	local lowestSore = self.node.Text_cell:setString(string_table.cellscore..data.objGameTable.lowestSore)
	--multy cur_room_quan
	local multy = self.node.Text_multy:setString(string_table.multy..data.objGameTable.baseMultiple)
	--cur round
	local curRound = self.node.Text_round:setString(data.objGameTable.gameCount)
	self:updatePlayerInfo(playerList)
end

function DDZTableScene:updatePlayerInfo(playerList)
	-- body
	for i,v in ipairs(playerList) do
		if i > 3 then
			return
		else
			self:showPlayer(v)
		end
	end
end

--根据玩家信息显示玩家
-- view_id 是经过转换的界面位置
function DDZTableScene:showPlayer(playerInfo)
	-- body
	if playerInfo.view_id and playerInfo.view_id >= 1 and playerInfo.view_id <= 3 then
		local head_node = self.node["head_node" .. playerInfo.view_id]
		local name = self.node['name' .. playerInfo.view_id]
		local coin = self.node['coin' .. playerInfo.view_id]
		head_node:show()
		name:setString(playerInfo.name)
		coin:setString(playerInfo.coin)

		-- print("---playerInfo.targetPlayerName : ",playerInfo.targetPlayerName)
		-- print("---playerInfo.headImgUrl : ",playerInfo.headImgUrl)
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

--剩下多少张
function DDZTableScene:updateLastCardNum(data)
	-- body
	for i = 1, DdzConfig.TableSeatNum do
		self.node["remainNum"..i]:setString(data[i])
	end	
end

--轮到某个位置
--seat 逻辑座位 1 -3
function DDZTableScene:turnSeat(seat,time)
	-- body
	for i=1,DdzConfig.TableSeatNum do
		self.node["clock_img"..i]:stopAllActions()
		self.node["clock_img" .. i]:hide()
	end
	local cur_clock = self.node["clock_img" .. seat]
	cur_clock:show()
	self:startCountTime(seat,time)
end

--开始倒计时
function DDZTableScene:startCountTime(i,lastTime)
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

--显示地主、农民 头像
function DDZTableScene:showBankerState( seat, is_Banker )
	-- body
	local bank_icon = self.node["bank_icon"..seat]
	if is_Banker then
		bank_icon:loadTexture("ddz/room/resource/LabelLandlord.png",1)	--地主
	else
		bank_icon:loadTexture("ddz/room/resource/LabelPeasant.png",1)	--农民
	end
	bank_icon:show()
end

function DDZTableScene:showPassCard( view_id,is_show )
	-- body
	if is_show then
		self.node["opt_icon"..view_id]:show()
	else
		self.node["opt_icon"..view_id]:hide()
	end
end

function DDZTableScene:micClick()
	self.part:micClick()
end

function DDZTableScene:TrustClick()
	self.part:trustClick()
end

function DDZTableScene:DistrustClick()
	self.part:distrustClick()
end

function DDZTableScene:invalidOutCard(type)
	if -1 == type then
		self.node.invalidTip:loadTexture("ddz/room/resource/Tip1.png",1)	--出牌不符合规则
	elseif -2 == type then
		self.node.invalidTip:loadTexture("ddz/room/resource/Tip0.png",1)	--大不过上家
	end
	
	self.node.invalidTip:show()
	--self.node.invalidTip:setLocalZorder(1)
    local actions = {
                        cc.DelayTime:create(2),
                    }
    local seq = transition.sequence(actions)

    transition.execute(self.node.invalidTip, seq,{ removeSelf= false, onComplete = function()
        self.node.invalidTip:hide()
    end})
end

---请求托管
function DDZTableScene:TrustClick()
	-- body
	self.part:reqAutoCard()
end

return DDZTableScene
