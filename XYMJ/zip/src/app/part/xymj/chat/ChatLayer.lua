--[[
*名称:ChatLayer
*描述:聊天界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local ChatLayer = class("ChatLayer",cc.load("mvc").ViewBase)
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
local CURRENT_MODULE_NAME = ...
ChatLayer.FACE_NUM = 20
ChatLayer.TEXT_NUM = 12


ChatLayer.FACE_TYPE = 1 --表情
ChatLayer.TEXT_TYPE = 2 --文字

ChatLayer.RECORD_CD_TIME = 0.5--录音冷却事件，防止频繁操作
ChatLayer.MAX_RECORD = 30 --保存最大的语音记录条数

for i=1,ChatLayer.FACE_NUM do
	ChatLayer["FaceClick" .. (i-1)] = function(self)
		-- body
		-- self:showFaceWithPos(i-1,self.node.voice_btn)
		self:hideSz()
		self.part:sendTalkingInGameMsg(1,i-1,"","",0)
	end
end
function ChatLayer:onCreate()
	-- body
	self.bTips = false;
	self:initWithFilePath("ChatLayer",CURRENT_MODULE_NAME)
	self.node.text_list:setItemModel(self.node.text_panel) --设置文字默认模版
	for i=1,self.TEXT_NUM do --设置快捷文字
		self.node.text_list:insertDefaultItem(i-1)
		local item = self.node.text_list:getItem(i-1)
		local txt = item:getChildByName('quick_txt')
		txt:setString(string_table["player_speak_" .. (i-1)])
	end
	self.node.text_list:addEventListener(function(target,event)
		-- body
		if event == 1 then
			local select_index = self.node.text_list:getCurSelectedIndex()
			local str = string_table["player_speak_" .. select_index]
			self:hideSz()
			--self.part:sendText(str)

			self.part:sendTalkingInGameMsg(0 , select_index , str ,"" ,0)
		end
	end)
end


--临时改需求-这块不需要修改(类似微信聊天窗口)
-- --表情
-- function ChatLayer:createLeftFaceItem(url,msg)
-- 	local widget = nil
-- 	return widget
-- end
-- function ChatLayer:createRightFaceItem(url,msg)
-- 	local widget = nil
-- 	return widget
-- end
-- --文本
-- function ChatLayer:createLeftTxtItem(url,msg)
-- 	local widget = nil
-- 	return widget		
-- end
-- function ChatLayer:createRihgtTxtItem(url,msg)
-- 	local widget = nil
-- 	return widget
-- end

-- --分割文字总数
-- function ChatLayer:filterChatTextLabel(msg)
-- 	local txtRowNum = 18
-- 	local rowNum = math.ceil(string.utf8len(msg)/txtRowNum)
-- 	local txtTb = {}
-- 	for i=1,rowNum do
-- 	local txt =nil
-- 	local fromIndex = 1+(i-1)*txtRowNum
-- 	local toIndex = i*txtRowNum
-- 	if i==rowNum then
-- 		toIndex=string.utf8len(msg)
-- 	end
-- 	txt = string.utf8sub(msg,fromIndex,toIndex)
-- 	table.insert(txtTb,txt)
-- 	end
-- end

-- function ChatLayer:getPlayerHeadUrl(viewId)
-- 	return ""
-- end
-- --获取相对应的模板
-- --left：他人
-- --right:本人
-- --msgType:0文本1：表情
-- function ChatLayer:getChatTempItem(msgType,viewId,msg)
-- 	local item = nil
-- 	local headUrl = self:getPlayerHeadUrl(viewId)
-- 	if msgType == 0 then -- 文本
-- 		if viewId == RoomConfig.MySeat then
-- 			item = self:createRihgtTxtItem(headUrl,msg)
-- 		else
-- 			item = self:createLeftTxtItem(headUrl,msg)
-- 		end
-- 	elseif msgType == 1 then --表情
-- 		if viewId == RoomConfig.MySeat then
-- 			item = self:createRightFaceItem(headUrl,msg)
-- 		else
-- 			item = self:createLeftTxtItem(headUrl,msg)
-- 		end	
-- 	end
-- 	return item
-- end

-- --展示内容
-- function ChatLayer:displayContent(bg,msgType,viewId，msg)
-- 	local function createTxtWidget()
-- 		local txt=ccui.Text:create()
-- 		txt:setAnchorPoint(cc.p(0,0))
-- 		txt:setFontSize(30)
-- 		return txt
-- 	end
-- 	local function setBgHeight(bg,msg)
-- 		local txtTb = self:filterChatTextLabel(msg)
-- 		local initHeight = 10
-- 		local totoalHeight = initHeight
-- 		local bgWidth = 0
-- 		for i,v in ipairs(txtTb) do
-- 			local txt = createTxtWidget()
-- 			local str = v
-- 			txt:setString(str)
-- 			local txtHeight = txt:getContentSize().height
-- 			txt:setPositionY(initHeight +(i-1)*txtHeight)
-- 			totoalHeight = totoalHeight + txtHeight
-- 			if i == 1 then
-- 				bgWidth = txt:getContentSize().width
-- 			end 
-- 		end
-- 		bg:setContentSize(cc.size(bgWidth,totoalHeight))
-- 	end
-- 	setBgHeight(bg,msg)
-- 	--左文本
-- 	--右文本
-- 	--左表情
-- 	--右表情
-- end

-- function ChatLayer:getLookItem()
-- 	local lookItem =nil
-- 	return lookItem 
-- end

-- function ChatLayer:addChatItem(msgType,pos,msg)
-- 	local widgetItem = self:getChatTempItem(msgType,pos,msg)
-- end

function ChatLayer:FaceEvent()
	self.part:faceEvent()
end

function ChatLayer:TextEvent()
	self.part:textEvent()
end

function ChatLayer:SendClick()
	--self.part:sendText()
	local txt = self.node.input_feild:getString()
	if txt ~= "" then
		self.part:sendTalkingInGameMsg(2,nil,txt)
		self.node.input_feild:setString("")
		self.node.input_feild:detachWithIME()
		self:hideSz()
	end
end

function ChatLayer:ChatClick()
	-- body
	self.node.sz_bg_mask:show()
	self.node.sz_bg:show()
end

function ChatLayer:VoiceRecordEvent()
	-- body
	self.part:voiceRecordEvent()
end

function ChatLayer:delayCallMsg(data)
	-- body
	local entry 
	entry = self:schedulerFunc(function()
		-- body
		self.part:playDelayAudioMsg(data)
		if entry then
			self:unScheduler(entry)
		end
	end,0.2,false)
end

-------------------------------------------------表情相关-------------------------------
function ChatLayer:hideSz() --隐藏聊天面板
	-- body
	self.node.sz_bg_mask:hide()
	self.node.sz_bg:hide()
end

function ChatLayer:hideSzBtn()
	-- body
	self.node.chat_btn:hide()
end

function ChatLayer:showSelectedPage(page)
	-- body
	print("this is show select page------------------------:",page)
	if page == self.FACE_TYPE then
		self.node.face_scroll:show()
		self.node.text_list:hide()
		self.node.text_check:setSelected(false)
		self.node.face_check:setTouchEnabled(false)
		self.node.text_check:setTouchEnabled(true)
	else
		self.node.face_scroll:hide()
		self.node.text_list:show()
		self.node.face_check:setSelected(false)
		self.node.text_check:setTouchEnabled(false)
		self.node.face_check:setTouchEnabled(true)
	end
end


--在某个位置播放表情
function ChatLayer:showFaceWithPos(faceid,pos)
	-- body
	if faceid >=0 and faceid < self.FACE_NUM then
		local sprite = cc.Sprite:createWithSpriteFrameName(string.format("%s/%d.png",self.res_base,faceid))
		sprite:setPosition(pos)
		self:addChild(sprite)
		local actions = {
						 cc.MoveBy:create(0.3,cc.p(0,10)),
						 cc.MoveBy:create(0.1,cc.p(0,-4)),
						 cc.MoveBy:create(0.1,cc.p(0,4)),
						 cc.MoveBy:create(0.1,cc.p(0,-4)),
						 cc.FadeOut:create(5.0)
						}
		local seq = transition.sequence(actions)
		local action = transition.execute(sprite,seq,{removeSelf= true})
	end
end

function ChatLayer:showYuYinWithPos(pos,viewId)
	-- body
	local sprite = cc.Sprite:createWithSpriteFrameName(self.res_base .. "/player_speaking.png")
	local size = cc.size(sprite:getContentSize().width ,sprite:getContentSize().height)
    if viewId == RoomConfig.DownSeat or viewId == RoomConfig.FrontSeat then
        pos = cc.pSub(pos,cc.p(size.width,0))
        sprite:setFlippedX(true)
    end
	sprite:setPosition(pos)
	self:addChild(sprite)
	local actions = {
					 cc.MoveBy:create(0.3,cc.p(0,10)),
					 cc.MoveBy:create(0.1,cc.p(0,-4)),
					 cc.MoveBy:create(0.1,cc.p(0,4)),
					 cc.MoveBy:create(0.1,cc.p(0,-4)),
					 cc.FadeOut:create(5.0)
					}
	local seq = transition.sequence(actions)
	local action = transition.execute(sprite,seq,{removeSelf= true})
end

function ChatLayer:showTextWithPos(str,pos,viewId,flag,sex)
	-- body
	if str then
		local str_txt = ccui.Text:create()
		str_txt:setFontSize(30)
		str_txt:setString(str)
		str_txt:setColor({r=0,g=0,b=0})
		local size = cc.size(str_txt:getContentSize().width + 40,str_txt:getContentSize().height + 25)
		local talk_sprite = ccui.Scale9Sprite:createWithSpriteFrameName(self.res_base .. '/MsgBox1.png')
		talk_sprite:setContentSize(size)
		talk_sprite:setAnchorPoint(cc.p(0,0.5))
		talk_sprite:setPosition(cc.pAdd(pos,cc.p(-25,0)))

		str_txt:setAnchorPoint(cc.p(0,0.5))

		if viewId == RoomConfig.DownSeat or viewId == RoomConfig.FrontSeat then
			talk_sprite:setFlippedX(true)
			pos = cc.pSub(pos,cc.p(size.width,0))
		end

		str_txt:setPosition(pos)

		self:addChild(talk_sprite)
		self:addChild(str_txt)

		transition.execute(str_txt,cc.FadeOut:create(7),{removeSelf = true})
		transition.execute(talk_sprite,cc.FadeOut:create(7),{removeSelf = true})
	end

	if flag then
		local mp3_name = ""
		local num =0
		
		for loop=1,12 do
			if string_table["player_speak_" ..(loop - 1)] == str then
				num = loop
				break
			end
		end
		if num ~=0 then
			local resSoundBeforePath = "res/sound/"
			local sexPath = sex == 2 and "man/" or "female/"
			mp3_name = string.format("%s%s%d.mp3",resSoundBeforePath,sexPath,num)
		end
		if mp3_name ~= "" then
			global:getAudioModule():playSound(mp3_name,false)
		end
	end
end

--------------------------------------语音相关-------------------------------------------------

--默认关闭record面板
function ChatLayer:setVoiceRecordState(state)
	-- body
	if state then
		self.node.voice_msg_log:hide()
		self.node.voice_record_bg:setPosition(0,720)
	else
		self.node.voice_record_bg:setPosition(-396,720)
	end
end


function ChatLayer:intRecordProgress(maxTime)
	-- body
	self.voice_max = maxTime
	self.voicing = false
	self.record_cd = false --是否录音cd中
	-- local voice_sprite = cc.Sprite:createWithSpriteFrameName(self.res_base .."/recordProgressDisplay.png")
	-- self.node.voice_progress = cc.ProgressTimer:create(voice_sprite)
	-- self.node.voice_progress:setType(0)
	-- self.node.voice_progress:setPercentage(100)
	-- local size = self.node.voice_bg:getContentSize()
	-- self.node.voice_bg:addChild(self.node.voice_progress)
	-- self.node.voice_progress:setPosition(cc.p(size.width/2,size.height/2))
	-- self.node.voice_time:setString(maxTime)
	-- self.node.voice_record_bg:show()
	self.node.voice_record_list:setItemModel(self.node.voice_panel)
	self.node.voice_record_list:addEventListener(handler(self,ChatLayer.onListViewClick))


	self.voice_list = {}
	self.voice_playing = false
	-- local data ={
	-- 	isme = true,
	-- 	img_url = "http://wx.qlogo.cn/mmopen/Vt3en7SeZMnc4t2XACP0I2v0SAoHDlDsqtUsrgsy5yIv6icUzwR1Xm2Tesib2U4iaVlLXaOazo8EsrF8xSJF8GEM1xmURV9AMNe/0",
	-- 	voice_path = "",
	-- 	voice_lenth = 20
	-- }

	-- self:voiceListAddCell(0,data)

	-- local data1 ={
	-- 	isme = false,
	-- 	voice_path = "",
	-- 	voice_lenth = 10
	-- }
	-- self:voiceListAddCell(1,data1)

end


--播放列表中声音事件
function ChatLayer:onListViewClick(touch,event)
	-- body
	if event == 1 then
		local select_index = self.node.voice_record_list:getCurSelectedIndex()
		local item  = self.node.voice_record_list:getItem(select_index)
		local data = self.voice_list[select_index+1]
		local data1 = self.voice_list[2]
		local voice_time = item:getChildByName("voice_time_right")
		if not data.isme then
			voice_time = item:getChildByName("voice_time_left")
		end

		local voice_log = voice_time:getChildByName("voice_log")
		print("voice_time:",voice_time:getName(),item,data.isme,data1.isme,voice_log)
		if data.isme  then
			voice_log:setSpriteFrame(self.res_base .."/myVoicePic3.png")
		else
			voice_log:setSpriteFrame(self.res_base .."/otherVoicePic3.png")
		end

		voice_log:stopAllActions()
		if self.voice_playing then
			self.voice_playing = false
			return
		end

		local animation = cc.Animation:create()
		for i=1,3 do
			if data.isme  then
				local sprite_frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format(self.res_base .."/myVoicePic%d.png",i))
				animation:addSpriteFrame(sprite_frame)
			else
				local sprite_frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format(self.res_base .."/otherVoicePic%d.png",i))
				animation:addSpriteFrame(sprite_frame)
			end
		end
		animation:setDelayPerUnit(0.3)
		animation:setRestoreOriginalFrame(true)
		local action = cc.Animate:create(animation)
		voice_log:runAction(cc.Repeat:create(action,data.voice_lenth))
		self.voice_playing = true
		self.part:playRecord(select_index+1)
	end
