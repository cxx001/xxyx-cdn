--[[
*名称:GpsLayer
*描述:通知界面
*版权:Copyright © 2016-2018 深圳市三只小熊科技有限公司 版权所有
*作者:管理员
*创建日期:
*修改日期:
*备注:该类属于baseClsss请勿修改，如需修改请详询管理员
]]
-- local BasePart = require("packages.mvc.BasePart")
local CURRENT_MODULE_NAME = ...
local GpsPart = class("GpsPart",cc.load('mvc').PartBase) --登录模块
GpsPart.DEFAULT_VIEW = "GpsLayer"

--[
-- @brief 构造函数
--]
GpsPart.CMD = {
    MSG_GET_PLAYERS_GPS_INFO = 0xc30503,		--发送GPS位置
    MSG_GET_PLAYERS_GPS_INFO_ACK = 0xc30504	--GPS ack
}
function GpsPart:ctor(owner)
    GpsPart.super.ctor(self, owner)
    self:initialize()
end

--[
-- @override
--]
function GpsPart:initialize()

end

--激活模块
function GpsPart:activate(gameId,tablepos,flag)
	-- gameId = 262401 --临时调试用
	tablepos = tablepos or 1
	flag = flag or 2
	self.game_id = gameId
	GpsPart.super.activate(self,CURRENT_MODULE_NAME)
	self:sendGpsMsg(tablepos,flag)
	self:setIsShow(true)
end

function GpsPart:sendGpsMsg(tablepos,flag)
	-- body
	print("sendGpsMsg")
	if flag > 1 then
		self.view:showGpsBtn(true)
		local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
		net_mode:registerMsgListener(GpsPart.CMD.MSG_GET_PLAYERS_GPS_INFO_ACK ,handler(self,GpsPart.msgGetPlayersGpsInfoAck))

		self.m_pos = tablepos
		self.seat = {}
		for loop = 0 , 3 do
			self.seat[loop + 1] = self:changeSeatToView(loop)
		end

		self:msgGetPlayersGpsInfo()
	else
		self.view:showGpsBtn(false)
	end
end


function GpsPart:msgGetPlayersGpsInfo()				--请求GPS
	-- body

	local lua_bridge = global:getModuleWithId(ModuleDef.BRIDGE_MOD)
	self.m_latitude = lua_bridge:getGPSLatitude()
	self.m_longitude = lua_bridge:getGPSLongitude()

	local net_mode = global:getModuleWithId(ModuleDef.NET_MOD)
	local msg_get_players_gps_info = comm_struct_pb.GetPlayersGpsInfo()
	msg_get_players_gps_info.latitude = self.m_latitude
	msg_get_players_gps_info.longitude = self.m_longitude
	net_mode:sendProtoMsg(msg_get_players_gps_info,GpsPart.CMD.MSG_GET_PLAYERS_GPS_INFO,self.game_id)
end

function GpsPart:msgGetPlayersGpsInfoAck(data,appID) 	--GPS回调
	-- body
	self.view:isShowGipTip(self.isshow)
	local msg_get_players_gps_info_ack = comm_struct_pb.GetPlayersGpsInfoAck()
	msg_get_players_gps_info_ack:ParseFromString(data)
	print("GpsPart msgGetPlayersGpsInfoAck: ",msg_get_players_gps_info_ack)

	self.Latitude = {}
	self.Longitude = {}

	self.distance = msg_get_players_gps_info_ack.distance
    self.Latitude[self.seat[1]] = msg_get_players_gps_info_ack.player0Latitude
    self.Longitude[self.seat[1]] = msg_get_players_gps_info_ack.player0Longitude
    self.Latitude[self.seat[2]] = msg_get_players_gps_info_ack.player1Latitude
    self.Longitude[self.seat[2]] = msg_get_players_gps_info_ack.player1Longitude
    self.Latitude[self.seat[3]] = msg_get_players_gps_info_ack.player2Latitude
    self.Longitude[self.seat[3]] = msg_get_players_gps_info_ack.player2Longitude
    self.Latitude[self.seat[4]] = msg_get_players_gps_info_ack.player3Latitude
    self.Longitude[self.seat[4]] = msg_get_players_gps_info_ack.player3Longitude

    self:showGpsDistance()
end

function GpsPart:setIsShow(flag)
	-- body
	self.isshow = flag
end

