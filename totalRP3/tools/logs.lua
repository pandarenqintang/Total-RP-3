----------------------------------------------------------------------------------
--- Total RP 3
---
--- Logging system
---
--- This new logging system is use primarily for debugging.
---	Debug messages are printed to the chatframe
--- and a full log with filtering options is available in a specific frame.
---
---	---------------------------------------------------------------------------
---	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
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

---@class TRP3_Logs
local Logs = {};
TRP3_API.Logs = Logs;

-- WoW imports
local print = print;
local tinsert = table.insert;
local pairs = pairs;
local strconcat = strconcat;
local format = string.format;
local assert = assert;

-- Total RP 3 imports
local Colors = TRP3_API.Colors;
local Strings = TRP3_API.Strings;
local isType = TRP3_API.Assertions.isType;

---@type ScrollingMessageFrame
local LogsFrame = TRP3_LogsFrame;

local LOG_HEADER_FORMAT = "[TRP3-%s]: ";
Logs.LEVELS = {
	DEBUG = "DEBUG",
	INFO = "INFO",
	WARNING = "WARNING",
	SEVERE = "SEVERE",
}

---@type TRP3_ColorMixin[]
local LEVELS_COLORS = {
	[Logs.LEVELS.DEBUG] = Colors.COLORS.CYAN,
	[Logs.LEVELS.INFO] = Colors.COLORS.GREEN,
	[Logs.LEVELS.WARNING] = Colors.COLORS.ORANGE,
	[Logs.LEVELS.SEVERE] = Colors.COLORS.RED,
}

---@param optional level string @ The log level, one of Logs.LEVELS
---@return TRP3_ColorMixin color @ The Color corresponding to the log level. If none was found, defaults to INFO
local function getLogColorForLevel(level)
	return LEVELS_COLORS[level] or LEVELS_COLORS[Logs.LEVELS.INFO];
end

---@param level string @ The log level, one of Logs.LEVELS
---@return string header @ The header for the log entry
local function getHeaderForLevel(level)
	assert(isType(level, "text", "level"));
	local header = format(LOG_HEADER_FORMAT, level);
	local logColor = getLogColorForLevel(level);
	return logColor:WrapTextInColorCode(header);
end

local logs = {};

---@param level string @ The log level, one of Logs.LEVELS
---@param ... string[] @ List of string to print
function Logs.log(level, ...)
	assert(isType(level, "text", "level"));
	local message = strconcat(getHeaderForLevel(level), Strings.convertTableToString({ ... }));

	tinsert(logs, {
		level = level,
		message = message
	});

	if TRP3_API.globals.DEBUG_MODE then
		print(message);
	end
end

---@param ... string[] @ List of string to print
function Logs.info(...)
	Logs.log(Logs.LEVELS.INFO, ...);
end

---@param ... string[] @ List of string to print
function Logs.debug(...)
	Logs.log(Logs.LEVELS.DEBUG, ...);
end

---@param ... string[] @ List of string to print
function Logs.warning(...)
	Logs.log(Logs.LEVELS.WARNING, ...);
end

---@param ... string[] @ List of string to print
function Logs.severe(...)
	Logs.log(Logs.LEVELS.SEVERE, ...);
end

-- TODO todo, todo todo todo todooooooo, todododo
function Logs.list()
	LogsFrame:Show();
	LogsFrame:AddMessage("-----------------------")
	for _, log in pairs(logs) do
		LogsFrame:AddMessage(log.messages);
	end
end


-- Backward compatibility layer
-- Map new system to the old one
TRP3_API.utils.log = {};

TRP3_API.utils.log.level = Logs.LEVELS;

function TRP3_API.utils.log.log(message, level)
	if not level then level = Logs.LEVELS.INFO end
	Logs.log(level, message);
end