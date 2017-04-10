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

local testFunctionParameters = {
	targetedEquipmentSetID             = 0,
	targetEquipmentSetShouldBeEquipped = true
}

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


local function testFunction(testFunctionParameters, eventParameters)
	local equipmentSetWasSuccessfullyEquipped = eventParameters[2];
	if not equipmentSetWasSuccessfullyEquipped then
		return false
	end
	local equippedSetID = eventParameters[2];

	local targetEquipmentSetIsEquipped = testFunctionParameters.targetedEquipmentSetID == equippedSetID;

	return targetEquipmentSetIsEquipped == testFunctionParameters.targetEquipmentSetShouldBeEquipped;
end

---@type ColorMixin
local variableColor = TRP3_API.utils.color.CreateColor(1, 0.82, 0);

local function listDecorator(testFunctionParameters)
	local name, iconFileID, setID, isEquipped = GetEquipmentSetInfo(testFunctionParameters.targetedEquipmentSetID);

	local conditionText = testFunctionParameters.targetEquipmentSetShouldBeEquipped and "equip" or "unequip";

	if not name then
		name = "Unknown equipment set"
	end

	return ("When you %s equipment set %s."):format(
	variableColor:WrapTextInColorCode(conditionText),
	variableColor:WrapTextInColorCode(name)
	);
end

Automator.registerTrigger(
{
	["name"]          = "Equipment sets",
	["description"]   = "Adapt your profile when switching equipment sets",
	["id"]            = "equipment_set",
	["events"]        = { "EQUIPMENT_SWAP_FINISHED" },
	["testFunction"]  = testFunction,
	["icon"]          = "inv_misc_legarmorkit",
	["listDecorator"] = listDecorator
}
);