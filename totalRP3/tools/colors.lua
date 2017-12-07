----------------------------------------------------------------------------------
--- Total RP 3
---
--- Colors system
---
--- Custom Colors API, piggy backing on WoW's ColorMixin
--- @see ColorMixin
---
--- ---------------------------------------------------------------------------
--- Copyright 2017 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- 	http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;

local Colors = {};
TRP3_API.Colors = Colors;

--- WoW imports
local CreateFromMixins = CreateFromMixins;
local ColorMixin = ColorMixin;
local tonumber = tonumber;
local assert = assert;
local format = string.format;
local lenght = string.len;
local gsub = string.gsub;
local ceil = math.ceil;

--- Total RP 3 imports
local isType = TRP3_API.Assertions.isType;
local isNotNil = TRP3_API.Assertions.isNotNil;
local isNotEmpty = TRP3_API.Assertions.isNotEmpty;

---@class TRP3_ColorMixin : ColorMixin
local TRP3_ColorMixin = {};

--- Function to test if a color is correctly readable on a specified.
--- We will calculate the luminance of the text color using known values that take into account how the human eye perceive color and then compute the contrast ratio.
--- The contrast ratio should be higher than 50%.
--- See: http://www.whydomath.org/node/wavlets/imagebasics.html
---
--- @return boolean isReadable @ True if the text will be readabl
function TRP3_ColorMixin:IsTextColorReadableOnDarkBackground()
	return ((0.299 * self.r + 0.587 * self.g + 0.114 * self.b)) >= 0.5;
end

--- Make the color ligther enough to be read on a dark background
function TRP3_ColorMixin:LightenColorUntilItIsReadable()
	while not self:IsTextColorReadableOnDarkBackground() do
		self.r = self.r + 0.01;
		self.g = self.g + 0.01;
		self.b = self.b + 0.01;

		if self.r > 1 then self.r = 1 end
		if self.g > 1 then self.g = 1 end
		if self.b > 1 then self.b = 1 end
	end
end

---Convert color bytes into bits, from a 0-255 range to 0-1 range.
---@param red number @ Between 0 and 255
---@param green number @ Between 0 and 255
---@param blue number @ Between 0 and 255
---@param optional alpha number @ Between 0 and 255
---@return number, number, number, number
local function convertColorBytesToBits(red, green, blue, alpha)

	assert(isNotNil(red, "red"));
	assert(isNotNil(green, "green"));
	assert(isNotNil(blue, "blue"));

	if alpha == nil then
		alpha = 255;
	end

	return red / 255, green / 255, blue / 255, alpha / 255;
end

local function convertColorBitsToBytes(red, green, blue, alpha)
	assert(isNotNil(red, "red"));
	assert(isNotNil(green, "green"));
	assert(isNotNil(blue, "blue"));

	if alpha == nil then
		alpha = 1;
	end

	return ceil(red * 255), ceil(green * 255), ceil(blue * 255), ceil(blue * 255)
end

--- Extract RGB values (255 based) from an hexadecimal code
---@param hexadecimalCode string @ An hexadecimal code corresponding to a color (example: `FFF`, `FAFAFA`, `#ffbababa`, `|cffbababa`)
---@return number, number, number red, green, blue
function Colors.hexaToNumber(hexadecimalCode)
	assert(isType(hexadecimalCode, "string", "hexadecimalCode"));

	local red, green, blue, alpha;

	-- We make sure we remove possible prefixes
	hexadecimalCode = gsub(hexadecimalCode, "#", "");
	hexadecimalCode = gsub(hexadecimalCode, "|c", "");

	local hexadecimalCodeLength = lenght(hexadecimalCode);

	if hexadecimalCodeLength == 3 then -- #FFF
		local r = hexadecimalCode:sub(1, 1);
		local g = hexadecimalCode:sub(2, 2);
		local b = hexadecimalCode:sub(3, 3);
		red = tonumber(r .. r, 16)
		green = tonumber(g .. g, 16)
		blue = tonumber(b .. b, 16)
	elseif hexadecimalCodeLength == 6 then -- #FAFAFA
		red = tonumber(hexadecimalCode:sub(1, 2), 16)
		green = tonumber(hexadecimalCode:sub(3, 4), 16)
		blue = tonumber(hexadecimalCode:sub(5, 6), 16)
	elseif hexadecimalCodeLength == 8 then -- #ffbababa
		alpha = tonumber(hexadecimalCode:sub(1, 2), 16)
		red = tonumber(hexadecimalCode:sub(3, 4), 16)
		green = tonumber(hexadecimalCode:sub(5, 6), 16)
		blue = tonumber(hexadecimalCode:sub(7, 8), 16)
	end

	return red, green, blue, alpha;
