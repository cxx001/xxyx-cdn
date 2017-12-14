--[[
*名称:AdLayer
*描述:广告界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
local AdNode = class("AdNode",cc.load("mvc").ViewBase)
AdNode.CHANGE_TIME = 15 -- 5秒切一次轮播图
local CURRENT_MODULE_NAME = ...
function AdNode:onCreate()
	-- body
    print("----AdNode:onCreate")
	self:initWithFilePath("AdPicNode",CURRENT_MODULE_NAME)
	local scale = display.width/1280
	self.node.root:setScale(scale)
end

function AdNode:initAdPageView(data)
	local PAGE_GAME_NUM = math.ceil(#data)
	self.page_game_num = PAGE_GAME_NUM
	for i=1,PAGE_GAME_NUM do 
		self.node.Ad_PageView:addPage(self.node.Ad_Image_Panel:clone())
	end
	if PAGE_GAME_NUM > 1 then
		self.node.Ad_PageView:setCurrentPageIndex(1)
	end
	self.node.Ad_PageView:addEventListener(handler(self,AdNode.pageViewEvent))
end

function AdNode:onEnter()
	-- body
	self:schedulerFunc(function()
		-- body
		local cur_page = self.node.Ad_PageView:getCurrentPageIndex()
		cur_page = (cur_page + 1)%self.page_game_num
		self.node.Ad_PageView:scrollToPage(cur_page)
	end,AdNode.CHANGE_TIME,false)
end

function AdNode:onExit()
	-- body
    print("----AdNode:onExit")
	self:clearScheduler()
	self.part.view = nil
	local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
	if lua_bridge.clearDownImgList ~= nil then
		lua_bridge:clearDownImgList()
	end
end


local function detachChild(node)
	if node then
		local ret = node:getChildByName("Ad_Image")
		ret:retain()                          -- @@@@@@@
		ret:removeFromParent(false)
		return ret
	end
end

local function attachChild(node, child)
	if node and child then
		node:addChild(child)
		child:release()                       -- @@@@@@@
	end
end

local function roll(arr, bForward)
    if #arr <= 0 then
        return
    end
	local temp = {}

	if bForward then
		table.insert(temp, detachChild(arr[#arr]))
		for i = 1, (#arr-1) do
			table.insert(temp, detachChild(arr[i]))
		end
	else
		for i = 2, #arr do
			table.insert(temp, detachChild(arr[i]))
		end
		table.insert(temp, detachChild(arr[1]))
	end

	for i = 1, #arr do
		attachChild(arr[i], temp[i])
	end
end

function AdNode:pageViewEvent(tag,event)
	-- body
	local cur_page = self.node.Ad_PageView:getCurrentPageIndex()
	if cur_page == 0 then
		self:schedulerFuncOnce(function()
			self.node.Ad_PageView:setCurrentPageIndex(1)
			roll(self.node.Ad_PageView:getItems(), true) 
		end, 0, false )
	elseif cur_page == (self.page_game_num - 1) then
		self:schedulerFuncOnce(function()
			self.node.Ad_PageView:setCurrentPageIndex(self.page_game_num - 2)
			roll(self.node.Ad_PageView:getItems(), false) 
		end, 0, false )
	end
end

function AdNode:getAdImgNode(idx)
	local page_panel = self.node.Ad_PageView:getItem(idx - 1):getChildByName("Ad_Image")
	local sprite = cc.Sprite:create(self.res_base .. "/AdPic.png")
	local size = page_panel:getContentSize()
	sprite:setPosition(cc.p(size.width * 0.5, size.height * 0.5))
	page_panel:addChild(sprite)
	return sprite
end

function AdNode:showAdNode(isShow)
	print("###[AdNode:showAdPanel]isShow ", isShow)
	if isShow then 
		self.node.Ad_Panel:runAction(cc.FadeIn:create(0.2)) 
		self.node.Ad_Image_Panel:runAction(cc.FadeIn:create(0.2)) 
	else
		self.node.Ad_Panel:runAction(cc.FadeOut:create(0.2))
		self.node.Ad_Image_Panel:runAction(cc.FadeOut:create(0.2)) 
	end
end

return AdNode
