
local CreateRoomLayer = import(".CreateRoomLayer")
local XYCreateRoomLayer = class("XYCreateRoomLayer",CreateRoomLayer)

-- function XYCreateRoomLayer:initialize()
-- 	XYCreateRoomLayer.super.initialize(self)
	-- self.node.wanfa_select1:setSelected(true)
	-- self.node.wanfa_select3:setSelected(false)
	-- self.node.times_select1:setSelected(true)
	-- self.node.times_select2:setSelected(true)
-- end

function XYCreateRoomLayer:initCheckList()
	self._ctTb = {}
	self._ctTb[1]= self.node.times_select1
	self._ctTb[2]= self.node.times_select2

	self._ctTb[3]= self.node.wanfa_select1
	self._ctTb[4]= self.node.wanfa_select2
	self._ctTb[5]= self.node.wanfa_select3

	self._ctTb[6]= self.node.wanfa_select4_0
	self._ctTb[7]= self.node.wanfa_select4_1

	self._ctTb[8]= self.node.wanfa_select5_0
	self._ctTb[9]= self.node.wanfa_select5_1

	self._ctTb[10]= self.node.wanfa_select6_0
	self._ctTb[11]= self.node.wanfa_select6_1

	self._ctTb[12]= self.node.aa_select1
	self._ctTb[13]= self.node.aa_select2

	self._ctTb[14]= self.node.wanfa_select0_1
	self._ctTb[15]= self.node.wanfa_select0_2
	self._ctTb[16]= self.node.wanfa_select0_3

	self:updateSelectState()
	self.node.aa_panel:hide()
end

function XYCreateRoomLayer:selectedTime1PayStyle()
	self.node.aa_panel:hide()
	self:AASelectFZZF()
end

function XYCreateRoomLayer:setSelectedTime2PayStyle()
	self.node.aa_panel:show()
	self:AASelectAAZF()
end

function XYCreateRoomLayer:updateCostDiamondOnView(costDiamond)
	print("##CreateRoomLayer:updateCostDiamondOnView: " .. tostring(costDiamond))
	local str = string_table.playway_zuan_shi..costDiamond ..")"		--TODO
	self:setDiamondeStr(str)
end

function XYCreateRoomLayer:setDiamondeStr(costDiamond)
	if self.node.times_select1:isSelected() then
		local diamond_txt1= self.node.times_select1:getChildByName("times_txt_0_0") 
		diamond_txt1:setString(costDiamond)
	end	

	if self.node.times_select2:isSelected() then
		local diamond_txt2= self.node.times_select2:getChildByName("times_txt_0_0") 
		diamond_txt2:setString(costDiamond)
	end	
end

function XYCreateRoomLayer:setDiamode()
	if self.node.times_select1:isSelected() then
		local diamond_txt1= self.node.times_select1:getChildByName("times_txt_0_0") 
		local diamond_txt2= self.node.times_select2:getChildByName("times_txt_0_0") 
		if diamond_txt1 and diamond_txt2 then
			diamond_txt1:show()
			diamond_txt2:hide()
		end
	end

	if self.node.times_select2:isSelected() then
		local diamond_txt1= self.node.times_select1:getChildByName("times_txt_0_0") 
		local diamond_txt2= self.node.times_select2:getChildByName("times_txt_0_0") 
		if diamond_txt1 and diamond_txt2 then
			diamond_txt1:hide()
			diamond_txt2:show()
		end
	end
end

function XYCreateRoomLayer:updateSelectState()
	for k,v in pairs(self._ctTb) do
		local title = v:getChildByName("times_txt")
		local titleSelected = v:getChildByName("times_txt_0")
		if title and titleSelected  then
			if v:isSelected() then
				title:hide()
				titleSelected:show()
			else
				title:show()
				titleSelected:hide()
			end
		end
	end
	self:setDiamode()
