--[[
	云南的打牌界面处理
--]]

local CardLayer = import(".CardLayer")
local BSCardLayer = class("BSCardLayer",CardLayer)

--云南杠牌处理
function BSCardLayer:GangPicClick()
	-- body
    self.part:gangClick() --杠的测试
	self:setGangPicState(false)
end

--杠的同牌不同组合 的选择列表
function BSCardLayer:showGangList(gangList)
	--显示可以杠的列表
	self.node.ma_list2:show()
	self.node.ma_list2:removeAllChildren()
	self.node.ma_list2:setItemModel(self.node.ma_panel1)

	local size_x = 0
	local size_y = self.node.ma_list2:getContentSize().height

	for i,v in ipairs(gangList) do
		self.node.ma_list2:insertDefaultItem(i-1)
		local item = self.node.ma_list2:getItem(i-1)
		for j = 1,4 do
			local c1 = bit._and(bit.rshift(v.cardValue,(j-1)*8),0xff)
			local type,value = self.card_factory:decodeValue(c1)
    		local ma = item:getChildByName("ma" .. j)
			local texture_name = string.format("%s/mine/M_%s_%d.png",self.res_base, RoomConfig.CardType[type],value)
			ma:loadTexture(texture_name,1)
			size_x = size_x + ma:getContentSize().width
		end
		size_x = size_x +5
	end
	size_x = size_x -5
	local size = cc.size(size_x,size_y)
	self.node.ma_list2:setContentSize(size)

	self.node.ma_list2:forceDoLayout()
	self.node.ma_list2:jumpToPercentHorizontal(50)
	self.node.ma_list2:addEventListener(function(ref,event)
		-- body
		if event == 1 then
	
			local select_index = self.node.ma_list2:getCurSelectedIndex()
			--发送请求杠牌
			self:hideOpt()
			self.part:requestOptCard(RoomConfig.Gang,gangList[select_index+1].cardValue)
		end
	end)
end

--杠的不同牌 单个选择列表
function BSCardLayer:showGangSelect(gangList)
	-- body
	self.node.ma_list1:show()
	local size_x = 0
	local size_y = self.node.ma_list1:getContentSize().height
	for i,v in ipairs(gangList) do
		self.node.ma_list1:insertDefaultItem(i-1)
		local item = self.node.ma_list1:getItem(i-1)
		local c1 = bit._and(v,0xff)
		local type,value = self.card_factory:decodeValue(c1)
    	local ma = item:getChildByName("ma1")
    	size_x = size_x + ma:getContentSize().width+3
		local texture_name = string.format("%s/mine/M_%s_%d.png",self.res_base, RoomConfig.CardType[type],value)
		ma:loadTexture(texture_name,1)
	end

	local size = cc.size(size_x,size_y)
	self.node.ma_list1:setContentSize(size)
	self.node.ma_list1:jumpToPercentHorizontal(50)

	self.node.ma_list1:addEventListener(function(ref,event)
		-- body
		if event == 1 then
			local select_index = self.node.ma_list1:getCurSelectedIndex()
			local c1 = bit._and(gangList[select_index + 1],0xff)
			self.part:selectGang(c1)
		end
	end)
end

--显示碰杠过操作
function BSCardLayer:showOpt(type,value)
	-- body
	self.card_touch_enable  = false
	if type == RoomConfig.MingGang then
		self.opt_show = true
		self.node.gang_btn:show()
		self.node.peng_btn:show()
		self.node.guo_btn:show()
	elseif type == RoomConfig.AnGang or type == RoomConfig.BuGang then
		self.opt_show = true
		self.node.gang_btn1:show()
		self.node.guo_btn:show()
	elseif type == RoomConfig.Peng then
		self.opt_show = true
		self.node.peng_btn:show()
		self.node.guo_btn:show()
	elseif type == RoomConfig.Hu then --胡的显示
	elseif type == RoomConfig.CHI then --吃的显示
		self.opt_show = true
		self.node.peng_btn:show()
		self.node.chi_btn:show()
	elseif type == RoomConfig.MAHJONG_OPERTAION_POP_LAST then
		self.opt_show = true
		print("self:showSelectBaoCardOnLayer(value.ocard)->",value.ocard)
		self:showSelectBaoCardOnLayer(value.ocard)	
	end

	for i,v in ipairs(self.card_list[RoomConfig.HandCard][RoomConfig.MySeat]) do
		for j,k in ipairs(value.mcard) do
			if v.card_value == k then
				local content_size = v.card_sprite:getContentSize()
				local pos = cc.pAdd(v.card_pos,cc.p(0,content_size.height*self.StandCardOffset))
				v.card_sprite:setPosition(pos)
			end
		end
	end

	print("this is show opt -------------------------:",self.opt_show)
end

function BSCardLayer:showHuAnimate(viewId,maList)
	-- body
	local card_node = self.node["hcard_node" .. viewId]
	local pos = cc.p(card_node:getPosition())
	self.node.hu_sprite:setPosition(pos)
	self.node.hu_sprite:show()
	--[[ --云南麻将 无码
    self.node.animation:setLastFrameCallFunc(function()
    	-- body
    	if #maList > 0 then
	    	self.node.ma_list1:show()
	    	local function addMa(i)
	    		-- body
	    		if i > #maList then
	    			return
	    		end

	    		local type,value = self.card_factory:decodeValue(maList[i])
	    		self.node.ma_list1:insertDefaultItem(i-1)
	    		local item = self.node.ma_list1:getItem(i-1)
	    		local ma = item:getChildByName("ma1")
				local texture_name = string.format("%s/mine/M_%s_%d.png",self.res_base, RoomConfig.CardType[type],value)
				print("this is ma:",i,#maList,texture_name,ma)
				ma:loadTexture(texture_name,1)
				ma:fadeIn({time= 0.5,onComplete=function()
					-- body
					addMa(i+1)
				end})
				
	    	end
	    	addMa(1)
		end
    end)
	]]
	self.node.animation:play("hu_animate",false)
	--播放胡的音效
	local sex = self.part:getPlayerInfo(viewId).sex
	local seat_id = self.part:getPlayerInfo(viewId).seat_id
	self:playOperateEffect(RoomConfig.MAHJONG_OPERTAION_PLAYER_HU_CONFIRMED,sex,seat_id)
end

return BSCardLayer