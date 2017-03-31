----------------------------------------------------------------------------------
-- Total RP 3
-- Automator mercenary module
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
	local UnitIsMercenary = UnitIsMercenary;

	local function isPlayerMercenary()
		return UnitIsMercenary("player");
	end
end

TRP3_API.automator.registerModule({
	["name"] = "Mercenary",
	["description"] = "Adapt your profile when you are a mercenary in a battleground.",
	["id"] = "mercenary",
	["init"] = init
});