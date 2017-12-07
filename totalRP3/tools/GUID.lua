----------------------------------------------------------------------------------
--- Total RP 3
---
--- GUID tools
---
--- Provides helper functions to handle and get stuff from the game's GUIDs
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

local GUID = {};
TRP3_API.GUID = GUID;

-- WoW imports
local assert = assert;
local strsplit = strsplit;
local GetPlayerInfoByGUID = GetPlayerInfoByGUID;

-- Total RP 3 imports
local isType = TRP3_API.Assertions.isType;

--[[
http://wow.gamepedia.com/API_UnitGUID
GUID formats (since 6.0.2):

For players: Player-[server ID]-[player UID] (Example: "Player-976-0002FD64")
For creatures, pets, objects, and vehicles: [Unit type]-0-[server ID]-[instance ID]-[zone UID]-[ID]-[Spawn UID] (Example: "Creature-0-976-0-11-31146-000136DF91")
Unit Type Names: "Creature", "Pet", "GameObject", and "Vehicle"
For vignettes: Vignette-0-[server ID]-[instance ID]-[zone UID]-0-[spawn UID] (Example: "Vignette-0-970-1116-7-0-0017CAE465" for rare mob Sulfurious)
 ]]
local GUID_TYPES = {
	PLAYER = "Player",
	CREATURE = "Creature",
	PET = "Pet",
	GAME_OBJECT = "GameObject",
	VEHICLE = "Vehicle",
	VIGNETTE = "Vignette"
}

--- Extract the unit type from the GUID
---@param guid string
---@return string unitType
function GUID.getUnitType(guid)
	assert(isType(guid, "string", "guid"));
	return guid:match("%a+");
end

--- Check that the given GUID is correctly formatted to be a player GUID
--- @param guid string
--- @return boolean isAPlayerGUID @ Returns true if the GUID belongs to a player
function GUID.isAPlayerGUID(guid)
	assert(isType(guid, "string", "guid"));
	return GUID.getUnitType(guid) == GUID_TYPES.PLAYER;
end

---@param guid string
---@return TRP3_ColorMixin|nil
function GUID.getClassColor(guid)
	assert(isType(guid, "string", "guid"));
	local _, englishClass = GetPlayerInfoByGUID(guid);
	if englishClass then
		return TRP3_API.Colors.getClassColor(englishClass);
	else
		TRP3_API.Logs.warning("Tried to get class color from a GUID that returned no englishClass", GUID);
	end
end

---@param guid string
---@return TRP3_ColorMixin|nil
function GUID.getCustomColor(guid)
	assert(isType(guid, "string", "guid"));
	local _, _, _, _, _, name, realm = GetPlayerInfoByGUID(guid);
	local unitID = TRP3_API.utils.str.unitInfoToID(name, realm);
	return TRP3_API.register.getUnitCustomColor(unitID)
end

--- Returns the color for the unit corresponding to the given GUID.
--- @param GUID string @ The GUID to use to retrieve player information
--- @param optional useCustomColors boolean @ If we should use custom color or not (usually defined in settings)
--- @param optional lightenColorUntilItIsReadable boolean @ If we should increase the color so it is readable on dark background (usually defined in settings)
--- @return TRP3_ColorMixin|nil color @ The color corresponding to GUID
function GUID.getUnitColor(guid, useCustomColors, lightenColorUntilItIsReadable)
	assert(isType(guid, "string", "GUID"));

	if useCustomColors then
		local color = GUID.getCustomColor(guid);
		if lightenColorUntilItIsReadable then
			color:LightenColorUntilItIsReadable();
		end
		return color;
	else
		return GUID.getClassColor(guid);
	end
end

function GUID.getNPCData(GUID)
	local unitType, _, _, _, _, npcID = strsplit("-", GUID or "");
	return unitType, npcID;
end