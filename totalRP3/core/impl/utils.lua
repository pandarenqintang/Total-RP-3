----------------------------------------------------------------------------------
-- Total RP 3
-- Util API
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--
--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--		http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;

-- TRP3 imports
local Utils = TRP3_API.utils;
local Log = Utils.log;
local Colors = TRP3_API.Colors;
local log = TRP3_API.utils.log.log;
local loc = TRP3_API.locale.getText;

-- Public accessor
Utils.math = {};
Utils.serial = {};
Utils.message = {};
Utils.resources = {};

-- WOW imports
local pcall, tostring, pairs, type, print, string, date, math, strconcat, wipe, tonumber = pcall, tostring, pairs, type, print, string, date, math, strconcat, wipe, tonumber;
local strtrim = strtrim;
local tinsert, assert, _G, tremove, next = tinsert, assert, _G, tremove, next;
local PlayMusic, StopMusic = PlayMusic, StopMusic;
local getZoneText, getSubZoneText = GetZoneText, GetSubZoneText;
local PlaySound, select, StopSound = PlaySound, select, StopSound;

function Utils.pcall(func, ...)
	if func then
		return {pcall(func, ...)};
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Messaging
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local MESSAGE_PREFIX = "[|cffffaa00TRP3|r] ";

local function getChatFrame()
	return DEFAULT_CHAT_FRAME;
end

-- CHAT_FRAME : ChatFrame (given by chatFrameIndex or default if nil)
-- ALERT_POPUP : TRP3 alert popup
-- RAID_ALERT : On screen alert (Raid notice frame)
Utils.message.type = {
	CHAT_FRAME = 1,
	ALERT_POPUP = 2,
	RAID_ALERT = 3,
	ALERT_MESSAGE = 4
};
local messageTypes = Utils.message.type;

-- Display a simple message. Nil free.
Utils.message.displayMessage = function(message, messageType, noPrefix, chatFrameIndex)
	if not messageType or messageType == messageTypes.CHAT_FRAME then
		local chatFrame = _G["ChatFrame"..tostring(chatFrameIndex)] or getChatFrame();
		if noPrefix then
			chatFrame:AddMessage(tostring(message), 1, 1, 1);
		else
			chatFrame:AddMessage(MESSAGE_PREFIX..tostring(message), 1, 1, 1);
		end
	elseif messageType == messageTypes.ALERT_POPUP then
		TRP3_API.popup.showAlertPopup(tostring(message));
	elseif messageType == messageTypes.RAID_ALERT then
		RaidNotice_AddMessage(RaidWarningFrame, tostring(message), ChatTypeInfo["RAID_WARNING"]);
	elseif messageType == messageTypes.ALERT_MESSAGE then
		UIErrorsFrame:AddMessage(message, 1.0, 0.0, 0.0);
	end
end

-- Return a color tag based on a letter
function Utils.str.color(color)
	color = color or "w"; -- default color if bad argument
	if color == "r" then return "|cffff0000" end -- red
	if color == "g" then return "|cff00ff00" end -- green
	if color == "b" then return "|cff0000ff" end -- blue
	if color == "y" then return "|cffffff00" end -- yellow
	if color == "p" then return "|cffff00ff" end -- purple
	if color == "c" then return "|cff00ffff" end -- cyan
	if color == "w" then return "|cffffffff" end -- white
	if color == "0" then return "|cff000000" end -- black
	if color == "o" then return "|cffffaa00" end -- orange
end

-- If the given string is empty, return nil
function Utils.str.emptyToNil(text)
	if text and #text > 0 then
		return text;
	end
	return nil;
end

-- Assure that the given string will not be nil
function Utils.str.nilToEmpty(text)
	return text or "";
end

function Utils.str.buildZoneText()
	local text = getZoneText() or ""; -- assuming that there is ALWAYS a zone text. Don't know if it's true.
	if getSubZoneText():len() > 0 then
		text = strconcat(text, " - ", getSubZoneText());
	end
	return text;
end

-- Search if the string matches the pattern in error-safe way.
-- Useful if the pattern his user writen.
function Utils.str.safeMatch(text, pattern)
	local trace = Utils.pcall(string.find, text, pattern);
	if trace[1] then
		return type(trace[2]) == "number";
	end
	return nil; -- Pattern error
end

local escapes = {
	["|c%x%x%x%x%x%x%x%x"] = "", -- color start
	["|r"] = "", -- color end
	["|H.-|h(.-)|h"] = "%1", -- links
	["|T.-|t"] = "", -- textures
}
function Utils.str.sanitize(text)
	if not text then return end
	for k, v in pairs(escapes) do
		text = text:gsub(k, v);
	end
	return text;
