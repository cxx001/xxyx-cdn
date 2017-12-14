--潜江麻将规则
RoomConfig.Rule = {
	[1] = { value = 0x01, name = "全新", tex = "quanxin.png", Rule2 = {5}}, --全新
	[2] = { value = 0x02, name = "一赖到底", tex = "yilaidaodi.png" ,Rule2 = {2,3,5,4}},--一赖到底
	[3] = { value = 0x04, name = "多癞", tex = "duolai.png", Rule2 = {5}},--全胡
}

RoomConfig.Rule2 = {
	[0] = { value = 0, 			name = ""},       		--不选择
	[1] = { value = 0x10, 		name = "红中"},   		--红中
	[2] = { value = 0x100, 		name = "四癞喜钱"},   	--四癞杠
	[3] = { value = 0x1000, 	name = "朝天双大胡"},   --朝天双大胡
	[4] = { value = 0x10000,	name = "无癞到底"},
	[5] = { value = 0x100000,	name = "笑提点"}
}

RoomConfig.NO_PIZI_OPT = false
RoomConfig.PIZI_NOTIFY = 0x12000
RoomConfig.PIZI_NOTIFY_AN = 0x13000

RoomConfig.InviteFormat = "正宗潜江麻将,真实防作弊!房号:%d,局数:%d,%s%s,底分%d分,%s支付,战个痛快!" 
RoomConfig.InviteFormatSimple = "潜江麻将,房号:%d,局数:%d,%s%s,底分%d分,%s支付"