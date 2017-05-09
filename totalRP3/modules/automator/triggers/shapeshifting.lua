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

local loc = TRP3_API.locale.getText;

-- WoW API imports
local UnitRace, UnitClassBase = UnitRace, UnitClassBase;
local select = select;
local format = string.format;
local GetShapeshiftFormID, GetShapeshiftFormInfo, GetShapeshiftForm = GetShapeshiftFormID, GetShapeshiftFormInfo, GetShapeshiftForm;

local SHAPESHIFT_FORMS      = {
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

local SHAPESHIFT_FORM_NAMES = {
	CAT      = loc("ATM_SHAPE_FORM_CAT"),
	TRAVEL   = loc("ATM_SHAPE_FORM_TRAVEL"),
	AQUATIC  = loc("ATM_SHAPE_FORM_AQUATIC"),
	BEAR     = loc("ATM_SHAPE_FORM_BEAR"),
	FLIGHT   = loc("ATM_SHAPE_FORM_FLIGHT"),
	MOONKIN  = loc("ATM_SHAPE_FORM_MOONKIN"),
	AFFINITY = loc("ATM_SHAPE_FORM_AFFINITY"),
	TREANT   = loc("ATM_SHAPE_FORM_TREANT")
}

local PLAYER_CLASS          = select(2, UnitClassBase("player"));

local function getCurrentForm()
	-- Check if the player is of a class who can shapeshift into a known shapeshift form
	if SHAPESHIFT_FORMS[PLAYER_CLASS] then
		local formID = GetShapeshiftFormID();
		if SHAPESHIFT_FORMS[PLAYER_CLASS][formID] then
			return SHAPESHIFT_FORMS[PLAYER_CLASS][formID];
		end
	end
	return "DEFAULT"
end

local testFunctionParameters = {
	desiredForm = 1
}
local function testFunction(testFunctionParameters)
	return testFunctionParameters.desiredForm == getCurrentForm();
end

---@type ColorMixin
local variableColor = TRP3_API.utils.color.CreateColor(1, 0.82, 0);

local function listDecorator(testFunctionParameters)
	local formName = SHAPESHIFT_FORM_NAMES[testFunctionParameters.desiredForm] or loc("ATM_SHAPE_UNKNOWN");

	return format(loc("ATM_SHAPE_DECORATOR"),
	variableColor:WrapTextInColorCode(loc("ATM_SHAPE_DECORATOR_VERB")),
	variableColor:WrapTextInColorCode(formName)
	);
end

local function isAvailable()
	return SHAPESHIFT_FORMS[PLAYER_CLASS] ~= nil;
end

Automator.registerTrigger(
{
	["name"]          = loc("ATM_SHAPE_NAME"),
	["description"]   = loc("ATM_SHAPE_DESCRIPTION"),
	["id"]            = "shapeshifting",
	["events"]        = { "UPDATE_SHAPESHIFT_FORM" },
	["icon"]          = "Ability_Druid_MasterShapeshifter",
	["testFunction"]  = testFunction,
	["listDecorator"] = listDecorator,
	["isAvailable"] = isAvailable
}
);