end

function Colors.hexaToFloat(hexa)
	return convertColorBytesToBits(Colors.hexaToNumber(hexa));
end

---createColor
---@param red number @ Value of the red channel
---@param green number @ Value of the green channel
---@param blue number @ Value of the blue channel
---@param optional alpha number @ Value of the alpha channel (default 1)
---@return TRP3_ColorMixin
function Colors.createColor(red, green, blue, alpha)

	assert(isType(red, "number", "red"));
	assert(isType(green, "number", "green"));
	assert(isType(blue, "number", "blue"));

	-- Check if we were given numbers based on a 0 to 255 scale
	if red > 1 or green > 1 or blue > 1 or (alpha and alpha > 1) then
		-- If that's the case, we will convert the numbers into the 0 to 1 scale
		red, green, blue, alpha = convertColorBytesToBits(red, green, blue, alpha);
	end

	-- Alpha channel is optional and default to 1 (full opacity)
	if alpha == nil then
		alpha = 1;
	end

	---@type TRP3_ColorMixin
	local color = CreateFromMixins(ColorMixin, TRP3_ColorMixin);
	color:OnLoad(red, green, blue, alpha);
	return color;
end

---createColorFromTable
---@param table table @ A color table with the r, g, b, a(optional) fields.
---@return TRP3_ColorMixin
function Colors.createColorFromTable(table)
	assert(isType(table, "table", "table"));
	assert(isNotNil(table.r, "table.r"));
	assert(isNotNil(table.g, "table.g"));
	assert(isNotNil(table.b, "table.b"));

	return Colors.createColor(table.r, table.g, table.b, table.a);
end

--- Creates a new TRP3_ColorMixin using an hexadecimal code.
---
--- _Note: This has lesser performances than `Colors.createColor(red, green, blue, alpha)` and should only be used if necessary. `Colors.createColor(red, green, blue, alpha)` should be preferred when possible._
---
---@param hexadecimalCode string @ An hexadecimal code corresponding to a color (example: `FFF`, `FAFAFA`, `#ffbababa`, `|cffbababa`)
---@return TRP3_ColorMixin
function Colors.createColorFromHexadecimalCode(hexadecimalCode)
	assert(isType(hexadecimalCode, "string", "hexadecimalCode"));
	return Colors.createColor(Colors.hexaToNumber(hexadecimalCode));
end

---Try to extract a color from a text that is using WoW's text color escape sequence (|cffffffff)
---@param text string
---@return TRP3_ColorMixin|nil color @ Returns a color if it was able to find one.
function Colors.extractColorFromText(text)
	assert(isType(text, "string", "text"));
	-- We can safely ignore the alpha channel here, it rarely varies in texts
	local rgb = text:match("|c%x%x(%x%x%x%x%x%x)");
	if isNotEmpty(rgb) then
		return Colors.createColorFromHexadecimalCode(rgb);
	end
end

---@param number number @ Value must be 255 based
---@return string hexa @ Hexadecimal representation of the value
function Colors.numberToHexa(number)
	assert(isType(number, "number", "number"));
	return format("%.2x", number);
end

--- Values must be 256 based
---@param red number
---@param green number
---@param blue number
---@param optional alpha number @ Default to 255
---@return string colorCode @ A color code in the |cffffffff format
function Colors.colorCode(red, green, blue, alpha)
	assert(isType(red, "number", "red"));
	assert(isType(green, "number", "green"));
	assert(isType(blue, "number", "blue"));
	if not alpha then
		alpha = 255;
	end
	return format("|c%.2x%.2x%.2x%.2x", alpha, red, green, blue);
