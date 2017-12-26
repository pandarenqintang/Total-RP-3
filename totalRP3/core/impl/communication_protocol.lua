----------------------------------------------------------------------------------
--- Total RP 3
---
--- Communication protocol and API
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

local Communications = {};
TRP3_API.Communications = Communications;
TRP3_API.communication = TRP3_API.Deprecated.setUpAPIDeprecatedWarning(TRP3_API.Communications, "Communications", "TRP3_API.communication", "TRP3_API.Communications");

-- WoW imports
local RegisterAddonMessagePrefix = RegisterAddonMessagePrefix;
local tostring = tostring;
local pairs = pairs;
local assert = assert;
local string = string;
local wipe = wipe;
local tinsert = table.insert;
local type = type;
local math = math;
local tconcat = table.concat;

-- Libraries imports
local ChatThrottleLib = ChatThrottleLib;
local libSerializer = LibStub:GetLibrary("AceSerializer-3.0");

-- Total RP 3 imports
local isType = TRP3_API.Assertions.isType;
local warning = TRP3_API.Logs.warning;
local debug = TRP3_API.Logs.debug;
local severe = TRP3_API.Logs.severe;
local GameEvents = TRP3_API.GameEvents;
local Serial = TRP3_API.Serial;
local VERBOSE = TRP3_API.Globals.DEBUG_MODE;

-- function definition
local handlePacketsIn;
local handleStructureIn;
local receiveObject;
local onAddonMessageReceived;
local isIDIgnored;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LAYER 0 : CONNECTION LAYER
-- Makes connection with Wow communication functions, or debug functions
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local wowCom_prefix = "TRP3.1";
local interface_id = {
	WOW = 1,
	DIRECT_RELAY = 2,
	DIRECT_PRINT = 3
};
Communications.total = 0;
Communications.totalReceived = 0;
Communications.interface_id = interface_id;
local selected_interface_id = interface_id.WOW;

function Communications.init()
	isIDIgnored = TRP3_API.register.isIDIgnored;
	GameEvents.registerHandler("CHAT_MSG_ADDON", onAddonMessageReceived);
	GameEvents.registerHandler("PLAYER_ENTERING_WORLD", function()
		RegisterAddonMessagePrefix(wowCom_prefix);
	end);
end

local function isSpecialTarget(target)
	return target == "PARTY" or target == "RAID";
end

-- This is the main communication interface, using ChatThrottleLib to
-- avoid being kicked by the server when sending a lot of data.
local function wowCommunicationInterface(packet, target, priority)
	if isSpecialTarget(target) then
		ChatThrottleLib:SendAddonMessage(priority or "BULK", wowCom_prefix, packet, target);
	else
		ChatThrottleLib:SendAddonMessage(priority or "BULK", wowCom_prefix, packet, "WHISPER", target);
	end
end

function onAddonMessageReceived(...)
	local prefix, packet , distributionType, sender = ...;
	if prefix == wowCom_prefix then
		if not sender or not sender:find('-') then
			warning("Malformed senderID: " .. tostring(sender));
			return;
		end
		Communications.totalReceived = Communications.totalReceived + prefix:len() + packet:len();
		handlePacketsIn(packet, sender);
	end
end

-- This communication interface print all sent message to the chat frame.
-- Note that the messages are not really sent.
local function directPrint(packet, target, priority)
	debug("Message to: "..tostring(target).." - Priority: "..tostring(priority)..(" - Message(%s):"):format(packet:len()));
	debug(packet);
end

-- A "direct relay" (like localhost) communication interface, used for development purpose.
-- Any message sent to this communication interface is directly rerouted to the user itself.
-- Note that the messages are not really sent.
local function directRelayInterface(packet, target, priority)
	directPrint(packet, target, priority)
	handlePacketsIn(packet, target);
end

-- Returns the function reference to be used as communication interface.
local function getCommunicationInterface()
	if selected_interface_id == interface_id.WOW then return wowCommunicationInterface end
	if selected_interface_id == interface_id.DIRECT_RELAY then return directRelayInterface end
	if selected_interface_id == interface_id.DIRECT_PRINT then return directPrint end
end

-- Changes the communication interface to use
function Communications.setInterfaceID(id)
	selected_interface_id = id;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LAYER 1 : PACKET LAYER
