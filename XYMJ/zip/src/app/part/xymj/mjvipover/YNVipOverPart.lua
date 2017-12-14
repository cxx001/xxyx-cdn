-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local VipOverPart = import(".VipOverPart")
local YNVipOverPart = class("YNVipOverPart",VipOverPart) 

function YNVipOverPart:vipOverDataInfo(data,tableid, createID)

    local vip_data = {}
    for k,v in ipairs(data.players) do
        vip_data[k] = {}
        if v.vipoverdata then
            local hithorsecount = v.vipoverdata.hithorsecount
            vip_data[k].dianpaoCount = v.vipoverdata.dianpaocount
            vip_data[k].ming_gang = bit._and(bit.rshift(hithorsecount,8),0xff)
            vip_data[k].an_gang = bit._and(bit.rshift(hithorsecount,16),0xff)
            vip_data[k].hit_horse = v.vipoverdata.wincount
        end
    end
    vip_data.createID = createID
    self.view:vipOverDataInfo(data,vip_data,tableid)
end

return YNVipOverPart