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

--Create root
local root = ccui.Layout:create()
root:ignoreContentAdaptWithSize(false)
root:setClippingEnabled(false)
root:setBackGroundColorOpacity(102)
root:setTouchEnabled(true);
root:setLayoutComponentEnabled(true)
root:setName("root")
root:setTag(41)
root:setCascadeColorEnabled(true)
root:setCascadeOpacityEnabled(true)
root:setAnchorPoint(0.5000, 0.5000)
root:setPosition(640.0000, 360.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(root)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 1280.0000, height = 720.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(3)
Layer:addChild(root)

--Create award_root
local award_root = ccui.Layout:create()
award_root:ignoreContentAdaptWithSize(false)
award_root:setClippingEnabled(false)
award_root:setBackGroundColorOpacity(102)
award_root:setTouchEnabled(true);
award_root:setLayoutComponentEnabled(true)
award_root:setName("award_root")
award_root:setTag(36)
award_root:setCascadeColorEnabled(true)
award_root:setCascadeOpacityEnabled(true)
award_root:setAnchorPoint(0.5000, 0.5000)
award_root:setPosition(640.0000, 360.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(award_root)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 1280.0000, height = 720.0000})
root:addChild(award_root)

--Create award_bg
local award_bg = ccui.ImageView:create()
award_bg:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/mjmatch/winMatch/res/winMatch_picture.plist")
award_bg:loadTexture("app/part/xymj/mjmatch/winMatch/res/award_bg.png",1)
award_bg:setLayoutComponentEnabled(true)
award_bg:setName("award_bg")
award_bg:setTag(62)
award_bg:setCascadeColorEnabled(true)
award_bg:setCascadeOpacityEnabled(true)
award_bg:setPosition(640.0000, 309.8880)
layout = ccui.LayoutComponent:bindLayoutComponent(award_bg)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.4304)
layout:setPercentWidth(0.3555)
layout:setPercentHeight(0.4056)
layout:setSize({width = 455.0000, height = 292.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(3)
layout:setLeftMargin(412.5000)
layout:setRightMargin(412.5000)
layout:setTopMargin(264.1120)
layout:setBottomMargin(163.8880)
award_root:addChild(award_bg)

--Create award_tips
local award_tips = ccui.ImageView:create()
award_tips:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/mjmatch/winMatch/res/winMatch_picture.plist")
award_tips:loadTexture("app/part/xymj/mjmatch/winMatch/res/award.png",1)
award_tips:setLayoutComponentEnabled(true)
award_tips:setName("award_tips")
award_tips:setTag(34)
award_tips:setCascadeColorEnabled(true)
award_tips:setCascadeOpacityEnabled(true)
award_tips:setPosition(640.0000, 288.5040)
layout = ccui.LayoutComponent:bindLayoutComponent(award_tips)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.4007)
layout:setPercentWidth(0.1805)
layout:setPercentHeight(0.0431)
layout:setSize({width = 231.0000, height = 31.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(3)
layout:setLeftMargin(524.5000)
layout:setRightMargin(524.5000)
layout:setTopMargin(415.9960)
layout:setBottomMargin(273.0040)
award_root:addChild(award_tips)

--Create effect_root
local effect_root = ccui.Layout:create()
effect_root:ignoreContentAdaptWithSize(false)
effect_root:setClippingEnabled(false)
effect_root:setBackGroundColorOpacity(102)
effect_root:setTouchEnabled(true);
effect_root:setLayoutComponentEnabled(true)
effect_root:setName("effect_root")
effect_root:setTag(63)
effect_root:setCascadeColorEnabled(true)
effect_root:setCascadeOpacityEnabled(true)
effect_root:setAnchorPoint(0.5000, 0.5000)
effect_root:setPosition(640.0000, 360.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(effect_root)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 1280.0000, height = 720.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(3)
root:addChild(effect_root)

--Create btn_root
local btn_root = ccui.Layout:create()
btn_root:ignoreContentAdaptWithSize(false)
btn_root:setClippingEnabled(false)
btn_root:setBackGroundColorOpacity(102)
btn_root:setTouchEnabled(true);
btn_root:setLayoutComponentEnabled(true)
btn_root:setName("btn_root")
btn_root:setTag(37)
btn_root:setCascadeColorEnabled(true)
btn_root:setCascadeOpacityEnabled(true)
btn_root:setAnchorPoint(0.5000, 0.5000)
btn_root:setPosition(640.0000, 360.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_root)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 1280.0000, height = 720.0000})
root:addChild(btn_root)

--Create share
local share = ccui.Button:create()
share:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/mjmatch/readyMatch/res/readyMatch_picture.plist")
share:loadTextureNormal("app/part/xymj/mjmatch/readyMatch/res/btn_normal_green.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/mjmatch/readyMatch/res/readyMatch_picture.plist")
share:loadTexturePressed("app/part/xymj/mjmatch/readyMatch/res/btn_click_green.png",1)
share:loadTextureDisabled("Default/Button_Disable.png",0)
share:setTitleFontSize(14)
share:setTitleColor({r = 65, g = 65, b = 70})
share:setScale9Enabled(true)
share:setCapInsets({x = 15, y = 11, width = 176, height = 57})
share:setLayoutComponentEnabled(true)
share:setName("share")
share:setTag(29)
share:setCascadeColorEnabled(true)
share:setCascadeOpacityEnabled(true)
share:setPosition(790.2720, 106.4057)
if callBackProvider~=nil then
      share:addClickEventListener(callBackProvider("winMatchLayer-UI.lua", share, "onXuanYao"))
end
layout = ccui.LayoutComponent:bindLayoutComponent(share)
layout:setPositionPercentX(0.6174)
layout:setPositionPercentY(0.1478)
layout:setPercentWidth(0.1609)
layout:setPercentHeight(0.1097)
layout:setSize({width = 206.0000, height = 79.0000})
layout:setHorizontalEdge(3)
layout:setLeftMargin(687.2720)
layout:setRightMargin(386.7280)
layout:setTopMargin(574.0943)
layout:setBottomMargin(66.9057)
btn_root:addChild(share)

--Create Image_2
local Image_2 = ccui.ImageView:create()
Image_2:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/mjmatch/winMatch/res/winMatch_picture.plist")
Image_2:loadTexture("app/part/xymj/mjmatch/winMatch/res/share.png",1)
Image_2:setLayoutComponentEnabled(true)
Image_2:setName("Image_2")
Image_2:setTag(32)
Image_2:setCascadeColorEnabled(true)
Image_2:setCascadeOpacityEnabled(true)
Image_2:setPosition(101.1048, 39.6124)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_2)
layout:setPositionPercentX(0.4908)
layout:setPositionPercentY(0.5014)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 206.0000, height = 79.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(1)
layout:setLeftMargin(-1.8952)
layout:setRightMargin(1.8952)
layout:setTopMargin(-0.1124)
layout:setBottomMargin(0.1124)
share:addChild(Image_2)

--Create sure
local sure = ccui.Button:create()
sure:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/mjmatch/readyMatch/res/readyMatch_picture.plist")
sure:loadTextureNormal("app/part/xymj/mjmatch/readyMatch/res/btn_normal_yellow.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/mjmatch/readyMatch/res/readyMatch_picture.plist")
sure:loadTexturePressed("app/part/xymj/mjmatch/readyMatch/res/btn_click_yellow.png",1)
sure:loadTextureDisabled("Default/Button_Disable.png",0)
sure:setTitleFontSize(14)
sure:setTitleColor({r = 65, g = 65, b = 70})
sure:setScale9Enabled(true)
sure:setCapInsets({x = 15, y = 11, width = 176, height = 57})
sure:setLayoutComponentEnabled(true)
sure:setName("sure")
sure:setTag(30)
sure:setCascadeColorEnabled(true)
sure:setCascadeOpacityEnabled(true)
sure:setPosition(507.6480, 107.1763)
if callBackProvider~=nil then
      sure:addClickEventListener(callBackProvider("winMatchLayer-UI.lua", sure, "onSureClick"))
end
layout = ccui.LayoutComponent:bindLayoutComponent(sure)
layout:setPositionPercentX(0.3966)
layout:setPositionPercentY(0.1489)
layout:setPercentWidth(0.1609)
layout:setPercentHeight(0.1097)
layout:setSize({width = 206.0000, height = 79.0000})
layout:setHorizontalEdge(3)
layout:setLeftMargin(404.6480)
layout:setRightMargin(669.3520)
layout:setTopMargin(573.3237)
layout:setBottomMargin(67.6763)
btn_root:addChild(sure)

--Create Image_3
local Image_3 = ccui.ImageView:create()
Image_3:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/mjmatch/winMatch/res/winMatch_picture.plist")
Image_3:loadTexture("app/part/xymj/mjmatch/winMatch/res/font_sure.png",1)
Image_3:setLayoutComponentEnabled(true)
Image_3:setName("Image_3")
Image_3:setTag(33)
Image_3:setCascadeColorEnabled(true)
Image_3:setCascadeOpacityEnabled(true)
Image_3:setPosition(102.6704, 38.8293)
if callBackProvider~=nil then
      Image_3:addClickEventListener(callBackProvider("winMatchLayer-UI.lua", Image_3, "onSureClick"))
end
layout = ccui.LayoutComponent:bindLayoutComponent(Image_3)
layout:setPositionPercentX(0.4984)
layout:setPositionPercentY(0.4915)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 206.0000, height = 79.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(1)
layout:setLeftMargin(-0.3296)
layout:setRightMargin(0.3296)
layout:setTopMargin(0.6707)
layout:setBottomMargin(-0.6707)
sure:addChild(Image_3)

--Create top_panel
local top_panel = ccui.Layout:create()
top_panel:ignoreContentAdaptWithSize(false)
top_panel:setClippingEnabled(false)
top_panel:setBackGroundColorOpacity(102)
top_panel:setTouchEnabled(true);
top_panel:setLayoutComponentEnabled(true)
top_panel:setName("top_panel")
top_panel:setTag(37)
top_panel:setCascadeColorEnabled(true)
top_panel:setCascadeOpacityEnabled(true)
top_panel:setAnchorPoint(0.5000, 0.5000)
top_panel:setPosition(640.0000, 373.4640)
layout = ccui.LayoutComponent:bindLayoutComponent(top_panel)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5187)
layout:setPercentWidth(0.2344)
layout:setPercentHeight(0.1389)
layout:setSize({width = 300.0000, height = 100.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(3)
layout:setLeftMargin(490.0000)
layout:setRightMargin(490.0000)
layout:setTopMargin(296.5360)
layout:setBottomMargin(323.4640)
root:addChild(top_panel)

--Create Image_5
local Image_5 = ccui.ImageView:create()
Image_5:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/mjmatch/winMatch/res/winMatch_picture.plist")
Image_5:loadTexture("app/part/xymj/mjmatch/winMatch/res/di.png",1)
Image_5:setLayoutComponentEnabled(true)
Image_5:setName("Image_5")
Image_5:setTag(35)
Image_5:setCascadeColorEnabled(true)
Image_5:setCascadeOpacityEnabled(true)
Image_5:setPosition(40.3400, 46.5777)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_5)
layout:setPositionPercentX(0.1345)
layout:setPositionPercentY(0.4658)
layout:setPercentWidth(0.2433)
layout:setPercentHeight(0.7200)
layout:setSize({width = 73.0000, height = 72.0000})
layout:setLeftMargin(3.8400)
layout:setRightMargin(223.1600)
layout:setTopMargin(17.4223)
layout:setBottomMargin(10.5777)
top_panel:addChild(Image_5)

--Create Image_6
local Image_6 = ccui.ImageView:create()
Image_6:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/mjmatch/winMatch/res/winMatch_picture.plist")
Image_6:loadTexture("app/part/xymj/mjmatch/winMatch/res/ming.png",1)
Image_6:setLayoutComponentEnabled(true)
Image_6:setName("Image_6")
Image_6:setTag(36)
Image_6:setCascadeColorEnabled(true)
Image_6:setCascadeOpacityEnabled(true)
Image_6:setPosition(260.0000, 44.7204)
layout = ccui.LayoutComponent:bindLayoutComponent(Image_6)
layout:setPositionPercentX(0.8667)
layout:setPositionPercentY(0.4472)
layout:setPercentWidth(0.2433)
layout:setPercentHeight(0.7200)
layout:setSize({width = 73.0000, height = 72.0000})
layout:setLeftMargin(223.5000)
layout:setRightMargin(3.5000)
layout:setTopMargin(19.2796)
layout:setBottomMargin(8.7204)
top_panel:addChild(Image_6)

--Create top_mumber
local top_mumber = ccui.TextAtlas:create([[22]],
													"app/part/xymj/mjmatch/winMatch/res/number2.png",
													74,
													98,
													"0")
top_mumber:setLayoutComponentEnabled(true)
top_mumber:setName("top_mumber")
top_mumber:setTag(38)
top_mumber:setCascadeColorEnabled(true)
top_mumber:setCascadeOpacityEnabled(true)
top_mumber:setPosition(150.0000, 51.3401)
layout = ccui.LayoutComponent:bindLayoutComponent(top_mumber)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5134)
layout:setPercentWidth(0.4933)
layout:setPercentHeight(0.9800)
layout:setSize({width = 148.0000, height = 98.0000})
layout:setLeftMargin(76.0000)
layout:setRightMargin(76.0000)
layout:setTopMargin(-0.3401)
layout:setBottomMargin(2.3401)
top_panel:addChild(top_mumber)

