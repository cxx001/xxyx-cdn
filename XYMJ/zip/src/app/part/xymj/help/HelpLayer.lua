--[[
	界面处理需要保证就算是错误数据也做到不崩溃--[[
*名称:HelpLayer
*描述:玩法介绍界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local HelpLayer = class("HelpLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
function HelpLayer:onCreate(data) --传入数据
	-- body
	self:addMask()
	self:initWithFilePath("HelpLayer",CURRENT_MODULE_NAME)

    local scale = display.width/1280
    self.node.bg:setScale(scale)
	self.rule1 = 1
	self.rule2 = 1
	for i=1,2 do
		HelpLayer["ChooseSelect" .. i] = function(self)
			self.part:selectChoose(i)
		end
	end
	self.node["CheckBox_select1"]:setTouchEnabled(false)

	for i=1,4 do
		HelpLayer["ruleSelectEvent" .. i] = function(self)
			self.part:selectrule(i)
		end
	end
	
	self.node["game_list"]:setScrollBarEnabled(false)
	self.node["rule_select1"]:setTouchEnabled(false)
	self:refreshScrollSize()
end

function HelpLayer:selectChoose(rule_type)
	-- body
	for i=1,2 do --关闭当前选择
        if i ~= 2 then
            if i ~= rule_type then
                self.node["choose_select" .. i]:setSelected(false)
                self.node["choose_select" .. i]:setTouchEnabled(true)
                self.isSelect = true
            else 
                self.node["choose_select" .. i]:setSelected(true)
                self.node["choose_select" .. i]:setTouchEnabled(false)
                self.isSelect = false
            end
        end
	end

	if rule_type == 1 then
		self.node.rule_select3:show()
		self.node.rule_select4:show()
	elseif rule_type == 2 then
		self.node.rule_select3:hide()
		self.node.rule_select4:hide()
	end
	self.rule1 = rule_type
	self.part:selectrule(1)
end

function HelpLayer:selectrule(rule_type)
	-- body
	self.node.rule_scroll:jumpToTop()
	for i=1,4 do --关闭当前选择
		if i ~= rule_type then
			self.node["rule_select" .. i]:setSelected(false)
			self.node["rule_select" .. i]:setTouchEnabled(true)
            if i == 1 then
                self.node["CheckBox_basicrule"]:setSelected(false)
                self.node["CheckBox_basicrule"]:setTouchEnabled(true)
            elseif i == 2 then
                self.node["CheckBox_basicsome"]:setSelected(false)
                self.node["CheckBox_basicsome"]:setTouchEnabled(true)
            elseif i == 3 then
                self.node["CheckBox_hptype"]:setSelected(false)
                self.node["CheckBox_hptype"]:setTouchEnabled(true)
            else
                self.node["CheckBox_hptype_0"]:setSelected(false)
                self.node["CheckBox_hptype_0"]:setTouchEnabled(true)
            end
			self.isSelect = true
		else 
			self.node["rule_select" .. i]:setSelected(true)
			self.node["rule_select" .. i]:setTouchEnabled(false)
           	if i == 1 then
           		self.node.rule:setContentSize(756,1312)
                self.node["CheckBox_basicrule"]:setSelected(true)
                self.node["CheckBox_basicrule"]:setTouchEnabled(false)
            elseif i == 2 then
            	self.node.rule:setContentSize(756,738)
                self.node["CheckBox_basicsome"]:setSelected(true)
                self.node["CheckBox_basicsome"]:setTouchEnabled(false)
            elseif i == 3 then
                self.node["CheckBox_hptype"]:setSelected(true)
                self.node["CheckBox_hptype"]:setTouchEnabled(false)
            else
                self.node["CheckBox_hptype_0"]:setSelected(true)
                self.node["CheckBox_hptype_0"]:setTouchEnabled(false)
            end
			self.isSelect = false
		end
	end

	self.rule2 = rule_type
	local Filename = self.res_base.."/".."rule"..self.rule1.."type"..self.rule2..".png"
    if self.rule2 == 1 then
        Filename = self.res_base.."/".."rule".."type"..".png"
    end
	print("Filename : ",Filename)
	self.node.rule:loadTexture(Filename)
	--local s_size = self.node.rule:getVirtualRendererSize()
	self:refreshScrollSize()
end

function HelpLayer:CloseClick()
    global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
	self.part:deactivate()
end

function HelpLayer:refreshScrollSize()
	self.node.rule_scroll:setInnerContainerSize(self.node.rule:getContentSize())
	self.node.rule:setPosition(cc.p(self.node.rule:getPosition(), self.node.rule_scroll:getInnerContainerSize().height))
end

return HelpLayer