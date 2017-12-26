----------------------------------------------------------------------------------
--- Total RP 3
---
---    Map tools
---
---    ---------------------------------------------------------------------------
---    Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
---    Copyright 2017 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
---    Licensed under the Apache License, Version 2.0 (the "License");
---    you may not use this file except in compliance with the License.
---    You may obtain a copy of the License at
---
---        http://www.apache.org/licenses/LICENSE-2.0
---
---    Unless required by applicable law or agreed to in writing, software
---    distributed under the License is distributed on an "AS IS" BASIS,
---    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
---    See the License for the specific language governing permissions and
---    limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;

local Map = {};
TRP3_API.Map = Map;

-- WoW imports
local getZoneText, getSubZoneText = GetZoneText, GetSubZoneText;
local UnitPosition = UnitPosition;
local GetCurrentMapAreaID = GetCurrentMapAreaID;
local GetPlayerMapPosition = GetPlayerMapPosition;
local strconcat = strconcat;

-- Total RP 3 imports
local warning = TRP3_API.Logs.warning;

--- Returns the current zone text, with the sub-zone appended to it if there is one by default
---@param includeSubzone boolean @ Indicates if the sub-zone text should be included (defaults to true)
---@return string zoneText @ The current zone text
function Map.getCurrentZoneText(includeSubZone)
	if includeSubZone == nil then
		includeSubZone = true;
	end
	local text = getZoneText() or ""; -- assuming that there is ALWAYS a zone text. Don't know if it's true.
	if includeSubZone and getSubZoneText():len() > 0 then
		text = strconcat(text, " - ", getSubZoneText());
	end
	return text;
end

--- Check if the user is in a restricted zone where many of the map functions are disabled (dungeon, raid, battleground, arena, etc.)
--- @return boolean playerIsInARestrictedZone @ Returns true if the player is in a restricted zone
function Map.playerIsInARestrictedZone()
	local x, y = UnitPosition("player");
	if not x or not y then
		return true;
	end
	return false;
end

function Map.getCurrentCoordinates()
	local mapID = GetCurrentMapAreaID();
	if Map.playerIsInARestrictedZone() then
		warning("Could not get correct coordinates for player, player might be in a restricted zone.");
		return mapID, 0, 0;
	else
		local x, y = GetPlayerMapPosition("player");
		return mapID, x, y;
	end
end