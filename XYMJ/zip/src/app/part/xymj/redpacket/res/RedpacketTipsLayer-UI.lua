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

--Create Panel_split
local Panel_split = ccui.Layout:create()
Panel_split:ignoreContentAdaptWithSize(false)
Panel_split:setClippingEnabled(false)
Panel_split:setBackGroundColorOpacity(102)
Panel_split:setTouchEnabled(true);
Panel_split:setLayoutComponentEnabled(true)
Panel_split:setName("Panel_split")
Panel_split:setTag(62)
Panel_split:setCascadeColorEnabled(true)
Panel_split:setCascadeOpacityEnabled(true)
Panel_split:setAnchorPoint(0.5000, 0.5000)
Panel_split:setPosition(640.0000, 360.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(Panel_split)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 1280.0000, height = 720.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(3)
Layer:addChild(Panel_split)

--Create Image_background
local Image_background = ccui.ImageView:create()
Image_background:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/redpacket/res/redpacket_picture.plist")
Image_background:loadTexture("app/part/xymj/redpacket/res/rp_icon.png",1)
Image_background:setLayoutComponentEnabled(true)
Image_background:setName("Image_background")
Image_background:setTag(56)
Image_background:setCascadeColorEnabled(true)
Image_background:setCascadeOpacityEnabled(true)
Image_background:setPosition(640.0000, 360.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_background)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.2766)
layout:setPercentHeight(0.6556)
layout:setSize({width = 354.0000, height = 472.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(3)
layout:setLeftMargin(463.0000)
layout:setRightMargin(463.0000)
layout:setTopMargin(124.0000)
layout:setBottomMargin(124.0000)
Panel_split:addChild(Image_background)

--Create Image_tiitle
local Image_tiitle = ccui.ImageView:create()
Image_tiitle:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/redpacket/res/redpacket_picture.plist")
Image_tiitle:loadTexture("app/part/xymj/redpacket/res/rec_wenzi1.png",1)
Image_tiitle:setLayoutComponentEnabled(true)
Image_tiitle:setName("Image_tiitle")
Image_tiitle:setTag(38)
Image_tiitle:setCascadeColorEnabled(true)
Image_tiitle:setCascadeOpacityEnabled(true)
Image_tiitle:setPosition(640.0000, 540.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_tiitle)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.7500)
layout:setPercentWidth(0.1742)
layout:setPercentHeight(0.0792)
layout:setSize({width = 223.0000, height = 57.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(3)
layout:setLeftMargin(528.5000)
layout:setRightMargin(528.5000)
layout:setTopMargin(151.5000)
layout:setBottomMargin(511.5000)
Panel_split:addChild(Image_tiitle)

--Create Btn_split
local Btn_split = ccui.Button:create()
Btn_split:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/redpacket/res/redpacket_picture.plist")
Btn_split:loadTextureNormal("app/part/xymj/redpacket/res/split.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/redpacket/res/redpacket_picture.plist")
Btn_split:loadTexturePressed("app/part/xymj/redpacket/res/split.png",1)
Btn_split:loadTextureDisabled("Default/Button_Disable.png",0)
Btn_split:setTitleFontSize(14)
Btn_split:setTitleColor({r = 65, g = 65, b = 70})
Btn_split:setScale9Enabled(true)
Btn_split:setCapInsets({x = 15, y = 11, width = 141, height = 151})
Btn_split:setLayoutComponentEnabled(true)
Btn_split:setName("Btn_split")
Btn_split:setTag(57)
Btn_split:setCascadeColorEnabled(true)
Btn_split:setCascadeOpacityEnabled(true)
Btn_split:setPosition(640.0000, 415.0080)
layout = ccui.LayoutComponent:bindLayoutComponent(Btn_split)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5764)
layout:setPercentWidth(0.1336)
layout:setPercentHeight(0.2403)
layout:setSize({width = 171.0000, height = 173.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(3)
layout:setLeftMargin(554.5000)
layout:setRightMargin(554.5000)
layout:setTopMargin(218.4920)
layout:setBottomMargin(328.5080)
Panel_split:addChild(Btn_split)

--Create Text_descript
local Text_descript = ccui.Text:create()
Text_descript:ignoreContentAdaptWithSize(true)
Text_descript:setTextAreaSize({width = 0, height = 0})
Text_descript:setFontName("font/msyh.ttf")
Text_descript:setFontSize(35)
Text_descript:setString([[开房获得红包]])
Text_descript:setTextHorizontalAlignment(1)
Text_descript:setLayoutComponentEnabled(true)
Text_descript:setName("Text_descript")
Text_descript:setTag(58)
Text_descript:setCascadeColorEnabled(true)
Text_descript:setCascadeOpacityEnabled(true)
Text_descript:setPosition(629.5040, 284.9040)
Text_descript:setTextColor({r = 255, g = 251, b = 86})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_descript)
layout:setPositionPercentX(0.4918)
layout:setPositionPercentY(0.3957)
layout:setPercentWidth(0.1664)
layout:setPercentHeight(0.0681)
layout:setSize({width = 213.0000, height = 49.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(3)
layout:setLeftMargin(523.0040)
layout:setRightMargin(543.9960)
layout:setTopMargin(410.5960)
layout:setBottomMargin(260.4040)
Panel_split:addChild(Text_descript)

--Create Text_context
local Text_context = ccui.Text:create()
Text_context:ignoreContentAdaptWithSize(false)
Text_context:setFontName("font/msyh.ttf")
Text_context:setFontSize(18)
Text_context:setString([[活动期间，每天XX点到XX点，开房可获得红包，开启红包可获得钻石、现金奖励]])
Text_context:setLayoutComponentEnabled(true)
Text_context:setName("Text_context")
Text_context:setTag(61)
Text_context:setCascadeColorEnabled(true)
Text_context:setCascadeOpacityEnabled(true)
Text_context:setPosition(640.0000, 210.0240)
Text_context:setTextColor({r = 255, g = 238, b = 168})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_context)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.2917)
layout:setPercentWidth(0.2344)
layout:setPercentHeight(0.1111)
layout:setSize({width = 300.0000, height = 80.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(3)
layout:setLeftMargin(490.0000)
layout:setRightMargin(490.0000)
layout:setTopMargin(469.9760)
layout:setBottomMargin(170.0240)
Panel_split:addChild(Text_context)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Layer
return result;
end

return Result
