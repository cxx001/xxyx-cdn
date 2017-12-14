--[[
*名称:DissolveLayer
*描述:创建房间界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local DissolveLayer = class("DissolveLayer",cc.load("mvc").ViewBase)
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
local CURRENT_MODULE_NAME = ...
function DissolveLayer:onCreate(data) --传入数据
	-- body
	self:initWithFilePath("DissolveLayer",CURRENT_MODULE_NAME)
	self.tips_show = false 
end


function DissolveLayer:CloseClick()
	self:LayerInit()
end

function DissolveLayer:SetData(data,playerList,m_seat_id)
	-- body

	--请求解散的人
	local player_request = self.part:changeSeatToView(data.mRequestCloseTablePlayerTablePos)
    local player_request_txt = self.part:getPlayerInfo(player_request)
    local m_seat_id = self.part:changeSeatToView(m_seat_id)
    self.node.playertxt:setString(player_request_txt.name)
    self.node.player0:setString(player_request_txt.name)
	self.node.agree0:setString(string_table.player_agree)
	self.node.agree0:setTextColor({r=147,g=221,b=75})			--agree green

	--其余的三个人初始化为等待
    self.msg_txt = {}
    for i,v in ipairs(playerList) do
    	if v.view_id ~= player_request then
    		local player_table = {}
    		player_table.playerIndex = v.playerIndex
			player_table.id = v.view_id
			player_table.name = v.name
			player_table.click = false
			player_table.txt1 = player_table.name
			player_table.txt2 = string_table.player_wait
			player_table.color = {r=251,g=214,b=104}
			table.insert(self.msg_txt, player_table)
		end
	end

	--同意的人
	if data.mAgreeTablePos ~= nil then
		for i,v in ipairs(data.mAgreeTablePos) do
			local playerId = self.part:changeSeatToView(v)
			print("playerId Agree : ",playerId)
			for k,j in ipairs(self.msg_txt) do
				if j.id == playerId then
					j.click =true
					j.txt1 = j.name
					j.txt2 = string_table.player_agree
					j.color = {r=147,g=221,b=75}
				end
			end
		end
	end

	--拒绝的人
	if data.mRefuseTablePos ~= nil then
		for i,v in ipairs(data.mRefuseTablePos) do
			local playerId = self.part:changeSeatToView(v)
			print("playerId Refuse : ",playerId)
			for k,j in ipairs(self.msg_txt) do
				if j.id == playerId then
					j.click =true
					j.txt1 = j.name
					j.txt2 = string_table.player_disagree
					j.color = {r=238,g=56,b=56}
				end
			end
		end
	end

	local arr = {}
	for i,v in ipairs(self.msg_txt) do
    	if v.view_id ~= player_request then
    		arr[i] = v.click
		end
	end
	if arr[1] == false and arr[2] == false and arr[3] == false then 
		self.tips_show = false
	end

	for i,v in ipairs(self.msg_txt) do
		if i >= 1 and i <= 3 then
			local player_list = self.node["player" .. i]
			local agree_list = self.node["agree" .. i]
			if player_list and agree_list then
				player_list:setString(v.txt1)
				agree_list:setString(v.txt2)
				agree_list:setTextColor(v.color)
				if v.click == false and m_seat_id == v.id and self.tips_show == false then
					self.tips_show = true
					self:showGreyBtn(true)
				end

				if v.click == true and m_seat_id == v.id then 	--已经同意或者拒绝的玩家，不显示同意拒绝按钮
					self:showGreyBtn(false)
				end

				if m_seat_id == player_request then				--请求解散的玩家，不显示同意拒绝按钮
					self:showGreyBtn(false)
				end
			end
		else
			print("Dissolve data playerList overflow")
		end
	end

	self:startCountTime(data.mLeftTime)
end

function DissolveLayer:showBtn(flag)

end

function DissolveLayer:startCountTime(wait_time)
	-- body
	print("DissolveLayer wait_time : ",wait_time)
	local cur_time = 1
	if self.time_entry ~= -1 then
		self:unScheduler(self.time_entry)
		self.time_entry = -1
	end
	self.time_entry = self:schedulerFunc(function()
		-- body
		if cur_time > wait_time then
			self:unScheduler(self.time_entry)
			self.time_entry = -1
			return
		end
		local time = wait_time - cur_time
		self.node.timeout:setString(time)
		cur_time = cur_time + 1
	end,1,false)
end

function DissolveLayer:LayerInit(isshow)
	if isshow == true then
		self.node.touchMask:show()
		self.node.dissolveBg:show()
	else
		self.node.touchMask:hide()
		self.node.dissolveBg:hide()
	end
end

function DissolveLayer:showBtn(isshow)
	-- body
	if isshow == true then
		self.node.agree_btn:show()
		self.node.disagree_btn:show()
	else
		self.node.agree_btn:hide()
		self.node.disagree_btn:hide()
	end
end

function DissolveLayer:showGreyBtn(enable)
	self.node.agree_btn:setEnabled(enable)
	self.node.disagree_btn:setEnabled(enable)
end

function DissolveLayer:disAgreeClick()
	-- body
	self.part:sureCloseVipRoom(3)
end

function DissolveLayer:agreeClick()
	-- body
	self.part:sureCloseVipRoom(2)
end

--不处理返回时间
function DissolveLayer:backEvent()
    
end

return DissolveLayer
