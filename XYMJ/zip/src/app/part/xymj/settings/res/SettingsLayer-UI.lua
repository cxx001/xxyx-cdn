--------------------------------------------------------------
-- This file was automatically generated by Cocos Studio.
-- Do not make changes to this file.
-- All changes will be lost.
--------------------------------------------------------------

local luaExtend = require "LuaExtend"

-- using for layout to decrease count of local variables
local layout = nil
local localLuaFile = nil
local innerCSD = nil
local innerProject = nil
local localFrame = nil

local Result = {}
------------------------------------------------------------
-- function call description
-- create function caller should provide a function to 
-- get a callback function in creating scene process.
-- the returned callback function will be registered to 
-- the callback event of the control.
-- the function provider is as below :
-- Callback callBackProvider(luaFileName, node, callbackName)
-- parameter description:
-- luaFileName  : a string, lua file name
-- node         : a Node, event source
-- callbackName : a string, callback function name
-- the return value is a callback function
------------------------------------------------------------
function Result.create(callBackProvider)

local result={}
setmetatable(result, luaExtend)

--Create Layer
local Layer=cc.Node:create()
Layer:setName("Layer")
layout = ccui.LayoutComponent:bindLayoutComponent(Layer)
layout:setSize({width = 1280.0000, height = 720.0000})

