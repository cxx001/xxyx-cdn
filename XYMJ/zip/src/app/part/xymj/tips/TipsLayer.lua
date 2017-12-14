--[[
*名称:TipsLayer
*描述:提示界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local TipsLayer = class("TipsLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
function TipsLayer:onCreate(data) --传入数据
	-- body
	self:addMask()
	self:initWithFilePath("TipsLayer",CURRENT_MODULE_NAME)
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
function TipsLayer:setInfo(info)
	-- body
    if info.tipType == nil or info.tipType == 1 then
        self.node.bg:show()
        self.node.bg2:hide()
        if info.left_click == nil then
            self.node.type_1:show()
            self.node.type_2:hide()
        else
            self.node.type_2:show()
            self.node.type_1:hide()
        end
        if info.tipType == nil then
            self.node.info_bg:loadTexture(self.res_base .. "/scale9bg.png",0)
            self.node.info_bg:ignoreContentAdaptWithSize(false)
            self.node.info_bg:setContentSize(460,269)
            self.node.bg:loadTexture(self.res_base .. "/smallbg.png",0)
            self.node.bg:ignoreContentAdaptWithSize(false)
            self.node.bg:setContentSize(482,288)
            self.node.info_bg:setPosition(self.node.bg:getContentSize().width*0.5,self.node.bg:getContentSize().height*0.5)
            self.node.ok_btn_1:setPositionX(self.node.bg:getContentSize().width*0.5)
            --self.node.ok_btn_2:setPositionX(self.node.bg:getContentSize().width*0.3)
            --self.node.cancel_btn_2:setPositionX(self.node.bg:getContentSize().width*0.7)
            self.node.info_scorll:setPositionX(self.node.bg:getContentSize().width*0.5)
        else
            self.node.info_bg:loadTexture(self.res_base .. "/forbg.png",0)
            self.node.info_bg:ignoreContentAdaptWithSize(false)
            self.node.info_bg:setContentSize(752,431)
            self.node.bg:loadTexture(self.res_base .. "/backBoard.png",0)
            self.node.bg:ignoreContentAdaptWithSize(false)
            self.node.bg:setContentSize(774,453)
            self.node.info_scorll:setContentSize(640,240)
            self.node.info_bg:setPosition(self.node.bg:getContentSize().width*0.5,self.node.bg:getContentSize().height*0.5)
            self.node.ok_btn_1:setPositionX(self.node.bg:getContentSize().width*0.5)
            self.node.ok_btn_2:setPositionX(self.node.bg:getContentSize().width*0.3)
            self.node.cancel_btn_2:setPositionX(self.node.bg:getContentSize().width*0.7)
            self.node.info_scorll:setPosition(self.node.bg:getContentSize().width*0.5,self.node.bg:getContentSize().height*0.6)
            self.node.info:setContentSize(600,self.node.info:getContentSize().height)
        end
    else
        self.node.bg2:show()
        self.node.bg:hide()
    end

	self.info = info
	local textInfo = self.node.info
	local scrollInfo = self.node.info_scorll 
	if info and info.info_txt then
		textInfo:setTextAreaSize(cc.size(textInfo:getContentSize().width,0))
		textInfo:ignoreContentAdaptWithSize(true)
		textInfo:setString(info.info_txt)  
		if nil == scrollInfo then
			return 
		end
		local textInfoHeight = textInfo:getContentSize().height
		local scrollSize = cc.size(scrollInfo:getInnerContainerSize().widht, scrollInfo:getInnerContainerSize().height)
		local textInfoPosY =  textInfo:getPositionY()
		local offHeight = textInfoHeight -  scrollSize.height
        textInfo:setPositionX(textInfo:getContentSize().width*0.5)
		if offHeight > 0 then
			scrollInfo:setInnerContainerSize(cc.size(scrollSize.widht, offHeight + scrollSize.height))
		end 
        textInfo:setPositionY(scrollInfo:getInnerContainerSize().height - textInfoHeight*0.5)
	end
end

function TipsLayer:notScroll()
    local scrollInfo = self.node.info_scorll 
    if scrollInfo then
        scrollInfo:setEnabled(false)
    end
end

function TipsLayer:OkClick()
	if self.info and self.info.mid_click then
		self.info.mid_click()
	end

	if self.info and self.info.left_click then
		self.info.left_click()
	end
	
	if self.info and self.part then
		self.part:deactivate()
	end  
end

function TipsLayer:CancelClick()
	-- body
	if self.info and self.info.right_click then
		self.info.right_click()
	end

	if self.part then
		self.part:deactivate()
	end
end

function TipsLayer:onCleanup()
    self.part.view = nil
end

return TipsLayer