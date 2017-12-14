--[[
*名称:RoomSettingLayer
*描述:房间设置界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local RoomSettingPart = class("RoomSettingPart",cc.load('mvc').PartBase) --登录模块
RoomSettingPart.DEFAULT_PART = {}
RoomSettingPart.DEFAULT_VIEW = "RoomSettingLayer"

--[
-- @brief 构造函数
--]
function RoomSettingPart:ctor(owner)
    RoomSettingPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function RoomSettingPart:initialize()

end

--激活模块
function RoomSettingPart:activate(data)
  print("111111111")
    RoomSettingPart.super.activate(self,CURRENT_MODULE_NAME)
    local audio_manager = global:getModuleWithId(ModuleDef.AUDIO_MOD)
    self.sound_value = false
    self.music_value = false
    self.cur_sound = audio_manager:getVolume()
    self.cur_music = audio_manager:getMusic()
    if self.cur_sound > 0 then
      self.sound_value = true
    end
    
    if self.cur_music > 0 then
      self.music_value = true
    end
    print("111111111")
    self.view:setSoundState(self.sound_value)
    self.view:setMusicState(self.music_value)
    self.view:setSlider(self.cur_sound,self.cur_music)

    self.view:isShowCloseBtn(data)
end

function RoomSettingPart:deactivate()
    if self.view then
     self.view:removeSelf()
     self.view =  nil
    end
    local audio_manager = global:getModuleWithId(ModuleDef.AUDIO_MOD)
    audio_manager:saveVolume()
end

function RoomSettingPart:changeMusicState()
  -- body
    self.music_value = not self.music_value
    local audio_manager = global:getModuleWithId(ModuleDef.AUDIO_MOD)
    if self.music_value  then
      audio_manager:setMusic(1)
      self.view:setMusicState(true)
    else
      audio_manager:setMusic(0)
      self.view:setMusicState(false)
    end
    audio_manager:saveVolume()
end

function RoomSettingPart:changeSoundState()
  -- body
   self.sound_value = not self.sound_value
   local audio_manager = global:getModuleWithId(ModuleDef.AUDIO_MOD)
    if self.sound_value  then
       audio_manager:setVolume(1)
       self.view:setSoundState(true)
    else
       audio_manager:setVolume(0)
       self.view:setSoundState(false)
    end
    audio_manager:saveVolume()
end

function RoomSettingPart:closeVipRoomClick()
    -- body
    self.view:CloseClick()
    self.owner:closeVipRoom()
end

function RoomSettingPart:exitClick()
    -- body
    self.view:CloseClick()
    self.owner:exitClick()
end

function RoomSettingPart:musicEvent(cur_music)
    local audio_manager = global:getModuleWithId(ModuleDef.AUDIO_MOD)
    audio_manager:setMusic(cur_music)
end

function RoomSettingPart:soundEvent(cur_sound)
    local audio_manager = global:getModuleWithId(ModuleDef.AUDIO_MOD)
    audio_manager:setVolume(cur_sound)
end

function RoomSettingPart:getPartId()
  -- body
  return "RoomSettingPart"
end

return RoomSettingPart 