--Create touch_mask
local touch_mask = ccui.Button:create()
touch_mask:ignoreContentAdaptWithSize(false)
touch_mask:loadTextureDisabled("Default/Button_Disable.png",0)
touch_mask:setTitleFontSize(14)
touch_mask:setTitleColor({r = 65, g = 65, b = 70})
touch_mask:setScale9Enabled(true)
touch_mask:setCapInsets({x = -15, y = -4, width = 30, height = 8})
touch_mask:setLayoutComponentEnabled(true)
touch_mask:setName("touch_mask")
touch_mask:setTag(47)
touch_mask:setCascadeColorEnabled(true)
touch_mask:setCascadeOpacityEnabled(true)
touch_mask:setPosition(640.0000, 360.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(touch_mask)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setHorizontalEdge(3)
layout:setVerticalEdge(3)
layout:setLeftMargin(640.0000)
layout:setRightMargin(640.0000)
layout:setTopMargin(360.0000)
layout:setBottomMargin(360.0000)
Layer:addChild(touch_mask)

--Create bg
local bg = ccui.ImageView:create()
bg:ignoreContentAdaptWithSize(false)
bg:loadTexture("app/part/xymj/settings/res/backg.png",0)
bg:setLayoutComponentEnabled(true)
bg:setName("bg")
bg:setTag(81)
bg:setCascadeColorEnabled(true)
bg:setCascadeOpacityEnabled(true)
bg:setPosition(640.0000, 343.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(bg)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.4764)
layout:setPercentWidth(0.8328)
layout:setPercentHeight(0.8694)
layout:setSize({width = 1066.0000, height = 626.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(1)
layout:setLeftMargin(107.0000)
layout:setRightMargin(107.0000)
layout:setTopMargin(64.0000)
layout:setBottomMargin(30.0000)
Layer:addChild(bg)

--Create fg
local fg = ccui.ImageView:create()
fg:ignoreContentAdaptWithSize(false)
fg:loadTexture("app/part/xymj/settings/res/xiaobei.png",0)
fg:setLayoutComponentEnabled(true)
fg:setName("fg")
fg:setTag(70)
fg:setCascadeColorEnabled(true)
fg:setCascadeOpacityEnabled(true)
fg:setPosition(533.0000, 313.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(fg)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.9775)
layout:setPercentHeight(0.9617)
layout:setSize({width = 1042.0000, height = 602.0000})
layout:setLeftMargin(12.0000)
layout:setRightMargin(12.0000)
layout:setTopMargin(12.0000)
layout:setBottomMargin(12.0000)
bg:addChild(fg)

--Create close_btn
local close_btn = ccui.Button:create()
close_btn:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/settings/res/settings_picture.plist")
close_btn:loadTextureNormal("app/part/xymj/settings/res/btn_close.png",1)
close_btn:loadTextureDisabled("Default/Button_Disable.png",0)
close_btn:setTitleFontSize(14)
close_btn:setTitleColor({r = 65, g = 65, b = 70})
close_btn:setScale9Enabled(true)
close_btn:setCapInsets({x = 15, y = 11, width = 52, height = 60})
close_btn:setLayoutComponentEnabled(true)
close_btn:setName("close_btn")
close_btn:setTag(82)
close_btn:setCascadeColorEnabled(true)
close_btn:setCascadeOpacityEnabled(true)
close_btn:setPosition(1055.0400, 609.7126)
if callBackProvider~=nil then
      close_btn:addClickEventListener(callBackProvider("SettingsLayer-UI.lua", close_btn, "CloseClick"))
end
layout = ccui.LayoutComponent:bindLayoutComponent(close_btn)
layout:setPositionPercentX(0.9897)
layout:setPositionPercentY(0.9740)
layout:setPercentWidth(0.0769)
layout:setPercentHeight(0.1310)
layout:setSize({width = 82.0000, height = 82.0000})
layout:setLeftMargin(1014.0400)
layout:setRightMargin(-30.0399)
layout:setTopMargin(-24.7126)
layout:setBottomMargin(568.7126)
bg:addChild(close_btn)

--Create Image_line
local Image_line = ccui.ImageView:create()
Image_line:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/settings/res/settings_picture.plist")
Image_line:loadTexture("app/part/xymj/settings/res/shu.png",1)
Image_line:setLayoutComponentEnabled(true)
Image_line:setName("Image_line")
Image_line:setTag(49)
Image_line:setCascadeColorEnabled(true)
Image_line:setCascadeOpacityEnabled(true)
Image_line:setPosition(428.0000, 313.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_line)
layout:setPositionPercentX(0.4015)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.0019)
layout:setPercentHeight(0.7492)
layout:setSize({width = 2.0000, height = 469.0000})
layout:setHorizontalEdge(1)
layout:setLeftMargin(427.0000)
layout:setRightMargin(637.0000)
layout:setTopMargin(78.5000)
layout:setBottomMargin(78.5000)
bg:addChild(Image_line)

--Create change_btn
local change_btn = ccui.Button:create()
change_btn:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/settings/res/settings_picture.plist")
change_btn:loadTextureNormal("app/part/xymj/settings/res/sz_ggzh.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/settings/res/settings_picture.plist")
change_btn:loadTexturePressed("app/part/xymj/settings/res/sz_ggzh.png",1)
change_btn:setTitleFontSize(14)
change_btn:setTitleColor({r = 65, g = 65, b = 70})
change_btn:setScale9Enabled(true)
change_btn:setCapInsets({x = 15, y = 11, width = 210, height = 69})
change_btn:setLayoutComponentEnabled(true)
change_btn:setName("change_btn")
change_btn:setTag(91)
change_btn:setCascadeColorEnabled(true)
change_btn:setCascadeOpacityEnabled(true)
change_btn:setPosition(225.0007, 202.5000)
if callBackProvider~=nil then
      change_btn:addClickEventListener(callBackProvider("SettingsLayer-UI.lua", change_btn, "ChangeAccountClick"))
end
layout = ccui.LayoutComponent:bindLayoutComponent(change_btn)
layout:setPositionPercentX(0.2111)
layout:setPositionPercentY(0.3235)
layout:setPercentWidth(0.2251)
layout:setPercentHeight(0.1454)
layout:setSize({width = 240.0000, height = 91.0000})
layout:setLeftMargin(105.0007)
layout:setRightMargin(720.9993)
layout:setTopMargin(378.0000)
layout:setBottomMargin(157.0000)
bg:addChild(change_btn)

--Create Sprite_change
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/settings/res/settings_picture.plist")
local Sprite_change = cc.Sprite:createWithSpriteFrameName("app/part/xymj/settings/res/ggzh.png")
Sprite_change:setName("Sprite_change")
Sprite_change:setTag(24)
Sprite_change:setCascadeColorEnabled(true)
Sprite_change:setCascadeOpacityEnabled(true)
Sprite_change:setPosition(120.0000, 45.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(Sprite_change)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 240.0000, height = 91.0000})
Sprite_change:setBlendFunc({src = 1, dst = 771})
change_btn:addChild(Sprite_change)

--Create duihuan_btn
local duihuan_btn = ccui.Button:create()
duihuan_btn:ignoreContentAdaptWithSize(false)
duihuan_btn:loadTextureNormal("app/part/xymj/settings/res/continue_normal.png",0)
duihuan_btn:loadTexturePressed("app/part/xymj/settings/res/continue_press.png",0)
duihuan_btn:setTitleFontSize(14)
duihuan_btn:setTitleColor({r = 65, g = 65, b = 70})
duihuan_btn:setScale9Enabled(true)
duihuan_btn:setCapInsets({x = 15, y = 11, width = 210, height = 69})
duihuan_btn:setLayoutComponentEnabled(true)
duihuan_btn:setName("duihuan_btn")
duihuan_btn:setTag(101)
duihuan_btn:setCascadeColorEnabled(true)
duihuan_btn:setCascadeOpacityEnabled(true)
duihuan_btn:setPosition(225.0000, 111.5000)
if callBackProvider~=nil then
      duihuan_btn:addClickEventListener(callBackProvider("SettingsLayer-UI.lua", duihuan_btn, "onDuihuanClick"))
end
layout = ccui.LayoutComponent:bindLayoutComponent(duihuan_btn)
layout:setPositionPercentX(0.2111)
layout:setPositionPercentY(0.1781)
layout:setPercentWidth(0.2251)
layout:setPercentHeight(0.1454)
layout:setSize({width = 240.0000, height = 91.0000})
layout:setLeftMargin(105.0000)
layout:setRightMargin(721.0000)
layout:setTopMargin(469.0000)
layout:setBottomMargin(66.0000)
bg:addChild(duihuan_btn)

--Create Sprite_change
local Sprite_change = cc.Sprite:create("app/part/xymj/settings/res/btn_word_redeem code.png")
Sprite_change:setName("Sprite_change")
Sprite_change:setTag(102)
Sprite_change:setCascadeColorEnabled(true)
Sprite_change:setCascadeOpacityEnabled(true)
Sprite_change:setPosition(120.0000, 45.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(Sprite_change)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.4625)
layout:setPercentHeight(0.4615)
layout:setSize({width = 111.0000, height = 42.0000})
layout:setLeftMargin(64.5000)
layout:setRightMargin(64.5000)
layout:setTopMargin(24.5000)
layout:setBottomMargin(24.5000)
Sprite_change:setBlendFunc({src = 1, dst = 771})
duihuan_btn:addChild(Sprite_change)

--Create right_panel
local right_panel = ccui.Layout:create()
right_panel:ignoreContentAdaptWithSize(false)
right_panel:setClippingEnabled(false)
right_panel:setBackGroundColorOpacity(102)
right_panel:setTouchEnabled(true);
right_panel:setLayoutComponentEnabled(true)
right_panel:setName("right_panel")
right_panel:setTag(86)
right_panel:setCascadeColorEnabled(true)
right_panel:setCascadeOpacityEnabled(true)
right_panel:setPosition(520.0000, 36.1700)
layout = ccui.LayoutComponent:bindLayoutComponent(right_panel)
layout:setPositionPercentX(0.4878)
layout:setPositionPercentY(0.0578)
layout:setPercentWidth(0.4690)
layout:setPercentHeight(0.7987)
layout:setSize({width = 500.0000, height = 500.0000})
layout:setHorizontalEdge(2)
layout:setVerticalEdge(2)
layout:setLeftMargin(520.0000)
layout:setRightMargin(46.0000)
layout:setTopMargin(89.8300)
layout:setBottomMargin(36.1700)
bg:addChild(right_panel)

--Create music_check
local music_check = ccui.ImageView:create()
music_check:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/settings/res/settings_picture.plist")
music_check:loadTexture("app/part/xymj/settings/res/sz_ON.png",1)
music_check:setTouchEnabled(true);
music_check:setLayoutComponentEnabled(true)
music_check:setName("music_check")
music_check:setTag(84)
music_check:setCascadeColorEnabled(true)
music_check:setCascadeOpacityEnabled(true)
music_check:setPosition(335.0000, 164.0000)
if callBackProvider~=nil then
      music_check:addClickEventListener(callBackProvider("SettingsLayer-UI.lua", music_check, "MusicEvent"))
end
layout = ccui.LayoutComponent:bindLayoutComponent(music_check)
layout:setPositionPercentX(0.6700)
layout:setPositionPercentY(0.3280)
layout:setPercentWidth(0.3680)
layout:setPercentHeight(0.1540)
layout:setSize({width = 184.0000, height = 77.0000})
layout:setLeftMargin(243.0000)
layout:setRightMargin(73.0000)
layout:setTopMargin(297.5000)
layout:setBottomMargin(125.5000)
right_panel:addChild(music_check)

--Create sound_check
local sound_check = ccui.ImageView:create()
sound_check:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/settings/res/settings_picture.plist")
sound_check:loadTexture("app/part/xymj/settings/res/sz_ON.png",1)
sound_check:setTouchEnabled(true);
sound_check:setLayoutComponentEnabled(true)
sound_check:setName("sound_check")
sound_check:setTag(83)
sound_check:setCascadeColorEnabled(true)
sound_check:setCascadeOpacityEnabled(true)
sound_check:setPosition(335.0000, 318.0000)
if callBackProvider~=nil then
      sound_check:addClickEventListener(callBackProvider("SettingsLayer-UI.lua", sound_check, "SoundEvent"))
end
layout = ccui.LayoutComponent:bindLayoutComponent(sound_check)
layout:setPositionPercentX(0.6700)
layout:setPositionPercentY(0.6360)
layout:setPercentWidth(0.3680)
layout:setPercentHeight(0.1540)
layout:setSize({width = 184.0000, height = 77.0000})
layout:setLeftMargin(243.0000)
layout:setRightMargin(73.0000)
layout:setTopMargin(143.5000)
layout:setBottomMargin(279.5000)
right_panel:addChild(sound_check)

--Create title_music_setting
local title_music_setting = ccui.Text:create()
title_music_setting:ignoreContentAdaptWithSize(true)
title_music_setting:setTextAreaSize({width = 0, height = 0})
title_music_setting:setFontName("msyh.ttf")
title_music_setting:setFontSize(35)
title_music_setting:setString([[音效设置]])
title_music_setting:setLayoutComponentEnabled(true)
title_music_setting:setName("title_music_setting")
title_music_setting:setTag(36)
title_music_setting:setCascadeColorEnabled(true)
title_music_setting:setCascadeOpacityEnabled(true)
title_music_setting:setPosition(245.0000, 472.0000)
title_music_setting:setTextColor({r = 129, g = 106, b = 92})
layout = ccui.LayoutComponent:bindLayoutComponent(title_music_setting)
layout:setPositionPercentX(0.4900)
layout:setPositionPercentY(0.9440)
layout:setPercentWidth(0.2860)
layout:setPercentHeight(0.0980)
layout:setSize({width = 143.0000, height = 49.0000})
layout:setLeftMargin(173.5000)
layout:setRightMargin(183.5000)
layout:setTopMargin(3.5000)
layout:setBottomMargin(447.5000)
right_panel:addChild(title_music_setting)

--Create laba_2
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/settings/res/settings_picture.plist")
local laba_2 = cc.Sprite:createWithSpriteFrameName("app/part/xymj/settings/res/laba.png")
laba_2:setName("laba_2")
laba_2:setTag(37)
laba_2:setCascadeColorEnabled(true)
laba_2:setCascadeOpacityEnabled(true)
laba_2:setPosition(10.0000, 388.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(laba_2)
layout:setPositionPercentX(0.0200)
layout:setPositionPercentY(0.7760)
layout:setPercentWidth(0.0960)
layout:setPercentHeight(0.0940)
layout:setSize({width = 48.0000, height = 47.0000})
layout:setVerticalEdge(2)
layout:setLeftMargin(-14.0000)
layout:setRightMargin(466.0000)
layout:setTopMargin(88.5000)
layout:setBottomMargin(364.5000)
laba_2:setBlendFunc({src = 1, dst = 771})
right_panel:addChild(laba_2)

--Create yinyue_3
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/settings/res/settings_picture.plist")
local yinyue_3 = cc.Sprite:createWithSpriteFrameName("app/part/xymj/settings/res/yinyue.png")
yinyue_3:setName("yinyue_3")
yinyue_3:setTag(38)
yinyue_3:setCascadeColorEnabled(true)
yinyue_3:setCascadeOpacityEnabled(true)
yinyue_3:setPosition(10.0000, 237.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(yinyue_3)
layout:setPositionPercentX(0.0200)
layout:setPositionPercentY(0.4740)
layout:setPercentWidth(0.0960)
layout:setPercentHeight(0.0940)
layout:setSize({width = 48.0000, height = 47.0000})
layout:setLeftMargin(-14.0000)
layout:setRightMargin(466.0000)
layout:setTopMargin(239.5000)
layout:setBottomMargin(213.5000)
yinyue_3:setBlendFunc({src = 1, dst = 771})
right_panel:addChild(yinyue_3)

--Create slider_sound
local slider_sound = ccui.Slider:create()
slider_sound:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/settings/res/settings_picture.plist")
slider_sound:loadBarTexture("app/part/xymj/settings/res/qian.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/settings/res/settings_picture.plist")
slider_sound:loadProgressBarTexture("app/part/xymj/settings/res/shen.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/settings/res/settings_picture.plist")
slider_sound:loadSlidBallTextureNormal("app/part/xymj/settings/res/xiao.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/settings/res/settings_picture.plist")
slider_sound:loadSlidBallTexturePressed("app/part/xymj/settings/res/xiao.png",1)
slider_sound:loadSlidBallTextureDisabled("Default/SliderNode_Disable.png",0)
slider_sound:setPercent(100)
slider_sound:setLayoutComponentEnabled(true)
slider_sound:setName("slider_sound")
slider_sound:setTag(39)
slider_sound:setCascadeColorEnabled(true)
slider_sound:setCascadeOpacityEnabled(true)
slider_sound:setPosition(248.0000, 388.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(slider_sound)
layout:setPositionPercentX(0.4960)
layout:setPositionPercentY(0.7760)
layout:setPercentWidth(0.7240)
layout:setPercentHeight(0.0980)
layout:setSize({width = 362.0000, height = 49.0000})
layout:setLeftMargin(67.0000)
layout:setRightMargin(71.0000)
layout:setTopMargin(87.5000)
layout:setBottomMargin(363.5000)
right_panel:addChild(slider_sound)

--Create slider_music
local slider_music = ccui.Slider:create()
slider_music:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/settings/res/settings_picture.plist")
slider_music:loadBarTexture("app/part/xymj/settings/res/qian.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/settings/res/settings_picture.plist")
slider_music:loadProgressBarTexture("app/part/xymj/settings/res/shen.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/settings/res/settings_picture.plist")
slider_music:loadSlidBallTextureNormal("app/part/xymj/settings/res/xiao.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/settings/res/settings_picture.plist")
slider_music:loadSlidBallTexturePressed("app/part/xymj/settings/res/xiao.png",1)
slider_music:loadSlidBallTextureDisabled("Default/SliderNode_Disable.png",0)
slider_music:setPercent(100)
slider_music:setLayoutComponentEnabled(true)
slider_music:setName("slider_music")
slider_music:setTag(40)
slider_music:setCascadeColorEnabled(true)
slider_music:setCascadeOpacityEnabled(true)
slider_music:setPosition(248.0000, 237.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(slider_music)
layout:setPositionPercentX(0.4960)
layout:setPositionPercentY(0.4740)
layout:setPercentWidth(0.7240)
layout:setPercentHeight(0.0980)
layout:setSize({width = 362.0000, height = 49.0000})
layout:setLeftMargin(67.0000)
layout:setRightMargin(71.0000)
layout:setTopMargin(238.5000)
layout:setBottomMargin(212.5000)
right_panel:addChild(slider_music)

--Create Text_2
local Text_2 = ccui.Text:create()
Text_2:ignoreContentAdaptWithSize(true)
Text_2:setTextAreaSize({width = 0, height = 0})
Text_2:setFontSize(32)
Text_2:setString([[音效]])
Text_2:setLayoutComponentEnabled(true)
Text_2:setName("Text_2")
Text_2:setTag(41)
Text_2:setCascadeColorEnabled(true)
Text_2:setCascadeOpacityEnabled(true)
Text_2:setPosition(15.0000, 318.0000)
Text_2:setTextColor({r = 180, g = 151, b = 133})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_2)
layout:setPositionPercentX(0.0300)
layout:setPositionPercentY(0.6360)
layout:setPercentWidth(0.1280)
layout:setPercentHeight(0.0740)
layout:setSize({width = 64.0000, height = 37.0000})
layout:setLeftMargin(-17.0000)
layout:setRightMargin(453.0000)
layout:setTopMargin(163.5000)
layout:setBottomMargin(299.5000)
right_panel:addChild(Text_2)

--Create Text_3
local Text_3 = ccui.Text:create()
Text_3:ignoreContentAdaptWithSize(true)
Text_3:setTextAreaSize({width = 0, height = 0})
Text_3:setFontSize(32)
Text_3:setString([[音乐]])
Text_3:setLayoutComponentEnabled(true)
Text_3:setName("Text_3")
Text_3:setTag(42)
Text_3:setCascadeColorEnabled(true)
Text_3:setCascadeOpacityEnabled(true)
Text_3:setPosition(15.0000, 164.0000)
Text_3:setTextColor({r = 180, g = 151, b = 133})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_3)
layout:setPositionPercentX(0.0300)
layout:setPositionPercentY(0.3280)
layout:setPercentWidth(0.1280)
layout:setPercentHeight(0.0740)
layout:setSize({width = 64.0000, height = 37.0000})
layout:setLeftMargin(-17.0000)
layout:setRightMargin(453.0000)
layout:setTopMargin(317.5000)
layout:setBottomMargin(145.5000)
right_panel:addChild(Text_3)

--Create td_check
local td_check = ccui.ImageView:create()
td_check:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/settings/res/settings_picture.plist")
td_check:loadTexture("app/part/xymj/settings/res/sz_ON.png",1)
td_check:setTouchEnabled(true);
td_check:setLayoutComponentEnabled(true)
td_check:setName("td_check")
td_check:setTag(74)
td_check:setCascadeColorEnabled(true)
td_check:setCascadeOpacityEnabled(true)
td_check:setVisible(false)
td_check:setPosition(1282.5260, 31.0707)
if callBackProvider~=nil then
      td_check:addClickEventListener(callBackProvider("SettingsLayer-UI.lua", td_check, "on3DEvent"))
end
layout = ccui.LayoutComponent:bindLayoutComponent(td_check)
layout:setPositionPercentX(2.5651)
layout:setPositionPercentY(0.0621)
layout:setPercentWidth(0.3680)
layout:setPercentHeight(0.1540)
layout:setSize({width = 184.0000, height = 77.0000})
layout:setLeftMargin(1190.5260)
layout:setRightMargin(-874.5259)
layout:setTopMargin(430.4293)
layout:setBottomMargin(-7.4293)
right_panel:addChild(td_check)

--Create Text_3d
local Text_3d = ccui.Text:create()
Text_3d:ignoreContentAdaptWithSize(true)
Text_3d:setTextAreaSize({width = 0, height = 0})
Text_3d:setFontSize(32)
Text_3d:setString([[3D]])
Text_3d:setLayoutComponentEnabled(true)
Text_3d:setName("Text_3d")
Text_3d:setTag(75)
Text_3d:setCascadeColorEnabled(true)
Text_3d:setCascadeOpacityEnabled(true)
Text_3d:setVisible(false)
Text_3d:setPosition(962.5306, 31.0703)
Text_3d:setTextColor({r = 180, g = 151, b = 133})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_3d)
layout:setPositionPercentX(1.9251)
layout:setPositionPercentY(0.0621)
layout:setPercentWidth(0.0820)
layout:setPercentHeight(0.0740)
layout:setSize({width = 41.0000, height = 37.0000})
layout:setLeftMargin(942.0306)
layout:setRightMargin(-483.0306)
layout:setTopMargin(450.4297)
layout:setBottomMargin(12.5703)
right_panel:addChild(Text_3d)

--Create dialect_check
local dialect_check = ccui.ImageView:create()
dialect_check:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/settings/res/settings_picture.plist")
dialect_check:loadTexture("app/part/xymj/settings/res/sz_OFF.png",1)
dialect_check:setTouchEnabled(true);
dialect_check:setLayoutComponentEnabled(true)
dialect_check:setName("dialect_check")
dialect_check:setTag(75)
dialect_check:setCascadeColorEnabled(true)
dialect_check:setCascadeOpacityEnabled(true)
dialect_check:setPosition(334.9998, 73.1732)
if callBackProvider~=nil then
      dialect_check:addClickEventListener(callBackProvider("SettingsLayer-UI.lua", dialect_check, "DialectEvent"))
end
layout = ccui.LayoutComponent:bindLayoutComponent(dialect_check)
layout:setPositionPercentX(0.6700)
layout:setPositionPercentY(0.1463)
layout:setPercentWidth(0.3680)
layout:setPercentHeight(0.1540)
layout:setSize({width = 184.0000, height = 77.0000})
layout:setLeftMargin(242.9998)
layout:setRightMargin(73.0002)
layout:setTopMargin(388.3268)
layout:setBottomMargin(34.6732)
right_panel:addChild(dialect_check)

--Create Text_3d_0
local Text_3d_0 = ccui.Text:create()
Text_3d_0:ignoreContentAdaptWithSize(true)
Text_3d_0:setTextAreaSize({width = 0, height = 0})
Text_3d_0:setFontSize(32)
Text_3d_0:setString([[方言]])
Text_3d_0:setLayoutComponentEnabled(true)
Text_3d_0:setName("Text_3d_0")
Text_3d_0:setTag(76)
Text_3d_0:setCascadeColorEnabled(true)
Text_3d_0:setCascadeOpacityEnabled(true)
Text_3d_0:setPosition(15.0000, 82.1727)
Text_3d_0:setTextColor({r = 180, g = 151, b = 133})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_3d_0)
layout:setPositionPercentX(0.0300)
layout:setPositionPercentY(0.1643)
layout:setPercentWidth(0.1280)
layout:setPercentHeight(0.0740)
layout:setSize({width = 64.0000, height = 37.0000})
layout:setLeftMargin(-17.0000)
layout:setRightMargin(453.0000)
layout:setTopMargin(399.3273)
layout:setBottomMargin(63.6727)
right_panel:addChild(Text_3d_0)

--Create Image_17
local Image_17 = ccui.ImageView:create()
Image_17:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/settings/res/settings_picture.plist")
Image_17:loadTexture("app/part/xymj/settings/res/head_kuang.png",1)
Image_17:setLayoutComponentEnabled(true)
Image_17:setName("Image_17")
Image_17:setTag(49)
Image_17:setCascadeColorEnabled(true)
Image_17:setCascadeOpacityEnabled(true)
Image_17:setPosition(222.0000, 356.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_17)
layout:setPositionPercentX(0.2083)
layout:setPositionPercentY(0.5695)
layout:setPercentWidth(0.1745)
layout:setPercentHeight(0.2971)
layout:setSize({width = 186.0000, height = 186.0000})
layout:setHorizontalEdge(1)
layout:setVerticalEdge(2)
layout:setLeftMargin(129.0000)
layout:setRightMargin(751.0000)
layout:setTopMargin(176.5000)
layout:setBottomMargin(263.5000)
bg:addChild(Image_17)

--Create model_1
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/settings/res/settings_picture.plist")
local model_1 = cc.Sprite:createWithSpriteFrameName("app/part/xymj/settings/res/model.png")
model_1:setName("model_1")
model_1:setTag(25)
model_1:setCascadeColorEnabled(true)
model_1:setCascadeOpacityEnabled(true)
model_1:setPosition(93.0000, 94.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(model_1)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5054)
layout:setPercentWidth(0.8710)
layout:setPercentHeight(0.8710)
layout:setSize({width = 162.0000, height = 162.0000})
layout:setLeftMargin(12.0000)
layout:setRightMargin(12.0000)
layout:setTopMargin(11.0000)
layout:setBottomMargin(13.0000)
model_1:setBlendFunc({src = 1, dst = 771})
Image_17:addChild(model_1)

--Create head_sprite
local head_sprite = cc.Sprite:create("app/part/xymj/settings/res/default_head.png")
head_sprite:setName("head_sprite")
head_sprite:setTag(253)
head_sprite:setCascadeColorEnabled(true)
head_sprite:setCascadeOpacityEnabled(true)
head_sprite:setPosition(92.4400, 95.7300)
head_sprite:setScaleX(1.6400)
head_sprite:setScaleY(1.6000)
layout = ccui.LayoutComponent:bindLayoutComponent(head_sprite)
layout:setPositionPercentX(0.4970)
layout:setPositionPercentY(0.5147)
layout:setPercentWidth(0.5269)
layout:setPercentHeight(0.5269)
layout:setSize({width = 98.0000, height = 98.0000})
layout:setLeftMargin(43.4400)
layout:setRightMargin(44.5600)
layout:setTopMargin(41.2700)
layout:setBottomMargin(46.7300)
head_sprite:setBlendFunc({src = 770, dst = 771})
Image_17:addChild(head_sprite)

--Create Image_1
local Image_1 = ccui.ImageView:create()
Image_1:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/settings/res/settings_picture.plist")
Image_1:loadTexture("app/part/xymj/settings/res/dialog_title_bg.png",1)
Image_1:setLayoutComponentEnabled(true)
Image_1:setName("Image_1")
Image_1:setTag(15)
Image_1:setCascadeColorEnabled(true)
Image_1:setCascadeOpacityEnabled(true)
Image_1:setPosition(533.0000, 591.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_1)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.9441)
layout:setPercentWidth(0.7908)
layout:setPercentHeight(0.1550)
layout:setSize({width = 843.0000, height = 97.0000})
layout:setLeftMargin(111.5000)
layout:setRightMargin(111.5000)
layout:setTopMargin(-13.5000)
layout:setBottomMargin(542.5000)
bg:addChild(Image_1)

