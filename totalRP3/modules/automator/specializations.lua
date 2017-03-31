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
local function init()
	
	-- WoW API imports
	local GetSpecialization = GetSpecialization;
	local GetSpecializationInfoByID = GetSpecializationInfoByID;
	local GetSpecializationInfo = GetSpecializationInfo;
	local GetNumSpecializations = GetNumSpecializations;
	local UnitSex = UnitSex;
	local tinsert = tinsert;
	
	local function getCurrentSpecialization()
		local sex = UnitSex("player");
		return GetSpecializationInfoByID(GetSpecialization(), nil, nil, nil, sex);
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
	
	TRP3_API.events.listenToEvent("ACTIVE_TALENT_GROUP_CHANGED", function()
		print("Current spec", getCurrentSpecialization());
	end)
	
end

TRP3_API.automator.registerModule({
	["name"] = "Specializations",
	["description"] = "Adapt your profile when you switch specializations.",
	["id"] = "specializations",
	["init"] = init
});