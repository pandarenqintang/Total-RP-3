----------------------------------------------------------------------------------
--- Total RP 3
--- Automator characteristics modification
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
local Events = TRP3_API.events;
local playerID = TRP3_API.globals.player_id;
local getData = TRP3_API.profile.getData;

local pairs = pairs;

local function modificationFunction(characteristics)
	local profile = getData("player");

	for field, value in pairs(characteristics) do
		profile.characteristics[field] = value;
	end

	Events.fireEvent(Events.REGISTER_DATA_UPDATED, playerID, nil, "characteristics");
end

Automator.registerModification(
{
	["name"]                 = "Profile characteristics",
	["description"]          = "Adapt your profile when you have a specific buff or debuff applied on you.",
	["id"]                   = "characteristics",
	["modificationFunction"] = modificationFunction
}
);