--Create item_root_1
local item_root_1 = ccui.Layout:create()
item_root_1:ignoreContentAdaptWithSize(false)
item_root_1:setClippingEnabled(false)
item_root_1:setBackGroundColorOpacity(102)
item_root_1:setTouchEnabled(true);
item_root_1:setLayoutComponentEnabled(true)
item_root_1:setName("item_root_1")
item_root_1:setTag(39)
item_root_1:setCascadeColorEnabled(true)
item_root_1:setCascadeOpacityEnabled(true)
item_root_1:setAnchorPoint(0.5000, 0.5000)
item_root_1:setPosition(-424.7717, 216.4000)
layout = ccui.LayoutComponent:bindLayoutComponent(item_root_1)
layout:setPositionPercentX(-0.3319)
layout:setPositionPercentY(0.3006)
layout:setPercentWidth(0.0781)
layout:setPercentHeight(0.1389)
layout:setSize({width = 100.0000, height = 100.0000})
layout:setLeftMargin(-474.7717)
layout:setRightMargin(1654.7720)
layout:setTopMargin(453.6000)
layout:setBottomMargin(166.4000)
root:addChild(item_root_1)

--Create item_bg_1
local item_bg_1 = ccui.ImageView:create()
item_bg_1:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/mjmatch/winMatch/res/winMatch_picture.plist")
item_bg_1:loadTexture("app/part/xymj/mjmatch/winMatch/res/item_bg.png",1)
item_bg_1:setLayoutComponentEnabled(true)
item_bg_1:setName("item_bg_1")
item_bg_1:setTag(40)
item_bg_1:setCascadeColorEnabled(true)
item_bg_1:setCascadeOpacityEnabled(true)
item_bg_1:setPosition(50.0000, 50.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(item_bg_1)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.0000)
layout:setPercentHeight(1.0000)
layout:setSize({width = 100.0000, height = 100.0000})
item_root_1:addChild(item_bg_1)

