--[[
*名称:RewardTipsLayer
*描述:奖励获得tips界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:Hunter.lei
*创建日期:2017.5.2
*修改日期:2017.5.2
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]

local RewardTipsLayer = class("RewardTipsLayer",cc.load("mvc").ViewBase)
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
local CURRENT_MODULE_NAME = ...
RewardTipsLayer.TYPE = {
    ITEM_CONIS_TYPE = 0x000000, --金币
    ITEM_DIMAND_TYPE = 0x000001, --钻石
    ITEM_CASH_TYPE = 0x000002, --现金
}

function RewardTipsLayer:onCreate()
	-- body
    self:addMask()
	self:initWithFilePath("RewardTipsLayer",CURRENT_MODULE_NAME)
    self.isNeedShare = false
    self:registerTouchEvent()
end

function RewardTipsLayer:ClickOk()
    --[[self:showRedAni(false)
    --点击奖励按钮，打开红包管理界面,如果是金币的则弹出的是获得奖品tips
    if self.isNeedShare then
        --微信朋友圈分享接口
        self.part:shareToWX()
    else
        --打开红包管理界面
        self.part:openRedpacketLayer()
    end
    self:onClose()  --关闭红包]]
end

function RewardTipsLayer:shareToWXCircleFriend(title,content,url)
    local bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
    bridge:shareRedPacketToWxCirleOfFriend(title,content,url,"rplogo")
end

function RewardTipsLayer:showRedAni(visible)
    if visible then
        if self.bgAni == nil then
            self.bgAni = Util.createSpineAnimation(self.res_base .. "/spine/huodejiangli_b","1",false,false)
            self.bgAni:setPosition(self.node.Panel_split:getContentSize().width*0.5,self.node.Panel_split:getContentSize().height*0.5)
            self.node.Panel_split:addChild(self.bgAni)
            self.bgAni:setLocalZOrder(self.node.Panel_title:getLocalZOrder()-1)
            local gs = self
            self.bgAni:registerSpineEventHandler(function(detail)
                xxtimer.delay(0.001, function() -- We need delay one frame to destory the animation, otherwise, the App will crash.
                    --animation:removeFromParent();
                    --循环播放动画2
                    gs.bgAni:setAnimation(0, "2", true);
                    gs.bgAni:setPosition(gs.node.Panel_split:getContentSize().width*0.5,gs.node.Panel_split:getContentSize().height*0.5)
                end);
            end, sp.EventType.ANIMATION_COMPLETE);
        end
        if self.fontAni == nil then
            self.fontAni = Util.createSpineAnimation(self.res_base .. "/spine/huodejiangli_f","1",false,false)
            self.fontAni:setPosition(self.node.Image_rewarditem:getContentSize().width*0.5,self.node.Image_rewarditem:getContentSize().height*0.5)
            self.node.Image_rewarditem:addChild(self.fontAni)
            local gs = self
            self.fontAni:registerSpineEventHandler(function(detail)
                xxtimer.delay(0.001, function() -- We need delay one frame to destory the animation, otherwise, the App will crash.
                    --animation:removeFromParent();
                    --循环播放动画2
                    gs.fontAni:setAnimation(0, "2", true);
                    gs.fontAni:setPosition(gs.node.Image_rewarditem:getContentSize().width*0.5,gs.node.Image_rewarditem:getContentSize().height*0.5)
                end);
            end, sp.EventType.ANIMATION_COMPLETE);
        end
    else
        if self.bgAni ~= nil then
            self.bgAni:clearTracks()
            self.bgAni:removeFromParent()
            self.bgAni = nil
        end
        if self.fontAni ~= nil then
            self.fontAni:clearTracks()
            self.fontAni:removeFromParent()
            self.fontAni = nil
        end
    end
end

function RewardTipsLayer:setDataInfo(data)
    if data ~= nil then
        self:showTitle(data.prizeType) --跟新标题
        self.node.AtlasLabel_num:setString(tostring(data.prize))--设置数量
        --更新红包数据
        if data.prizeType == RewardTipsLayer.TYPE.ITEM_CONIS_TYPE then
        --金币图标
            self.node.Image_rewarditem:loadTexture(self.res_base .. "/icon_coins.png",1)
            local s_size = self.node.Image_rewarditem:getVirtualRendererSize()
            self.node.Image_rewarditem:setContentSize(s_size.width,s_size.height)
        elseif data.prizeType == RewardTipsLayer.TYPE.ITEM_DIMAND_TYPE then
        --钻石图标
            self.node.Image_rewarditem:loadTexture(self.res_base .. "/icon_dimand.png",1)
            local s_size = self.node.Image_rewarditem:getVirtualRendererSize()
            self.node.Image_rewarditem:setContentSize(s_size.width,s_size.height)
        else
        --现金图标
            self.node.Image_rewarditem:loadTexture(self.res_base .. "/icon_cash.png",1)
            local s_size = self.node.Image_rewarditem:getVirtualRendererSize()
            self.node.Image_rewarditem:setContentSize(s_size.width,s_size.height)
        end
        
        if data.isNeedShare == 0 then
            self.node.Image_wenzi:loadTexture(self.res_base .. "/share_friend.png",1)
            self.node.Text_tips:setString("将红包分享到朋友圈即可领取现金奖励您的好友也能获得大礼哦")--后面放到string_zh中
            self.isNeedShare = true
        else
            self.node.Image_wenzi:loadTexture(self.res_base .. "/open_wenzi.png",1)
            self.node.Text_tips:setString("请进入红包管理界面领取奖励")
            self.isNeedShare = false
        end
         
    end
    
    self:showRedAni(true)
    
    --如果是直接获得金币，则直接显示获得金币和金币增加特效
    
    --如果是钻石和现金则显示分享模式的布局
    --self.node.Image_wenzi:loadTexture(self.res_base .. "/rewardtips/open_wenzi.png",1)
    --self.node.AtlasLabel_num:setString("111")
    --self.node.Image_rewarditem:loadTexture(self.res_base .. "/rewardtips/dimand.png",1) --更新物品图片
end

function RewardTipsLayer:showTitle(prizeType)
    if prizeType ~= nil and prizeType == RewardTipsLayer.TYPE.ITEM_CONIS_TYPE then
        --金币
        self.node.Image_tiitle:setVisible(true)
        self.node.Image_title2:setVisible(false)
    else
        --现金或者钻石
        self.node.Image_tiitle:setVisible(false)
        self.node.Image_title2:setVisible(true)
        if prizeType == RewardTipsLayer.TYPE.ITEM_DIMAND_TYPE then
            --钻石
            self.node.Text_reward:setString("钻石")
        else
            --现金
            self.node.Text_reward:setString("现金")
        end
    end
end

--关闭红包界面
function RewardTipsLayer:onClose()
    self.part:onClose()
end

function RewardTipsLayer:registerTouchEvent()
    self.node.Button_ok:setSwallowTouches(false)
    self._touchListener = cc.EventListenerTouchOneByOne:create()
    self._touchListener:setSwallowTouches(false)
    self._touchListener:registerScriptHandler(handler(self, RewardTipsLayer.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self._touchListener:registerScriptHandler(handler(self, RewardTipsLayer.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self._touchListener:registerScriptHandler(handler(self, RewardTipsLayer.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(self._touchListener, self.node.Button_ok)
end

--touchbegan
function RewardTipsLayer:onTouchBegan(touches,event)
    return true
end

--touchmove
function RewardTipsLayer:onTouchMoved(touches,event)

end
--touchend
function RewardTipsLayer:onTouchEnded(touches,event)
    local touch_pos = touches:getLocation()
    local target = event:getCurrentTarget()
    
    local locationInNode = target:convertToNodeSpace(touch_pos);
    local s = target:getContentSize();
    local rect = cc.rect(0, 0, s.width, s.height);
     
    if cc.rectContainsPoint(rect,locationInNode) then
        --self:onSplitPacket()
        --先播拆红包动画再发送请求
        self:showRedAni(false)
        --点击奖励按钮，打开红包管理界面,如果是金币的则弹出的是获得奖品tips
        if self.isNeedShare then
            --微信朋友圈分享接口
            self.part:shareToWX()
        else
            --打开红包管理界面
            self.part:openRedpacketLayer()
        end
    end 
    
    self:onClose()  --关闭红包
end
return RewardTipsLayer