----------------------------------------------------------------------------------
--- Total RP 3
---
---    UI messages
---
---    ---------------------------------------------------------------------------
---    Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
---    Copyright 2017 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
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

local Messages = {};
TRP3_API.Messages = Messages;

-- WoW imports
local tostring = tostring;

local MESSAGE_PREFIX = "[" .. TRP3_API.Colors.COLORS.YELLOW:WrapTextInColorCode(TRP3_API.globals.addon_name_short) .. "]";

local function getChatFrame(chatFrameIndex)
	return _G["ChatFrame" .. tostring(chatFrameIndex)] or DEFAULT_CHAT_FRAME;
end

Messages.TYPES = {
	CHAT_FRAME = 1, -- ChatFrame (given by chatFrameIndex or default if nil)
	ALERT_POPUP = 2, -- Total RP 3 alert popup
	RAID_ALERT = 3, -- On screen alert (Raid notice frame)
	ALERT_MESSAGE = 4 -- UI error
};

-- Display a simple message. Nil free.
function Messages.displayMessage(message, messageType, noPrefix, chatFrameIndex)

	-- Chat frame
	if not messageType or messageType == Messages.TYPES.CHAT_FRAME then
		local chatFrame = getChatFrame(chatFrameIndex);
		message = tostring(message);
		if not noPrefix then
			message = MESSAGE_PREFIX .. " " .. message;
		end
		chatFrame:AddMessage(message, 1, 1, 1);

	-- Total RP 3 popup
	elseif messageType == Messages.TYPES.ALERT_POPUP then
		TRP3_API.popup.showAlertPopup(tostring(message));

	-- Raid alert
	elseif messageType == Messages.TYPES.RAID_ALERT then
		RaidNotice_AddMessage(RaidWarningFrame, tostring(message), ChatTypeInfo["RAID_WARNING"]);

	-- UI error
	elseif messageType == Messages.TYPES.ALERT_MESSAGE then
		UIErrorsFrame:AddMessage(message, 1.0, 0.0, 0.0);
	end
end