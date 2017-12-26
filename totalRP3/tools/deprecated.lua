----------------------------------------------------------------------------------
--- Total RP 3
---
--- Deprecated API and functions
---
--- This file makes bridges between the old APIs and the new ones.
--- It will send warnings when used during development
---
---	------------------------------------------------------------------------------
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

local Deprecated = {};
TRP3_API.Deprecated = Deprecated;

-- WoW imports
local setmetatable = setmetatable;
local format = string.format;

-- Localization keys
local DEPRECATED_API_MOVED = [[Accessing Total RP 3's %s API via %s is deprecated and will be removed in version %s. Please use %s instead.]];
local DEPRECATED_FUNCTION = [[Function %s is deprecated and will be removed in version %s. Please use %s instead.]];

local NEXT_DEPRECATION_VERSION = "1.4.0";

function Deprecated.setUpAPIDeprecatedWarning(newAPI, apiName, oldPath, newPath)
	return setmetatable({}, {
		__index = function(_, key)
			TRP3_API.Logs.warning(format(DEPRECATED_API_MOVED, apiName, oldPath, NEXT_DEPRECATION_VERSION, newPath));
			return newAPI[key];
		end,
	});
end

function Deprecated.setUpDeprecatedFunctionWarning(newFunction, oldFunctionName, newFunctionName)
	return function(...)
		TRP3_API.Logs.warning(format(DEPRECATED_FUNCTION, oldFunctionName, NEXT_DEPRECATION_VERSION, newFunctionName));
		return newFunction(...);
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Will be deprecated in version 1.4.0
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- String API
TRP3_API.utils.str = Deprecated.setUpAPIDeprecatedWarning(TRP3_API.Strings, "Strings", "TRP3_API.utils.str", "TRP3_API.Strings");
TRP3_API.utils.str.id = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.Strings.generateID, "TRP3_API.utils.str.id", "TRP3_API.Strings.generateID");

-- HTML API
TRP3_API.utils.str.toHTML = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.HTML.convertTRP3TagsIntoHTML, "TRP3_API.utils.str.toHTML", "TRP3_API.HTML.convertTRP3TagsIntoHTML");

-- Colors API
TRP3_API.utils.color = Deprecated.setUpAPIDeprecatedWarning(TRP3_API.Colors, "Colors", "TRP3_API.utils.color", "TRP3_API.Colors");
TRP3_API.utils.color.CreateColor = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.Colors.createColor, "TRP3_API.utils.color.CreateColor", "TRP3_API.Colors.createColor");
TRP3_API.utils.color.getColorFromHexadecimalCode = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.Colors.createColorFromHexadecimalCode, "TRP3_API.utils.color.getColorFromHexadecimalCode", "TRP3_API.Colors.createColorFromHexadecimalCode");
TRP3_API.utils.color.GetClassColorByGUID = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.GUID.getClassColor, "TRP3_API.utils.color.GetClassColorByGUID", "TRP3_API.GUID.getClassColor");
TRP3_API.utils.color.GetCustomColorByGUID = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.GUID.getCustomColor, "TRP3_API.utils.color.GetCustomColorByGUID", "TRP3_API.GUID.getCustomColor");
TRP3_API.utils.color.getUnitColorByGUID = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.GUID.getUnitColor, "TRP3_API.utils.color.getUnitColorByGUID", "TRP3_API.GUID.getUnitColor");
TRP3_API.utils.color.getUnitCustomColor = Deprecated.setUpDeprecatedFunctionWarning(function(...)
	TRP3_API.register.getUnitCustomColor(...);
end , "TRP3_API.utils.color.getUnitCustomColor", "TRP3_API.register.getUnitCustomColor");

-- Events API
TRP3_API.utils.event = Deprecated.setUpAPIDeprecatedWarning(TRP3_API.GameEvents, "GameEvents", "TRP3_API.utils.event", "TRP3_API.GameEvents");

-- GUID API
TRP3_API.utils.guid = Deprecated.setUpAPIDeprecatedWarning(TRP3_API.GUID, "GUID", "TRP3_API.utils.guid", "TRP3_API.GUID");
TRP3_API.utils.str.getUnitDataFromGUIDDirect = TRP3_API.GUID.getNPCData;

-- Locale API
TRP3_API.locale = Deprecated.setUpAPIDeprecatedWarning(TRP3_API.Locale, "Locale", "TRP3_API.locale", "TRP3_API.Locale");

-- Logs API
-- Note we will avoid throwing warning when using the old logging API because it is already chatty enough and can lead to infinite loops :P
TRP3_API.utils.log = {};
TRP3_API.utils.log.level = TRP3_API.Logs.LEVELS;
TRP3_API.utils.log.log = function(message, level)
	if not level then level = TRP3_API.Logs.LEVELS.INFO end
	TRP3_API.Logs.log(level, message);
end

TRP3_API.ui.misc = {};
-- Sounds API
TRP3_API.utils.music = Deprecated.setUpAPIDeprecatedWarning(TRP3_API.Sounds, "Sounds", "TRP3_API.utils.music", "TRP3_API.Sounds");
TRP3_API.ui.misc.playSoundKit = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.Sounds.playUISound, "TRP3_API.ui.misc.playSoundKit", "TRP3_API.Sounds.playUISound");
TRP3_API.ui.misc.playUISound = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.Sounds.playUISound, "TRP3_API.ui.misc.playUISound", "TRP3_API.Sounds.playUISound");
-- Manually register a played sound callback for Extended's sound history frame
TRP3_API.Sounds.registerOnSoundPlayedCallback(function()
	if TRP3_SoundsHistoryFrame then
		TRP3_SoundsHistoryFrame.onSoundPlayed();
	end
end);

