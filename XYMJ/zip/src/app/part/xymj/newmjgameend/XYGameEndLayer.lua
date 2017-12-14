--
-- Author: Your Name
-- Date: 2016-12-08 14:54:30
--

--[[
	云南的牌局结束界面处理
--]]

local GameEndLayer = import(".GameEndLayer")
local XYGameEndLayer = class("XYGameEndLayer",GameEndLayer)
require("app.model.protobufmsg" .. (PartConfig.prePath or "") .. ".player_game_over_ack_pb")

function XYGameEndLayer:setData(data,tablepos,lastRound,cur_hand,total_hand,tableId)
	-- body
	--time
	local date_txt =os.date("%Y/%m/%d %H:%M")
	self.node.time_txt:show()
	self.node.time_txt:setString(date_txt)

	if tableId>0 then
		self:setRoomId(tableId)		
	else
		self:setRoomId(data.roomid)		
	end
	self:setSetNum(cur_hand,total_hand,data.isviptable)
	
	if lastRound == true then
		self.node.next_btn:loadTextureNormal(self.res_base .. "/check_result_btn.png",1)
	end
	
	--沒有用到
	--local user = global:getGameUser()
	--local m_id = user:getProp("uid")
	print("XYGameEndLayer:setData======")
	--Item 為 self.node.result_panel

	local function addKanScript(card)
		local kan_sp = cc.Sprite:create(self.res_base .. "/kanScript.png")
		kan_sp:setAnchorPoint(cc.p(0,0))
		card:addChild(kan_sp)
		kan_sp:setLocalZOrder(30)
	end

	local function addShuaiScript(card)
		local kan_sp = cc.Sprite:create(self.res_base .. "/shuaiScript.png")
		kan_sp:setPosition(cc.p(0,20))
		kan_sp:setAnchorPoint(cc.p(-0.5,-0.5))
		card:addChild(kan_sp)
		kan_sp:setLocalZOrder(30)
	end

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
		local info  = v.name--名字加描述： 默默 胡牌
		if string.utf8len(info) > 5 then
			info = string.utf8sub(info,1,5)
			info = info .."..."
		end
		info_txt:setString(info.."")
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

		print("==================================================")
		self:updateHuPaiResult(card_node1,v.huResult)

		local perpcgMargin =10*6/2   --每对吃碰杠的间隙
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
					local card = self.card_sprite:createHandCard(RoomConfig.MySeat,card_value[m],false)
					if showKanpaiIcon then 
						if bit._and(self.part:getPlaywayType(),0x40400) == 0x40400 then
							addShuaiScript(card)
						else
					 		addKanScript(card)
					 	end
					end
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

				--取出k .chuOffset
				--转换为对应的人 
				--local startX = x_offset-widthPer*card_num+marginChiPengGangX
				-- local startX = indexStart +35

				-- local pengChiGangTotal = widthPer*card_num
				-- print("pengChiGangTotal-------------------:"..pengChiGangTotal)

				-- local pengChiGangInfo_txt=ccui.Text:create()
				-- pengChiGangInfo_txt:setAnchorPoint(cc.p(0,0))
				-- pengChiGangInfo_txt:setFontSize(30)
				-- pengChiGangInfo_txt:setLocalZOrder(1000)
				-- local name = self.part:getChiPengGangName(v.tablepos,k.chuOffset,data)
				-- --local name = "好下dddd"

				-- print("-----------------------------:name"..name)
				-- --pengChiGangInfo_txt:setString(string.utf8sub(name,1,5))
				-- pengChiGangInfo_txt:setString(name)

				-- card_node:addChild(pengChiGangInfo_txt)
				-- local x = pengChiGangTotal/2- pengChiGangInfo_txt:getContentSize().width/2
				-- --local x = 0

				-- print("x-------------------:"..x)
				-- pengChiGangInfo_txt:setPosition(cc.p(startX+x,-90))
				-- if data.hucards[i] > 0 then
				-- 	pengChiGangInfo_txt:setColor(cc.c3b(246, 237, 194))
				-- else
				-- 	pengChiGangInfo_txt:setColor(cc.c3b(190, 223, 220))
				-- end

				x_offset = x_offset + perpcgMargin
			end
		end

		self:setItemBg(img_bg,data.hucards[i]>0,info_txt,des_txt)

		--local player_game_over_ack = data.PlayerGameOverAck
		local xy_pgo_ack = data.Extensions[xy_player_game_over_ack_pb.XYPlayerGameOverAck.xyExt]

		local kanpai_datas = xy_pgo_ack and xy_pgo_ack.playerKanPaiCards[i] or {}
		local shuaipai_datas = xy_pgo_ack and xy_pgo_ack.playerShuaiPaiCards[i] or {}

		--创建手牌:	去掉吃碰杠的牌
		-- for i,v in ipairs(data.handcard) do
		for j,k in ipairs(data.handcard[i].cardvalue) do
			-- local card = self.card_sprite:createEndCard(k)
			local card = self.card_sprite:createHandCard(RoomConfig.MySeat,k,false)

			local content_size = card:getContentSize()

			content_size.width = content_size.width -marginX
			if widthPer==nil then
				widthPer= content_size.width
			end

			local pos = cc.p(j*content_size.width+x_offset,0)
			card:setPosition(pos)
			card_node:addChild(card)

			local showKanpaiIcon = false
			for idx,kanpai_val in pairs(kanpai_datas.cardvalue or {}) do

				if kanpai_val == k then
					kanpai_datas.cardvalue[idx] = 0
					showKanpaiIcon = true
					break
				end
			end

			if showKanpaiIcon then
			 	addKanScript(card)
			end

			local showShuaipaiIcon = false
			for idx,shuaipai_val in pairs(shuaipai_datas.cardvalue or {}) do

				if shuaipai_val == k then
					shuaipai_datas.cardvalue[idx] = 0
					showShuaipaiIcon = true
					break
				end
			end

			if showShuaipaiIcon then
			 	addShuaiScript(card)
			end

			if j==#data.handcard[i].cardvalue and  data.hucards[i] > 0 then
				local poshupai = cc.p(card:getPositionX()+content_size.width+perpcgMargin*1.2,0)
				-- local hupaiCard = self.card_sprite:createEndCard(data.hucards[i])
				local hupaiCard = self.card_sprite:createHandCard(RoomConfig.MySeat,data.hucards[i],false)
				-- self.card_sprite:createHandCard( RoomConfig.MySeat,card_value[m],false)
				card_node1:show()
				hu_card:hide() 
				hupaiCard:setPosition(poshupai)
				card_node:addChild(hupaiCard)
			end
		end

	end