--Create item_1
local item_1 = ccui.ImageView:create()
item_1:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/mjmatch/winMatch/res/winMatch_picture.plist")
item_1:loadTexture("app/part/xymj/mjmatch/winMatch/res/item_gold.png",1)
item_1:setLayoutComponentEnabled(true)
item_1:setName("item_1")
item_1:setTag(41)
item_1:setCascadeColorEnabled(true)
item_1:setCascadeOpacityEnabled(true)
item_1:setPosition(50.0001, 47.6977)
layout = ccui.LayoutComponent:bindLayoutComponent(item_1)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.4770)
layout:setPercentWidth(0.5000)
layout:setPercentHeight(0.5500)
layout:setSize({width = 50.0000, height = 55.0000})
layout:setLeftMargin(25.0001)
layout:setRightMargin(24.9999)
layout:setTopMargin(24.8023)
layout:setBottomMargin(20.1977)
item_root_1:addChild(item_1)

--Create item_number_1
local item_number_1 = ccui.TextAtlas:create([[01112]],
													"app/part/xymj/mjmatch/winMatch/res/number.png",
													21,
													28,
													"/")
item_number_1:setLayoutComponentEnabled(true)
item_number_1:setName("item_number_1")
item_number_1:setTag(43)
item_number_1:setCascadeColorEnabled(true)
item_number_1:setCascadeOpacityEnabled(true)
item_number_1:setPosition(50.0006, 10.4790)
layout = ccui.LayoutComponent:bindLayoutComponent(item_number_1)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.1048)
layout:setPercentWidth(1.0500)
layout:setPercentHeight(0.2800)
layout:setSize({width = 105.0000, height = 28.0000})
layout:setLeftMargin(-2.4994)
layout:setRightMargin(-2.5006)
layout:setTopMargin(75.5210)
layout:setBottomMargin(-3.5210)
item_root_1:addChild(item_number_1)

