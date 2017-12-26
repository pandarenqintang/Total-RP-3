----------------------------------------------------------------------------------
--- Total RP 3
---
--- Total RP 3 events API
---
--- Custom events fired by Total RP 3, listened to by other Total RP 3 modules.
---
---    ---------------------------------------------------------------------------
---    Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
---
---    Licensed under the Apache License, Version 2.0 (the "License");
---    you may not use this file except in compliance with the License.
---    You may obtain a copy of the License at
---
---        http://www.apache.org/licenses/LICENSE-2.0
---
---    Unless required by applicable law or agreed to in writing, software
---    distributed under the License is distributed on an "AS IS" BASIS,
---    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
---    See the License for the specific language governing permissions and
---    limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;

local Events = {};
TRP3_API.Events = Events;

-- WoW imports
local assert = assert;
local tostring = tostring;
local tinsert = table.insert;
local pairs = pairs;

-- Total RP 3 imports
local isType = TRP3_API.Assertions.isType;

Events.EVENTS = {
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Total RP 3 events
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Workflow
	WORKFLOW_ON_API = "WORKFLOW_ON_API",
	WORKFLOW_ON_LOAD = "WORKFLOW_ON_LOAD",
	WORKFLOW_ON_LOADED = "WORKFLOW_ON_LOADED",
	WORKFLOW_ON_FINISH = "WORKFLOW_ON_FINISH",

	-- Navigation
	NAVIGATION_TUTORIAL_REFRESH = "NAVIGATION_TUTORIAL_REFRESH",
	NAVIGATION_RESIZED = "NAVIGATION_RESIZED",

	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	-- Data changed
	--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	-- General event when a data changed in a profile of a certain unitID (character or companion)
	-- Arg1 : (optional) unitID or companionFullID
	-- Arg2 : profile ID
	-- Arg3 : (optional) Data type : either nil or "characteristics", "about", "misc", "character", "unitID"
	REGISTER_DATA_UPDATED = "REGISTER_DATA_UPDATED",

	-- Called when you switch from one profile to another
	-- Use to known when re-compress all of the current profile.
	-- Arg1 : profile structure
	REGISTER_PROFILES_LOADED = "REGISTER_PROFILES_LOADED",

	-- Called when a profile is deleted (character or companion)
	-- Arg1 : Profile ID
	-- Arg2 : (optional, currently only for characters) A tab containing all the linked unitIDs to the profile
	REGISTER_PROFILE_DELETED = "REGISTER_PROFILE_DELETED",

	-- Called when as "About" page is shown.
	-- This is used by the tooltip and the target bar to be refreshed
	REGISTER_ABOUT_READ = "REGISTER_ABOUT_READ",

	-- Called when a notifications is created/read/removed
	NOTIFICATION_CHANGED = "NOTIFICATION_CHANGED",

	-- Called when Wow Event UPDATE_MOUSEOVER_UNIT is fired
	-- Arg1 : Target ID
	-- Arg2 : Target mode (Character, pet, battle pet ...)
	MOUSE_OVER_CHANGED = "MOUSE_OVER_CHANGED",
};

local REGISTERED_EVENTS = {};

function Events.registerEvent(event)
	assert(isType(event, "text", "event"));
	assert(not REGISTERED_EVENTS[event], "Event already registered.");
	REGISTERED_EVENTS[event] = {};
end

-- Register main Total RP 3 events
for event, eventID in pairs(Events.EVENTS) do
	Events.registerEvent(eventID);
end

function Events.listenToEvent(event, handler)
	assert(isType(event, "text", "event"));
	assert(REGISTERED_EVENTS[event], "Unknown event: " .. tostring(event));
	assert(isType(handler, "function", "handler"));
	tinsert(REGISTERED_EVENTS[event], handler);
end

function Events.listenToEvents(events, handler)
	assert(isType(events, "table", "events"));
	for _, event in pairs(events) do
		Events.listenToEvent(event, handler);
	end
end

function Events.fireEvent(event, ...)
	assert(isType(event, "text", "event"));
	assert(REGISTERED_EVENTS[event], "Unknown event: " .. tostring(event));
	for _, handler in pairs(REGISTERED_EVENTS[event]) do
		handler(...);
	end
end