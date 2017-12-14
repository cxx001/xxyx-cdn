--[[
 牌局内出牌：待优化
]]
local OutCardLayer = class("OutCardLayer")

function OutCardLayer:init(resBase)
	self._colNum = 7 		--出牌标准列数规定
	self._rowNum = 3		--出牌标准行数规定
	self.res_base = resBase
	self.outCardInfoList = {}
	self:addSpriteFrames()
end

function OutCardLayer:addSpriteFrames()
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/empty/empty_picture.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/mine/mine_picture.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/left/out/left_picture.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/left/down/left_down_picture.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/right/out/right_picture.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/right/down/right_down_picture.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/bottom/bottom_picture.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/bottomfont/bottomfront_picture.plist")

	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/allempty/allempty_picture.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/allowance/allowance_picture.plist")

	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/mj_card_picture.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/mj_out_card_topbottom_picture.plist")
end


function OutCardLayer:setLocalZ()
	local  node_center = self._root:getChildByName("Node_center")
	local  ocard1= node_center:getChildByName("ocard1")
	local  ocard2= node_center:getChildByName("ocard2")
	local  ocard3= node_center:getChildByName("ocard3")
	local  ocard4= node_center:getChildByName("ocard4")
	ocard1:setLocalZOrder(ocard2:getLocalZOrder()+3)
	ocard4:setLocalZOrder(ocard3:getLocalZOrder()+1)
end


--子节点
function OutCardLayer:setRoot(root)
	self._root = root

	self:setLocalZ()	
end

--colRow标识
function OutCardLayer:showoutCard(viewId,value,row,col)
	if self.addSpriteFrames then self:addSpriteFrames() end
	--显示
    --名字
    local name="az"
	local card_type,card_value = self:decodeValue(value) --预留给牌子
	if viewId == RoomConfig.MySeat then
		name=""
	elseif viewId == RoomConfig.DownSeat then
		name=""
	elseif viewId == RoomConfig.FrontSeat then
		name=""
	elseif viewId == RoomConfig.UpSeat then
		name=""
	end

	local cardBg = self:getCardBgByName(viewId,row,col)
	if cardBg ==nil then return nil  end
	cardBg:show() 

	--设置card的纹理
	local card = cardBg:getChildByName("card")

	local cardPath = self:getCardPathAndFileNameBefore(viewId,col,row).path
	local fileNameBefore = self:getCardPathAndFileNameBefore(viewId,col,row).before

	local cardFileName =string.format("%s/%s_%s_%d.png",cardPath,fileNameBefore,RoomConfig.CardType[card_type],card_value)
	--ynmj/room/resource/mj/mj_az_010/mj_az_010_wind_6.png
	--cardFileNamecardFileName========:ynmj/room/resource/mj/mj_ad_08_mj_ad_08_wind_4.png
	print("cardFileNamecardFileName========:"..cardFileName)
	if card ==nil then
		card =ccui.ImageView:create()
		card:setAnchorPoint(cc.p(0,0))
		card:setName("card")
		cardBg:addChild(card)		
	end
	card:loadTexture(cardFileName,1)
 	-- card:setUserObject(ccui.ImageView:create())
 	-- dump(card:getUserObject())

	if value == 0x39 then
		local backSprite = cc.Sprite:createWithSpriteFrameName(cardFileName)
		cardBg:setSpriteFrame(backSprite:getSpriteFrame())
		card:hide()
	end

	if value ~=0x39 then
		local allwancePath =self:getAllanwncePath(viewId,col,row)
		self:addOutCardInfoList(cardBg,allwancePath,value)
	end

	return cardBg
end 

--重置所有底板
function OutCardLayer:resetAllCard()
	--全部为不可见
	local  node_center = self._root:getChildByName("Node_center")

	local  ocard1= node_center:getChildByName("ocard1")
	for k,v in pairs(ocard1:getChildren()) do
		v:hide()
	end

	local  ocard2= node_center:getChildByName("ocard2")
	for k,v in pairs(ocard2:getChildren()) do
		v:hide()
	end

	local  ocard3= node_center:getChildByName("ocard3")
	for k,v in pairs(ocard3:getChildren()) do
		v:hide()
	end


	local  ocard4= node_center:getChildByName("ocard4")
	for k,v in pairs(ocard4:getChildren()) do
		v:hide()
	end
end

function OutCardLayer:getShowOutCardWordPos(viewId,row,col)
	local BgNodeName 	="ocard"..viewId
	local node_center = self._root:getChildByName("Node_center")
	local outCard 		=node_center:getChildByName(BgNodeName)
	local cardBg  		=self:getCardBgByName(viewId,row,col)
	local wold_pos 		= outCard:convertToWorldSpace(cc.p(cardBg:getPositionX(),cardBg:getPositionY()))
	return wold_pos
