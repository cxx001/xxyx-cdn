--[[
 牌局内吃碰杠的牌：待优化
--]]
local DownCardLayer = class("DownCardLayer")

local CURRENT_MODULE_NAME = ...


function DownCardLayer:init(resBase)


	self.res_base = resBase

	self.card_factory = import(".CardFactory",CURRENT_MODULE_NAME)
	self.card_factory:addSpriteFrames()
	self.naozhuangCardNum = 0
end

--子节点
function DownCardLayer:setRoot(root)
	self._root = root
	self.downCardInfoList ={}
	self:initHcard()
end

--初始化hCard
function DownCardLayer:initHcard()
	 self._hCard1 = self._root:getChildByName("hCard1")
	 local node_Center = self._root:getChildByName("Node_Center")
	 self._hCard2 = node_Center:getChildByName("hCard2")
	 self._hCard3 = node_Center:getChildByName("hCard3")
	 self._hCard4 = node_Center:getChildByName("hCard4")

	 self:resetAllDownCard()
end

--重置hCard
function DownCardLayer:resetAllDownCard()
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

function DownCardLayer:hideChildrents( hCard )
	for k,v in pairs(hCard:getChildren()) do
		v:hide()
	end
end

local down_card_idx = {3, 2, 1, 4, 5}

--tData:吃碰杠数据
--i: 为第几组吃碰杠
--tp:明杠，暗杠等类型
function DownCardLayer:showDownCard(viewId,tData,i,tp)
	release_print(os.date("%c") .. "[info] Down页面展示downcard ",viewId,tData,i,tp)
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
				self:updateCard(cardBg,v,viewId,tp,4,dowCard)
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

			for j,v in ipairs(tData) do
				if (tp == 0) and (j == 4) then
					j = 5
				end 

				local cardBgName = cardBgNameBefore .."_"..down_card_idx[j]
		 		print("cardBgName---------+++:"..cardBgName)
				local cardBg = cpg:getChildByName(cardBgName)
				self:updateCard(cardBg,v,viewId,tp,j,dowCard)
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

--更新卡牌
function DownCardLayer:updateCard(cardBg,v,viewId,tp,j,dowCard)
	release_print(os.date("%c") .. "[info] Down页面更新卡牌 ",cardBg,v,viewId,tp,j,dowCard)
 	cardBg:show()
	local card_type,card_value = self.card_factory:decodeValue(v) --预留给牌子


	print("card_value====================:"..card_value)

	local card = cardBg:getChildByName("img_card")

	if tp == RoomConfig.BuGang then--补杠：--全部可见 （本来有3个） 		需要加一个牌

		local cardFileName=self:getCardFileName(viewId,card_value,card_type)
		card:loadTexture(cardFileName,1)
		table.insert(dowCard,cardBg)
		
	elseif tp ==RoomConfig.MingGang then--明杠: --全部可见   	 				需要添加四个牌
		local cardFileName=self:getCardFileName(viewId,card_value,card_type)
		card:loadTexture(cardFileName,1)
	    table.insert(dowCard,cardBg)
	elseif tp ==RoomConfig.AnGang  then--暗杠：--自己可见一张牌 其他人不可见  	需要添加四个牌
		if viewId == RoomConfig.MySeat then
			if j == 4 then
				local cardFileName=self:getCardFileName(viewId,card_value,card_type)
				card:loadTexture(cardFileName,1)	
			else
				local cardFileName=self:getGangBackFileNameCardByViewId(viewId) --反
				card:loadTexture(cardFileName,1)	
			end
		else
			local cardFileName=self:getGangBackFileNameCardByViewId(viewId) --反
			card:loadTexture(cardFileName,1)	
		end	
		table.insert(dowCard,cardBg)
	elseif tp == RoomConfig.Peng or tp == RoomConfig.Chi then--吃碰杠 --全部可见  需要添加3个牌
		local cardFileName=self:getCardFileName(viewId,card_value,card_type)
		card:loadTexture(cardFileName,1)
		table.insert(dowCard,cardBg)
	else
		local cardFileName=self:getGangBackFileNameCardByViewId(viewId) --反
		card:loadTexture(cardFileName,1)
		table.insert(dowCard,cardBg)
	end