function GpsPart:showGpsDistance()
	-- body
	self.gps_table = {}
    for loop = 1,4 do
    	local tmp_table = {}
		tmp_table.clent_seat = self.seat[loop]		--clent Seat
		tmp_table.seat = loop 						--server Seat
		table.insert(self.gps_table, tmp_table)
	end

	for i=1,4 do  
        for j=1,4-i do  
            if self.gps_table[j].clent_seat > self.gps_table[j+1].clent_seat then
                local tmp = self.gps_table[j]
                self.gps_table[j] = self.gps_table[j+1]
                self.gps_table[j+1] = tmp
            end  
        end  
    end  

    self.clent_seat = {}
    for i,v in ipairs(self.gps_table) do
		self.clent_seat[i] = v.clent_seat
	end


    self.gpsFlag = {}  													--gps是否有效标志
	for loop = 1 , 4 do
		if self.Latitude[self.clent_seat[loop]] == 0 and self.Longitude[self.clent_seat[loop]] == 0 then
			self.gpsFlag[loop] = false 
		else
			self.gpsFlag[loop] = true
		end
		print(self.gpsFlag[loop] , loop)
		self.view:showSeat(self.gpsFlag[loop] , loop)	
	end

	self.Distance = {}
	for loop = 1,6 do 
		self.Distance[loop] = 0
	end
	--print("self.gpsFlag[self.seat[1]]",self.gpsFlag[self.seat[1]])
	if self.gpsFlag[1] == true then
		
		if self.gpsFlag[2] == true then
			self.Distance[1] = self:LatitudeLongitudeDist(self.Latitude[self.clent_seat[1]],self.Longitude[self.clent_seat[1]],self.Latitude[self.clent_seat[2]],self.Longitude[self.clent_seat[2]])--a与b的距离A
			self.view:showDistance(1,self.Distance[1],self.distance)
		else
			self.view:showDistance(1,false)
		end
		
		if self.gpsFlag[3] == true then
			self.Distance[2] = self:LatitudeLongitudeDist(self.Latitude[self.clent_seat[1]],self.Longitude[self.clent_seat[1]],self.Latitude[self.clent_seat[3]],self.Longitude[self.clent_seat[3]])--a与c的距离B
			self.view:showDistance(2,self.Distance[2],self.distance)
		else
			self.view:showDistance(2,false)
		end
		
		if self.gpsFlag[4] == true then
			self.Distance[3] = self:LatitudeLongitudeDist(self.Latitude[self.clent_seat[1]],self.Longitude[self.clent_seat[1]],self.Latitude[self.clent_seat[4]],self.Longitude[self.clent_seat[4]])--a与d的距离C
			self.view:showDistance(3,self.Distance[3],self.distance)
		else
			self.view:showDistance(3,false)
		end
	else
		self.view:showDistance(1,false)
		self.view:showDistance(2,false)
		self.view:showDistance(3,false)
	end

	if self.gpsFlag[2] == true then	
		if self.gpsFlag[3] == true then
			self.Distance[4] = self:LatitudeLongitudeDist(self.Latitude[self.clent_seat[2]],self.Longitude[self.clent_seat[2]],self.Latitude[self.clent_seat[3]],self.Longitude[self.clent_seat[3]])--b与c的距离D
			self.view:showDistance(4,self.Distance[4],self.distance)
		else
			self.view:showDistance(4,false)
		end

		if self.gpsFlag[4] == true then
			self.Distance[5] = self:LatitudeLongitudeDist(self.Latitude[self.clent_seat[2]],self.Longitude[self.clent_seat[2]],self.Latitude[self.clent_seat[4]],self.Longitude[self.clent_seat[4]])--b与d的距离E
			self.view:showDistance(5,self.Distance[5],self.distance)
		else
			self.view:showDistance(5,false)
		end
	else
		self.view:showDistance(4,false)
		self.view:showDistance(5,false)
	end

	if self.gpsFlag[3] == true then	
		if self.gpsFlag[4] == true then
			self.Distance[6] = self:LatitudeLongitudeDist(self.Latitude[self.clent_seat[3]],self.Longitude[self.clent_seat[3]],self.Latitude[self.clent_seat[4]],self.Longitude[self.clent_seat[4]])--b与d的距离F
			self.view:showDistance(6,self.Distance[6],self.distance)
		else
			self.view:showDistance(6,false)
		end
	else
		self.view:showDistance(6,false)
	end

	for loop = 1,6 do 
		if self.Distance[loop] == 0 then

		elseif self.Distance[loop] < self.distance then
			self.view:showGipWaring(true)
		end
	end
end

--返回的是m为单位 
function GpsPart:LatitudeLongitudeDist(lon1,lat1,lon2,lat2)
	-- body
	print("lon1,lat1,lon2,lat2 : ",lon1,lat1,lon2,lat2)
	local EARTH_RADIUS = 6378.137
	local rad_lat1 = math.rad(lat1)
	local rad_lat2 = math.rad(lat2)

	local rad_lon1 = math.rad(lon1)
	local rad_lon2 = math.rad(lon2)

    local a = rad_lat1 - rad_lat2
    local b = rad_lon1 - rad_lon2

    local dist = 2*math.asin((math.sqrt(math.pow(math.sin(a/2),2)+math.cos(rad_lat1)*math.cos(rad_lat2)*math.pow(math.sin(b/2),2))))
    dist = dist * EARTH_RADIUS
    dist = math.floor((dist*10000)+0.5)/10
    return dist
end

--将逻辑座位转换为界面座位
function GpsPart:changeSeatToView(seatId) --座位顺时针方向增加 1 - 4
	-- body
	if self.m_pos then
		return (seatId - self.m_pos + 4)%4 + 1
	end
end

function GpsPart:showGpsTip(index,distance)
	-- body
	self.owner:showGpsTip(index,distance)
end

function GpsPart:deactivate()
	if self.view ~= nil then
		self.view:removeSelf()
  		self.view = nil
  	end
end

function GpsPart:Gps_Click(node,touch,event)
	if self.view then
		self.view:Gps_Click(node,touch,event)
	end
end

function GpsPart:getPartId()
	-- body
	return "GpsPart"
end

return GpsPart 
