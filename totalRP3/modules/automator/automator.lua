----------------------------------------------------------------------------------
-- Total RP 3
-- Automator module
-- Bring automation to Total RP 3
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

-- Public access
---@class Automator
local Automator = {};
TRP3_API.automator = Automator;

local log = TRP3_API.utils.log.log;

local function logFormat(text, ...)
	log(text:format(...));
end

local assert = assert;
local unpack, strjoin, pairs = unpack, strjoin, pairs;

local automatorTriggers = {};

---registerTrigger
---@param triggerStructure table
function Automator.registerTrigger(triggerStructure)

	assert(triggerStructure, "Automator trigger structure can't be nil");

	assert(triggerStructure.id, "Illegal trigger structure. An automator trigger must have an id field!");
	assert(triggerStructure.testFunction, "Illegal trigger structure. An automator trigger must have a testFunction!");

	assert(not automatorTriggers[triggerStructure.id], "This automator trigger is already register: " .. triggerStructure.id);

	if not triggerStructure.name or not type(triggerStructure.name) == "string" or triggerStructure.name:len() == 0 then
		triggerStructure.name = triggerStructure.id;
	end

	automatorTriggers[triggerStructure.id] = triggerStructure;

	logFormat("Trigger registered: %s", triggerStructure.id);

end

local automatorModifications = {};

---registerModification
---@param modificationStructure table
function Automator.registerModification(modificationStructure)

	assert(modificationStructure, "Automator modification structure can't be nil");

	assert(modificationStructure.id, "Illegal modification structure. Automator modification must have an id field!");
	assert(modificationStructure.modificationFunction, "Illegal modification structure. Automator modification must have modificationFunction!");

	assert(not automatorModifications[modificationStructure.id], "This automator modification is already register: " .. modificationStructure.id);

	if not modificationStructure.name or not type(modificationStructure.name) == "string" or modificationStructure.name:len() == 0 then
		modificationStructure.name = modificationStructure.id;
	end

	automatorModifications[modificationStructure.id] = modificationStructure;

	logFormat("Modification registered: %s", modificationStructure.id);

end

