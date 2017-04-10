----------------------------------------------------------------------------------
-- Total RP 3
-- Automator auras module
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

------@type Automator
local Automator = TRP3_API.automator;

-- WoW API imports
local GetSpecialization = GetSpecialization;
local GetSpecializationInfo = GetSpecializationInfo;
local GetNumSpecializations = GetNumSpecializations;
local UnitSex = UnitSex;
local tinsert = tinsert;

local sex = UnitSex("player");

---Shortcut to GetSpecializationInfo(specID, isInspect, isPet, inspectTarget, gender) with the all the other parameters already populated.
---@param specializationID number
local function getPlayerSpecializationInfo(specializationID)
	return GetSpecializationInfo(specializationID, nil, nil, nil, sex)
end

local function getAvailableSpecializations()
	local availableSpecializations = {};
	local sex = UnitSex("player");
	for i = 1, GetNumSpecializations() do
		local id, name, description, icon, background, role = GetSpecializationInfo(i, nil, nil, nil, sex);
		tinsert(availableSpecializations, {
			id          = id,
			name        = name,
			description = description,
			icon        = icon,
			background  = background,
			role        = role
		})
	end
end

local testFunctionParameters = {
	targetedSpecializationID = 1
}
---@param testFunctionParameters table
local function testFunction(testFunctionParameters)
	return testFunctionParameters.targetedSpecializationID == GetSpecialization();
end

---@type ColorMixin
local variableColor = TRP3_API.utils.color.CreateColor(1, 0.82, 0);

local function listDecorator(testFunctionParameters)
	local id, name, description, icon, background, role = getPlayerSpecializationInfo(testFunctionParameters.targetedSpecializationID);

	if not name then name = UNKNOWN end

	return ("When you %s to your %s specialization."):format(
	variableColor:WrapTextInColorCode("switching specialization"),
	variableColor:WrapTextInColorCode(name)
	);
end

Automator.registerTrigger(
{
	["name"]          = "Specializations",
	["description"]   = "Adapt your profile when you switch specializations.",
	["id"]            = "specialization",
	["events"]        = { "ACTIVE_TALENT_GROUP_CHANGED" },
	["icon"]          = "Inv_7XP_Inscription_TalentTome02",
	["testFunction"]  = testFunction,
	["listDecorator"] = listDecorator
}
);