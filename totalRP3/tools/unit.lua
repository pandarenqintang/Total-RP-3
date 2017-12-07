----------------------------------------------------------------------------------
--- Total RP 3
---
---	Unit tools
---
--- Methods and tools related to a unit in the game.
--- Allows the creation of a Unit class
---
---	---------------------------------------------------------------------------
---	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
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

local Unit = {};
TRP3_API.Unit = Unit;

-- WoW imports
local UnitFullName = UnitFullName;
local CreateFromMixins = CreateFromMixins;
local GetGuildInfo = GetGuildInfo;
local UnitRace = UnitRace;
local UnitFactionGroup = UnitFactionGroup;
local UnitClass = UnitClass;
local UnitGUID = UnitGUID;

-- Total RP 3 imports
local Strings = TRP3_API.Strings;
local GUID = TRP3_API.GUID;

---@param unitID string @ A valid unit ID
---@return string guildName @ The name of the unit's guild
function Unit.getGuildName(unitID)
	local guildName = GetGuildInfo(unitID);
	return guildName;
end

---@param unitID string @ A valid unit ID
---@return string guildRank @ The guild rank name of the unit
function Unit.getGuildRank(unitID)
	local _, rank = GetGuildInfo(unitID);
	return rank;
end

---@param unitID string @ A valid unit ID
---@return string race @ The non localized race of the unit
function Unit.getRace(unitID)
	local _, race = UnitRace(unitID);
	return race;
end

---@param unitID string @ A valid unit ID
---@return string race @ The non localized class of the unit
function Unit.getClass(unitID)
	local _, class = UnitClass(unitID);
	return class;
end

---@param unitID string @ A valid unit ID
---@return string race @ The non localized faction of the unit
function Unit.getFaction(unitID)
	local faction = UnitFactionGroup(unitID);
	return faction;
end

---@return strings, string unitType, npcID @ The type of creature and the NPC ID
function Unit.getNPCData(unitID)
	return GUID.getNPCData(UnitGUID(unitID));
end

---@param unitID string @ A unit type ("target", "mouseover", etc.)
---@return string npcID @ The ID of the NPC
function Unit.getUnitNPCID(unitID)
	local unitType, npcID = Unit.getNPCData(unitID);
	return npcID;
end

--- Create a unit ID based on a targetType (target, player, mouseover ...)
--- The returned id can be nil.
---@param unit string @ Unit type ("player", "target", etc.)
---@return string unitID @ A properly formatted unit ID (PlayerName-RealmName)
function Unit.getUnitID(unit)
	local playerName, realm = UnitFullName(unit);
	if not playerName or playerName:len() == 0 or playerName == UNKNOWNOBJECT then
		return nil;
	end
	return Strings.unitInfoToID(playerName, realm);
end

---@class TRP3_UnitMixin
local UnitMixin = {};

---@param unitID string
function UnitMixin:OnLoad(unitID)
	self.unitID = unitID;
end

---@return string name @ The name of the unit
function UnitMixin:GetName()
	local name = Strings.unitIDToInfo(self.unitID);
	return name;
end

---@return string realm @ The realm of the unit
function UnitMixin:GetRealm()
	local _, realm = Strings.unitIDToInfo(self.unitID);
	return realm;
end

function UnitMixin:GetGUID()
	return UnitGUID(self.unitID);
end

---@return string guildName @ The name of the unit's guild
function UnitMixin:GetGuildName()
	return Unit.getGuildName(self.unitID);
end

---@return string guildRank @ The guild rank name of the unit
function UnitMixin:GetGuildRank()
	return Unit.getGuildRank(self.unitID);
end

---@return string race @ The non localized race of the unit
function UnitMixin:GetRace()
	return Unit.getRace(self.unitID);
end

---@return string race @ The non localized class of the unit
function UnitMixin:GetClass()
	return Unit.getClass(self.unitID);
end

---@return string race @ The non localized faction of the unit
function UnitMixin:GetFaction()
	return Unit.getFaction(self.unitID);
end

---@param unitID string @ A valid unitID
---@return TRP3_UnitMixin unit
function Unit.CreateFromID(unitID)
	---@type TRP3_UnitMixin
	local unit = CreateFromMixins({}, UnitMixin);
	unit:OnLoad(unitID);
	return unit;
end

---@param unitType string @ A unit type ("player", "target");
---@return TRP3_UnitMixin unit
function Unit.CreateFromType(unitType)
	local unitID = Unit.getUnitID(unitType);
	return Unit.CreateFromID(unitID);
end