--Create item_root_2
local item_root_2 = ccui.Layout:create()
item_root_2:ignoreContentAdaptWithSize(false)
item_root_2:setClippingEnabled(false)
item_root_2:setBackGroundColorOpacity(102)
item_root_2:setTouchEnabled(true);
item_root_2:setLayoutComponentEnabled(true)
item_root_2:setName("item_root_2")
item_root_2:setTag(44)
item_root_2:setCascadeColorEnabled(true)
item_root_2:setCascadeOpacityEnabled(true)
item_root_2:setAnchorPoint(0.5000, 0.5000)
item_root_2:setPosition(-423.9286, 102.5919)
layout = ccui.LayoutComponent:bindLayoutComponent(item_root_2)
layout:setPositionPercentX(-0.3312)
layout:setPositionPercentY(0.1425)
layout:setPercentWidth(0.1797)
layout:setPercentHeight(0.1389)
layout:setSize({width = 230.0000, height = 100.0000})
layout:setLeftMargin(-538.9286)
layout:setRightMargin(1588.9290)
layout:setTopMargin(567.4081)
layout:setBottomMargin(52.5919)
root:addChild(item_root_2)

--Create item_bg_1
local item_bg_1 = ccui.ImageView:create()
item_bg_1:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/mjmatch/winMatch/res/winMatch_picture.plist")
item_bg_1:loadTexture("app/part/xymj/mjmatch/winMatch/res/item_bg.png",1)
item_bg_1:setLayoutComponentEnabled(true)
item_bg_1:setName("item_bg_1")
item_bg_1:setTag(45)
item_bg_1:setCascadeColorEnabled(true)
item_bg_1:setCascadeOpacityEnabled(true)
item_bg_1:setPosition(50.0000, 50.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(item_bg_1)
layout:setPositionPercentX(0.2174)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.4348)
layout:setPercentHeight(1.0000)
layout:setSize({width = 100.0000, height = 100.0000})
layout:setRightMargin(130.0000)
item_root_2:addChild(item_bg_1)

