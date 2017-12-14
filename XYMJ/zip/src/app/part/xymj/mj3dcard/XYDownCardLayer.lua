--[[
 牌局内吃碰杠的牌：待优化
--]]

local DownCardLayer = import(".DownCardLayer")

local XYDownCardLayer = class("XYDownCardLayer",DownCardLayer)

local CURRENT_MODULE_NAME = ...


--bug重现3个2万的那个玩家坎牌

function XYDownCardLayer:init(resBase)


	self.res_base = resBase

	self.card_factory = import(".CardFactory",CURRENT_MODULE_NAME)
	self.card_factory:addSpriteFrames()
	self.naozhuangCardNum = 0
end

--初始化hCard
function XYDownCardLayer:initHcard()
	 self._hCard1 = self._root:getChildByName("hCard1")
	 local node_Center = self._root:getChildByName("Node_Center")
	 self._hCard2 = node_Center:getChildByName("hCard2")
	 self._hCard3 = node_Center:getChildByName("hCard3")
	 self._hCard4 = node_Center:getChildByName("hCard4")

	 self:resetAllDownCard()
end

--重置hCard
function XYDownCardLayer:resetAllDownCard()
	--全部为不可见
	self._hCard1:hide()
	self._hCard2:hide()
	self._hCard3:hide()
	self._hCard4:hide()

	self:hideChildrents(self._hCard1)
	self:hideChildrents(self._hCard2)
	self:hideChildrents(self._hCard3)
	self:hideChildrents(self._hCard4)
end

function XYDownCardLayer:hideChildrents( hCard )
	for k,v in pairs(hCard:getChildren()) do
		v:hide()
	end
end

local down_card_idx = {3, 2, 1, 4, 5}