end
function XYCreateRoomLayer:initXyCreateroom()
	self.node.wanfa_select3:setSelected(false)
	self.node.times_select1:setSelected(true)
	self.node.times_select1:setTouchEnabled(false)
	self.node.times_select2:setSelected(false)
	self.node.times_select2:setTouchEnabled(true)

	local selected = {"1", "2", "4_0", "5_0", "6_0", "0_1"}
	local unselected =  {"3", "4_1", "5_1", "6_1", "0_2", "0_3"}
	for _,idx in pairs(selected) do
		self.node["wanfa_select"..idx]:setSelected(true)
		self.node["wanfa_select"..idx]:setTouchEnabled(false)
	end
	for _,idx in pairs(unselected) do
		self.node["wanfa_select"..idx]:setSelected(false)
		self.node["wanfa_select"..idx]:setTouchEnabled(true)
	end

	--支付调整位置
 	self.adjust_pos_y = 110
 	self.adjust_pos_y_ls = 210

 	self.xtmj_pos_y = self.node.aa_panel:getPositionY()
 	self.bdy_pos_y = self.node.aa_panel:getPositionY() + self.adjust_pos_y
 	-- self.ls_pos_y = self.node.aa_panel:getPositionY() + self.adjust_pos_y_ls
 	self.ls_pos_y_up = self.node.aa_panel:getPositionY() + self.adjust_pos_y_ls
 	self.ls_pos_y_down = self.node.aa_panel:getPositionY() + self.adjust_pos_y

 	self.ls13579_pos_y = self.node.aa_panel:getPositionY() + self.adjust_pos_y
	self:initCheckList()
end

function XYCreateRoomLayer:TimesSelectEvent1(_, sender, event) 
	if event == ccui.CheckBoxEventType.selected then
		print("xymj TimesSelectEvent1 on select wudazui")
		self.node.times_select1:setSelected(true)
		self.node.times_select1:setTouchEnabled(false)
		self.node.times_select2:setSelected(false)
		self.node.times_select2:setTouchEnabled(true)
		self.part:selectTimes(1)
		self:selectedTime1PayStyle()
		self:updateSelectState()
	elseif event == ccui.CheckBoxEventType.unselected then
		print("xymj TimesSelectEvent1 on unselect wudazui")
	else
	end
end

function XYCreateRoomLayer:TimesSelectEvent2(_, sender, event) 
	if event == ccui.CheckBoxEventType.selected then
		print("xymj TimesSelectEvent2 on select wudazui")
		self.node.times_select2:setSelected(true)
		self.node.times_select2:setTouchEnabled(false)
		self.node.times_select1:setSelected(false)
		self.node.times_select1:setTouchEnabled(true)
		self:updateSelectState()
		self.part:selectTimes(2)
		if self.node.title_bg2 then
			self:setSelectedTime2PayStyle()
		end
	elseif event == ccui.CheckBoxEventType.unselected then
		print("xymj TimesSelectEvent2 on unselect wudazui")
	else
	end
end

function XYCreateRoomLayer:onSelectWDZ(_, sender, event) 
	if event == ccui.CheckBoxEventType.selected then
		if self:isLSSelected() then
			self:setLSWanfaStat("huozui")
		end
		print("xymj create_room on select wudazui")
		self.node.wanfa_select1:setSelected(true)
		self.node.wanfa_select1:setTouchEnabled(false)
		self.node.wanfa_select2:setSelected(false)
		self.node.wanfa_select2:setTouchEnabled(true)
		self.node.wanfa_select3:setSelected(false)
		self.node.wanfa_select3:setTouchEnabled(true)
		self:updateSelectState()
	elseif event == ccui.CheckBoxEventType.unselected then
		print("xymj create_room on unselect wudazui")
	else
		--do nothing
	end
end

