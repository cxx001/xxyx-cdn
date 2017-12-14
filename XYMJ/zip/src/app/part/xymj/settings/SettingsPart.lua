--[[
*名称:SettingsLayer
*描述:系统设置界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local SettingsPart = class("SettingsPart",cc.load('mvc').PartBase) --登录模块
SettingsPart.DEFAULT_VIEW = "SettingsLayer"

--[
-- @brief 构造函数
--]
function SettingsPart:ctor(owner)
    SettingsPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function SettingsPart:initialize()
  self.callback = nil
end

function SettingsPart:setCallback(callback)
  self.callback= callback
end

--激活模块
function SettingsPart:activate(data)
	SettingsPart.super.activate(self,CURRENT_MODULE_NAME)
  local audio_manager = global:getModuleWithId(ModuleDef.AUDIO_MOD)
  self.sound_value = false
  self.music_value = false
  if audio_manager:getVolume() > 0 then
    self.sound_value = true
  end 

  if audio_manager:getMusic() > 0 then
    self.music_value = true
  end
  self.view:setSoundState(self.sound_value)
  self.view:setMusicState(self.music_value)

  self.use3d = cc.UserDefault:getInstance():getBoolForKey(self:get3DKey(), true)
  self.view:set3DState(self.use3d)

  self.dialect = cc.UserDefault:getInstance():getBoolForKey(self:getDialectKey(), false)
  self.view:setDialectState(self.dialect)
end

function SettingsPart:deactivate()
	self.view:removeSelf()
  self.view =  nil
end

function SettingsPart:getPartId()
	-- body
	return "SettingsPart"
end

function SettingsPart:changAccount()
  -- body
  local tips_part = global:createPart("TipsPart",self)--require('app.part.tips.TipsPart').new(self)
  if tips_part then
    tips_part:activate({info_txt=string_table.change_account,left_click=function()
      -- body
        cc.UserDefault:getInstance():setStringForKey(enUserData.ASSETS_TOKEN,"")
        local login_part = global:activatePart("LoginPart")
        login_part:showLogin()
    end})
  end
end

function SettingsPart:linkYinSi()
  -- body
  cc.Application:getInstance():openURL("http://www.highlightsky.com/mj/service_terms_and_privacy_policy.html")
end

function SettingsPart:linkFuWu()
  -- body
  cc.Application:getInstance():openURL("http://www.highlightsky.com/mj/service_terms_and_privacy_policy.html")
end

function SettingsPart:changeMusicState()
  -- body
    self.music_value = not self.music_value
    local audio_manager = global:getModuleWithId(ModuleDef.AUDIO_MOD)
    if self.music_value  then
      audio_manager:setMusic(1)
    else
      audio_manager:setMusic(0)
    end
    audio_manager:saveVolume()
    self.view:setMusicState(self.music_value)
end

function SettingsPart:changeSoundState()
  -- body
  self.sound_value = not self.sound_value
  local audio_manager = global:getModuleWithId(ModuleDef.AUDIO_MOD)
  if self.sound_value  then
     audio_manager:setVolume(1)
  else
     audio_manager:setVolume(0)
  end
  audio_manager:saveVolume()
   self.view:setSoundState(self.sound_value)
end

function SettingsPart:changeDialect()
  self.dialect = not self.dialect 
  cc.UserDefault:getInstance():setBoolForKey(self:getDialectKey(), self.dialect)
  cc.UserDefault:getInstance():flush()
  self.view:setDialectState(self.dialect)
  if self.callback then self.callback() end
end

function SettingsPart:getDialectKey()
  return "Dialect"
end

function SettingsPart:change3DState()
  self.use3d = not self.use3d
  cc.UserDefault:getInstance():setBoolForKey(self:get3DKey(), self.use3d)
  cc.UserDefault:getInstance():flush()
  self.view:set3DState(self.use3d)
end

function SettingsPart:UploadLogClick()
    if self.owner then
      if self.owner.removeSettingsPart then
        self.owner:removeSettingsPart()
      end
      if self.owner.activeFankuiPart then
        self.owner:activeFankuiPart()
      end
    end
end

function SettingsPart:musicEvent(cur_music)
    local audio_manager = global:getModuleWithId(ModuleDef.AUDIO_MOD)
    audio_manager:setMusic(cur_music)
end

function SettingsPart:soundEvent(cur_sound)
    local audio_manager = global:getModuleWithId(ModuleDef.AUDIO_MOD)
    audio_manager:setVolume(cur_sound)
end

function SettingsPart:get3DKey()
    local key = "key_use3d"
    return key
end

function SettingsPart:setSwitch3DEnable(enable)
    --self.view:setSwitch3DEnable(enable)
    self.view:setSwitch3DEnable(false)
end

function SettingsPart:isDuihuanEnable()
    local ret = false
    if self.owner and self.owner.onDuihuanClick then
        ret = true
    end
    return ret
end

function SettingsPart:onDuihuanClick()
    if self.owner and self.owner.onDuihuanClick then
      self.owner:onDuihuanClick()
    end
    self:deactivate()
end

return SettingsPart 