-- Tables API
TRP3_API.utils.table = Deprecated.setUpAPIDeprecatedWarning(TRP3_API.Tables, "Tables", "TRP3_API.utils.table", "TRP3_API.Tables");

-- Textures API
TRP3_API.utils.texture = Deprecated.setUpAPIDeprecatedWarning(TRP3_API.Textures, "Textures", "TRP3_API.utils.texture", "TRP3_API.Textures");
TRP3_API.utils.str.texture = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.Textures.tag, "TRP3_API.utils.str.texture", "TRP3_API.Textures.tag");
TRP3_API.utils.str.icon = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.Textures.iconTag, "TRP3_API.utils.str.icon", "TRP3_API.Textures.iconTag");
TRP3_API.ui.misc.getUnitTexture = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.Textures.getUnitTexture, "TRP3_API.ui.misc.getUnitTexture", "TRP3_API.Textures.getUnitTexture");
TRP3_API.ui.misc.getClassTexture = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.Textures.getClassTexture, "TRP3_API.ui.misc.getClassTexture", "TRP3_API.Textures.getClassTexture");

-- Unit API
TRP3_API.utils.str.GetGuildName = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.Unit.getGuildName, "TRP3_API.utils.str.GetGuildName", "TRP3_API.Unit.getGuildName");
TRP3_API.utils.str.GetGuildRank = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.Unit.getGuildRank, "TRP3_API.utils.str.GetGuildRank", "TRP3_API.Unit.getGuildRank");
TRP3_API.utils.str.GetRace = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.Unit.getRace, "TRP3_API.utils.str.GetRace", "TRP3_API.Unit.getRace");
TRP3_API.utils.str.GetClass = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.Unit.getClass, "TRP3_API.utils.str.GetClass", "TRP3_API.Unit.getClass");
TRP3_API.utils.str.GetFaction = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.Unit.getFaction, "TRP3_API.utils.str.GetFaction", "TRP3_API.Unit.getFaction");
TRP3_API.utils.str.getUnitDataFromGUID = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.Unit.getNPCData, "TRP3_API.utils.str.getUnitDataFromGUID", "TRP3_API.Unit.getNPCData");
TRP3_API.utils.str.getUnitNPCID = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.Unit.getUnitNPCID, "TRP3_API.utils.str.getUnitNPCID", "TRP3_API.Unit.getUnitNPCID");
TRP3_API.utils.str.getUnitID = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.Unit.getUnitID, "TRP3_API.utils.str.getUnitID", "TRP3_API.Unit.getUnitID");

-- Serial API
TRP3_API.utils.serial = Deprecated.setUpAPIDeprecatedWarning(TRP3_API.Serial, "Serial", "TRP3_API.utils.serial", "TRP3_API.Serial");

-- Math API
TRP3_API.utils.math = Deprecated.setUpAPIDeprecatedWarning(TRP3_API.Math, "Math", "TRP3_API.utils.math", "TRP3_API.Math");

-- Utils.pcall
local pcall = pcall;
TRP3_API.utils.pcall = Deprecated.setUpDeprecatedFunctionWarning(function(func, ...)
	if func then
		return { pcall(func, ...) };
	end
end, "TRP3_API.utils.pcall", "{pcall(...)}");

-- Messaging API
TRP3_API.utils.message = Deprecated.setUpAPIDeprecatedWarning(TRP3_API.Messages, "Messaging", "TRP3_API.utils.message", "TRP3_API.Messages");
TRP3_API.utils.message.type = TRP3_API.Messages.TYPES;

-- Map API
TRP3_API.utils.str.buildZoneText = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.Map.getCurrentZoneText, "TRP3_API.utils.str.buildZoneText", "TRP3_API.Map.getCurrentZoneText");

-- TRP3 Events API
TRP3_API.events = Deprecated.setUpAPIDeprecatedWarning(TRP3_API.Events, "Events", "TRP3_API.events", "TRP3_API.Events");
-- Copy events to main table, as they used to be placed there before
for k, v in pairs(TRP3_API.Events.EVENTS) do
	TRP3_API.events[k] = v;
end

TRP3_API.slash = Deprecated.setUpAPIDeprecatedWarning(TRP3_API.Slash, "Slash", "TRP3_API.slash", "TRP3_API.Slash");

-- UI Animations
TRP3_API.ui.misc.playAnimation = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.Animations.playAnimation, "TRP3_API.ui.misc.playAnimation", "TRP3_API.Animations.playAnimation");

-- Popups
TRP3_API.popup = Deprecated.setUpAPIDeprecatedWarning(TRP3_API.Popups, "Popups", "TRP3_API.popup", "TRP3_API.Popups");

-- Frames API
TRP3_API.ui.frame = Deprecated.setUpAPIDeprecatedWarning(TRP3_API.Frames, "Frames", "TRP3_API.ui.frame", "TRP3_API.Frames");
TRP3_API.ui.frame.initResize = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.Frames.makeResizable, "TRP3_API.ui.frame.initResize", "TRP3_API.Frames.makeResizable");
TRP3_API.ui.frame.setupMove = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.Frames.makeMovable, "TRP3_API.ui.frame.setupMove", "TRP3_API.Frames.makeMovable");
TRP3_API.ui.frame.configureHoverFrame = Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.Frames.configureHoverFrame, "TRP3_API.ui.frame.configureHoverFrame", "TRP3_API.Frames.configureHoverFrame");

-- Tooltips
TRP3_API.ui.tooltip = Deprecated.setUpAPIDeprecatedWarning(TRP3_API.Tooltips, "Tooltips", "TRP3_API.ui.tooltip", "TRP3_API.Tooltips");