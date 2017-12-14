--[[
*名称:AddRoomLayer
*描述:加入房间界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local AddRoomLayer = class("AddRoomLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
function AddRoomLayer:onCreate()
	-- body
	self:addMask()
	self:initWithFilePath("AddRoomLayer",CURRENT_MODULE_NAME)
	self.node.im_board:setScrollBarEnabled(false)
	local scale = display.width/1280
	self.node.bg:setScale(scale)
end

for i=0,9 do
	AddRoomLayer["NumClick" .. i] = function(self)
		-- body
		self.part:addNum(i)
	end
end

function AddRoomLayer:AddGameClick()    
	self.part:addGame()
end

function AddRoomLayer:ResetClick()    
	self.part:resetNum()
end

function AddRoomLayer:DelClick()    
	self.part:delNum()
end

function AddRoomLayer:CloseClick()
	-- body
	self.part:deactivate()
end

function AddRoomLayer:showNum(str,ids)
	-- body
    local inputComponent = self.node.Image_3:getChildByName("input_txt" .. ids )
    
	inputComponent:setString(str)
end

function AddRoomLayer:CreateGameClick()
	-- body
	self.part:createGameClick()
end


function AddRoomLayer:initUI(type)
	-- body
	local titleFileName, promptString, btnImageNormal, btnImagePressed

	if type == 1 then
		promptString = string_table.input_six_room_num
		titleFileName = 'addgame_bg.png'
		btnImageNormal, btnImagePressed = 'chongzhi1.png', 'chongzhi2.png'
	elseif type == 2 then
		promptString = string_table.input_six_referrer_num
		titleFileName = 'recommender-bg.png'
		btnImageNormal, btnImagePressed = 'confirm1.png', 'confirm2.png'
	else
		print("addroom init data is error")
	end

	local filepath = self.res_base .. "/"
	-- self.node.add_info_txt:setString(promptString) --推荐人后续要移除，由webview做

	self.node.tip_bg:loadTexture(filepath .. titleFileName)
	self.node.reset_btn:loadTextures(filepath .. btnImageNormal, filepath .. btnImagePressed)
end

return AddRoomLayer