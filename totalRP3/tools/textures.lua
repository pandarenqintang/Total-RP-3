----------------------------------------------------------------------------------
--- Total RP 3
---
--- Textures tools
---
--- Provides helper functions to handle textures
---
---	------------------------------------------------------------------------------
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
---	Copyright 2017 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
---	Licensed under the Apache License, Version 2.0 (the "License");
---	you may not use this file except in compliance with the License.
---	You may obtain a copy of the License at
---
---		http://www.apache.org/licenses/LICENSE-2.0
---
---	Unless required by applicable law or agreed to in writing, software
---	distributed under the License is distributed on an "AS IS" BASIS,
---	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
---	See the License for the specific language governing permissions and
---	limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;

local Textures = {};
TRP3_API.Textures = Textures;

-- WoW import
local SetPortraitToTexture = SetPortraitToTexture
local tostring = tostring
local pcall = pcall
local assert = assert;
local format = string.format;
local type = type;

-- Total RP 3 imports
local Logs = TRP3_API.Logs;
local isOfTypes = TRP3_API.Assertions.isOfTypes;

local TEXTURE_TAG_PATTERN = "|T%s:%s:%s|t";

--- Return an texture text tag based on the given image url and size.
---@param texturePath string|number @ Either a texture path or a texture ID
---@param optional textureSizeX number @ The horizontal size of the texture (default 15)
---@param optional textureSizeY number @ The vertical size of the texture (default to textureSizeX)
---@return string textureTag @ A tag (escape sequence) to display the texture in a text
function Textures.tag(texturePath, textureSizeX, textureSizeY)
	assert(isOfTypes(texturePath, { "string", "number" }, "texturePath"));
	if not textureSizeX then
		textureSizeX = 15;
	end
	if not textureSizeY then
		textureSizeY = textureSizeX;
	end
	return format(TEXTURE_TAG_PATTERN, texturePath, textureSizeX, textureSizeY);
end

local ICON_PATH = [[Interface\ICONS\]];

---@param iconPath string|number @ Either a texture path or a texture ID
---@return string iconPath @ Either a full texture path or a texture ID
function Textures.iconPath(iconPath)
	-- We append the icons texture path if the texture is a string, but not if it is an ID
	if type(iconPath) == "string" then
		iconPath = ICON_PATH .. iconPath;
	end
	return iconPath;
end

---@param iconPath string|number @ Either a texture path or a texture ID
---@param iconSize number @ The size of the icon (default 15)
---@return string iconTag @ A tag (escape sequence) to display the icon in a text
function Textures.iconTag(iconPath, iconSize)
	if not iconPath then
		iconPath = TRP3_API.globals.icons.default;
	end
	return Textures.tag(Textures.iconPath(iconPath), iconSize);
end

-- TODO There is something to be improved here. Better fallback, better handling of Frame vs name of frame
---Apply a rounded texture on a frame
---@param textureFrame Frame|string @ Either the reference to a frame or the name of the frame
---@param texturePath string|number @ Either a texture path or a texture ID that can be rounded
---@param optional failTexture string|number @ Either a texture path or a texture ID as a fallback
function Textures.applyRoundTexture(textureFrame, texturePath, failTexture)
	assert(isOfTypes(textureFrame, { "Texture", "string" }, "textureFrame"));
	assert(isOfTypes(texturePath, { "number", "string" }, "texturePath"));

	-- SetPortraitToTexture raises an error if it cannot use the texture we gave it.
	local ok, errorMess = pcall(SetPortraitToTexture, textureFrame, texturePath);
	if not ok then
		Logs.warning("Failed to round texture: " .. tostring(errorMess));
		if failTexture then
			SetPortraitToTexture(textureFrame, failTexture);
		elseif _G[textureFrame] then
			_G[textureFrame]:SetTexture(texturePath);
		end
	end
end


local UNIT_TEXTURES = {
	Human = {
		"Achievement_Character_Human_Male",
		"Achievement_Character_Human_Female",
	},
	Gnome = {
		"Achievement_Character_Gnome_Male",
		"Achievement_Character_Gnome_Female",
	},
	Scourge = {
		"Achievement_Character_Undead_Male",
		"Achievement_Character_Undead_Female",
	},
	NightElf = {
		"Achievement_Character_Nightelf_Male",
		"Achievement_Character_Nightelf_Female",
	},
	Dwarf = {
		"Achievement_Character_Dwarf_Male",
		"Achievement_Character_Dwarf_Female",
	},
	Draenei = {
		"Achievement_Character_Draenei_Male",
		"Achievement_Character_Draenei_Female",
	},
	Orc = {
		"Achievement_Character_Orc_Male",
		"Achievement_Character_Orc_Female",
	},
	BloodElf = {
		"Achievement_Character_Bloodelf_Male",
		"Achievement_Character_Bloodelf_Female",
	},
	Troll = {
		"Achievement_Character_Troll_Male",
		"Achievement_Character_Troll_Female",
	},
	Tauren = {
		"Achievement_Character_Tauren_Male",
		"Achievement_Character_Tauren_Female",
	},
	Worgen = {
		"achievement_worganhead",
		"Ability_Racial_Viciousness",
	},
	Goblin = {
		"Ability_Racial_RocketJump",
		"Ability_Racial_RocketJump",
	},
	Pandaren = {
		"Achievement_Guild_ClassyPanda",
		"Achievement_Character_Pandaren_Female",
	},
};

---Get the icon texture corresponding to the unit, according to its race and gender
---@param race string
---@param gender number
---@retunr string texture
function Textures.getUnitTexture(race, gender)
	if UNIT_TEXTURES[race] and UNIT_TEXTURES[race][gender - 1] then
		return UNIT_TEXTURES[race][gender - 1];
	end
	return TRP3_API.Globals.icons.default;
end

local CLASS_TEXTURES = {
	ROGUE = "Ability_Rogue_DualWeild",
	WARLOCK = "Ability_Warlock_Eradication",
	PALADIN = "Spell_Paladin_Clarityofpurpose",
	MONK = "Monk_Ability_Transcendence",
	MAGE = "spell_Mage_NetherTempest",
	HUNTER = "Ability_Hunter_MasterMarksman",
	WARRIOR = "Ability_Warrior_OffensiveStance",
	DEATHKNIGHT = "Spell_Deathknight_FrostPresence",
	DRUID = "Spell_druid_tirelesspursuit",
	SHAMAN = "Ability_Shaman_WindwalkTotem",
	PRIEST = "Priest_icon_Chakra",
	DEMONHUNTER = "ability_demonhunter_specdps",
}

---Get the icon texture corresponding to the class
---@param class string
---@return string texture
function Textures.getClassTexture(class)
	return CLASS_TEXTURES[class] or TRP3_API.Globals.icons.default;
end