end

--- Values must be 0..1 based
---@param red number
---@param green number
---@param blue number
---@param optional alpha number
---@return string colorCode @ A color code in the |cffffffff format
function Colors.colorCodeFloat(red, green, blue, alpha)
	return Colors.colorCode(convertColorBitsToBytes(red, green, blue, alpha));
end

--- From r, g, b tab
---@param tab number[] @ A table with the r, b, g, a fields that represents a color
---@return string colorCode @ A color code in the |cffffffff format
function Colors.colorCodeFloatTab(tab)
	return Colors.colorCodeFloat(tab.r, tab.g, tab.b, tab.a);
end

---Get the chat color associated to a specificed channel in the settings
---@param channel string @ A chat channel ("WHISPER", "YELL", etc.)
---@return TRP3_ColorMixin chatColor
function Colors.getChatColorForChannel(channel)
	assert(isType(channel, "string", "channel"));
	assert(ChatTypeInfo[channel], "Trying to get chat color for an unknown channel type: " .. channel);

	-- Caches the channel colors into our COLORS table for easy access later and avoid creating a new color everytime
	if not Colors.COLORS["CHAT_" .. channel] then
		Colors.COLORS["CHAT_" .. channel] = Colors.createColorFromTable(ChatTypeInfo[channel])
	end

	return Colors.COLORS["CHAT_" .. channel];
end

