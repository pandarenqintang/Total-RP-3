----------------------------------------------------------------------------------
-- Total RP 3
-- Automator equipement sets module
-- ---------------------------------------------------------------------------
-- Copyright 2017 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
----------------------------------------------------------------------------------

---@type Automator
local Automator = TRP3_API.automator;


local pairs, tinsert = pairs, tinsert;

-- WoW API imports
local GetEquipmentSetIDs = C_EquipmentSet.GetEquipmentSetIDs;
local GetEquipmentSetInfo = C_EquipmentSet.GetEquipmentSetInfo;

local function listEquipmentSets()
	local equipmentSets = {};
	for _, equipmentSetID in pairs(GetEquipmentSetIDs()) do
		local name, iconFileID, setID, isEquipped = GetEquipmentSetInfo(equipmentSetID);
		tinsert(equipmentSets, {
			name       = name,
			iconFileID = iconFileID,
			setID      = setID,
			isEquipped = isEquipped
		})
	end
end


local function testFunction(equipmentTest, wasSuccessfullyEquiped, equipmentSetID)
	return wasSuccessfullyEquiped and equipmentTest == equipmentSetID
end

---@type ColorMixin
local variableColor = TRP3_API.utils.color.CreateColor(1, 0.82, 0);

Automator.registerTrigger(
{
	["name"]         = "Equipment sets",
	["description"]  = "Adapt your profile when switching equipment sets",
	["id"]           = "equipment_set",
	["events"]       = { "EQUIPMENT_SWAP_FINISHED" },
	["testFunction"] = testFunction,
	["icon"]         = "inv_misc_legarmorkit",
	["listDecorator"] = function(desiredEquipmentSetID)
		local name, iconFileID, setID, isEquipped = GetEquipmentSetInfo(desiredEquipmentSetID);
		return "When " .. variableColor:WrapTextInColorCode("switching equipment set") .. " to " .. variableColor:WrapTextInColorCode(name or UNKNOWN) .. ".";
	end
}
);