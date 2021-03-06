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
touch_mask:setTag(53)
touch_mask:setCascadeColorEnabled(true)
touch_mask:setCascadeOpacityEnabled(true)
touch_mask:setPosition(640.0000, 360.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(touch_mask)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 1280.0000, height = 720.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(3)
Layer:addChild(touch_mask)

--Create bg
local bg = ccui.ImageView:create()
bg:ignoreContentAdaptWithSize(false)
bg:loadTexture("app/part/xymj/duihuan/res/backg.png",0)
bg:setLayoutComponentEnabled(true)
bg:setName("bg")
bg:setTag(21)
bg:setCascadeColorEnabled(true)
bg:setCascadeOpacityEnabled(true)
bg:setPosition(640.0000, 360.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(bg)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.8328)
layout:setPercentHeight(0.8694)
layout:setSize({width = 1066.0000, height = 626.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(1)
layout:setLeftMargin(107.0000)
layout:setRightMargin(107.0000)
layout:setTopMargin(47.0000)
layout:setBottomMargin(47.0000)
Layer:addChild(bg)

--Create inner_bg
local inner_bg = ccui.ImageView:create()
inner_bg:ignoreContentAdaptWithSize(false)
inner_bg:loadTexture("app/part/xymj/duihuan/res/srk_01.png",0)
inner_bg:setScale9Enabled(true)
inner_bg:setCapInsets({x = 15, y = 15, width = 961, height = 467})
inner_bg:setLayoutComponentEnabled(true)
inner_bg:setName("inner_bg")
inner_bg:setTag(130)
inner_bg:setCascadeColorEnabled(true)
inner_bg:setCascadeOpacityEnabled(true)
inner_bg:setPosition(533.0000, 313.0000)
inner_bg:setScaleX(0.9179)
inner_bg:setScaleY(0.8030)
layout = ccui.LayoutComponent:bindLayoutComponent(inner_bg)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.9606)
layout:setPercentHeight(0.9617)
layout:setSize({width = 1024.0000, height = 602.0000})
layout:setLeftMargin(21.0000)
layout:setRightMargin(21.0000)
layout:setTopMargin(12.0000)
layout:setBottomMargin(12.0000)
bg:addChild(inner_bg)

--Create text_field_bg
local text_field_bg = ccui.ImageView:create()
text_field_bg:ignoreContentAdaptWithSize(false)
text_field_bg:loadTexture("app/part/xymj/duihuan/res/input_bg.png",0)
text_field_bg:setScale9Enabled(true)
text_field_bg:setCapInsets({x = 15, y = 15, width = 22, height = 22})
text_field_bg:setLayoutComponentEnabled(true)
text_field_bg:setName("text_field_bg")
text_field_bg:setTag(53)
text_field_bg:setCascadeColorEnabled(true)
text_field_bg:setCascadeOpacityEnabled(true)
text_field_bg:setPosition(533.0000, 334.0000)
text_field_bg:setScaleX(0.9179)
text_field_bg:setScaleY(0.8030)
layout = ccui.LayoutComponent:bindLayoutComponent(text_field_bg)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5335)
layout:setPercentWidth(0.5647)
layout:setPercentHeight(0.1102)
layout:setSize({width = 602.0000, height = 69.0000})
layout:setLeftMargin(232.0000)
layout:setRightMargin(232.0000)
layout:setTopMargin(257.5000)
layout:setBottomMargin(299.5000)
bg:addChild(text_field_bg)

--Create text_field
local text_field = ccui.TextField:create()
text_field:ignoreContentAdaptWithSize(false)
tolua.cast(text_field:getVirtualRenderer(), "cc.Label"):setLineBreakWithoutSpace(true)
text_field:setFontSize(48)
text_field:setPlaceHolder("请输入兑换码")
text_field:setString([[]])
text_field:setMaxLength(10)
text_field:setLayoutComponentEnabled(true)
text_field:setName("text_field")
text_field:setTag(51)
text_field:setCascadeColorEnabled(true)
text_field:setCascadeOpacityEnabled(true)
text_field:setPosition(301.0000, 31.2600)
text_field:setColor({r = 177, g = 120, b = 63})
if callBackProvider~=nil then
      text_field:addEventListener(callBackProvider("DuihuanLayer-UI.lua", text_field, "onTextfieldCallback"))
end
layout = ccui.LayoutComponent:bindLayoutComponent(text_field)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.4530)
layout:setPercentWidthEnabled(true)
layout:setPercentHeightEnabled(true)
layout:setPercentWidth(0.9500)
layout:setPercentHeight(0.9000)
layout:setSize({width = 571.9000, height = 62.1000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(3)
layout:setLeftMargin(15.0500)
layout:setRightMargin(15.0500)
layout:setTopMargin(6.6900)
layout:setBottomMargin(0.2100)
text_field_bg:addChild(text_field)

--Create title_bg
local title_bg = ccui.ImageView:create()
title_bg:ignoreContentAdaptWithSize(false)
title_bg:loadTexture("app/part/xymj/duihuan/res/dialog_title_bg.png",0)
title_bg:setLayoutComponentEnabled(true)
title_bg:setName("title_bg")
title_bg:setTag(372)
title_bg:setCascadeColorEnabled(true)
title_bg:setCascadeOpacityEnabled(true)
title_bg:setPosition(533.0000, 591.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(title_bg)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.9441)
layout:setPercentWidth(0.7908)
layout:setPercentHeight(0.1550)
layout:setSize({width = 843.0000, height = 97.0000})
layout:setLeftMargin(111.5000)
layout:setRightMargin(111.5000)
layout:setTopMargin(-13.5000)
layout:setBottomMargin(542.5000)
bg:addChild(title_bg)

--Create title_text
local title_text = ccui.ImageView:create()
title_text:ignoreContentAdaptWithSize(false)
title_text:loadTexture("app/part/xymj/duihuan/res/btn_word_redeem code.png",0)
title_text:setLayoutComponentEnabled(true)
title_text:setName("title_text")
title_text:setTag(373)
title_text:setCascadeColorEnabled(true)
title_text:setCascadeOpacityEnabled(true)
title_text:setPosition(421.5000, 58.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(title_text)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5979)
layout:setPercentWidth(0.1317)
layout:setPercentHeight(0.4330)
layout:setSize({width = 111.0000, height = 42.0000})
layout:setLeftMargin(366.0000)
layout:setRightMargin(366.0000)
layout:setTopMargin(18.0000)
layout:setBottomMargin(37.0000)
title_bg:addChild(title_text)

--Create close_btn
local close_btn = ccui.Button:create()
close_btn:ignoreContentAdaptWithSize(false)
close_btn:loadTextureNormal("app/part/xymj/duihuan/res/btn_close.png",0)
close_btn:loadTextureDisabled("Default/Button_Disable.png",0)
close_btn:setTitleFontSize(14)
close_btn:setTitleColor({r = 65, g = 65, b = 70})
close_btn:setScale9Enabled(true)
close_btn:setCapInsets({x = 15, y = 11, width = 52, height = 60})
close_btn:setLayoutComponentEnabled(true)
close_btn:setName("close_btn")
close_btn:setTag(22)
close_btn:setCascadeColorEnabled(true)
close_btn:setCascadeOpacityEnabled(true)
close_btn:setPosition(1057.1900, 611.7600)
if callBackProvider~=nil then
      close_btn:addClickEventListener(callBackProvider("DuihuanLayer-UI.lua", close_btn, "CloseClick"))
end
layout = ccui.LayoutComponent:bindLayoutComponent(close_btn)
layout:setPositionPercentX(0.9917)
layout:setPositionPercentY(0.9773)
layout:setPercentWidth(0.0769)
layout:setPercentHeight(0.1310)
layout:setSize({width = 82.0000, height = 82.0000})
layout:setLeftMargin(1016.1900)
layout:setRightMargin(-32.1899)
layout:setTopMargin(-26.7600)
layout:setBottomMargin(570.7600)
bg:addChild(close_btn)

--Create button_send
local button_send = ccui.Button:create()
button_send:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/duihuantips/res/tips_picture.plist")
button_send:loadTextureNormal("app/part/xymj/tips/res/tc_qrl.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/duihuantips/res/tips_picture.plist")
button_send:loadTexturePressed("app/part/xymj/tips/res/tc_qr.png",1)
button_send:setTitleFontSize(14)
button_send:setScale9Enabled(true)
button_send:setCapInsets({x = 15, y = 11, width = 176, height = 57})
button_send:setLayoutComponentEnabled(true)
button_send:setName("button_send")
button_send:setTag(266)
button_send:setCascadeColorEnabled(true)
button_send:setCascadeOpacityEnabled(true)
button_send:setPosition(528.1144, 142.3113)
if callBackProvider~=nil then
      button_send:addClickEventListener(callBackProvider("DuihuanLayer-UI.lua", button_send, "onOkClick"))
end
layout = ccui.LayoutComponent:bindLayoutComponent(button_send)
layout:setPositionPercentX(0.4954)
layout:setPositionPercentY(0.2273)
layout:setPercentWidth(0.1932)
layout:setPercentHeight(0.1262)
layout:setSize({width = 206.0000, height = 79.0000})
layout:setVerticalEdge(1)
layout:setLeftMargin(425.1144)
layout:setRightMargin(434.8856)
layout:setTopMargin(444.1887)
layout:setBottomMargin(102.8113)
bg:addChild(button_send)

--Create image_ok_1
local image_ok_1 = ccui.ImageView:create()
image_ok_1:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/duihuantips/res/tips_picture.plist")
image_ok_1:loadTexture("app/part/xymj/tips/res/qd.png",1)
image_ok_1:setLayoutComponentEnabled(true)
image_ok_1:setName("image_ok_1")
image_ok_1:setTag(267)
image_ok_1:setCascadeColorEnabled(true)
image_ok_1:setCascadeOpacityEnabled(true)
image_ok_1:setPosition(103.0000, 39.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(image_ok_1)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 206.0000, height = 79.0000})
button_send:addChild(image_ok_1)

--Create btn_record
local btn_record = ccui.Button:create()
btn_record:ignoreContentAdaptWithSize(false)
btn_record:setTitleFontSize(24)
btn_record:setTitleText("兑换历史")
btn_record:setTitleColor({r = 82, g = 55, b = 21})
btn_record:setScale9Enabled(true)
btn_record:setCapInsets({x = 15, y = 6, width = 162, height = 42})
btn_record:setLayoutComponentEnabled(true)
btn_record:setName("btn_record")
btn_record:setTag(152)
btn_record:setCascadeColorEnabled(true)
btn_record:setCascadeOpacityEnabled(true)
btn_record:setPosition(945.0000, 97.1600)
if callBackProvider~=nil then
      btn_record:addClickEventListener(callBackProvider("DuihuanLayer-UI.lua", btn_record, "onRecordClick"))
end
layout = ccui.LayoutComponent:bindLayoutComponent(btn_record)
layout:setPositionPercentX(0.8865)
layout:setPositionPercentY(0.1552)
layout:setPercentWidth(0.1801)
layout:setPercentHeight(0.0895)
layout:setSize({width = 192.0000, height = 56.0000})
layout:setLeftMargin(849.0000)
layout:setRightMargin(25.0000)
layout:setTopMargin(500.8400)
layout:setBottomMargin(69.1600)
bg:addChild(btn_record)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Layer
return result;
end

return Result

