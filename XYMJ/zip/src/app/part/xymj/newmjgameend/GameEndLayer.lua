--[[
*名称:GameEndLayer
*描述:结束结算界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local GameEndLayer = class("GameEndLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
function GameEndLayer:onCreate()
	-- body
	self:addMask()
	self:initWithFilePath("GameEndLayer",CURRENT_MODULE_NAME)

	self.node.result_list:setItemModel(self.node.result_panel)
	self.node.result_list:setScrollBarEnabled(false) 
end

 

function GameEndLayer:setCardPart(cardPart) 
	self.card_sprite = import("..mj3dcard.CardFactory",CURRENT_MODULE_NAME)

	-- self.card_sprite = import("../mj3dcard.CardFactory",CURRENT_MODULE_NAME)
	self.card_sprite:init(cardPart.view.res_base)
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/end_picture.plist") 

	self.card_sprite:setPart(cardPart) 
end


function GameEndLayer:getEndType(player)
	-- body
	local result = player.gameresult 
	if player.coin == 0 then --没输没赢
		return self.res_base .. "/nothing.png"
	elseif bit._and(result,SocketConfig.MahjongHuCode.ZI_MO) ~= 0 then --自摸
		return self.res_base .. "/zimo.png"
	elseif bit._and(result,SocketConfig.MahjongHuCode.WIN) ~= 0 then
		return self.res_base .. "/hupai.png"
	elseif bit._and(result,SocketConfig.MahjongHuCode.DIAN_PAO) ~= 0 then 
		return self.res_base .. "/dianpaosss.png"
	elseif bit._and(result,SocketConfig.MahjongHuCode.LIU_JU) ~= 0 then
		return self.res_base .. "/liuju.png"
	else --输
		return self.res_base .. "/lose.png"
	end
end

function GameEndLayer:hideBackBtn()
	-- body
	self.node.return_btn:hide()
end

function GameEndLayer:setData(data , tablepos,lastRound,cur_hand,total_hand,tableId)
	-- body
	local date_txt =os.date("%Y%m%d %H:%M")
	self.node.time_txt:setString(date_txt)

	local user = global:getGameUser()
	local m_id = user:getProp("uid")

	for i,v in ipairs(data.players) do
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
		score_txt:setString(v.coin)
		print("data.macard->",data.macard[i])
		local ma = data.macard[i]
		if ma > 0 then
			card_node1:show()
			local mma=  bit._and(ma,0xffffffff)
			local m2 = bit.rshift(data.hucards[i],8)
			mma = bit._or(mma,bit.lshift(m2,30))
			local num = 0
			for i=1,5 do
				local m = bit._and(bit.rshift(mma,(i-1)*6),0x3f)
				if m ~= 0 then
					num = num + 1
				end
			end
			
			--云南麻将 除了血战，其他都没有 下码
			--[[
			local ma_bg = card_node1:getChildByName("ma_bg")
			for j= 1,num do
				local m = bit._and(bit.rshift(mma,(j-1)*6),0x3f)
				local ma_node = ma_bg:getChildByName("ma" .. j)
				local frame_name = self.card_sprite:getFrameName(RoomConfig.MySeat,m)
				ma_node:loadTexture(frame_name,1)
			end
			]]

		end

		if data.dealerpos == v.tablepos then
			banker_icon:show()
		end

		if v.tablepos == tablepos then
			local resource_name = self:getEndType(v)
			self.node.title:ignoreContentAdaptWithSize(true)
			self.node.title:loadTexture(resource_name,1)
		end

		local x_offset = 0
		local content_size = nil 
		if data.downcards[i] ~= nil and data.downcards[i].cards ~= nil then --存在碰杠的牌
			for j,k in ipairs(data.downcards[i].cards) do
				local card_num = 3
				local card_value = {}
				local end_card_value = k.value or k.cardValue  					--字段命名可能不一致 容错

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


		if data.hucards[i] > 0 then
			local frame_name = self.card_sprite:getFrameName(RoomConfig.MySeat,data.hucards[i])
			hu_card:loadTexture(frame_name,1)
		end

		--创建手牌
		-- for i,v in ipairs(data.handcard) do
		for j,k in ipairs(data.handcard[i].cardvalue) do
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
	end
end

--新增小结算玩家胡牌结果字段
function GameEndLayer:updateHuPaiResult(card_node1,result)
	print("result:-----------------------.."..result)
	local tResultDes = {}
	tResultDes.MOU_REN 	=0 --默认
	tResultDes.ZI_MO 	=1 --自摸
	tResultDes.HU_PAI 	=2 --接炮（胡牌）
	tResultDes.DIAN_PAO =3 --点炮
	tResultDes.LIU_JU 	=4 --流局

	local hu_icon     = card_node1:getChildByName("hu_icon")
	local zimo_icon     = card_node1:getChildByName("zimo_icon")
	local dianpao_icon     = card_node1:getChildByName("dianpao_icon")
	local luiju_icon     = card_node1:getChildByName("luiju_icon")

	if result == tResultDes.MOU_REN then
	elseif result ==tResultDes.ZI_MO then
		card_node1:show()
		if zimo_icon then
			zimo_icon:show()
		end
	elseif result ==tResultDes.HU_PAI then
		card_node1:show()
		if hu_icon then
			hu_icon:show()
		end
	elseif result ==tResultDes.DIAN_PAO then
		card_node1:show()
		if dianpao_icon then
		   dianpao_icon:show()
		end
	elseif result ==tResultDes.LIU_JU then
		card_node1:show()
		if  luiju_icon then
			luiju_icon:show()
		end
	end
end


function GameEndLayer:NextClick()    
	self.part:nextGame()
end

function GameEndLayer:backEvent()
	-- body
	self.part:nextGame()
end

function GameEndLayer:BackClick() 
	self.part:returnGame()
end

return GameEndLayer