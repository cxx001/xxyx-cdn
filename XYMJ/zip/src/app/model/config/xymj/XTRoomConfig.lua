--仙桃麻将规则
RoomConfig.Rule = {
	[1] = { value = 0x01, name = "一癞到底", tex = "yilaidaodi.png"}, --全新
	[2] = { value = 0x02, name = "硬晃", tex = "yinghuang.png"},--一赖到底
	[3] = { value = 0x04, name = "干瞪眼", tex = "gandengyan.png"},--全胡
}

RoomConfig.Rule2 = {
	[0] = { value = 0, 			name = "",    tex = ""},       --不选择
	[1] = { value = 0x10, 		name = "飘癞有奖",  tex = "piaolaiyoujiang.png"},   --红中
}

RoomConfig.NO_PIZI_OPT = true
RoomConfig.PIZI_NOTIFY = 0x12000
RoomConfig.PIZI_NOTIFY_AN = 0x13000