--tData:吃碰杠数据
--i: 为第几组吃碰杠
--tp:明杠，暗杠等类型
--bKanPai:出现坎牌的张数
function XYDownCardLayer:showDownCard(viewId,tData,i,tp,bKanPai)
	release_print(os.date("%c") .. "[info] 信阳Down页面展示downcard ",viewId,tData,i,tp,bKanPai)
	print("XYDownCardLayer:showDownCard")
 	local hCard = nil
 	local cardBgNameBefore= "mj_bottomcardbg_"
	if viewId == RoomConfig.MySeat then
		hCard =  self._hCard1
		cardBgNameBefore = "mj_bottomcardbg_"
	elseif viewId == RoomConfig.DownSeat then
		hCard =  self._hCard2
		cardBgNameBefore = "mj_rightcardbg_"
	elseif viewId == RoomConfig.FrontSeat then
		hCard =  self._hCard3
		cardBgNameBefore = "mj_topcardbg_"
	elseif viewId == RoomConfig.UpSeat then
		hCard =  self._hCard4
		cardBgNameBefore = "mj_leftcardbg_"
	end	
	hCard:show()

	local dowCard =  {}			--需要返回的吃碰杠结构卡牌

	--获取吃碰杠对应项
	local cpgName = "cpg_"..i
	cardBgNameBefore =cardBgNameBefore..i
	print("cardBgNameBefore----:"..cardBgNameBefore)
	print("cpgName----:"..cpgName)

	local cpg = hCard:getChildByName(cpgName)
	if cpg then
		cpg:show()

		dump(tData)

		if (((#tData) == 1) and (tp > 0)) then --在牌局内补杠
				local cardBgName = cardBgNameBefore .."_"..4
		 		print("card在牌局内补杠BgName---------+++:"..cardBgName)
				local cardBg = cpg:getChildByName(cardBgName)
				local v = tData[1]
				if bKanPai then
					dump(bKanPai)
				else
					print("bKanPaiFFFFFF")
				end
				self:updateCard(cardBg,v,viewId,tp,4,dowCard,bKanPai)
		else
			--没有空的值
			local function notEmptyCard()
				local b = true
				for k,v in ipairs(tData) do
					if v == RoomConfig.EmptyCard then
						b = false
					end
				end
				return b
			end
			
			--兼容暗杠
			if notEmptyCard() then 
	        	table.sort(tData,function (a,b )
	        		return a < b
	    		end)
			end

			--暗杠 值在最后一位
			if tp == RoomConfig.AnGang  then
				table.sort(tData,function (a,b )
	        		return a > b
	    		end)
			end

			for j,v in ipairs(tData) do
				if (tp == 0) and (j == 4) then
					j = 5
				end 

				local cardBgName = cardBgNameBefore .."_"..down_card_idx[j]
		 		print("cardBgName---------+++:"..cardBgName)
				local cardBg = cpg:getChildByName(cardBgName)
				self:updateCard(cardBg,v,viewId,tp,j,dowCard,bKanPai)
			end

			if (tp == 0) and (tData[4] == nil) then
				for k=(#tData + 1), 5 do
					local cardBgName = cardBgNameBefore .."_"..down_card_idx[k]
			 		print("hide cardBgName---------+++:"..cardBgName)
					local cardBg = cpg:getChildByName(cardBgName)
					if cardBg then
						cardBg:hide()
					end
				end
			end	
		end
	else
		print("ERROR : cpg is nil")
	end

	return dowCard
end

--添加坎牌角标
function XYDownCardLayer:addKanPaiScript(viewId,card)
	print("viewId--------------:"..viewId)
	local tPath = {}
	tPath[RoomConfig.MySeat] = "mySeat"
	tPath[RoomConfig.DownSeat] = "downSeat"
	tPath[RoomConfig.FrontSeat] = "frontSeat"
	tPath[RoomConfig.UpSeat] = "upSeat"
	if bit._and(self:getPlaywayType(),0x40400) == 0x40400 then
		tPath[RoomConfig.MySeat] = "mj_az_02_shuai"
		tPath[RoomConfig.DownSeat] = "mj_zr_01_shuai"
		tPath[RoomConfig.FrontSeat] = "mj_zd_01_shuai"
		tPath[RoomConfig.UpSeat] = "mj_al_01_shuai"
	end	

	local pathScript =self.res_base..tPath[viewId]
	local scriptName = "widgetCardScript"
	local tbPos = {}
	tbPos[RoomConfig.MySeat] ={x=7,y=35}
	tbPos[RoomConfig.DownSeat] ={x=0,y=0}
	tbPos[RoomConfig.FrontSeat] ={x=0,y=0}
	tbPos[RoomConfig.UpSeat] ={x=0,y=0}

	if card then
		pathScript=self.res_base.."/script/"..tPath[viewId]..".png"
		print("xy down card layer, playway ", self:getPlaywayType())


		local widgetCardScript = card:getChildByName(scriptName)
		if widgetCardScript ==nil then
			widgetCardScript = ccui.ImageView:create()
			widgetCardScript:setName(scriptName)
			widgetCardScript:setAnchorPoint(cc.p(0,0))
			widgetCardScript:setPositionX(tbPos[viewId].x)
			widgetCardScript:setPositionY(tbPos[viewId].y)
			card:addChild(widgetCardScript)
		end
		widgetCardScript:loadTexture(pathScript,1)
	end
end

--更新卡牌
--bkanPai：出现坎牌的张数
function XYDownCardLayer:updateCard(cardBg,v,viewId,tp,j,dowCard,bKanPai)
	release_print(os.date("%c") .. "[info] 信阳Down页面更新卡牌 ",cardBg,v,viewId,tp,j,dowCard)
 	if nil ~= self.card_factory then
		self.card_factory:addSpriteFrames()
	end
 	cardBg:show()
	local card_type,card_value = self.card_factory:decodeValue(v) --预留给牌子

	if bKanPai and bKanPai >0 then
		print("card_value===bKanPai=================:"..card_value)
	end

	print("card_value====================:"..card_value)

	local card = cardBg:getChildByName("img_card")
	if card ==nil then
		card =self:createCard()
		cardBg:addChild(card)
		card:setName("img_card")
	end
	card:show()

	if tp == RoomConfig.BuGang then--补杠：--全部可见 （本来有3个） 		需要加一个牌
		print("RoomConfig.BuGang")
		local cardFileName=self:getCardFileName(viewId,card_value,card_type)
		card:loadTexture(cardFileName,1)
		table.insert(dowCard,cardBg)
	    self:showKanPaiScript(viewId,cardBg,j,bKanPai,tp)
	elseif tp ==RoomConfig.MingGang then--明杠: --全部可见   	 				需要添加四个牌
		print("RoomConfig.MingGang")
		local cardFileName=self:getCardFileName(viewId,card_value,card_type)
		card:loadTexture(cardFileName,1)
	    table.insert(dowCard,cardBg)
	    self:showKanPaiScript(viewId,cardBg,j,bKanPai)
	elseif tp ==RoomConfig.AnGang  then--暗杠：--自己可见一张牌 其他人不可见  	需要添加四个牌
		--if viewId == RoomConfig.MySeat then
		print("RoomConfig.AnGang")
			if j == 4 then
				local cardFileName
                if (card_value == 9) and (card_type == 3) then
                    cardFileName=self:getGangBackFileNameCardByViewId(viewId)
                else
                    cardFileName=self:getCardFileName(viewId,card_value,card_type)
                end
				card:loadTexture(cardFileName,1)	
			else
				local cardFileName=self:getGangBackFileNameCardByViewId(viewId) --反
				card:loadTexture(cardFileName,1)	
			end
		--else
		--	local cardFileName=self:getGangBackFileNameCardByViewId(viewId) --反
		--	card:loadTexture(cardFileName,1)
		--end
		table.insert(dowCard,cardBg)
	elseif tp == RoomConfig.Peng or tp == RoomConfig.Chi then--吃碰杠 --全部可见  需要添加3个牌
		print("RoomConfig.Peng")
		local cardFileName=self:getCardFileName(viewId,card_value,card_type)
		card:loadTexture(cardFileName,1)
		table.insert(dowCard,cardBg)
	    self:showKanPaiScript(viewId,cardBg,j,bKanPai)

	    self:addDownCardInfoList(cardBg,v,self:getAllancePath(viewId))
	    print("downAllancePath:"..self:getAllancePath(viewId))
	    -- addDownCardInfoList(cardBg,cardValue,allwancePath)
	else
		print("RoomConfig.fan")
		local cardFileName=self:getGangBackFileNameCardByViewId(viewId) --反
		card:loadTexture(cardFileName,1)
		table.insert(dowCard,cardBg)
	end
end

--img_card
function XYDownCardLayer:createCard()
	local widgetCard = ccui.ImageView:create()
	widgetCard:setAnchorPoint(cc.p(0,0)) 
	widgetCard:setPositionX(0)
	widgetCard:setPositionY(0)
	return widgetCard
end

--推倒胡牌的时候，显示坎牌盖的值
function XYDownCardLayer:pushOverShowKanPaiValue(tbKan,viewId,indexDown)
 	local hCard = nil
 	local cardBgNameBefore= "mj_bottomcardbg_"
	if viewId == RoomConfig.MySeat then
		hCard =  self._hCard1
		cardBgNameBefore = "mj_bottomcardbg_"
	elseif viewId == RoomConfig.DownSeat then
		hCard =  self._hCard2
		cardBgNameBefore = "mj_rightcardbg_"
	elseif viewId == RoomConfig.FrontSeat then
		hCard =  self._hCard3
		cardBgNameBefore = "mj_topcardbg_"
	elseif viewId == RoomConfig.UpSeat then
		hCard =  self._hCard4
		cardBgNameBefore = "mj_leftcardbg_"
	end	
	--获取吃碰杠对应项
	local cpgName = "cpg_"..indexDown
	cardBgNameBefore =cardBgNameBefore..indexDown
	print("cardBgNameBefore----:"..cardBgNameBefore)
	print("cpgName----:"..cpgName)
	local cpg = hCard:getChildByName(cpgName)

	
	local indexTbKan = 0 
	for i,v in ipairs(down_card_idx) do
		local cardBgName = cardBgNameBefore .."_"..down_card_idx[i]	
		print("cardBgName---------+++:"..cardBgName)
		local cardBg = cpg:getChildByName(cardBgName)	
		if cardBg:isVisible() then
			print("222222222")
			indexTbKan = indexTbKan + 1
			local  value= tbKan[indexTbKan]
			local card_type,card_value = self.card_factory:decodeValue(value) --预留给牌子
			local card = cardBg:getChildByName("img_card")
			if card ==nil then
				card =self:createCard()
				cardBg:addChild(card)
				card:setName("img_card")
			end
			card:show()
			local cardFileName=self:getCardFileName(viewId,card_value,card_type)
			card:loadTexture(cardFileName,1)
		end
	end

	print("viewId:"..viewId)
	dump(tbKan)
end

--展示坎牌角标
--tp：吃碰杠类型
function XYDownCardLayer:showKanPaiScript(viewId,cardBg,j,bKanPai,tp)
	release_print(os.date("%c") .. "[info] 信阳Down页面展示坎牌角标 ",viewId,cardBg,j,bKanPai)
	if bKanPai and bKanPai >0 then
		print("bKanPai:"..bKanPai)
		print("j:"..j)
		if bKanPai ==2 then
			if j==1 or j==3 then
	    		self:addKanPaiScript(viewId,cardBg)
			end
		elseif bKanPai ==1 then
			local idx = 1
			if tp and tp == RoomConfig.BuGang then
				idx = 4
			end
			if j==idx then --j==4的时候是补杠的时候
	    		self:addKanPaiScript(viewId,cardBg)	
			end
		elseif bKanPai ==3 then
			if j==1 or j==3 or j==4 then
	    	self:addKanPaiScript(viewId,cardBg)	
			end
		elseif bKanPai ==4 then
			self:addKanPaiScript(viewId,cardBg)
		end
    end	
end


--正面底牌(暂时用不到)
function XYDownCardLayer:getCPGFileNameCardByViewId(viewId)
	local fileName = self.res_base .."/allempty/mj_az_02.png"
	if viewId == RoomConfig.MySeat then
		fileName = self.res_base .. "/allempty/mj_az_02.png"
	elseif viewId == RoomConfig.DownSeat then
		fileName = self.res_base .. "/allempty/mj_ar_01.png"
	elseif viewId == RoomConfig.FrontSeat then
		fileName = self.res_base .. "/allempty/mj_ad_01.png"
	elseif viewId == RoomConfig.UpSeat then
		fileName = self.res_base .. "/allempty/mj_al_01.png"
	end	
	return fileName
end

--背面牌
function XYDownCardLayer:getGangBackFileNameCardByViewId(viewId)
	local fileName = self.res_base .."/allempty/mj_bz_01.png"
	if viewId == RoomConfig.MySeat then
		fileName = self.res_base .. "/allempty/mj_bz_01.png"
	elseif viewId == RoomConfig.DownSeat then
		fileName = self.res_base .. "/allempty/mj_br_01.png"
	elseif viewId == RoomConfig.FrontSeat then
		fileName = self.res_base .. "/allempty/mj_bd_02.png"
	elseif viewId == RoomConfig.UpSeat then
		fileName = self.res_base .. "/allempty/mj_bl_01.png"
	end	
	return fileName
end

--获取卡牌路径 (先考虑一般情况)
function XYDownCardLayer:getCardFileName(viewId,v,card_type)
	local fileNameBefore = ""
	if viewId == RoomConfig.MySeat then
		fileNameBefore = "mj_az_02"
	elseif viewId == RoomConfig.DownSeat then
		fileNameBefore = "mj_ar_01"
	elseif viewId == RoomConfig.FrontSeat then
		fileNameBefore = "mj_ad_01"
	elseif viewId == RoomConfig.UpSeat then
		fileNameBefore = "mj_al_01"
	end	

-- app/part/mj3dcard/res/room/resource/mj/mj_az_01/mj_az_01_character_2.png

----fileName:app/part/mj3dcard/res/room/resource/mj/mj_az_01/mj_az_01_character_4.png
	print("self.res_base self.res_base :"..self.res_base )
	local filePath=self.res_base .. "/"..fileNameBefore.."/"
	local fileName = string.format("%s%s_%s_%d.png",filePath,fileNameBefore,RoomConfig.CardType[card_type],v)

	if (card_type == 3) and (v == 9) then
		fileName = self:getGangBackFileNameCardByViewId(viewId)
	end

	print("XYDownCardLayer----fileName:"..fileName)

	return fileName
end

function XYDownCardLayer:updateNaozhuangNum(naozhuangCardNum)
	local cpg = self._hCard1:getChildByName("cpg_1")
	local cardBg = cpg:getChildByName("mj_bottomcardbg_1_3")
	local cardSize = cardBg:getContentSize()

	local curPosX = self._hCard1:getPositionX()
	local targetPosX =  curPosX - (naozhuangCardNum - self.naozhuangCardNum) * cardSize.width * 1.1
	self._hCard1:setPositionX(targetPosX)
	self.naozhuangCardNum = naozhuangCardNum
end

function XYDownCardLayer:setPlaywayType(type)
	self.playwayType = type
end

function XYDownCardLayer:getPlaywayType()
	local ret = 0
	if self.playwayType then
		ret = self.playwayType
	end
	return ret
end

return XYDownCardLayer