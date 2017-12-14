--[[
*名称:UserInfoLayer
*描述:玩家信息界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local UserInfoLayer = class("UserInfoLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]

function UserInfoLayer:onCreate(data) --传入数据
	-- body
	self.pageIndex = 0
	self:addMask()
	self:initWithFilePath("UserInfoLayer",CURRENT_MODULE_NAME)
	self.node.liushui_panel_list:setItemModel(self.node.liushui_item_panel)
	for i=1,2 do
		UserInfoLayer["ChooseSelect" .. i] = function(self)
			self.part:selectChoose(i)
		end
	end
    self.node["CheckBox_userinfo"]:setTouchEnabled(false)
	self.node["choose_select1"]:setTouchEnabled(false)

	for i=1,3 do
		UserInfoLayer["LiushuiSelectEvent" .. i] = function(self)
			self.part:selectLiushui(i,nil)
		end

		--UserInfoLayer["userSelectEvent" .. i] = function(self)
			--self.part:selectuser(i)
		--end
	end
	--self.node.user_panel:show()
    local scale = display.width/1280
	self.node.bg:setScale(scale)

	self.node["CheckBox_userliushui"]:hide()
	self.node["liushui_panel_list"]:hide()
	self.node["user_list"]:setScrollBarEnabled(false)
end

function UserInfoLayer:selectChoose(type)
	-- body
	for i=1,2 do --关闭当前选择
		if i ~= type then
			self.node["choose_select" .. i]:setSelected(false)
            self.node["choose_select" .. i]:setTouchEnabled(true)
            if i == 1 then
                self.node["CheckBox_userinfo"]:setSelected(false)
                self.node["CheckBox_userinfo"]:setTouchEnabled(true)
            else
                -- self.node["CheckBox_userliushui"]:setSelected(false)
                -- self.node["CheckBox_userliushui"]:setTouchEnabled(true)
            end
            self.isSelect = true
        else 
            self.node["choose_select" .. i]:setSelected(true)
            self.node["choose_select" .. i]:setTouchEnabled(false)
            if i == 1 then
                self.node["CheckBox_userinfo"]:setSelected(true)
                self.node["CheckBox_userinfo"]:setTouchEnabled(false)
            else
                self.node["CheckBox_userliushui"]:setSelected(true)
                self.node["CheckBox_userliushui"]:setTouchEnabled(false)
            end
            self.isSelect = false
		end
	end

	if type == 2 then
		self.node.liushui_panel:show()
		--self.node.user_panel:hide()
		self:hideUserLayer()
		self.part:selectLiushui(1,nil)
	elseif type == 1 then
		self.node.liushui_panel:hide()
		--self.node.user_panel:show()
		self.part:selectuser(1)
		self.node.liushui_panel_list:removeAllItems()
	end

	self:setNomessage(false)
end

function UserInfoLayer:selectLiushui(type)
	-- body
	for i=1,3 do --关闭当前选择
		if i ~= type then
			self.node["liushui_select" .. i]:setSelected(false)
			self.node["liushui_select" .. i]:setTouchEnabled(true)
			self.isSelect = true
		else 
			self.node["liushui_select" .. i]:setSelected(true)
			self.node["liushui_select" .. i]:setTouchEnabled(false)
			self.isSelect = false
		end
	end
	self:setNomessage(false)
end

function UserInfoLayer:selectuser(type)
	-- body
	--[[self:setNomessage(false)
	for i=1,2 do --关闭当前选择
		if i ~= type then
            self.node["choose_select" .. i]:setSelected(false)
			self.node["choose_select" .. i]:setTouchEnabled(true)
            if i == 1 then
                self.node["CheckBox_userinfo"]:setSelected(false)
                self.node["CheckBox_userinfo"]:setTouchEnabled(true)
            else
                self.node["CheckBox_userliushui"]:setSelected(false)
                self.node["CheckBox_userliushui"]:setTouchEnabled(true)
            end
			self.isSelect = true
		else 
			self.node["choose_select" .. i]:setSelected(true)
			self.node["choose_select" .. i]:setTouchEnabled(false)
            if i == 1 then
                self.node["CheckBox_userliushui"]:setSelected(false)
                self.node["CheckBox_userliushui"]:setTouchEnabled(true)
            else
                self.node["CheckBox_userinfo"]:setSelected(false)
                self.node["CheckBox_userinfo"]:setTouchEnabled(true)
            end
			self.isSelect = false
		end
	end
	if type == 1 then
		self:hideUserLayer()
		self:showUserInfoLayer()
	elseif type == 2 then
		self:hideUserLayer()
		--self:showReferrerPanel()
	elseif type == 3 then
		--self:showReferrerPanel()
	end]]
end

function UserInfoLayer:getHeadNode()
	-- body
	return self.node.head
	-- return self.node.head_img.head
end

function UserInfoLayer:updateUserInfo(userInfo)
	-- body
	local game_player = userInfo["gameplayer" .. SocketConfig.GAME_ID]

	print("userInfo:",game_player)
	self.node.nick_name_txt:setString(userInfo.name)
	self.node.id_txt:setString(game_player.playerIndex)
	self.node.zuan_txt:setString(game_player.diamond)
	self.playerIndex = game_player.playerIndex

	local spHead = self:getHeadNode()
	local user_info= global:getGameUser():getProps()
   	local orgNodeWidth=spHead:getTextureRect().width
    local orgNnodeHeight= spHead:getTextureRect().height
	local orgScaleX = spHead:getScaleX()
 	local orgScaleY = spHead:getScaleY()
 	if user_info.photo	and user_info.photo ~= "" then
 		Util.loadHeadImg(user_info.photo,spHead)
 	end
	local  head_nodeWidth=spHead:getTextureRect().width
	local  head_nodeHeight= spHead:getTextureRect().height
  	spHead:setScaleX(orgNodeWidth * orgScaleX/head_nodeWidth)
	spHead:setScaleY(orgNnodeHeight * orgScaleY/head_nodeHeight)
	-- local user = global:getGameUser()
	-- local recommender_Id = user:getProp("recommender_Id"..SocketConfig.GAME_ID)
	-- local recommenderId = 0
	
	-- if recommender_Id and recommender_Id.recommenderId then
	-- 	recommenderId = recommender_Id.recommenderId
	-- end

	-- if recommenderId == 0 then
	-- 	recommenderId =""
	-- end
	-- self.node.refe_txt:setString(recommenderId)
end

function UserInfoLayer:updateUserRefeTxt(recommenderId)
	self.node.refe_txt:setString(recommenderId)
end

function UserInfoLayer:CloseClick()
    global:getAudioModule():playSound("res/sound/Button32.mp3",false)
	self.part:deactivate()
end

function UserInfoLayer:UserInfoEvent()
    global:getAudioModule():playSound("res/sound/Button32.mp3",false)
end

function UserInfoLayer:PasswordEvent()
    global:getAudioModule():playSound("res/sound/Button32.mp3",false)
end

function UserInfoLayer:setNomessage(type)
	-- body
	if type == true then
		self.node.nomassage:show()
		self.node.user_info_layer:hide()
		self.node.liushui_panel_list:removeAllItems()
	else
		self.node.nomassage:hide()
	end
end

function UserInfoLayer:setLiftRight(type)
	-- body
	if type == true then
		self.node.liftrightpanel:show()
	else
		self.node.liftrightpanel:hide()
	end
end

function UserInfoLayer:setData(data)
	self.node.liushui_panel_list:removeAllItems()

	self.pageIndex = data.pageIndex
	self.totalPage = data.totalPage
	--self.totalPage = 20
	if data.logs then
		for k,v in ipairs(data.logs) do
			self.node.liushui_panel_list:insertDefaultItem(k-1)
			local item = self.node.liushui_panel_list:getItem(k-1)

			local number = item:getChildByName("number")
			local str = item:getChildByName("str")
			number:setString(k)
	
			local strDetail = ""..v.opDetail.."    "..v.dateStr.."     "..v.opGold..string_table.mall_title_diamond

			str:setString(strDetail)
		end
	else
		print("data.logs is nil")
		return
	end


	self:setRLEnable(self.totalPage,self.pageIndex)


--[[
	self.node.liushui_panel_list:removeAllItems()
	for i=1,20 do
		self.node.liushui_panel_list:insertDefaultItem(i-1)
		local item = self.node.liushui_panel_list:getItem(i-1)
		local number = item:getChildByName("number")
		local str = item:getChildByName("str")
		number:setString(i)
	end
]]
end

function UserInfoLayer:setRLEnable(totalPage , pageIndex) 	--设置左右键Enable
	-- body
	print("-------------totalPage: ",totalPage)
	print("-------------pageIndex: ",pageIndex)
	if 0 == totalPage - 1 then
		self.node.left_btn:hide()
		self.node.right_btn:hide()
	elseif 0 < totalPage - 1 and pageIndex == 0 then
		self.node.left_btn:hide()
		self.node.right_btn:show()
	elseif 0 < totalPage - 1 and pageIndex == totalPage - 1 then
		self.node.left_btn:show()
		self.node.right_btn:hide()
	elseif pageIndex < totalPage and pageIndex > 0 then
		self.node.left_btn:show()
		self.node.right_btn:show()
	end
end

function UserInfoLayer:rightClick()
	-- body
	--print("-------------------rightClick")
	self.pageIndex = self.pageIndex + 1
	--self:setRLEnable(self.totalPage,self.pageIndex)
	self.part:selectLiushui(nil,self.pageIndex)
end

function UserInfoLayer:leftClick()
	-- body
	--print("-------------------leftClick")
	self.pageIndex = self.pageIndex - 1
	--self:setRLEnable(self.totalPage,self.pageIndex)
	self.part:selectLiushui(nil,self.pageIndex)
end

function UserInfoLayer:OkClick()
	-- body
	local txt = tonumber(self.node.input_feild:getString())
	print("--------------txt : ",txt)
	self.part:okClick(txt)
end

function UserInfoLayer:showReferrerPanel()
	self.node.user_info_layer:hide()
	--self.node.referrer_panel:show()
	self.node.appilagency_panel:hide()
end

function UserInfoLayer:showUserInfoLayer()
	self.node.user_info_layer:show()
	--self.node.referrer_panel:hide()
	self.node.appilagency_panel:hide()
end

function UserInfoLayer:hideUserLayer()
	self.node.user_info_layer:hide()
	--self.node.referrer_panel:hide()
	self.node.appilagency_panel:hide()
end

function UserInfoLayer:setApplyAgency()
	local FileName1 = self.res_base .. '/apply_agency.png'
	local FileName2 = self.res_base .. '/apply_agency-l.png'
	self.node.user_select2:loadTextureBackGround(FileName2,1)
	self.node.user_select2:loadTextureBackGroundSelected(FileName2,1)
	self.node.user_select2:loadTextureFrontCross(FileName1,1)
end

function UserInfoLayer:showAppilaGency(msg,type)  
	self.node.appilagency_panel:show()
	self.node.user_info_layer:hide()
	--self.node.referrer_panel:hide()

	local str = ""
	local strtmp = string.gsub(msg, "UID", tostring(self.playerIndex))
	local strArr = self.part:split(strtmp,";")
	for i,v in ipairs(strArr) do
		str = str .. v .. '\n'
	end
	if type == 1 then

	elseif type == 2 then
		local FileName3 = self.res_base .. '/weixinshare.png'
		self.node.appilagency_btn:loadTextureNormal(FileName3,1)
		self.node.appilagency_btn:loadTexturePressed(FileName3,1)
	end
	self.node.appilagency_txt:setString(str)
end

function UserInfoLayer:AppilAgencyClick() 
	print("###[UserInfoLayer:AppilAgencyClick]")
	--body
	self.part:appilAgencyClick()
end

function UserInfoLayer:InputClick()
	print("###[UserInfoLayer:InputClick]")
	-- body
	self.part:inputClick()
end

return UserInfoLayer