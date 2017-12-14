--[[
*名称:TeamVoiceLayer
*描述:队伍语音界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local TeamVoiceLayer = class("TeamVoiceLayer",cc.load("mvc").ViewBase)
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
local CURRENT_MODULE_NAME = ...

function TeamVoiceLayer:onCreate()
	-- body
	self:initWithFilePath("TeamVoiceLayer",CURRENT_MODULE_NAME)

    self.bSpeaker = false
    self.bMic = false;
    self.originPos = cc.p(self.node.mic_btn:getPosition())
    for i = 1,4 do
        self.node["FileNode_player" .. i]:hide()
    end
end

function TeamVoiceLayer:hideVoice()
    --body
    self.node.speaker_btn:hide()
    self.node.mic_btn:hide()
end

function TeamVoiceLayer:showVoice()
    --body
    self.node.speaker_btn:show()
    self.node.mic_btn:show()
end

--------------------------------------语音相关------------------------------------------------

function TeamVoiceLayer:onTouchSpeaker(node,touch,event)
    if event == 0 then --按下
		if self.bSpeaker then
		    self.node.speaker_btn:loadTexturePressed(self.res_base .. "/speaker_click.png",1)
		else
		    self.node.speaker_btn:loadTexturePressed(self.res_base .. "/speaker_silent_click.png",1)
		end
    elseif event == 2 then --按钮下touchend事件
		if not self.bSpeaker then
		    self:openVoiceSpeaker()--加入语音房间
		else
		    self:closeVoiceSpeaker()--加入语音房间
		end
    elseif event == 3 then --按钮外touchend事件
		if self.bSpeaker then
		    self.node.speaker_btn:loadTextureNormal(self.res_base .. "/speaker.png",1)
		else
		    self.node.speaker_btn:loadTextureNormal(self.res_base .. "/speaker_silent.png",1)
		end
    end

end

function TeamVoiceLayer:onTouchMic(node,touch,event)
    if event == 0 then --按下
		if self.bMic then
		    self.node.mic_btn:loadTexturePressed(self.res_base .. "/aj_yy_light.png",1)
		else
		    self.node.mic_btn:loadTexturePressed(self.res_base .. "/forbid_aj_yy_light.png",1)
		end
    elseif event == 2 then --按钮下touchend事件
		if not self.bMic then
		    self:openVoiceMic()--加入语音房间
		else
		    self:closeVoiceMic()--加入语音房间
		end
    elseif event == 3 then --按钮外touchend事件
		if self.bMic then
		    self.node.mic_btn:loadTextureNormal(self.res_base .. "/aj_yy.png",1)
		else
		    self.node.mic_btn:loadTextureNormal(self.res_base .. "/forbid_aj_yy.png",1)
		end
    end
end

function TeamVoiceLayer:openVoiceMic()
    local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
    local code = nil

    code = lua_bridge:openMic()--加入语音房间
    
    if code == 0 then
	    self.bMic = true
	    self.node.mic_btn:loadTextureNormal(self.res_base .. "/aj_yy.png",1)
        local micState = cc.UserDefault:getInstance():setBoolForKey("micphone",true)
	    if not self.bSpeaker then --打开扬声器，如果麦克风打开则麦克风一起打开
		    self:openVoiceSpeaker();
		   	if not self.bTips then
		    	self.node.Text_tips:setVisible(true);
		    end
		   	self.bTips = true;
		    	
	    	local seq = cc.Sequence:create(cc.DelayTime:create(1.0),cc.CallFunc:create(function()
	    			self.node.Text_tips:setVisible(false);
	    			self.bTips = false;
	    		end))
	    	self.node.Text_tips:runAction(seq);
	    end
	    local audio_manager = global:getModuleWithId(ModuleDef.AUDIO_MOD)
	    
	    
	    if not audio_manager:getSoundState() then
	    	audio_manager:setRatio(0.1)
	    	audio_manager:setSoundState(true)
	    	audio_manager:setVolume(audio_manager:getVolume() * audio_manager:getRatio())
	    end

	    if not audio_manager:getMusicState() then
	    	audio_manager:setMusciRatio(0.1)
	    	audio_manager:setMusicState(true)
	    	audio_manager:setMusic(audio_manager:getMusic() * audio_manager:getMusciRatio())
	    end

    elseif code == 8193 then
        --没有加入房间就打开语音
        self.part:openMicFailed()
    end
end

function TeamVoiceLayer:closeVoiceMic()
    local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
    local code = nil
     
    code = lua_bridge:closeMic()--加入语音房间
    if code == 0 then
	    self.bMic = false
	    self.node.mic_btn:loadTextureNormal(self.res_base .. "/forbid_aj_yy.png",1)
        local micState = cc.UserDefault:getInstance():setBoolForKey("micphone",false)
	    local audio_manager = global:getModuleWithId(ModuleDef.AUDIO_MOD)
	    
	    if not self.bSpeaker and not self.bMic then
		    if audio_manager:getSoundState() then
		    	audio_manager:setVolume(audio_manager:getVolume() / audio_manager:getRatio())
		    	audio_manager:setRatio(1)
		    	audio_manager:setSoundState(false)
		    end

		    if audio_manager:getMusicState() then
			    audio_manager:setMusic(audio_manager:getMusic() / audio_manager:getMusciRatio())
		    	audio_manager:setMusciRatio(1)
		    	audio_manager:setMusicState(false)
		    end
		end
    end
end

function TeamVoiceLayer:openVoiceSpeaker()
    local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
    local code = nil

    code = lua_bridge:openSpeaker()--加入语音房间
    if code == 0 then
	    self.bSpeaker = true
    	self.node.speaker_btn:loadTextureNormal(self.res_base .. "/speaker.png",1)
    	local audio_manager = global:getModuleWithId(ModuleDef.AUDIO_MOD)
	    if not audio_manager:getSoundState() then
	    	audio_manager:setRatio(0.1)
	    	audio_manager:setSoundState(true)
	    	audio_manager:setVolume(audio_manager:getVolume() * audio_manager:getRatio())
	    end

	    if not audio_manager:getMusicState() then
	    	audio_manager:setMusciRatio(0.1)
	    	audio_manager:setMusicState(true)
	    	audio_manager:setMusic(audio_manager:getMusic() * audio_manager:getMusciRatio())
	    end
        cc.UserDefault:getInstance():setBoolForKey("speaker",true)
    elseif code == 8193 then
        --没有加入房间就打开语音
        self.part:openSpeakerFailed()
    end
end

function TeamVoiceLayer:closeVoiceSpeaker()
    local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
    local code = nil

    code = lua_bridge:closeSpeaker()--加入语音房间
    if code == 0 then
	    self.bSpeaker = false
	    self.node.speaker_btn:loadTextureNormal(self.res_base .. "/speaker_silent.png",1)
        cc.UserDefault:getInstance():setBoolForKey("speaker",false)
	    if self.bMic then --关闭扬声器，如果麦克风打开则麦克风一起关掉
		    --self.node.mic_checkbox:setSelected(false);
		    if not self.bTips then
		    	self.node.Text_tips:setVisible(true);
		    end
		   	self.bTips = true;
		    	
	    	local seq = cc.Sequence:create(cc.DelayTime:create(1.0),cc.CallFunc:create(function()
	    			self.node.Text_tips:setVisible(false);
	    			self.bTips = false;
	    		end))
	    	self.node.Text_tips:runAction(seq);
		    self:closeVoiceMic();
	    end
	    if not self.bSpeaker and not self.bMic then
	    	local audio_manager = global:getModuleWithId(ModuleDef.AUDIO_MOD)
		    if audio_manager:getSoundState() then
		    	audio_manager:setVolume(audio_manager:getVolume() / audio_manager:getRatio())
		    	audio_manager:setRatio(1)
		    	audio_manager:setSoundState(false)
		    end

		    if audio_manager:getMusicState() then
			    audio_manager:setMusic(audio_manager:getMusic() / audio_manager:getMusciRatio())
		    	audio_manager:setMusciRatio(1)
		    	audio_manager:setMusicState(false)
		    end
		end
    end
end

--进入界面
function TeamVoiceLayer:onEnter()
	self.part:onEnter()
end

--离开界面
function TeamVoiceLayer:onExit()
	self.part:onExit()
end

--micphone按钮准备界面时位置
function TeamVoiceLayer:setReadyPos()
    self.node.mic_btn:setPositionY(self.node.speaker_btn:getPositionY())
end

--micphone按钮原位置
function TeamVoiceLayer:setOriginPos()
    self.node.mic_btn:setPosition(self.originPos.x,self.originPos.y)
end

function TeamVoiceLayer:memberChangeStatus(seatID,status)
    if status == 0 then
        --停止说话
        self.node['FileNode_player'.. seatID]:hide()
        self.node['FileNode_player'.. seatID].animation:gotoFrameAndPause(0)
    elseif status == 1 then
        --开始说话
        self.node['FileNode_player'.. seatID]:show()
    elseif status == 2 then
        --继续说话
        self.node['FileNode_player'.. seatID]:show()
        if not self.node['FileNode_player'.. seatID].animation:isPlaying() then
            self.node['FileNode_player'.. seatID].animation:gotoFrameAndPlay(0, 60, true)
        end
    end

end
return TeamVoiceLayer
