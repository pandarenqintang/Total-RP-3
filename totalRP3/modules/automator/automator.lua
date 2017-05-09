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
local Automator = {
	enabled = false
};
TRP3_API.automator = Automator;
local log = TRP3_API.utils.log.log;

local function logFormat(text, ...)
	log(text:format(...));
end

local assert = assert;
local format = string.format;
local unpack, strjoin, pairs = unpack, strjoin, pairs;

local tcopy = TRP3_API.utils.table.copy;
local treverse = TRP3_API.utils.table.reverse;
local getProfile = TRP3_API.profile.getData;
local setTooltipForFrame = TRP3_API.ui.tooltip.setTooltipForFrame;
local loc = TRP3_API.locale.getText;

function Automator.getPlayerProfileWithActiveVariations()
	local profile = tcopy(getProfile("player"));
	if Automator.enabled then
		Automator.applyActiveVariationsToProfile(profile);
	end
	return profile;
end


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

	Automator.enabled = true;

	local activeVariations = {};

	local registerHandler = TRP3_API.utils.event.registerHandler;

	local druidVariations = {
		{
			variationName = "Kitty",
			triggerID = "shapeshifting",
			triggerTestFunctionParameters = { "CAT" },
			modifications = {
				{
					modificationID = "characteristics",
					modificationFunctionParameters = { {
						CH = "5A97BB",
						IC = "TalentSpec_Druid_Feral_Cat";
						TI = "Kitty cat"
					} }
				}
			}
		},
		{
			variationName = "Bear",
			triggerID = "shapeshifting",
			triggerTestFunctionParameters = { "BEAR" },
			modifications = {
				{
					modificationID = "characteristics",
					modificationFunctionParameters = { {
						CH = "AE592D",
						IC = "TalentSpec_Druid_Feral_Bear",
						TI = "Tanky"
					} }
				}
			}
		},
		{
			variationName = "Healing spec",
			triggerID = "specialization",
			triggerTestFunctionParameters = { 4 },
			modifications = {
				{
					modificationID = "characteristics",
					modificationFunctionParameters = { {
						FT = "Healer"
					} }
				}
			}
		},
		{
			variationName = "Tank spec",
			triggerID = "specialization",
			triggerTestFunctionParameters = { 3 },
			modifications = {
				{
					modificationID = "characteristics",
					modificationFunctionParameters = { {
						FT = "Guardian"
					} }
				}
			}
		},
		{
			variationName = "Tanking set",
			triggerID = "equipment_set",
			triggerTestFunctionParameters = { 2 },
			modifications = {
				{
					modificationID = "characteristics",
					modificationFunctionParameters = { {
						FT = "Avec tabard"
					} }
				}
			}
		},
		{
			variationName = "Tanking set",
			triggerID = "equipment_set",
			triggerTestFunctionParameters = { 4 },
			modifications = {
				{
					modificationID = "characteristics",
					modificationFunctionParameters = { {
						FT = "Sans tabard"
					} }
				}
			}
		}
	}

	local variations = {
		[1] = {
			variationName = "In worgen form",
			triggerID = "worgen_form",
			triggerTestFunctionParameters = { true },
			modifications = {
				{
					modificationID = "characteristics",
					modificationFunctionParameters = { {
						IC = "Ability_Racial_Viciousness",
						CH = "87939A",
						RA = "Worgen"
					} }
				}
			}
		},
		[2] = {
			variationName = "In human form",
			triggerID = "worgen_form",
			triggerTestFunctionParameters = { false },
			modifications = {
				{
					modificationID = "characteristics",
					modificationFunctionParameters = { {
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
					variations.isActive = trigger.testFunction(variation.triggerTestFunctionParameters, { ... })
					logFormat("Trigger %s was %s.", variation.triggerID, variations.isActive);
				end )

				logFormat("Registered event %s", event)
			end
		end
	end



	--- Apply the currently active variations to the give profile
	---    @param profile table
	--- @return table
	function Automator.applyActiveVariationsToProfile(profile)

		for _, variation in pairs(variations) do
			if variation.isActive then
				for _, modification in pairs(variation.modifications) do
					logFormat("Applying modification %s", modification.modificationID);
					assert(automatorModifications[modification.modificationID],
					"Unkown modification executed in variation " .. variation.variationName .. ": " .. modification.modificationID);
					automatorModifications[modification.modificationID].modificationFunction(profile, unpack(modification.modificationFunctionParameters));
				end
			end
		end

		return profile
	end


	---@type ColorMixin
	local variableColor = TRP3_API.utils.color.CreateColor(1, 0.82, 0);
	local function onVariationsPageShow()

		-- Variations are applied from the start of the table to then end of the table,
		-- but should be presented as the latest applied being on top in the UI.
		-- So we create a copy of the table and reverse its order.
		local variations = treverse(tcopy(variations));

		for i, variation in pairs(variations) do
			if i > 5 then
				break
			end
			local line = _G["TRP3_AutomatorListListLine" .. i];

			local tooltipText = "";

			line.Title:SetText(variation.variationName);

			local trigger = automatorTriggers[variation.triggerID];

			if trigger.listDecorator then
				line.SubTitle:SetText(trigger.listDecorator(unpack(variation.triggerTestFunctionParameters)));
			else
				line.SubTitle:SetText(format(
				loc("ATM_DEFAULT_TRIGGER_DECORATOR"),
				variableColor:WrapTextInColorCode(trigger.name),
				variableColor:WrapTextInColorCode(strjoin(", ", unpack(variation.triggerTestFunctionParameters)))
				));
			end

			tooltipText = tooltipText .. "\n".. line.SubTitle:GetText();

			if trigger.icon then
				line.Icon:SetTexture("Interface\\ICONS\\" .. trigger.icon)
			end

			-- Check if this trigger trigger is available for the current character
			-- Since profiles can be shared across multiple characters of different specs, classes, etc.
			-- If there is no isAvailable() function for the trigger, we assume it is always available
			if trigger.isAvailable and not trigger.isAvailable() then
				--TODO Tooltip about how the trigger is not available for this character
				line.Icon:SetVertexColor(1, 0, 0);
				tooltipText = tooltipText .. "\n" .. loc("ATM_TRIGGER_UNAVAILABLE");
			else
				line.Icon:SetVertexColor(1, 1, 1);
			end

			setTooltipForFrame(line, line, "RIGHT", 0, -30, -- Tooltip position
			variation.variationName, -- Tooltip title
			tooltipText -- Tooltip content
			)
		end
	end

	TRP3_API.navigation.menu.registerMenu(
	{
		id = "main_19_player_automator",
		text = loc("ATM_MENU"),
		onSelected = function()
			TRP3_API.navigation.page.setPage("player_automator");
		end,
		isChildOf = "main_10_player",
	}
	);

	TRP3_API.navigation.page.registerPage(
	{
		id = "player_automator",
		frame = TRP3_AutomatorList,
		onPagePostShow = onVariationsPageShow,
		tutorialProvider = function()
			return {};
		end,
	}
	);
end


-- Register a Total RP 3 trigger that can be disabled in the settings
TRP3_API.module.registerModule(
{
	["name"] = loc("ATM_MODULE_NAME"),
	["description"] = loc("ATM_MODULE_DESCRIPTION"),
	["version"] = 0.1,
	["id"] = "trp3_automator",
	["onStart"] = onStart,
	["minVersion"] = 27
}
);