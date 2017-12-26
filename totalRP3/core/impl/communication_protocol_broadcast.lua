----------------------------------------------------------------------------------
--- Total RP 3
---
--- Broadcast communication system
---
---	---------------------------------------------------------------------------
---	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--- Copyright 2017 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
---	Licensed under the Apache License, Version 2.0 (the "License");
---	you may not use this file except in compliance with the License.
---	You may obtain a copy of the License at
---
---		http://www.apache.org/licenses/LICENSE-2.0
---
---	Unless required by applicable law or agreed to in writing, software
---	distributed under the License is distributed on an "AS IS" BASIS,
---	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
---	See the License for the specific language governing permissions and
---	limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;

local Broadcast = {};
TRP3_API.Broadcast = Broadcast;
TRP3_API.communication.broadcast = TRP3_API.Deprecated.setUpAPIDeprecatedWarning(TRP3_API.Broadcast, "Broadcast", "TRP3_API.communication.broadcast", "TRP3_API.Broadcast");

-- WoW imports
local wipe = wipe;
local string = string;
local pairs = pairs;
local strsplit = strsplit;
local assert = assert;
local tinsert = table.insert;
local type = type;
local tostring = tostring;
local GetChannelRosterInfo = GetChannelRosterInfo;
local GetChannelDisplayInfo = GetChannelDisplayInfo;
local GetChannelName = GetChannelName;
local JoinChannelByName = JoinChannelByName;
local RegisterAddonMessagePrefix = RegisterAddonMessagePrefix;
local newTicker = C_Timer.NewTicker;

-- Libraries imports
local ChatThrottleLib = ChatThrottleLib;

-- Total RP 3 imports
local log = TRP3_API.Logs.info;
local warning = TRP3_API.Logs.warning;
local loc = TRP3_API.loc;
local GameEvents = TRP3_API.GameEvents;
local Events = TRP3_API.Events;
local Messages = TRP3_API.Messages;
local Communications = TRP3_API.Communications;
local Globals = TRP3_API.Globals;
local Strings = TRP3_API.Strings;

local isIDIgnored;
local BROADCAST_CHANNEL_NAME = "xtensionxtooltip2";

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Communication protocol
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

Broadcast.HELLO_CMD = "TRP3HI";
local HELLO_CMD = Broadcast.HELLO_CMD;

local helloWorlded = false;
local PREFIX_REGISTRATION, PREFIX_P2P_REGISTRATION = {}, {};
local BROADCAST_PREFIX = "RPB";
local BROADCAST_VERSION = 1;
local BROADCAST_SEPARATOR = "~";
local BROADCAST_HEADER = BROADCAST_PREFIX .. BROADCAST_VERSION;
Communications.totalBroadcast = 0;
Communications.totalBroadcastP2P = 0;
Communications.totalBroadcastR = 0;
Communications.totalBroadcastP2PR = 0;

function Broadcast.broadcast(command, ...)
	if not command then
		log("Bad params");
		return;
	end
	if not helloWorlded and command ~= HELLO_CMD then
		log("Broadcast channel not yet initialized.");
		return;
	end
	local message = BROADCAST_HEADER .. BROADCAST_SEPARATOR .. command;
	for _, arg in pairs({...}) do
		arg = tostring(arg);
		if arg:find(BROADCAST_SEPARATOR) then
			warning("Trying a broadcast with a arg containing the separator character. Abort !");
			return;
		end
		message = message .. BROADCAST_SEPARATOR .. arg;
	end
	if message:len() < 254 then
		local channelName = GetChannelName(BROADCAST_CHANNEL_NAME);
		ChatThrottleLib:SendAddonMessage("NORMAL", BROADCAST_HEADER, message, "CHANNEL", channelName);
		Communications.totalBroadcast = Communications.totalBroadcast + BROADCAST_HEADER:len() + message:len();
	else
		warning(("Trying a broadcast with a message with length %s. Abort !"):format(message:len()));
	end
end

