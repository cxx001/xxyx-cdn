--[[
*名称:DuihuanTipsLayer
*描述:兑换提示界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local DuihuanTipsLayer = class("DuihuanTipsLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
function DuihuanTipsLayer:onCreate(data) --传入数据
	-- body
	self:addMask()
	self:initWithFilePath("DuihuanTipsLayer",CURRENT_MODULE_NAME)
    self.node.bg:show()
    self.node.bg2:hide()
end


--[[
   info ={
		info_txt = "",
		right_click = func
		left_click = func
		mid_click= func
   }

   默认定义了左边点击事件就是两个按钮
--]]
-- function DuihuanTipsLayer:setInfo(info)
-- 	-- body
--     if info.tipType == nil or info.tipType == 1 then
        -- self.node.bg:show()
        -- self.node.bg2:hide()
--         if info.left_click == nil then
--             self.node.type_1:show()
--             self.node.type_2:hide()
--         else
--             self.node.type_2:show()
--             self.node.type_1:hide()
--         end
--         if info.tipType == nil then
--             self.node.info_bg:loadTexture(self.res_base .. "/scale9bg.png",0)
--             self.node.info_bg:ignoreContentAdaptWithSize(false)
--             self.node.info_bg:setContentSize(460,269)
--             self.node.bg:loadTexture(self.res_base .. "/smallbg.png",0)
--             self.node.bg:ignoreContentAdaptWithSize(false)
--             self.node.bg:setContentSize(482,288)
--             self.node.info_bg:setPosition(self.node.bg:getContentSize().width*0.5,self.node.bg:getContentSize().height*0.5)
--             self.node.ok_btn_1:setPositionX(self.node.bg:getContentSize().width*0.5)
--             --self.node.ok_btn_2:setPositionX(self.node.bg:getContentSize().width*0.3)
--             --self.node.cancel_btn_2:setPositionX(self.node.bg:getContentSize().width*0.7)
--             self.node.info_scorll:setPositionX(self.node.bg:getContentSize().width*0.5)
--         else
--             self.node.info_bg:loadTexture(self.res_base .. "/forbg.png",0)
--             self.node.info_bg:ignoreContentAdaptWithSize(false)
--             self.node.info_bg:setContentSize(752,431)
--             self.node.bg:loadTexture(self.res_base .. "/backBoard.png",0)
--             self.node.bg:ignoreContentAdaptWithSize(false)
--             self.node.bg:setContentSize(774,453)
--             self.node.info_scorll:setContentSize(640,240)
--             self.node.info_bg:setPosition(self.node.bg:getContentSize().width*0.5,self.node.bg:getContentSize().height*0.5)
--             self.node.ok_btn_1:setPositionX(self.node.bg:getContentSize().width*0.5)
--             self.node.ok_btn_2:setPositionX(self.node.bg:getContentSize().width*0.3)
--             self.node.cancel_btn_2:setPositionX(self.node.bg:getContentSize().width*0.7)
--             self.node.info_scorll:setPosition(self.node.bg:getContentSize().width*0.5,self.node.bg:getContentSize().height*0.6)
--             self.node.info:setContentSize(600,self.node.info:getContentSize().height)
--         end
--     else
--         self.node.bg2:show()
--         self.node.bg:hide()
--     end

-- 	self.info = info
-- 	local textInfo = self.node.info
-- 	local scrollInfo = self.node.info_scorll 
-- 	if info and info.info_txt then
-- 		textInfo:setTextAreaSize(cc.size(textInfo:getContentSize().width,0))
-- 		textInfo:ignoreContentAdaptWithSize(true)
-- 		textInfo:setString(info.info_txt)  
-- 		if nil == scrollInfo then
-- 			return 
-- 		end
-- 		local textInfoHeight = textInfo:getContentSize().height
-- 		local scrollSize = cc.size(scrollInfo:getInnerContainerSize().widht, scrollInfo:getInnerContainerSize().height)
-- 		local textInfoPosY =  textInfo:getPositionY()
-- 		local offHeight = textInfoHeight -  scrollSize.height
--         textInfo:setPositionX(textInfo:getContentSize().width*0.5)
-- 		if offHeight > 0 then
-- 			scrollInfo:setInnerContainerSize(cc.size(scrollSize.widht, offHeight + scrollSize.height))
-- 		end 
--         textInfo:setPositionY(scrollInfo:getInnerContainerSize().height - textInfoHeight*0.5)
-- 	end
-- end

function DuihuanTipsLayer:notScroll()
    local scrollInfo = self.node.info_scorll 
    if scrollInfo then
        scrollInfo:setEnabled(false)
    end
end

function DuihuanTipsLayer:OkClick()
	if self.mid_click then
		self.mid_click()
	end

	if self.left_click then
		self.left_click()
	end
	
	if self.part then
		self.part:deactivate()
	end  
end

function DuihuanTipsLayer:CancelClick()
	-- body
	if self.right_click then
		self.right_click()
	end

	if self.part then
		self.part:deactivate()
	end
end

-- DuihuanTipsPart.TEXT_ZDL = 1  --文字+知道了按钮
-- DuihuanTipsPart.ITEMS_ZDL = 2  --恭喜您，获得+奖励内容+知道了按钮
-- DuihuanTipsPart.ITEMS_LJLQ = 3  --恭喜您，获得+奖励内容+立即领取按钮
-- DuihuanTipsPart.ITEMS_WXKF_QD = 4  --恭喜您，获得+奖励内容+微信客服+确定按钮
-- DuihuanTipsPart.ITEMS_LJDH_SHDH = 5  --恭喜您，获得+奖励内容+立即领取+稍后领取按钮
-- DuihuanTipsPart.ITEMS_LJFX_SHFX = 6  --恭喜您，获得+奖励内容+立即分享+稍后分享按钮

function DuihuanTipsLayer:setInfo(data)

    print("DuihuanTipsLayer ", data)

    self.mid_click = data.mid_click
    self.left_click = data.left_click
    self.right_click = data.right_click

    self:updateTextStat(data.txtType, data.txtLines)
    self:updateBtnStat(data.btnType)
end

function DuihuanTipsLayer:updateTextStat(txtType, data)
    local content = ""
    
    print("txtType, data ", txtType, data)

    if #data > 1 then
        self.node.upInfo:show()
        self.node.upInfo:setString(data[1])
        self.node.downInfo:show()
        self.node.downInfo:setString(data[2])
        self.node.info:hide()
    else
        self.node.upInfo:hide()
        self.node.downInfo:hide()
        self.node.info:show()
        self.node.info:setString(data[1])
    end

    -- if txtType == self.part.ITEMS_WXKF_QD then
    --     print("XXXXXX ----1-----")
    --     content = data.before_item
    --     for _,item in pairs(data.items) do
    --         content = content .. item.count .. item.count_type
    --     end

    --     self.node.upInfo:show()
    --     self.node.upInfo:setString(content)

    --     self.node.downInfo:show()
    --     self.node.downInfo:setString(data.info_wxkf)

    --     self.node.info:hide()
    -- else
    --     print("XXXXXX ----2-----")
    --     if txtType == self.part.TEXT_ZDL then
    --         print("XXXXXX ----3-----")
    --         content = data
    --     elseif txtType == self.part.ITEMS_LJLQ 
    --         or txtType == self.part.ITEMS_WXKF_QD 
    --         or txtType == self.part.ITEMS_LJDH_SHDH
    --         or txtType == self.part.ITEMS_LJFX_SHFX 
    --         or txtType == self.part.ITEMS_ZDL then
    --         print("XXXXXX ----4-----")
    --         content = data.before_item
    --         for _,item in pairs(data.items) do
    --             print("XXXXXX ----5----- ", item)
    --             content = content .. item.name .. item.count .. item.count_type
    --         end
    --     end

    --     self.node.upInfo:hide()
    --     self.node.downInfo:hide()

    --     self.node.info:show()
    --     self.node.info:setString(content)
    -- end    
end

function DuihuanTipsLayer:updateBtnStat(btnType)
    local btnNum = 1
    if btnType == self.part.TEXT_ZDL or btnType == self.part.ITEMS_ZDL then
        btnNum = 1
        self.node.image_ok_1:loadTexture(self.res_base .. "/btn_txt_zdl.png")
        self.node.image_ok_1:setContentSize(cc.size(95, 36))
    elseif btnType == self.part.ITEMS_LJLQ then
        btnNum = 1
        self.node.image_ok_1:loadTexture(self.res_base .. "/btn_txt_ljlq.png")
        self.node.image_ok_1:setContentSize(cc.size(126, 37))
    elseif btnType == self.part.ITEMS_WXKF_QD then
        btnNum = 1
        self.node.image_ok_1:loadTexture(self.res_base .. "/btn_txt_qd.png")
        self.node.image_ok_1:setContentSize(cc.size(66, 37))
    elseif btnType == self.part.ITEMS_LJDH_SHDH then
        btnNum = 2
        self.node.image_ok_2:loadTexture(self.res_base .. "/btn_txt_ljdh.png")
        self.node.image_cancel_2:loadTexture(self.res_base .. "/btn_txt_shdh.png")
        self.node.image_ok_2:setContentSize(cc.size(126, 37))
        self.node.image_cancel_2:setContentSize(cc.size(126, 37))
    elseif btnType == self.part.ITEMS_LJFX_SHFX then
        btnNum = 2
        self.node.image_ok_2:loadTexture(self.res_base .. "/btn_txt_ljfx.png")
        self.node.image_cancel_2:loadTexture(self.res_base .. "/btn_txt_shfx.png")
        self.node.image_ok_2:setContentSize(cc.size(125, 38))
        self.node.image_cancel_2:setContentSize(cc.size(125, 38))
    end

    if btnNum == 1 then
        self.node.type_1:show()
        self.node.type_2:hide()
    else
        self.node.type_1:hide()
        self.node.type_2:show()
    end
end

return DuihuanTipsLayer