end

---取消录音
function ChatLayer:voiceCancel()
	-- body
	if self.voicing then
		-- self.node.voice_progress:setPercentage(100)
		self.node.voice_time:setString(self.voice_max)
		self:clearScheduler()
		self.voicing = false
		self.node.voice_bg:hide()
		self.part:recordVoiceTouchUp()
	end

	self.record_cd = true  --cd中
	local time_entry = nil
	time_entry = self:schedulerFunc(function()
		-- body
		self.record_cd = false
		self:unScheduler(time_entry)
	end,ChatLayer.RECORD_CD_TIME,false)
end

function ChatLayer:VoiceTouch(node,touch,event)
	if self.record_cd == false then
		local time_entry = nil
		if not self.voicing and event == 0  then
			self.voicing = true
			self.node.voice_bg:show()
			local cur_time = self.voice_max
			time_entry = self:schedulerFunc(function()
				-- body
				cur_time =cur_time - 0.1
				if cur_time <= 0 then
					self:voiceCancel()
				else
					local percent = cur_time*100/self.voice_max
					self.node.voice_time:setString(math.floor(cur_time))
					-- self.node.voice_progress:setPercentage(percent)	
				end
			end,0.1,false)
			self.part:recordVoiceTouchDown()
		elseif event == 2 then --按钮下touchend事件
			self:voiceCancel()
		elseif event == 3 then --按钮外touchend事件
			self:voiceCancel()
		end
	end