end

function OutCardLayer:getShowOutHuCardWordPos(viewId,cardBg)
	local BgNodeName 	="ocard"..viewId
	local node_center 	= self._root:getChildByName("Node_center")
	local outCard 		=node_center:getChildByName(BgNodeName)
	local wold_pos 		= outCard:convertToWorldSpace(cc.p(cardBg:getPositionX(),cardBg:getPositionY()))
	return wold_pos
end

--获取底板
function OutCardLayer:getCardBgByName(viewId,row,col)

	local BgNodeName = "ocard1"
	local fileName = ""
	if viewId == RoomConfig.MySeat then --列 0 开始
		BgNodeName = "ocard1"
		fileName="mj_az_"
	elseif viewId == RoomConfig.DownSeat then --行 0 开始
		BgNodeName = "ocard2"
		fileName="mj_ar_"
	elseif viewId == RoomConfig.FrontSeat then --列
		BgNodeName = "ocard3"
		fileName="mj_ad_"
	elseif viewId == RoomConfig.UpSeat then   --行
		BgNodeName = "ocard4"
		fileName="mj_al_"
	end
	local mRow = row
	local mCol = col
	mRow =mRow +1 
	mCol =mCol +1 

	if mRow > self._rowNum then
		mRow =self._rowNum
		mCol = self._colNum + mCol
	end

	fileName = fileName..mRow.."_"..mCol
	print("childName name---------------:",fileName)
	
	local node_center = self._root:getChildByName("Node_center")
	local outCard =node_center:getChildByName(BgNodeName)

	local cardBg = outCard:getChildByName(fileName)
	return cardBg
end

function OutCardLayer:addOutCardInfoList(cardBg,allwancePath,cardValue)
	local bIn = false
	local function updateOutCardInfoList(cardBg)
		for k,v in pairs(self.outCardInfoList) do
			if cardBg == v.card then
				v.allwancePath =allwancePath
				v.cardValue = cardValue
				bIn = true
				break
			end
		end
	end
	updateOutCardInfoList(cardBg)

	if bIn then return end

	local cardInfo = {}
	cardInfo.card = cardBg 
	-- cardInfo.allwancePath = self.res_base .."/mj_azz_01.png"
	cardInfo.allwancePath = allwancePath
	cardInfo.cardValue = cardValue
	table.insert(self.outCardInfoList,cardInfo)
end

function OutCardLayer:getCardInfo(cardBg)
	for k,v in pairs(self.outCardInfoList) do
		if cardBg == v.card then
			return v
		end
	end	
end

function OutCardLayer:deallocOutCardInfoList()
	self.outCardInfoList = {}
end

function OutCardLayer:delAllwanceMask()
 	if not self.outCardInfoList and #self.outCardInfoList>0 then return end
	local allwanceName = "allwanceName"
 	for k,v in pairs(self.outCardInfoList) do
 		local cardInfo = v
 		local cardBg = cardInfo.card
		if cardBg then
			local allwanceMask = cardBg:getChildByName(allwanceName)
			if allwanceMask ~=nil then
			   allwanceMask:hide()
			end
		end
 	end
end

--更新余量
--bgList：每个玩家对应的出牌列表
--cardValue:所选中的牌值
function OutCardLayer:updateAllwanceMask(cardValue)
	self:delAllwanceMask()
	if not self.outCardInfoList and #self.outCardInfoList>0 then return end
	-- dump(self.outCardInfoList)
 	for k,v in pairs(self.outCardInfoList) do
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

--获取卡牌所在路径和文件名前缀
function OutCardLayer:getAllanwncePath(viewId,col,row)
	local fileName = ""
	if viewId == RoomConfig.MySeat then --列 0 开始
		col= col>(self._colNum-1) and (self._colNum-1) or col 
		local mrgincolRow = col + 3  --相对文件取名差3
		fileName="mj_azzz_0"..mrgincolRow
	elseif viewId == RoomConfig.DownSeat then --行 0 开始
		row = row >2 and 2 or row
		local mrgincolRow = row + 3  --相对文件取名差3
		fileName="mj_arzz_0"..mrgincolRow
	elseif viewId == RoomConfig.FrontSeat then --列
		col= col>(self._colNum-1) and (self._colNum-1) or col
		local mrgincolRow = 8-col  --暂时没有
		fileName="mj_adzz_0"..mrgincolRow
	elseif viewId == RoomConfig.UpSeat then   --行
		row = row > (self._rowNum-1)  and (self._rowNum-1) or row
		local mrgincolRow = row + 3  --暂时没有
		fileName="mj_alzz_0"..mrgincolRow
	end
	local path=self.res_base.. "/allowance/"..fileName..".png"
	print("getAllanwncePath:",path)
	return  path