function XYCreateRoomLayer:onSelectBGZ(_, sender, event)
	if event == ccui.CheckBoxEventType.selected then
		print("xymj create_room on select bagongzui")
		if self:isLSSelected() then
			self:setLSWanfaStat("sizui")
		end
		if self:isXYMJSelected() then
			self.node.wanfa_select2:setSelected(true)
			self.node.wanfa_select2:setTouchEnabled(false)
			self.node.wanfa_select3:setSelected(false)
			self.node.wanfa_select3:setTouchEnabled(true)
		else
			self.node.wanfa_select1:setSelected(false)
			self.node.wanfa_select1:setTouchEnabled(true)
			self.node.wanfa_select2:setSelected(true)
			self.node.wanfa_select2:setTouchEnabled(false)
			self.node.wanfa_select3:setSelected(false)
			self.node.wanfa_select3:setTouchEnabled(true)			
		end
		self:updateSelectState()
	elseif event == ccui.CheckBoxEventType.unselected then
		print("xymj create_room on unselect bagongzui")
	else
		--do nothing
	end	
end

function XYCreateRoomLayer:onSelectMTP(_, sender, event)
	if event == ccui.CheckBoxEventType.selected then
		if self:isLSSelected() then
			self:setLSWanfaStat("kanjin")
		end
		print("xymj create_room on select mantangpao")
		if self:isXYMJSelected() then
			self.node.wanfa_select2:setSelected(false)
			self.node.wanfa_select2:setTouchEnabled(true)
			self.node.wanfa_select3:setSelected(true)
			self.node.wanfa_select3:setTouchEnabled(false)
		else
			self.node.wanfa_select1:setSelected(false)
			self.node.wanfa_select1:setTouchEnabled(true)
			self.node.wanfa_select2:setSelected(false)
			self.node.wanfa_select2:setTouchEnabled(true)
			self.node.wanfa_select3:setSelected(true)
			self.node.wanfa_select3:setTouchEnabled(false)			
		end
		self:updateSelectState()
	elseif event == ccui.CheckBoxEventType.unselected then
		print("xymj create_room on unselect mantangpao")
	else
		--do nothing
	end
end

function XYCreateRoomLayer:onSelectDP3(_, sender, event)
	if event == ccui.CheckBoxEventType.selected then
		print("xymj create_room on select dian pao shu 3 jia")
		self.node.wanfa_select0_1:setSelected(true)
		self.node.wanfa_select0_1:setTouchEnabled(false)
		self.node.wanfa_select0_2:setSelected(false)
		self.node.wanfa_select0_2:setTouchEnabled(true)
		self.node.wanfa_select0_3:setSelected(false)
		self.node.wanfa_select0_3:setTouchEnabled(true)
		self:updateSelectState()
	elseif event == ccui.CheckBoxEventType.unselected then
		print("xymj create_room on unselect dian pao shu 3 jia")
	else
		--do nothing
	end
end

function XYCreateRoomLayer:onSelectDP1(_, sender, event)
	if event == ccui.CheckBoxEventType.selected then
		print("xymj create_room on select dian pao shu 1 jia")
		self.node.wanfa_select0_1:setSelected(false)
		self.node.wanfa_select0_1:setTouchEnabled(true)
		self.node.wanfa_select0_2:setSelected(true)
		self.node.wanfa_select0_2:setTouchEnabled(false)
		self.node.wanfa_select0_3:setSelected(false)
		self.node.wanfa_select0_3:setTouchEnabled(true)
		self:updateSelectState()
	elseif event == ccui.CheckBoxEventType.unselected then
		print("xymj create_room on unselect dian pao shu 1 jia")
	else
		--do nothing
	end
end

function XYCreateRoomLayer:onSelectZMH(_, sender, event)
	if event == ccui.CheckBoxEventType.selected then
		print("xymj create_room on select zi mo hu")
		self.node.wanfa_select0_1:setSelected(false)
		self.node.wanfa_select0_1:setTouchEnabled(true)
		self.node.wanfa_select0_2:setSelected(false)
		self.node.wanfa_select0_2:setTouchEnabled(true)
		self.node.wanfa_select0_3:setSelected(true)
		self.node.wanfa_select0_3:setTouchEnabled(false)
		self:updateSelectState()
	elseif event == ccui.CheckBoxEventType.unselected then
		print("xymj create_room on unselect zi mo hu")
	else
		--do nothing
	end