-- Packet sending and receiving
-- Handles packet sequences
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- 254 - TRP3.1(6) - MESSAGE_ID(2) - control character(1) - total256(2) - index256(2)
local AVAILABLE_CHARACTERS = 240;
local NEXT_PACKET_PREFIX = "F";
local LAST_PACKET_PREFIX = "L";
local PACKETS_RECEPTOR = {};
local ID_MOD = 74;
local ID_MOD_START = 48;
local ID_MAX_VALUE = ID_MOD*ID_MOD;

local function code(code)
	assert(type(code) == "number" and code < ID_MAX_VALUE, "Bad code: " .. code);
	local div = math.floor(code / ID_MOD);
	local remainder = math.fmod (code, ID_MOD);
	return string.char(ID_MOD_START + div) .. string.char(ID_MOD_START + remainder);
end

-- Send each packet to the current communication interface.
local function handlePacketsOut(messageID, packets, target, priority)
	local totalPackets = #packets;
	if totalPackets ~= 0 then
		local total256 = code(totalPackets);
		for index, packet in pairs(packets) do
			assert(packet:len() <= AVAILABLE_CHARACTERS, "Too long packet: " .. packet:len());
			local control = NEXT_PACKET_PREFIX;
			if index == #packets then
				control = LAST_PACKET_PREFIX;
			end
			local str = messageID .. control .. total256 .. packet;
			local size = str:len() + wowCom_prefix:len();
			Communications.total = Communications.total + size;
			getCommunicationInterface()(str, target, priority);

		end
	end
end

local PACKET_MESSAGE_HANDLERS = {};

