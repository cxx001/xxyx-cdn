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

--Create bg_dikuang
local bg_dikuang = ccui.ImageView:create()
bg_dikuang:ignoreContentAdaptWithSize(false)
bg_dikuang:loadTexture("app/part/xymj/payContinueTip/res/bg1.png",0)
bg_dikuang:setLayoutComponentEnabled(true)
bg_dikuang:setName("bg_dikuang")
bg_dikuang:setTag(1834)
bg_dikuang:setCascadeColorEnabled(true)
bg_dikuang:setCascadeOpacityEnabled(true)
bg_dikuang:setPosition(640.0000, 360.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(bg_dikuang)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.6047)
layout:setPercentHeight(0.6292)
layout:setSize({width = 774.0000, height = 453.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(3)
layout:setLeftMargin(253.0000)
layout:setRightMargin(253.0000)
layout:setTopMargin(133.5000)
layout:setBottomMargin(133.5000)
Layer:addChild(bg_dikuang)

--Create bg2
local bg2 = ccui.ImageView:create()
bg2:ignoreContentAdaptWithSize(false)
bg2:loadTexture("app/part/xymj/payContinueTip/res/bg2.png",0)
bg2:setLayoutComponentEnabled(true)
bg2:setName("bg2")
bg2:setTag(1835)
bg2:setCascadeColorEnabled(true)
bg2:setCascadeOpacityEnabled(true)
bg2:setPosition(387.0000, 226.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(bg2)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.9716)
layout:setPercentHeight(0.9514)
layout:setSize({width = 752.0000, height = 431.0000})
layout:setLeftMargin(11.0000)
layout:setRightMargin(11.0000)
layout:setTopMargin(11.0000)
layout:setBottomMargin(11.0000)
bg_dikuang:addChild(bg2)

--Create Text_tip
local Text_tip = ccui.Text:create()
Text_tip:ignoreContentAdaptWithSize(false)
Text_tip:setFontSize(35)
Text_tip:setString([[由于您未绑定推荐人，当前购钻石价格较高，确定继续支付吗?]])
Text_tip:setLayoutComponentEnabled(true)
Text_tip:setName("Text_tip")
Text_tip:setTag(1836)
Text_tip:setCascadeColorEnabled(true)
Text_tip:setCascadeOpacityEnabled(true)
Text_tip:setPosition(387.0000, 362.4000)
Text_tip:setTextColor({r = 106, g = 51, b = 10})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_tip)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.8000)
layout:setPercentWidth(0.7752)
layout:setPercentHeight(0.2208)
layout:setSize({width = 600.0000, height = 100.0000})
layout:setLeftMargin(87.0000)
layout:setRightMargin(87.0000)
layout:setTopMargin(40.6000)
layout:setBottomMargin(312.4000)
bg_dikuang:addChild(Text_tip)

--Create Button_bind
local Button_bind = ccui.Button:create()
Button_bind:ignoreContentAdaptWithSize(false)
Button_bind:loadTextureNormal("app/part/xymj/payContinueTip/res/yellowBtn1.png",0)
Button_bind:loadTexturePressed("app/part/xymj/payContinueTip/res/yellowBtn2.png",0)
Button_bind:setTitleFontSize(14)
Button_bind:setTitleColor({r = 65, g = 65, b = 70})
Button_bind:setScale9Enabled(true)
Button_bind:setCapInsets({x = 15, y = 11, width = 210, height = 69})
Button_bind:setLayoutComponentEnabled(true)
Button_bind:setName("Button_bind")
Button_bind:setTag(1837)
Button_bind:setCascadeColorEnabled(true)
Button_bind:setCascadeOpacityEnabled(true)
Button_bind:setPosition(232.2000, 135.9000)
if callBackProvider~=nil then
      Button_bind:addClickEventListener(callBackProvider("PayContinueLayer-UI.lua", Button_bind, "bindClick"))
end
layout = ccui.LayoutComponent:bindLayoutComponent(Button_bind)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.3000)
layout:setPositionPercentY(0.3000)
layout:setPercentWidth(0.3101)
layout:setPercentHeight(0.2009)
layout:setSize({width = 240.0000, height = 91.0000})
layout:setLeftMargin(112.2000)
layout:setRightMargin(421.8000)
layout:setTopMargin(271.6000)
layout:setBottomMargin(90.4000)
bg_dikuang:addChild(Button_bind)

--Create Image_7
local Image_7 = ccui.ImageView:create()
Image_7:ignoreContentAdaptWithSize(false)
Image_7:loadTexture("app/part/xymj/payContinueTip/res/btnImg2.png",0)
Image_7:setLayoutComponentEnabled(true)
Image_7:setName("Image_7")
Image_7:setTag(1838)
Image_7:setCascadeColorEnabled(true)
Image_7:setCascadeOpacityEnabled(true)
Image_7:setPosition(120.0000, 45.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_7)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 240.0000, height = 91.0000})
Button_bind:addChild(Image_7)

--Create Button_continue
local Button_continue = ccui.Button:create()
Button_continue:ignoreContentAdaptWithSize(false)
Button_continue:loadTextureNormal("app/part/xymj/payContinueTip/res/greenbtn1.png",0)
Button_continue:loadTexturePressed("app/part/xymj/payContinueTip/res/greenbtn2.png",0)
Button_continue:setTitleFontSize(14)
Button_continue:setTitleColor({r = 65, g = 65, b = 70})
Button_continue:setScale9Enabled(true)
Button_continue:setCapInsets({x = 15, y = 11, width = 210, height = 69})
Button_continue:setLayoutComponentEnabled(true)
Button_continue:setName("Button_continue")
Button_continue:setTag(1839)
Button_continue:setCascadeColorEnabled(true)
Button_continue:setCascadeOpacityEnabled(true)
Button_continue:setPosition(541.8000, 135.9000)
if callBackProvider~=nil then
      Button_continue:addClickEventListener(callBackProvider("PayContinueLayer-UI.lua", Button_continue, "continuePayClick"))