end

function XYCreateRoomLayer:onSelectYF(_, sender, event)
	if event == ccui.CheckBoxEventType.selected then
		print("xymj create_room on select youfeng")
		self.node.wanfa_select4_0:setSelected(true)
		self.node.wanfa_select4_0:setTouchEnabled(false)
		self.node.wanfa_select4_1:setSelected(false)
		self.node.wanfa_select4_1:setTouchEnabled(true)
		self:updateSelectState()
	elseif event == ccui.CheckBoxEventType.unselected then
		print("xymj create_room on unselect youfeng")
		if not self:isXYMJSelected() then
			self.node.wanfa_select4_0:setSelected(false)
		end
	else
		--do nothing
	end	
end

function XYCreateRoomLayer:onSelectWF(_, sender, event)
	if event == ccui.CheckBoxEventType.selected then
		print("xymj create_room on select wufeng")
		self.node.wanfa_select4_0:setSelected(false)
		self.node.wanfa_select4_0:setTouchEnabled(true)
		self.node.wanfa_select4_1:setSelected(true)
		self.node.wanfa_select4_1:setTouchEnabled(false)
		self:updateSelectState()
	elseif event == ccui.CheckBoxEventType.unselected then
		print("xymj create_room on unselect wufeng")
	else
		--do nothing
	end	
end

function XYCreateRoomLayer:onSelectYKP(_, sender, event)
	if event == ccui.CheckBoxEventType.selected then
		print("xymj create_room on select youkanpai")
		self.node.wanfa_select5_0:setSelected(true)
		self.node.wanfa_select5_0:setTouchEnabled(false)
		self.node.wanfa_select5_1:setSelected(false)
		self.node.wanfa_select5_1:setTouchEnabled(true)
		self:updateSelectState()
	elseif event == ccui.CheckBoxEventType.unselected then
		print("xymj create_room on unselect youkanpai")
	else
		--do nothing
	end		
end

function XYCreateRoomLayer:onSelectWKP(_, sender, event)
	if event == ccui.CheckBoxEventType.selected then
		print("xymj create_room on select wukanpai")
		self.node.wanfa_select5_0:setSelected(false)
		self.node.wanfa_select5_0:setTouchEnabled(true)
		self.node.wanfa_select5_1:setSelected(true)
		self.node.wanfa_select5_1:setTouchEnabled(false)
		self:updateSelectState()
	elseif event == ccui.CheckBoxEventType.unselected then
		print("xymj create_room on unselect wukanpai")
	else
		--do nothing
	end		
end

function XYCreateRoomLayer:onSelectYNZ(_, sender, event)
	if event == ccui.CheckBoxEventType.selected then
		print("xymj create_room on select younaozhuang")
		self.node.wanfa_select6_0:setSelected(true)
		self.node.wanfa_select6_0:setTouchEnabled(false)
		self.node.wanfa_select6_1:setSelected(false)
		self.node.wanfa_select6_1:setTouchEnabled(true)
		self:updateSelectState()
	elseif event == ccui.CheckBoxEventType.unselected then
		print("xymj create_room on unselect younaozhuang")
	else
		--do nothing
	end		
end

function XYCreateRoomLayer:onSelectWNZ(_, sender, event)
	if event == ccui.CheckBoxEventType.selected then
		print("xymj create_room on select wunaozhuang")
		self.node.wanfa_select6_0:setSelected(false)
		self.node.wanfa_select6_0:setTouchEnabled(true)
		self.node.wanfa_select6_1:setSelected(true)
		self.node.wanfa_select6_1:setTouchEnabled(false)
		self:updateSelectState()
	elseif event == ccui.CheckBoxEventType.unselected then
		print("xymj create_room on unselect wunaozhuang")
	else
		--do nothing
	end		
end

