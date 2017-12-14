--[[
*名称:BroadcastLayer
*描述:广播消息界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local BroadcastNode = class("BroadcastNode",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]

function BroadcastNode:onCreate()
	-- body
	self:initWithFilePath("BroadcastNode",CURRENT_MODULE_NAME)
    local scale = display.width/1280
    self.node.root:setScale(scale)
end


--广播文字移动
function BroadcastNode:broadcastUpdate(msg)
    local shap = self.node.pmdbg_img1
    local content_size = shap:getContentSize()
    if self.broad_cast == nil then
        self.broad_cast = ccui.Text:create()
        self.broad_cast:setFontSize(34)
        self.broad_cast:setAnchorPoint(cc.p(0,0.5))
        
        local cil_sprite = cc.Sprite:create(self.res_base .. "/bg.png")
        if not cil_sprite then
            return
        end

        local img_width = self.node.pmdbg_img1:getBoundingBox().width * 1.0
        local cil_sprite_width = cil_sprite:getBoundingBox().width * 1.0
        cil_sprite:setScaleX(img_width / cil_sprite_width)

        local cliper = cc.ClippingNode:create()
        local pos = cc.p(content_size.width/2 - 5,content_size.height/2)
        cliper:setStencil(cil_sprite)
        cliper:addChild(self.broad_cast)
        cliper:setPosition(pos)
        shap:addChild(cliper)
    end

    local start_pos = cc.p(content_size.width/2,0)
    self.broad_cast:setPosition(start_pos)
    self.broad_cast:setString(msg)

    local text_size = self.broad_cast:getStringLength()
    local end_time
    if text_size > 8 then
        end_time = 8+(text_size - 8)*0.3
    else
        end_time = 8
    end

    local text_width = self.broad_cast:getContentSize()
    local end_pos = {}
    end_pos.x = self.broad_cast:getPositionX() - content_size.width - text_width.width - 200
    end_pos.y = 0

    local actions = {
                        cc.MoveTo:create(end_time,end_pos),
                    }
    local seq = transition.sequence(actions)
    transition.execute(self.broad_cast , seq , { removeSelf= false, onComplete = function()
        self.part:setBroadcastState(false)
        self.part:checkBroadcast()
    end})
    self.part:setBroadcastState(true)
end

function BroadcastNode:isShowBroadcastNode(flag)
    -- body   
    if flag == true then 
        self.node.bc_panel:show()
    else
        self.node.bc_panel:hide()
    end
end

return BroadcastNode