end

--[[
创建一列语音数据
	--语音数据
	data = {
		isme = false
		img_url = ""
		voice_path = ""
		voice_lenth =  15
	}
--]]
function ChatLayer:voiceListAddCell(index,data)
	-- body
	if index > self.MAX_RECORD then
		self.removeItem(0)
		index = self.MAX_RECORD
		table.remove(self.voice_list,1)
	end

	table.insert(self.voice_list,data)

	self.node.voice_record_list:insertDefaultItem(index)
	local item = self.node.voice_record_list:getItem(index)
	local head_sprite = nil
	local voice_time = nil
	local voice_log = nil
	if data.isme then
		head_sprite =  item:getChildByName("head_sprite_right")
		voice_time = item:getChildByName("voice_time_right")
		voice_log = cc.Sprite:createWithSpriteFrameName(self.res_base .."/myVoicePic3.png")
		voice_log:setName("voice_log")
		voice_time:addChild(voice_log)
	else
		head_sprite = item:getChildByName("head_sprite_left")
		voice_time = item:getChildByName("voice_time_left")
		voice_log = cc.Sprite:createWithSpriteFrameName(self.res_base .."/otherVoicePic3.png")
		voice_log:setName("voice_log")
		voice_time:addChild(voice_log)
	end


	if voice_time then
		voice_time:show()
	else
		return
	end

	local voice_lenth_txt = voice_time:getChildByName("voice_lenth")

	if head_sprite then
		head_sprite:show()
		if data.img_url then
			local sprite =  cc.Sprite:create("common/resource/logo0.png")
			sprite:setName("head_sprite_net")
        	sprite:setAnchorPoint(cc.p(0, 0))
			self.part:loadImgToSprite(sprite,data.img_url)
			head_sprite:addChild(sprite)
		end
	else
		return
	end

	local content_size = voice_time:getContentSize()
	local voice_size = cc.size(content_size.width + data.voice_lenth*5,content_size.height)
	voice_time:setContentSize(voice_size)


	voice_lenth_txt:setString(data.voice_lenth .. "\"")
	if not data.isme then
		voice_log:setPosition(cc.p(25,content_size.height/2))
		voice_lenth_txt:setPositionX(voice_size.width + 16)
	else
		voice_log:setPosition(cc.p(voice_size.width-25,content_size.height/2))
	end

	self.node.voice_msg_log:show()

end

--返回键事件
function ChatLayer:backEvent()
	-- body
	self:hideSz()
end

function ChatLayer:hideIME()
	-- body
	self.node.input_feild:didNotSelectSelf()
end

function ChatLayer:MaskClick()
	-- body
	self:hideSz()
end

function ChatLayer:hideIME()
	self.node.input_feild:didNotSelectSelf()
end

function ChatLayer:setChatBtnStat(stat)
	self.node.chat_btn:setVisible(stat)
end

function ChatLayer:onEnter()
	self.part:onEnter()
end

function ChatLayer:onExit()
	self.part:onExit()
end

return ChatLayer
