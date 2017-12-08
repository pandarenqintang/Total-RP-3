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

-- WoW imports
local setmetatable = setmetatable;
local format = string.format;

-- Localization keys
local DEPRECATED_API_MOVED = [[Accessing Total RP 3's %s API via %s is deprecated and will be removed in version %s. Please use %s instead.]];
local DEPRECATED_FUNCTION = [[Function %s is deprecated and will be removed in version %s. Please use %s instead.]];

local NEXT_DEPRECATION_VERSION = "1.4.0";

local function setUpAPIDeprecatedWarning(newAPI, apiName, oldPath, newPath)
	return setmetatable({}, {
		__index = function(_, key)
			TRP3_API.Logs.warning(format(DEPRECATED_API_MOVED, apiName, oldPath, NEXT_DEPRECATION_VERSION, newPath));
			return newAPI[key];
		end,
	});
end

local function setUpDeprecatedFunctionWarning(newFunction, oldFunctionName, newFunctionName)
	return function(...)
		TRP3_API.Logs.warning(format(DEPRECATED_FUNCTION, oldFunctionName, NEXT_DEPRECATION_VERSION, newFunctionName));
		return newFunction(...);
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Will be deprecated in version 1.4.0
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- String API
TRP3_API.utils.str = setUpAPIDeprecatedWarning(TRP3_API.Strings, "Strings", "TRP3_API.utils.str", "TRP3_API.Strings");

-- HTML API
TRP3_API.utils.str.toHTML = setUpDeprecatedFunctionWarning(TRP3_API.HTML.convertTRP3TagsIntoHTML, "TRP3_API.utils.str.toHTML", "TRP3_API.HTML.convertTRP3TagsIntoHTML");

-- Colors API
TRP3_API.utils.color = setUpAPIDeprecatedWarning(TRP3_API.Colors, "Colors", "TRP3_API.utils.color", "TRP3_API.Colors");
TRP3_API.utils.color.CreateColor = setUpDeprecatedFunctionWarning(TRP3_API.Colors.createColor, "TRP3_API.utils.color.CreateColor", "TRP3_API.Colors.createColor");
TRP3_API.utils.color.getColorFromHexadecimalCode = setUpDeprecatedFunctionWarning(TRP3_API.Colors.createColorFromHexadecimalCode, "TRP3_API.utils.color.getColorFromHexadecimalCode", "TRP3_API.Colors.createColorFromHexadecimalCode");
TRP3_API.utils.color.GetClassColorByGUID = setUpDeprecatedFunctionWarning(TRP3_API.GUID.getClassColor, "TRP3_API.utils.color.GetClassColorByGUID", "TRP3_API.GUID.getClassColor");
TRP3_API.utils.color.GetCustomColorByGUID = setUpDeprecatedFunctionWarning(TRP3_API.GUID.getCustomColor, "TRP3_API.utils.color.GetCustomColorByGUID", "TRP3_API.GUID.getCustomColor");
TRP3_API.utils.color.getUnitColorByGUID = setUpDeprecatedFunctionWarning(TRP3_API.GUID.getUnitColor, "TRP3_API.utils.color.getUnitColorByGUID", "TRP3_API.GUID.getUnitColor");
TRP3_API.utils.color.getUnitCustomColor = setUpDeprecatedFunctionWarning(function(...)
	TRP3_API.register.getUnitCustomColor(...);
end , "TRP3_API.utils.color.getUnitCustomColor", "TRP3_API.register.getUnitCustomColor");
TRP3_API.utils.str.color = setUpDeprecatedFunctionWarning(TRP3_API.Colors.get, "TRP3_API.utils.str.color", "TRP3_API.Colors.get");

-- Events API
TRP3_API.utils.event = setUpAPIDeprecatedWarning(TRP3_API.Events, "Events", "TRP3_API.utils.event", "TRP3_API.Events");

-- GUID API
TRP3_API.utils.guid = setUpAPIDeprecatedWarning(TRP3_API.GUID, "GUID", "TRP3_API.utils.guid", "TRP3_API.GUID");
TRP3_API.utils.str.getUnitDataFromGUIDDirect = TRP3_API.GUID.getNPCData;

-- Locale API
TRP3_API.locale = setUpAPIDeprecatedWarning(TRP3_API.Locale, "Locale", "TRP3_API.locale", "TRP3_API.Locale");

-- Logs API
-- Note we will avoid throwing warning when using the old logging API because it is already chatty enough and can lead to infinite loops :P
TRP3_API.utils.log = {};
print("Mapping log");
TRP3_API.utils.log.level = TRP3_API.Logs.LEVELS;
TRP3_API.utils.log.log = function(message, level)
	if not level then level = TRP3_API.Logs.LEVELS.INFO end
	TRP3_API.Logs.log(level, message);
end

-- Sounds API
TRP3_API.utils.music = setUpAPIDeprecatedWarning(TRP3_API.Sounds, "Sounds", "TRP3_API.utils.music", "TRP3_API.Sounds");
-- Manually register a played sound callback for Extended's sound history frame
TRP3_API.Sounds.registerOnSoundPlayedCallback(function()
	if TRP3_SoundsHistoryFrame then
		TRP3_SoundsHistoryFrame.onSoundPlayed();
	end
end);

-- Tables API
TRP3_API.utils.table = setUpAPIDeprecatedWarning(TRP3_API.Tables, "Tables", "TRP3_API.utils.table", "TRP3_API.Tables");

-- Textures API
TRP3_API.utils.texture = setUpAPIDeprecatedWarning(TRP3_API.Textures, "Textures", "TRP3_API.utils.texture", "TRP3_API.Textures");
TRP3_API.utils.str.texture = setUpDeprecatedFunctionWarning(TRP3_API.Textures.tag, "TRP3_API.utils.str.texture", "TRP3_API.Textures.tag");
TRP3_API.utils.str.icon = setUpDeprecatedFunctionWarning(TRP3_API.Textures.iconTag, "TRP3_API.utils.str.icon", "TRP3_API.Textures.iconTag");

-- Unit API
TRP3_API.utils.str.GetGuildName = setUpDeprecatedFunctionWarning(TRP3_API.Unit.getGuildName, "TRP3_API.utils.str.GetGuildName", "TRP3_API.Unit.getGuildName");
TRP3_API.utils.str.GetGuildRank = setUpDeprecatedFunctionWarning(TRP3_API.Unit.getGuildRank, "TRP3_API.utils.str.GetGuildRank", "TRP3_API.Unit.getGuildRank");
TRP3_API.utils.str.GetRace = setUpDeprecatedFunctionWarning(TRP3_API.Unit.getRace, "TRP3_API.utils.str.GetRace", "TRP3_API.Unit.getRace");
TRP3_API.utils.str.GetClass = setUpDeprecatedFunctionWarning(TRP3_API.Unit.getClass, "TRP3_API.utils.str.GetClass", "TRP3_API.Unit.getClass");
TRP3_API.utils.str.GetFaction = setUpDeprecatedFunctionWarning(TRP3_API.Unit.getFaction, "TRP3_API.utils.str.GetFaction", "TRP3_API.Unit.getFaction");
TRP3_API.utils.str.getUnitDataFromGUID = setUpDeprecatedFunctionWarning(TRP3_API.Unit.getNPCData, "TRP3_API.utils.str.getUnitDataFromGUID", "TRP3_API.Unit.getNPCData");
TRP3_API.utils.str.getUnitNPCID = setUpDeprecatedFunctionWarning(TRP3_API.Unit.getUnitNPCID, "TRP3_API.utils.str.getUnitNPCID", "TRP3_API.Unit.getUnitNPCID");
TRP3_API.utils.str.getUnitID = setUpDeprecatedFunctionWarning(TRP3_API.Unit.getUnitID, "TRP3_API.utils.str.getUnitID", "TRP3_API.Unit.getUnitID");