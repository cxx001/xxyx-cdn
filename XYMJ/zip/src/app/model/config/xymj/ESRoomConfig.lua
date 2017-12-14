--恩施麻将规则
RoomConfig.Rule = {
	[1] = { value = 0x01, name = "一赖到底", tex = "yilaidaodi.png", Rule2 = {1,2}},  
	[2] = { value = 0x02, name = "一痞二赖", tex = "yipierlai.png" ,Rule2 = {1,2}}, 
	[3] = { value = 0x04, name = "硬麻将", tex = "yingmajiang.png", Rule2 = {1}},
	[4] = { value = 0x08, name = "蒙癞子", tex = "menglaizi.png", Rule2 = {1,2}},
}

RoomConfig.PlayTimes = {
	[1] = {	value = 4, index = 1},
	[2] = {	value = 8, index = 1},
	[3] = {	value = 16, index = 1},
}

RoomConfig.DiZhu = {
	[1] = {value = 1},
	[2] = {value = 2},
	[3] = {value = 3},
	[4] = {value = 5},
}

RoomConfig.PlayType = {
	[1] = {value = 0, name = "房主支付"},
	[2] = {value = 1, name = "AA支付"},
}

RoomConfig.Rule2 = {
	[0] = { value = 0, 			name = ""},       		--不选择
	[1] = { value = 0x2000,		name = "抬庄"},   		--抬庄
	[2] = { value = 0x4000,		name = "杠上炮"},   	--杠上炮 
}

RoomConfig.InviteFormat = "正宗恩施麻将,真实防作弊!房号:%d,局数:%d,%s%s,底分%d分,%s支付,战个痛快!" 
RoomConfig.InviteFormatSimple = "恩施麻将,房号:%d,局数:%d,%s%s,底分%d分,%s支付"

RoomConfig.NO_PIZI_OPT = false
RoomConfig.PIZI_NOTIFY = 0x12000
RoomConfig.PIZI_NOTIFY_AN = 0x13000