end

--設置項背景
function XYGameEndLayer:setItemBg(item,b,info_txt,desc_txt)
	local color = cc.c3b(210, 244, 241)
	if b ==true then
		local bright=self.res_base .."/gameOverEndItemBgHu.png"
		item:loadTexture(bright)
		color = cc.c3b(255, 246, 202)
		desc_txt:setColor(cc.c3b(255, 235, 135))
	else
		local normal=self.res_base .."/gameOverEndItemBg.png"
		item:loadTexture(normal)
	end
	info_txt:setColor(color)
end

function XYGameEndLayer:setRoomId(rooId)
	self.node.housenumshow_txt:setString(""..rooId)
end

--點炮
function XYGameEndLayer:setDianPao(card_node1,hu_icon,b,hu_card)
	if b then
		local path=self.res_base .."/dianpao.png"
		hu_card:hide()
		card_node1:show()
		hu_icon:loadTexture(path)
	end 
end

--[[
function XYGameEndLayer:setPlayerTag(card_node1,info)
	local tDianPao=string.find(info,"点炮")  --TODO
	local tZiMo =string.find(info,"自摸")
	local tHuPai =string.find(info,"胡牌")
	local dianpao_icon= card_node1:getChildByName("dianpao_icon")
	local zimo_icon= card_node1:getChildByName("zimo_icon")
	local hu_icon= card_node1:getChildByName("hu_icon")


	if tDianPao ~=nil then
		print("点炮点炮点炮点炮点炮")
		card_node1:show()
		dianpao_icon:show()
	end
 	if tZiMo ~=nil then
 		print("自摸自摸自摸")
 		card_node1:show()
 		zimo_icon:show()
	end
 	if tHuPai ~=nil then
 		print("胡牌胡牌胡牌胡牌")
		card_node1:show()
		hu_icon:show()
	end
end
--]]
function XYGameEndLayer:setSetNum(cur_hand,total_hand,viptableid)
	if tonumber(viptableid) == 0 then
		self.node.setnumshow_txt:setString("1/1")
	else
		self.node.setnumshow_txt:setString(cur_hand.."/"..total_hand)
	end
end

return XYGameEndLayer