--Create Image_2
local Image_2 = ccui.ImageView:create()
Image_2:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/settings/res/settings_picture.plist")
Image_2:loadTexture("app/part/xymj/settings/res/tltie_setting.png",1)
Image_2:setLayoutComponentEnabled(true)
Image_2:setName("Image_2")
Image_2:setTag(16)
Image_2:setCascadeColorEnabled(true)
Image_2:setCascadeOpacityEnabled(true)
Image_2:setPosition(421.5000, 60.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_2)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.6186)
layout:setPercentWidth(0.2206)
layout:setPercentHeight(0.5361)
layout:setSize({width = 186.0000, height = 52.0000})
layout:setLeftMargin(328.5000)
layout:setRightMargin(328.5000)
layout:setTopMargin(11.0000)
layout:setBottomMargin(34.0000)
Image_1:addChild(Image_2)

--Create Text_modifyUName
local Text_modifyUName = ccui.Text:create()
Text_modifyUName:ignoreContentAdaptWithSize(true)
Text_modifyUName:setTextAreaSize({width = 0, height = 0})
Text_modifyUName:setFontName("msyh.ttf")
Text_modifyUName:setFontSize(35)
Text_modifyUName:setString([[更改帐号]])
Text_modifyUName:setLayoutComponentEnabled(true)
Text_modifyUName:setName("Text_modifyUName")
Text_modifyUName:setTag(43)
Text_modifyUName:setCascadeColorEnabled(true)
Text_modifyUName:setCascadeOpacityEnabled(true)
Text_modifyUName:setPosition(222.5000, 502.7302)
Text_modifyUName:setTextColor({r = 129, g = 106, b = 92})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_modifyUName)
layout:setPositionPercentX(0.2087)
layout:setPositionPercentY(0.8031)
layout:setPercentWidth(0.1341)
layout:setPercentHeight(0.0783)
layout:setSize({width = 143.0000, height = 49.0000})
layout:setLeftMargin(151.0000)
layout:setRightMargin(772.0000)
layout:setTopMargin(98.7698)
layout:setBottomMargin(478.2302)
bg:addChild(Text_modifyUName)

