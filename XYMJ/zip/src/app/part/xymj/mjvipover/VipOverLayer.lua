--[[
*名称:VipOverLayer
*描述:大结算界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local VipOverLayer = class("VipOverLayer",cc.load("mvc").ViewBase)
--[[
	界面处理需要保证就算是错误数据也做到不崩溃
	在获取到数据的时候进行checkData操作
]]
local CURRENT_MODULE_NAME = ...
function VipOverLayer:onCreate()
	-- body
    self:addMask()
	self:initWithFilePath("VipOverLayer",CURRENT_MODULE_NAME)
    self.node.player_list:setItemModel(self.node.player_panel2)
    self.node.player_list:addEventListener(handler(self,VipOverLayer.itemClick))
    self.node.player_list1:setItemModel(self.node.player_panel2)
    self.node.player_list1:addEventListener(handler(self,VipOverLayer.itemClick))
    self.list1_show = false
    self.cur_open_index = -1 --当前打开的item索引
    self.node.player_list1:hide()
end


function VipOverLayer:itemClick(tag,event)
    -- body
    print("this is item click:",tag,event)
    if event == 1 then

        local cur_index = self.node.player_list:getCurSelectedIndex()
        if self.list1_show == true then
            cur_index = self.node.player_list1:getCurSelectedIndex()
        end
        self:refreshVipData(cur_index)
    end
end


function VipOverLayer:vipOverDataInfo(data,vipData,tableId,creatorId)
    -- body
    local date_txt = os.date("%Y%m%d %H:%M")
    self.node.time:setString(date_txt)
    self.node.roomid:setString(string.format(string_table.room_id_txt,tableId))
    self.over_data = data
    self.vip_data = vipData
    self.creatorId = creatorId
    for i,v in ipairs(data.players) do
        self.node.player_list:insertDefaultItem(i -1)
        local item  = self.node.player_list:getItem(i-1)
        local head_bg = item:getChildByName("head_bg")
        local over_win = item:getChildByName("over_win")
        local banker_icon =item:getChildByName("banker_icon")
        local head_node = cc.Sprite:create(self.res_base .. "/logo0.png")
        head_node:setAnchorPoint(0,0)
        head_bg:addChild(head_node)
        local name = item:getChildByName("name")
        local zongchengji = item:getChildByName("zongchengji")
        local id_txt = item:getChildByName("id_txt")
        local rank_num = item:getChildByName("rank_num")


        local id = id_txt:getChildByName("id")
        local num = zongchengji:getChildByName("num")
        name:setString(v.name)
        id:setString(v.playerIndex)
        
        print("v.playerIndex : ",tonumber(v.playerIndex),creatorId,v.uid)
        if (tonumber(v.playerIndex) == tonumber(creatorId)) or (tostring(v.uid) == tostring(creatorId)) then --显示房主
            banker_icon:show()
        end
        
        local num_txt = v.coin
        if num_txt < 0 then
            num_txt = "/" .. math.abs(v.coin) 
        end
        num:setString(num_txt)
        rank_num:setString(i)
        if v.headImgUrl and v.headImgUrl ~= "" then
            self.part:loadHeadImg(v.headImgUrl,head_node)
        end


        if tostring(vipData.createID) == tostring(v.uid) or tostring(vipData.createID) == tostring(v.playerIndex) then
            local bankerImg = item:getChildByName("banker_icon")
            bankerImg:setVisible(true) 
        end

        if #data.players == 4 then
            if tonumber(data.winPos) == tonumber(v.tablepos) then
                over_win:show()
            end
        end
    end 
end

--刷新当前数据，显示某个玩家的详细数据
function VipOverLayer:refreshVipData(index)
    -- body
    local cur_list = self.node.player_list 
    if self.list1_show == false then
        self.list1_show = true
        self.node.player_list:hide()
        self.node.player_list1:removeAllChildren()
        self.node.player_list1:show()
        cur_list = self.node.player_list1
    else
        self.node.player_list:removeAllChildren()
        self.node.player_list1:hide()
        self.node.player_list:show()
        self.list1_show = false
    end
    
    for i,v in ipairs(self.over_data.players) do
        local item
        if i == index + 1 and self.cur_open_index ~= index then
            cur_list:insertCustomItem(self.node.player_panel1:clone(),i -1)
            item  = cur_list:getItem(i-1)
            local vip_over = item:getChildByName("vip_over")
            local hu_txt = vip_over:getChildByName("hu_txt")
            local zhongma_txt = vip_over:getChildByName("zhongma_txt")
            local gonggang_txt = vip_over:getChildByName("gonggang_txt")
            local angang_txt = vip_over:getChildByName("angang_txt")
            print("this is show vip info:",self.vip_data[i].hit_horse,self.vip_data[i].dianpaoCount,self.vip_data[i].ming_gang)
            hu_txt:setString(string.format(string_table.game_over_vip_winCount .. "%s",self.vip_data[i].hit_horse))
            zhongma_txt:setString(string.format(string_table.game_over_vip_dianPaoCount .. "%s",self.vip_data[i].dianpaoCount))
            gonggang_txt:setString(string.format(string_table.game_over_gong_gang .. "%s",self.vip_data[i].ming_gang))
            angang_txt:setString(string.format(string_table.game_over_an_gang .. "%s",self.vip_data[i].an_gang))
        else
            cur_list:insertCustomItem(self.node.player_panel2:clone(),i -1)
            item  = cur_list:getItem(i-1)
        end


        local head_bg = item:getChildByName("head_bg")
        local over_win = item:getChildByName("over_win")
        local banker_icon =item:getChildByName("banker_icon")
        local head_node = cc.Sprite:create(self.res_base .. "/logo0.png")
        head_node:setAnchorPoint(0,0)
        head_bg:addChild(head_node)
        local name = item:getChildByName("name")
        local zongchengji = item:getChildByName("zongchengji")
        local id_txt = item:getChildByName("id_txt")
        local rank_num = item:getChildByName("rank_num")

        local id = id_txt:getChildByName("id")
        local num = zongchengji:getChildByName("num")
        name:setString(v.name)
        id:setString(v.playerIndex)
        local num_txt = v.coin
        if num_txt < 0 then
            num_txt = "/" .. math.abs(v.coin) 
        end

                
        if (tonumber(v.playerIndex) == tonumber(self.creatorId))  or (tostring(v.uid) == tostring(self.creatorId)) then --显示房主
            banker_icon:show()
        end
        num:setString(num_txt)
        rank_num:setString(i)
        if v.headImgUrl and v.headImgUrl ~= "" then
            self.part:loadHeadImg(v.headImgUrl,head_node)
        end

        if #self.over_data.players == 4 then
            if tonumber(self.over_data.winPos) == tonumber(v.tablepos) then
                over_win:show()
            end
        end
    end

    if self.cur_open_index == index then
        self.cur_open_index = -1
    else
        self.cur_open_index = index
    end

end

function VipOverLayer:BackClick()
    self.part:returnGame()
end

function VipOverLayer:onClose()
    self:BackClick()
end

function VipOverLayer:ShowClick()
    local bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
    -- bridge:saveGamePic()

    local shareContent = string_table.wx_one_friend
    local shareUrl = string_table.share_weixin_android_url
    --分享内容和分享链接都是从服务器上拉取的

    local user = global:getGameUser()
    local props = user:getProps()
    local gameConfigList = props["gameplayer" .. SocketConfig.GAME_ID].gameConfigList

    for i,v in ipairs(gameConfigList) do
        local gameParam = gameConfigList[i]
        if gameParam.paraId == ClientParamConfig.WEIXIN_SHARE_CONTENT then
            if gameParam.valueStr then
                shareContent = gameParam.valueStr --分享内容
            end
        end

        if device.platform == "android" then
            if gameParam.paraId == ClientParamConfig.WEIXIN_SHARE_URL_ANDROID then
                if gameParam.valueStr then
                    shareUrl = gameParam.valueStr --分享链接
                end
            end
        elseif device.platform == "ios" then
            if gameParam.paraId == ClientParamConfig.WEIXIN_SHARE_URL_IOS then
                if gameParam.valueStr then
                    shareUrl = gameParam.valueStr --分享链接
                end
            end
        end
    end

    if bridge.savePicAndShare then
        bridge:savePicAndShare(nil,shareContent,shareUrl,2)
    else
        bridge:saveGamePic()
        local time = nil
        time = self:schedulerFunc(function()
            if time ~= nil then
                self:unScheduler(time)
            end
            bridge:ShareToWX(2,shareContent,shareUrl) --分享图片
        end,1,false)
    end
    -- self:BackClick()
end

return VipOverLayer
