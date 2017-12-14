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
	self:initWithFilePath("NewReadyLayer",CURRENT_MODULE_NAME)
	self:switchToReadyState(false) 
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
		local head_node = self.node["head_node" .. playerInfo.view_id]
		local name = self.node['name' .. playerInfo.view_id]
		local coin = self.node['coin' .. playerInfo.view_id]
		local ready_icon = self.node['read_icon' .. playerInfo.view_id]
		head_node:show()
		--print("###[ReadyLayer:showPlayer] playerInfo.gamestate is ", playerInfo.gamestate)
		-- if playerInfo.gamestate == self.part.ePlayerState.NOREADY then --未准备
		-- 	ready_icon:hide()
		-- else
		-- 	ready_icon:show()
		-- end
		ready_icon:hide()
		name:setString(playerInfo.name)
		name:setColor({r=255,g=255,b=255})		--初始化白色
		coin:setString(playerInfo.coin)
		
		if playerInfo.intable == 0 then
            self:offlinePlayer(playerInfo.view_id,false)
		end

		if playerInfo.targetPlayerName ~= nil then
			if playerInfo.targetPlayerName and playerInfo.targetPlayerName ~= "" then
				self.part:loadHeadImg(playerInfo.targetPlayerName,head_node)
			end
		else 	
			if playerInfo.headImgUrl and playerInfo.headImgUrl ~= "" then
				self.part:loadHeadImg(playerInfo.headImgUrl,head_node)
			end
		end
	end
end

function ReadyLayer:hidePlayer(num)
	local head_node = self.node["head_node" .. num]
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
	self.node.room_id_txt:setString(string.format(string_table.room_id_txt,tableId))
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
	local ready_icon = self.node['read_icon' .. viewID]
	ready_icon:setVisible(isShow) 
end

function ReadyLayer:switchToReadyState(ret)
	if nil == self.node.ready_btn or nil == self.node.cancel_btn then
		return
	end
	self.node.ready_btn:setTouchEnabled(not ret)
	self.node.ready_btn:setEnabled(not ret)
	self.node.ready_btn:setVisible(not ret)

	self.node.cancel_btn:setTouchEnabled(ret)
	self.node.cancel_btn:setEnabled(ret)
	self.node.cancel_btn:setVisible(ret)
end

--更新VIP场分享按钮和准备按钮的显示
function ReadyLayer:updateVIPOpBtn(ret)
	-- self.node.ready_btn:setVisible(ret)
	-- self.node.invite_btn:setVisible(ret)
	-- self.node.cancel_btn:setVisible(ret)
	self.node.vip_layer:setVisible(ret)
end


--解散房间
function ReadyLayer:CloseRoomClick()
	-- body
	self.part:closeRoom()
end

function ReadyLayer:MaskClick()
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

function ReadyLayer:ChatClick()
	-- body
	global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self.part:chatClick()
end

return ReadyLayer
