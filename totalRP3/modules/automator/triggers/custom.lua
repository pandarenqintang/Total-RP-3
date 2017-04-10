----------------------------------------------------------------------------------
--- Total RP 3
--- Automator custom trigger
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

local testFunctionParameters = {
	customTestFunctionDescription = "My custom test",
	customTestFunction = function(eventParameters) end,
	events = {}
}
local function testFunction(testFunctionParameters, eventParameters)
	return testFunctionParameters.customTestFunction(eventParameters);
end

---@type ColorMixin
local variableColor = TRP3_API.utils.color.CreateColor(1, 0.82, 0);

local function listDecorator(testFunctionParameters)
	return ("When your custom trigger %s into %s"):format(
	variableColor:WrapTextInColorCode(testFunctionParameters.customTestFunctionDescription),
	variableColor:WrapTextInColorCode("true")
	);
end

local function isAvailable()
	return true;
end

Automator.registerTrigger(
{
	["name"]          = "Custom trigger",
	["description"]   = "Adapt your profile according to custom a custom trigger.",
	["id"]            = "custom_trigger",
	["icon"]          = "INV_Eng_GearspringParts",

	["testFunction"]  = testFunction,
	["listDecorator"] = listDecorator,
	["isAvailable"]   = isAvailable
}
);