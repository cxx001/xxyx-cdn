--[[
*名称:LobbyLayer
*描述:大厅界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local LobbyScene = class("LobbyScene",cc.load("mvc").ViewBase)
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
local CURRENT_MODULE_NAME = ...
function LobbyScene:onCreate(data) --传入数据
	-- body
	self.part:realodConfigFile()
	self:initWithFilePath("LobbyScene",CURRENT_MODULE_NAME,true)
	local scale = display.width/1280
	self.node.top_panel:setScale(scale)
	self.node.bottom_panel:setScale(scale)

	self.node.setting_list_bg:hide()
    
    local bgAni = Util.createSpineAnimationLoop(self.res_base .. "/spine/Datingbeijing","1",false)
    bgAni:setPosition(display.width*0.5,display.height*0.5)
    self.node.bg:addChild(bgAni)
    self.pressTime = 0



	local time_entry = nil
	local count = 0
    self:showCreateRoomAni(self.node.add_game_btn,true)
	time_entry = self:schedulerFunc(function()
		if count > 1 then
   			if time_entry ~= nil and time_entry ~= -1 then
   			self:unScheduler(time_entry)
   			end
		end

   		if count == 0 then
     		self:showAddRoomAni(self.node.xs_game_btn,true)
     	elseif count ==1 then
        	self:showMatchAni(self.node.create_game_btn,true)
   		end
   		count= count + 1 
	end,0.5,false)
    
    -- self:showAddRoomAni(self.node.xs_game_btn,true)
    -- self:showAddRoomAni(self.node.xs_game_btn,true)
    -- self:showMatchAni(self.node.create_game_btn,true)

   self:showCommonAni(true)



   -- local sprite = cc.Sprite:create(self.res_base.."/head_mask.png")
   -- local clipping_node = cc.ClippingNode:create(sprite)
   -- local sprit_size = sprite:getContentSize()
   -- local head_sprite = cc.Sprite:create("niuniu/room/resource/head_mask.png")
   -- clipping_node:addChild(head_sprite)
   -- clipping_node:setName("ClippingNode")
   -- clipping_node:setAlphaThreshold(0)
   -- clipping_node:setPosition(cc.p(sprit_size.width/2,sprit_size.height/2))
   -- head_node:addChild(clipping_node)

   -- local sprite = cc.Sprite:create(self.res_base.."/touxiang.png")
   -- local clipping_node = cc.ClippingNode:create(sprite)

   -- clipping_node:setName("ClippingNode")
   -- clipping_node:setAlphaThreshold(0)
   -- clipping_node:setPosition(cc.p(360,640))
   -- self.node.bg:addChild(clipping_node)
   -- local image = ccui.ImageView:create()
   -- image:ignoreContentAdaptWithSize(false)
   -- image:loadTexture(self.res_base.."/default_head.png",0)
   -- clipping_node:addChild(image)
   	if ISAPPSTORE then
		self.node.return_lobby:hide()
		self.node.coin_bg:hide()
		self.node.agent_btn:setVisible(false)
		self.node.create_game_btn:setVisible(false);
	end
end

function LobbyScene:showCreateRoomAni(node,visible)
	if visible then
		if self.crAni == nil then
		    self.crAni = Util.createSpineAnimationLoop(self.res_base .. "/spine/UI_1","red",false)
		    self.crAni:setPosition(node:getContentSize().width*0.5,node:getContentSize().height*0.5)
		    node:addChild(self.crAni)
		end
		self.crAni:show()
	else
		if self.crAni ~= nil then
	    	-- self.crAni:clearTracks()
	    	-- self.crAni:removeFromParent()
	    	-- self.crAni = nil
			self.crAni:hide()
	    end
	end
end

function LobbyScene:showAddRoomAni(node,visible)
	if visible then
		if self.arAni == nil then
		    self.arAni = Util.createSpineAnimationLoop(self.res_base .. "/spine/UI_1","yellow",false)
		    self.arAni:setPosition(node:getContentSize().width*0.5,node:getContentSize().height*0.5)
		    node:addChild(self.arAni)
		end
		self.arAni:show()
	else
		if self.arAni ~= nil then
	    	-- self.arAni:clearTracks()
	    	-- self.arAni:removeFromParent()
	    	-- self.arAni = nil
	    	self.arAni:hide()
	    end
	end
end

function LobbyScene:showMatchAni(node,visible)
	if visible then
		if self.matchAni == nil then
		    self.matchAni = Util.createSpineAnimationLoop(self.res_base .. "/spine/UI_1","green",false)
		    self.matchAni:setPosition(node:getContentSize().width*0.5,node:getContentSize().height*0.5)
		    node:addChild(self.matchAni)
		end
		self.matchAni:show()
	else
		if self.matchAni ~= nil then
	    	-- self.matchAni:clearTracks()
	    	-- self.matchAni:removeFromParent()
	    	-- self.matchAni = nil
	 	    self.matchAni:hide()
	    end
	end
end

function LobbyScene:updateUserInfo(info,gameInfo)
	-- body
	self.node.name:setString(info.name)
	self.node.id:setString(gameInfo.playerIndex)
	self.node.zuan_txt:setString(gameInfo.diamond)
	self.node.coin_txt:setString(gameInfo.gold)

	if SingleGame then
		self.node.return_lobby_btn:hide()
	end
end

function LobbyScene:getHeadNode()
	-- body
	return self.node.head_sprite
end

--公告4
function LobbyScene:NoticeClick(node,touch,eventType)
	-- body
	if eventType == ccui.TouchEventType.began then
    	self.isTouch = true	--按下
        self.NoticeScheduleID = self:schedulerFunc(function()
		-- bodyss
		if self.pressTime > 1 then
		    local spineAni = Util.createSpineAnimation(self.res_base .. "/spine/UIchangan_effect","4",false,ture)
		    spineAni:setPosition(self.node.ntf_btn:getContentSize().width*0.5,self.node.ntf_btn:getContentSize().height*0.5)
		    self.node.ntf_btn:addChild(spineAni)
            self:unScheduler(self.NoticeScheduleID)
			self.pressTime = 0
            return
		end
		if self.isTouch then
			self.pressTime = self.pressTime + 1
		else
			self:unScheduler(self.NoticeScheduleID)
			self.pressTime = 0
		end

	end,0.5,false)
    elseif eventType == ccui.TouchEventType.moved then
        print("按下按钮移动")
    elseif eventType == ccui.TouchEventType.ended then
    	self.isTouch = false
		global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
		self.part:noticeClick()
        print("放开按钮")
    elseif eventType == ccui.TouchEventType.canceled then
    	self.isTouch = false
        print("取消点击")
    end
end

--玩法
function LobbyScene:HelpClick(node,touch,eventType)
	-- body
	-- global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
	-- self.part:helpClick()

	if eventType == ccui.TouchEventType.began then
    	self.isTouch = true	--按下
        self.ShareScheduleID = self:schedulerFunc(function()
		-- bodyss
		if self.pressTime > 1 then
		    local spineAni = Util.createSpineAnimation(self.res_base .. "/spine/UIchangan_effect","13",false,ture)
		    spineAni:setPosition(self.node.help_btn:getContentSize().width*0.5,self.node.help_btn:getContentSize().height*0.5)
		    self.node.help_btn:addChild(spineAni)
            self:unScheduler(self.ShareScheduleID)
			self.pressTime = 0
            return
		end
		if self.isTouch then
			self.pressTime = self.pressTime + 1
		else
			self:unScheduler(self.ShareScheduleID)
			self.pressTime = 0
		end

		end,0.5,false)
    elseif eventType == ccui.TouchEventType.moved then
        print("按下按钮移动")
    elseif eventType == ccui.TouchEventType.ended then
    	self.isTouch = false
		global:getAudioModule():playSound("res/sound/Button32.mp3",false)
		self.part:helpClick()
        print("放开按钮")
    elseif eventType == ccui.TouchEventType.canceled then
    	self.isTouch = false
        print("取消点击")
    end 
end

--战绩12
function LobbyScene:RecordClick(node,touch,eventType)
	-- body
	-- global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
	-- self.part:recordClick()	
	if eventType == ccui.TouchEventType.began then
    	self.isTouch = true	--按下
        self.ShareScheduleID = self:schedulerFunc(function()
		-- bodyss
		if self.pressTime > 1 then
		    local spineAni = Util.createSpineAnimation(self.res_base .. "/spine/UIchangan_effect","12",false,ture)
		    spineAni:setPosition(self.node.record_btn:getContentSize().width*0.5,self.node.record_btn:getContentSize().height*0.5)
		    self.node.record_btn:addChild(spineAni)
            self:unScheduler(self.ShareScheduleID)
			self.pressTime = 0
            return
		end
		if self.isTouch then
			self.pressTime = self.pressTime + 1
		else
			self:unScheduler(self.ShareScheduleID)
			self.pressTime = 0
		end

		end,0.5,false)
    elseif eventType == ccui.TouchEventType.moved then
        print("按下按钮移动")
    elseif eventType == ccui.TouchEventType.ended then
    	self.isTouch = false
		global:getAudioModule():playSound("res/sound/Button32.mp3",false)
		self.part:recordClick()
        print("放开按钮")
    elseif eventType == ccui.TouchEventType.canceled then
    	self.isTouch = false
        print("取消点击")
    end 

end

--设置5
function LobbyScene:SettingsClick(node,touch,eventType)
	-- body
	if eventType == ccui.TouchEventType.began then
        	self.isTouch = true	--按下
            self.SettingScheduleID = self:schedulerFunc(function()
			-- bodyss
			if self.pressTime > 1 then
			    local spineAni = Util.createSpineAnimation(self.res_base .. "/spine/UIchangan_effect","5",false,ture)
			    spineAni:setPosition(self.node.settings_btn:getContentSize().width*0.5,self.node.settings_btn:getContentSize().height*0.5)
			    self.node.settings_btn:addChild(spineAni)
                self:unScheduler(self.SettingScheduleID)
				self.pressTime = 0
                return
			end
			if self.isTouch then
				self.pressTime = self.pressTime + 1
			else
				self:unScheduler(self.SettingScheduleID)
				self.pressTime = 0
			end

	end,0.5,false)
    elseif eventType == ccui.TouchEventType.moved then
        print("按下按钮移动")
    elseif eventType == ccui.TouchEventType.ended then
    	self.isTouch = false
		global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
		self.part:settingsClick()
        print("放开按钮")
    elseif eventType == ccui.TouchEventType.canceled then
    	self.isTouch = false
        print("取消点击")
    end
end

--分享3
function LobbyScene:ShareClick(node,touch,eventType)
	-- body
	if eventType == ccui.TouchEventType.began then
        	self.isTouch = true	--按下
            self.ShareScheduleID = self:schedulerFunc(function()
			-- bodyss
			if self.pressTime > 1 then
			    local spineAni = Util.createSpineAnimation(self.res_base .. "/spine/UIchangan_effect","3",false,ture)
			    spineAni:setPosition(self.node.share_btn:getContentSize().width*0.5,self.node.share_btn:getContentSize().height*0.5)
			    self.node.share_btn:addChild(spineAni)
                self:unScheduler(self.ShareScheduleID)
				self.pressTime = 0
                return
			end
			if self.isTouch then
				self.pressTime = self.pressTime + 1
			else
				self:unScheduler(self.ShareScheduleID)
				self.pressTime = 0
			end

	end,0.5,false)
    elseif eventType == ccui.TouchEventType.moved then
        print("按下按钮移动")
    elseif eventType == ccui.TouchEventType.ended then
    	self.isTouch = false
		global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
		self.part:shareClick()
        print("放开按钮")
    elseif eventType == ccui.TouchEventType.canceled then
    	self.isTouch = false
        print("取消点击")
    end

end

--活动1
function LobbyScene:ActivityClick(node,touch,eventType)
	-- body
	if eventType == ccui.TouchEventType.began then
        	self.isTouch = true	--按下
            self.ActivityScheduleID = self:schedulerFunc(function()
			-- bodyss
			if self.pressTime > 1 then
			    local spineAni = Util.createSpineAnimation(self.res_base .. "/spine/UIchangan_effect","1",false,ture)
			    spineAni:setPosition(self.node.activity_btn:getContentSize().width*0.5,self.node.activity_btn:getContentSize().height*0.5)
			    self.node.activity_btn:addChild(spineAni)
                self:unScheduler(self.ActivityScheduleID)
				self.pressTime = 0
                return
			end
			if self.isTouch then
				self.pressTime = self.pressTime + 1
			else
				self:unScheduler(self.ActivityScheduleID)
				self.pressTime = 0
			end

	end,0.5,false)
    elseif eventType == ccui.TouchEventType.moved then
        print("按下按钮移动")
    elseif eventType == ccui.TouchEventType.ended then
    	self.isTouch = false

        print("放开按钮")
    elseif eventType == ccui.TouchEventType.canceled then
    	self.isTouch = false
        print("取消点击")
    end

end

--代理7
function LobbyScene:onClickAgent(node,touch,eventType)
	-- body
	if eventType == ccui.TouchEventType.began then
        	self.isTouch = true	--按下
            self.AgentScheduleID = self:schedulerFunc(function()
			-- bodyss
			if self.pressTime > 1 then
			    local spineAni = Util.createSpineAnimation(self.res_base .. "/spine/UIchangan_effect","7",false,ture)
			    spineAni:setPosition(self.node.agent_btn:getContentSize().width*0.5,self.node.agent_btn:getContentSize().height*0.5)
			    self.node.agent_btn:addChild(spineAni)
                self:unScheduler(self.AgentScheduleID)
				self.pressTime = 0
                return
			end
			if self.isTouch then
				self.pressTime = self.pressTime + 1
			else
				self:unScheduler(self.AgentScheduleID)
				self.pressTime = 0
			end

	end,0.5,false)
    elseif eventType == ccui.TouchEventType.moved then
        print("按下按钮移动")
    elseif eventType == ccui.TouchEventType.ended then
    	self.isTouch = false
		global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
		self.part:agentClick()
        print("放开按钮")
    elseif eventType == ccui.TouchEventType.canceled then
    	self.isTouch = false
        print("取消点击")
    end

end

function LobbyScene:HeadClick()
	-- body
	-- global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
	-- self.part:headClick()
end

function LobbyScene:AddZuanClick()
	-- body
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
	self.part:addZuan()
end

function LobbyScene:AddCoinClick()
	--body
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3", false)
	self.part:addZuan()
end


--创建房间事件
function LobbyScene:CreateGameClick(node,touch,eventType)
	-- body
	if eventType == ccui.TouchEventType.began then
        	self.isTouch = true	--按下
            self:showCreateRoomAni(self.node.add_game_btn,false)
            self.CeateGameScheduleID = self:schedulerFunc(function()
			-- bodyss
			if self.pressTime > 1 then
			    local spineAni = Util.createSpineAnimation(self.res_base .. "/spine/UI_2","red",false,ture)
                spineAni:setScale(self.node.add_game_btn:getRendererNormal():getScale())
			    spineAni:setPosition(self.node.add_game_btn:getContentSize().width*0.5,self.node.add_game_btn:getContentSize().height*0.5)
			    self.node.add_game_btn:addChild(spineAni)
                --self:unScheduler(self.CeateGameScheduleID)
				self.pressTime = 0
                return
			end
			if self.isTouch then
				self.pressTime = self.pressTime + 1
			else
				self:unScheduler(self.CeateGameScheduleID)
				self.pressTime = 0
			end
	end,0.5,false)
    elseif eventType == ccui.TouchEventType.moved then
        print("按下按钮移动")
    elseif eventType == ccui.TouchEventType.ended then
    	self.isTouch = false
		global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
		self.part:createRoomClick()
        self:showCreateRoomAni(self.node.add_game_btn,true)
        print("放开按钮")
    elseif eventType == ccui.TouchEventType.canceled then
        if self.isTouch then
            self.isTouch = false
            self:showCreateRoomAni(self.node.add_game_btn,true)
        end

        print("取消点击")
    end
end

--加入房间事件
function LobbyScene:AddGameClick(node,touch,eventType)
	-- body
	if eventType == ccui.TouchEventType.began then
    	self.isTouch = true	--按下
        self:showAddRoomAni(self.node.xs_game_btn,false)
        self.AddGameScheduleID = self:schedulerFunc(function()
		-- bodyss
		if self.pressTime > 1 then
		    local spineAni = Util.createSpineAnimation(self.res_base .. "/spine/UI_2","yellow",false,ture)
            spineAni:setScale(self.node.xs_game_btn:getRendererNormal():getScale())
		    spineAni:setPosition(self.node.xs_game_btn:getContentSize().width*0.5,self.node.xs_game_btn:getContentSize().height*0.5)
		    self.node.xs_game_btn:addChild(spineAni)
            --self:unScheduler(self.AddGameScheduleID)
			self.pressTime = 0
            return
		end
		if self.isTouch then
			self.pressTime = self.pressTime + 1
		else
			self:unScheduler(self.AddGameScheduleID)
			self.pressTime = 0
		end

	end,0.5,false)
    elseif eventType == ccui.TouchEventType.moved then
        print("按下按钮移动")
    elseif eventType == ccui.TouchEventType.ended then
    	self.isTouch = false
		global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
		self.part:addRoomClick()
        self:showAddRoomAni(self.node.xs_game_btn,true)
        print("放开按钮")
    elseif eventType == ccui.TouchEventType.canceled then
        if self.isTouch then
            self.isTouch = false
            self:showAddRoomAni(self.node.xs_game_btn,true)
        end
        print("取消点击")
    end

end

function LobbyScene:FriendGameClick()
	-- body
    global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
	self.part:friendGameClick()
end

function LobbyScene:GJGameClick(node,touch,eventType)
	-- body
	if eventType == ccui.TouchEventType.began then
    	self.isTouch = true	--按下
        self:showMatchAni(self.node.create_game_btn,false)
        self.matchScheduleID = self:schedulerFunc(function()
		-- bodyss
		if self.pressTime > 1 then
		    local spineAni = Util.createSpineAnimation(self.res_base .. "/spine/UI_2","green",false,ture)
            spineAni:setScale(self.node.create_game_btn:getRendererNormal():getScale())
		    spineAni:setPosition(self.node.create_game_btn:getContentSize().width*0.5,self.node.create_game_btn:getContentSize().height*0.5)
		    self.node.create_game_btn:addChild(spineAni)
            --self:unScheduler(self.AddGameScheduleID)
			self.pressTime = 0
            return
		end
		if self.isTouch then
			self.pressTime = self.pressTime + 1
		else
			self:unScheduler(self.matchScheduleID)
			self.pressTime = 0
		end

	end,0.5,false)
    elseif eventType == ccui.TouchEventType.moved then
        print("按下按钮移动")
    elseif eventType == ccui.TouchEventType.ended then
    	self.isTouch = false
		global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
		self.part:matchClick()
        self:showMatchAni(self.node.create_game_btn,true)
        print("放开按钮")
    elseif eventType == ccui.TouchEventType.canceled then
        if self.isTouch then
            self.isTouch = false
            self:showMatchAni(self.node.create_game_btn,true)
        end
        print("取消点击")
    end
end

function LobbyScene:CoinsGameClick()
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
	self.part:creatNewPlayerGame()
end

function LobbyScene:HNGameClick()
	-- body
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
	self.part:addRoomClick()
end

function LobbyScene:ShopClick()
	-- body
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
	self.part:shopClick()
end

--返回合集大厅
function LobbyScene:ReturnLobby()
	-- body
	self.part:returnLobby()
end

function LobbyScene:backEvent()
	-- body
	self.part:backEvent()
end

function LobbyScene:AgentClick()
	-- body
	self.part:agentClick()
end

function LobbyScene:changeAgent()
	-- body
	local FileName1 = self.res_base .. '/agent3.png'
	local FileName2 = self.res_base .. '/agent4.png'
	self.node.agent_btn:loadTextureNormal(FileName1,0)
	self.node.agent_btn:loadTexturePressed(FileName2,0)
end

function LobbyScene:ResetGameTitle(gameId)
	--由资源固化设置，不再需要由代码动态设定
	-- local titleFileName = self.res_base .. '/logo_' .. gameId .. '.png'
	-- self.node.game_name:loadTexture(titleFileName,1)
end

function LobbyScene:showCommonAni(visible)
	if visible then
		if self.diamAni == nil then
		    self.diamAni = Util.createSpineAnimationLoop(self.res_base .. "/spine/Diamond_effect","1",false)
		    self.diamAni:setPosition(self.node.zuan_icon:getContentSize().width*0.5,self.node.zuan_icon:getContentSize().height*0.5)
		    self.node.zuan_icon:addChild(self.diamAni)
		end
		if self.coinAni == nil then
		    self.coinAni = Util.createSpineAnimationLoop(self.res_base .. "/spine/Gold_effect","1",false)
		    self.coinAni:setPosition(self.node.coin_icon:getContentSize().width*0.5,self.node.coin_icon:getContentSize().height*0.5)
		    self.node.coin_icon:addChild(self.coinAni)
		end
	else
		if self.diamAni ~= nil then
			self.diamAni:clearTracks()
	    	self.diamAni:removeFromParent()
	    	self.diamAni =nil
	    end
	    if self.coinAni ~= nil then
	    	self.coinAni:clearTracks()
	    	self.coinAni:removeFromParent()
	    	self.coinAni = nil
	    end
	end
end

--是否显示红包按钮
function LobbyScene:showRedPacket(visible,flag)
	self.node.Button_redpack:setVisible(visible)

	self:showRedPacketAni(visible,flag)

end

--是否显示引导按钮
function LobbyScene:showGuide(visible)
	self.node.Button_guide:setVisible(visible)
	if not visible then
		self:showGuideAni(visible)
	end
end

--反馈按钮事件
function LobbyScene:FeedBackClick(node,touch,eventType)
        if eventType == ccui.TouchEventType.began then
        	self.isTouch = true	--按下
            self.feedScheduleID = self:schedulerFunc(function()
			-- bodyss
			if self.pressTime > 1 then
			    local spineAni = Util.createSpineAnimation(self.res_base .. "/spine/UIchangan_effect","6",false,ture)
			    spineAni:setPosition(self.node.feedback_btn:getContentSize().width*0.5,self.node.feedback_btn:getContentSize().height*0.5)
			    self.node.feedback_btn:addChild(spineAni)
                self:unScheduler(self.feedScheduleID)
				self.pressTime = 0
                return
			end
			if self.isTouch then
				self.pressTime = self.pressTime + 1
			else
				self:unScheduler(self.feedScheduleID)
				self.pressTime = 0
			end

	end,0.5,false)
        elseif eventType == ccui.TouchEventType.moved then
            print("按下按钮移动")
        elseif eventType == ccui.TouchEventType.ended then
        	self.isTouch = false
        	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
            print("放开按钮")
            self.part:activeFankuiPart()
        elseif eventType == ccui.TouchEventType.canceled then
        	self.isTouch = false
            print("取消点击")
        end
end 

function LobbyScene:showRedPacketAni(visible,flag)
	local aniName = "1"
	if flag then
		aniName = "2"
	end
	if visible then
		if self.redAni == nil then
		    self.redAni = Util.createSpineAnimationLoop(self.res_base .. "/spine/hongbaoicon",aniName,false)
		    self.redAni:setPosition(self.node.Button_redpack:getContentSize().width*0.5,self.node.Button_redpack:getContentSize().height*0.5)
		    self.node.Button_redpack:addChild(self.redAni)
		else
			self.redAni:setAnimation(0,aniName,true)
		end
	else
		if self.redAni ~= nil then
	    	self.redAni:clearTracks()
	    	self.redAni:removeFromParent()
	    	self.redAni = nil
	    end
	end
end
--红包管理界面
function LobbyScene:ClickRedPacketEvent()
	-- body
	self.part:ClickRedPacketEvent()
end
function LobbyScene:showGuideAni(visible)
	if visible then
		if self.guideAni == nil then
		    self.guideAni = Util.createSpineAnimationLoop(self.res_base .. "/spine/Yindao","1",false)
		    self.guideAni:setPosition(self.node.Button_guide:getContentSize().width*0.5,self.node.Button_guide:getContentSize().height*0.5)
		    self.node.Button_guide:addChild(self.guideAni)
		end
	else
		if self.guideAni ~= nil then
	    	self.guideAni:clearTracks()
	    	self.guideAni:removeFromParent()
	    	self.guideAni = nil
	    end
	end
end

function LobbyScene:onEnter()
    self.part:onEnter()
    self.part:onQueryRedPacketReqMsg()
end

function LobbyScene:onExit()
    self.part:onExit()
end


return LobbyScene