function XYCreateRoomLayer:setLSWanfaStat(playway)
	if playway == "kanjin" then
		local show_item_idx = 
		{
			["1"] = string_table.ls_playway1, 
			["2"] = string_table.ls_playway2, 
			["3"] = string_table.ls_playway3
		}
		local selected_item_idx = {"3"}
		self:setSelectWanfaStat("btn_ls", show_item_idx, selected_item_idx, false)

		self:updateSelectState()
		self.node.aa_panel:setPositionY(self.ls_pos_y_up)
	else
		local show_item_idx = 
		{
			["1"] = string_table.ls_playway1, 
			["2"] = string_table.ls_playway2, 
			["3"] = string_table.ls_playway3,
			["0_1"] = string_table.bdy_playway2,
			["0_2"] = string_table.bdy_playway3,
			["0_3"] = string_table.bdy_playway1,
			["4_0"] = string_table.ls_playway4,
			["4_1"] = string_table.ls_playway5
		}
		local selected_item_idx = {}
		if playway == "huozui" then
			selected_item_idx = {"1", "0_1", "4_0"}
		else 
			selected_item_idx = {"2", "0_1", "4_0"}
		end
		
		self:setSelectWanfaStat("btn_ls", show_item_idx, selected_item_idx, true)

		self:updateSelectState()
		self.node.aa_panel:setPositionY(self.ls_pos_y_down)		
	end
end






-- function XYCreateRoomLayer:setLSWanfaStat(playway)
-- 	if playway == "kanjin" then
-- 		local show_item_idx = 
-- 		{
-- 			["1"] = string_table.ls_playway1, 
-- 			["2"] = string_table.ls_playway2, 
-- 			["3"] = string_table.ls_playway3
-- 		}
-- 		local selected_item_idx = {"3"}
-- 		self:setSelectWanfaStat("btn_ls", show_item_idx, selected_item_idx, false)

-- 		self:updateSelectState()
-- 		self.node.aa_panel:setPositionY(self.ls_pos_y_up)
-- 	else
-- 		local show_item_idx = 
-- 		{
-- 			["1"] = string_table.ls_playway1, 
-- 			["2"] = string_table.ls_playway2, 
-- 			["3"] = string_table.ls_playway3,
-- 			["0_1"] = string_table.bdy_playway2,
-- 			["0_2"] = string_table.bdy_playway3,
-- 			["0_3"] = string_table.bdy_playway1,
-- 			["4_0"] = string_table.ls_playway4,
-- 			["4_1"] = string_table.ls_playway5
-- 		}
-- 		if playway == "huozui" then
-- 			local selected_item_idx = {"1", "0_1", "4_0"}
-- 		else if playway == "sizui" then
-- 			local selected_item_idx = {"2", "0_1", "4_0"}
-- 		else
-- 		end
		
-- 		self:setSelectWanfaStat("btn_ls", show_item_idx, selected_item_idx, true)

-- 		self:updateSelectState()
-- 		self.node.aa_panel:setPositionY(self.ls_pos_y_down)	
-- 	end
-- end

function XYCreateRoomLayer:setAAStat(bSelectFZZF)
	self.node.aa_select1:setSelected(bSelectFZZF)
	self.node.aa_select1:setTouchEnabled((not bSelectFZZF))
	self.node.aa_select2:setSelected((not bSelectFZZF))
	self.node.aa_select2:setTouchEnabled(bSelectFZZF)	
end

function XYCreateRoomLayer:AASelectFZZF()
	self:setAAStat(true)
	self.part:selectPayment(1)	
	self:updateSelectState()
end

function XYCreateRoomLayer:AASelectAAZF()
	self:setAAStat(false)
	self.part:selectPayment(2)
	self:updateSelectState()
end

function XYCreateRoomLayer:isWDZSelected()
	local ret = false
	if self.node.wanfa_select1 and self.node.wanfa_select1:isSelected() then
		ret = true
	end
	return ret
end

function XYCreateRoomLayer:isBGZSelected()
	local ret = false
	if self.node.wanfa_select2 and self.node.wanfa_select2:isSelected() then
		ret = true
	end
	return ret
end

function XYCreateRoomLayer:isMTPSelected()
	local ret = false
	if self.node.wanfa_select3 and self.node.wanfa_select3:isSelected() then
		ret = true
	end
	return ret
