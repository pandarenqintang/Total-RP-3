----------------------------------------------------------------------------------
--- Total RP 3
---
--- Total RP 3 custom dice rolls
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

-- Total RP 3 imports
local loc = TRP3_API.loc;

-- Register a Total RP 3 module that can be disabled in the settings
TRP3_API.module.registerModule({
	["name"] = loc.MO_DICE_ROLLS_MODULE,
	["description"] = loc.MO_DICE_ROLLS_MODULE_TT,
	["version"] = 1.000,
	["id"] = "trp3_dice_rolls",
	["minVersion"] = 35,
	["onStart"] = function()

		-- WoW imports
		local UnitExists = UnitExists;
		local UnitInParty = UnitInParty;
		local UnitInRaid = UnitInRaid;
		local IsInGroup = IsInGroup;
		local IsInRaid = IsInRaid;
		local pairs = pairs;
		local random = math.random;
		local tonumber = tonumber;
		local find = string.find;
		local strjoin = strjoin
		local unpack = unpack;
		local tinsert = table.insert;
		local type = type;

		-- Total RP 3 imports
		local Communications = TRP3_API.communication;
		local Unit = TRP3_API.Unit;
		local Messages = TRP3_API.Messages;
		local Sounds = TRP3_API.Sounds;
		local Events = TRP3_API.Events;
		local Slash = TRP3_API.Slash;
		local Textures = TRP3_API.Textures;

		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
		-- Dices roll
		--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

		Events.EVENTS.TRP3_ROLL = "TRP3_ROLL";
		local DICE_TEXT_ICON = Textures.iconTag("inv_misc_dice_02", 20);
		local DICE_TOTAL_TEXT_ICON = Textures.iconTag("inv_misc_dice_01", 20);
		local DICE_SIGNAL = "DISN";
		local DICE_ROLL_SOUND_ID = 36629;

		local function sendDiceRoll(args)
			if UnitExists("target") and not (UnitInParty("target") or UnitInRaid("target")) then
				Communications.sendObject(DICE_SIGNAL, args, Unit.getUnitID("target"));
			end
			if IsInRaid() then
				Communications.sendObject(DICE_SIGNAL, args, "RAID");
			elseif IsInGroup() then
				Communications.sendObject(DICE_SIGNAL, args, "PARTY");
			end
		end

		local function rollDice(diceString, noSend)
			local _, _, num, diceCount = find(diceString, "(%d+)d(%d+)");
			num = tonumber(num) or 0;
			diceCount = tonumber(diceCount) or 0;
			if num > 0 and diceCount > 0 then
				local total = 0;
				for i = 1, num do
					local value = random(1, diceCount);
					total = total + value;
				end
				Messages.displayMessage(loc(loc.DICE_ROLL, DICE_TEXT_ICON, num, diceCount, total));
				sendDiceRoll({ c = num, d = diceCount, t = total });
				return total;
			end
			return 0;
		end

		function Slash.rollDices(...)
			local args = { ... };
			local total = 0;
			local i = 0;

			if #args == 0 then
				tinsert(args, "1d100");
			end
			for index, roll in pairs(args) do
				total = total + rollDice(roll);
				i = index;
			end

			local totalMessage = loc(loc.DICE_TOTAL, DICE_TOTAL_TEXT_ICON, total);
			if i > 1 then
				Messages.displayMessage(totalMessage);
				sendDiceRoll({ t = total });
			end
			Messages.displayMessage(totalMessage, 3);
			Sounds.playUISound(DICE_ROLL_SOUND_ID);
			Events.fireEvent(Events.EVENTS.TRP3_ROLL, strjoin(" ", unpack(args)), total);

			return total, i;
		end

		Events.listenToEvent(Events.EVENTS.WORKFLOW_ON_LOADED, function()
			Slash.registerCommand({
				id = "roll",
				helpLine = " " .. loc.DICE_HELP,
				handler = function(...)
					TRP3_API.slash.rollDices(...);
				end
			});

			Communications.registerProtocolPrefix(DICE_SIGNAL, function(arg, sender)
				if sender ~= TRP3_API.globals.player_id then
					if type(arg) == "table" then
						if arg.c and arg.d and arg.t then
							Messages.displayMessage(loc(loc.DICE_ROLL_T, DICE_TEXT_ICON, sender, arg.c, arg.d, arg.t));
						elseif arg.t then
							local totalMessage = loc(loc.DICE_TOTAL_T, DICE_TOTAL_TEXT_ICON, sender, arg.t);
							Messages.displayMessage(totalMessage);
						end
						Sounds.playSoundID(DICE_ROLL_SOUND_ID, Sounds.CHANNELS.SFX, sender);
					end
				end
			end);
		end);

	end,
});