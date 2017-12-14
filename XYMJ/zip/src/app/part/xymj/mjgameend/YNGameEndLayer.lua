--
-- Author: Your Name
-- Date: 2016-12-08 14:54:30
--

--[[
	云南的牌局结束界面处理
--]]

local GameEndLayer = import(".GameEndLayer")
local YNGameEndLayer = class("YNGameEndLayer",GameEndLayer)
local CURRENT_MODULE_NAME = ...
function YNGameEndLayer:onCreate()
	-- body
	self:addMask()
	self:initWithFilePath("GameEndLayer",CURRENT_MODULE_NAME)
	self.node.result_list:setItemModel(self.node.result_panel)
	self.card_sprite = import("..mjcard.CardFactory",CURRENT_MODULE_NAME)
	--self.card_sprite = require("app.part.mjcard.HBCardFactory").new(self)
	self.card_sprite:init("app/part/mjcard/res")
end
function YNGameEndLayer:setData(data , tablepos,lastRound)
	-- body
	local date_txt =os.date("%Y/%m/%d %H:%M")
	self.node.time_txt:show()
	self.node.time_txt:setString(date_txt)
	
	if lastRound == true then
		self.node.next_btn:loadTextureNormal(self.res_base .. "/check_result_btn.png",1)
	end
	
	local user = global:getGameUser()
	local m_id = user:getProp("uid")
	
	local mInfo = nil

	
	local playerInfoList = {}
	for i,v in ipairs(data.players) do
		if tostring(v.playerIndex) == tostring(m_id) then
			mInfo = v 
		else
			table.insert(playerInfoList, v)
		end 
	end
	table.insert(playerInfoList, mInfo)  
	self.refPlayers = data.players

	

	--print("GameEndLayer:setData======")
	for i,v in ipairs(playerInfoList) do
		local userID = v.playerIndex


		self.node.result_list:insertDefaultItem(i-1)
		local item = self.node.result_list:getItem(i-1)
		local info_txt = item:getChildByName("info_txt")
		local score_txt = item:getChildByName("score_txt")
		local card_node = item:getChildByName("card_node")
		local card_node1 = item:getChildByName("card_node_1")
		local hu_card = card_node1:getChildByName("hu_card")
		local banker_icon = item:getChildByName("banker_icon")
		local info  = v.name .. " " .. v.desc
		info_txt:setString(info)
		score_txt:setString("")
		local score_txt1 = item:getChildByName("score_txt1")
		local score_txt2 = item:getChildByName("score_txt2")
		if v.coin > 0 then
			score_txt1:setString("/"..v.coin)
			score_txt2:setString("")
		elseif v.coin == 0 then
			score_txt2:setString("0")
			score_txt1:setString("")
		elseif v.coin < 0 then
			score_txt2:setString("/"..math.abs(v.coin))
			score_txt1:setString("")
		end
		-- if data.dealerpos == v.tablepos then
		-- 	banker_icon:show()
		-- end

		if v.tablepos == tablepos then
			local resource_name = self:getEndType(v)
			self.node.title:ignoreContentAdaptWithSize(true)
			self.node.title:loadTexture(resource_name,1)
		end

		local x_offset = 0
		local content_size = nil 

		local downcardInfo = self:findUserData(userID, data.downcards)
		if downcardInfo ~= nil and downcardInfo.cards ~= nil then --存在碰杠的牌
			for j,k in ipairs(downcardInfo.cards) do
				local card_num = 3
				local card_value = {}
				local end_card_value = k.value or k.cardValue  					--字段命名可能不一致 容错

				if k.type == RoomConfig.Peng or k.type == RoomConfig.Chi or k.type == RoomConfig.PIZI_NOTIFY then
					card_value[1] = bit._and(bit.rshift(end_card_value,0),0xff)
					card_value[2] = bit._and(bit.rshift(end_card_value,8),0xff)
					card_value[3] = bit._and(bit.rshift(end_card_value,16),0xff)
				elseif k.type == RoomConfig.MingGang or k.type == RoomConfig.BuGang or k.type == RoomConfig.AnGang then
					card_num =  4
					card_value[1] = bit._and(end_card_value,0xff)
					card_value[2] = card_value[1]
					card_value[3] = card_value[1]
					card_value[4] = card_value[1]
				end
			
				for m=1,card_num do
					local card = self.card_sprite:createEndCard(card_value[m])
					content_size = card:getContentSize()
					content_size.width = content_size.width -2
					local index = m
					local offset_y = 0
				

					x_offset = (index-1+(j-1)*3)*content_size.width-content_size.width/2+(j-1)*content_size.width/10
					local pos = cc.p(x_offset,offset_y)
					if index == 4 then
						index = 2
						offset_y = -content_size.height/10
						pos = cc.p((index-1+(j-1)*3)*content_size.width-content_size.width/2+(j-1)*content_size.width/10,offset_y)
					end
					card:setPosition(pos)
					card_node:addChild(card)
				end
			end
		end

		if x_offset > 0 then
			x_offset = x_offset + content_size.width/3
		end
 

		local hucardInfo = self:findUserData(userID, data.hucards) 
		if nil ~= hucardInfo and hucardInfo > 0 then
			card_node1:show()
			local frame_name = self.card_sprite:getFrameName(RoomConfig.MySeat,hucardInfo)
			hu_card:loadTexture(frame_name,1)
		else
			print("###[error]hucardInfo is nil which userID is ", userID)
		end

		--创建手牌
		-- for i,v in ipairs(data.handcard) do
		local handcardInfo = self:findUserData(userID, data.handcard)
		if nil ~= handcardInfo and nil ~= handcardInfo.cardvalue then
			for j,k in ipairs(handcardInfo.cardvalue) do
				local card = self.card_sprite:createEndCard(k)
				local content_size = card:getContentSize()
				content_size.width = content_size.width -2
				if x_offset == 0 then
					x_offset = -content_size.width
				end
				
				local pos = cc.p(j*content_size.width+x_offset,0)
				card:setPosition(pos)
				card_node:addChild(card)
			end
		else
			print("###[error]handcardInfo is nil which userID is ", userID)
		end
	end
end

--新增一句吐槽，什么鬼协议，玩家信息竟然和手牌不是一起的数据结构
function YNGameEndLayer:findUserData(userID, inputList)
	if nil == self.refPlayers then
		print("###[YNGameEndLayer:findUserData] self.refPlayers is nil")
		return
	end
	if nil == inputList or nil == next(inputList) then
		print("###[YNGameEndLayer:findUserData] self.inputList is nil or it is empty")
		return
	end
	local refIndex = 0
	for i,v in ipairs(self.refPlayers) do
		if v.playerIndex == userID then 
			refIndex = i
			print("###[YNGameEndLayer:findUserData]find the index ",refIndex)
			break
		end
	end
	print("###[YNGameEndLayer:findUserData] refIndex: ",refIndex) 
	return inputList[refIndex]
end

return YNGameEndLayer