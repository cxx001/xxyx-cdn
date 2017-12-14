--[[
*名称:SmallUserInfoLayer
*描述:个人信息界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local SmallUserInfoLayer = class("SmallUserInfoLayer",cc.load("mvc").ViewBase)
local CURRENT_MODULE_NAME = ...
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
function SmallUserInfoLayer:onCreate()
	-- body
    self:initWithFilePath("SmallUserInfoLayer",CURRENT_MODULE_NAME)
end

function SmallUserInfoLayer:CloseClick()
    self.part:deactivate()
end


function SmallUserInfoLayer:setPlayerInfo(player_info , posX , posY , viewId , diamond,isVip, desc)
    -- body
    self.node.id:setString(player_info.playerIndex)
    self.node.name:setString(player_info.name)
    if isVip == false then
        self.node.coin_txt:setString(string_table.gold)
    else
        self.node.coin_txt:setString(string_table.score)
    end
    self.node.coin:setString(player_info.coin)

    local mode = self.part.owner.match_mode
    if mode then
        self.node.coin:hide()
        self.node.coin_txt:hide()
    end

    if self.node.ip then
        self.node.ip:setString(player_info.ip)
    end
    if self.node.diamond then
        for i,v in ipairs(diamond) do
            local playerPos = self.part:changeSeatToView(i) - 1
            if playerPos == 0 then
                playerPos = 4
            end
            if playerPos == viewId then
                self.node.diamond:setString(v)
            end
        end  
    end
    print("---player_info.headImgUrl : ",player_info.headImgUrl,player_info.targetPlayerName)   
        if player_info.headImgUrl and player_info.headImgUrl ~= "" then
            self.part:loadHeadImg(player_info.headImgUrl)
        elseif player_info.targetPlayerName and player_info.targetPlayerName ~= "" then
            self.part:loadHeadImg(player_info.targetPlayerName)
        end

    if desc and desc ~= "" then
        self.node.xiazui:setString(desc)
        self.node.xiazui_txt:show()
        self.node.xiazui:show()
    else
        self.node.xiazui_txt:hide()
        self.node.xiazui:hide()
    end

    local viewId = tostring(viewId)
    local pos = pos
    if viewId == "1" then
        pos =cc.p(posX+270 , posY+100)
    elseif viewId == "2" then
        pos =cc.p(posX-260 , posY)
    elseif viewId == "3" then
        pos =cc.p(posX-250 , posY-90)
    elseif viewId == "4" then
        pos =cc.p(posX+270 , posY)
    end
    self.node.bg:setPosition(pos)
end

function SmallUserInfoLayer:getHeadNode()
    -- body
    return self.node.head_sprite
end

return SmallUserInfoLayer
