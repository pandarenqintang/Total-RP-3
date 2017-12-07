----------------------------------------------------------------------------------
--- Total RP 3
---
--- Events system
---
--- Provides an easy way to listen to game events
---
---	------------------------------------------------------------------------------
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
---	Copyright 2017 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
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

local Events = {};
TRP3_API.Events = Events;

-- WoW imports
local assert = assert;
local pairs = pairs;
local tostring = tostring;
local tinsert = table.insert;
local format = string.format;

-- Total RP 3 imports
local Logs = TRP3_API.Logs;
local Tables = TRP3_API.Tables;
local String = TRP3_API.Strings;
local isNotNil = TRP3_API.Assertions.isNotNil;
local isType = TRP3_API.Assertions.isType;

local REGISTERED_EVENTS = {};

local REGISTERED_CALLBACK = "Registered a new event callback for event %s with id %s.";
local UNREGISTERED_CALLBACK = "Unregistered an event callback for event %s with id %s.";
local EVENT_HANDLER_NOT_FOUND = "handlerID not found %s.";
local REGISTERED_EVENT = "Listening to new event %s.";
local UNREGISTERED_EVENT = "Stopped listening to event %s, no more callbacks for this event.";

local EventFrame = CreateFrame("FRAME");

---Register a callback for a game event
---@param event string @ A game event to listen to
---@param callback func @ A callback that will be called when the event is fired with its arguments
function Events.registerHandler(event, callback)
	assert(isNotNil(event, "event"));
	assert(isType(callback,"function", "callback"));

	if not REGISTERED_EVENTS[event] then
		REGISTERED_EVENTS[event] = {};
		EventFrame:RegisterEvent(event);
		Logs.info(format(REGISTERED_EVENT, tostring(event)));
	end

	local handlerID = String.generateUniqueID(REGISTERED_EVENTS);
	REGISTERED_EVENTS[event][handlerID] = callback;

	Logs.info(format(REGISTERED_CALLBACK, tostring(event), handlerID));

	return handlerID;
end

---Unregister a previously registered callback using the handler ID given at registration
---@param handlerID string @ The handler ID of a previsouly registered callback that we want to unregister
function Events.unregisterHandler(handlerID)
	assert(isNotNil(handlerID, "handlerID"));

	-- Look for the handler ID through all the events
	for event, eventTab in pairs(REGISTERED_EVENTS) do
		if eventTab[handlerID] then
			eventTab[handlerID] = nil;

			-- If this specific event no longer has any callback, we can remove it and unregister it
			if Tables.size(eventTab) == 0 then
				REGISTERED_EVENTS[event] = nil;
				EventFrame:UnregisterEvent(event);
				Logs.info(format(UNREGISTERED_EVENT, tostring(event)));
			end

			Logs.info(format(UNREGISTERED_CALLBACK, tostring(event), handlerID));

			return;
		end
	end
	Logs.warning(format(EVENT_HANDLER_NOT_FOUND, handlerID));
end

local function eventDispatcher(self, event, ...)
	-- Callbacks
	if REGISTERED_EVENTS[event] then
		local temp = Tables.getTempTable();

		-- We use a separate structure as the callback could change REGISTERED_EVENTS[event]
		Tables.copy(temp, REGISTERED_EVENTS[event])
		for _, callback in pairs(temp) do
			callback(...);
		end

		Tables.releaseTempTable(temp);
	else
		self:UnregisterEvent(event);
		Logs.info(format(UNREGISTERED_EVENT, tostring(event)));
	end
end

EventFrame:SetScript("OnEvent", eventDispatcher);

function Events.fireEvent(event, ...)
	eventDispatcher(EventFrame, event, ...)
end