--Create item_1
local item_1 = ccui.ImageView:create()
item_1:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/mjmatch/winMatch/res/winMatch_picture.plist")
item_1:loadTexture("app/part/xymj/mjmatch/winMatch/res/item_gold.png",1)
item_1:setLayoutComponentEnabled(true)
item_1:setName("item_1")
item_1:setTag(46)
item_1:setCascadeColorEnabled(true)
item_1:setCascadeOpacityEnabled(true)
item_1:setPosition(50.0001, 47.6982)
layout = ccui.LayoutComponent:bindLayoutComponent(item_1)
layout:setPositionPercentX(0.2174)
layout:setPositionPercentY(0.4770)
layout:setPercentWidth(0.2174)
layout:setPercentHeight(0.5500)
layout:setSize({width = 50.0000, height = 55.0000})
layout:setLeftMargin(25.0001)
layout:setRightMargin(154.9999)
layout:setTopMargin(24.8018)
layout:setBottomMargin(20.1982)
item_root_2:addChild(item_1)

--Create item_number_1
local item_number_1 = ccui.TextAtlas:create([[01112]],
													"app/part/xymj/mjmatch/winMatch/res/number.png",
													21,
													28,
													"/")
item_number_1:setLayoutComponentEnabled(true)
item_number_1:setName("item_number_1")
item_number_1:setTag(47)
item_number_1:setCascadeColorEnabled(true)
item_number_1:setCascadeOpacityEnabled(true)
item_number_1:setPosition(50.0005, 10.4796)
layout = ccui.LayoutComponent:bindLayoutComponent(item_number_1)
layout:setPositionPercentX(0.2174)
layout:setPositionPercentY(0.1048)
layout:setPercentWidth(0.4565)
layout:setPercentHeight(0.2800)
layout:setSize({width = 105.0000, height = 28.0000})
layout:setLeftMargin(-2.4995)
layout:setRightMargin(127.4995)
layout:setTopMargin(75.5204)
layout:setBottomMargin(-3.5204)
item_root_2:addChild(item_number_1)

--Create item_bg_2
local item_bg_2 = ccui.ImageView:create()
item_bg_2:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/mjmatch/winMatch/res/winMatch_picture.plist")
item_bg_2:loadTexture("app/part/xymj/mjmatch/winMatch/res/item_bg.png",1)
item_bg_2:setLayoutComponentEnabled(true)
item_bg_2:setName("item_bg_2")
item_bg_2:setTag(48)
item_bg_2:setCascadeColorEnabled(true)
item_bg_2:setCascadeOpacityEnabled(true)
item_bg_2:setPosition(179.0787, 50.6862)
layout = ccui.LayoutComponent:bindLayoutComponent(item_bg_2)
layout:setPositionPercentX(0.7786)
layout:setPositionPercentY(0.5069)
layout:setPercentWidth(0.4348)
layout:setPercentHeight(1.0000)
layout:setSize({width = 100.0000, height = 100.0000})
layout:setLeftMargin(129.0787)
layout:setRightMargin(0.9213)
layout:setTopMargin(-0.6862)
layout:setBottomMargin(0.6862)
item_root_2:addChild(item_bg_2)