end

function XYCreateRoomLayer:isYFSelected()
	local ret = false
	if self.node.wanfa_select4_0 and self.node.wanfa_select4_0:isSelected() then
		ret = true
	end
	return ret
end

function XYCreateRoomLayer:isWFSelected()
	local ret = false
	if self.node.wanfa_select4_1 and self.node.wanfa_select4_1:isSelected() then
		ret = true
	end
	return ret
end

function XYCreateRoomLayer:isYKPSelected()
		local ret = false
	if self.node.wanfa_select5_0 and self.node.wanfa_select5_0:isSelected() then
		ret = true
	end
	return ret
end

function XYCreateRoomLayer:isYNZSelected()
	local ret = false
	if self.node.wanfa_select6_0 and self.node.wanfa_select6_0:isSelected() then
		ret = true
	end
	return ret
end

function XYCreateRoomLayer:isWF01Selected()
	local ret = false
	if self.node.wanfa_select0_1 and self.node.wanfa_select0_1:isSelected() then
		ret = true
	end
	return ret
end

function XYCreateRoomLayer:isWF02Selected()
	local ret = false
	if self.node.wanfa_select0_2 and self.node.wanfa_select0_2:isSelected() then
		ret = true
	end
	return ret
end

function XYCreateRoomLayer:isWF03Selected()
	local ret = false
	if self.node.wanfa_select0_3 and self.node.wanfa_select0_3:isSelected() then
		ret = true
	end
	return ret
end

function XYCreateRoomLayer:onXtmjClick()
	local show_item_idx = 
	{
		["1"] = string_table.xymj_playway1, 
		["2"] = string_table.xymj_playway2, 
		["3"] = string_table.xymj_playway4,
		["0_1"] = string_table.bdy_playway2,
		["0_2"] = string_table.bdy_playway3,
		["0_3"] = string_table.bdy_playway1,
		["4_0"] = string_table.xymj_playway3,
		["4_1"] = string_table.bdy_playway5,
		["5_0"] = string_table.playway_type_ykp,
		["5_1"] = string_table.playway_type_wkp,
		["6_0"] = string_table.playway_type_ynz,
		["6_1"] = string_table.playway_type_wnz,
	}
	local selected_item_idx = {"1", "2", "0_1", "4_0", "5_0", "6_0"}
	self:setSelectWanfaStat("btn_xymj", show_item_idx, selected_item_idx, true)

	self:updateSelectState()
	self.node.aa_panel:setPositionY(self.xtmj_pos_y)
end

function XYCreateRoomLayer:onBdyClick()
	local show_item_idx = 
	{
		["1"] = string_table.bdy_playway2, 
		["2"] = string_table.bdy_playway3, 
		["3"] = string_table.bdy_playway1,
		["0_1"] = string_table.bdy_playway4,
		["0_2"] = string_table.bdy_playway5,
		["4_0"] = string_table.bdy_playway6,
		["4_1"] = string_table.bdy_playway7,
	}
	local selected_item_idx = {"1", "0_1", "4_0"}
	self:setSelectWanfaStat("btn_bdy", show_item_idx, selected_item_idx, true)

	self:updateSelectState()
	self.node.aa_panel:setPositionY(self.bdy_pos_y)
end

function XYCreateRoomLayer:onLsClick()
	-- local show_item_idx = 
	-- {
	-- 	["1"] = string_table.ls_playway1, 
	-- 	["2"] = string_table.ls_playway2, 
	-- 	["3"] = string_table.ls_playway3,
	-- 	["0_1"] = string_table.bdy_playway2,
	-- 	["0_2"] = string_table.bdy_playway3,
	-- 	["0_3"] = string_table.bdy_playway1,
	-- 	["4_0"] = string_table.ls_playway4,
	-- 	["4_1"] = string_table.ls_playway5
	-- }
	-- local selected_item_idx = {"1", "0_1", "4_0"}
	-- self:setSelectWanfaStat("btn_ls", show_item_idx, selected_item_idx, true)

	-- self:updateSelectState()
	-- self.node.aa_panel:setPositionY(self.ls_pos_y_down)	
	self:setLSWanfaStat("huozui")