end


--正面底牌(暂时用不到)
function DownCardLayer:getCPGFileNameCardByViewId(viewId)
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
function DownCardLayer:getGangBackFileNameCardByViewId(viewId)
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
function DownCardLayer:getCardFileName(viewId,v,card_type)
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

	if (v == 0) or (v == 8 and card_type == 3) then
		local user = global:getGameUser()
		local uid = user:getProp("uid")
		local logFilepath = cc.FileUtils:getInstance():getLogFilePath()

		local http_mode = global:getModuleWithId(ModuleDef.HTTP_MOD)
		http_mode:UpLoadLogFile(uid, 524545, logFilepath, "penggangsantiao")		
	end

	if (card_type == 3) and (v == 9) then
		fileName = self:getGangBackFileNameCardByViewId(viewId)
	end

	print("DownCardLayer----fileName:"..fileName)

	return fileName
end

--余量
function DownCardLayer:getAllancePath(viewId)
	local path = ""
	local tbPath  = {}
	tbPath[RoomConfig.MySeat] = "/mj_azzz_02.png"
	tbPath[RoomConfig.DownSeat] = "/mj_arzz_01.png"
	tbPath[RoomConfig.FrontSeat] = "/mj_adzz_01.png"
	tbPath[RoomConfig.UpSeat] = "/mj_alzz_01.png"
	if  not tbPath[viewId] then return path end
	path = self.res_base.."/allowance"..tbPath[viewId]
	return path
end

function DownCardLayer:addDownCardInfoList(cardBg,cardValue,allwancePath)
	local bIn = false
	local function updateDownCardInfoList(cardBg)
		for k,v in pairs(self.downCardInfoList) do
			if cardBg == v.card then
				v.allwancePath =allwancePath
				v.cardValue = cardValue
				bIn =true
				break
			end
		end
	end
	updateDownCardInfoList(cardBg)

	if bIn then return end

	local cardInfo = {}
	cardInfo.card = cardBg 
	cardInfo.cardValue = cardValue
	cardInfo.allwancePath = allwancePath
	table.insert(self.downCardInfoList,cardInfo)
end

function DownCardLayer:deallocDownCardInfoList()

end

function DownCardLayer:delAllwanceMask()
	if not self.downCardInfoList and  #self.downCardInfoList == 0 then return end
	local allwanceName = "allwanceName"
	for k,v in pairs(self.downCardInfoList) do
		local cardInfo = v
		local bgCard=cardInfo.card
		if bgCard then
			local allwanceMask = bgCard:getChildByName(allwanceName)
			if allwanceMask ~=nil then
			   allwanceMask:hide()
			end
		end
	end	
end

function DownCardLayer:updateAllwanceMask(cardValue)
	self:delAllwanceMask()
 	if not self.downCardInfoList and  #self.downCardInfoList==0 then return end
 	for k,v in pairs(self.downCardInfoList) do
 		local cardInfo = v
 		local cardBg = cardInfo.card
		if cardBg then
			if cardInfo.cardValue == cardValue then
				local allwanceName = "allwanceName"
				local allwanceMask = cardBg:getChildByName(allwanceName)
				local path = cardInfo.allwancePath
				print("allwancePath:--------------"..path)
				if allwanceMask ==nil then
					allwanceMask = ccui.ImageView:create()
					allwanceMask:setAnchorPoint(cc.p(0,0))
					allwanceMask:setName(allwanceName)
					cardBg:addChild(allwanceMask,20)
				end
				allwanceMask:loadTexture(path,1)
				allwanceMask:show()
			end
		end
 	end
end



function DownCardLayer:updateNaozhuangNum(naozhuangCardNum)
	local cpg = self._hCard1:getChildByName("cpg_1")
	local cardBg = cpg:getChildByName("mj_bottomcardbg_1_3")
	local cardSize = cardBg:getContentSize()

	local curPosX = self._hCard1:getPositionX()
	local targetPosX =  curPosX - (naozhuangCardNum - self.naozhuangCardNum) * cardSize.width * 1.1
	self._hCard1:setPositionX(targetPosX)
	self.naozhuangCardNum = naozhuangCardNum
end

return DownCardLayer