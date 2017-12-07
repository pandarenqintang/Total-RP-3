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

---CreateColor
---@param red number @ Value of the red channel
---@param green number @ Value of the green channel
---@param blue number @ Value of the blue channel
---@param optional alpha number @ Value of the alpha channel (default 1)
---@return TRP3_ColorMixin
function Colors.CreateColor(red, green, blue, alpha)

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

---CreateColorFromTable
---@param table table @ A color table with the r, g, b, a fields.
---@return TRP3_ColorMixin
function Colors.CreateColorFromTable(table)
	assert(isType(table, "table", "table"));
	assert(isNotNil(table.r, "table.r"));
	assert(isNotNil(table.g, "table.g"));
	assert(isNotNil(table.b, "table.b"));

	return Colors.CreateColor(table.r, table.g, table.b, table.a);
end

--- Creates a new TRP3_ColorMixin using an hexadecimal code.
---
--- _Note: This has lesser performances than `Colors.CreateColor(red, green, blue, alpha)` and should only be used if necessary. `Colors.CreateColor(red, green, blue, alpha)` should be preferred when possible._
---
---@param hexadecimalCode string @ An hexadecimal code corresponding to a color (example: `FFF`, `FAFAFA`, `#ffbababa`, `|cffbababa`)
---@return TRP3_ColorMixin
function Colors.CreateColorFromHexadecimalCode(hexadecimalCode)
	assert(isType(hexadecimalCode, "string", "hexadecimalCode"));

	local red, green, blue, alpha = 1, 1, 1, 1;

	-- We make sure we remove possible prefixes
	hexadecimalCode = hexadecimalCode:gsub("#", "");
	hexadecimalCode = hexadecimalCode:gsub("|c", "");

	local hexadecimalCodeLength = hexadecimalCode:len();

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

	return Colors.CreateColor(red, green, blue, alpha);
end

---Get the chat color associated to a specificed channel in the settings
---@param channel string @ A chat channel ("WHISPER", "YELL", etc.)
---@return TRP3_ColorMixin chatColor
function Colors.getChatColorForChannel(channel)
	assert(isType(channel, "string", "channel"));
	assert(ChatTypeInfo[channel], "Trying to get chat color for an unknown channel type: " .. channel);

	-- Caches the channel colors into our COLORS table for easy access later and avoid creating a new color everytime
	if not Colors.COLORS["CHAT_" .. channel] then
		Colors.COLORS["CHAT_" .. channel] = Colors.CreateColorFromTable(ChatTypeInfo[channel])
	end

	return Colors.COLORS["CHAT_" .. channel];
end