local function onBroadcastReceived(message, sender)
	local header, command, arg1, arg2, arg3, arg4, arg5, arg6, arg7 = strsplit(BROADCAST_SEPARATOR, message);
	if not header == BROADCAST_HEADER or not command then
		return; -- If not RP protocol or don't have a command
	end
	Communications.totalBroadcastR = Communications.totalBroadcastR + BROADCAST_HEADER:len() + message:len();
	for _, callback in pairs(PREFIX_REGISTRATION[command] or Globals.empty) do
		callback(sender, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
	end
end

-- Register a function to callback when receiving args to a certain command
function Broadcast.registerCommand(command, callback)
	assert(command and callback and type(callback) == "function", "Usage: command, callback");
	if PREFIX_REGISTRATION[command] == nil then
		PREFIX_REGISTRATION[command] = {};
	end
	tinsert(PREFIX_REGISTRATION[command], callback);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Peer to peer part
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function onP2PMessageReceived(message, sender)
	Communications.totalBroadcastP2PR = Communications.totalBroadcastP2PR + BROADCAST_HEADER:len() + message:len();
	local command, arg1, arg2, arg3, arg4, arg5, arg6, arg7 = strsplit(BROADCAST_SEPARATOR, message);
	if PREFIX_P2P_REGISTRATION[command] then
		for _, callback in pairs(PREFIX_P2P_REGISTRATION[command]) do
			callback(sender, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
		end
	end
end

-- Register a function to callback when receiving args to a certain command
function Broadcast.registerP2PCommand(command, callback)
	assert(command and callback and type(callback) == "function", "Usage: command, callback");
	if PREFIX_P2P_REGISTRATION[command] == nil then
		PREFIX_P2P_REGISTRATION[command] = {};
	end
	tinsert(PREFIX_P2P_REGISTRATION[command], callback);
end

function Broadcast.sendP2PMessage(target, command, ...)
	local message = command;
	for _, arg in pairs({...}) do
		arg = tostring(arg);
		if arg:find(BROADCAST_SEPARATOR) then
			warning("Trying a broadcast with a arg containing the separator character. Abort !");
			return;
		end
		message = message .. BROADCAST_SEPARATOR .. arg;
	end
	if message:len() < 254 then
		ChatThrottleLib:SendAddonMessage("NORMAL", BROADCAST_HEADER, message, "WHISPER", target);
		Communications.totalBroadcastP2P = Communications.totalBroadcastP2P + BROADCAST_HEADER:len() + message:len();
	else
		warning(("Trying a P2P message with a message with length %s. Abort !"):format(message:len()));
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Players connexions listener
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local connectedPlayers = {};

function Broadcast.isPlayerBroadcastable(playerName)
	return connectedPlayers[playerName] ~= nil;
end

function Broadcast.getPlayers()
	return connectedPlayers;
end

function Broadcast.resetPlayers()
	local channelName;
	wipe(connectedPlayers);
	for i=1, MAX_CHANNEL_BUTTONS, 1 do
		channelName = GetChannelDisplayInfo(i);
		if channelName == BROADCAST_CHANNEL_NAME then
			local j = 1;
			while GetChannelRosterInfo(i, j) do
				local playerName = GetChannelRosterInfo(i, j);
				connectedPlayers[playerName] = 1;
				j = j + 1;
			end
			break;
		end
	end
	return connectedPlayers;
end

local function onChannelJoin(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	if arg2 and arg9 == BROADCAST_CHANNEL_NAME() then
		-- TODO Why are we using the unit name only here? Issues could rise with connected realms!
		local unitName = Strings.unitIDToInfo(arg2);
		connectedPlayers[unitName] = 1;
	end
end

local function onChannelLeave(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	if arg2 and arg9 == BROADCAST_CHANNEL_NAME() then
		-- TODO Why are we using the unit name only here? Issues could rise with connected realms!
		local unitName = Strings.unitIDToInfo(arg2);
		connectedPlayers[unitName] = nil;
	end
end

local function onMessageReceived(...)
	local prefix, message , distributionType, sender, _, _, _, channel = ...;

	if not sender then
		return;
	end

	if prefix == BROADCAST_HEADER then

		if not sender:find('-') then
			sender = Strings.unitInfoToID(sender);
		end

		if not isIDIgnored(sender) then
			if distributionType == "CHANNEL" and string.lower(channel) == BROADCAST_CHANNEL_NAME then
				onBroadcastReceived(message, sender, channel);
			else
				onP2PMessageReceived(message, sender);
			end
		end

	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Init and helloWorld
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

function Broadcast.init()
	isIDIgnored = TRP3_API.register.isIDIgnored;

	-- First, register prefix
	GameEvents.registerHandler("PLAYER_ENTERING_WORLD", function()
		RegisterAddonMessagePrefix(BROADCAST_HEADER);
	end);

	local ticker;
	-- Then, launch the loop
	Events.listenToEvent(Events.EVENTS.WORKFLOW_ON_LOADED, function()
		local firstTime = true;
		ticker = newTicker(5, function(self)
			if firstTime then firstTime = false; return; end
			if GetChannelName(BROADCAST_CHANNEL_NAME) == 0 then
				log("Step 1: Try to connect to broadcast channel: " .. BROADCAST_CHANNEL_NAME);
				JoinChannelByName(BROADCAST_CHANNEL_NAME);
			else
				log("Step 2: Connected to broadcast channel: " .. BROADCAST_CHANNEL_NAME .. ". Now sending HELLO command.");
				if not helloWorlded then
					Broadcast.broadcast(HELLO_CMD, Globals.version, Globals.version_display);
				end
			end
		end, 9);
	end);

	-- When we receive a broadcast or a P2P response
	GameEvents.registerHandler("CHAT_MSG_ADDON", onMessageReceived);

	-- When someone placed a password on the channel
	GameEvents.registerHandler("CHANNEL_PASSWORD_REQUEST", function(channel)
		if channel == BROADCAST_CHANNEL_NAME then
			log("Passworded !");
			Messages.displayMessage(loc(loc.BROADCAST_PASSWORD, channel));
			ticker:Cancel();
		end
	end);

	-- For when someone just places a password
	GameEvents.registerHandler("CHAT_MSG_CHANNEL_NOTICE_USER", function(mode, user, _, _, _, _, _, _, channel)
		if mode == "PASSWORD_CHANGED" and channel == BROADCAST_CHANNEL_NAME then
			Messages.displayMessage(loc(loc.BROADCAST_PASSWORDED, user, channel));
		end
	end);

	-- When you are already in 10 channel
	GameEvents.registerHandler("CHAT_MSG_SYSTEM", function(message)
		if message == ERR_TOO_MANY_CHAT_CHANNELS and not helloWorlded then
			Messages.displayMessage(loc.BROADCAST_10);
			ticker:Cancel();
		end
	end);

	-- For stats
	GameEvents.registerHandler("CHAT_MSG_CHANNEL_JOIN", onChannelJoin);
	GameEvents.registerHandler("CHAT_MSG_CHANNEL_LEAVE", onChannelLeave);

	-- We register our own HELLO msg so that when it happens we know we are capable of sending and receive on the channel.
	Broadcast.registerCommand(HELLO_CMD, function(sender, command)
		if sender == Globals.player_id then
			log("Step 3: HELLO command sent and parsed. Broadcast channel initialized.");
			helloWorlded = true;
			ticker:Cancel();
		end
	end);
end