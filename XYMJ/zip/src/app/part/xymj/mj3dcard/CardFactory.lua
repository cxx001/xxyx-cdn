--[[
*名称:CardLayer
*描述:手牌工厂模式类
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local CardFactory = class("CardFactory")


function CardFactory:init(resBase)
	-- body
	self.res_base = resBase
	self:addSpriteFrames()
end

function CardFactory:setPart(part)
	self.part = part
	if self.part == nil then
		print("setPart(part)")
	end
end

function CardFactory:addSpriteFrames() 
	-- body
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
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.res_base .. "/script/mj_script.plist")
end

function CardFactory:createEndCard(value)
	release_print(os.date("%c") .. "[info] CFC 创建结算页面牌 ", value)
	self:addSpriteFrames()
	local card_type,card_value = self:decodeValue(value)
	print("this is  createWithData",value,card_type,card_value)
	local frame_name = ""
	self.node =  ccui.ImageView:create()
	local png_name = string.format("M_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
	frame_name = self.res_base .. "/mine/" .. png_name
	
	self.node:loadTexture(frame_name,1)
	
	if touch then --是否有触摸事件
		self.node:setTouchEnabled(true)
		self.node:setSwallowTouches(false)
	end
	return self.node
end

-- 创建待摸牌
-- function CardFactory:createReadyCard(viewId, isUp)
-- 	-- body
--         isUp = isUp or false;
-- 	self:addSpriteFrames()
-- 	-- print("this is  createReadyCard",value,card_type,card_value) 
-- 	local frame_name = ""
-- 	local node =  ccui.ImageView:create()

-- 	if viewId == RoomConfig.MySeat or viewId == RoomConfig.FrontSeat then
-- 	    frame_name = self.res_base .. "/room/resource/mj/empty/back_vert.png"
-- 	elseif viewId == RoomConfig.DownSeat then
--             frame_name = self.res_base .. "/room/resource/mj/empty/back_left.png"
--             if(not isUp) then
--                 node:setFlippedX(true); 
-- 	    end
-- 	elseif viewId == RoomConfig.UpSeat then
--             frame_name = self.res_base .. "/room/resource/mj/empty/back_left.png"
-- 	end
	
-- 	node:loadTexture(frame_name,1)
-- 	--[[if viewId == RoomConfig.MySeat then

-- 		local scale = display.width / 1080
-- 		local o_scale = self.node:getScale()
-- 		print("this is o_scale :",o_scale,scale)
-- 		self.node:setScale(scale*o_scale)
-- 		local content_size = self.node:getContentSize()
-- 		self.node.getContentSize = function()
-- 			-- body
-- 			return cc.size(content_size.width*scale*o_scale,content_size.height*scale*o_scale)
-- 		end
-- 	end]]

-- 	return node
-- end 

-- 创建待摸牌
function CardFactory:createReadyCard(viewId,isUp)
	-- body
	self:addSpriteFrames()

	local frame_name = ""
	local node =  ccui.ImageView:create()

	if viewId == RoomConfig.MySeat then
		if isUp then --上边的牌
	    	frame_name = self.res_base .. "/allempty/mj_bz_02.png"
		else 		 --下家的牌
	    	frame_name = self.res_base .. "/allempty/mj_bz_03.png"
		end
	elseif  viewId ==RoomConfig.DownSeat then
	    frame_name = self.res_base .. "/allempty/mj_br_03.png"
	elseif viewId ==  RoomConfig.FrontSeat then --暂时没有资源
		if isUp then --上边的牌
	    	frame_name = self.res_base .. "/allempty/mj_bd_04.png"
		else 		 --下家的牌
	    	frame_name = self.res_base .. "/allempty/mj_bd_03.png"
		end
	elseif viewId == RoomConfig.UpSeat then
         frame_name = self.res_base .. "/allempty/mj_bl_03.png"
	end

	--print("frame_name:"..frame_name)
	
	node:loadTexture(frame_name,1)
	return node
end 

function CardFactory:createWithData(viewId,value,touch)
	release_print(os.date("%c") .. "[info] CFC 根据数据创建牌 ", viewId,value)
	self:addSpriteFrames()
	local card_type,card_value = self:decodeValue(value)
	print("this is  createWithData",value,card_type,card_value) 
	local frame_name = ""
	self.node =  ccui.ImageView:create()

	if viewId == RoomConfig.MySeat then
	    local png_name = string.format("M_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
	    frame_name = self.res_base .. "/mine/" .. png_name
	elseif viewId == RoomConfig.DownSeat then
		if value then
			local png_name = string.format("R_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
			frame_name = self.res_base .. "/right/out/" .. png_name
		else
			frame_name = self.res_base .. "/empty/e_mj_right.png"
		end
	elseif viewId == RoomConfig.FrontSeat then
		if value then
			local png_name = string.format("B_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
			frame_name = self.res_base .. "/bottom/" .. png_name
			self.node:setScale(0.5)
		else
			frame_name = self.res_base .. "/empty/e_mj_up.png"
		end
	elseif viewId == RoomConfig.UpSeat then
		if value then
			local png_name = string.format("L_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
			frame_name = self.res_base .. "/left/out/" .. png_name
		else
		    frame_name = self.res_base .. "/empty/e_mj_left.png"
		end
	end
	
	print("CardFactory:createWithData frame_name ", frame_name)
	self.node:loadTexture(frame_name,1)
	if touch then --是否有触摸事件
		self.node:setTouchEnabled(true)
		self.node:setSwallowTouches(false)
	end
	return self.node
end 

--取手牌数据牌的文件路径
function CardFactory:getMySeatHandCardVFilePath(v,card_type)
	local fileNameBefore = "mj_az_01"
	local filePath=self.res_base .. "/"..fileNameBefore.."/"
	local fileName = string.format("%s%s_%s_%d.png",filePath,fileNameBefore,RoomConfig.CardType[card_type],v)
	print("CardFactoryDownCardLayer----fileName:"..fileName)

	return fileName
end

--取本家出牌数据的文件路径
function CardFactory:createMySeatOutCard(value)
	--出牌的最后一列
	release_print(os.date("%c") .. "[info] CFC 创建自己位置的已出牌 ", value)
	self:addSpriteFrames()
	local card_type,card_value = self:decodeValue(value)

	local function getFileName(v,card_type)
		local fileNameBefore = "mj_az_09"
		local filePath=self.res_base .. "/"..fileNameBefore.."/"
		local fileName = string.format("%s%s_%s_%d.png",filePath,fileNameBefore,RoomConfig.CardType[card_type],v)
		return fileName
	end 
	local frame_name = self.res_base .. "/allempty/mj_az_09.png"
	local node =  ccui.ImageView:create()
	node:loadTexture(frame_name,1)

	local nodeCardV = ccui.ImageView:create()
	local nodeCardVPath = getFileName(card_value,card_type)
	nodeCardV:setAnchorPoint(cc.p(0,0))
	nodeCardV:loadTexture(nodeCardVPath,1)
	node:addChild(nodeCardV)
	return node
end

-- function CardFactory:getPeiFrameName()
-- 	local frame_name = self.res_base .. "/B_autumnpei.png"
-- 	return frame_name
-- end

function CardFactory:createHandCard(viewId,value,touch)
	release_print(os.date("%c") .. "[info] CFC 创建手牌 ", viewId,value)
	self:addSpriteFrames()
	local card_type,card_value = self:decodeValue(value)
	print("this is  createWithData",value,card_type,card_value) 
	local frame_name = ""
	self.node =  ccui.ImageView:create()
	if viewId == RoomConfig.MySeat then --带有数据
		frame_name = self.res_base .. "/allempty/mj_az_01.png"
		--print("frame_name ", frame_name)
		local function createWidgetCard(path,bTouch)
			local widgetCard = ccui.ImageView:create()
			widgetCard:setAnchorPoint(cc.p(0,0))
			widgetCard:loadTexture(path,1)
			widgetCard:setTouchEnabled(bTouch)
			return widgetCard
		end

		--添加癞子痞子角标
		local function addPiZiLaiZiScript(node,b)
			local path =self.res_base.."/script/mj_az_01"
			local scriptTag = b and "l" or "p"
			path =path .. scriptTag .. ".png" 
			print("PiZiLaiZiScript:"..path)
			local scriptCard = createWidgetCard(path,false)
			node:addChild(scriptCard)
		end

		--添加罗山坎金玩法角标
		local function addPeiZiScript(node,b)
			-- local path = self:getPeiFrameName()
			local path =self.res_base.."/script/B_autumnpei.png"
			print("PeiZiLaiZiScript:"..path)
			local scriptCard = createWidgetCard(path,false)
			node:addChild(scriptCard)
		end

		local nodeCardVPath = self:getMySeatHandCardVFilePath(card_value,card_type)
		local nodeCardV=createWidgetCard(nodeCardVPath, false)
		if nodeCardV ~=nil then
			self.node:addChild(nodeCardV)
			--添加
			print("createHandCard")
			if self.part then
				if self.part.isLaiZi and self.part:isLaiZi(value)  then
					addPiZiLaiZiScript(self.node,self.part:isLaiZi(value))
				elseif self.part.isPiZi and self.part:isPiZi(value) then
					addPiZiLaiZiScript(self.node,self.part:isLaiZi(value))
				elseif self.part.isPeiZi and self.part:isPeiZi(value) then
					addPeiZiScript(self.node,self.part:isPeiZi(value))
				end 
			end 
		end
	elseif viewId == RoomConfig.DownSeat then
		frame_name = self.res_base .. "/allempty/mj_cr_01.png"
	elseif viewId == RoomConfig.FrontSeat then
		frame_name = self.res_base .. "/allempty/mj_bd_01.png"
	elseif viewId == RoomConfig.UpSeat then
		frame_name = self.res_base .. "/allempty/mj_cl_01.png"
	end
	
	self.node:loadTexture(frame_name,1)
	if touch then --是否有触摸事件
		self.node:setTouchEnabled(true)
		self.node:setSwallowTouches(false)
	end
	return self.node
end

-- --创建出的牌
-- function CardFactory:createOutCardWithData(viewId,value)
-- 	-- body
-- 	print("this is card down card:",viewId,value)
-- 	self:addSpriteFrames()
-- 	self.node = cc.Sprite:createWithSpriteFrameName(self.res_base .. "/room/resource/mj/bottom/B_autumn.png")
-- 	local size = self.node:getContentSize()
-- 	local frame_name = self:getFrameNameWithData(viewId,value)
-- 	self.node:setSpriteFrame(frame_name)
-- 	if viewId == RoomConfig.DownSeat or viewId == RoomConfig.UpSeat then
-- 		local scale_rate = 1
-- 		self.node:setScale(scale_rate)
-- 		local content_size = self.node:getContentSize()
-- 		self.node.getContentSize = function()
-- 			-- body
-- 			return cc.size(content_size.width*scale_rate,content_size.height*scale_rate)
-- 		end
-- 	elseif viewId == RoomConfig.MySeat then
-- 		--[[-
-- 		local scale = display.width / 1080
-- 		local o_scale = self.node:getScale()
-- 		self.node:setScale(scale*o_scale)
-- 		local content_size = self.node:getContentSize()
-- 		print("this is o_scale :",o_scale,scale)
-- 		self.node.getContentSize = function()
-- 			-- body
-- 			return cc.size(content_size.width*scale*o_scale,content_size.height*scale*o_scale)
-- 		end
-- -]]
-- 		local scale = 1
-- 		local o_scale = self.node:getScale()
-- 		self.node:setScale(scale*o_scale)
-- 		local content_size = self.node:getContentSize()
-- 		print("this is o_scale :",o_scale,scale)
-- 		self.node.getContentSize = function()
-- 			-- body
-- 			return cc.size(content_size.width*scale*o_scale,content_size.height*scale*o_scale)
-- 		end
-- 	end
-- 	return self.node
-- end

--创建出的牌
--colRow 行列标识
function CardFactory:createOutCardWithData(viewId,value,colRow)
	release_print(os.date("%c") .. "[info] CFC 根据数值创建已出牌 ", viewId,value,colRow)
	-- print("this is card down card:",viewId,value)
	self:addSpriteFrames()
	self.node = cc.Sprite:createWithSpriteFrameName(self.res_base .. "/bottom/B_autumn.png")

	local frame_name = self:getFrameNameWithData(viewId,value,colRow)
	self.node:setSpriteFrame(frame_name)
	return self.node
end

--创建吃碰杠的牌
function CardFactory:createDownCardWithData(viewId,value)
	release_print(os.date("%c") .. "[info] CFC 根据数值创建DownCard ", viewId,value)
	-- print("this is card down card:",viewId,value)
	self:addSpriteFrames()
	self.node = cc.Sprite:createWithSpriteFrameName(self.res_base .. "/bottom/B_autumn.png")
	local size = self.node:getContentSize()
	local frame_name = self:getDownFrameNameWithData(viewId,value)
	self.node:setSpriteFrame(frame_name)
	if viewId == RoomConfig.DownSeat or viewId == RoomConfig.UpSeat then
		local scale_rate = 0.8
		self.node:setScale(scale_rate)
		local content_size = self.node:getContentSize()


		self.node.getContentSize = function()
			-- body
			return cc.size(content_size.width*scale_rate,content_size.height*scale_rate)
		end
	elseif viewId == RoomConfig.MySeat then
		local scale = display.width / 1080
		local o_scale = self.node:getScale()
		self.node:setScale(scale*o_scale)
		local content_size = self.node:getContentSize()
		print("this is o_scale :",o_scale,scale)
		self.node.getContentSize = function()
			-- body
			return cc.size(content_size.width*scale*o_scale,content_size.height*scale*o_scale)
		end
	end
	return self.node
end

function CardFactory:decodeValue(value)
	-- body
	if value then
		return math.floor(value/16),value%16
	else
		return nil
	end
end

function CardFactory:getFrameName(viewId,value)
	release_print(os.date("%c") .. "[info] CFC 获取资源 ", viewId,value)
	local frame_name = ""
	local card_type,card_value = self:decodeValue(value)
	if viewId == RoomConfig.MySeat then
		local png_name = string.format("M_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
		frame_name = self.res_base .. "/mine/" .. png_name
	elseif viewId == RoomConfig.DownSeat then
		if value then
			local png_name = string.format("R_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
			frame_name = self.res_base .. "/right/out/" .. png_name
		else
			frame_name = self.res_base .. "/empty/e_mj_right.png"
		end
	elseif viewId == RoomConfig.FrontSeat then
		if value then
			local png_name = string.format("B_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
			frame_name = self.res_base .. "/bottom/" .. png_name
		else
			frame_name = self.res_base .. "/empty/e_mj_up.png"
		end
	elseif viewId == RoomConfig.UpSeat then
		if value then
			local png_name = string.format("L_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
			frame_name = self.res_base .. "/left/out/" .. png_name
		else
		    frame_name = self.res_base .. "/empty/e_mj_left.png"
		end
	end
	return frame_name
end

--]]
--出的牌
-- function CardFactory:getFrameNameWithData(viewId,value)
-- 	-- body
-- 	local frame_name = ""
-- 	local card_type,card_value = self:decodeValue(value)
-- 	if viewId == RoomConfig.MySeat then
-- 		if value ~= RoomConfig.EmptyCard then
-- 			local png_name = string.format("B_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
-- 			frame_name = self.res_base .. "/room/resource/mj/bottom/" .. png_name	
-- 		else
-- 			frame_name = self.res_base .. "/room/resource/mj/bottom/B_wind_9.png"
-- 		end
-- 	elseif viewId == RoomConfig.DownSeat then
-- 		if value ~= RoomConfig.EmptyCard then
-- 			local png_name = string.format("R_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
-- 			frame_name = self.res_base .. "/room/resource/mj/right/out/" .. png_name
-- 		else
-- 			frame_name = self.res_base .. "/room/resource/mj/empty/e_mj_b_left.png"
-- 		end
-- 	elseif viewId == RoomConfig.FrontSeat then
-- 		if value ~= RoomConfig.EmptyCard then
-- 			local png_name = string.format("B_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
-- 			frame_name = self.res_base .. "/room/resource/mj/bottomfont/" .. png_name

-- 		else
-- 			frame_name = self.res_base .. "/room/resource/mj/bottomfont/B_wind_9.png"
-- 		end
-- 	elseif viewId == RoomConfig.UpSeat then
-- 		if value ~= RoomConfig.EmptyCard then
-- 			local png_name = string.format("L_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
-- 			frame_name = self.res_base .. "/room/resource/mj/left/out/" .. png_name
-- 		else
-- 			frame_name = self.res_base .. "/room/resource/mj/empty/e_mj_b_right.png"
-- 		end
-- 	end
-- 	return frame_name
-- end

--colRow标识
function CardFactory:getFrameNameWithData(viewId,value,colRow)
	--RoomConfig.EmptyCard 取杠的牌
	release_print(os.date("%c") .. "[info] CFC 根据数值获取资源 ", viewId,value,colRow)
	local frame_name = ""
    if value == RoomConfig.EmptyCard then
    	if viewId == RoomConfig.MySeat  then
			frame_name = self.res_base .. "/bottom/B_wind_9.png"
    	elseif viewId == RoomConfig.DownSeat  then
			frame_name = self.res_base .. "/empty/e_mj_b_left.png"
    	elseif viewId == RoomConfig.FrontSeat  then
 			frame_name = self.res_base .. "/bottomfont/B_wind_9.png"
    	elseif viewId == RoomConfig.UpSeat  then 
   			frame_name = self.res_base .. "/empty/e_mj_b_right.png"
    	end
    	return frame_name
    end

    --取牌子
	local card_type,card_value = self:decodeValue(value) --预留给牌子
	if viewId == RoomConfig.MySeat then
			-- local png_name = string.format("B_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
			-- frame_name = self.res_base .. "/room/resource/mj/bottom/" .. png_name	
	elseif viewId == RoomConfig.DownSeat then
			-- local png_name = string.format("R_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
			-- frame_name = self.res_base .. "/room/resource/mj/right/out/" .. png_name

	elseif viewId == RoomConfig.FrontSeat then
			-- local png_name = string.format("B_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
			-- frame_name = self.res_base .. "/room/resource/mj/bottomfont/" .. png_name
	elseif viewId == RoomConfig.UpSeat then
			-- local png_name = string.format("L_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
			-- frame_name = self.res_base .. "/room/resource/mj/left/out/" .. png_name
	end

	--先取底板先：
    local bg_frame_name = ""
    bg_frame_name =  self:getOutCardBgFramePath(viewId,colRow)
    print("bg_frame_name:----------"..bg_frame_name)
	return bg_frame_name
end

--获取出的牌的底框类型文件名;
function CardFactory:getOutCardBgFramePath(viewId,colRow)
	release_print(os.date("%c") .. "[info] CFC 获取已出牌资源 ", viewId,colRow)
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

--吃碰杠的牌
function CardFactory:getDownFrameNameWithData(viewId,value)
	release_print(os.date("%c") .. "[info] CFC 根据牌值获取DownCard资源 ", viewId,value)
	local frame_name = ""
	local card_type,card_value = self:decodeValue(value)
	if viewId == RoomConfig.MySeat then
		if value ~= RoomConfig.EmptyCard then
			local png_name = string.format("B_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
			frame_name = self.res_base .. "/bottom/" .. png_name	
		else
			frame_name = self.res_base .. "/bottom/B_wind_9.png"
		end
	elseif viewId == RoomConfig.DownSeat then
		if value ~= RoomConfig.EmptyCard then
			local png_name = string.format("R_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
			frame_name = self.res_base .. "/right/down/" .. png_name
		else
			frame_name = self.res_base .. "/right/down/L_empty.png"
			self.node:setRotation(-90)
		end
	elseif viewId == RoomConfig.FrontSeat then
		if value ~= RoomConfig.EmptyCard then
			local png_name = string.format("B_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
			--frame_name = self.res_base .. "/room/resource/mj/bottom/" .. png_name
			frame_name = self.res_base .. "/bottomfont/" .. png_name
		else
			--frame_name = self.res_base .. "/room/resource/mj/bottom/B_wind_9.png"
			frame_name = self.res_base .. "/bottomfont/B_wind_9.png"
		end
	elseif viewId == RoomConfig.UpSeat then
		if value ~= RoomConfig.EmptyCard then
			local png_name = string.format("L_%s_%d.png",  RoomConfig.CardType[card_type],card_value)
			frame_name = self.res_base .. "/left/down/" .. png_name
		else
			frame_name = self.res_base .. "/right/down/R_empty.png"
			self.node:setRotation(-90)
		end
	end
	return frame_name
end

return CardFactory