end

function Utils.str.crop(text, size)
	text = strtrim(text or "");
	if text:len() > size then
		text = text:sub(1, size) .. "…";
	end
	return text
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Math
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function incrementNumber(version, figures)
	local incremented = version + 1;
	if incremented >= math.pow(10, figures) then
		incremented = 1;
	end
	return incremented;
end
Utils.math.incrementNumber = incrementNumber;

--- Return the interpolation.
-- delta is a number between 0 and 1;
local function lerp(delta, from, to)
	local diff = to - from;
	return from + (delta * diff);
end
Utils.math.lerp = lerp;

Utils.math.color = function(delta, fromR, fromG, fromB, toR, toG, toB)
	return lerp(delta, fromR, toR), lerp(delta, fromG, toG), lerp(delta, fromB, toB);
end

--- Values must be 256 based
Utils.math.colorCode = function(delta, fromR, fromG, fromB, toR, toG, toB)
	return Colors.colorCode(lerp(delta, fromR, toR), lerp(delta, fromG, toG), lerp(delta, fromB, toB));
end

function Utils.math.round(value, decimals)
	local mult = 10 ^ (decimals or 0)
	return math.floor(value * mult) / mult;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Text tags utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local directReplacements = {
	["/col"] = "|r",
};

local function convertTextTag(tag)

	if directReplacements[tag] then -- Direct replacement
		return directReplacements[tag];
	elseif tag:match("^col%:%a$") then -- Color replacement
		return Utils.str.color(tag:match("^col%:(%a)$"));
	elseif tag:match("^col:%x%x%x%x%x%x$") then -- Hexa color replacement
		return "|cff"..tag:match("^col:(%x%x%x%x%x%x)$");
	elseif tag:match("^icon%:[%w%s%_%-%d]+%:%d+$") then -- Icon
		local icon, size = tag:match("^icon%:([%w%s%_%-%d]+)%:(%d+)$");
		return Utils.str.icon(icon, size);
	end

	return "{"..tag.."}";
end

local function convertTextTags(text)
	if text then
		text = text:gsub("%{(.-)%}", convertTextTag);
		return text;
	end
end
Utils.str.convertTextTags = convertTextTags;

local escapedHTMLCharacters = {
	["<"] = "&lt;",
	[">"] = "&gt;",
	["\""] = "&quot;",
};

local structureTags = {
	["{h(%d)}"] = "<h%1>",
	["{h(%d):c}"] = "<h%1 align=\"center\">",
	["{h(%d):r}"] = "<h%1 align=\"right\">",
	["{/h(%d)}"] = "</h%1>",

	["{p}"] = "<P>",
	["{p:c}"] = "<P align=\"center\">",
	["{p:r}"] = "<P align=\"right\">",
	["{/p}"] = "</P>",
};

local strtrim = strtrim;

