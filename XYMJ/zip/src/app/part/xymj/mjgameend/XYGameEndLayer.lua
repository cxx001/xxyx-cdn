--
-- Author: Your Name
-- Date: 2016-12-08 14:54:30
--

--[[
	信阳的牌局结束界面处理
--]]

local GameEndLayer = import(".GameEndLayer")
local XYGameEndLayer = class("XYGameEndLayer",GameEndLayer)
local CURRENT_MODULE_NAME = ...

function XYGameEndLayer:onCreate()
	-- body
	self:addMask()
	self:initWithFilePath("GameEndLayer",CURRENT_MODULE_NAME)
	self.node.result_list:setItemModel(self.node.result_panel)
	self.card_sprite = import("..mjcard.XYCardFactory",CURRENT_MODULE_NAME)
	--self.card_sprite = require("app.part.mjcard.HBCardFactory").new(self)
	self.card_sprite:init("app/part/xymj/mjcard/res")
end



function XYGameEndLayer:setData(data , tablepos,lastRound)
-- body
	--time
	local date_txt =os.date("%Y/%m/%d %H:%M")
	self.node.time_txt:show()
	self.node.time_txt:setString(date_txt)

	-- if tableId>0 then
	-- 	self:setRoomId(tableId)		
	-- else
	-- 	self:setRoomId(data.roomid)		
	-- end
	
	if lastRound == true then
		self.node.next_btn:loadTextureNormal(self.res_base .. "/check_result_btn.png",1)
	end
	
	--沒有用到
	--local user = global:getGameUser()
	--local m_id = user:getProp("uid")
	print("YNGameEndLayer:setData======")
	--Item 為 self.node.result_panel

	for i,v in ipairs(data.players) do
 
		self.node.result_list:insertDefaultItem(i-1)
		local item        = self.node.result_list:getItem(i-1)
		local info_txt    = item:getChildByName("info_txt")
		local score_txt   = item:getChildByName("score_txt")
		local card_node   = item:getChildByName("card_node")
		local card_node1  = item:getChildByName("card_node_1") 
		local hu_card     = card_node1:getChildByName("hu_card")
		local hu_icon     = card_node1:getChildByName("hu_icon")

		local banker_icon = item:getChildByName("banker_icon") --莊家圖標
		local des_txt = item:getChildByName("des_txt") --莊家圖標
		banker_icon:hide()
		local img_bg	  = item:getChildByName("img_bg")

		--local info  = v.name .. " " .. v.desc 	--名字加描述： 默默 胡牌
		local info  = v.name .. " "  	--名字加描述： 默默 胡牌
		info_txt:setString(info)
		local infoOther = ""..v.desc
		des_txt:setString(infoOther)
		 --local tb=string.find(infoOther,"点炮");
		--self:setDianPao(card_node1,hu_icon,tb~=nil,hu_card)
		-- self:setPlayerTag(card_node1,infoOther)
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
		if data.dealerpos == v.tablepos then
			--banker_icon:show()
		end

		if v.tablepos == tablepos then
			local resource_name = self:getEndType(v)
			self.node.title:ignoreContentAdaptWithSize(true)
			self.node.title:loadTexture(resource_name,1)
		end

		local perpcgMargin =20   --每对吃碰杠的间隙
		local marginX =0	     --每张牌大小的偏移量

		local x_offset = 0
		local content_size = nil 
		local widthPer = nil
		local marginChiPengGangX = -40

		if data.downcards[i] ~= nil and data.downcards[i].cards ~= nil then --存在碰杠的牌
			for j,k in ipairs(data.downcards[i].cards) do
				print("data.downcards[i]----------num："..#data.downcards[i].cards)
				print("j--------------------"..j)
				local card_num = 3
				local card_value = {}
				local end_card_value = k.value or k.cardValue  					--字段命名可能不一致 容错
				local kanpaiCardNum = k.usexiaojinum or 0

				if k.type == RoomConfig.Peng or k.type == RoomConfig.Chi then
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
				local indexStart = x_offset

				for m=1,card_num do
					local showKanpaiIcon = false
					if m <= kanpaiCardNum then
						showKanpaiIcon = true
					end

					local card = self.card_sprite:createEndCard(card_value[m], showKanpaiIcon)
					content_size = card:getContentSize()
				
					content_size.width = content_size.width -marginX
					if widthPer==nil then
						widthPer=content_size.width
					end
					local index = m
					local offset_y = 0
					local cardWith = content_size.width--吃碰杠每个牌的位置
					x_offset = x_offset +cardWith 
					local pos = cc.p(x_offset,offset_y)
					card:setPosition(pos)
					card_node:addChild(card)
				end

				-- if data.hucards[i] > 0 then
				-- 	pengChiGangInfo_txt:setColor(cc.c3b(246, 237, 194))
				-- else
				-- 	pengChiGangInfo_txt:setColor(cc.c3b(190, 223, 220))
				-- end

				x_offset = x_offset + perpcgMargin
			end
		end

		--创建手牌:	去掉吃碰杠的牌
		-- for i,v in ipairs(data.handcard) do
		local hupaiMarginX=-perpcgMargin*2
		for j,k in ipairs(data.handcard[i].cardvalue) do
			local card = self.card_sprite:createEndCard(k)
			--local card = self.card_sprite:createHandCard(RoomConfig.MySeat,k,false)

			local content_size = card:getContentSize()

			content_size.width = content_size.width -marginX
			if widthPer==nil then
				widthPer= content_size.width
			end

			local pos = cc.p(j*content_size.width+x_offset,0)
			card:setPosition(pos)
			card_node:addChild(card)
			if j==#data.handcard[i].cardvalue and  data.hucards[i] > 0 then
				local poshupai = cc.p(card:getPositionX()+content_size.width*2+hupaiMarginX,0)
				local hupaiCard = self.card_sprite:createEndCard(data.hucards[i])
				card_node1:show()
				hu_card:hide()
				hupaiCard:setPosition(poshupai)
				card_node:addChild(hupaiCard)
			end
		end

		end
end

-- function XYGameEndLayer:setData(data , tablepos,lastRound)
-- 	-- body
-- 	local date_txt =os.date("%Y/%m/%d %H:%M")
-- 	self.node.time_txt:show()
-- 	self.node.time_txt:setString(date_txt)
	
-- 	if lastRound == true then
-- 		self.node.next_btn:loadTextureNormal(self.res_base .. "/room/resource/end/check_result_btn.png",1)
-- 	end
	
-- 	local user = global:getGameUser()
-- 	local m_id = user:getProp("uid")
-- 	for i,v in ipairs(data.players) do
-- 		self.node.result_list:insertDefaultItem(i-1)
-- 		local item = self.node.result_list:getItem(i-1)
-- 		local info_txt = item:getChildByName("info_txt")
-- 		local score_txt = item:getChildByName("score_txt")
-- 		local card_node = item:getChildByName("card_node")
-- 		local card_node1 = item:getChildByName("card_node_1")
-- 		local hu_card = card_node1:getChildByName("hu_card")
-- 		local banker_icon = item:getChildByName("banker_icon")
-- 		local info  = v.name .. " " .. v.desc
-- 		info_txt:setString(info)
-- 		score_txt:setString("")
-- 		local score_txt1 = item:getChildByName("score_txt1")
-- 		local score_txt2 = item:getChildByName("score_txt2")
-- 		if v.coin > 0 then
-- 			score_txt1:setString("/"..v.coin)
-- 			score_txt2:setString("")
-- 		elseif v.coin == 0 then
-- 			score_txt2:setString("0")
-- 			score_txt1:setString("")
-- 		elseif v.coin < 0 then
-- 			score_txt2:setString("/"..math.abs(v.coin))
-- 			score_txt1:setString("")
-- 		end
-- 		-- if data.dealerpos == v.tablepos then
-- 		-- 	banker_icon:show()
-- 		-- end

-- 		if v.tablepos == tablepos then
-- 			local resource_name = self:getEndType(v)
-- 			self.node.title:ignoreContentAdaptWithSize(true)
-- 			self.node.title:loadTexture(resource_name,1)
-- 		end

-- 		local x_offset = 0
-- 		local content_size = nil 
-- 		if data.downcards[i] ~= nil and data.downcards[i].cards ~= nil then --存在碰杠的牌
-- 			for j,k in ipairs(data.downcards[i].cards) do
-- 				local card_num = 3
-- 				local card_value = {}
-- 				local end_card_value = k.value or k.cardValue  					--字段命名可能不一致 容错
-- 				local kanpaiCardNum = k.usexiaojinum or 0

-- 				if k.type == RoomConfig.Peng or k.type == RoomConfig.Chi then
-- 					card_value[1] = bit._and(bit.rshift(end_card_value,0),0xff)
-- 					card_value[2] = bit._and(bit.rshift(end_card_value,8),0xff)
-- 					card_value[3] = bit._and(bit.rshift(end_card_value,16),0xff)
-- 				elseif k.type == RoomConfig.MingGang or k.type == RoomConfig.BuGang or k.type == RoomConfig.AnGang then
-- 					card_num =  4
-- 					card_value[1] = bit._and(end_card_value,0xff)
-- 					card_value[2] = bit._and(bit.rshift(end_card_value,8),0xff)
-- 					card_value[3] = bit._and(bit.rshift(end_card_value,16),0xff)
-- 					card_value[4] = bit._and(bit.rshift(end_card_value,24),0xff)
-- 				end
			
-- 				for m=1,card_num do
-- 					local showKanpaiIcon = false
-- 					if m <= kanpaiCardNum then
-- 						showKanpaiIcon = true
-- 					end

-- 					local card = self.card_sprite:createEndCard(card_value[m], showKanpaiIcon)
-- 					content_size = card:getContentSize()
-- 					content_size.width = content_size.width -2
-- 					local index = m
-- 					local offset_y = 0
				

-- 					x_offset = (index-1+(j-1)*3)*content_size.width-content_size.width/2+(j-1)*content_size.width/10
-- 					local pos = cc.p(x_offset,offset_y)
-- 					if index == 4 then
-- 						index = 2
-- 						offset_y = -content_size.height/10
-- 						pos = cc.p((index-1+(j-1)*3)*content_size.width-content_size.width/2+(j-1)*content_size.width/10,offset_y)
-- 					end
-- 					card:setPosition(pos)
-- 					card_node:addChild(card)
-- 				end
-- 			end
-- 		end

-- 		if x_offset > 0 then
-- 			x_offset = x_offset + content_size.width/3
-- 		end

-- 		--[[
-- 		if data.hucards[i] > 0 then
-- 			local frame_name = self.card_sprite:getFrameName(RoomConfig.MySeat,data.hucards[i])
-- 			hu_card:loadTexture(frame_name,1)
-- 		end
-- 		]]


-- 		if data.hucards[i] > 0 then
-- 			card_node1:show()
-- 			local frame_name = self.card_sprite:getFrameName(RoomConfig.MySeat,data.hucards[i])
-- 			hu_card:loadTexture(frame_name,1)
-- 		end

-- 		--创建手牌
-- 		-- for i,v in ipairs(data.handcard) do
-- 		for j,k in ipairs(data.handcard[i].cardvalue) do
-- 			local card = self.card_sprite:createEndCard(k)
-- 			local content_size = card:getContentSize()
-- 			content_size.width = content_size.width -2
-- 			if x_offset == 0 then
-- 				x_offset = -content_size.width
-- 			end
			
-- 			local pos = cc.p(j*content_size.width+x_offset,0)
-- 			card:setPosition(pos)
-- 			card_node:addChild(card)
-- 		end
-- 	end
-- end

function XYGameEndLayer:setPlaywayStr(playwatStr)
	if self.node.playway_text then
		self.node.playway_text:setString(playwatStr)
	end
end

return XYGameEndLayer