end

--获取卡牌所在路径和文件名前缀
function OutCardLayer:getCardPathAndFileNameBefore(viewId,col,row)
	local pathTb = {}
	local mrgincolRow=0
	if viewId == RoomConfig.MySeat then --列 0 开始
		col= col>(self._colNum-1) and (self._colNum-1) or col 
		mrgincolRow = col + 3  --相对文件取名差3
		pathTb.path="mj_az_0"..mrgincolRow
	elseif viewId == RoomConfig.DownSeat then --行 0 开始
		row = row >2 and 2 or row
		mrgincolRow = row + 3  --相对文件取名差3
		pathTb.path="mj_ar_0"..mrgincolRow
	elseif viewId == RoomConfig.FrontSeat then --列
		col= col>(self._colNum-1) and (self._colNum-1) or col
		mrgincolRow = 8-col  --暂时没有
		pathTb.path="mj_ad_0"..mrgincolRow
	elseif viewId == RoomConfig.UpSeat then   --行
		row = row > (self._rowNum-1)  and (self._rowNum-1) or row
		mrgincolRow = row + 3  --暂时没有
		pathTb.path="mj_al_0"..mrgincolRow
	end
	pathTb.before=pathTb.path
	pathTb.path=self.res_base .. "/"..pathTb.path
	print("this is path :",pathTb.path,mrgincolRow)
	return  pathTb
end
--获取出的牌的底框类型文件名;
function OutCardLayer:getOutCardBgFramePath(viewId,colRow)
	local fileName = ""
	if viewId == RoomConfig.MySeat then --列 0 开始
		local mrgincolRow = colRow + 3  --相对文件取名差3
		fileName="mj_az_0"..mrgincolRow..".png"
	elseif viewId == RoomConfig.DownSeat then --行 0 开始
		local mrgincolRow = colRow + 3  --相对文件取名差3
		fileName="mj_ar_0"..mrgincolRow..".png"
	elseif viewId == RoomConfig.FrontSeat then --列
		local mrgincolRow = 8-colRow  --暂时没有
		fileName="mj_ad_0"..mrgincolRow..".png"
	elseif viewId == RoomConfig.UpSeat then   --行
		local mrgincolRow = colRow + 3  --暂时没有
		fileName="mj_al_0"..mrgincolRow..".png"
	end
	print("this is file name:",fileName,colRow)
	return  self.res_base .. "/allempty/"..fileName
end

function OutCardLayer:getBaoListByViewId(viewId)
	local  node_center = self._root:getChildByName("Node_center")
	local  baoList = node_center:getChildByName("baoList"..viewId)
	return baoList
end

--重置痞子癞子所有出的牌
function OutCardLayer:resetPiZiLaiZiCard()
	--全部为不可见
	local  node_center = self._root:getChildByName("Node_center")

	local  baoList1= node_center:getChildByName("baoList1")
	for k,v in pairs(baoList1:getChildren()) do
		v:hide()
	end

	local  baoList2= node_center:getChildByName("baoList2")  
	for k,v in pairs(baoList2:getChildren()) do
		v:hide()
	end

	local  baoList3= node_center:getChildByName("baoList3")
	for k,v in pairs(baoList3:getChildren()) do
		v:hide()
	end

	local  baoList4= node_center:getChildByName("baoList4")
	for k,v in pairs(baoList4:getChildren()) do
		v:hide()
	end
print("OutCardLayer:resetPiZiLaiZiCard()") 

	-- local  baolist1= node_center:getChildByName("baolist1")
	-- for k,v in pairs(baolist1:getChildren()) do
	-- 	v:hide()
	-- end

	-- local  baolist2= node_center:getChildByName("baolist2")
	-- for k,v in pairs(baolist2:getChildren()) do
	-- 	v:hide()
	-- end

	-- local  baolist3= node_center:getChildByName("baolist3")
	-- for k,v in pairs(baolist3:getChildren()) do
	-- 	v:hide()
	-- end

	-- local  baolist4= node_center:getChildByName("baolist4")
	-- for k,v in pairs(baolist4:getChildren()) do
	-- 	v:hide()
	-- end

end