--Create Text_currentUName
local Text_currentUName = ccui.Text:create()
Text_currentUName:ignoreContentAdaptWithSize(true)
Text_currentUName:setTextAreaSize({width = 0, height = 0})
Text_currentUName:setFontName("msyh.ttf")
Text_currentUName:setFontSize(35)
Text_currentUName:setString([[Siri]])
Text_currentUName:setLayoutComponentEnabled(true)
Text_currentUName:setName("Text_currentUName")
Text_currentUName:setTag(44)
Text_currentUName:setCascadeColorEnabled(true)
Text_currentUName:setCascadeOpacityEnabled(true)
Text_currentUName:setVisible(false)
Text_currentUName:setPosition(222.5548, 213.0947)
Text_currentUName:setTextColor({r = 129, g = 106, b = 92})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_currentUName)
layout:setPositionPercentX(0.2088)
layout:setPositionPercentY(0.3404)
layout:setPercentWidth(0.0478)
layout:setPercentHeight(0.0783)
layout:setSize({width = 51.0000, height = 49.0000})
layout:setLeftMargin(197.0548)
layout:setRightMargin(817.9452)
layout:setTopMargin(388.4053)
layout:setBottomMargin(188.5947)
bg:addChild(Text_currentUName)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Layer
return result;
end

return Result