local function savePacket(sender, messageID, packet, total)
	if not PACKETS_RECEPTOR[sender] then
		PACKETS_RECEPTOR[sender] = {};
	end
	if not PACKETS_RECEPTOR[sender][messageID] then
		PACKETS_RECEPTOR[sender][messageID] = {};
	end
	tinsert(PACKETS_RECEPTOR[sender][messageID], packet);

	if VERBOSE then
		debug(("savePacket(%s, %s, packet, %s / %s)"):format(sender, messageID, #PACKETS_RECEPTOR[sender][messageID], total));
	end

	-- Triggers packet handlers
	if PACKET_MESSAGE_HANDLERS[sender] and PACKET_MESSAGE_HANDLERS[sender][messageID] then
		for _, handler in pairs(PACKET_MESSAGE_HANDLERS[sender][messageID]) do
			handler(messageID, total, #PACKETS_RECEPTOR[sender][messageID]);
		end
	end
end

function Communications.addMessageIDHandler(target, messageID, callback)
	if not PACKET_MESSAGE_HANDLERS[target] then PACKET_MESSAGE_HANDLERS[target] = {} end
	if not PACKET_MESSAGE_HANDLERS[target][messageID] then PACKET_MESSAGE_HANDLERS[target][messageID] = {} end
	tinsert(PACKET_MESSAGE_HANDLERS[target][messageID], callback);
end

local function getPackets(sender, messageID)
	assert(PACKETS_RECEPTOR[sender] and PACKETS_RECEPTOR[sender][messageID], "No stored packets from "..sender.." for structure "..messageID);
	return PACKETS_RECEPTOR[sender][messageID];
end

local function endPacket(sender, messageID)
	assert(PACKETS_RECEPTOR[sender] and PACKETS_RECEPTOR[sender][messageID], "No stored packets from "..sender.." for structure "..messageID);
	wipe(PACKETS_RECEPTOR[sender][messageID]);
	PACKETS_RECEPTOR[sender][messageID] = nil;
	if PACKET_MESSAGE_HANDLERS[sender] and PACKET_MESSAGE_HANDLERS[sender][messageID] then
		wipe(PACKET_MESSAGE_HANDLERS[sender][messageID]);
		PACKET_MESSAGE_HANDLERS[sender][messageID] = nil;
	end
end

local function decode(code)
	assert(type(code) == "string" and #code == 2, "Bad code: '" .. code .. "'");
	local value = (string.byte(code:sub(2, 2)) - ID_MOD_START) + (((string.byte(code:sub(1, 1)) - ID_MOD_START) * ID_MOD));
	return value;
end

function handlePacketsIn(packet, sender)
	if not isIDIgnored(sender) then
		local messageID = packet:sub(1, 2);
		local control = packet:sub(3, 3);
		local total10 = decode(packet:sub(4, 5));
		savePacket(sender, messageID, packet:sub(6), total10);
		if control == LAST_PACKET_PREFIX then
			handleStructureIn(getPackets(sender, messageID), sender, messageID);
			endPacket(sender, messageID);
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LAYER 2 : MESSAGE LAYER
-- Structure-to-Message serialization / deserialization
-- Message cutting in packets / Message reconstitution
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local MESSAGE_ID = 1;

-- Message IDs are 74 base number encoded on 2 chars (74*74 = 5476 available Message IDs)
function Communications.getMessageIDAndIncrement()
	local toReturn = code(MESSAGE_ID);
	MESSAGE_ID = MESSAGE_ID + 1;
	if MESSAGE_ID >= ID_MAX_VALUE then
		MESSAGE_ID = 1;
	end
	return toReturn;
end

-- Convert structure to message, cut message in packets.
local function handleStructureOut(structure, target, priority, messageID)
	local message = libSerializer:Serialize(structure);
	messageID = messageID or Communications.getMessageIDAndIncrement();
	local messageSize = message:len();
	local packetTab = {};
	local index = 1;
	while index <= messageSize do
		tinsert(packetTab, message:sub(index, index + (AVAILABLE_CHARACTERS - 1)));
		index = index + AVAILABLE_CHARACTERS;
	end
	handlePacketsOut(messageID, packetTab, target, priority);
end

-- Reassemble the message based on the packets, and deserialize it.
function handleStructureIn(packets, sender, messageID)
	local message = tconcat(packets);
	local status, structure = libSerializer:Deserialize(message);
	if status then
		receiveObject(structure, sender, messageID);
	else
		Serial.errorCount = Serial.errorCount + 1;
		severe(("Deserialization error from %s. Message:\n%s"):format(sender, message));
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- LAYER 3 : STRUCTURE LAYER
-- "What to do with the structure received / to send ?"
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local PREFIX_REGISTRATION = {};

-- Register a function to callback when receiving a object attached to the given prefix
function Communications.registerProtocolPrefix(prefix, callback)
	assert(isType(prefix, "string", "prefix"));
	assert(isType(callback, "function", "callback"));
	if PREFIX_REGISTRATION[prefix] == nil then
		PREFIX_REGISTRATION[prefix] = {};
	end
	tinsert(PREFIX_REGISTRATION[prefix], callback);
end

-- Send a object to a player
-- Prefix must have been registered before use this function
-- The object can be any lua type (numbers, strings, tables, but NOT functions or userdatas)
-- Priority is optional ("Bulk" by default)
function Communications.sendObject(prefix, object, target, priority, messageID)
	assert(PREFIX_REGISTRATION[prefix] ~= nil, "Unregistered prefix: "..prefix);
	if not isIDIgnored(target) then
		if isSpecialTarget(target) or target:match("[^%-]+%-[^%-]+") then
			if VERBOSE then
				debug(("Send to %s with prefix %s"):format(target, prefix));
			end
			local structure = {prefix, object};
			handleStructureOut(structure, target, priority, messageID);
		else
			warning("Trying to send data to bad formed target: " .. target);
			return; -- Avoid display "The player "Pouic-" doesn't seemed to be online".
		end
	end
end

-- Receive a structure from a player (sender)
-- Call any callback registered for this prefix.
-- Structure[1] contains the prefix, structure[2] contains the object
function receiveObject(structure, sender, messageID)
	if type(structure) == "table" and #structure == 2 then
		local prefix = structure[1];
		if VERBOSE then
			debug(("Received from %s with prefix %s"):format(sender, prefix));
		end
		if PREFIX_REGISTRATION[prefix] then
			for _, callback in pairs(PREFIX_REGISTRATION[prefix]) do
				callback(structure[2], sender, messageID);
			end
		else
			debug("No registration for prefix: " .. prefix);
		end
	else
		severe("Bad structure composition.");
	end
end

-- Estimate the number of packet needed to send a object.
function Communications.estimateStructureLoad(object)
	assert(object, "Object nil");
	return math.ceil((#(libSerializer:Serialize({"MOCK", object}))) / AVAILABLE_CHARACTERS);
end