--- A list of common colors we might want to use accross the add-on
Colors.COLORS = {
	ORANGE 	= Colors.CreateColor(255, 153, 0),
	WHITE 	= Colors.CreateColor(1, 1, 1),
	YELLOW 	= Colors.CreateColor(1, 0.75, 0),
	CYAN	= Colors.CreateColor(0, 1, 1),
	GREEN	= Colors.CreateColor(0, 1, 0),
	RED		= Colors.CreateColor(1, 0, 0),

	-- CLASSES
	HUNTER 		= Colors.CreateColorFromTable(RAID_CLASS_COLORS.HUNTER),
	WARLOCK 	= Colors.CreateColorFromTable(RAID_CLASS_COLORS.WARLOCK),
	PRIEST 		= Colors.CreateColorFromTable(RAID_CLASS_COLORS.PRIEST),
	PALADIN 	= Colors.CreateColorFromTable(RAID_CLASS_COLORS.PALADIN),
	MAGE 		= Colors.CreateColorFromTable(RAID_CLASS_COLORS.MAGE),
	ROGUE 		= Colors.CreateColorFromTable(RAID_CLASS_COLORS.ROGUE),
	DRUID 		= Colors.CreateColorFromTable(RAID_CLASS_COLORS.DRUID),
	SHAMAN 		= Colors.CreateColorFromTable(RAID_CLASS_COLORS.SHAMAN),
	WARRIOR 	= Colors.CreateColorFromTable(RAID_CLASS_COLORS.WARRIOR),
	DEATHKNIGHT = Colors.CreateColorFromTable(RAID_CLASS_COLORS.DEATHKNIGHT),
	MONK 		= Colors.CreateColorFromTable(RAID_CLASS_COLORS.MONK),
	DEMONHUNTER = Colors.CreateColorFromTable(RAID_CLASS_COLORS.DEMONHUNTER),

	-- ITEM QUALITY
	-- BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_COMMON] is actually the POOR (grey) color.
	-- There is no common quality color in . Bravo Blizzard 👏
	ITEM_POOR	 	= Colors.CreateColorFromTable(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_COMMON]),
	ITEM_COMMON	 	= Colors.CreateColor(0.95, 0.95, 0.95),
	ITEM_UNCOMMON 	= Colors.CreateColorFromTable(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_UNCOMMON]),
	ITEM_RARE 		= Colors.CreateColorFromTable(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_RARE]),
	ITEM_EPIC 		= Colors.CreateColorFromTable(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_EPIC]),
	ITEM_LEGENDARY 	= Colors.CreateColorFromTable(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_LEGENDARY]),
	ITEM_ARTIFACT 	= Colors.CreateColorFromTable(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_ARTIFACT]),
	ITEM_HEIRLOOM 	= Colors.CreateColorFromTable(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_HEIRLOOM]),
	ITEM_WOW_TOKEN 	= Colors.CreateColorFromTable(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_WOW_TOKEN]),

	-- FACTIONS
	ALLIANCE	= Colors.CreateColorFromTable(PLAYER_FACTION_COLORS[1]),
	HORDE		= Colors.CreateColorFromTable(PLAYER_FACTION_COLORS[0]), -- Yup, this is a table with a 0 index. Blizzard ¯\_(ツ)_/¯

	BATTLE_NET	= Colors.CreateColorFromTable(FRIENDS_BNET_NAME_COLOR);

	-- POWERBAR COLORS
	POWER_MANA 				= Colors.CreateColorFromTable(PowerBarColor["MANA"]),
	POWER_RAGE 				= Colors.CreateColorFromTable(PowerBarColor["RAGE"]),
	POWER_FOCUS 			= Colors.CreateColorFromTable(PowerBarColor["FOCUS"]),
	POWER_ENERGY 			= Colors.CreateColorFromTable(PowerBarColor["ENERGY"]),
	POWER_COMBO_POINTS 		= Colors.CreateColorFromTable(PowerBarColor["COMBO_POINTS"]),
	POWER_RUNES 			= Colors.CreateColorFromTable(PowerBarColor["RUNES"]),
	POWER_RUNIC_POWER 		= Colors.CreateColorFromTable(PowerBarColor["RUNIC_POWER"]),
	POWER_SOUL_SHARDS 		= Colors.CreateColorFromTable(PowerBarColor["SOUL_SHARDS"]),
	POWER_LUNAR_POWER 		= Colors.CreateColorFromTable(PowerBarColor["LUNAR_POWER"]),
	POWER_HOLY_POWER 		= Colors.CreateColorFromTable(PowerBarColor["HOLY_POWER"]),
	POWER_MAELSTROM 		= Colors.CreateColorFromTable(PowerBarColor["MAELSTROM"]),
	POWER_INSANITY 			= Colors.CreateColorFromTable(PowerBarColor["INSANITY"]),
	POWER_CHI 				= Colors.CreateColorFromTable(PowerBarColor["CHI"]),
	POWER_ARCANE_CHARGES 	= Colors.CreateColorFromTable(PowerBarColor["ARCANE_CHARGES"]),
	POWER_FURY 				= Colors.CreateColorFromTable(PowerBarColor["FURY"]),
	POWER_PAIN 				= Colors.CreateColorFromTable(PowerBarColor["PAIN"]),
	POWER_AMMOSLOT 			= Colors.CreateColorFromTable(PowerBarColor["AMMOSLOT"]),
	POWER_FUEL 				= Colors.CreateColorFromTable(PowerBarColor["FUEL"]),
};