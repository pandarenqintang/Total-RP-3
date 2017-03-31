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
TRP3_API.automator = {
};
local Log = TRP3_API.utils.log;

local assert = assert;

local automatorModules = {};

---registerModule
---@param moduleStructure table
function TRP3_API.automator.registerModule(moduleStructure)
	
	assert(moduleStructure, "Automator module structure can't be nil");
	assert(moduleStructure.id, "Illegal module structure. Automator module id: "..moduleStructure.id);
	assert(not MODULE_REGISTRATION[moduleStructure.id], "This automator module is already register: "..moduleStructure.id);
	
	if not moduleStructure.name or not type(moduleStructure.name) == "string" or moduleStructure.name:len() == 0 then
		moduleStructure.name = moduleStructure.id;
	end
	
	automatorModules[moduleStructure.id] = moduleStructure;
	
	Log.log("Module registered: " .. moduleStructure.id);
	
end

local function onStart()
	
end


-- Register a Total RP 3 module that can be disabled in the settings
TRP3_API.module.registerModule({
	["name"] = "Automator",
	["description"] = "Bring automation to Total RP 3.",
	["version"] = 0.1,
	["id"] = "trp3_automator",
	["onStart"] = onStart,
	["minVersion"] = 27
});