--[[
*名称:ReadyLayer
*描述:准备界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local ReadyLayer = class("ReadyLayer",cc.load("mvc").ViewBase)
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
local CURRENT_MODULE_NAME = ...

function ReadyLayer:onCreate() --传入数据
	-- body
	self:initWithFilePath("ReadyLayer",CURRENT_MODULE_NAME)
	if self.part:isFirstRound() then
		self:switchToReadyState(false)
	else
		self:hideSitAndInviteBtn()
	end 

	local is_match = self.part.owner.match_mode
	if is_match then
		self.node.lefttop_dark_bg3:setVisible(false)
	end
end

--显示所有玩家
function ReadyLayer:initPlayer(playerList)
	-- 自己永远是node1
	if playerList then
		for k,v in ipairs(playerList) do
			if k > 4 then
				return
			else
				self:showPlayer(v)
			end
		end

		local player_size = #playerList 
		if player_size >= 4 then --房间满人不需要邀请
			self.node.invite_btn:show()
		else
			self.node.invite_btn:show()
		end
	end
end

function ReadyLayer:nextGame(playerList)
	-- body
	if playerList then
		for k,v in ipairs(playerList) do
			if k > 4 then
				return
			else
				self:showPlayer(v)
			end
		end
	end
	self:hideSitAndInviteBtn()
end

function ReadyLayer:showPlayer(playerInfo)
	print(string.format("###[ReadyLayer:showPlayer]seat_id %d view_id %d ", playerInfo.tablepos, playerInfo.view_id))
	-- body
	if playerInfo.view_id and playerInfo.view_id >= 1 and playerInfo.view_id <= 4 then
		local head_bg = self.node["head_bg" .. playerInfo.view_id]
		local head_node = self.node["head_node" .. playerInfo.view_id]

		local name = self.node['name' .. playerInfo.view_id]
		local coin = self.node['coin' .. playerInfo.view_id]
		local ready_icon = self.node['read_icon' .. playerInfo.view_id]
		ready_icon:hide()
		head_node:show()
		head_bg:show()

   local sprite = cc.Sprite:create(self.res_base.."/touxiang.png")
   local clipping_node = cc.ClippingNode:create(sprite)

   -- clipping_node:setName("ClippingNode")
   -- clipping_node:setAlphaThreshold(0)
   -- clipping_node:setPosition(cc.p(600,640))
   -- self.node.bg:addChild(clipping_node)
   -- local image = ccui.ImageView:create()
   -- image:ignoreContentAdaptWithSize(false)
   -- image:loadTexture(self.res_base.."/default_head.png",0)
   -- clipping_node:addChild(image)

		--print("###[ReadyLayer:showPlayer] playerInfo.gamestate is ", playerInfo.gamestate)
		-- if playerInfo.gamestate == self.part.ePlayerState.NOREADY then --未准备
		-- 	ready_icon:hide()
		-- else
		-- 	ready_icon:show()
		-- end
		name:setString(string.utf8sub(playerInfo.name,1,5))
		-- name:setColor({r=255,g=255,b=255})		--初始化白色
		local strTag =""
		-- playerInfo.coin = 0
		if playerInfo.coin < 0 then
			strTag="/"
		end 
		local strCoin =strTag..playerInfo.coin
		coin:setString(strCoin)
		---------------------
		--裁剪模板
		local sprite_floor = cc.Sprite:create(self.res_base .. "/touxiang.png")
		-- local sprite_floor = cc.Sprite:create(self.res_base .. "/pz_jsfj2.png")
    	local clipping_node = cc.ClippingNode:create(sprite_floor)
    	local sprite_floor_size = sprite_floor:getContentSize()
    	----裁剪对象
    	local sprite_head = cc.Sprite:create(self.res_base .. "/default_head.png")
    	local head_size = sprite_head:getContentSize()
    	sprite_head:setScale(sprite_floor_size.width/head_size.width, sprite_floor_size.height/head_size.height)

    	local head_bg_size = head_node:getContentSize()
    	clipping_node:addChild(sprite_head)
    	clipping_node:setAlphaThreshold(0.8)
    	clipping_node:setPosition(cc.p(head_bg_size.width/2,head_bg_size.height/2))
    	head_node:addChild(clipping_node)
		---------------------

		if playerInfo.intable == 0 then
            self:offlinePlayer(playerInfo.view_id,false)
		end

		if playerInfo.targetPlayerName ~= nil then
			if playerInfo.targetPlayerName and playerInfo.targetPlayerName ~= "" then
				self.part:loadHeadImg(playerInfo.targetPlayerName,sprite_head)
			end
		else 	
			if playerInfo.headImgUrl and playerInfo.headImgUrl ~= "" then
				self.part:loadHeadImg(playerInfo.headImgUrl,sprite_head)
			end
		end

	end
end

function ReadyLayer:hidePlayer(num)
	-- local head_node = self.node["head_node" .. num]
	-- head_node:hide()
	local head_node = self.node["head_bg" .. num]
	head_node:hide()
end

function ReadyLayer:offlinePlayer(offlinePos,online)
	local name = self.node['name' .. offlinePos]
	if online then
	   name:setColor({r=255,g=255,b=255})
    else
        name:setColor({r=0,g=0,b=0})
    end

 --    local ready_icon = self.node['read_icon' .. offlinePos]
	-- if online then --未准备
	-- 	ready_icon:show()
	-- else
	-- 	ready_icon:hide()
	-- end
end

function ReadyLayer:setTableID(tableId)
	-- body
	print("房间号:->",string.format(string_table.room_id_txt,tableId))
	self.node.txt_num_card:setString(tableId.."")
	-- self.node.room_id_txt:setString(string.format(string_table.room_id_txt,tableId))
end

--获取座位坐标列表
function ReadyLayer:getPosTable()
	-- body
	local pos_table = {}
	for i=1,RoomConfig.TableSeatNum do
		local head_node = self.node["head_bg" .. i]
		local head_content = head_node:getContentSize()
		local pos 
		if i == RoomConfig.DownSeat or i == RoomConfig.FrontSeat then
			pos = cc.pSub(cc.p(head_node:getPosition()),cc.p(head_content.width*2/5,0))
		else 
			pos = cc.pAdd(cc.p(head_node:getPosition()),cc.p(head_content.width*4/5,0)) 
		end
		table.insert(pos_table,pos)
	end
	return pos_table
end

function ReadyLayer:showVipInfo()
	-- body
	self.node.vip_layer:show()
	self.node.Node_vip:show()
end

function ReadyLayer:updateTableShow(tableInfo)
	-- dump(self.node.tableNode)
	-- local tableNode = self.node.tableNode
	-- local table_logo = tableNode:getChildByName("table_logo")
	-- local table_logo_playway = tableNode:getChildByName("table_logo_playway")
	-- local table_dizhu = tableNode:getChildByName("table_dizhu")

	-- print("tableInfo.playwaytype ", tableInfo.playwaytype)
	-- local playWayTex = self.res_base .. "/"
	-- local playWay1 = tableInfo.playwaytype   
	-- for k,v in pairs(RoomConfig.Rule) do 
	-- 	if bit._and(playWay1,v.value) == v.value then
	-- 		playWayTex = playWayTex..v.tex
	-- 		break
	-- 	end
	-- end
	-- if playWay1 == 0 then
	-- 	return
	-- end
	-- print(string.format("###[HBTableScene:updateTableShow]playWay1 %02x playWayTex %s", playWay1, playWayTex))
	-- if cc.FileUtils:getInstance():isFileExist(playWayTex) then
	-- 	--table_logo_playway:loadTexture(playWayTex, 1)
	-- end  

	-- local logoFile = string.format("%s/table_logo_%d.png", self.res_base, self.part.game_id)
	-- print("###[HBTableScene:updateTableShow]logoFile ", logoFile)
	-- if cc.FileUtils:getInstance():isFileExist(logoFile) then
	-- 	--table_logo:loadTexture(logoFile, 1)
	-- end
	
	-- local dizhu = tableInfo.diZhu 
	-- dizhu = dizhu or "0" 
	-- table_dizhu:setString("底分:".. dizhu)
end

--邀请好友
function ReadyLayer:InviteFriendsClick()
	-- body
	self.part:inviteFriends()
	
end

function ReadyLayer:readyClick()
	self.part:requestToStart(true) 
end

function ReadyLayer:cancelClick()
	self.part:requestToStart(false) 
end


function ReadyLayer:updatePlayerShow(viewID, isShow) 
	-- local ready_icon = self.node['read_icon' .. viewID]
	-- ready_icon:setVisible(isShow)
	local ready = self.node['ready_' .. viewID]
	ready:setVisible(isShow)
end

function ReadyLayer:switchToReadyState(ret)
	if nil == self.node.ready_btn or nil == self.node.cancel_btn then
		return
	end
	--此版本屏蔽牌局前准备
	self.node.ready_btn:setTouchEnabled(not ret)
	self.node.ready_btn:setEnabled(not ret)
	self.node.ready_btn:setVisible(not ret) 

	self.node.cancel_btn:setTouchEnabled(ret)
	self.node.cancel_btn:setEnabled(ret)
	self.node.cancel_btn:setVisible(ret)

	-- self.node.ready_btn:setTouchEnabled(false)
	-- self.node.ready_btn:setEnabled(false)
	-- self.node.ready_btn:setVisible(false) 
	
	-- self.node.cancel_btn:setTouchEnabled(false)
	-- self.node.cancel_btn:setEnabled(false)
	-- self.node.cancel_btn:setVisible(false)
end

--更新VIP场分享按钮和准备按钮的显示
function ReadyLayer:updateVIPOpBtn(ret)
	self.node.ready_btn:setVisible(ret)
	self.node.invite_btn:setVisible(ret)
	self.node.cancel_btn:setVisible(ret)
	self.node.vip_layer:setVisible(ret)
	self.node.Node_vip:setVisible(ret)
end


--解散房间
function ReadyLayer:CloseRoomClick()
	-- body
	self.part:closeRoom()
end

function ReadyLayer:MaskClick()
	--报错啦所以屏蔽
	if true then
		return
	end
	-- body
	self.part:maskClick()
end

function ReadyLayer:ExitClick()
	self.part:exitClick()
end

function ReadyLayer:hideSitAndInviteBtn() 
	self.node.ready_btn:hide()
	self.node.invite_btn:hide()
	self.node.cancel_btn:hide()
end

function ReadyLayer:XiXiShouClick()
	print("XiXiShouClick")
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
	local path_name = self.res_base .. '/effect_xixishou/xixishou'
	self:addEffect(path_name, 0)

end

function ReadyLayer:BaiCaiShenClick()
	print("BaiCaiShenClick")
	global:getModuleWithId(ModuleDef.AUDIO_MOD):playSound("res/sound/Button32.mp3",false)
	local path_name = self.res_base .. '/effect_baicaishen/baicaishen'
	self:addEffect(path_name, -100)
end

function ReadyLayer:addEffectMask()
	local mask_layer = cc.LayerColor:create()
    mask_layer:initWithColor(cc.c4b(0,0,0,150))
    self.node.root:addChild(mask_layer)
    mask_layer:setName('mask_layer')
    return mask_layer
end

function ReadyLayer:addEffect(path_name, offset)
	if self.node.root:getChildByName('mask_layer') then
		return 
	end

	self:addEffectMask()
	local ui_effect = Util.createSpineAnimation(path_name, '1', false, true, function()
		local mask_layer = self.node.root:getChildByName('mask_layer')
		if mask_layer then
			mask_layer:removeFromParent()
		end
	end)
	local size = self.node.root:getContentSize()
	ui_effect:setPosition(cc.p(size.width/2, size.height/2 + offset))
	self.node.root:addChild(ui_effect)
end

return ReadyLayer
