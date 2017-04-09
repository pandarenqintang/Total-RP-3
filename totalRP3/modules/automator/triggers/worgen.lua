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
local HasAlternateForm = HasAlternateForm;


local function testFunction(shouldBeInWorgenForm)
	return shouldBeInWorgenForm == not select(2, HasAlternateForm());
end

---@type ColorMixin
local variableColor = TRP3_API.utils.color.CreateColor(1, 0.82, 0);

Automator.registerTrigger(
{
	["name"]          = "Worgen form",
	["description"]   = "Adapt your profile when going into your human or your worgen form",
	["id"]            = "worgen_form",
	["events"]        = { "UNIT_PORTRAIT_UPDATE" },
	["testFunction"]  = testFunction,
	["icon"]          = "achievement_worganhead",
	["listDecorator"] = function(shouldBeInWorgenForm)
		return "When " .. variableColor:WrapTextInColorCode("you transform") .. " into " .. variableColor:WrapTextInColorCode(shouldBeInWorgenForm and "a worgen" or "a human");
	end,
	["available"]     = function()
		return select(2, UnitRace("player")) == "Worgen";
	end
}
);