--Create item_2
local item_2 = ccui.ImageView:create()
item_2:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/mjmatch/winMatch/res/winMatch_picture.plist")
item_2:loadTexture("app/part/xymj/mjmatch/winMatch/res/item_gold.png",1)
item_2:setLayoutComponentEnabled(true)
item_2:setName("item_2")
item_2:setTag(49)
item_2:setCascadeColorEnabled(true)
item_2:setCascadeOpacityEnabled(true)
item_2:setPosition(179.0782, 48.3843)
layout = ccui.LayoutComponent:bindLayoutComponent(item_2)
layout:setPositionPercentX(0.7786)
layout:setPositionPercentY(0.4838)
layout:setPercentWidth(0.2174)
layout:setPercentHeight(0.5500)
layout:setSize({width = 50.0000, height = 55.0000})
layout:setLeftMargin(154.0782)
layout:setRightMargin(25.9218)
layout:setTopMargin(24.1157)
layout:setBottomMargin(20.8843)
item_root_2:addChild(item_2)

--Create item_number_2
local item_number_2 = ccui.TextAtlas:create([[/1112]],
													"app/part/xymj/mjmatch/winMatch/res/number.png",
													21,
													28,
													"/")
item_number_2:setLayoutComponentEnabled(true)
item_number_2:setName("item_number_2")
item_number_2:setTag(50)
item_number_2:setCascadeColorEnabled(true)
item_number_2:setCascadeOpacityEnabled(true)
item_number_2:setPosition(179.0790, 11.1656)
layout = ccui.LayoutComponent:bindLayoutComponent(item_number_2)
layout:setPositionPercentX(0.7786)
layout:setPositionPercentY(0.1117)
layout:setPercentWidth(0.4565)
layout:setPercentHeight(0.2800)
layout:setSize({width = 105.0000, height = 28.0000})
layout:setLeftMargin(126.5790)
layout:setRightMargin(-1.5790)
layout:setTopMargin(74.8344)
layout:setBottomMargin(-2.8344)
item_root_2:addChild(item_number_2)

--Create item_root_3
local item_root_3 = ccui.Layout:create()
item_root_3:ignoreContentAdaptWithSize(false)
item_root_3:setClippingEnabled(false)
item_root_3:setBackGroundColorOpacity(102)
item_root_3:setTouchEnabled(true);
item_root_3:setLayoutComponentEnabled(true)
item_root_3:setName("item_root_3")
item_root_3:setTag(51)
item_root_3:setCascadeColorEnabled(true)
item_root_3:setCascadeOpacityEnabled(true)
item_root_3:setAnchorPoint(0.5000, 0.5000)
item_root_3:setPosition(-415.4529, -11.2170)
layout = ccui.LayoutComponent:bindLayoutComponent(item_root_3)
layout:setPositionPercentX(-0.3246)
layout:setPositionPercentY(-0.0156)
layout:setPercentWidth(0.2813)
layout:setPercentHeight(0.1389)
layout:setSize({width = 360.0000, height = 100.0000})
layout:setLeftMargin(-595.4529)
layout:setRightMargin(1515.4530)
layout:setTopMargin(681.2170)
layout:setBottomMargin(-61.2170)
root:addChild(item_root_3)

--Create item_bg_1
local item_bg_1 = ccui.ImageView:create()
item_bg_1:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/mjmatch/winMatch/res/winMatch_picture.plist")
item_bg_1:loadTexture("app/part/xymj/mjmatch/winMatch/res/item_bg.png",1)
item_bg_1:setLayoutComponentEnabled(true)
item_bg_1:setName("item_bg_1")
item_bg_1:setTag(52)
item_bg_1:setCascadeColorEnabled(true)
item_bg_1:setCascadeOpacityEnabled(true)
item_bg_1:setPosition(50.0000, 50.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(item_bg_1)
layout:setPositionPercentX(0.1389)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.2778)
layout:setPercentHeight(1.0000)
layout:setSize({width = 100.0000, height = 100.0000})
layout:setRightMargin(260.0000)
item_root_3:addChild(item_bg_1)