--- A list of common colors we might want to use accross the add-on
Colors.COLORS = {
	ORANGE 	= Colors.createColor(255, 153, 0),
	WHITE 	= Colors.createColor(1, 1, 1),
	YELLOW 	= Colors.createColor(1, 0.75, 0),
	CYAN	= Colors.createColor(0, 1, 1),
	GREEN	= Colors.createColor(0, 1, 0),
	RED		= Colors.createColor(1, 0, 0),

	-- CLASSES
	HUNTER 		= Colors.createColorFromTable(RAID_CLASS_COLORS.HUNTER),
	WARLOCK 	= Colors.createColorFromTable(RAID_CLASS_COLORS.WARLOCK),
	PRIEST 		= Colors.createColorFromTable(RAID_CLASS_COLORS.PRIEST),
	PALADIN 	= Colors.createColorFromTable(RAID_CLASS_COLORS.PALADIN),
	MAGE 		= Colors.createColorFromTable(RAID_CLASS_COLORS.MAGE),
	ROGUE 		= Colors.createColorFromTable(RAID_CLASS_COLORS.ROGUE),
	DRUID 		= Colors.createColorFromTable(RAID_CLASS_COLORS.DRUID),
	SHAMAN 		= Colors.createColorFromTable(RAID_CLASS_COLORS.SHAMAN),
	WARRIOR 	= Colors.createColorFromTable(RAID_CLASS_COLORS.WARRIOR),
	DEATHKNIGHT = Colors.createColorFromTable(RAID_CLASS_COLORS.DEATHKNIGHT),
	MONK 		= Colors.createColorFromTable(RAID_CLASS_COLORS.MONK),
	DEMONHUNTER = Colors.createColorFromTable(RAID_CLASS_COLORS.DEMONHUNTER),

	-- ITEM QUALITY
	-- BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_COMMON] is actually the POOR (grey) color.
	-- There is no common quality color in . Bravo Blizzard 👏
	ITEM_POOR	 	= Colors.createColorFromTable(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_COMMON]),
	ITEM_COMMON	 	= Colors.createColor(0.95, 0.95, 0.95),
	ITEM_UNCOMMON 	= Colors.createColorFromTable(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_UNCOMMON]),
	ITEM_RARE 		= Colors.createColorFromTable(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_RARE]),
	ITEM_EPIC 		= Colors.createColorFromTable(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_EPIC]),
	ITEM_LEGENDARY 	= Colors.createColorFromTable(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_LEGENDARY]),
	ITEM_ARTIFACT 	= Colors.createColorFromTable(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_ARTIFACT]),
	ITEM_HEIRLOOM 	= Colors.createColorFromTable(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_HEIRLOOM]),
	ITEM_WOW_TOKEN 	= Colors.createColorFromTable(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_WOW_TOKEN]),

	-- FACTIONS
	ALLIANCE	= Colors.createColorFromTable(PLAYER_FACTION_COLORS[1]),
	HORDE		= Colors.createColorFromTable(PLAYER_FACTION_COLORS[0]), -- Yup, this is a table with a 0 index. Blizzard ¯\_(ツ)_/¯

	BATTLE_NET	= Colors.createColorFromTable(FRIENDS_BNET_NAME_COLOR),
	TWITTER = Colors.createColorFromHexadecimalCode("#61AAEE"),

	-- POWERBAR COLORS
	POWER_MANA 				= Colors.createColorFromTable(PowerBarColor["MANA"]),
	POWER_RAGE 				= Colors.createColorFromTable(PowerBarColor["RAGE"]),
	POWER_FOCUS 			= Colors.createColorFromTable(PowerBarColor["FOCUS"]),
	POWER_ENERGY 			= Colors.createColorFromTable(PowerBarColor["ENERGY"]),
	POWER_COMBO_POINTS 		= Colors.createColorFromTable(PowerBarColor["COMBO_POINTS"]),
	POWER_RUNES 			= Colors.createColorFromTable(PowerBarColor["RUNES"]),
	POWER_RUNIC_POWER 		= Colors.createColorFromTable(PowerBarColor["RUNIC_POWER"]),
	POWER_SOUL_SHARDS 		= Colors.createColorFromTable(PowerBarColor["SOUL_SHARDS"]),
	POWER_LUNAR_POWER 		= Colors.createColorFromTable(PowerBarColor["LUNAR_POWER"]),
	POWER_HOLY_POWER 		= Colors.createColorFromTable(PowerBarColor["HOLY_POWER"]),
	POWER_MAELSTROM 		= Colors.createColorFromTable(PowerBarColor["MAELSTROM"]),
	POWER_INSANITY 			= Colors.createColorFromTable(PowerBarColor["INSANITY"]),
	POWER_CHI 				= Colors.createColorFromTable(PowerBarColor["CHI"]),
	POWER_ARCANE_CHARGES 	= Colors.createColorFromTable(PowerBarColor["ARCANE_CHARGES"]),
	POWER_FURY 				= Colors.createColorFromTable(PowerBarColor["FURY"]),
	POWER_PAIN 				= Colors.createColorFromTable(PowerBarColor["PAIN"]),
	POWER_AMMOSLOT 			= Colors.createColorFromTable(PowerBarColor["AMMOSLOT"]),
	POWER_FUEL 				= Colors.createColorFromTable(PowerBarColor["FUEL"]),
};

---@param englishClass string @ The english variable of a class, all caps (HUNTER, PRIEST)
---@return TRP3_ColorMixin color
function Colors.getClassColor(englishClass)
	assert(isType(englishClass, "string", "englishClass"));
	assert(RAID_CLASS_COLORS[englishClass], "Trying to get class color of an unknown class " .. englishClass);
	return Colors.COLORS[englishClass];
end

local TRP3_COLOR_SHORTCUTS = {
	["r"] = Colors.createColorFromHexadecimalCode("ff0000"),
	["g"] = Colors.createColorFromHexadecimalCode("00ff00"),
	["b"] = Colors.createColorFromHexadecimalCode("0000ff"),
	["y"] = Colors.createColorFromHexadecimalCode("ffff00"),
	["p"] = Colors.createColorFromHexadecimalCode("ff00ff"),
	["c"] = Colors.createColorFromHexadecimalCode("00ffff"),
	["w"] = Colors.createColorFromHexadecimalCode("ffffff"),
	["0"] = Colors.createColorFromHexadecimalCode("000000"),
	["o"] = Colors.createColorFromHexadecimalCode("ffaa00"),
}

---@param shortcut string @ A single used as a shortcut to one of our color
---@return TRP3_ColorMixin color
function Colors.get(shortcut)
	if not shortcut then
		shortcut = "w";
	end
	return TRP3_COLOR_SHORTCUTS[shortcut];
end