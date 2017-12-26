----------------------------------------------------------------------------------
--- Total RP 3
---
--- Slash commands API
---
--- ---------------------------------------------------------------------------
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
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

---@type TRP3_API
local _, TRP3_API = ...;

local Slash = {};
TRP3_API.Slash = Slash;

-- WoW imports
local tinsert = tinsert;
local assert = assert;
local tostring = tostring;
local pairs = pairs;
local sort = table.sort;
local remove = table.remove;
local wipe = wipe;
local unpack = unpack;
local strsplit = strsplit;

-- Total RP 3 imports
local isType = TRP3_API.Assertions.isType;
local loc = TRP3_API.loc;
local Colors = TRP3_API.Colors;
local displayMessage = TRP3_API.Messages.displayMessage;


--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Command management
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local COMMANDS = {};

function TRP3_API.slash.registerCommand(commandStructure)
	assert(isType(commandStructure, "table", "commandStructure"));
	assert(isType(commandStructure.id, "string", "commandStructure.id"));
	assert(commandStructure.id ~= "help", "The command id \"help\" is reserved.");
	assert(not COMMANDS[commandStructure.id], "Already registered command id: " .. tostring(commandStructure.id));
	COMMANDS[commandStructure.id] = commandStructure;
end

function TRP3_API.slash.unregisterCommand(commandID)
	COMMANDS[commandID] = nil;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Command handling
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

SLASH_TOTALRP31, SLASH_TOTALRP32 = '/trp3', '/totalrp3';
local sortTable = {};

function SlashCmdList.TOTALRP3(msg, editbox)
	local args = {strsplit(" ", msg)};
	local cmdID = args[1];
	remove(args, 1);

	if cmdID and COMMANDS[cmdID] and COMMANDS[cmdID].handler then
		COMMANDS[cmdID].handler(unpack(args));
	else
		-- Show command list
		displayMessage(loc.COM_LIST);
		wipe(sortTable);
		for cmdID, _ in pairs(COMMANDS) do
			tinsert(sortTable, cmdID);
		end
		sort(sortTable);
		for _, cmdID in pairs(sortTable) do
			local cmd, cmdText = COMMANDS[cmdID], Colors.COLORS.GREEN:WrapTextInColorCode(SLASH_TOTALRP31 .. " " .. cmdID);
			if cmd.helpLine then
				cmdText = cmdText .. Colors.COLORS.ORANGE:WrapTextInColorCode(cmd.helpLine);
			end
			displayMessage(cmdText);
		end
	end
end