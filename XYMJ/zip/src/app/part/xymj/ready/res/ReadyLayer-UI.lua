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
touch_mask:setTag(65)
touch_mask:setCascadeColorEnabled(true)
touch_mask:setCascadeOpacityEnabled(true)
touch_mask:setPosition(640.0000, 360.0000)
if callBackProvider~=nil then
      touch_mask:addClickEventListener(callBackProvider("ReadyLayer-UI.lua", touch_mask, "MaskClick"))
end
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
bg:loadTexture("app/part/xymj/ready/res/zhuozi.jpg",0)
bg:setLayoutComponentEnabled(true)
bg:setName("bg")
bg:setTag(57)
bg:setCascadeColorEnabled(true)
bg:setCascadeOpacityEnabled(true)
bg:setPosition(640.0000, 360.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(bg)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 1280.0000, height = 720.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(3)
Layer:addChild(bg)

--Create table_logo
local table_logo = ccui.ImageView:create()
table_logo:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/ready/res/ready_picture.plist")
table_logo:loadTexture("app/part/xymj/ready/res/table_logo_327940.png",1)
table_logo:setLayoutComponentEnabled(true)
table_logo:setName("table_logo")
table_logo:setTag(282)
table_logo:setCascadeColorEnabled(true)
table_logo:setCascadeOpacityEnabled(true)
table_logo:setPosition(640.0000, 324.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(table_logo)
layout:setPositionPercentXEnabled(true)
layout:setPositionPercentYEnabled(true)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.4500)
layout:setPercentWidth(0.1953)
layout:setPercentHeight(0.1333)
layout:setSize({width = 250.0000, height = 96.0000})
layout:setLeftMargin(515.0000)
layout:setRightMargin(515.0000)
layout:setTopMargin(348.0000)
layout:setBottomMargin(276.0000)
bg:addChild(table_logo)

--Create ready_img
local ready_img = ccui.ImageView:create()
ready_img:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/ready/res/ready_picture.plist")
ready_img:loadTexture("app/part/xymj/ready/res/wenzi.png",1)
ready_img:setLayoutComponentEnabled(true)
ready_img:setName("ready_img")
ready_img:setTag(82)
ready_img:setCascadeColorEnabled(true)
ready_img:setCascadeOpacityEnabled(true)
ready_img:setPosition(640.0000, 359.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(ready_img)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.4986)
layout:setPercentWidth(0.4586)
layout:setPercentHeight(0.0944)
layout:setSize({width = 587.0000, height = 68.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(1)
layout:setLeftMargin(346.5000)
layout:setRightMargin(346.5000)
layout:setTopMargin(327.0000)
layout:setBottomMargin(325.0000)
bg:addChild(ready_img)

--Create head_bg1
local head_bg1 = ccui.ImageView:create()
head_bg1:ignoreContentAdaptWithSize(false)
head_bg1:loadTexture("app/part/xymj/ready/res/headFrame.png",0)
head_bg1:setLayoutComponentEnabled(true)
head_bg1:setName("head_bg1")
head_bg1:setTag(83)
head_bg1:setCascadeColorEnabled(true)
head_bg1:setCascadeOpacityEnabled(true)
head_bg1:setPosition(640.0000, 112.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(head_bg1)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.1556)
layout:setPercentWidth(0.0812)
layout:setPercentHeight(0.1444)
layout:setSize({width = 104.0000, height = 104.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(1)
layout:setLeftMargin(588.0000)
layout:setRightMargin(588.0000)
layout:setTopMargin(556.0000)
layout:setBottomMargin(60.0000)
Layer:addChild(head_bg1)

--Create head_node1
local head_node1 = cc.Sprite:create("app/part/xymj/ready/res/logo0.png")
head_node1:setName("head_node1")
head_node1:setTag(66)
head_node1:setCascadeColorEnabled(true)
head_node1:setCascadeOpacityEnabled(true)
head_node1:setVisible(false)
head_node1:setPosition(52.0000, 52.0000)
head_node1:setScaleX(0.7700)
head_node1:setScaleY(0.7700)
layout = ccui.LayoutComponent:bindLayoutComponent(head_node1)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.9423)
layout:setPercentHeight(0.9423)
layout:setSize({width = 98.0000, height = 98.0000})
layout:setLeftMargin(3.0000)
layout:setRightMargin(3.0000)
layout:setTopMargin(3.0000)
layout:setBottomMargin(3.0000)
head_node1:setBlendFunc({src = 770, dst = 771})
head_bg1:addChild(head_node1)

--Create name1
local name1 = ccui.Text:create()
name1:ignoreContentAdaptWithSize(true)
name1:setTextAreaSize({width = 0, height = 0})
name1:setFontSize(30)
name1:setString([[]])
name1:setLayoutComponentEnabled(true)
name1:setName("name1")
name1:setTag(67)
name1:setCascadeColorEnabled(true)
name1:setCascadeOpacityEnabled(true)
name1:setAnchorPoint(0.0000, 0.5000)
name1:setPosition(117.0000, 79.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(name1)
layout:setPositionPercentX(1.1939)
layout:setPositionPercentY(0.8061)
layout:setLeftMargin(117.0000)
layout:setRightMargin(-19.0000)
layout:setTopMargin(19.0000)
layout:setBottomMargin(79.0000)
head_node1:addChild(name1)

--Create coin1
local coin1 = ccui.Text:create()
coin1:ignoreContentAdaptWithSize(true)
coin1:setTextAreaSize({width = 0, height = 0})
coin1:setFontSize(20)
coin1:setString([[]])
coin1:setLayoutComponentEnabled(true)
coin1:setName("coin1")
coin1:setTag(68)
coin1:setCascadeColorEnabled(true)
coin1:setCascadeOpacityEnabled(true)
coin1:setAnchorPoint(0.0000, 0.5000)
coin1:setPosition(117.0000, 45.0000)
coin1:setTextColor({r = 249, g = 252, b = 5})
layout = ccui.LayoutComponent:bindLayoutComponent(coin1)
layout:setPositionPercentX(1.1939)
layout:setPositionPercentY(0.4592)
layout:setLeftMargin(117.0000)
layout:setRightMargin(-19.0000)
layout:setTopMargin(53.0000)
layout:setBottomMargin(45.0000)
head_node1:addChild(coin1)

--Create ip1
local ip1 = ccui.Text:create()
ip1:ignoreContentAdaptWithSize(true)
ip1:setTextAreaSize({width = 0, height = 0})
ip1:setFontSize(30)
ip1:setString([[]])
ip1:setLayoutComponentEnabled(true)
ip1:setName("ip1")
ip1:setTag(58)
ip1:setCascadeColorEnabled(true)
ip1:setCascadeOpacityEnabled(true)
ip1:setAnchorPoint(0.0000, 0.5000)
ip1:setPosition(114.1741, 11.2769)
layout = ccui.LayoutComponent:bindLayoutComponent(ip1)
layout:setPositionPercentX(1.1650)
layout:setPositionPercentY(0.1151)
layout:setLeftMargin(114.1741)
layout:setRightMargin(-16.1741)
layout:setTopMargin(86.7231)
layout:setBottomMargin(11.2769)
head_node1:addChild(ip1)

--Create read_icon1
local read_icon1 = ccui.ImageView:create()
read_icon1:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/ready/res/ready_picture.plist")
read_icon1:loadTexture("app/part/xymj/ready/res/wait_zhunbei.png",1)
read_icon1:setLayoutComponentEnabled(true)
read_icon1:setName("read_icon1")
read_icon1:setTag(69)
read_icon1:setCascadeColorEnabled(true)
read_icon1:setCascadeOpacityEnabled(true)
read_icon1:setPosition(-33.0000, 51.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(read_icon1)
layout:setPositionPercentX(-0.3367)
layout:setPositionPercentY(0.5204)
layout:setPercentWidth(0.6531)
layout:setPercentHeight(0.6531)
layout:setSize({width = 64.0000, height = 64.0000})
layout:setLeftMargin(-65.0000)
layout:setRightMargin(99.0000)
layout:setTopMargin(15.0000)
layout:setBottomMargin(19.0000)
head_node1:addChild(read_icon1)

--Create head_bg2
local head_bg2 = ccui.ImageView:create()
head_bg2:ignoreContentAdaptWithSize(false)
head_bg2:loadTexture("app/part/xymj/ready/res/headFrame.png",0)
head_bg2:setLayoutComponentEnabled(true)
head_bg2:setName("head_bg2")
head_bg2:setTag(84)
head_bg2:setCascadeColorEnabled(true)
head_bg2:setCascadeOpacityEnabled(true)
head_bg2:setPosition(1078.0000, 360.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(head_bg2)
layout:setPositionPercentX(0.8422)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.0812)
layout:setPercentHeight(0.1444)
layout:setSize({width = 104.0000, height = 104.0000})
layout:setHorizontalEdge(2)
layout:setLeftMargin(1026.0000)
layout:setRightMargin(150.0000)
layout:setTopMargin(308.0000)
layout:setBottomMargin(308.0000)
Layer:addChild(head_bg2)

--Create head_node2
local head_node2 = cc.Sprite:create("app/part/xymj/ready/res/logo0.png")
head_node2:setName("head_node2")
head_node2:setTag(70)
head_node2:setCascadeColorEnabled(true)
head_node2:setCascadeOpacityEnabled(true)
head_node2:setVisible(false)
head_node2:setPosition(52.0000, 52.0000)
head_node2:setScaleX(0.7700)
head_node2:setScaleY(0.7700)
layout = ccui.LayoutComponent:bindLayoutComponent(head_node2)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.9423)
layout:setPercentHeight(0.9423)
layout:setSize({width = 98.0000, height = 98.0000})
layout:setLeftMargin(3.0000)
layout:setRightMargin(3.0000)
layout:setTopMargin(3.0000)
layout:setBottomMargin(3.0000)
head_node2:setBlendFunc({src = 770, dst = 771})
head_bg2:addChild(head_node2)

--Create name2
local name2 = ccui.Text:create()
name2:ignoreContentAdaptWithSize(true)
name2:setTextAreaSize({width = 0, height = 0})
name2:setFontSize(30)
name2:setString([[]])
name2:setLayoutComponentEnabled(true)
name2:setName("name2")
name2:setTag(71)
name2:setCascadeColorEnabled(true)
name2:setCascadeOpacityEnabled(true)
name2:setAnchorPoint(0.0000, 0.5000)
name2:setPosition(117.0000, 79.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(name2)
layout:setPositionPercentX(1.1939)
layout:setPositionPercentY(0.8061)
layout:setLeftMargin(117.0000)
layout:setRightMargin(-19.0000)
layout:setTopMargin(19.0000)
layout:setBottomMargin(79.0000)
head_node2:addChild(name2)

--Create coin2
local coin2 = ccui.Text:create()
coin2:ignoreContentAdaptWithSize(true)
coin2:setTextAreaSize({width = 0, height = 0})
coin2:setFontSize(20)
coin2:setString([[]])
coin2:setLayoutComponentEnabled(true)
coin2:setName("coin2")
coin2:setTag(72)
coin2:setCascadeColorEnabled(true)
coin2:setCascadeOpacityEnabled(true)
coin2:setAnchorPoint(0.0000, 0.5000)
coin2:setPosition(117.0000, 45.0000)
coin2:setTextColor({r = 249, g = 252, b = 5})
layout = ccui.LayoutComponent:bindLayoutComponent(coin2)
layout:setPositionPercentX(1.1939)
layout:setPositionPercentY(0.4592)
layout:setLeftMargin(117.0000)
layout:setRightMargin(-19.0000)
layout:setTopMargin(53.0000)
layout:setBottomMargin(45.0000)
head_node2:addChild(coin2)

--Create ip2
local ip2 = ccui.Text:create()
ip2:ignoreContentAdaptWithSize(true)
ip2:setTextAreaSize({width = 0, height = 0})
ip2:setFontSize(30)
ip2:setString([[]])
ip2:setLayoutComponentEnabled(true)
ip2:setName("ip2")
ip2:setTag(59)
ip2:setCascadeColorEnabled(true)
ip2:setCascadeOpacityEnabled(true)
ip2:setAnchorPoint(0.0000, 0.5000)
ip2:setPosition(123.9049, 8.8437)
layout = ccui.LayoutComponent:bindLayoutComponent(ip2)
layout:setPositionPercentX(1.2643)
layout:setPositionPercentY(0.0902)
layout:setLeftMargin(123.9049)
layout:setRightMargin(-25.9049)
layout:setTopMargin(89.1563)
layout:setBottomMargin(8.8437)
head_node2:addChild(ip2)

--Create read_icon2
local read_icon2 = ccui.ImageView:create()
read_icon2:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/ready/res/ready_picture.plist")
read_icon2:loadTexture("app/part/xymj/ready/res/wait_zhunbei.png",1)
read_icon2:setLayoutComponentEnabled(true)
read_icon2:setName("read_icon2")
read_icon2:setTag(73)
read_icon2:setCascadeColorEnabled(true)
read_icon2:setCascadeOpacityEnabled(true)
read_icon2:setPosition(-33.0000, 51.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(read_icon2)
layout:setPositionPercentX(-0.3367)
layout:setPositionPercentY(0.5204)
layout:setPercentWidth(0.6531)
layout:setPercentHeight(0.6531)
layout:setSize({width = 64.0000, height = 64.0000})
layout:setLeftMargin(-65.0000)
layout:setRightMargin(99.0000)
layout:setTopMargin(15.0000)
layout:setBottomMargin(19.0000)
head_node2:addChild(read_icon2)

--Create head_bg3
local head_bg3 = ccui.ImageView:create()
head_bg3:ignoreContentAdaptWithSize(false)
head_bg3:loadTexture("app/part/xymj/ready/res/headFrame.png",0)
head_bg3:setLayoutComponentEnabled(true)
head_bg3:setName("head_bg3")
head_bg3:setTag(85)
head_bg3:setCascadeColorEnabled(true)
head_bg3:setCascadeOpacityEnabled(true)
head_bg3:setPosition(640.0000, 608.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(head_bg3)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.8444)
layout:setPercentWidth(0.0812)
layout:setPercentHeight(0.1444)
layout:setSize({width = 104.0000, height = 104.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(2)
layout:setLeftMargin(588.0000)
layout:setRightMargin(588.0000)
layout:setTopMargin(60.0000)
layout:setBottomMargin(556.0000)
Layer:addChild(head_bg3)

--Create head_node3
local head_node3 = cc.Sprite:create("app/part/xymj/ready/res/logo0.png")
head_node3:setName("head_node3")
head_node3:setTag(74)
head_node3:setCascadeColorEnabled(true)
head_node3:setCascadeOpacityEnabled(true)
head_node3:setVisible(false)
head_node3:setPosition(52.0000, 52.0000)
head_node3:setScaleX(0.7700)
head_node3:setScaleY(0.7700)
layout = ccui.LayoutComponent:bindLayoutComponent(head_node3)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.9423)
layout:setPercentHeight(0.9423)
layout:setSize({width = 98.0000, height = 98.0000})
layout:setLeftMargin(3.0000)
layout:setRightMargin(3.0000)
layout:setTopMargin(3.0000)
layout:setBottomMargin(3.0000)
head_node3:setBlendFunc({src = 770, dst = 771})
head_bg3:addChild(head_node3)

--Create name3
local name3 = ccui.Text:create()
name3:ignoreContentAdaptWithSize(true)
name3:setTextAreaSize({width = 0, height = 0})
name3:setFontSize(30)
name3:setString([[]])
name3:setLayoutComponentEnabled(true)
name3:setName("name3")
name3:setTag(75)
name3:setCascadeColorEnabled(true)
name3:setCascadeOpacityEnabled(true)
name3:setAnchorPoint(0.0000, 0.5000)
name3:setPosition(117.0000, 79.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(name3)
layout:setPositionPercentX(1.1939)
layout:setPositionPercentY(0.8061)
layout:setLeftMargin(117.0000)
layout:setRightMargin(-19.0000)
layout:setTopMargin(19.0000)
layout:setBottomMargin(79.0000)
head_node3:addChild(name3)

--Create coin3
local coin3 = ccui.Text:create()
coin3:ignoreContentAdaptWithSize(true)
coin3:setTextAreaSize({width = 0, height = 0})
coin3:setFontSize(20)
coin3:setString([[]])
coin3:setLayoutComponentEnabled(true)
coin3:setName("coin3")
coin3:setTag(76)
coin3:setCascadeColorEnabled(true)
coin3:setCascadeOpacityEnabled(true)
coin3:setAnchorPoint(0.0000, 0.5000)
coin3:setPosition(117.0000, 45.0000)
coin3:setTextColor({r = 249, g = 252, b = 5})
layout = ccui.LayoutComponent:bindLayoutComponent(coin3)
layout:setPositionPercentX(1.1939)
layout:setPositionPercentY(0.4592)
layout:setLeftMargin(117.0000)
layout:setRightMargin(-19.0000)
layout:setTopMargin(53.0000)
layout:setBottomMargin(45.0000)
head_node3:addChild(coin3)

--Create ip3
local ip3 = ccui.Text:create()
ip3:ignoreContentAdaptWithSize(true)
ip3:setTextAreaSize({width = 0, height = 0})
ip3:setFontSize(30)
ip3:setString([[]])
ip3:setLayoutComponentEnabled(true)
ip3:setName("ip3")
ip3:setTag(60)
ip3:setCascadeColorEnabled(true)
ip3:setCascadeOpacityEnabled(true)
ip3:setAnchorPoint(0.0000, 0.5000)
ip3:setPosition(117.1163, 11.3142)
layout = ccui.LayoutComponent:bindLayoutComponent(ip3)
layout:setPositionPercentX(1.1951)
layout:setPositionPercentY(0.1155)
layout:setLeftMargin(117.1163)
layout:setRightMargin(-19.1163)
layout:setTopMargin(86.6858)
layout:setBottomMargin(11.3142)
head_node3:addChild(ip3)

--Create read_icon3
local read_icon3 = ccui.ImageView:create()
read_icon3:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/ready/res/ready_picture.plist")
read_icon3:loadTexture("app/part/xymj/ready/res/wait_zhunbei.png",1)
read_icon3:setLayoutComponentEnabled(true)
read_icon3:setName("read_icon3")
read_icon3:setTag(77)
read_icon3:setCascadeColorEnabled(true)
read_icon3:setCascadeOpacityEnabled(true)
read_icon3:setPosition(-33.0000, 51.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(read_icon3)
layout:setPositionPercentX(-0.3367)
layout:setPositionPercentY(0.5204)
layout:setPercentWidth(0.6531)
layout:setPercentHeight(0.6531)
layout:setSize({width = 64.0000, height = 64.0000})
layout:setLeftMargin(-65.0000)
layout:setRightMargin(99.0000)
layout:setTopMargin(15.0000)
layout:setBottomMargin(19.0000)
head_node3:addChild(read_icon3)

--Create head_bg4
local head_bg4 = ccui.ImageView:create()
head_bg4:ignoreContentAdaptWithSize(false)
head_bg4:loadTexture("app/part/xymj/ready/res/headFrame.png",0)
head_bg4:setLayoutComponentEnabled(true)
head_bg4:setName("head_bg4")
head_bg4:setTag(86)
head_bg4:setCascadeColorEnabled(true)
head_bg4:setCascadeOpacityEnabled(true)
head_bg4:setPosition(202.0000, 360.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(head_bg4)
layout:setPositionPercentX(0.1578)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.0812)
layout:setPercentHeight(0.1444)
layout:setSize({width = 104.0000, height = 104.0000})
layout:setHorizontalEdge(1)
layout:setLeftMargin(150.0000)
layout:setRightMargin(1026.0000)
layout:setTopMargin(308.0000)
layout:setBottomMargin(308.0000)
Layer:addChild(head_bg4)

--Create head_node4
local head_node4 = cc.Sprite:create("app/part/xymj/ready/res/logo0.png")
head_node4:setName("head_node4")
head_node4:setTag(78)
head_node4:setCascadeColorEnabled(true)
head_node4:setCascadeOpacityEnabled(true)
head_node4:setVisible(false)
head_node4:setPosition(52.0000, 52.0000)
head_node4:setScaleX(0.7700)
head_node4:setScaleY(0.7700)
layout = ccui.LayoutComponent:bindLayoutComponent(head_node4)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.9423)
layout:setPercentHeight(0.9423)
layout:setSize({width = 98.0000, height = 98.0000})
layout:setHorizontalEdge(2)
layout:setLeftMargin(3.0000)
layout:setRightMargin(3.0000)
layout:setTopMargin(3.0000)
layout:setBottomMargin(3.0000)
head_node4:setBlendFunc({src = 770, dst = 771})
head_bg4:addChild(head_node4)

--Create name4
local name4 = ccui.Text:create()
name4:ignoreContentAdaptWithSize(true)
name4:setTextAreaSize({width = 0, height = 0})
name4:setFontSize(30)
name4:setString([[]])
name4:setLayoutComponentEnabled(true)
name4:setName("name4")
name4:setTag(79)
name4:setCascadeColorEnabled(true)
name4:setCascadeOpacityEnabled(true)
name4:setAnchorPoint(0.0000, 0.5000)
name4:setPosition(117.0000, 79.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(name4)
layout:setPositionPercentX(1.1939)
layout:setPositionPercentY(0.8061)
layout:setLeftMargin(117.0000)
layout:setRightMargin(-19.0000)
layout:setTopMargin(19.0000)
layout:setBottomMargin(79.0000)
head_node4:addChild(name4)

--Create coin4
local coin4 = ccui.Text:create()
coin4:ignoreContentAdaptWithSize(true)
coin4:setTextAreaSize({width = 0, height = 0})
coin4:setFontSize(20)
coin4:setString([[]])
coin4:setLayoutComponentEnabled(true)
coin4:setName("coin4")
coin4:setTag(80)
coin4:setCascadeColorEnabled(true)
coin4:setCascadeOpacityEnabled(true)
coin4:setAnchorPoint(0.0000, 0.5000)
coin4:setPosition(117.0000, 45.0000)
coin4:setTextColor({r = 249, g = 252, b = 5})
layout = ccui.LayoutComponent:bindLayoutComponent(coin4)
layout:setPositionPercentX(1.1939)
layout:setPositionPercentY(0.4592)
layout:setLeftMargin(117.0000)
layout:setRightMargin(-19.0000)
layout:setTopMargin(53.0000)
layout:setBottomMargin(45.0000)
head_node4:addChild(coin4)

--Create ip4
local ip4 = ccui.Text:create()
ip4:ignoreContentAdaptWithSize(true)
ip4:setTextAreaSize({width = 0, height = 0})
ip4:setFontSize(30)
ip4:setString([[]])
ip4:setLayoutComponentEnabled(true)
ip4:setName("ip4")
ip4:setTag(61)
ip4:setCascadeColorEnabled(true)
ip4:setCascadeOpacityEnabled(true)
ip4:setAnchorPoint(0.0000, 0.5000)
ip4:setPosition(117.1184, 9.7092)
layout = ccui.LayoutComponent:bindLayoutComponent(ip4)
layout:setPositionPercentX(1.1951)
layout:setPositionPercentY(0.0991)
layout:setLeftMargin(117.1184)
layout:setRightMargin(-19.1184)
layout:setTopMargin(88.2908)
layout:setBottomMargin(9.7092)
head_node4:addChild(ip4)

--Create read_icon4
local read_icon4 = ccui.ImageView:create()
read_icon4:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/ready/res/ready_picture.plist")
read_icon4:loadTexture("app/part/xymj/ready/res/wait_zhunbei.png",1)
read_icon4:setLayoutComponentEnabled(true)
read_icon4:setName("read_icon4")
read_icon4:setTag(81)
read_icon4:setCascadeColorEnabled(true)
read_icon4:setCascadeOpacityEnabled(true)
read_icon4:setPosition(-33.0000, 51.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(read_icon4)
layout:setPositionPercentX(-0.3367)
layout:setPositionPercentY(0.5204)
layout:setPercentWidth(0.6531)
layout:setPercentHeight(0.6531)
layout:setSize({width = 64.0000, height = 64.0000})
layout:setLeftMargin(-65.0000)
layout:setRightMargin(99.0000)
layout:setTopMargin(15.0000)
layout:setBottomMargin(19.0000)
head_node4:addChild(read_icon4)

--Create broadcast_node
local broadcast_node=cc.Node:create()
broadcast_node:setName("broadcast_node")
broadcast_node:setTag(361)
broadcast_node:setCascadeColorEnabled(true)
broadcast_node:setCascadeOpacityEnabled(true)
broadcast_node:setPosition(640.0000, 569.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(broadcast_node)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.7903)
layout:setHorizontalEdge(3)
layout:setVerticalEdge(2)
layout:setLeftMargin(640.0000)
layout:setRightMargin(640.0000)
layout:setTopMargin(151.0000)
layout:setBottomMargin(569.0000)
Layer:addChild(broadcast_node)

--Create exit_btn
local exit_btn = ccui.Button:create()
exit_btn:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/ready/res/ready_picture.plist")
exit_btn:loadTextureNormal("app/part/xymj/ready/res/pz_jsfj1.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/ready/res/ready_picture.plist")
exit_btn:loadTexturePressed("app/part/xymj/ready/res/pz_jsfj2.png",1)
exit_btn:loadTextureDisabled("Default/Button_Disable.png",0)
exit_btn:setTitleFontSize(14)
exit_btn:setTitleColor({r = 65, g = 65, b = 70})
exit_btn:setScale9Enabled(true)
exit_btn:setCapInsets({x = 15, y = 11, width = 38, height = 49})
exit_btn:setLayoutComponentEnabled(true)
exit_btn:setName("exit_btn")
exit_btn:setTag(106)
exit_btn:setCascadeColorEnabled(true)
exit_btn:setCascadeOpacityEnabled(true)
exit_btn:setPosition(1210.0000, 655.0000)
if callBackProvider~=nil then
      exit_btn:addClickEventListener(callBackProvider("ReadyLayer-UI.lua", exit_btn, "ExitClick"))
end
layout = ccui.LayoutComponent:bindLayoutComponent(exit_btn)
layout:setPositionPercentX(0.9453)
layout:setPositionPercentY(0.9097)
layout:setPercentWidth(0.0531)
layout:setPercentHeight(0.0986)
layout:setSize({width = 68.0000, height = 71.0000})
layout:setHorizontalEdge(2)
layout:setVerticalEdge(2)
layout:setLeftMargin(1176.0000)
layout:setRightMargin(35.9999)
layout:setTopMargin(29.5000)
layout:setBottomMargin(619.5000)
Layer:addChild(exit_btn)

--Create vip_layer
local vip_layer = ccui.Layout:create()
vip_layer:ignoreContentAdaptWithSize(false)
vip_layer:setClippingEnabled(false)
vip_layer:setBackGroundColorOpacity(90)
vip_layer:setLayoutComponentEnabled(true)
vip_layer:setName("vip_layer")
vip_layer:setTag(95)
vip_layer:setCascadeColorEnabled(true)
vip_layer:setCascadeOpacityEnabled(true)
vip_layer:setVisible(false)
layout = ccui.LayoutComponent:bindLayoutComponent(vip_layer)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 1280.0000, height = 720.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(3)
layout:setStretchWidthEnabled(true)
layout:setStretchHeightEnabled(true)
Layer:addChild(vip_layer)

--Create roomIdBg
local roomIdBg = ccui.ImageView:create()
roomIdBg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/ready/res/ready_picture.plist")
roomIdBg:loadTexture("app/part/xymj/ready/res/leftTopBg.png",1)
roomIdBg:setLayoutComponentEnabled(true)
roomIdBg:setName("roomIdBg")
roomIdBg:setTag(81)
roomIdBg:setCascadeColorEnabled(true)
roomIdBg:setCascadeOpacityEnabled(true)
roomIdBg:setAnchorPoint(0.5000, 1.0000)
roomIdBg:setPosition(145.0002, 720.0001)
layout = ccui.LayoutComponent:bindLayoutComponent(roomIdBg)
layout:setPositionPercentX(0.1133)
layout:setPositionPercentY(1.0000)
layout:setPercentWidth(0.1656)
layout:setPercentHeight(0.0611)
layout:setSize({width = 212.0000, height = 44.0000})
layout:setHorizontalEdge(1)
layout:setVerticalEdge(2)
layout:setLeftMargin(39.0002)
layout:setRightMargin(1029.0000)
layout:setTopMargin(-0.0001)
layout:setBottomMargin(676.0001)
vip_layer:addChild(roomIdBg)

--Create room_id_txt
local room_id_txt = ccui.Text:create()
room_id_txt:ignoreContentAdaptWithSize(true)
room_id_txt:setTextAreaSize({width = 0, height = 0})
room_id_txt:setFontSize(26)
room_id_txt:setString([[房号:111111]])
room_id_txt:setLayoutComponentEnabled(true)
room_id_txt:setName("room_id_txt")
room_id_txt:setTag(96)
room_id_txt:setCascadeColorEnabled(true)
room_id_txt:setCascadeOpacityEnabled(true)
room_id_txt:setPosition(105.0002, 19.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(room_id_txt)
layout:setPositionPercentX(0.4953)
layout:setPositionPercentY(0.4432)
layout:setPercentWidth(0.6462)
layout:setPercentHeight(0.7045)
layout:setSize({width = 137.0000, height = 31.0000})
layout:setHorizontalEdge(1)
layout:setVerticalEdge(2)
layout:setLeftMargin(36.5002)
layout:setRightMargin(38.4998)
layout:setTopMargin(9.0000)
layout:setBottomMargin(4.0000)
roomIdBg:addChild(room_id_txt)

--Create invite_btn
local invite_btn = ccui.Button:create()
invite_btn:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/ready/res/ready_picture.plist")
invite_btn:loadTextureNormal("app/part/xymj/ready/res/pz_wxyq.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/ready/res/ready_picture.plist")
invite_btn:loadTexturePressed("app/part/xymj/ready/res/pz_wxyq.png",1)
invite_btn:loadTextureDisabled("Default/Button_Disable.png",0)
invite_btn:setTitleFontSize(14)
invite_btn:setTitleColor({r = 65, g = 65, b = 70})
invite_btn:setScale9Enabled(true)
invite_btn:setCapInsets({x = 15, y = 11, width = 280, height = 78})
invite_btn:setLayoutComponentEnabled(true)
invite_btn:setName("invite_btn")
invite_btn:setTag(97)
invite_btn:setCascadeColorEnabled(true)
invite_btn:setCascadeOpacityEnabled(true)
invite_btn:setPosition(640.0000, 228.0000)
if callBackProvider~=nil then
      invite_btn:addClickEventListener(callBackProvider("ReadyLayer-UI.lua", invite_btn, "InviteFriendsClick"))
end
layout = ccui.LayoutComponent:bindLayoutComponent(invite_btn)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.3167)
layout:setPercentWidth(0.2422)
layout:setPercentHeight(0.1389)
layout:setSize({width = 310.0000, height = 100.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(1)
layout:setLeftMargin(485.0000)
layout:setRightMargin(485.0000)
layout:setTopMargin(442.0000)
layout:setBottomMargin(178.0000)
vip_layer:addChild(invite_btn)

--Create room_info_txt
local room_info_txt = ccui.Text:create()
room_info_txt:ignoreContentAdaptWithSize(true)
room_info_txt:setTextAreaSize({width = 0, height = 0})
room_info_txt:setFontSize(28)
room_info_txt:setString([[]])
room_info_txt:setLayoutComponentEnabled(true)
room_info_txt:setName("room_info_txt")
room_info_txt:setTag(98)
room_info_txt:setCascadeColorEnabled(true)
room_info_txt:setCascadeOpacityEnabled(true)
room_info_txt:setVisible(false)
room_info_txt:setPosition(640.0000, 414.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(room_info_txt)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5750)
layout:setHorizontalEdge(3)
layout:setVerticalEdge(2)
layout:setLeftMargin(640.0000)
layout:setRightMargin(640.0000)
layout:setTopMargin(306.0000)
layout:setBottomMargin(414.0000)
vip_layer:addChild(room_info_txt)

--Create close_room_btn
local close_room_btn = ccui.Button:create()
close_room_btn:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/ready/res/ready_picture.plist")
close_room_btn:loadTextureNormal("app/part/xymj/ready/res/jiesan_fangjian.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/ready/res/ready_picture.plist")
close_room_btn:loadTexturePressed("app/part/xymj/ready/res/jiesan_fangjian_l.png",1)
close_room_btn:loadTextureDisabled("Default/Button_Disable.png",0)
close_room_btn:setTitleFontSize(14)
close_room_btn:setTitleColor({r = 65, g = 65, b = 70})
close_room_btn:setScale9Enabled(true)
close_room_btn:setCapInsets({x = 15, y = 11, width = 29, height = 39})
close_room_btn:setLayoutComponentEnabled(true)
close_room_btn:setName("close_room_btn")
close_room_btn:setTag(99)
close_room_btn:setCascadeColorEnabled(true)
close_room_btn:setCascadeOpacityEnabled(true)
close_room_btn:setPosition(1210.0000, 500.0000)
if callBackProvider~=nil then
      close_room_btn:addClickEventListener(callBackProvider("ReadyLayer-UI.lua", close_room_btn, "CloseRoomClick"))
end
layout = ccui.LayoutComponent:bindLayoutComponent(close_room_btn)
layout:setPositionPercentX(0.9453)
layout:setPositionPercentY(0.6944)
layout:setPercentWidth(0.0461)
layout:setPercentHeight(0.0847)
layout:setSize({width = 59.0000, height = 61.0000})
layout:setHorizontalEdge(2)
layout:setVerticalEdge(2)
layout:setLeftMargin(1180.5000)
layout:setRightMargin(40.5000)
layout:setTopMargin(189.5000)
layout:setBottomMargin(469.5000)
vip_layer:addChild(close_room_btn)

--Create chat_btn
local chat_btn = ccui.Button:create()
chat_btn:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/ready/res/ready_picture.plist")
chat_btn:loadTextureNormal("app/part/xymj/ready/res/pz_lt1.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/ready/res/ready_picture.plist")
chat_btn:loadTexturePressed("app/part/xymj/ready/res/pz_lt2.png",1)
chat_btn:loadTextureDisabled("Default/Button_Disable.png",0)
chat_btn:setTitleFontSize(14)
chat_btn:setTitleColor({r = 65, g = 65, b = 70})
chat_btn:setScale9Enabled(true)
chat_btn:setCapInsets({x = 15, y = 11, width = 38, height = 49})
chat_btn:setLayoutComponentEnabled(true)
chat_btn:setName("chat_btn")
chat_btn:setTag(247)
chat_btn:setCascadeColorEnabled(true)
chat_btn:setCascadeOpacityEnabled(true)
chat_btn:setPosition(1210.0000, 580.0000)
if callBackProvider~=nil then
      chat_btn:addClickEventListener(callBackProvider("ReadyLayer-UI.lua", chat_btn, "ChatClick"))
end
layout = ccui.LayoutComponent:bindLayoutComponent(chat_btn)
layout:setPositionPercentX(0.9453)
layout:setPositionPercentY(0.8056)
layout:setPercentWidth(0.0531)
layout:setPercentHeight(0.0986)
layout:setSize({width = 68.0000, height = 71.0000})
layout:setHorizontalEdge(2)
layout:setLeftMargin(1176.0000)
layout:setRightMargin(36.0000)
layout:setTopMargin(104.5000)
layout:setBottomMargin(544.5000)
Layer:addChild(chat_btn)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Layer
return result;
end

return Result

