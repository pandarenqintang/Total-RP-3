----------------------------------------------------------------------------------
-- Total RP 3
-- English locale (default locale)
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--
--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--		http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
--      秦唐 好哥哥友情汉化 金色平原欢迎您！
----------------------------------------------------------------------------------

-- Fixed some typos in the English localization - Paul Corlay

local LOCALE_EN = {
	locale = "zhCN",
	localeText = "简体中文",
	localeContent = {

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- GENERAL
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

		GEN_WELCOME_MESSAGE = "感谢使用 Total RP 3 (v %s) ! 玩的开心 !",
		GEN_VERSION = "版本: %s (更新 %s)",

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- REGISTER
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		REG_PLAYER = "角色",
		REG_PLAYER_CHANGE_CONFIRM = "您可能有未保存的数据更改.\n你想改变页面吗?\n|cffff9900任何更改都将丢失.",
		REG_PLAYER_CARACT = "特征",
		REG_PLAYER_NAMESTITLES = "名字与称呼",
		REG_PLAYER_CHARACTERISTICS = "特征",
		REG_PLAYER_REGISTER = "目录信息",
		REG_PLAYER_ICON = "角色图标",
		REG_PLAYER_ICON_TT = "为你的角色选一个图标.",
		REG_PLAYER_TITLE = "称号/头衔",
		REG_PLAYER_TITLE_TT = "角色的头衔就是我们通常说的称号.避免过长头衔.\n\n举例 |c0000ff00适当的头衔 |r:\n|c0000ff00- 女伯爵,\n- 侯爵,\n- 占星师,\n- 贵族,\n- 游学者.\n|r例如 |cffff0000适当的称号|r:\n|cffff0000- 米奈希尔的女伯爵,\n- 暴风城法师塔的占星师,\n- 德莱尼的外交官,\n- 等等.",
		REG_PLAYER_FIRSTNAME = "名",
		REG_PLAYER_FIRSTNAME_TT = "这是你角色的名. 必须的, 如果没有指定，会使用(|cffffff00%s|r) 默认名.\n\n你也可以使用 |c0000ff00昵称 |r!",
		REG_PLAYER_LASTNAME = "姓",
		REG_PLAYER_LASTNAME_TT = "这是你角色的姓.",
		REG_PLAYER_HERE = "设置坐标/位置",
		REG_PLAYER_HERE_TT = "|cffffff00Click|r: 设定到你当前的坐标/位置",
		REG_PLAYER_HERE_HOME_TT = "|cffffff00Click|r: 用你当前的坐标作为你的房子的位置.\n|cffffff00右击|r: 删除你的房子的位置.",
		REG_PLAYER_HERE_HOME_PRE_TT = "现在的房子地图坐标:\n|cff00ff00%s|r.",
		REG_PLAYER_RESIDENCE_SHOW = "住宅坐标/位置",
		REG_PLAYER_RESIDENCE_SHOW_TT = "|cff00ff00%s\n\n|r点击在地图上显示",
		REG_PLAYER_COLOR_CLASS = "职业颜色",
		REG_PLAYER_COLOR_CLASS_TT = "这也决定了名字的颜色.（使用trp3的玩家会才能看到）\n\n",
		REG_PLAYER_COLOR_TT = "|cffffff00Click:|r 选择一种颜色\n|cffffff00Right-click:|r 改变颜色",
		REG_PLAYER_FULLTITLE = "全称",
		REG_PLAYER_FULLTITLE_TT = "这个显示在你的角色的名下面.它可以是一个很长的称呼，也可以是另一个称号.\n应该避免过于冗余，方便人们记住你的信息.",
		REG_PLAYER_RACE = "种族",
		REG_PLAYER_RACE_TT = "这是你的角色的种族.它不需要被限制在可玩的游戏种族中.魔兽争霸和魔兽世界内有很多种族可以使用.",
		REG_PLAYER_BKG = "布置背景",
		REG_PLAYER_BKG_TT = "这会改变你角色的图像背景.",
		REG_PLAYER_CLASS = "职业",
		REG_PLAYER_CLASS_TT = "这是您的角色的自定义类.\n\n|cff00ff00比如 :|r\n骑士长, 消防员, 死灵法师, 游侠, 秘术师 ...",
		REG_PLAYER_AGE = "年龄",
		REG_PLAYER_AGE_TT = "在这里你可以指出你的角色有多老.\n\n有几种方法可以做到这一点:|c0000ff00\n- 要么使用年份（如黑门历）,\n- 或形容词(年轻、成熟、成熟、可敬等).",
		REG_PLAYER_EYE = "眼睛颜色",
		REG_PLAYER_EYE_TT = "在这里，你可以看到你的眼睛的颜色.\n\n记住，即使你的角色的脸总是被隐藏起来，这可能还是值得一提的，以防万一.",
		REG_PLAYER_HEIGHT = "身高",
		REG_PLAYER_HEIGHT_TT = "这是你的角色的身高.\n有几种方法可以做到:|c0000ff00\n- 一个精确的数字: 170 cm, 6'5\" ...\n-  或者简单的高或矮 !",
		REG_PLAYER_WEIGHT = "体型",
		REG_PLAYER_WEIGHT_TT = "这里描述你的体型.\n比如他们可以 |c0000ff00苗条、脂肪和肌肉...|r",
		REG_PLAYER_BIRTHPLACE = "出生地",
		REG_PLAYER_BIRTHPLACE_TT = "在这里你可以指出你角色的出生地. 这可以是一个区域，一个区域，甚至是一个大洲. 你可以决定你想要多精确.\n\n|c00ffff00你可以使用这个按钮来方便地设置你当前的位置为出生地.",
		REG_PLAYER_RESIDENCE = "居住",
		REG_PLAYER_RESIDENCE_TT = "在这里你可以指出你的角色通常生活在哪里. 这可能是他们的个人地址(他们的家)或者是他们可以相遇的地方.\n注意，如果你的角色是一个流浪者，甚至是无家可归者，你需要相应地改变信息.\n\n|c00ffff00你可以使用这个按钮来方便地设置你当前的位置.",
		REG_PLAYER_MSP_MOTTO = "座右铭",
		REG_PLAYER_MSP_HOUSE = "房子的名字",
		REG_PLAYER_MSP_NICK = "昵称",
		REG_PLAYER_TRP2_TRAITS = "面相",
		REG_PLAYER_TRP2_PIERCING = "伤痕",
		REG_PLAYER_TRP2_TATTOO = "刺青",
		REG_PLAYER_PSYCHO = "性格",
		REG_PLAYER_ADD_NEW = "创建新的",
		REG_PLAYER_HISTORY = "经历",
		REG_PLAYER_MORE_INFO = "附加说明",
		REG_PLAYER_PHYSICAL = "外貌",
		REG_PLAYER_NO_CHAR = "没有特征",
		REG_PLAYER_SHOWPSYCHO = "显示人格框架",
		REG_PLAYER_SHOWPSYCHO_TT = "检查你是否想要使用人格描述.\n\n如果你不想用这种方式来表示你的角色的性格, 或者不想被设定束缚，就把这段隐藏.",
		REG_PLAYER_PSYCHO_ADD = "添加一种性格",
		REG_PLAYER_PSYCHO_POINT = "添加一个点",
		REG_PLAYER_PSYCHO_MORE = "添加一个到 \"%s\"",
		REG_PLAYER_PSYCHO_ATTIBUTENAME_TT = "属性名称",
		REG_PLAYER_PSYCHO_RIGHTICON_TT = "设置右翼图标.",
		REG_PLAYER_PSYCHO_LEFTICON_TT = "设置左翼图标.",
		REG_PLAYER_PSYCHO_SOCIAL = "社会特征",
		REG_PLAYER_PSYCHO_PERSONAL = "人格特质",
		REG_PLAYER_PSYCHO_CHAOTIC = "邪恶";
		REG_PLAYER_PSYCHO_Loyal = "正义";
		REG_PLAYER_PSYCHO_Chaste = "善良";
		REG_PLAYER_PSYCHO_Luxurieux = "伪善";
		REG_PLAYER_PSYCHO_Indulgent = "宽容";
		REG_PLAYER_PSYCHO_Rencunier = "报复心强";
		REG_PLAYER_PSYCHO_Genereux = "无私";
		REG_PLAYER_PSYCHO_Egoiste = "自私";
		REG_PLAYER_PSYCHO_Sincere = "诚实的";
		REG_PLAYER_PSYCHO_Trompeur = "欺诈者";
		REG_PLAYER_PSYCHO_Misericordieux = "温柔 ";
		REG_PLAYER_PSYCHO_Cruel = "残忍";
		REG_PLAYER_PSYCHO_Pieux = "感性";
		REG_PLAYER_PSYCHO_Pragmatique = "叛逆";
		REG_PLAYER_PSYCHO_Conciliant = "模范";
		REG_PLAYER_PSYCHO_Rationnel = "理性";
		REG_PLAYER_PSYCHO_Reflechi = "谨慎";
		REG_PLAYER_PSYCHO_Impulsif = "莽撞";
		REG_PLAYER_PSYCHO_Acete = "禁欲主义（斯多葛学派）";
		REG_PLAYER_PSYCHO_Bonvivant = "享乐主义（伊壁鸠鲁主义）";
		REG_PLAYER_PSYCHO_Valeureux = "勇敢";
		REG_PLAYER_PSYCHO_Couard = "懦弱";
		REG_PLAYER_PSYCHO_CUSTOM = "定制性格",
		REG_PLAYER_PSYCHO_CREATENEW = "自建特征",
		REG_PLAYER_LEFTTRAIT = "左倾",
		REG_PLAYER_RIGHTTRAIT = "右倾",
		REG_DELETE_WARNING = "你确定你要删除这个 %s's 描述?\n",
		REG_IGNORE_TOAST = "忽略的特征",
		REG_PLAYER_IGNORE = "忽略相关特征 (%s)",
		REG_PLAYER_IGNORE_WARNING = "你想忽略这些角色吗 ?\n\n|cffff9900%s\n\n|r您可以选择输入下面的原因。这是一份个人笔记，它将作为提醒.",
		REG_PLAYER_SHOWMISC = "展示各种各样的框架",
		REG_PLAYER_SHOWMISC_TT = "检查您是否希望为您的字符显示自定义字段。如果您不想显示自定义字段，请保持该框不受约束，而其他的帧将保持完全隐藏。",
		REG_PLAYER_MISC_ADD = "添加一个额外的字段",
		REG_PLAYER_ABOUT = "关于",
		REG_PLAYER_ABOUTS = "人物卡 %s",
		REG_PLAYER_ABOUT_MUSIC = "音乐主题",
		REG_PLAYER_ABOUT_NOMUSIC = "|cffff9900没有音乐",
		REG_PLAYER_ABOUT_UNMUSIC = "|cffff9900未知音乐",
		REG_PLAYER_ABOUT_MUSIC_SELECT = "选择角色音乐",
		REG_PLAYER_ABOUT_MUSIC_REMOVE = "取消音乐",
		REG_PLAYER_ABOUT_MUSIC_LISTEN = "开始音乐",
		REG_PLAYER_ABOUT_MUSIC_STOP = "停止音乐",
		REG_PLAYER_ABOUT_MUSIC_SELECT2 = "选择音乐",
		REG_PLAYER_ABOUT_T1_YOURTEXT = "您在此处输入的文字",
		REG_PLAYER_ABOUT_HEADER = "页面标签",
		REG_PLAYER_ABOUT_ADD_FRAME = "添加一个框架",
		REG_PLAYER_ABOUT_REMOVE_FRAME = "删除这个框架",
		REG_PLAYER_ABOUT_P = "段落标记",
		REG_PLAYER_ABOUT_TAGS = "格式化工具",
		REG_PLAYER_ABOUT_SOME = "一些文字 ...",
		REG_PLAYER_ABOUT_VOTE_UP = "我喜欢这个内容",
		REG_PLAYER_ABOUT_VOTE_DOWN = "我不喜欢这个内容",
		REG_PLAYER_ABOUT_VOTE_TT = "你的投票完全是匿名的，只有这个玩家才能看到.",
		REG_PLAYER_ABOUT_VOTE_TT2 = "只有这个玩家在线时才可以投票.",
		REG_PLAYER_ABOUT_VOTE_NO = "网上没有任何与此档案相关的人物.\n你想强制在 Total RP 3 投票决定你的投票结果吗 ?",
		REG_PLAYER_ABOUT_VOTE_SENDING = "正在发送你的投票 %s ...",
		REG_PLAYER_ABOUT_VOTE_SENDING_OK = "你的投票已经被送到了 %s !",
		REG_PLAYER_ABOUT_VOTES = "统计资料",
		REG_PLAYER_ABOUT_VOTES_R = "|cff00ff00%s 喜欢这个内容\n|cffff0000%s 不喜欢这个内容",
		REG_PLAYER_ABOUT_EMPTY = "没有说明",
		REG_PLAYER_STYLE_RPSTYLE_SHORT = "RP 风格",
		REG_PLAYER_STYLE_RPSTYLE = "Roleplay 风格",
		REG_PLAYER_STYLE_HIDE = "不显示",
		REG_PLAYER_STYLE_WOWXP = "魔兽世界经验",
		REG_PLAYER_STYLE_FREQ = "RP频率",
		REG_PLAYER_STYLE_FREQ_1 = "所有时间, 不OOC",
		REG_PLAYER_STYLE_FREQ_2 = "大多数时间",
		REG_PLAYER_STYLE_FREQ_3 = "一部分时间",
		REG_PLAYER_STYLE_FREQ_4 = "我是临时演员（临时工）",
		REG_PLAYER_STYLE_FREQ_5 = "大部分时间都在OOC,我不是RP玩家",
		REG_PLAYER_STYLE_PERMI = "角色许可",
		REG_PLAYER_STYLE_ASSIST = "RP扮演游戏帮助",
		REG_PLAYER_STYLE_INJURY = "接受角色受伤",
		REG_PLAYER_STYLE_DEATH = "接受角色死亡",
		REG_PLAYER_STYLE_ROMANCE = "接受角色浪漫史",
		REG_PLAYER_STYLE_BATTLE = "RP战斗",
		REG_PLAYER_STYLE_BATTLE_1 = "PVP",
		REG_PLAYER_STYLE_BATTLE_2 = "TRP3战斗",
		REG_PLAYER_STYLE_BATTLE_3 = "ROLL点战",
		REG_PLAYER_STYLE_BATTLE_4 = "表情战斗",
		REG_PLAYER_STYLE_EMPTY = "没有啥好说的",
		REG_PLAYER_STYLE_GUILD = "公会性质",
		REG_PLAYER_STYLE_GUILD_IC = "角色扮演（RP）公会",
		REG_PLAYER_STYLE_GUILD_OOC = "游戏（OOC）公会",
		REG_PLAYER_ALERT_HEAVY_SMALL = "|cffff0000T你的个人资料的总规模相当大.\n|cffff9900你应该减少它.",
		CO_GENERAL_HEAVY = "警告：文件太多.",
		CO_GENERAL_HEAVY_TT = "当您的文件的总大小超过一个合理的值时，会发出警告.",
-- 这个值是多少 需要测试.
		REG_PLAYER_PEEK = "其他",
		REG_PLAYER_CURRENT = "目前",
		REG_PLAYER_CURRENTOOC = "目前 (OOC)",
		REG_PLAYER_CURRENT_OOC = "这是一个 OOC 信息";
		REG_PLAYER_GLANCE = "第一印象",
		REG_PLAYER_GLANCE_USE = "激活这个位置",
		REG_PLAYER_GLANCE_TITLE = "属性名称",
		REG_PLAYER_GLANCE_UNUSED = "未使用的槽（点）",
		REG_PLAYER_GLANCE_CONFIG = "|cff00ff00\"第一印象\"|r 是一组可以用来定义关于这个角色的重要信息的槽（点）.\n\n可以在槽中使用这些操作:\n|cffffff00单击:|r 配置槽\n|cffffff00双击:|r 隐藏槽\n|cffffff00右击:|r 添加槽\n|cffffff00拖动:|r 移动槽",
		REG_PLAYER_GLANCE_EDITOR = "印象 编辑 : 槽 %s",
		REG_PLAYER_GLANCE_BAR_TARGET = "\"第一印象\" 预设",
		REG_PLAYER_GLANCE_BAR_LOAD_SAVE = "组预设",
		REG_PLAYER_GLANCE_BAR_SAVE = "保存组预设",
		REG_PLAYER_GLANCE_BAR_LOAD = "组预设",
		REG_PLAYER_GLANCE_BAR_EMPTY = "预设名不能是空的.",
		REG_PLAYER_GLANCE_BAR_NAME = "请输入预设名.\n\n|cff00ff00注意:如果该名称已经被另一个组预先设置，那么另一个组将被替换.",
		REG_PLAYER_GLANCE_BAR_SAVED = "组预设 |cff00ff00%s|r 被创建.",
		REG_PLAYER_GLANCE_BAR_DELETED = "组预设 |cffff9900%s|r 被删除.",
		REG_PLAYER_GLANCE_PRESET = "读取一个预设",
		REG_PLAYER_GLANCE_PRESET_SELECT = "选择一个预设.",
		REG_PLAYER_GLANCE_PRESET_SAVE = "将信息保存为预设值.",
		REG_PLAYER_GLANCE_PRESET_SAVE_SMALL = "保存为预设的",
		REG_PLAYER_GLANCE_PRESET_CATEGORY = "预置种类",
		REG_PLAYER_GLANCE_PRESET_NAME = "预设名称",
		REG_PLAYER_GLANCE_PRESET_CREATE = "创建预设",
		REG_PLAYER_GLANCE_PRESET_REMOVE = "删除预设 |cff00ff00%s|r.";
		REG_PLAYER_GLANCE_PRESET_ADD = "创建预设 |cff00ff00%s|r.";
		REG_PLAYER_GLANCE_PRESET_ALERT1 = "你必须进入一个预设的类别.",
		REG_PLAYER_GLANCE_PRESET_GET_CAT = "%s\n\n请输入这个预设的类别名称.",
		REG_PLAYER_TUTO_ABOUT_COMMON = [[|cff00ff00音乐主题:|r
你可以选择一个为你的角色 |cffffff00音乐|r . 设计一个阅读 |cffffff00你人物卡的背景音乐|r.

|cff00ff00人物卡:|r
这是一个创作区域 |cffffff00人物角色的背景文档|r .

|cff00ff00模板:|r
这些个模板相当于给你角色提供了 |cffffff00修改布局和创作可能性|r 请发挥想象力.
|cffff9900只有被选中的模板可以被其他人看到，所以您不需要全部填满.|r
一旦选择了模板，您可以再次打开本教程，以获得关于每个模板的更多帮助.]],
		REG_PLAYER_TUTO_ABOUT_T1 = [[这个模板允许您 |cff00ff00自由地组织您的描述|r.

描述不必局限于您的角色 |cffff9900外貌|r. 可以自由描述他的 |cffff9900背景|r 或有关他的 |cffff9900人品/性格|r.

使用这个模板，您可以使用格式化工具访问几个布局参数，如 |cffffff00文字大小、颜色和对齐|r.
这些工具还允许你插入 |cffffff00图像,图标或链接到外部网站|r.]],
		REG_PLAYER_TUTO_ABOUT_T2 = [[该模板结构更结构化,包含|cff00ff00独立的对话框列表|r.

每一对话框都有一个 |cffffff00图标,背景和文档|r. 注意，您可以在这些对话框中使用格式化工具，比如彩色文字和图标文本标记。

描述不必局限于您的角色 |cffff9900外貌|r. 可以自由的描写他的 |cffff9900人物背景|r 或者 |cffff9900人物个性|r.]],
		REG_PLAYER_TUTO_ABOUT_T3 = [[这个模板被分为三个部分: |cff00ff00外貌, 性格和经历|r.

你不需要把所有的对话框都填满, |cffff9900如果你什么都不填，那栏对话框就不会显示|r.

每一对话框都有一个|cffffff00图标,背景和文档|r. 注意，您可以在这些对话框中使用格式化工具，比如彩色文字和图标文本标记。]],
		REG_PLAYER_TUTO_ABOUT_MISC_1 = [[这个部分提供了一个 |cffffff005 槽|r 您可以描述 |cff00ff00关于您的角色的最重要的信息|r.

这些槽会显示在 |cffffff00"第一印象"|r 当其他人点击你的头像.

|cff00ff00提示:您可以拖动槽来重新排序.|r
这也会显示在 |cffffff00"第一印象"|r!]],
		REG_PLAYER_TUTO_ABOUT_MISC_3 = [[这部分主要是设定 |cffffff00一个标记|r ，可以设定很多关于 |cffffff00你、你的角色以及和他人互动时候的原则立场。|r.]],
		REG_RELATION = "人物关系",
		REG_RELATION_BUTTON_TT = "关系: %s\n|cff00ff00%s\n\n|cffffff00单击以显示可能的操作",
		REG_RELATION_UNFRIENDLY = "不友好/善的",
		REG_RELATION_NONE = "无",
		REG_RELATION_NEUTRAL = "中立的",
		REG_RELATION_BUSINESS = "商业上的",
		REG_RELATION_FRIEND = "友好/善的",
		REG_RELATION_LOVE = "喜爱的",
		REG_RELATION_FAMILY = "家人",
		REG_RELATION_UNFRIENDLY_TT = "%s 明显不喜欢 %s.",
		REG_RELATION_NONE_TT = "%s 不知道 %s.",
		REG_RELATION_NEUTRAL_TT = "%s 没有什么特别的感觉 %s.",
		REG_RELATION_BUSINESS_TT = "%s 和 %s 商业合作关系.",
		REG_RELATION_FRIEND_TT = "%s 认为 %s 是朋友.",
		REG_RELATION_LOVE_TT = "%s 热恋中 %s !",
		REG_RELATION_FAMILY_TT = "%s 血浓于水 %s.",
		REG_RELATION_TARGET = "|cffffff00Click: |r改变关系",
		REG_REGISTER = "玩家目录",
		REG_REGISTER_CHAR_LIST = "角色列表",
		REG_TT_GUILD_IC = "RP 成员",
		REG_TT_GUILD_OOC = "OOC 成员",
		REG_TT_LEVEL = "Level %s %s",
		REG_TT_REALM = "范围: |cffff9900%s",
		REG_TT_GUILD = "%s 属于 |cffff9900%s",
		REG_TT_TARGET = "目标: |cffff9900%s",
		REG_TT_NOTIF = "未读的描述",
		REG_TT_IGNORED = "< 角色被忽略 >",
		REG_TT_IGNORED_OWNER = "< 玩家被忽略 >",
		REG_LIST_CHAR_TITLE = "角色列表",
		REG_LIST_CHAR_SEL = "选择一个角色",
		REG_LIST_CHAR_TT = "点击页面显示",
		REG_LIST_CHAR_TT_RELATION = "关系:\n|cff00ff00%s",
		REG_LIST_CHAR_TT_CHAR = "绑定游戏里的角色(s):",
		REG_LIST_CHAR_TT_CHAR_NO = "没有绑定任何角色",
		REG_LIST_CHAR_TT_DATE = "上一次看到的日期: |cff00ff00%s|r\n上一次看到的位置: |cff00ff00%s|r",
		REG_LIST_CHAR_TT_GLANCE = "第一印象",
		REG_LIST_CHAR_TT_NEW_ABOUT = "未读的描述",
		REG_LIST_CHAR_TT_IGNORE = "忽略的角色(s)",
		REG_LIST_CHAR_FILTER = "角色: %s / %s",
		REG_LIST_CHAR_EMPTY = "没有角色",
		REG_LIST_CHAR_EMPTY2 = "没有匹配的角色",
		REG_LIST_CHAR_IGNORED = "忽略",
		REG_LIST_IGNORE_TITLE = "忽略列表",
		REG_LIST_IGNORE_EMPTY = "没有忽略字符",
		REG_LIST_IGNORE_TT = "理由:\n|cff00ff00%s\n\n|cffffff00单击从忽略列表中删除",
		REG_LIST_PETS_FILTER = "同伴: %s / %s",
		REG_LIST_PETS_TITLE = "同伴列表",
		REG_LIST_PETS_EMPTY = "没有同伴",
		REG_LIST_PETS_EMPTY2 = "没有匹配的同伴",
		REG_LIST_PETS_TOOLTIP = "已经被发现",
		REG_LIST_PETS_TOOLTIP2 = "已经被发现",
		REG_LIST_PET_NAME = "同伴的名字",
		REG_LIST_PET_TYPE = "同伴的种类",
		REG_LIST_PET_MASTER = "主人名字",
		REG_LIST_FILTERS = "过滤",
		REG_LIST_FILTERS_TT = "|cffffff00左击:|r 应用过滤器\n|cffffff00右击:|r 清除过滤器",
		REG_LIST_REALMONLY = "仅限范围之内",
		REG_LIST_GUILD = "角色公会",
		REG_LIST_NAME = "角色名",
		REG_LIST_FLAGS = "标记",
		REG_LIST_ADDON = "档案种类",
		REG_LIST_ACTIONS_PURGE = "清除注册",
		REG_LIST_ACTIONS_PURGE_ALL = "删除所有档案",
		REG_LIST_ACTIONS_PURGE_ALL_COMP_C = "这将删除目录中所有同伴.\n\n|cff00ff00%s 同伴.",
		REG_LIST_ACTIONS_PURGE_ALL_C = "这将从目录中删除所有档案和角色链接.\n\n|cff00ff00%s .",
		REG_LIST_ACTIONS_PURGE_TIME = "超过一个月没见的档案",
		REG_LIST_ACTIONS_PURGE_TIME_C = "这个清除将移除所有一个月未见的档案\n\n|cff00ff00%s",
		REG_LIST_ACTIONS_PURGE_UNLINKED = "配置文件和角色不匹配.",
		REG_LIST_ACTIONS_PURGE_UNLINKED_C = "这个清除将删除所有没有绑定到魔兽世界的角色档案.\n\n|cff00ff00%s",
		REG_LIST_ACTIONS_PURGE_IGNORE = "忽略角色的配置文件",
		REG_LIST_ACTIONS_PURGE_IGNORE_C = "这将清除所有被忽略的魔兽世界的角色档案.\n\n|cff00ff00%s",
		REG_LIST_ACTIONS_PURGE_EMPTY = "没有配置文件被清除.",
		REG_LIST_ACTIONS_PURGE_COUNT = "%s 配置文件将被删除.",
		REG_LIST_ACTIONS_MASS = "对 %s 选定配置文件的操作",
		REG_LIST_ACTIONS_MASS_REMOVE = "删除配置文件",
		REG_LIST_ACTIONS_MASS_REMOVE_C = "该操作将删除 |cff00ff00%s 选定的配置文件|r.",
		REG_LIST_ACTIONS_MASS_IGNORE = "忽略角色",
		REG_LIST_ACTIONS_MASS_IGNORE_C = [[该操作将把 |cff00ff00%s 角色|r 添加到忽略列表中.

您可以选择输入下面的原因。这是一份个人笔记，它将作为一个提醒.]],
		REG_LIST_CHAR_TUTO_ACTIONS = "本专栏允许您选择多个角色，并对所有这些角色执行操作.",
		REG_LIST_CHAR_TUTO_LIST = [[第一个列显示角色的名称.

第二列显示了其他玩家角色与当前你的角色之间的关系.

最后一列是各种标记. (忽略的 ..等等.)]],
		REG_LIST_CHAR_TUTO_FILTER = [[你可以在这搜索.

这将对 |cff00ff00姓名搜索|r 包括已知游戏角色的全称 (姓 + 名) .

这将对 |cff00ff00公会搜索|r 包括已知游戏角色的公会名.

这将对 |cff00ff00范围搜索|r 包括已知游戏角色符合关键字的范围之内进行搜索.]],
		REG_LIST_NOTIF_ADD = "新档案被发现 |cff00ff00%s",
		REG_LIST_NOTIF_ADD_CONFIG = "新档案被发现",
		REG_LIST_NOTIF_ADD_NOT = "这个档案已经不存在了.",
		REG_COMPANION_LINKED = "同伴 %s 现在与配置文件 %s.联系在一起",
		REG_COMPANION = "同伴",
		REG_COMPANIONS = "同伴",
		REG_COMPANION_BOUNDS = "绑定",
		REG_COMPANION_TARGET_NO = "你的目标不是一个有效的宠物，小宠物，狗狗，法师元素或者一个重命名的战斗宠物.",
		REG_COMPANION_BOUND_TO = "绑定到 ...",
		REG_COMPANION_UNBOUND = "未绑定 ...",
		REG_COMPANION_LINKED_NO = "同伴 %s 不再与任何概要文件相关联.",
		REG_COMPANION_BOUND_TO_TARGET = "目标",
		REG_COMPANION_BROWSER_BATTLE = "浏览战斗宠物",
		REG_COMPANION_BROWSER_MOUNT = "坐骑浏览",
		REG_COMPANION_PROFILES = "同伴配置文件",
		REG_COMPANION_TF_PROFILE = "同伴资料",
		REG_COMPANION_TF_PROFILE_MOUNT = "坐骑资料",
		REG_COMPANION_TF_NO = "没有资料",
		REG_COMPANION_TF_CREATE = "创建一个档案",
		REG_COMPANION_TF_UNBOUND = "从配置文件分离",
		REG_COMPANION_TF_BOUND_TO = "选择一个档案",
		REG_COMPANION_TF_OPEN = "打开页面",
		REG_COMPANION_TF_OWNER = "所有者: %s",
		REG_COMPANION_INFO = "信息",
		REG_COMPANION_NAME = "名字",
		REG_COMPANION_TITLE = "标题",
		REG_COMPANION_NAME_COLOR = "名字颜色",
		REG_MSP_ALERT = [[|cffff0000警告

勾选玛丽苏协议MSP以后不能使用其他插件, 这会造成冲突.此RPUI协议可以使一些配置文件（如眼睛颜色，身高体重等）可以用其他插件打开(其他插件指Total RP 2, XRP, MyRoleplay, FlagRSP, 等等.）|r

当前装载: |cff00ff00%s

|cffff9900Trp3默认禁止玛丽苏协议MSP.|r

如果你无视这个警告继续使用MSP，可以在Trp3设置里->勾选玛丽苏协议MSP协议模块]],
		REG_COMPANION_PAGE_TUTO_C_1 = "查阅",
		REG_COMPANION_PAGE_TUTO_E_1 = "这是 |cff00ff00你同伴的主要信息|r.\n\n所有这些信息将会出现在 |cffff9900同伴工具栏上|r.",
		REG_COMPANION_PAGE_TUTO_E_2 = [[这是 |cff00ff00你同伴的描述|r.

这不限于 |cffff9900外貌描述|r.可以随意描述它的 |cffff9900背景|r 或者相关 |cffff9900性格|r.

有很多自定义描述的方法。
你可以讲述一个关于它的 |cffffff00故事|r . 你也可以介绍它的信息，如 |cffffff00大小, 颜色和阵营|r.
你可以在描述中加入 |cffffff00图片，图标或者外部网页链接|r.]],

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- CONFIGURATION
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

		CO_CONFIGURATION = "设置",
		CO_GENERAL = "常规设置",
		CO_GENERAL_CHANGELOCALE_ALERT = "想要重新加载改变语言吗 %s 现在 ?\n\n如果不是, 语言将会在下次加载的时候变更.",
		CO_GENERAL_LOCALE = "插件语言环境",
		CO_GENERAL_COM = " 沟通",
		CO_GENERAL_BROADCAST = "使用广播频道",
		CO_GENERAL_BROADCAST_TT = "频道用在很多地方. 禁用它将使所有的功能失效, 比如地图上的位置，播放本地声音，藏宝箱和指示牌...",
		CO_GENERAL_BROADCAST_C = "广播频道名",
		CO_GENERAL_MISC = "其他",
		CO_GENERAL_TT_SIZE = "信息提示文本大小",
		CO_GENERAL_NEW_VERSION = "更新提醒",
		CO_GENERAL_NEW_VERSION_TT = "当有新版本可用时，请发出警告.",
		CO_GENERAL_UI_SOUNDS = "UI 声音",
		CO_GENERAL_UI_SOUNDS_TT = "激活用户界面声音(打开窗口，切换选项卡，点击按钮).",
		CO_GENERAL_UI_ANIMATIONS = "UI 动画",
		CO_GENERAL_UI_ANIMATIONS_TT = "激活界面动画.",
		CO_TOOLTIP = "工具设置",
		CO_TOOLTIP_USE = "使用字符/同伴工具提示",
		CO_TOOLTIP_COMBAT = "战斗时隐藏",
        CO_TOOLTIP_COLOR = "显示自定义颜色",
        CO_TOOLTIP_CONTRAST = "增加颜色对比",
        CO_TOOLTIP_CONTRAST_TT = "启用这个选项允许Total RP 3修改自定义颜色，使文本在颜色太暗时更易读。",
        CO_TOOLTIP_CROP_TEXT = "不合理的长文本",
        CO_TOOLTIP_CROP_TEXT_TT = [[限制工具提示中每个字段可以显示的字符数量量，以防止不合理的长文本和可能的布局问题。

|cfffff569限制细节:
名字: 100 字符
标题: 150 字符
种族:  50 字符
职业:  50 字符|r]],
		CO_TOOLTIP_CHARACTER = "角色工具栏",
		CO_TOOLTIP_ANCHORED = "固定架",
		CO_TOOLTIP_ANCHOR = "固定点/锚点",
		CO_TOOLTIP_HIDE_ORIGINAL = "隐藏原始工具提示",
		CO_TOOLTIP_MAINSIZE = "主题的字体大小",
		CO_TOOLTIP_SUBSIZE = "二级字体大小",
		CO_TOOLTIP_TERSIZE = "三级字体大小",
		CO_TOOLTIP_SPACING = "显示间距",
		CO_TOOLTIP_SPACING_TT = "MyRoleplay 工具栏风格，使显示间距高亮.",
		CO_TOOLTIP_NO_FADE_OUT = "立即隐藏而不是衰减",
		CO_TOOLTIP_PETS = "同伴工具栏",
		CO_TOOLTIP_OWNER = "显示所有者",
		CO_TOOLTIP_PETS_INFO = "显示所有者信息",
		CO_TOOLTIP_COMMON = "普通设置",
		CO_TOOLTIP_ICONS = "显示图标",
		CO_TOOLTIP_FT = "显示完整标题",
		CO_TOOLTIP_RACE = "显示种族, 职业和等级",
		CO_TOOLTIP_REALM = "显示国家",
		CO_TOOLTIP_GUILD = "显示公会信息",
		CO_TOOLTIP_TARGET = "显示目标",
		CO_TOOLTIP_TITLE = "显示标题",
		CO_TOOLTIP_CLIENT = "显示委托/人",
		CO_TOOLTIP_NOTIF = "显示通告",
		CO_TOOLTIP_NOTIF_TT = "这些通告和客户端版本， 未读描述标签和'第一印象'标签显示在一起.",
		CO_TOOLTIP_RELATION = "显示关系颜色",
		CO_TOOLTIP_RELATION_TT = "设置一个颜色来表示角色间的关系.",
		CO_TOOLTIP_CURRENT = "显示 \"当前\" 的信息",
		CO_TOOLTIP_CURRENT_SIZE = "最大 \"当前\" 信息长度",
		CO_TOOLTIP_PROFILE_ONLY = "只有当前目标有描述才会使用",
		CO_TOOLTIP_IN_CHARACTER_ONLY = "OOC状态隐藏描述",
		CO_REGISTER = "登记设置",
		CO_REGISTER_ABOUT_VOTE = "使用投票系统",
		CO_REGISTER_ABOUT_VOTE_TT = "支持投票系统，允许你对其他人的描述进行投票(“喜欢”或“不喜欢”)，并允许他们对你做同样的事情。",
		CO_REGISTER_AUTO_ADD = "自动添加新玩家",
		CO_REGISTER_AUTO_ADD_TT = [[自动添加你遇到的新玩家.

|cffff0000注意:禁用此选项将阻止您从尚未遇到的玩家获得任何新的配置文件！如果你不想收到其他玩家的新资料，只需要更新你已经看过的玩家，就可以使用这个选项。]],
		CO_REGISTER_AUTO_PURGE = "自动删除玩家目录",
		CO_REGISTER_AUTO_PURGE_TT = "自动从目录中删除你在某个时间没有登陆过的角色。您可以在删除之前选择延迟\n\n|cff00ff00请注意，与您的一个角色的关系的概要文件永远不会被清除.\n\n|cffff9900但这有一个bug，当它到达某个特定的值时，它会丢失所有被保存的数据。我们强烈建议保持这个系统以免整体失效。",
		CO_REGISTER_AUTO_PURGE_0 = "禁用自动删除",
		CO_REGISTER_AUTO_PURGE_1 = "在 %s 天后删除",
		CO_MODULES = "模块状态",
		CO_MODULES_VERSION = "版本: %s",
		CO_MODULES_ID = "模块 ID: %s",
		CO_MODULES_STATUS = "状态: %s",
		CO_MODULES_STATUS_0 = "缺少的依赖关系",
		CO_MODULES_STATUS_1 = "已载入",
		CO_MODULES_STATUS_2 = "禁用",
		CO_MODULES_STATUS_3 = "Total RP 3 需要更新",
		CO_MODULES_STATUS_4 = "初始化错误",
		CO_MODULES_STATUS_5 = "在启动时的错误",
		CO_MODULES_TT_NONE = "没有依赖关系";
		CO_MODULES_TT_DEPS = "依赖关系";
		CO_MODULES_TT_TRP = "%s Total RP 3 版本 %s 最小值.|r",
		CO_MODULES_TT_DEP = "\n%s- %s (版本 %s)|r",
		CO_MODULES_TT_ERROR = "\n\n|cffff0000错误:|r\n%s";
		CO_MODULES_TUTO = [[模块是独立的可以启用或禁用.

可能的状态:
|cff00ff00加载:|r 模块启用并加载.
|cff999999关闭:|r 模块已关闭.
|cffff9900缺少的依赖关系:|r 一些依赖项没有加载.
|cffff9900TRP 需要更新:|r 这个模块需要一个更近的版本 TRP3.
|cffff0000初始化或启动时的错误:|r 模块加载顺序失败。这个模块很可能会产生错误！
|cffff9900当禁用模块时，需要重新加载UI.]],
		CO_MODULES_SHOWERROR = "显示错误",
		CO_MODULES_DISABLE = "禁用 模块",
		CO_MODULES_ENABLE = "启用 模块",
		CO_TOOLBAR = "框架设置",
		CO_TOOLBAR_CONTENT = "工具栏设置",
		CO_TOOLBAR_ICON_SIZE = "图标设置",
		CO_TOOLBAR_MAX = "每一行最多图标",
		CO_TOOLBAR_MAX_TT = "设置为1如果你想垂直地显示工具条 !",
		CO_TOOLBAR_CONTENT_CAPE = "披风开关",
		CO_TOOLBAR_CONTENT_HELMET = "头盔开关",
		CO_TOOLBAR_CONTENT_STATUS = "玩家状态 (AFK/DND)",
		CO_TOOLBAR_CONTENT_RPSTATUS = "角色状态 (IC/OOC)",
		CO_TOOLBAR_SHOW_ON_LOGIN = "在登录时显示工具栏",
		CO_TOOLBAR_SHOW_ON_LOGIN_HELP = "如果您不想在登录时显示工具栏，您可以禁用该选项.",
		CO_TARGETFRAME = "目标框架设置",
		CO_TARGETFRAME_USE = "显示条件",
		CO_TARGETFRAME_USE_TT = "确定目标帧在哪些条件下应该显示在目标选择上.",
		CO_TARGETFRAME_USE_1 = "总是",
		CO_TARGETFRAME_USE_2 = "只有当在 IC",
		CO_TARGETFRAME_USE_3 = "从不 (无效的)",
		CO_TARGETFRAME_ICON_SIZE = "图标尺寸",
		CO_MINIMAP_BUTTON = "小地图按钮",
		CO_MINIMAP_BUTTON_SHOW_TITLE = "显示小地图按钮",
		CO_MINIMAP_BUTTON_SHOW_HELP = [[如果你正在使用另一个插件来显示Total RP 3的小地图按钮 (FuBar, Titan, Bazooka) 您可以从小地图上删除按钮。
|cff00ff00Reminder :你可以打开 Total RP 3 使用命令 /trp3 switch main|r]],
		CO_MINIMAP_BUTTON_FRAME = "框架锚定",
		CO_MINIMAP_BUTTON_RESET = "复位位置",
		CO_MINIMAP_BUTTON_RESET_BUTTON = "重置",
		CO_MAP_BUTTON = "地图搜索按钮",
		CO_MAP_BUTTON_POS = "搜索按钮在地图上位置",
		CO_ANCHOR_TOP = "顶部",
		CO_ANCHOR_TOP_LEFT = "左上角",
		CO_ANCHOR_TOP_RIGHT = "右上角",
		CO_ANCHOR_BOTTOM = "底部",
		CO_ANCHOR_BOTTOM_LEFT = "左下角",
		CO_ANCHOR_BOTTOM_RIGHT = "右下角",
		CO_ANCHOR_LEFT = "左",
		CO_ANCHOR_RIGHT = "右",
		CO_ANCHOR_CURSOR = "在光标处显示",
		CO_CHAT = "聊天设置",
		CO_CHAT_MAIN = "聊天主设置",
		CO_CHAT_MAIN_NAMING = "命名方法",
		CO_CHAT_MAIN_NAMING_1 = "使用原名",
		CO_CHAT_MAIN_NAMING_2 = "使用自定义名称",
		CO_CHAT_MAIN_NAMING_3 = "名 + 姓",
		CO_CHAT_MAIN_NAMING_4 = "简称/代号 + 名 + 名",
		CO_CHAT_REMOVE_REALM = "从域中移除角色",
        CO_CHAT_INSERT_FULL_RP_NAME = "插入 RP 名 使用 shift-click",
        CO_CHAT_INSERT_FULL_RP_NAME_TT = [[插入一个完整的 RP 角色名字当 SHIFT-click 他们聊天窗口的名字.

(当启用该选项时，您可以在需要缺省行为时单击名称，并插入角色名称而不是完整的RP姓名)]],
		CO_CHAT_MAIN_COLOR = "名字使用自定义颜色",
		CO_CHAT_INCREASE_CONTRAST = "增加颜色对比",
		CO_CHAT_USE_ICONS = "显示玩家图标",
		CO_CHAT_USE = "在频道中显示",
		CO_CHAT_USE_SAY = "在频道路说",
		CO_CHAT_MAIN_NPC = "NPC 说话检测",
		CO_CHAT_MAIN_NPC_USE = "使用 NPC 说话检测",
		CO_CHAT_MAIN_NPC_PREFIX = "NPC 说话检测模式",
		CO_CHAT_MAIN_NPC_PREFIX_TT = "如果聊天时候使用白字，表情，公会，团队频道用这个前缀开头聊天, 它将被解释为NPC聊天.\n\n|cff00ff00默认情况下 : \"|| \"\n(没有 \" 人名后面的空格)",
		CO_CHAT_MAIN_EMOTE = "表情检测",
		CO_CHAT_MAIN_EMOTE_USE = "使用表情检测",
		CO_CHAT_MAIN_EMOTE_PATTERN = "表情检测模式",
		CO_CHAT_MAIN_OOC = "OOC 监测",
		CO_CHAT_MAIN_OOC_USE = "开启OOC监测",
		CO_CHAT_MAIN_OOC_PATTERN = "OOC 监测方式",
		CO_CHAT_MAIN_OOC_COLOR = "OOC 颜色",
		CO_CHAT_MAIN_EMOTE_YELL = "不允许喊叫表情",
		CO_CHAT_MAIN_EMOTE_YELL_TT = "不在喊叫时显示*表情*或<表情>",
		CO_GLANCE_MAIN = "\"第一印象\" 条",
		CO_GLANCE_RESET_TT = "将按钮位复位到框架的左下角.",
		CO_GLANCE_LOCK = "锁定按钮",
		CO_GLANCE_LOCK_TT = "防止被拖拽",
		CO_GLANCE_PRESET_TRP2 = "使用 Total RP 2 风格的位置",
		CO_GLANCE_PRESET_TRP2_BUTTON = "使用",
		CO_GLANCE_PRESET_TRP2_HELP = "在TRP2风格中设置栏的快捷方式:在目标帧的右边.",
		CO_GLANCE_PRESET_TRP3 = "使用总RP 3样式的位置",
		CO_GLANCE_PRESET_TRP3_HELP = "在TRP3风格中设置栏的快捷方式:在TRP3目标框架的底部.",
		CO_GLANCE_TT_ANCHOR = "工具提示锚点",
		CO_MSP = "玛丽苏的协议（RP插件兼容性协议）",
		CO_MSP_T3 = "只能使用第三模板",
		CO_MSP_T3_TT = "遵循了玛丽苏协议，\"人物卡\" 模板只能使用三个模板式样.一些人物卡配置文件可以用其他RP插件打开（但是这些插件不能共存）",
		CO_WIM = "|cffff9900耳语频道被禁用.",
		CO_WIM_TT = "你正使用 |cff00ff00WIM|r, 为了兼容性目的，对耳语频道被禁用",
		CO_LOCATION = "定位设置",
		CO_LOCATION_ACTIVATE = "启用角色定位",
		CO_LOCATION_ACTIVATE_TT = "启用角色定位系统，允许您在世界地图上扫描其他RP玩家，并允许他们找到您。",
		CO_LOCATION_DISABLE_OOC = "当OOC时，禁用角色位置",
		CO_LOCATION_DISABLE_OOC_TT = "当您将RP状态设置为OOC时，您将不会对来自其他玩家的位置请求作出响应。",
		CO_LOCATION_DISABLE_PVP = "PVP状态时，禁用角色位置",
		CO_LOCATION_DISABLE_PVP_TT = "当你在PvP时，你不会对来自其他玩家的位置请求作出回应.\n\n这选项在PvP领域特别有用，在PvP领域，来自其他阵营的玩家可以滥用位置系统来跟踪你.",
		CO_SANITIZER = "传入的概要文件",
		CO_SANITIZER_TT = "当TRP不允许它(颜色，图像……)时，从进入的概要文件中删除转义序列。.",

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- TOOLBAR AND UI BUTTONS
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

		TB_TOOLBAR = "TRP3工具栏",
		TB_SWITCH_TOOLBAR = "打开工具栏",
		TB_SWITCH_CAPE_ON = "披风: |cff00ff00显示",
		TB_SWITCH_CAPE_OFF = "披风: |cffff0000隐藏",
		TB_SWITCH_CAPE_1 = "显示披风",
		TB_SWITCH_CAPE_2 = "隐藏披风",
		TB_SWITCH_HELM_ON = "头盔: |cff00ff00显示",
		TB_SWITCH_HELM_OFF = "头盔: |cffff0000隐藏",
		TB_SWITCH_HELM_1 = "显示头盔",
		TB_SWITCH_HELM_2 = "隐藏头盔",
		TB_GO_TO_MODE = "切换到 %s 模式",
		TB_NORMAL_MODE = "在线",
		TB_DND_MODE = "请勿打扰",
		TB_AFK_MODE = "离线",
		TB_STATUS = "玩家",
		TB_RPSTATUS_ON = "角色: |cff00ff00RP中",
		TB_RPSTATUS_OFF = "角色: |cffff0000OOC中",
		TB_RPSTATUS_TO_ON = "进入 |cff00ff00RP状态",
		TB_RPSTATUS_TO_OFF = "进入 |cffff0000OOC状态",
		TB_SWITCH_PROFILE = "切换到另一个配置文件",
		TF_OPEN_CHARACTER = "显示角色页面",
		TF_OPEN_COMPANION = "显示同伴页面",
		TF_OPEN_MOUNT = "显示坐骑页面",
		TF_PLAY_THEME = "播放角色主题",
		TF_PLAY_THEME_TT = "|cffffff00左击:|r 播放 |cff00ff00%s\n|cffffff00右击:|r 停止 主题",
		TF_IGNORE = "忽略玩家",
		TF_IGNORE_TT = "|cffffff00点击:|r 忽略角色",
		TF_IGNORE_CONFIRM = "你确定要忽略这个ID ?\n\n|cffffff00%s|r\n\n|cffff7700你可以进步一写下忽略原因，这是一个私人的笔记，它不会被别人看到，它会作为一个提醒",
		TF_IGNORE_NO_REASON = "没有理由",
		TB_LANGUAGE = "语言",
		TB_LANGUAGES_TT = "改变语言",

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- PROFILES
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


		PR_PROFILEMANAGER_TITLE = "所有角色档案",
		PR_PROFILEMANAGER_DELETE_WARNING = "您确定要删除配置文件 %s?\n此操作无法撤销，所有与此概要文件相关的TRP3信息(角色信息、玩家目录、任务日志、应用状态)将被销毁。!",
		PR_PROFILE = "个人档案",
		PR_PROFILES = "个人档案",
		PR_PROFILE_CREATED = "档案 %s 建立.",
		PR_CREATE_PROFILE = "创建一个卡",
		PR_PROFILE_DELETED = "档案 %s 删除.",
		PR_PROFILE_HELP = "个人档案包含所有的 |cffffff00\"角色\"|r 信息 |cff00ff00角色扮演的人物卡|r.\n\n对应 |cffffff00\"魔兽账号角色\"|r 可以一次绑定一个人物卡，也可以在需要的时候一个账号角色切换多个人物卡（换皮）.\n\n你通常的 |cffffff00\"魔兽账号角色\"|r 一一对应 |cff00ff00人物卡|r 关系!",
		PR_PROFILE_DETAIL = "人物卡绑定当前魔兽账号角色",
		PR_DELETE_PROFILE = "删除同伴卡",
		PR_DUPLICATE_PROFILE = "创建卡副本",
		PR_UNUSED_PROFILE = "人物卡没有绑定任何魔兽账号角色.",
		PR_PROFILE_LOADED = "资料 %s 已载入.",
		PR_PROFILEMANAGER_CREATE_POPUP = "为新卡建个名字.\n名字不能为空.",
		PR_PROFILEMANAGER_DUPP_POPUP = "为新卡建个名字.\n名字不能为空.\n\n这个副本不会改变角色设置 %s.",
		PR_PROFILEMANAGER_EDIT_POPUP = "为新卡建个名字 %s.\n名字不能为空\n\n这个副本不会改变角色和其他玩家角色的人物关系.",
		PR_PROFILEMANAGER_ALREADY_IN_USE = "这个同伴卡名字 %s 无效.",
		PR_PROFILEMANAGER_COUNT = "%s 魔兽账号角色绑定人物卡.",
		PR_PROFILEMANAGER_ACTIONS = "动作",
		PR_PROFILEMANAGER_SWITCH = "选择资料",
		PR_PROFILEMANAGER_RENAME = "重命名资料",
		PR_PROFILEMANAGER_CURRENT = "配置资料",
		PR_CO_PROFILEMANAGER_TITLE = "同伴档案",
		PR_CO_PROFILE_HELP = [[一个同伴卡包括 |cffffff00"宠物"|r 作为 |cff00ff00扮演的角色|r.

同伴卡可以绑定到:
- 一只战斗宠物 |cffff9900(只有当它已经被命名)|r
- 一个猎人的宠物
- 一个术士的恶魔
- 一个法师元素
- 一个死亡骑士食尸鬼 |cffff9900(见下文)|r

就像人物卡一样 |cff00ff00同伴卡|r 可以绑定 |cffffff00随从|r, 和 |cffffff00宠物|r 轻松的从一个卡切换到另一个卡.

|cffff9900Ghouls:|r 食尸鬼的话每次召唤都要重新绑卡……]],
		PR_CO_PROFILE_HELP2 = [[单击这里创建新的同伴卡.

|cff00ff00绑定随从 (猎人宠物,水元素 ...), 召唤宠物, 选中他们并且绑定到现有的同伴卡 (或者创建一个).|r]],
		PR_CO_MASTERS = "主人",
		PR_CO_EMPTY = "没有同伴卡",
		PR_CO_NEW_PROFILE = "新建同伴卡",
		PR_CO_COUNT = "%s 宠物/坐骑绑定到同伴卡.",
		PR_CO_UNUSED_PROFILE = "这同伴卡没有绑定任何宠物或者坐骑.",
		PR_CO_PROFILE_DETAIL = "这同伴卡绑定到",
		PR_CO_PROFILEMANAGER_DELETE_WARNING = "你确定你要删除的同伴卡 %s?\n无法恢复和TRP3与这个卡有关所有信息将被摧毁!!",
		PR_CO_PROFILEMANAGER_DUPP_POPUP = "请输入新的同伴名称.\n名称不能为空.\n\n这个名字不会改变宠物/坐骑的资料 %s.",
		PR_CO_PROFILEMANAGER_EDIT_POPUP = "请输入新的同伴名称 %s.\名称不能为空.\n\n这个名字不会改变宠物/坐骑与其他的关系",
		PR_CO_WARNING_RENAME = "|cffff0000警告:|r 强烈建议你重命名你的宠物之前连接到一个同伴卡.\n\n链接吗 ?",
		PR_CO_PET = "宠物",
		PR_CO_BATTLE = "战斗宠物",
		PR_CO_MOUNT = "坐骑",
		PR_IMPORT_CHAR_TAB = "人物输入",
		PR_IMPORT_PETS_TAB = "同伴输入",
		PR_IMPORT_IMPORT_ALL = "输入所有",
		PR_IMPORT_WILL_BE_IMPORTED = "将导入",
		PR_IMPORT_EMPTY = "没有可输入的资料",
		PR_PROFILE_MANAGEMENT_TITLE = "资料管理",
		PR_EXPORT_IMPORT_TITLE = "输出/输入资料",
		PR_EXPORT_IMPORT_HELP = [[您可以导出和导入配置文件使用下拉菜单中的选项.

使用  |cffffff00输出资料|r 选择生成包含概要文件序列化数据的一大块文本。您可以使用control-c(或Mac上的命令-c)复制文本，并将其粘贴到其他地方作为备份。(|cffff0000请注意，一些高级的文本编辑工具，如Microsoft Word，将重新格式化特殊的字符串，例如引号，改变数据。使用像记事本这样的简单的文本编辑工具|r)

使用 |cffffff00输入资料|r 将之前导出的数据粘贴到现有的概要文件中. 这个概要文件中的现有数据将被您所粘贴的数据所替代。您不能直接将数据导入您当前选择的概要文件。]],
		PR_EXPORT_PROFILE = "输出资料",
		PR_IMPORT_PROFILE = "输入资料",
		PR_EXPORT_NAME = "资料 %s (大小 %0.2f kB)",
		PR_EXPORT_TOO_LARGE = "这个配置文件太大，不能导出.\n\n配置文件的: %0.2f kB\n最大: 20 kB",
		PR_IMPORT_PROFILE_TT = "在这里粘贴一个资料",
		PR_IMPORT = "输入",
		PR_PROFILEMANAGER_IMPORT_WARNING = "用导入的数据替换资料 %s的所有内容?",
		PR_PROFILEMANAGER_IMPORT_WARNING_2 = "警告:这一档案系列是由旧版本的TRP3制作而成的.\n不兼容.\n\n导入的数据替换了资料 %s的所有内容吗?",
		PR_SLASH_SWITCH_HELP = "使用它的名称切换到另一个配置文件.",
		PR_SLASH_EXAMPLE = "|cffffff00命令行用法:|r |cffcccccc/trp3 profile Millidan Foamrage|r |cffffff00切换到 Millidan Foamrage的资料.|r",
		PR_SLASH_NOT_FOUND = "|cffff0000无法找到一个名为|r |cffffff00%s|r|cffff0000.|r",

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- DASHBOARD
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

		DB_STATUS = "状态",
		DB_STATUS_CURRENTLY_COMMON = "这些状态将显示在你的角色的工具提示上。保持它的清晰和简洁|cffff9900默认 TRP3 只能显示140个字母。",
		DB_STATUS_CURRENTLY = "当前 (IC)",
		DB_STATUS_CURRENTLY_TT = "在这里列出你角色一些重要信息.",
		DB_STATUS_CURRENTLY_OOC = "其它信息 (OOC)",
		DB_STATUS_CURRENTLY_OOC_TT = "在这里列出你的一些重要信息，可以是玩家信息，或者其他人物卡信息",
		DB_STATUS_RP = "角色状态",
		DB_STATUS_RP_IC = "在RP",
		DB_STATUS_RP_IC_TT = "这说明你在扮演你的角色.\n你所有的动作行为解释为你角色的行为.",
		DB_STATUS_RP_OOC = "OOC，不在RP",
		DB_STATUS_RP_OOC_TT = "你不在扮演你的角色.\n你的言行和你的角色没有必然联系.",
		DB_STATUS_XP = "玩家状态",
		DB_STATUS_XP_BEGINNER = "RP新人",
		DB_STATUS_XP_BEGINNER_TT = "这个选择将在你的工具提示上显示一个图标，\n表示你是新手玩家.",
		DB_STATUS_RP_EXP = "RP玩家",
		DB_STATUS_RP_EXP_TT = "表明你是一个经验丰富的玩家.\n不会在你的工具提示中显示任何特定的图标.",
		DB_STATUS_RP_VOLUNTEER = "RP玩家志愿者",
		DB_STATUS_RP_VOLUNTEER_TT = "这个选择将在你的工具提示上显示一个图标, \n表示你愿意帮助他们的新手新手.",
		DB_TUTO_1 = [[|cffffff00角色状态|r 表示您当前是否在扮演角色的角色.

|cffffff00角色状态|r 允许你说你是一个初学者或者是一个愿意帮助新手的老手 !

|cff00ff00这些信息将被放置在你的角色的工具提示中.]],
		DB_NEW = "更新了什么?",
		DB_ABOUT = "关于 Total RP 3",
		DB_MORE = "更多模组",
		DB_HTML_GOTO = "单击打开",

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- COMMON UI TEXTS
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


		UI_BKG = "背景 %s",
		UI_ICON_BROWSER = "图标浏览",
		UI_ICON_BROWSER_HELP = "复制图标",
		UI_ICON_BROWSER_HELP_TT = [[当这个界面打开时 |cffffff00ctrl + click|r 你可以在一个图标上点击一个图标来复制它的名字.

这将工作:|cff00ff00
- 你袋子里的任何东西
- 在魔法书的任何一个图标上|r]],
		UI_COMPANION_BROWSER_HELP = "选择一个战斗的宠物",
		UI_COMPANION_BROWSER_HELP_TT = "|cffffff00警告: |r被重新命名的战斗宠物可以被绑定到一个卡上.\n\n|cff00ff00这里只列出了这些战斗宠物.",
		UI_ICON_SELECT = "选择图标",
		UI_MUSIC_BROWSER = "音乐浏览",
		UI_MUSIC_SELECT = "选择音乐",
		UI_COLOR_BROWSER = "颜色浏览",
		UI_COLOR_BROWSER_SELECT = "选择颜色",
		UI_IMAGE_BROWSER = "图片浏览",
		UI_IMAGE_SELECT = "选择图片",
		UI_FILTER = "搜索",
		UI_LINK_URL = "http://your.url.here",
		UI_LINK_TEXT = "您在此处输入的文字",
		UI_LINK_WARNING = [[这是你的链接 URL.
你可以复制/黏贴你的网页地址.

|cffff0000!! 免责声明 !!|r
Total RP 不负责导致有害内容的链接.]],
		UI_TUTO_BUTTON = "教学模式",
		UI_TUTO_BUTTON_TT = "点击打开/关闭教程模式",
		UI_CLOSE_ALL = "关闭全部",

		NPC_TALK_SAY_PATTERN = "说:",
		NPC_TALK_YELL_PATTERN = "喊:",
		NPC_TALK_WHISPER_PATTERN = "悄悄说：",

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- COMMON TEXTS
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

		CM_SHOW = "显示",
		CM_ACTIONS = "动作",
		CM_IC = "IC",
		CM_OOC = "OOC",
		CM_CLICK = "单击",
		CM_R_CLICK = "右击",
		CM_L_CLICK = "左击",
		CM_M_CLICK = "中键单击",
		CM_ALT = "Alt",
		CM_CTRL = "Ctrl",
		CM_SHIFT = "Shift",
		CM_DRAGDROP = "拖曳",
		CM_DOUBLECLICK = "双击",
		CM_LINK = "链接",
		CM_SAVE = "保存",
		CM_CANCEL = "取消",
		CM_NAME = "名字",
		CM_VALUE = "值",
		CM_UNKNOWN = "未知",
		CM_PLAY = "播放",
		CM_STOP = "停止",
		CM_LOAD = "读取",
		CM_REMOVE = "移动",
		CM_EDIT = "编辑",
		CM_LEFT = "左边",
		CM_CENTER = "中央",
		CM_RIGHT = "右边",
		CM_COLOR = "颜色",
		CM_ICON = "图标",
		CM_IMAGE = "图片",
		CM_SELECT = "选择",
		CM_OPEN = "打开",
		CM_APPLY = "应用",
		CM_MOVE_UP = "上移",
		CM_MOVE_DOWN = "下移",
		CM_CLASS_WARRIOR = "战士",
		CM_CLASS_PALADIN = "圣骑士",
		CM_CLASS_HUNTER = "猎人",
		CM_CLASS_ROGUE = "潜行者",
		CM_CLASS_PRIEST = "牧师",
		CM_CLASS_DEATHKNIGHT = "死亡骑士",
		CM_CLASS_SHAMAN = "萨满",
		CM_CLASS_MAGE = "法师",
		CM_CLASS_WARLOCK = "术士",
		CM_CLASS_MONK = "武僧",
		CM_CLASS_DRUID = "德鲁伊",
		CM_CLASS_UNKNOWN = "未知",
		CM_RESIZE = "调整尺寸",
		CM_RESIZE_TT = "拖动调整帧的大小.",
		CM_TWEET_PROFILE = "显示配置文件的url",
		CM_TWEET = "发送一条微博",

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- Minimap button
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

		MM_SHOW_HIDE_MAIN = "显示/隐藏的主要框架",
		MM_SHOW_HIDE_SHORTCUT = "显示/隐藏工具栏",
		MM_SHOW_HIDE_MOVE = "移动按钮",

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- Browsers
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

		BW_COLOR_CODE = "颜色代码",
		BW_COLOR_CODE_TT = "你可以在这里粘贴6个十六进制颜色代码并按Enter键.",
		BW_COLOR_CODE_ALERT = "错误的十六进制代码！",

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- Databroker
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

		DTBK_HELMET = "Total RP 3 - 头盔",
		DTBK_CLOAK = "Total RP 3 - 披风",
		DTBK_AFK = "Total RP 3 - AFK/DND",
		DTBK_RP = "Total RP 3 - IC/OOC",
		DTBK_LANGUAGES = "Total RP 3 - 语言",

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- Bindings
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

		BINDING_NAME_TRP3_TOGGLE = "教学主界面";
		BINDING_NAME_TRP3_TOOLBAR_TOGGLE = "教学工具栏";

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- About TRP3
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

		ABOUT_TITLE = "关于",

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- MAP
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

		MAP_BUTTON_TITLE = "搜索RP",
		MAP_BUTTON_SUBTITLE = "点击显示合适的搜索",
		MAP_BUTTON_NO_SCAN = "没有搜到",
		MAP_BUTTON_SCANNING = "搜索",
		MAP_SCAN_CHAR = "搜索角色",
		MAP_SCAN_CHAR_TITLE = "角色",

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- MATURE FILTER
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

		MATURE_FILTER_TITLE = "关键字过滤",
		MATURE_FILTER_TOOLTIP_WARNING = "分级内容",
		MATURE_FILTER_TOOLTIP_WARNING_SUBTEXT = "这个字符配置文件包含成熟的内容。如果你真的想要使用目标栏动作按钮来显示内容…",
		MATURE_FILTER_OPTION = "启动关键字过滤",
		MATURE_FILTER_OPTION_TT = [[检查该选项,使成熟的概要文件过滤。总RP 3将扫描传入配置文件时收到特定的关键词报告是为成熟的观众,并概要文件标记为成熟,如果找到这样的词。

成熟的概要文件将有一个温和的提示,你必须确认你想查看配置文件你第一次打开它。]],
		MATURE_FILTER_ADD_TO_WHITELIST = "将这个概要文件添加到 |cffffffff白名单|r",
		MATURE_FILTER_ADD_TO_WHITELIST_TT = "这个配置文件添加到| cffffffffmature白名单| r和揭示了成熟的内容里面。",
		MATURE_FILTER_ADD_TO_WHITELIST_OPTION = "添加到 |cffffffff白名单|r",
		MATURE_FILTER_ADD_TO_WHITELIST_TEXT = [[确认你想要添加 %s 到 |cffffffff白名单|r.

他们个人资料的内容将不再被隐藏。]],
		MATURE_FILTER_REMOVE_FROM_WHITELIST = "删除此概要 |cffffffff白名单|r",
		MATURE_FILTER_REMOVE_FROM_WHITELIST_TT = "删除此概要 |cffffffff白名单|r 隐藏在里面的分级的内容.",
		MATURE_FILTER_REMOVE_FROM_WHITELIST_OPTION = "删除此 |cffffffff白名单|r",
		MATURE_FILTER_REMOVE_FROM_WHITELIST_TEXT = [[确认你想删除 %s 从 |cffffffff白名单|r.

它们的概要文件的内容将再次被隐藏.]],
		MATURE_FILTER_FLAG_PLAYER = "标记一个人",
		MATURE_FILTER_FLAG_PLAYER_TT = "标记这个角色会发布不适内容。标记后该角色发言会被隐藏.",
		MATURE_FILTER_FLAG_PLAYER_OPTION = "标记文本",
		MATURE_FILTER_FLAG_PLAYER_TEXT = [[确认您想要标记 %s文本含有不适内容. 文本内容会被隐藏.

|cffffff00可选择的:|r 指出在这个概要文件中找到的攻击性词(由空格分隔开)将它们添加到过滤器中.]],
		MATURE_FILTER_EDIT_DICTIONARY = "编辑关键字库",
		MATURE_FILTER_EDIT_DICTIONARY_TT = "编辑用于筛选成熟配置文件的自定义字典.",
		MATURE_FILTER_EDIT_DICTIONARY_BUTTON = "编辑",
		MATURE_FILTER_EDIT_DICTIONARY_TITLE = "自定义字典编辑器",
		MATURE_FILTER_EDIT_DICTIONARY_ADD_BUTTON = "添加",
		MATURE_FILTER_EDIT_DICTIONARY_ADD_TEXT = "在字典中添加一个新单词",
		MATURE_FILTER_EDIT_DICTIONARY_EDIT_WORD = [[编辑这个词]],
		MATURE_FILTER_EDIT_DICTIONARY_DELETE_WORD = [[从自定义字典中删除单词]],
		MATURE_FILTER_WARNING_TITLE = "分级",
		MATURE_FILTER_WARNING_CONTINUE = "继续",
		MATURE_FILTER_WARNING_GO_BACK = "返回",
		MATURE_FILTER_WARNING_TEXT = [[TRP 3 内容过滤系统启用。


这个配置文件包含过滤关键字内容。


你确定你想把这个配置文件吗?]],
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- DICE ROLL
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

                DICE_ROLL = "%s roll点 |cffff9900%sx d%s|r 得到了 |cff00ff00%s|r.",
		DICE_TOTAL = "%s 统计 |cff00ff00%s|r roll到了.",
		DICE_HELP = "摇一个或者多个色子，定义几个面，例如: 1d6, 2d12 3d20 ...",
		DICE_ROLL_T = "%s %s roll点 |cffff9900%sx d%s|r 得到了 |cff00ff00%s|r.",
		DICE_TOTAL_T = "%s %s 统计 |cff00ff00%s|r roll到了.",

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- NPC Speeches
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

		NPC_TALK_TITLE = "NPC 发言",
		NPC_TALK_NAME = "NPC 名字",
		NPC_TALK_NAME_TT = [[你可以使用像 %t 这样的标准聊天标签插入你的目标名或 %f 来插入你的焦点的名字.

您还可以在不使用NPC名字的情况下，将这个字段清空以创建表情.
]],
		NPC_TALK_MESSAGE = "消息",
		NPC_TALK_CHANNEL = "频道: ",
		NPC_TALK_SEND = "发送",
		NPC_TALK_ERROR_EMPTY_MESSAGE = "消息不能为空.",
		NPC_TALK_COMMAND_HELP = "打开 NPC 发言界面.",
		NPC_TALK_BUTTON_TT = "打开 NPC 发言界面 允许你让 NPC 说话或做表情.",

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- MISC
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


		PATTERN_ERROR = "在模板中有语法错误.",
		PATTERN_ERROR_TAG = "模式中的错误:未关闭的文本标签.",
		SCRIPT_UNKNOWN_EFFECT = "脚本错误,未知的 FX",
		SCRIPT_ERROR = "错误的脚本.",
		NEW_VERSION_TITLE = "新的更新可用",
		NEW_VERSION = "|cff00ff00A new version of Total RP 3 (v %s) is available.\n\n|cffffff00We strongly encourage you to stay up-to-date.|r\n\nThis message will only appear once per session and can be disabled in the settings (General settings => Miscellaneous).",
		BROADCAST_PASSWORD = "|cffff0000There is a password placed on the broadcast channel (%s).\n|cffff9900TRP3 won't try again to connect to it but you won't be able to use some features like players location on map.\n|cff00ff00You can disable or change the broadcast channel in the TRP3 general settings.",
		BROADCAST_PASSWORDED = "|cffff0000The user |r%s|cffff0000 just placed a password on the broadcast channel (%s).\n|cffff9900If you don't know that password, you won't be able to use features like players location on the map.",
		BROADCAST_10 = "|cffff9900You already are in 10 channels. TRP3 won't try again to connect to the broadcast channel but you won't be able to use some features like players location on map.",

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- COMMANDS
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

		COM_LIST = "命令列表:",
		COM_SWITCH_USAGE = "用法: |cff00ff00/trp3 switch main|r 开关主框架或 |cff00ff00/trp3 switch toolbar|r 开关工具栏.",
		COM_RESET_USAGE = "用法: |cff00ff00/trp3 reset frames|r 重置所有帧的位置.",
		COM_RESET_RESET = "帧的位置已被重置!",
        COM_STASH_DATA = [[|cffff0000你确定你想要隐藏你的 Total RP 3 数据?|r

你的个人资料、伙伴档案和设置会暂时被隐藏起来，你的UI会重新载入空数据，就像你安装总RP 3是全新的一样.
|cff00ff00U再次使用相同命令 (|cff999999/trp3 stash|cff00ff00) 恢复您的数据.|r]],
		OPTION_ENABLED_TOAST = "选择启用",
		OPTION_DISABLED_TOAST = "选择禁用",
		WHATS_NEW_16 = [[
## 1.2.11 - 2017-11-09

### Added

- Added support for the profile downloading indicator from and to the XRP add-on.

### Fixed

- Fixed an error when trying to whitelist a profile that has been flagged as containing mature content when the profile hasn't been entirely downloaded yet ([ticket #133](https://wow.curseforge.com/projects/total-rp-3/issues/133)).
- Fixed an issue allowing the user to send empty NPC messages when using the Enter key ([ticket #124](https://wow.curseforge.com/projects/total-rp-3/issues/124)).
- Fixed an error when targeting battle pets that are participating in a pet battle ([ticket #96](https://wow.curseforge.com/projects/total-rp-3/issues/96)).
- Fixed an issue where if you used a single space character for your class (like to indicate you have none) it would be considered as empty and your character's real class would be used instead ([ticket #103](https://wow.curseforge.com/projects/total-rp-3/issues/103)).
- Fixed an issue where players with custom RP status from other add-ons sent via the Mary Sue Protocol would be shown as Out Of Character.

### Removed

- Removed workaround for the text box issue introduced in patch 7.3 as this issue has been fixed in patch 7.3.2.

]],
		WHATS_NEW_16_1 = [[
## 1.2.11.1 - 2017-12-08

### Fixed

- Fixed an issue where the Mary Sue Protocol downloading indicator would get stuck for Total RP 3 profiles.

]],
		WHATS_NEW_16_2 = [[
## 1.2.11.2 - 2017-12-26

### Fixed

- Fixed a Lua overflow error with the ChatThrottleLib that could occur in rare cases.
- Fixed an issue that would cause the tooltip to reload all the data too frequently.
- Fixed an issue that could cause a larger than usual amount of Unknown profiles to be listed in the Directory.

### Removed

- Removed the downloading progression indicator in the tooltip for now as it was the cause of some of these issues. It will be brought back later with a better implementation.

]],
		WHATS_NEW_16_3 = [[
## 1.2.11.3 - 2018-01-02

Happy new year! The Total RP 3 team wishes you the best for 2018.

### Updated

- Updated list of Patreon supporters inside the add-on for the month of December.

]],
		MORE_MODULES_2 = [[{h2:c}Optional modules{/h2}
{h3}Total RP 3: Extended{/h3}
|cff9999ffTotal RP 3: Extended|r add the possibility to create new content in WoW: campaigns with quests and dialogues, items, documents (books, signs, contracts, …) and many more!
{link*http://extended.totalrp3.info*Download on Curse.com}

{h3}Kui |cff9966ffNameplates|r module{/h3}
The Kui |cff9966ffNameplates|r module adds several Total RP 3 customizations to the KuiNameplates add-on:
• See the full RP name of a character on their nameplate, instead of their default name, colored like in their tooltip.
• See customized pets names.
• Hide the names of players without an RP profile!
{link*http://mods.curse.com/addons/wow/total-rp-3-kuinameplates-module*Download on Curse.com}.


]],

		THANK_YOU_1 = [[{h1:c}Total RP 3{/h1}
{p:c}{col:6eff51}Version %s (build %s){/col}{/p}
{p:c}{link*http://totalrp3.info*TotalRP3.info} — {twitter*TotalRP3*@TotalRP3} {/p}
{p:c}{link*http://discord.totalrp3.info*Join us on Discord}{/p}

{h2}{icon:INV_Eng_gizmo1:20} Created by{/h2}
- Renaud "{twitter*EllypseCelwe*Ellypse}" Parize
- Sylvain "{twitter*Telkostrasz*Telkostrasz}" Cossement

{h2}{icon:QUEST_KHADGAR:20} The Rest of the Team{/h2}
- Connor "{twitter*Saelorable*Sælorable}" Macleod (Contributor)
- {twitter*Solanya_*Solanya} (Community Manager)

{h2}{icon:THUMBUP:20} Acknowledgements{/h2}
{col:ffffff}Ellypse's {/col}{link*https://www.patreon.com/ellypse*Patreon} {col:ffffff}supporters:{/col}
%s

{col:ffffff}Our pre-alpha QA team:{/col}
- Erzan
- Calian
- Kharess
- Alnih
- 611

{col:ffffff}Thanks to all our friends for their support all these years:{/col}
- For Telkos: Kharess, Kathryl, Marud, Solona, Stretcher, Lisma...
- For Ellypse: The guilds Eglise du Saint Gamon, Maison Celwë'Belore, Mercenaires Atal'ai, and more particularly Erzan, Elenna, Caleb, Siana and Adaeria

{col:ffffff}For helping us creating the Total RP guild on Kirin Tor (EU):{/col}
- Azane
- Hellclaw
- Leylou

{col:ffffff}Thanks to Horionne for sending us the magazine Gamer Culte Online #14 with an article about Total RP.{/col}]],

		MO_ADDON_NOT_INSTALLED = "The %s add-on is not installed, custom Total RP 3 integration disabled.",
		MO_TOOLTIP_CUSTOMIZATIONS_DESCRIPTION = "Add custom compatibility for the %s add-on, so that your tooltip preferences are applied to Total RP 3's tooltips.",
		MO_CHAT_CUSTOMIZATIONS_DESCRIPTION = "Add custom compatibility for the %s add-on, so that chat messages and player names are modified by Total RP 3 in that add-on."
	},
};

TRP3_API.locale.registerLocale(LOCALE_EN);
