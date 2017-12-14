local ReadyCardCoordinate = class("ReadyCardCoordinate")
ReadyCardCoordinate.colNum = 17
--上家待摸牌维护坐标
------------------------------------------------------
				-- local poxs = {2.51,8.91,15.74,22.36,28.75,
				-- 34.95,40.13,46.08,51.99,57.95,
				-- 63.52,68.61,73.64,79.04,83.62,
				-- 88.84,93.49}
				-- local poys = {-237.63,-208.49,-180.41,-152.24,-125.42,
				-- -98.37,-71.64,-45.63,-20.32,4.10,
				-- 28.12,51.47,74.49,96.96,117.66,
				-- 138.62,159.16}
ReadyCardCoordinate.handUp_X_17={}
ReadyCardCoordinate.handUp_X_17[1]=2.51
ReadyCardCoordinate.handUp_X_17[2]=8.91
ReadyCardCoordinate.handUp_X_17[3]=15.74
ReadyCardCoordinate.handUp_X_17[4]=22.36
ReadyCardCoordinate.handUp_X_17[5]=28.75
ReadyCardCoordinate.handUp_X_17[6]=34.95
ReadyCardCoordinate.handUp_X_17[7]=40.13
ReadyCardCoordinate.handUp_X_17[8]=46.08
ReadyCardCoordinate.handUp_X_17[9]=51.99
ReadyCardCoordinate.handUp_X_17[10]=57.95
ReadyCardCoordinate.handUp_X_17[11]=63.52
ReadyCardCoordinate.handUp_X_17[12]=68.61
ReadyCardCoordinate.handUp_X_17[13]=73.64
ReadyCardCoordinate.handUp_X_17[14]=79.04
ReadyCardCoordinate.handUp_X_17[15]=83.62
ReadyCardCoordinate.handUp_X_17[16]=88.84
ReadyCardCoordinate.handUp_X_17[17]=93.49

ReadyCardCoordinate.handUp_Y_17={}
ReadyCardCoordinate.handUp_Y_17[1]=-237.63
ReadyCardCoordinate.handUp_Y_17[2]=-208.49
ReadyCardCoordinate.handUp_Y_17[3]=-180.41
ReadyCardCoordinate.handUp_Y_17[4]=-152.24
ReadyCardCoordinate.handUp_Y_17[5]=-125.42
ReadyCardCoordinate.handUp_Y_17[6]=-98.37
ReadyCardCoordinate.handUp_Y_17[7]=-71.64
ReadyCardCoordinate.handUp_Y_17[8]=-45.63
ReadyCardCoordinate.handUp_Y_17[9]=-20.32
ReadyCardCoordinate.handUp_Y_17[10]=4.10
ReadyCardCoordinate.handUp_Y_17[11]=28.12
ReadyCardCoordinate.handUp_Y_17[12]=51.47
ReadyCardCoordinate.handUp_Y_17[13]=74.49
ReadyCardCoordinate.handUp_Y_17[14]=96.96
ReadyCardCoordinate.handUp_Y_17[15]=117.66
ReadyCardCoordinate.handUp_Y_17[16]=138.62
ReadyCardCoordinate.handUp_Y_17[17]=159.16
------------------------------------------------------
----下家待摸牌维护坐标
------------------------------------------------------

-- local poxs = {-1.38,3.22,7.83,12.84,18.07,23.65,28.92,34.47,39.68,45.06,50.60,56.46,62.40,68.53,74.72,80.87,87.06}
-- local poys = {113.24,92.59,71.50,49.15,27.06,3.68,-19.67,-44.30,-68.78,-93.09,-118.60,-145.15,-172.22,-198.93,-226.91,-255.51,-284.61}

ReadyCardCoordinate.handDown_X_17={}
ReadyCardCoordinate.handDown_X_17[1]=-1.38
ReadyCardCoordinate.handDown_X_17[2]=3.22
ReadyCardCoordinate.handDown_X_17[3]=7.83
ReadyCardCoordinate.handDown_X_17[4]=12.84
ReadyCardCoordinate.handDown_X_17[5]=18.07
ReadyCardCoordinate.handDown_X_17[6]=23.65
ReadyCardCoordinate.handDown_X_17[7]=28.92
ReadyCardCoordinate.handDown_X_17[8]=34.47
ReadyCardCoordinate.handDown_X_17[9]=39.68
ReadyCardCoordinate.handDown_X_17[10]=45.06
ReadyCardCoordinate.handDown_X_17[11]=50.60
ReadyCardCoordinate.handDown_X_17[12]=56.46
ReadyCardCoordinate.handDown_X_17[13]=62.40
ReadyCardCoordinate.handDown_X_17[14]=68.53
ReadyCardCoordinate.handDown_X_17[15]=74.72
ReadyCardCoordinate.handDown_X_17[16]=80.87
ReadyCardCoordinate.handDown_X_17[17]=87.06

ReadyCardCoordinate.handDown_Y_17={}
ReadyCardCoordinate.handDown_Y_17[1]=113.24
ReadyCardCoordinate.handDown_Y_17[2]=92.59
ReadyCardCoordinate.handDown_Y_17[3]=71.50
ReadyCardCoordinate.handDown_Y_17[4]=49.15
ReadyCardCoordinate.handDown_Y_17[5]=27.06
ReadyCardCoordinate.handDown_Y_17[6]=3.68
ReadyCardCoordinate.handDown_Y_17[7]=-19.67
ReadyCardCoordinate.handDown_Y_17[8]=-44.30
ReadyCardCoordinate.handDown_Y_17[9]=-68.78
ReadyCardCoordinate.handDown_Y_17[10]=-93.09
ReadyCardCoordinate.handDown_Y_17[11]=-118.60
ReadyCardCoordinate.handDown_Y_17[12]=-145.15
ReadyCardCoordinate.handDown_Y_17[13]=-172.22
ReadyCardCoordinate.handDown_Y_17[14]=-198.93
ReadyCardCoordinate.handDown_Y_17[15]=-226.91
ReadyCardCoordinate.handDown_Y_17[16]=-255.51
ReadyCardCoordinate.handDown_Y_17[17]=-284.61

--从上往下排
function ReadyCardCoordinate:getDownPos(i,totoal)
	local tbPos = {}
	local index = ReadyCardCoordinate.colNum - totoal+ i
	tbPos.x = ReadyCardCoordinate.handDown_X_17[i]
	tbPos.y = ReadyCardCoordinate.handDown_Y_17[i]
	return tbPos
end
--从下往上排
function ReadyCardCoordinate:getUpPos(i,totoal)
	local tbPos = {}
	tbPos.x = ReadyCardCoordinate.handUp_X_17[i]
	tbPos.y = ReadyCardCoordinate.handUp_Y_17[i]
	return tbPos
end

return ReadyCardCoordinate