-- Convert the given text by his HTML representation
Utils.str.toHTML = function(text, noColor)

	local linkColor = "|cff00ff00";
	if noColor then
		linkColor = "";
	end

	-- 1) Replacement : & character
	text = text:gsub("&", "&amp;");

	-- 2) Replacement : escape HTML characters
	for pattern, replacement in pairs(escapedHTMLCharacters) do
		text = text:gsub(pattern, replacement);
	end

	-- 3) Replace Markdown
	local titleFunction = function(titleChars, title)
		local titleLevel = #titleChars;
		return "\n<h" .. titleLevel .. ">" .. strtrim(title) .. "</h" .. titleLevel .. ">";
	end;

	text = text:gsub("^(#+)(.-)\n", titleFunction);
	text = text:gsub("\n(#+)(.-)\n", titleFunction);
	text = text:gsub("\n(#+)(.-)$", titleFunction);
	text = text:gsub("^(#+)(.-)$", titleFunction);

	-- 4) Replacement : text tags
	for pattern, replacement in pairs(structureTags) do
		text = text:gsub(pattern, replacement);
	end

	local tab = {};
	local i=1;
	while text:find("<") and i<500 do

		local before;
		before = text:sub(1, text:find("<") - 1);
		if #before > 0 then
			tinsert(tab, before);
		end

		local tagText;

		local tag = text:match("</(.-)>");
		if tag then
			tagText = text:sub( text:find("<"), text:find("</") + #tag + 2);
			if #tagText == #tag + 3 then
				return loc("PATTERN_ERROR");
			end
			tinsert(tab, tagText);
		else
			return loc("PATTERN_ERROR");
		end

		local after;
		after = text:sub(#before + #tagText + 1);
		text = after;

		--		Log.log("Iteration "..i);
		--		Log.log("before ("..(#before).."): "..before);
		--		Log.log("tagText ("..(#tagText).."): "..tagText);
		--		Log.log("after ("..(#before).."): "..after);

		i = i+1;
		if i == 500 then
			log("HTML overfloooow !", Log.level.SEVERE);
		end
	end
	if #text > 0 then
		tinsert(tab, text); -- Rest of the text
	end

	--	log("Parts count "..(#tab));

	local finalText = "";
	for _, line in pairs(tab) do

		if not line:find("<") then
			line = "<P>" .. line .. "</P>";
		end
		line = line:gsub("\n","<br/>");

		line = line:gsub("{img%:(.-)%:(.-)%:(.-)%}",
			"</P><img src=\"%1\" align=\"center\" width=\"%2\" height=\"%3\"/><P>");

		line = line:gsub("%!%[(.-)%]%((.-)%)", function(icon, size)
			if icon:find("\\") then
				local width, height;
				if size:find("%,") then
					width, height = strsplit(",", size);
				else
					width = tonumber(size) or 128;
					height = width;
				end
				return "</P><img src=\"".. icon .. "\" align=\"center\" width=\"".. width .. "\" height=\"" .. height .. "\"/><P>";
			end
			return Utils.str.icon(icon, tonumber(size) or 25);
		end);

		line = line:gsub("%[(.-)%]%((.-)%)",
			"<a href=\"%2\">" .. linkColor .. "[%1]|r</a>");

		line = line:gsub("{link%*(.-)%*(.-)}",
			"<a href=\"%1\">" .. linkColor .. "[%2]|r</a>");

		line = line:gsub("{twitter%*(.-)%*(.-)}",
			"<a href=\"twitter%1\">|cff61AAEE%2|r</a>");

		finalText = finalText .. line;
	end

	finalText = convertTextTags(finalText);

	return "<HTML><BODY>" .. finalText .. "</BODY></HTML>";
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- COMPRESSION / Serialization / HASH
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local libCompress = LibStub:GetLibrary("LibCompress");
local libCompressEncoder = libCompress:GetAddonEncodeTable();
local libSerializer = LibStub:GetLibrary("AceSerializer-3.0");

local function serialize(structure)
	return libSerializer:Serialize(structure);
end
Utils.serial.serialize = serialize;

local function deserialize(structure)
	local status, data = libSerializer:Deserialize(structure);
	assert(status, "Deserialization error:\n" .. tostring(structure) .. "\n" .. tostring(data));
	return data;
end
Utils.serial.deserialize = deserialize;

Utils.serial.errorCount = 0;
local function safeDeserialize(structure, default)
	local status, data = libSerializer:Deserialize(structure);
	if not status then
		Log.log("Deserialization error:\n" .. tostring(structure) .. "\n" .. tostring(data), Log.level.WARNING);
		return default;
	end
	return data;
end
Utils.serial.safeDeserialize = safeDeserialize;

local function encodeCompressMessage(message)
	return libCompressEncoder:Encode(libCompress:Compress(message));
end
Utils.serial.encodeCompressMessage = encodeCompressMessage;

Utils.serial.decompressCodedMessage = function(message)
	return libCompress:Decompress(libCompressEncoder:Decode(message));
end

Utils.serial.safeEncodeCompressMessage = function(serial)
	local encoded = encodeCompressMessage(serial);
	-- Rollback test
	local decoded = Utils.serial.decompressCodedMessage(encoded);
	if decoded == serial then
		return encoded;
	else
		Log.log("safeEncodeCompressStructure error:\n" .. tostring(serial), Log.level.WARNING);
		return nil;
	end
end

Utils.serial.decompressCodedStructure = function(message)
	return deserialize(libCompress:Decompress(libCompressEncoder:Decode(message)));
end

Utils.serial.safeDecompressCodedStructure = function(message)
	return safeDeserialize(libCompress:Decompress(libCompressEncoder:Decode(message)));
end

Utils.serial.encodeCompressStructure = function(structure)
	return encodeCompressMessage(serialize(structure));
end

Utils.serial.hashCode = function(str)
	return libCompress:fcs32final(libCompress:fcs32update(libCompress:fcs32init(), str));
end