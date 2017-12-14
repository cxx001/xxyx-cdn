-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local BroadcastPart = class("BroadcastPart",cc.load('mvc').PartBase) --登录模块
BroadcastPart.DEFAULT_PART = {}
BroadcastPart.DEFAULT_VIEW = "BroadcastNode"
BroadcastPart.MAX_CACHE = 100
--[
-- @brief 构造函数
--]
function BroadcastPart:ctor(owner)
    BroadcastPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function BroadcastPart:initialize()
   self.broad_cast_list = {}
end

--激活模块
function BroadcastPart:activate(gameId,node)
    BroadcastPart.super.activate(self,CURRENT_MODULE_NAME,node)
    self.game_id = gameId
    self.broad_cast_running = false --是否正在播放广播
end

function BroadcastPart:startBroadcast(msg,loopNum,removeAll,curview,appId)
    --print("--------------startBroadcast appId, self.game_id ", appId, self.game_id)

    if tonumber(appId) == tonumber(self.game_id) then
        self.curview = curview
        for i=1,loopNum do                             
            self:insertBroadcast(msg,removeAll)
        end
    end
end

function BroadcastPart:insertBroadcast(msg,removeAll)
    --print("--------------insertBroadcast")
    table.insert(self.broad_cast_list,msg)
    if #self.broad_cast_list > BroadcastPart.MAX_CACHE then ---如果缓存的信息大于缓存最大数
        table.remove(self.broad_cast_list,1)
    end
    self:checkBroadcast(removeAll)
end

function BroadcastPart:checkBroadcast(removeAll)
    local length = (#self.broad_cast_list)
    if length == 0 and self.curview == true then 
        self:isShowBroadcastNode(false)
    end

    if #self.broad_cast_list > 0 and self.broad_cast_running == false then
        local msg = self.broad_cast_list[1]
        table.remove(self.broad_cast_list,1)
        self.view:broadcastUpdate(msg)
    end

    --print("--------------checkBroadcast msg : ",msg)
    --print("--------------checkBroadcast length : ",length)
end

function BroadcastPart:setBroadcastState(running)
    self.broad_cast_running = running
end

function BroadcastPart:deactivate()
    self.view:removeSelf()
    self.view =  nil
end

function BroadcastPart:isShowBroadcastNode(flag)
    -- body   
   self.view:isShowBroadcastNode(flag)
end

function BroadcastPart:getPartId()
    -- body
    return "BroadcastPart"
end

return BroadcastPart