--Create item_1
local item_1 = ccui.ImageView:create()
item_1:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/mjmatch/winMatch/res/winMatch_picture.plist")
item_1:loadTexture("app/part/xymj/mjmatch/winMatch/res/item_gold.png",1)
item_1:setLayoutComponentEnabled(true)
item_1:setName("item_1")
item_1:setTag(53)
item_1:setCascadeColorEnabled(true)
item_1:setCascadeOpacityEnabled(true)
item_1:setPosition(50.0001, 47.6980)
layout = ccui.LayoutComponent:bindLayoutComponent(item_1)
layout:setPositionPercentX(0.1389)
layout:setPositionPercentY(0.4770)
layout:setPercentWidth(0.1389)
layout:setPercentHeight(0.5500)
layout:setSize({width = 50.0000, height = 55.0000})
layout:setLeftMargin(25.0001)
layout:setRightMargin(284.9999)
layout:setTopMargin(24.8020)
layout:setBottomMargin(20.1980)
item_root_3:addChild(item_1)

--Create item_number_1
local item_number_1 = ccui.TextAtlas:create([[01112]],
													"app/part/xymj/mjmatch/winMatch/res/number.png",
													21,
													28,
													"/")
item_number_1:setLayoutComponentEnabled(true)
item_number_1:setName("item_number_1")
item_number_1:setTag(54)
item_number_1:setCascadeColorEnabled(true)
item_number_1:setCascadeOpacityEnabled(true)
item_number_1:setPosition(50.0006, 10.4794)
layout = ccui.LayoutComponent:bindLayoutComponent(item_number_1)
layout:setPositionPercentX(0.1389)
layout:setPositionPercentY(0.1048)
layout:setPercentWidth(0.2917)
layout:setPercentHeight(0.2800)
layout:setSize({width = 105.0000, height = 28.0000})
layout:setLeftMargin(-2.4994)
layout:setRightMargin(257.4994)
layout:setTopMargin(75.5206)
layout:setBottomMargin(-3.5206)
item_root_3:addChild(item_number_1)

--Create item_bg_2
local item_bg_2 = ccui.ImageView:create()
item_bg_2:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/mjmatch/winMatch/res/winMatch_picture.plist")
item_bg_2:loadTexture("app/part/xymj/mjmatch/winMatch/res/item_bg.png",1)
item_bg_2:setLayoutComponentEnabled(true)
item_bg_2:setName("item_bg_2")
item_bg_2:setTag(55)
item_bg_2:setCascadeColorEnabled(true)
item_bg_2:setCascadeOpacityEnabled(true)
item_bg_2:setPosition(179.0787, 50.6862)
layout = ccui.LayoutComponent:bindLayoutComponent(item_bg_2)
layout:setPositionPercentX(0.4974)
layout:setPositionPercentY(0.5069)
layout:setPercentWidth(0.2778)
layout:setPercentHeight(1.0000)
layout:setSize({width = 100.0000, height = 100.0000})
layout:setLeftMargin(129.0787)
layout:setRightMargin(130.9213)
layout:setTopMargin(-0.6862)
layout:setBottomMargin(0.6862)
item_root_3:addChild(item_bg_2)

--Create item_2
local item_2 = ccui.ImageView:create()
item_2:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/mjmatch/winMatch/res/winMatch_picture.plist")
item_2:loadTexture("app/part/xymj/mjmatch/winMatch/res/item_gold.png",1)
item_2:setLayoutComponentEnabled(true)
item_2:setName("item_2")
item_2:setTag(56)
item_2:setCascadeColorEnabled(true)
item_2:setCascadeOpacityEnabled(true)
item_2:setPosition(179.0783, 48.3842)
layout = ccui.LayoutComponent:bindLayoutComponent(item_2)
layout:setPositionPercentX(0.4974)
layout:setPositionPercentY(0.4838)
layout:setPercentWidth(0.1389)
layout:setPercentHeight(0.5500)
layout:setSize({width = 50.0000, height = 55.0000})
layout:setLeftMargin(154.0783)
layout:setRightMargin(155.9217)
layout:setTopMargin(24.1158)
layout:setBottomMargin(20.8842)
item_root_3:addChild(item_2)

--Create item_number_2
local item_number_2 = ccui.TextAtlas:create([[01112]],
													"app/part/xymj/mjmatch/winMatch/res/number.png",
													21,
													28,
													"/")
item_number_2:setLayoutComponentEnabled(true)
item_number_2:setName("item_number_2")
item_number_2:setTag(57)
item_number_2:setCascadeColorEnabled(true)
item_number_2:setCascadeOpacityEnabled(true)
item_number_2:setPosition(179.0790, 11.1655)
layout = ccui.LayoutComponent:bindLayoutComponent(item_number_2)
layout:setPositionPercentX(0.4974)
layout:setPositionPercentY(0.1117)
layout:setPercentWidth(0.2917)
layout:setPercentHeight(0.2800)
layout:setSize({width = 105.0000, height = 28.0000})
layout:setLeftMargin(126.5790)
layout:setRightMargin(128.4210)
layout:setTopMargin(74.8345)
layout:setBottomMargin(-2.8345)
item_root_3:addChild(item_number_2)

