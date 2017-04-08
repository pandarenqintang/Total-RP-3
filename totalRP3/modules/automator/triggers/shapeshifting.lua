----------------------------------------------------------------------------------
--- Total RP 3
--- Automator shapeshifting module
--- ---------------------------------------------------------------------------
--- Copyright 2017 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@type Automator
local Automator = TRP3_API.automator;

-- WoW API imports
local UnitRace, UnitClassBase = UnitRace, UnitClassBase;
local select = select;
local GetShapeshiftFormID, GetShapeshiftFormInfo, GetShapeshiftForm = GetShapeshiftFormID, GetShapeshiftFormInfo, GetShapeshiftForm;
local HasAlternateForm = HasAlternateForm;

local SHAPESHIFT_FORMS = {
	DRUID  = {
		[1]  = "CAT",
		[3]  = "TRAVEL",
		[4]  = "AQUATIC",
		[5]  = "BEAR",
		[27] = "FLIGHT",
		[29] = "FLIGHT",
		[31] = "MOONKIN",
		[35] = "AFFINITY",
		[36] = "TREANT",
	},
	SHAMAN = {
		[16] = "GHOSTWOLF",
	},
	PRIEST = {
		[28] = "SHADOWFORM",
	}
}

local WORGEN_FORMS     = {
	WORGEN = "WORGEN",
	HUMAN  = "HUMAN"
}

local PLAYER_CLASS     = select(2, UnitClassBase("player"));
local PLAYER_IS_WORGEN = select(2, UnitRace("player")) == "Worgen";

local function playerIsInWorgenForm()
	return not select(2, HasAlternateForm());
end

local function getCurrentForm()
	-- Check if the player is of a class who can shapeshift into a known shapeshift form
	if SHAPESHIFT_FORMS[PLAYER_CLASS] then
		local formID = GetShapeshiftFormID();
		if SHAPESHIFT_FORMS[PLAYER_CLASS][formID] then
			return SHAPESHIFT_FORMS[PLAYER_CLASS][formID];
		end
	end
	if PLAYER_IS_WORGEN then
		return playerIsInWorgenForm() and WORGEN_FORMS.WORGEN or WORGEN_FORMS.HUMAN;
	end
	return "DEFAULT"
end


local function testFunction(desiredForm)
	return desiredForm == getCurrentForm();
end

Automator.registerTrigger(
{
	["name"]         = "Shapeshifting",
	["description"]  = "Adapt your profile when shapeshifting",
	["id"]           = "shapeshifting",
	["events"]       = { "UPDATE_SHAPESHIFT_FORM" },
	["testFunction"] = testFunction
}
);