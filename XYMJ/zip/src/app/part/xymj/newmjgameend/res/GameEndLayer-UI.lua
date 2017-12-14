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
touch_mask:setTag(80)
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
local bg = ccui.Layout:create()
bg:ignoreContentAdaptWithSize(false)
bg:setClippingEnabled(false)
bg:setBackGroundColorOpacity(102)
bg:setTouchEnabled(true);
bg:setLayoutComponentEnabled(true)
bg:setName("bg")
bg:setTag(333)
bg:setCascadeColorEnabled(true)
bg:setCascadeOpacityEnabled(true)
bg:setAnchorPoint(0.5000, 0.5000)
bg:setPosition(640.0000, 360.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(bg)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(0.7758)
layout:setPercentHeight(0.8528)
layout:setSize({width = 993.0000, height = 614.0000})
layout:setLeftMargin(143.5000)
layout:setRightMargin(143.5000)
layout:setTopMargin(53.0000)
layout:setBottomMargin(53.0000)
touch_mask:addChild(bg)

--Create time_txt
local time_txt = ccui.Text:create()
time_txt:ignoreContentAdaptWithSize(true)
time_txt:setTextAreaSize({width = 0, height = 0})
time_txt:setFontName("font/msyh.ttf")
time_txt:setFontSize(20)
time_txt:setString([[2017/03/19 22:59:52]])
time_txt:setLayoutComponentEnabled(true)
time_txt:setName("time_txt")
time_txt:setTag(84)
time_txt:setCascadeColorEnabled(true)
time_txt:setCascadeOpacityEnabled(true)
time_txt:setAnchorPoint(1.0000, 0.5000)
time_txt:setPosition(115.9054, -30.5793)
time_txt:setTextColor({r = 208, g = 222, b = 229})
layout = ccui.LayoutComponent:bindLayoutComponent(time_txt)
layout:setPositionPercentX(0.1167)
layout:setPositionPercentY(-0.0498)
layout:setPercentWidth(0.1823)
layout:setPercentHeight(0.0456)
layout:setSize({width = 181.0000, height = 28.0000})
layout:setHorizontalEdge(1)
layout:setVerticalEdge(1)
layout:setLeftMargin(-65.0946)
layout:setRightMargin(877.0946)
layout:setTopMargin(630.5793)
layout:setBottomMargin(-44.5793)
bg:addChild(time_txt)

--Create housenum_txt
local housenum_txt = ccui.Text:create()
housenum_txt:ignoreContentAdaptWithSize(true)
housenum_txt:setTextAreaSize({width = 0, height = 0})
housenum_txt:setFontName("font/msyh.ttf")
housenum_txt:setFontSize(20)
housenum_txt:setString([[房号:]])
housenum_txt:setLayoutComponentEnabled(true)
housenum_txt:setName("housenum_txt")
housenum_txt:setTag(250)
housenum_txt:setCascadeColorEnabled(true)
housenum_txt:setCascadeOpacityEnabled(true)
housenum_txt:setAnchorPoint(1.0000, 0.5000)
housenum_txt:setPosition(6.8957, -1.5805)
housenum_txt:setTextColor({r = 208, g = 222, b = 229})
layout = ccui.LayoutComponent:bindLayoutComponent(housenum_txt)
layout:setPositionPercentX(0.0069)
layout:setPositionPercentY(-0.0026)
layout:setPercentWidth(0.0473)
layout:setPercentHeight(0.0456)
layout:setSize({width = 47.0000, height = 28.0000})
layout:setHorizontalEdge(1)
layout:setVerticalEdge(1)
layout:setLeftMargin(-40.1043)
layout:setRightMargin(986.1043)
layout:setTopMargin(601.5805)
layout:setBottomMargin(-15.5805)
bg:addChild(housenum_txt)

--Create housenumshow_txt
local housenumshow_txt = ccui.Text:create()
housenumshow_txt:ignoreContentAdaptWithSize(true)
housenumshow_txt:setTextAreaSize({width = 0, height = 0})
housenumshow_txt:setFontName("font/msyh.ttf")
housenumshow_txt:setFontSize(20)
housenumshow_txt:setString([[998556]])
housenumshow_txt:setLayoutComponentEnabled(true)
housenumshow_txt:setName("housenumshow_txt")
housenumshow_txt:setTag(251)
housenumshow_txt:setCascadeColorEnabled(true)
housenumshow_txt:setCascadeOpacityEnabled(true)
housenumshow_txt:setAnchorPoint(1.0000, 0.5000)
housenumshow_txt:setPosition(72.8989, -2.5800)
housenumshow_txt:setTextColor({r = 251, g = 183, b = 0})
layout = ccui.LayoutComponent:bindLayoutComponent(housenumshow_txt)
layout:setPositionPercentX(0.0734)
layout:setPositionPercentY(-0.0042)
layout:setPercentWidth(0.0634)
layout:setPercentHeight(0.0456)
layout:setSize({width = 63.0000, height = 28.0000})
layout:setHorizontalEdge(1)
layout:setVerticalEdge(1)
layout:setLeftMargin(9.8989)
layout:setRightMargin(920.1011)
layout:setTopMargin(602.5800)
layout:setBottomMargin(-16.5800)
bg:addChild(housenumshow_txt)

--Create spmjtag
local spmjtag = cc.Sprite:create("app/part/xymj/newmjgameend/res/geJiuMaJiangTag.png")
spmjtag:setName("spmjtag")
spmjtag:setTag(252)
spmjtag:setCascadeColorEnabled(true)
spmjtag:setCascadeOpacityEnabled(true)
spmjtag:setVisible(false)
spmjtag:setAnchorPoint(0.0000, 0.0000)
spmjtag:setPosition(-52.3188, 20.4238)
layout = ccui.LayoutComponent:bindLayoutComponent(spmjtag)
layout:setPositionPercentX(-0.0527)
layout:setPositionPercentY(0.0333)
layout:setPercentWidth(0.1279)
layout:setPercentHeight(0.0619)
layout:setSize({width = 127.0000, height = 38.0000})
layout:setLeftMargin(-52.3188)
layout:setRightMargin(918.3188)
layout:setTopMargin(555.5762)
layout:setBottomMargin(20.4238)
spmjtag:setBlendFunc({src = 1, dst = 771})
bg:addChild(spmjtag)

--Create setnum_txt
local setnum_txt = ccui.Text:create()
setnum_txt:ignoreContentAdaptWithSize(true)
setnum_txt:setTextAreaSize({width = 0, height = 0})
setnum_txt:setFontName("font/msyh.ttf")
setnum_txt:setFontSize(20)
setnum_txt:setString([[局数:]])
setnum_txt:setLayoutComponentEnabled(true)
setnum_txt:setName("setnum_txt")
setnum_txt:setTag(255)
setnum_txt:setCascadeColorEnabled(true)
setnum_txt:setCascadeOpacityEnabled(true)
setnum_txt:setAnchorPoint(1.0000, 0.5000)
setnum_txt:setPosition(160.8979, -1.5805)
setnum_txt:setTextColor({r = 208, g = 222, b = 229})
layout = ccui.LayoutComponent:bindLayoutComponent(setnum_txt)
layout:setPositionPercentX(0.1620)
layout:setPositionPercentY(-0.0026)
layout:setPercentWidth(0.0473)
layout:setPercentHeight(0.0456)
layout:setSize({width = 47.0000, height = 28.0000})
layout:setLeftMargin(113.8979)
layout:setRightMargin(832.1021)
layout:setTopMargin(601.5805)
layout:setBottomMargin(-15.5805)
bg:addChild(setnum_txt)

--Create setnumshow_txt
local setnumshow_txt = ccui.Text:create()
setnumshow_txt:ignoreContentAdaptWithSize(true)
setnumshow_txt:setTextAreaSize({width = 0, height = 0})
setnumshow_txt:setFontName("font/msyh.ttf")
setnumshow_txt:setFontSize(20)
setnumshow_txt:setString([[1/4]])
setnumshow_txt:setLayoutComponentEnabled(true)
setnumshow_txt:setName("setnumshow_txt")
setnumshow_txt:setTag(256)
setnumshow_txt:setCascadeColorEnabled(true)
setnumshow_txt:setCascadeOpacityEnabled(true)
setnumshow_txt:setAnchorPoint(1.0000, 0.5000)
setnumshow_txt:setPosition(194.9005, -2.5800)
setnumshow_txt:setTextColor({r = 251, g = 183, b = 0})
layout = ccui.LayoutComponent:bindLayoutComponent(setnumshow_txt)
layout:setPositionPercentX(0.1963)
layout:setPositionPercentY(-0.0042)
layout:setPercentWidth(0.0342)
layout:setPercentHeight(0.0456)
layout:setSize({width = 34.0000, height = 28.0000})
layout:setHorizontalEdge(1)
layout:setVerticalEdge(1)
layout:setLeftMargin(160.9005)
layout:setRightMargin(798.0995)
layout:setTopMargin(602.5800)
layout:setBottomMargin(-16.5800)
bg:addChild(setnumshow_txt)

--Create bgnum_txt
local bgnum_txt = ccui.Text:create()
bgnum_txt:ignoreContentAdaptWithSize(true)
bgnum_txt:setTextAreaSize({width = 0, height = 0})
bgnum_txt:setFontSize(20)
bgnum_txt:setString([[底分:]])
bgnum_txt:setTouchEnabled(true);
bgnum_txt:setLayoutComponentEnabled(true)
bgnum_txt:setName("bgnum_txt")
bgnum_txt:setTag(257)
bgnum_txt:setCascadeColorEnabled(true)
bgnum_txt:setCascadeOpacityEnabled(true)
bgnum_txt:setVisible(false)
bgnum_txt:setAnchorPoint(1.0000, 0.5000)
bgnum_txt:setPosition(274.9055, -16.5805)
bgnum_txt:setTextColor({r = 208, g = 222, b = 229})
layout = ccui.LayoutComponent:bindLayoutComponent(bgnum_txt)
layout:setPositionPercentX(0.2768)
layout:setPositionPercentY(-0.0270)
layout:setPercentWidth(0.0504)
layout:setPercentHeight(0.0326)
layout:setSize({width = 50.0000, height = 20.0000})
layout:setHorizontalEdge(1)
layout:setVerticalEdge(1)
layout:setLeftMargin(224.9055)
layout:setRightMargin(718.0945)
layout:setTopMargin(620.5805)
layout:setBottomMargin(-26.5805)
bg:addChild(bgnum_txt)

--Create bgnumshow_txt
local bgnumshow_txt = ccui.Text:create()
bgnumshow_txt:ignoreContentAdaptWithSize(true)
bgnumshow_txt:setTextAreaSize({width = 0, height = 0})
bgnumshow_txt:setFontSize(20)
bgnumshow_txt:setString([[998556]])
bgnumshow_txt:setTouchEnabled(true);
bgnumshow_txt:setLayoutComponentEnabled(true)
bgnumshow_txt:setName("bgnumshow_txt")
bgnumshow_txt:setTag(258)
bgnumshow_txt:setCascadeColorEnabled(true)
bgnumshow_txt:setCascadeOpacityEnabled(true)
bgnumshow_txt:setVisible(false)
bgnumshow_txt:setAnchorPoint(1.0000, 0.5000)
bgnumshow_txt:setPosition(338.9058, -17.5803)
bgnumshow_txt:setTextColor({r = 251, g = 183, b = 0})
layout = ccui.LayoutComponent:bindLayoutComponent(bgnumshow_txt)
layout:setPositionPercentX(0.3413)
layout:setPositionPercentY(-0.0286)
layout:setPercentWidth(0.0604)
layout:setPercentHeight(0.0326)
layout:setSize({width = 60.0000, height = 20.0000})
layout:setHorizontalEdge(1)
layout:setVerticalEdge(1)
layout:setLeftMargin(278.9058)
layout:setRightMargin(654.0942)
layout:setTopMargin(621.5803)
layout:setBottomMargin(-27.5803)
bg:addChild(bgnumshow_txt)

--Create return_btn
local return_btn = ccui.Button:create()
return_btn:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/newmjgameend/res/end_picture.plist")
return_btn:loadTextureNormal("app/part/xymj/newmjgameend/res/exit_room_btn.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/newmjgameend/res/end_picture.plist")
return_btn:loadTexturePressed("app/part/xymj/newmjgameend/res/exit_room_btn_light.png",1)
return_btn:loadTextureDisabled("Default/Button_Disable.png",0)
return_btn:setTitleFontSize(14)
return_btn:setTitleColor({r = 65, g = 65, b = 70})
return_btn:setScale9Enabled(true)
return_btn:setCapInsets({x = 15, y = 11, width = 36, height = 63})
return_btn:setLayoutComponentEnabled(true)
return_btn:setName("return_btn")
return_btn:setTag(190)
return_btn:setCascadeColorEnabled(true)
return_btn:setCascadeOpacityEnabled(true)
return_btn:setPosition(39.0000, 607.6411)
if callBackProvider~=nil then
      return_btn:addClickEventListener(callBackProvider("GameEndLayer-UI.lua", return_btn, "BackClick"))
end
layout = ccui.LayoutComponent:bindLayoutComponent(return_btn)
layout:setPositionPercentX(0.0305)
layout:setPositionPercentY(0.8439)
layout:setPercentWidth(0.0516)
layout:setPercentHeight(0.1181)
layout:setSize({width = 66.0000, height = 85.0000})
layout:setHorizontalEdge(1)
layout:setVerticalEdge(2)
layout:setLeftMargin(6.0000)
layout:setRightMargin(1208.0000)
layout:setTopMargin(69.8589)
layout:setBottomMargin(565.1411)
touch_mask:addChild(return_btn)

--Create result_list
local result_list = ccui.ListView:create()
result_list:setItemsMargin(28)
result_list:setDirection(1)
result_list:setGravity(0)
result_list:ignoreContentAdaptWithSize(false)
result_list:setClippingEnabled(false)
result_list:setBackGroundColorOpacity(102)
result_list:setLayoutComponentEnabled(true)
result_list:setName("result_list")
result_list:setTag(82)
result_list:setCascadeColorEnabled(true)
result_list:setCascadeOpacityEnabled(true)
result_list:setAnchorPoint(0.5000, 0.0000)
result_list:setPosition(640.0000, 105.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(result_list)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.1458)
layout:setPercentWidth(0.7391)
layout:setPercentHeight(0.7500)
layout:setSize({width = 946.0000, height = 540.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(1)
layout:setLeftMargin(167.0000)
layout:setRightMargin(167.0000)
layout:setTopMargin(75.0000)
layout:setBottomMargin(105.0000)
touch_mask:addChild(result_list)

--Create btn_layer
local btn_layer = ccui.Layout:create()
btn_layer:ignoreContentAdaptWithSize(false)
btn_layer:setClippingEnabled(false)
btn_layer:setBackGroundColorOpacity(102)
btn_layer:setTouchEnabled(true);
btn_layer:setLayoutComponentEnabled(true)
btn_layer:setName("btn_layer")
btn_layer:setTag(192)
btn_layer:setCascadeColorEnabled(true)
btn_layer:setCascadeOpacityEnabled(true)
btn_layer:setAnchorPoint(0.5000, 0.0000)
btn_layer:setPosition(640.0000, 23.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(btn_layer)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.0319)
layout:setPercentWidth(0.4922)
layout:setPercentHeight(0.1389)
layout:setSize({width = 630.0000, height = 100.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(1)
layout:setLeftMargin(325.0000)
layout:setRightMargin(325.0000)
layout:setTopMargin(597.0000)
layout:setBottomMargin(23.0000)
touch_mask:addChild(btn_layer)

--Create result_panel
local result_panel = ccui.Layout:create()
result_panel:ignoreContentAdaptWithSize(false)
result_panel:setClippingEnabled(false)
result_panel:setBackGroundColorOpacity(102)
result_panel:setTouchEnabled(true);
result_panel:setLayoutComponentEnabled(true)
result_panel:setName("result_panel")
result_panel:setTag(85)
result_panel:setCascadeColorEnabled(true)
result_panel:setCascadeOpacityEnabled(true)
result_panel:setPosition(-45.0000, 1106.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(result_panel)
layout:setPositionPercentX(-0.0352)
layout:setPositionPercentY(1.5361)
layout:setPercentWidth(0.7391)
layout:setPercentHeight(0.1528)
layout:setSize({width = 946.0000, height = 110.0000})
layout:setLeftMargin(-45.0000)
layout:setRightMargin(379.0000)
layout:setTopMargin(-496.0000)
layout:setBottomMargin(1106.0000)
touch_mask:addChild(result_panel)

--Create img_bg
local img_bg = ccui.ImageView:create()
img_bg:ignoreContentAdaptWithSize(false)
img_bg:loadTexture("app/part/xymj/newmjgameend/res/gameOverEndItemBg.png",0)
img_bg:setLayoutComponentEnabled(true)
img_bg:setName("img_bg")
img_bg:setTag(336)
img_bg:setCascadeColorEnabled(true)
img_bg:setCascadeOpacityEnabled(true)
img_bg:setPosition(473.0000, 55.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(img_bg)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.5000)
layout:setPercentWidth(1.1522)
layout:setPercentHeight(1.2364)
layout:setSize({width = 1090.0000, height = 136.0000})
layout:setLeftMargin(-72.0000)
layout:setRightMargin(-72.0000)
layout:setTopMargin(-13.0000)
layout:setBottomMargin(-13.0000)
result_panel:addChild(img_bg)

--Create info_txt
local info_txt = ccui.Text:create()
info_txt:ignoreContentAdaptWithSize(true)
info_txt:setTextAreaSize({width = 0, height = 0})
info_txt:setFontName("font/msyh.ttf")
info_txt:setFontSize(25)
info_txt:setString([[耳膜你好]])
info_txt:setLayoutComponentEnabled(true)
info_txt:setName("info_txt")
info_txt:setTag(86)
info_txt:setCascadeColorEnabled(true)
info_txt:setCascadeOpacityEnabled(true)
info_txt:setAnchorPoint(0.0000, 0.5000)
info_txt:setPosition(-42.0157, 94.0000)
info_txt:setTextColor({r = 210, g = 244, b = 241})
layout = ccui.LayoutComponent:bindLayoutComponent(info_txt)
layout:setPositionPercentX(-0.0444)
layout:setPositionPercentY(0.8545)
layout:setPercentWidth(0.1089)
layout:setPercentHeight(0.3182)
layout:setSize({width = 103.0000, height = 35.0000})
layout:setLeftMargin(-42.0157)
layout:setRightMargin(885.0157)
layout:setTopMargin(-1.5000)
layout:setBottomMargin(76.5000)
result_panel:addChild(info_txt)

--Create score_txt
local score_txt = ccui.Text:create()
score_txt:ignoreContentAdaptWithSize(true)
score_txt:setTextAreaSize({width = 0, height = 0})
score_txt:setFontSize(28)
score_txt:setString([[]])
score_txt:setLayoutComponentEnabled(true)
score_txt:setName("score_txt")
score_txt:setTag(91)
score_txt:setCascadeColorEnabled(true)
score_txt:setCascadeOpacityEnabled(true)
score_txt:setAnchorPoint(0.0000, 0.5000)
score_txt:setPosition(760.9887, 94.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(score_txt)
layout:setPositionPercentX(0.8044)
layout:setPositionPercentY(0.8545)
layout:setLeftMargin(760.9887)
layout:setRightMargin(185.0113)
layout:setTopMargin(16.0000)
layout:setBottomMargin(94.0000)
result_panel:addChild(score_txt)

--Create score_txt1
local score_txt1 = ccui.TextAtlas:create([[9999]],
													"app/part/xymj/newmjgameend/res/num1.png",
													26,
													34,
													"/")
score_txt1:setLayoutComponentEnabled(true)
score_txt1:setName("score_txt1")
score_txt1:setTag(325)
score_txt1:setCascadeColorEnabled(true)
score_txt1:setCascadeOpacityEnabled(true)
score_txt1:setAnchorPoint(0.0000, 0.5000)
score_txt1:setPosition(-5.7886, 56.8777)
layout = ccui.LayoutComponent:bindLayoutComponent(score_txt1)
layout:setPositionPercentX(-0.0061)
layout:setPositionPercentY(0.5171)
layout:setPercentWidth(0.1099)
layout:setPercentHeight(0.3091)
layout:setSize({width = 104.0000, height = 34.0000})
layout:setLeftMargin(-5.7886)
layout:setRightMargin(847.7886)
layout:setTopMargin(36.1223)
layout:setBottomMargin(39.8777)
result_panel:addChild(score_txt1)

--Create score_txt2
local score_txt2 = ccui.TextAtlas:create([[8888]],
													"app/part/xymj/newmjgameend/res/num2.png",
													26,
													34,
													"/")
score_txt2:setLayoutComponentEnabled(true)
score_txt2:setName("score_txt2")
score_txt2:setTag(326)
score_txt2:setCascadeColorEnabled(true)
score_txt2:setCascadeOpacityEnabled(true)
score_txt2:setAnchorPoint(0.0000, 0.5000)
score_txt2:setPosition(-4.0201, 56.0003)
layout = ccui.LayoutComponent:bindLayoutComponent(score_txt2)
layout:setPositionPercentX(-0.0042)
layout:setPositionPercentY(0.5091)
layout:setPercentWidth(0.1099)
layout:setPercentHeight(0.3091)
layout:setSize({width = 104.0000, height = 34.0000})
layout:setLeftMargin(-4.0201)
layout:setRightMargin(846.0201)
layout:setTopMargin(36.9997)
layout:setBottomMargin(39.0003)
result_panel:addChild(score_txt2)

--Create card_node
local card_node = ccui.Layout:create()
card_node:ignoreContentAdaptWithSize(false)
card_node:setClippingEnabled(false)
card_node:setBackGroundColorOpacity(102)
card_node:setTouchEnabled(true);
card_node:setLayoutComponentEnabled(true)
card_node:setName("card_node")
card_node:setTag(172)
card_node:setCascadeColorEnabled(true)
card_node:setCascadeOpacityEnabled(true)
card_node:setPosition(99.9988, 49.0000)
card_node:setScaleX(0.4300)
card_node:setScaleY(0.4300)
layout = ccui.LayoutComponent:bindLayoutComponent(card_node)
layout:setPositionPercentX(0.1057)
layout:setPositionPercentY(0.4455)
layout:setPercentWidth(0.2114)
layout:setPercentHeight(0.5000)
layout:setSize({width = 200.0000, height = 55.0000})
layout:setLeftMargin(99.9988)
layout:setRightMargin(646.0012)
layout:setTopMargin(6.0000)
layout:setBottomMargin(49.0000)
result_panel:addChild(card_node)

--Create card_node_1
local card_node_1 = ccui.Layout:create()
card_node_1:ignoreContentAdaptWithSize(false)
card_node_1:setClippingEnabled(false)
card_node_1:setBackGroundColorOpacity(102)
card_node_1:setTouchEnabled(true);
card_node_1:setLayoutComponentEnabled(true)
card_node_1:setName("card_node_1")
card_node_1:setTag(173)
card_node_1:setCascadeColorEnabled(true)
card_node_1:setCascadeOpacityEnabled(true)
card_node_1:setPosition(770.0000, 39.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(card_node_1)
layout:setPositionPercentX(0.8140)
layout:setPositionPercentY(0.3545)
layout:setPercentWidth(0.1057)
layout:setPercentHeight(0.9091)
layout:setSize({width = 100.0000, height = 100.0000})
layout:setLeftMargin(770.0000)
layout:setRightMargin(76.0000)
layout:setTopMargin(-29.0000)
layout:setBottomMargin(39.0000)
result_panel:addChild(card_node_1)

--Create hu_card
local hu_card = ccui.ImageView:create()
hu_card:ignoreContentAdaptWithSize(false)
hu_card:loadTexture("Default/ImageFile.png",0)
hu_card:setLayoutComponentEnabled(true)
hu_card:setName("hu_card")
hu_card:setTag(90)
hu_card:setCascadeColorEnabled(true)
hu_card:setCascadeOpacityEnabled(true)
hu_card:setVisible(false)
hu_card:setPosition(78.0078, 0.0029)
hu_card:setScaleX(0.7000)
hu_card:setScaleY(0.7000)
layout = ccui.LayoutComponent:bindLayoutComponent(hu_card)
layout:setPositionPercentX(0.7801)
layout:setPercentWidth(0.7500)
layout:setPercentHeight(1.1300)
layout:setSize({width = 75.0000, height = 113.0000})
layout:setLeftMargin(40.5078)
layout:setRightMargin(-15.5078)
layout:setTopMargin(43.4971)
layout:setBottomMargin(-56.4971)
card_node_1:addChild(hu_card)

--Create hu_icon
local hu_icon = ccui.ImageView:create()
hu_icon:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/newmjgameend/res/end_picture.plist")
hu_icon:loadTexture("app/part/xymj/newmjgameend/res/hu_bt.png",1)
hu_icon:setLayoutComponentEnabled(true)
hu_icon:setName("hu_icon")
hu_icon:setTag(92)
hu_icon:setCascadeColorEnabled(true)
hu_icon:setCascadeOpacityEnabled(true)
hu_icon:setVisible(false)
hu_icon:setPosition(138.1500, 13.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(hu_icon)
layout:setPositionPercentX(1.3815)
layout:setPositionPercentY(0.1300)
layout:setPercentWidth(0.7500)
layout:setPercentHeight(0.6700)
layout:setSize({width = 75.0000, height = 67.0000})
layout:setLeftMargin(100.6500)
layout:setRightMargin(-75.6500)
layout:setTopMargin(53.5000)
layout:setBottomMargin(-20.5000)
card_node_1:addChild(hu_icon)

--Create ma_bg
local ma_bg = ccui.ImageView:create()
ma_bg:ignoreContentAdaptWithSize(false)
ma_bg:loadTexture("Default/ImageFile.png",0)
ma_bg:setLayoutComponentEnabled(true)
ma_bg:setName("ma_bg")
ma_bg:setTag(179)
ma_bg:setCascadeColorEnabled(true)
ma_bg:setCascadeOpacityEnabled(true)
ma_bg:setVisible(false)
ma_bg:setPosition(310.0000, 0.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(ma_bg)
layout:setPositionPercentX(3.1000)
layout:setPercentWidth(3.3000)
layout:setPercentHeight(0.9000)
layout:setSize({width = 330.0000, height = 90.0000})
layout:setLeftMargin(145.0000)
layout:setRightMargin(-375.0000)
layout:setTopMargin(55.0000)
layout:setBottomMargin(-45.0000)
card_node_1:addChild(ma_bg)

--Create ma1
local ma1 = ccui.ImageView:create()
ma1:ignoreContentAdaptWithSize(false)
ma1:loadTexture("Default/ImageFile.png",0)
ma1:setLayoutComponentEnabled(true)
ma1:setName("ma1")
ma1:setTag(94)
ma1:setCascadeColorEnabled(true)
ma1:setCascadeOpacityEnabled(true)
ma1:setPosition(42.0000, 42.0000)
ma1:setScaleX(0.7000)
ma1:setScaleY(0.7000)
layout = ccui.LayoutComponent:bindLayoutComponent(ma1)
layout:setPositionPercentX(0.1273)
layout:setPositionPercentY(0.4667)
layout:setPercentWidth(0.2273)
layout:setPercentHeight(1.2556)
layout:setSize({width = 75.0000, height = 113.0000})
layout:setLeftMargin(4.5000)
layout:setRightMargin(250.5000)
layout:setTopMargin(-8.5000)
layout:setBottomMargin(-14.5000)
ma_bg:addChild(ma1)

--Create ma2
local ma2 = ccui.ImageView:create()
ma2:ignoreContentAdaptWithSize(false)
ma2:loadTexture("Default/ImageFile.png",0)
ma2:setLayoutComponentEnabled(true)
ma2:setName("ma2")
ma2:setTag(95)
ma2:setCascadeColorEnabled(true)
ma2:setCascadeOpacityEnabled(true)
ma2:setPosition(102.0000, 42.0000)
ma2:setScaleX(0.7000)
ma2:setScaleY(0.7000)
layout = ccui.LayoutComponent:bindLayoutComponent(ma2)
layout:setPositionPercentX(0.3091)
layout:setPositionPercentY(0.4667)
layout:setPercentWidth(0.2273)
layout:setPercentHeight(1.2556)
layout:setSize({width = 75.0000, height = 113.0000})
layout:setLeftMargin(64.5000)
layout:setRightMargin(190.5000)
layout:setTopMargin(-8.5000)
layout:setBottomMargin(-14.5000)
ma_bg:addChild(ma2)

--Create ma3
local ma3 = ccui.ImageView:create()
ma3:ignoreContentAdaptWithSize(false)
ma3:loadTexture("Default/ImageFile.png",0)
ma3:setLayoutComponentEnabled(true)
ma3:setName("ma3")
ma3:setTag(96)
ma3:setCascadeColorEnabled(true)
ma3:setCascadeOpacityEnabled(true)
ma3:setPosition(162.0000, 42.0000)
ma3:setScaleX(0.7000)
ma3:setScaleY(0.7000)
layout = ccui.LayoutComponent:bindLayoutComponent(ma3)
layout:setPositionPercentX(0.4909)
layout:setPositionPercentY(0.4667)
layout:setPercentWidth(0.2273)
layout:setPercentHeight(1.2556)
layout:setSize({width = 75.0000, height = 113.0000})
layout:setLeftMargin(124.5000)
layout:setRightMargin(130.5000)
layout:setTopMargin(-8.5000)
layout:setBottomMargin(-14.5000)
ma_bg:addChild(ma3)

--Create ma4
local ma4 = ccui.ImageView:create()
ma4:ignoreContentAdaptWithSize(false)
ma4:loadTexture("Default/ImageFile.png",0)
ma4:setLayoutComponentEnabled(true)
ma4:setName("ma4")
ma4:setTag(97)
ma4:setCascadeColorEnabled(true)
ma4:setCascadeOpacityEnabled(true)
ma4:setPosition(222.0000, 42.0000)
ma4:setScaleX(0.7000)
ma4:setScaleY(0.7000)
layout = ccui.LayoutComponent:bindLayoutComponent(ma4)
layout:setPositionPercentX(0.6727)
layout:setPositionPercentY(0.4667)
layout:setPercentWidth(0.2273)
layout:setPercentHeight(1.2556)
layout:setSize({width = 75.0000, height = 113.0000})
layout:setLeftMargin(184.5000)
layout:setRightMargin(70.5000)
layout:setTopMargin(-8.5000)
layout:setBottomMargin(-14.5000)
ma_bg:addChild(ma4)

--Create zimo_icon
local zimo_icon = ccui.ImageView:create()
zimo_icon:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/newmjgameend/res/end_picture.plist")
zimo_icon:loadTexture("app/part/xymj/newmjgameend/res/zimo.png",1)
zimo_icon:setLayoutComponentEnabled(true)
zimo_icon:setName("zimo_icon")
zimo_icon:setTag(36)
zimo_icon:setCascadeColorEnabled(true)
zimo_icon:setCascadeOpacityEnabled(true)
zimo_icon:setVisible(false)
zimo_icon:setPosition(146.1558, 14.0007)
zimo_icon:setScaleX(0.5000)
zimo_icon:setScaleY(0.5000)
layout = ccui.LayoutComponent:bindLayoutComponent(zimo_icon)
layout:setPositionPercentX(1.4616)
layout:setPositionPercentY(0.1400)
layout:setPercentWidth(1.9900)
layout:setPercentHeight(1.1200)
layout:setSize({width = 199.0000, height = 112.0000})
layout:setLeftMargin(46.6558)
layout:setRightMargin(-145.6558)
layout:setTopMargin(29.9993)
layout:setBottomMargin(-41.9993)
card_node_1:addChild(zimo_icon)

--Create dianpao_icon
local dianpao_icon = ccui.ImageView:create()
dianpao_icon:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/newmjgameend/res/end_picture.plist")
dianpao_icon:loadTexture("app/part/xymj/newmjgameend/res/dianpaosss.png",1)
dianpao_icon:setLayoutComponentEnabled(true)
dianpao_icon:setName("dianpao_icon")
dianpao_icon:setTag(37)
dianpao_icon:setCascadeColorEnabled(true)
dianpao_icon:setCascadeOpacityEnabled(true)
dianpao_icon:setVisible(false)
dianpao_icon:setPosition(143.1525, 12.0001)
layout = ccui.LayoutComponent:bindLayoutComponent(dianpao_icon)
layout:setPositionPercentX(1.4315)
layout:setPositionPercentY(0.1200)
layout:setPercentWidth(1.0100)
layout:setPercentHeight(0.5300)
layout:setSize({width = 101.0000, height = 53.0000})
layout:setLeftMargin(92.6525)
layout:setRightMargin(-93.6525)
layout:setTopMargin(61.4999)
layout:setBottomMargin(-14.4999)
card_node_1:addChild(dianpao_icon)

--Create luiju_icon
local luiju_icon = ccui.ImageView:create()
luiju_icon:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/newmjgameend/res/end_picture.plist")
luiju_icon:loadTexture("app/part/xymj/newmjgameend/res/liuju.png",1)
luiju_icon:setLayoutComponentEnabled(true)
luiju_icon:setName("luiju_icon")
luiju_icon:setTag(37)
luiju_icon:setCascadeColorEnabled(true)
luiju_icon:setCascadeOpacityEnabled(true)
luiju_icon:setVisible(false)
luiju_icon:setPosition(149.1500, 14.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(luiju_icon)
layout:setPositionPercentX(1.4915)
layout:setPositionPercentY(0.1400)
layout:setPercentWidth(1.1000)
layout:setPercentHeight(0.7000)
layout:setSize({width = 110.0000, height = 70.0000})
layout:setLeftMargin(94.1500)
layout:setRightMargin(-104.1500)
layout:setTopMargin(51.0000)
layout:setBottomMargin(-21.0000)
card_node_1:addChild(luiju_icon)

--Create banker_icon
local banker_icon = ccui.ImageView:create()
banker_icon:ignoreContentAdaptWithSize(false)
banker_icon:loadTexture("Default/ImageFile.png",0)
banker_icon:setLayoutComponentEnabled(true)
banker_icon:setName("banker_icon")
banker_icon:setTag(100)
banker_icon:setCascadeColorEnabled(true)
banker_icon:setCascadeOpacityEnabled(true)
banker_icon:setVisible(false)
banker_icon:setPosition(40.0000, 39.0000)
layout = ccui.LayoutComponent:bindLayoutComponent(banker_icon)
layout:setPositionPercentX(0.0423)
layout:setPositionPercentY(0.3545)
layout:setPercentWidth(0.0497)
layout:setPercentHeight(0.4273)
layout:setSize({width = 47.0000, height = 47.0000})
layout:setLeftMargin(16.5000)
layout:setRightMargin(882.5000)
layout:setTopMargin(47.5000)
layout:setBottomMargin(15.5000)
result_panel:addChild(banker_icon)

--Create img_score
local img_score = ccui.ImageView:create()
img_score:ignoreContentAdaptWithSize(false)
img_score:loadTexture("app/part/xymj/newmjgameend/res/scoreItem.png",0)
img_score:setLayoutComponentEnabled(true)
img_score:setName("img_score")
img_score:setTag(337)
img_score:setCascadeColorEnabled(true)
img_score:setCascadeOpacityEnabled(true)
img_score:setPosition(-27.0093, 52.9996)
layout = ccui.LayoutComponent:bindLayoutComponent(img_score)
layout:setPositionPercentX(-0.0286)
layout:setPositionPercentY(0.4818)
layout:setPercentWidth(0.0359)
layout:setPercentHeight(0.3000)
layout:setSize({width = 34.0000, height = 33.0000})
layout:setLeftMargin(-44.0093)
layout:setRightMargin(956.0093)
layout:setTopMargin(40.5004)
layout:setBottomMargin(36.4996)
result_panel:addChild(img_score)

--Create des_txt
local des_txt = ccui.Text:create()
des_txt:ignoreContentAdaptWithSize(true)
des_txt:setTextAreaSize({width = 0, height = 0})
des_txt:setFontName("font/msyh.ttf")
des_txt:setFontSize(25)
des_txt:setString([[X1]])
des_txt:setLayoutComponentEnabled(true)
des_txt:setName("des_txt")
des_txt:setTag(338)
des_txt:setCascadeColorEnabled(true)
des_txt:setCascadeOpacityEnabled(true)
des_txt:setAnchorPoint(0.0000, 0.5000)
des_txt:setPosition(114.9698, 93.9994)
des_txt:setTextColor({r = 172, g = 240, b = 235})
layout = ccui.LayoutComponent:bindLayoutComponent(des_txt)
layout:setPositionPercentX(0.1215)
layout:setPositionPercentY(0.8545)
layout:setPercentWidth(0.0338)
layout:setPercentHeight(0.3182)
layout:setSize({width = 32.0000, height = 35.0000})
layout:setLeftMargin(114.9698)
layout:setRightMargin(799.0302)
layout:setTopMargin(-1.4994)
layout:setBottomMargin(76.4994)
result_panel:addChild(des_txt)

--Create title
local title = ccui.ImageView:create()
title:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/newmjgameend/res/end_picture.plist")
title:loadTexture("app/part/xymj/newmjgameend/res/nothing.png",1)
title:setLayoutComponentEnabled(true)
title:setName("title")
title:setTag(81)
title:setCascadeColorEnabled(true)
title:setCascadeOpacityEnabled(true)
title:setVisible(false)
title:setPosition(640.0000, 671.0026)
layout = ccui.LayoutComponent:bindLayoutComponent(title)
layout:setPositionPercentX(0.5000)
layout:setPositionPercentY(0.9319)
layout:setPercentWidth(0.4891)
layout:setPercentHeight(0.1250)
layout:setSize({width = 626.0000, height = 90.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(2)
layout:setLeftMargin(327.0000)
layout:setRightMargin(327.0000)
layout:setTopMargin(3.9974)
layout:setBottomMargin(626.0026)
touch_mask:addChild(title)

--Create next_btn
local next_btn = ccui.Button:create()
next_btn:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("app/part/xymj/newmjgameend/res/end_picture.plist")
next_btn:loadTextureNormal("app/part/xymj/newmjgameend/res/continue.png",1)
next_btn:loadTextureDisabled("Default/Button_Disable.png",0)
next_btn:setTitleFontSize(14)
next_btn:setTitleColor({r = 65, g = 65, b = 70})
next_btn:setScale9Enabled(true)
next_btn:setCapInsets({x = 28, y = 11, width = 176, height = 60})
next_btn:setLayoutComponentEnabled(true)
next_btn:setName("next_btn")
next_btn:setTag(83)
next_btn:setCascadeColorEnabled(true)
next_btn:setCascadeOpacityEnabled(true)
next_btn:setPosition(1080.0640, 52.0013)
if callBackProvider~=nil then
      next_btn:addClickEventListener(callBackProvider("GameEndLayer-UI.lua", next_btn, "NextClick"))
end
layout = ccui.LayoutComponent:bindLayoutComponent(next_btn)
layout:setPositionPercentX(0.8438)
layout:setPositionPercentY(0.0722)
layout:setPercentWidth(0.1680)
layout:setPercentHeight(0.1028)
layout:setSize({width = 215.0000, height = 74.0000})
layout:setHorizontalEdge(3)
layout:setVerticalEdge(1)
layout:setLeftMargin(972.5640)
layout:setRightMargin(92.4360)
layout:setTopMargin(630.9987)
layout:setBottomMargin(15.0013)
touch_mask:addChild(next_btn)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1.0000)
--Create Animation List

result['root'] = Layer
return result;
end

return Result