end

function XYCreateRoomLayer:onLs13579Click()
--	error("123")
	local show_item_idx = 
	{
		["1"] = string_table.bdy_playway2, 
		["2"] = string_table.bdy_playway3, 
		["3"] = string_table.bdy_playway1,
		["0_1"] = string_table.ls13579_playway1,
		["0_2"] = string_table.ls13579_playway2,
		["0_3"] = string_table.ls13579_playway3,
		["4_0"] = string_table.ls13579_playway4,
		["4_1"] = string_table.ls13579_playway5,
	}
	local selected_item_idx = {"1","0_1","4_1"}
	self:setSelectWanfaStat("btn_ls13579", show_item_idx, selected_item_idx, true)

	self:updateSelectState()

	self.node.aa_panel:setPositionY(self.ls13579_pos_y)
end

function XYCreateRoomLayer:setSelectWanfaStat(selected_btn_name, show_item_idx, selected_item_idx, showKexuan)
	local wanfa_btns = {"btn_xymj", "btn_bdy", "btn_ls","btn_ls13579"}
	for _,btn_name in pairs(wanfa_btns) do
		if btn_name == selected_btn_name then
			self.node[btn_name]:setEnabled(false)
		else
			self.node[btn_name]:setEnabled(true)
		end
	end

	local to_selected_item_idx = {}
	for k,v in pairs(selected_item_idx) do
		to_selected_item_idx[v] = k
	end
	local all_wanfa_item_idx = {"1", "2", "3", "0_1", "0_2", "0_3", "4_0", "4_1", "5_0", "5_1", "6_0", "6_1"}
	for _,idx in pairs(all_wanfa_item_idx) do
		if show_item_idx[idx] then
			self.node["wanfa_select"..idx]:show()
			self.node["wanfa_select"..idx]:getChildByName("times_txt"):setString(show_item_idx[idx])
			self.node["wanfa_select"..idx]:getChildByName("times_txt_0"):setString(show_item_idx[idx])
		else
			self.node["wanfa_select"..idx]:hide()
		end

		if to_selected_item_idx[idx] then
			self.node["wanfa_select"..idx]:setSelected(true)
			self.node["wanfa_select"..idx]:setTouchEnabled(false)
		else
			self.node["wanfa_select"..idx]:setSelected(false)
			self.node["wanfa_select"..idx]:setTouchEnabled(true)
		end
	end

	self.node.wanfa_title_kexuan:setVisible(showKexuan)
end

function XYCreateRoomLayer:isXYMJSelected()
	local ret = false
	if self:getSelectWanfaIdx() == 1 then
		ret = true
	end
	return ret
end

function XYCreateRoomLayer:isBDYSelected()
	local ret = false
	if self:getSelectWanfaIdx() == 2 then
		ret = true
	end
	return ret
end

function XYCreateRoomLayer:isLSSelected()
	local ret = false
	if self:getSelectWanfaIdx() == 3 then
		ret = true
	end
	return ret
end

function XYCreateRoomLayer:isLS13579Selected()
	local ret = false
	if self:getSelectWanfaIdx() == 4 then
		ret = true
	end
	return ret
end

function XYCreateRoomLayer:getSelectWanfaIdx()
	local ret = 1 --信阳麻将
	if self.node.btn_bdy and (not self.node.btn_bdy:isEnabled()) then
		ret = 2 --扳倒赢
	elseif self.node.btn_ls and (not self.node.btn_ls:isEnabled()) then
		ret = 3 --罗山玩法
	elseif self.node.btn_ls and (not self.node.btn_ls13579:isEnabled()) then
		ret = 4 --罗山13579玩法
	end
	return ret
end

function XYCreateRoomLayer:setSelectPayment(payment)
	--do nothing
end

return XYCreateRoomLayer





























