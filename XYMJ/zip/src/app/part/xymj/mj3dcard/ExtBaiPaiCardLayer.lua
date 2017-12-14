--[[
 牌局内出牌：待优化
]]
local ExtBaiPaiCardLayer = class("ExtBaiPaiCardLayer")

function ExtBaiPaiCardLayer:init(resBase)
	self._colNum = 7 		--出牌标准列数规定
	self._rowNum = 3		--出牌标准行数规定
	self.res_base = resBase

	self:addSpriteFrames()
end

function ExtBaiPaiCardLayer:addSpriteFrames()
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/empty/empty_picture.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/mine/mine_picture.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/left/out/left_picture.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/left/down/left_down_picture.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/right/out/right_picture.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/right/down/right_down_picture.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/bottom/bottom_picture.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/bottomfont/bottomfront_picture.plist")

	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/allempty/allempty_picture.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/mj_card_picture.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/mj_out_card_topbottom_picture.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/script/mj_script.plist")
end

--子节点
function ExtBaiPaiCardLayer:setRoot(root)
	self._root = root
end

function ExtBaiPaiCardLayer:getBaoListByViewId(viewId)
	local  node_center = self._root:getChildByName("Node_center")
	local  baoList = node_center:getChildByName("baoList"..viewId)
	return baoList
end

--重置痞子癞子所有出的牌
function ExtBaiPaiCardLayer:resetPiZiLaiZiCard()
	--全部为不可见
	local  node_center = self._root:getChildByName("Node_center")
	print("ExtBaiPaiCardLayer:resetPiZiLaiZiCard()") 

	local  baolist1= node_center:getChildByName("baolist1")
	for k,v in pairs(baolist1:getChildren()) do
		v:hide()
	end

	local  baolist2= node_center:getChildByName("baolist2")
	for k,v in pairs(baolist2:getChildren()) do
		v:hide()
	end

	local  baolist3= node_center:getChildByName("baolist3")
	for k,v in pairs(baolist3:getChildren()) do
		v:hide()
	end

	local  baolist4= node_center:getChildByName("baolist4")
	for k,v in pairs(baolist4:getChildren()) do
		v:hide()
	end

end

function ExtBaiPaiCardLayer:resetPiZiLaiZiCardByViewId(viewId)
	local  node_center = self._root:getChildByName("Node_center")
	local baoName = "baolist"..viewId
	local  baolist= node_center:getChildByName(baoName)
	for k,v in pairs(baolist:getChildren()) do
		v:hide()
	end
end

--index要显示第几个的索引
--b:false 癞子，true: 为痞子
function ExtBaiPaiCardLayer:showPiZiLaiZi(viewId,index,value,b)
	local  node_center = self._root:getChildByName("Node_center")
	local  baoList = node_center:getChildByName("baolist"..viewId)
	local  cardBgName = "imgBg_"..index
	local  cardBg= baoList:getChildByName(cardBgName)
	local  card =cardBg:getChildByName("imgv")
	local  cardFileName = self:getPiZiLaiZiCardFrame(viewId,index,value)
	card:loadTexture(cardFileName,1)

	local scriptTag = b and "p" or "l"
	local  cardScriptPath = self:getPiLaiBgFileNameBefore(viewId,index)..scriptTag
	cardScriptPath = string.format("%s/%s/%s.png",self.res_base,"script",cardScriptPath)

	self:updateScript(cardBg,cardScriptPath)

	cardBg:show()
	return cardBg
end

--更新角标
function ExtBaiPaiCardLayer:updateScript(cardBg,cardScriptPath)
	local cardScipt = cardBg:getChildByName("cardScipt")
	if cardScipt ==nil then
		cardScipt =ccui.ImageView:create()
		cardScipt:setAnchorPoint(cc.p(0,0))
		cardScipt:setName("cardScipt")
		cardBg:addChild(cardScipt)		
	end
	print("cardScriptName:"..cardScriptPath)
	cardScipt:loadTexture(cardScriptPath,1)
end

function ExtBaiPaiCardLayer:getPiLaiBgFileNameBefore(viewId,index)
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
	return fileNameBefore
end

--获取痞子癞子的麻将子
function ExtBaiPaiCardLayer:getPiZiLaiZiCardFrame(viewId,index,value)
	local fileNameBefore =self:getPiLaiBgFileNameBefore(viewId,index)
	local card_type,card_value = self:decodeValue(value)
	print("index:------------"..index)
	print("fileNameBefore:------------"..fileNameBefore)
	local filePath=self.res_base .. "/"..fileNameBefore.."/"
	local fileName = string.format("%s%s_%s_%d.png",filePath,fileNameBefore,RoomConfig.CardType[card_type],card_value)
	return fileName 
end

function ExtBaiPaiCardLayer:decodeValue(value)
	-- body
	if value then
		return math.floor(value/16),value%16
	else
		return nil
	end
end


return ExtBaiPaiCardLayer