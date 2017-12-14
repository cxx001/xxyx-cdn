local SettingsLayer = class("SettingsLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
function SettingsLayer:onCreate(data) --传入数据
	-- body
	self:addMask()
	self:initWithFilePath("SettingsLayer",CURRENT_MODULE_NAME)
	local user_info = global:getGameUser():getProps()
	-- user_info.photo = "http://wx.qlogo.cn/mmopen/JBQEPjTjtXTO1vUiaIyxmSuZOS3p0PgQ7dX6YSKdKw0Cd5vcUZazUbBkZw2XbG3BoQVfKdgjicxrUPwZQMq3bgZZ4GtFM1kJg6/0"
	self.node.head_sprite:show()
 --    local photoScale = 195 / self.node.head_sprite:getContentSize().width
 --    self.node.head_sprite:setScale(photoScale)
 --    self.node.head_sprite:setPosition(self.node.Image_17:getContentSize().width*0.5,self.node.Image_17:getContentSize().height*0.5)
 		-- Util.loadHeadImg(user_info.photo,self.node.head_sprite)

   	local orgNodeWidth=self.node.head_sprite:getTextureRect().width
    local orgNnodeHeight= self.node.head_sprite:getTextureRect().height
	local orgScaleX = self.node.head_sprite:getScaleX()
 	local orgScaleY = self.node.head_sprite:getScaleY()
 	if user_info.photo	and user_info.photo ~= "" then
 		Util.loadHeadImg(user_info.photo,self.node.head_sprite)
 	end
	local  head_nodeWidth=self.node.head_sprite:getTextureRect().width
	local  head_nodeHeight= self.node.head_sprite:getTextureRect().height
  	self.node.head_sprite:setScaleX(orgNodeWidth * orgScaleX/head_nodeWidth)
	self.node.head_sprite:setScaleY(orgNnodeHeight * orgScaleY/head_nodeHeight)

    local scale = display.width/1280
	self.node.bg:setScale(scale)

	self.node.slider_sound:addEventListener(handler(self,SettingsLayer.soundSliderEvent))
	self.node.slider_music:addEventListener(handler(self,SettingsLayer.musicSliderEvent))

	if self.part:isDuihuanEnable() then
		self.node.duihuan_btn:show()
	end
end

function SettingsLayer:musicSliderEvent(ref,event)
	-- body
	local percent = self.node.slider_music:getPercent()
	local cur_music = percent/100
	self.part:musicEvent(cur_music)
end

function SettingsLayer:soundSliderEvent(ref,event)
	-- body
	local percent = self.node.slider_sound:getPercent()
	local cur_sound = percent/100
	self.part:soundEvent(cur_sound)
end

function SettingsLayer:ChangeAccountClick()
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/confirm.mp3",false)
	self.part:changAccount()
end

function SettingsLayer:FuWuClick()
	self.part:linkFuWu()
end

function SettingsLayer:YinSiClick()
	self.part:linkYinSi()
end

function SettingsLayer:MusicEvent()
	print("this is MusicEvent------------------------:")
	self.part:changeMusicState()
end

function SettingsLayer:SoundEvent()
	print("this is SoundEvent------------------------:")
	self.part:changeSoundState()
end

function SettingsLayer:setSoundState(on)
	-- body
	if on then
		self.node.sound_check:loadTexture(self.res_base .. "/sz_ON.png",1)
	else
		self.node.sound_check:loadTexture(self.res_base .. "/sz_OFF.png",1)
	end
end

function SettingsLayer:setMusicState(on)
	-- body
	if on then
		self.node.music_check:loadTexture(self.res_base .. "/sz_ON.png",1)
	else
		self.node.music_check:loadTexture(self.res_base .. "/sz_OFF.png",1)
	end

end

function SettingsLayer:set3DState(on)
	if on then
		self.node.td_check:loadTexture(self.res_base .. "/sz_ON.png",1)
	else
		self.node.td_check:loadTexture(self.res_base .. "/sz_OFF.png",1)
	end
end

function SettingsLayer:CloseClick()
	-- body
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
	self.part:deactivate()
end

function SettingsLayer:UploadLogClick()
	self.part:UploadLogClick()
end

function SettingsLayer:DialectEvent()
	print("this is DialectEvent------------------------:")
	self.part:changeDialect()
end

function SettingsLayer:setDialectState(on)
	if not self.node.dialect_check then return end
	if on then
		self.node.dialect_check:loadTexture(self.res_base .. "/sz_ON.png",1)
	else
		self.node.dialect_check:loadTexture(self.res_base .. "/sz_OFF.png",1)
	end
end

function SettingsLayer:on3DEvent()
	print("this is on3DEvent------------------------:")
	self.part:change3DState()
end


function SettingsLayer:setSwitch3DEnable(enable)
	if self.node.Text_3d then
		self.node.Text_3d:setVisible(enable)
	end

	if self.node.td_check then
		self.node.td_check:setVisible(enable)
	end
end

function SettingsLayer:onDuihuanClick()
	self.part:onDuihuanClick()
end

return SettingsLayer
