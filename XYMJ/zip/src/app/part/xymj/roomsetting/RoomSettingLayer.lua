--[[
*名称:RoomSettingLayer
*描述:房间设置界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local RoomSettingLayer = class("RoomSettingLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
function RoomSettingLayer:onCreate(data) --传入数据
	-- body
    print("----RoomSettingLayer:onCreate")
    self:addMask()
	self:initWithFilePath("RoomSettingLayer",CURRENT_MODULE_NAME)

	--self:init("RoomSettingLayer")
	self.node.music_slider:addEventListener(handler(self,RoomSettingLayer.musicEvent))
	self.node.sound_slider:addEventListener(handler(self,RoomSettingLayer.soundEvent))
end

function RoomSettingLayer:musicEvent(ref,event)
	-- body
	local percent = self.node.music_slider:getPercent()
	local cur_music = percent/100
	self.part:musicEvent(cur_music)
end

function RoomSettingLayer:soundEvent(ref,event)
	-- body
	local percent = self.node.sound_slider:getPercent()
	local cur_sound = percent/100
	self.part:soundEvent(cur_sound)
end

function RoomSettingLayer:setSlider(cur_sound,cur_music)
	if cur_sound == nil then
		cur_sound = 1 
	end

	if cur_music == nil then
		cur_music = 1 
	end
		self.node.music_slider:setPercent(cur_music * 100)
		self.node.sound_slider:setPercent(cur_sound * 100)
end

function RoomSettingLayer:MusicEvent()
	self.part:changeMusicState()
end

function RoomSettingLayer:SoundEvent()
	self.part:changeSoundState()
end

function RoomSettingLayer:setSoundState(on)
	-- body
	if on then
		self.node.sound_check:loadTexture(self.res_base .. "/sz_ON.png",1)
	else
		self.node.sound_check:loadTexture(self.res_base .. "/sz_OFF.png",1)
	end
end

function RoomSettingLayer:setMusicState(on)
	-- body
	if on then
		self.node.music_check:loadTexture(self.res_base .. "/sz_ON.png",1)
	else
		self.node.music_check:loadTexture(self.res_base .. "/sz_OFF.png",1)
	end

end

function RoomSettingLayer:CloseClick()
	-- body
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self.part:deactivate()
end

function RoomSettingLayer:CloseVipRoomClick()
	-- body
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	if self.flag > 1 then
		self.part:closeVipRoomClick()
	else
		self.part:exitClick()
	end
end

function RoomSettingLayer:isShowCloseBtn(data)
	-- body
	self.flag = data
	local FileName1 = self.res_base .. '/closeviproom1.png'
	local FileName2 = self.res_base .. '/closeviproom2.png'
	if self.flag > 1 then 
		
	else
		FileName1 = self.res_base .. '/exitroom1.png'
		FileName2 = self.res_base .. '/exitroom2.png'
	end
	print("------------",FileName1,FileName2)
	self.node.close_vip_btn:loadTextureNormal(FileName1,1)
	self.node.close_vip_btn:loadTexturePressed(FileName2,1)
end

return RoomSettingLayer