local function onStart()

	local registerHandler = TRP3_API.utils.event.registerHandler;

	local druidVariations = {
		{
			variationName                 = "Kitty",
			triggerID                     = "shapeshifting",
			triggerTestFunctionParameters = { "CAT" },
			modifications                 = {
				{
					modificationID                = "characteristics",
					modifcationFunctionParameters = { {
						CH = "5A97BB",
						IC = "TalentSpec_Druid_Feral_Cat";
						TI = "Kitty cat"
					} }
				}
			}
		},
		{
			variationName                 = "Bear",
			triggerID                     = "shapeshifting",
			triggerTestFunctionParameters = { "BEAR" },
			modifications                 = {
				{
					modificationID                = "characteristics",
					modifcationFunctionParameters = { {
						CH = "AE592D",
						IC = "TalentSpec_Druid_Feral_Bear",
						TI = "Tanky"
					} }
				}
			}
		},
		{
			variationName                 = "Healing spec",
			triggerID                     = "specialization",
			triggerTestFunctionParameters = { 4 },
			modifications                 = {
				{
					modificationID                = "characteristics",
					modifcationFunctionParameters = { {
						FT = "Healer"
					} }
				}
			}
		},
		{
			variationName                 = "Tank spec",
			triggerID                     = "specialization",
			triggerTestFunctionParameters = { 3 },
			modifications                 = {
				{
					modificationID                = "characteristics",
					modifcationFunctionParameters = { {
						FT = "Guardian"
					} }
				}
			}
		},
		{
			variationName                 = "Tanking set",
			triggerID                     = "equipment_set",
			triggerTestFunctionParameters = { 2 },
			modifications                 = {
				{
					modificationID                = "characteristics",
					modifcationFunctionParameters = { {
						FT = "Avec tabard"
					} }
				}
			}
		},
		{
			variationName                 = "Tanking set",
			triggerID                     = "equipment_set",
			triggerTestFunctionParameters = { 4 },
			modifications                 = {
				{
					modificationID                = "characteristics",
					modifcationFunctionParameters = { {
						FT = "Sans tabard"
					} }
				}
			}
		}
	}

	local variations = {
		{
			variationName                 = "In worgen form",
			triggerID                     = "worgen_form",
			triggerTestFunctionParameters = { true },
			modifications                 = {
				{
					modificationID                = "characteristics",
					modifcationFunctionParameters = { {
						IC = "Ability_Racial_Viciousness",
						CH = "87939A",
						RA = "Worgen"
					} }
				}
			}
		},
		{
			variationName                 = "In human form",
			triggerID                     = "worgen_form",
			triggerTestFunctionParameters = { false },
			modifications                 = {
				{
					modificationID                = "characteristics",
					modifcationFunctionParameters = { {
						IC = "Achievement_Character_Human_Female",
						CH = "30A3E1",
						RA = "Human"
					} }
				}
			}
		}
	}

	for _, variation in pairs(variations) do
		logFormat("Handling variation: %s", variation.variationName);

		logFormat("Registering events for trigger %s", variation.triggerID);
		assert(automatorTriggers[variation.triggerID], "Unkown trigger " .. variation.triggerID .. " for variation " .. variation.variationName);
		local trigger = automatorTriggers[variation.triggerID];

		if trigger.isAvailable and not trigger.isAvailable() then
			logFormat("Ignored trigger %s as it is not available for this character", trigger.name);

		else
			local events = trigger.events or variations.triggerTestFunctionParameters.events or {};

			for _, event in pairs(events) do

				-- Register a handler for each event
				registerHandler(event, function(...)

					logFormat("Event %s fired", event)
					logFormat("Testing trigger %s with parameters %s", variation.triggerID, tostring(strjoin(", ", unpack(variation.triggerTestFunctionParameters))));

					-- Check if the trigger condition is validated
					-- We pass the function parameters defined in the variation and also the event parameters
					if trigger.testFunction(variation.triggerTestFunctionParameters, {...}) then

						logFormat("Trigger %s was true.", variation.triggerID);

						for _, modification in pairs(variation.modifications) do
							logFormat("Applying modification %s", modification.modificationID);
							assert(automatorModifications[modification.modificationID],
								   "Unkown modification executed in variation " .. variation.variationName .. ": " .. modification.modificationID);

							automatorModifications[modification.modificationID].modificationFunction(unpack(modification.modifcationFunctionParameters));
						end

					else

						logFormat("Trigger %s was false.", variation.triggerID);

					end
				end )

				logFormat("Registered event %s", event)
			end
		end
	end

	---@type ColorMixin
	local variableColor = TRP3_API.utils.color.CreateColor(1, 0.82, 0);
	local function onVariationsPageShow()
		for i, variation in pairs(variations) do
			if i > 5 then
				break
			end
			local line = _G["TRP3_AutomatorListListLine" .. i];

			line.Title:SetText(variation.variationName);

			local triggerAction = automatorTriggers[variation.triggerID];

			if triggerAction.listDecorator then
				line.SubTitle:SetText(triggerAction.listDecorator(unpack(variation.triggerTestFunctionParameters)));
			else
				line.SubTitle:SetText("When " .. variableColor:WrapTextInColorCode(triggerAction.name) .. " is " .. variableColor:WrapTextInColorCode(strjoin(", ", unpack(variation.triggerTestFunctionParameters))));
			end

			if triggerAction.icon then
				line.Icon:SetTexture("Interface\\ICONS\\" .. triggerAction.icon)
			end

			if triggerAction.isAvailable and not triggerAction.isAvailable() then
				--TODO Tooltip about how the trigger is not available for this character
				line.Icon:SetVertexColor(1, 0, 0);
			else
				line.Icon:SetVertexColor(1, 1, 1);
			end
		end
	end

	TRP3_API.navigation.menu.registerMenu(
	{
		id         = "main_19_player_automator",
		text       = "Variations",
		onSelected = function()
			TRP3_API.navigation.page.setPage("player_automator");
		end,
		isChildOf  = "main_10_player",
	}
	);

	TRP3_API.navigation.page.registerPage(
	{
		id               = "player_automator",
		frame            = TRP3_AutomatorList,
		onPagePostShow   = onVariationsPageShow,
		tutorialProvider = function()
			return {};
		end,
	}
	);
end


-- Register a Total RP 3 trigger that can be disabled in the settings
TRP3_API.module.registerModule(
{
	["name"]        = "Automator",
	["description"] = "Bring automation to Total RP 3.",
	["version"]     = 0.1,
	["id"]          = "trp3_automator",
	["onStart"]     = onStart,
	["minVersion"]  = 27
}
);