function OutCardLayer:resetPiZiLaiZiCardByViewId(viewId)
	-- local  node_center = self._root:getChildByName("Node_center")
	-- local baoName = "baolist"..viewId
	-- local  baolist= node_center:getChildByName(baoName)
	-- for k,v in pairs(baolist:getChildren()) do
	-- 	v:hide()
	-- end
end

--index要显示第几个的索引
function OutCardLayer:showPiZiLaiZi(viewId,index,value)
	local  node_center = self._root:getChildByName("Node_center")
	local  baoList = node_center:getChildByName("baolist"..viewId)
	local  cardBgName = "imgBg_"..index
	local  cardBg= baoList:getChildByName(cardBgName)
	local  card =cardBg:getChildByName("imgv")
	cardBg:show()
	--cardBg:setScale(2)

	local  cardFileName = self:getPiZiLaiZiCardFrame(viewId,index,value)
	card:loadTexture(cardFileName,1)
	return cardBg
end

--获取痞子癞子的麻将子
function OutCardLayer:getPiZiLaiZiCardFrame(viewId,index,value)

	local tbPath = {}
	tbPath[RoomConfig.MySeat] = {}
	tbPath[RoomConfig.MySeat][1]="mj_az_06"
	tbPath[RoomConfig.MySeat][2]="mj_az_07"
	tbPath[RoomConfig.MySeat][3]="mj_az_08"
	tbPath[RoomConfig.MySeat][4]="mj_az_09"
	tbPath[RoomConfig.MySeat][5]="mj_az_06"
	tbPath[RoomConfig.MySeat][6]="mj_az_07"
	tbPath[RoomConfig.MySeat][7]="mj_az_08"
	tbPath[RoomConfig.MySeat][8]="mj_az_09"

	tbPath[RoomConfig.DownSeat] = {}
	tbPath[RoomConfig.DownSeat][1]="mj_ar_02"
	tbPath[RoomConfig.DownSeat][2]="mj_ar_01"
	tbPath[RoomConfig.DownSeat][3]="mj_ar_02"
	tbPath[RoomConfig.DownSeat][4]="mj_ar_01"
	tbPath[RoomConfig.DownSeat][5]="mj_ar_02"
	tbPath[RoomConfig.DownSeat][6]="mj_ar_01"
	tbPath[RoomConfig.DownSeat][7]="mj_ar_02"
	tbPath[RoomConfig.DownSeat][8]="mj_ar_01"

	tbPath[RoomConfig.FrontSeat] = {}
	tbPath[RoomConfig.FrontSeat][1]="mj_ad_05"
	tbPath[RoomConfig.FrontSeat][2]="mj_ad_04"
	tbPath[RoomConfig.FrontSeat][3]="mj_ad_03"
	tbPath[RoomConfig.FrontSeat][4]="mj_ad_02"
	tbPath[RoomConfig.FrontSeat][5]="mj_ad_05"
	tbPath[RoomConfig.FrontSeat][6]="mj_ad_04"
	tbPath[RoomConfig.FrontSeat][7]="mj_ad_03"
	tbPath[RoomConfig.FrontSeat][8]="mj_ad_02"

	tbPath[RoomConfig.UpSeat] = {}
	tbPath[RoomConfig.UpSeat][1]="mj_al_02"
	tbPath[RoomConfig.UpSeat][2]="mj_al_01"
	tbPath[RoomConfig.UpSeat][3]="mj_al_02"
	tbPath[RoomConfig.UpSeat][4]="mj_al_01"
	tbPath[RoomConfig.UpSeat][5]="mj_al_02"
	tbPath[RoomConfig.UpSeat][6]="mj_al_01"
	tbPath[RoomConfig.UpSeat][7]="mj_al_02"
	tbPath[RoomConfig.UpSeat][8]="mj_al_01"

	local fileNameBefore = tbPath[viewId][index]
	local card_type,card_value = self:decodeValue(value)
	print("index:------------"..index)
	print("fileNameBefore:------------"..fileNameBefore)
	local filePath=self.res_base .. "/"..fileNameBefore.."/"
	local fileName = string.format("%s%s_%s_%d.png",filePath,fileNameBefore,RoomConfig.CardType[card_type],card_value)
	return fileName 
	-- -- local filePath=self.res_base .. "/"..fileNameBefore.."/"
	-- -- local fileName = string.format("%s%s_%s_%d.png",filePath,fileNameBefore,RoomConfig.CardType[card_type],v)
	-- return nil --fileName 
end

function OutCardLayer:decodeValue(value)
	-- body
	if value then
		return math.floor(value/16),value%16
	else
		return nil
	end
end


return OutCardLayer