--Create item_bg_3
local item_bg_3 = ccui.ImageView:create()
item_bg_3:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/mjmatch/winMatch/res/winMatch_picture.plist")
item_bg_3:loadTexture("app/part/xymj/mjmatch/winMatch/res/item_bg.png",1)
item_bg_3:setLayoutComponentEnabled(true)
item_bg_3:setName("item_bg_3")
item_bg_3:setTag(58)
item_bg_3:setCascadeColorEnabled(true)
item_bg_3:setCascadeOpacityEnabled(true)
item_bg_3:setPosition(307.5747, 51.3725)
layout = ccui.LayoutComponent:bindLayoutComponent(item_bg_3)
layout:setPositionPercentX(0.8544)
layout:setPositionPercentY(0.5137)
layout:setPercentWidth(0.2778)
layout:setPercentHeight(1.0000)
layout:setSize({width = 100.0000, height = 100.0000})
layout:setLeftMargin(257.5747)
layout:setRightMargin(2.4253)
layout:setTopMargin(-1.3725)
layout:setBottomMargin(1.3725)
item_root_3:addChild(item_bg_3)

--Create item_3
local item_3 = ccui.ImageView:create()
item_3:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/mjmatch/winMatch/res/winMatch_picture.plist")
item_3:loadTexture("app/part/xymj/mjmatch/winMatch/res/item_gold.png",1)
item_3:setLayoutComponentEnabled(true)
item_3:setName("item_3")
item_3:setTag(59)
item_3:setCascadeColorEnabled(true)
item_3:setCascadeOpacityEnabled(true)
item_3:setPosition(307.5743, 49.0704)
layout = ccui.LayoutComponent:bindLayoutComponent(item_3)
layout:setPositionPercentX(0.8544)
layout:setPositionPercentY(0.4907)
layout:setPercentWidth(0.1389)
layout:setPercentHeight(0.5500)
layout:setSize({width = 50.0000, height = 55.0000})
layout:setLeftMargin(282.5743)
layout:setRightMargin(27.4257)
layout:setTopMargin(23.4296)
layout:setBottomMargin(21.5704)
item_root_3:addChild(item_3)

--Create item_number_3
local item_number_3 = ccui.TextAtlas:create([[01112]],
													"app/part/xymj/mjmatch/winMatch/res/number.png",
													21,
													28,
													"/")
item_number_3:setLayoutComponentEnabled(true)
item_number_3:setName("item_number_3")
item_number_3:setTag(60)
item_number_3:setCascadeColorEnabled(true)
item_number_3:setCascadeOpacityEnabled(true)
item_number_3:setPosition(307.5751, 11.8517)
layout = ccui.LayoutComponent:bindLayoutComponent(item_number_3)
layout:setPositionPercentX(0.8544)
layout:setPositionPercentY(0.1185)
layout:setPercentWidth(0.2917)
layout:setPercentHeight(0.2800)
layout:setSize({width = 105.0000, height = 28.0000})
layout:setLeftMargin(255.0751)
layout:setRightMargin(-0.0751)
layout:setTopMargin(74.1483)
layout:setBottomMargin(-2.1483)
item_root_3:addChild(item_number_3)

--Create item_root
local item_root = ccui.Layout:create()
item_root:ignoreContentAdaptWithSize(false)
item_root:setClippingEnabled(false)
item_root:setBackGroundColorOpacity(102)
item_root:setTouchEnabled(true);
item_root:setLayoutComponentEnabled(true)
item_root:setName("item_root")
item_root:setTag(61)
item_root:setCascadeColorEnabled(true)
item_root:setCascadeOpacityEnabled(true)
item_root:setAnchorPoint(0.5000, 0.5000)
item_root:setPosition(640.0000, 218.3760)
layout = ccui.LayoutComponent:bindLayoutComponent(item_root)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.3033)
layout:setPercentWidth(0.0781)
layout:setPercentHeight(0.1389)
layout:setSize({width = 100.0000, height = 100.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(3)
layout:setLeftMargin(590.0000)
layout:setRightMargin(590.0000)
layout:setTopMargin(451.6240)
layout:setBottomMargin(168.3760)
root:addChild(item_root)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Layer
return result;
end

return Result