end
layout = ccui.LayoutComponent:bindLayoutComponent(Button_continue)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentX(0.7000)
layout:setPositionPercentY(0.3000)
layout:setPercentWidth(0.3101)
layout:setPercentHeight(0.2009)
layout:setSize({width = 240.0000, height = 91.0000})
layout:setLeftMargin(421.8000)
layout:setRightMargin(112.2000)
layout:setTopMargin(271.6000)
layout:setBottomMargin(90.4000)
bg_dikuang:addChild(Button_continue)

--Create Image_8
local Image_8 = ccui.ImageView:create()
Image_8:ignoreContentAdaptWithSize(false)
Image_8:loadTexture("app/part/xymj/payContinueTip/res/btnImg1.png",0)
Image_8:setLayoutComponentEnabled(true)
Image_8:setName("Image_8")
Image_8:setTag(1840)
Image_8:setCascadeColorEnabled(true)
Image_8:setCascadeOpacityEnabled(true)
Image_8:setPosition(120.0000, 45.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_8)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 240.0000, height = 91.0000})
Button_continue:addChild(Image_8)

--Create Text_3
local Text_3 = ccui.Text:create()
Text_3:ignoreContentAdaptWithSize(true)
Text_3:setTextAreaSize({width = 0, height = 0})
Text_3:setFontSize(30)
Text_3:setString([[未绑定的价格：]])
Text_3:setLayoutComponentEnabled(true)
Text_3:setName("Text_3")
Text_3:setTag(1841)
Text_3:setCascadeColorEnabled(true)
Text_3:setCascadeOpacityEnabled(true)
Text_3:setPosition(261.2954, 289.6758)
Text_3:setTextColor({r = 77, g = 77, b = 77})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_3)
layout:setPositionPercentX(0.3376)
layout:setPositionPercentY(0.6395)
layout:setPercentWidth(0.2713)
layout:setPercentHeight(0.0662)
layout:setSize({width = 210.0000, height = 30.0000})
layout:setLeftMargin(156.2954)
layout:setRightMargin(407.7046)
layout:setTopMargin(148.3242)
layout:setBottomMargin(274.6758)
bg_dikuang:addChild(Text_3)

--Create Text_4
local Text_4 = ccui.Text:create()
Text_4:ignoreContentAdaptWithSize(true)
Text_4:setTextAreaSize({width = 0, height = 0})
Text_4:setFontSize(30)
Text_4:setString([[已绑定的价格：]])
Text_4:setLayoutComponentEnabled(true)
Text_4:setName("Text_4")
Text_4:setTag(1842)
Text_4:setCascadeColorEnabled(true)
Text_4:setCascadeOpacityEnabled(true)
Text_4:setPosition(261.2954, 241.2001)
Text_4:setTextColor({r = 77, g = 77, b = 77})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_4)
layout:setPositionPercentX(0.3376)
layout:setPositionPercentY(0.5325)
layout:setPercentWidth(0.2713)
layout:setPercentHeight(0.0662)
layout:setSize({width = 210.0000, height = 30.0000})
layout:setLeftMargin(156.2954)
layout:setRightMargin(407.7046)
layout:setTopMargin(196.7999)
layout:setBottomMargin(226.2001)
bg_dikuang:addChild(Text_4)

--Create Text_price1
local Text_price1 = ccui.Text:create()
Text_price1:ignoreContentAdaptWithSize(true)
Text_price1:setTextAreaSize({width = 0, height = 0})
Text_price1:setFontSize(30)
Text_price1:setString([[999元]])
Text_price1:setLayoutComponentEnabled(true)
Text_price1:setName("Text_price1")
Text_price1:setTag(1843)
Text_price1:setCascadeColorEnabled(true)
Text_price1:setCascadeOpacityEnabled(true)
Text_price1:setPosition(416.3295, 289.6758)
Text_price1:setTextColor({r = 106, g = 51, b = 10})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_price1)
layout:setPositionPercentX(0.5379)
layout:setPositionPercentY(0.6395)
layout:setPercentWidth(0.0969)
layout:setPercentHeight(0.0662)
layout:setSize({width = 75.0000, height = 30.0000})
layout:setLeftMargin(378.8295)
layout:setRightMargin(320.1705)
layout:setTopMargin(148.3242)
layout:setBottomMargin(274.6758)
bg_dikuang:addChild(Text_price1)

--Create Text_price2
local Text_price2 = ccui.Text:create()
Text_price2:ignoreContentAdaptWithSize(true)
Text_price2:setTextAreaSize({width = 0, height = 0})
Text_price2:setFontSize(30)
Text_price2:setString([[999元]])
Text_price2:setLayoutComponentEnabled(true)
Text_price2:setName("Text_price2")
Text_price2:setTag(1845)
Text_price2:setCascadeColorEnabled(true)
Text_price2:setCascadeOpacityEnabled(true)
Text_price2:setPosition(416.3295, 241.2001)
Text_price2:setTextColor({r = 106, g = 51, b = 10})
layout = ccui.LayoutComponent:bindLayoutComponent(Text_price2)
layout:setPositionPercentX(0.5379)
layout:setPositionPercentY(0.5325)
layout:setPercentWidth(0.0969)
layout:setPercentHeight(0.0662)
layout:setSize({width = 75.0000, height = 30.0000})
layout:setLeftMargin(378.8295)
layout:setRightMargin(320.1705)
layout:setTopMargin(196.7999)
layout:setBottomMargin(226.2001)
bg_dikuang:addChild(Text_price2)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Layer
return result;
end

return Result

