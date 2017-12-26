----------------------------------------------------------------------------------
--- Total RP 3
---
---	String tools
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

local Strings = {};
TRP3_API.Strings = Strings;

-- WoW imports
local pairs = pairs;
local tostring = tostring;
local tConcat = table.concat;
local assert = assert;
local string = string;
local match = string.match;
local random = math.random;
local date = date;
local tinsert = table.insert;
local pcall = pcall;
local strconcat = strconcat;
local strtrim = strtrim;
local gsub = string.gsub;
local type = type;

-- Total RP 3 imports
local isType = TRP3_API.Assertions.isType;
local isNotEmpty = TRP3_API.Assertions.isNotEmpty;

---@param table table @ A table of element
---@param optional customSeparator string @ A custom separator to use to when concatenating the table (default is " ").
---@return string
function Strings.convertTableToString(table, customSeparator)
	assert(isType(table, "table", "table"));
	-- If the table is empty we will just return empty string
	if not isNotEmpty(table) then return "" end
	-- If no custom separator was indicated we use " " as default
	if not customSeparator then
		customSeparator = " ";
	end
	-- Create a table of string values
	local toStringedMessages = {};
	for k, v in pairs(table) do
		toStringedMessages[k] = tostring(v);
	end
	-- Concat the table of string values with the separator
	return tConcat(toStringedMessages, " ");
end

-- Only used for French related stuff, it's okay if non-latin characters are not here
-- Note: We have a list of lowercase and uppercase letters here, because string.lower doesn't
-- like accentuated uppercase letters at all, so we can't have just lowercase letters and apply a string.lower.
local VOWELS = { "a", "e", "i", "o", "u", "y", "A"; "E", "I", "O", "U", "Y", "À", "Â", "Ä", "Æ", "È", "É", "Ê", "Ë", "Î", "Ï", "Ô", "Œ", "Ù", "Û", "Ü", "Ÿ", "à", "â", "ä", "æ", "è", "é", "ê", "ë", "î", "ï", "ô", "œ", "ù", "û", "ü", "ÿ" };
VOWELS = tInvert(VOWELS); -- Invert the table so it is easier to check if something is a vowel

---@param letter string @ A single letter as a string (can be uppercase or lowercase)
---@return boolean isAVowel @ True if the letter is a vowel
function Strings.isAVowel(letter)
	assert(isType(letter, "string", "letter"));
	return VOWELS[letter] == true;
end

---@param text string
---@return string letter @ The first letter in the string that was passed
function Strings.getFirstLetter(text)
	assert(isType(text, "string", "text"));
	return string.sub(text, 1, 1);
end

-- Build a list of characters that can be used to generate IDs
local ID_CHARS = {};
for i = 48, 57 do
	tinsert(ID_CHARS, string.char(i));
end
for i = 65, 90 do
	tinsert(ID_CHARS, string.char(i));
end
for i = 97, 122 do
	tinsert(ID_CHARS, string.char(i));
end
local sID_CHARS = #ID_CHARS;

---	Generate a pseudo-unique random ID.
--- If you encounter a collision, you really should playing lottery
---	ID's have a id_length characters length
---@return string ID @ Generated ID
function Strings.generateID()
	local ID = date("%m%d%H%M%S");
	for i=1, 5 do
		ID = ID .. ID_CHARS[random(1, sID_CHARS)];
	end
	return ID;
end

--- A secure way to check if a String matches a pattern.
--- This is useful when using user-given pattern, as malformed pattern would produce lua error.
---@param stringToCheck string @ The string in which we will search for the pattern
---@param pattern string @ Lua matching pattern
---@return number foundIndex @ The index at which the string was found
function Strings.match(stringToCheck, pattern)
	local ok, result = pcall(string.find, string.lower(stringToCheck), string.lower(pattern));
	if not ok then
		return false; -- Syntax error.
	end
	-- string.find should return a number if the string matches the pattern
	return string.find(tostring(result), "%d");
end

--- Generate a pseudo-unique random ID while checking a table for possible collisions.
---@param table table @ A table where indexes are IDs generated via Strings.generateID
---@return string ID @ An ID that is not already used inside this table
function Strings.generateUniqueID(table)
	local ID = Strings.generateID();
	while table[ID] do
		ID = Strings.generateID();
	end
	return ID;
end

--- Create a unit ID from a unit name and unit realm. If realm = nil then we use current realm.
--- This method ALWAYS return a nil free UnitName-RealmShortName string.
---@param unitName string @ The unit name of the player
---@param unitRealmID string @ The realm without spaces (WrymrestAccord)
---@return unitID string @ A properly formatted unitID (PlayerName-RealmName)
function Strings.unitInfoToID(unitName, unitRealmID)
	-- Some functions (like GetPlayerInfoByGUID(GUID)) will return an empty string for the realm instead of null…
	-- Thanks Blizz…
	if not unitRealmID or unitRealmID == "" then
		unitRealmID = TRP3_API.globals.player_realm_id
	end
	return strconcat(unitName or "_", '-', unitRealmID);
end

--- Separates the unit name and realm from an unit ID
---@param unitID string @ A properly formatted unitID (PlayerName-RealmName)
---@return unitName, unitRealm string,string @ Returns the unit name and the server of the unit
function Strings.unitIDToInfo(unitID)
	-- We can get unitID without a server, this means the unit is from the same server as the player
	if not unitID:find('-') then
		return unitID, TRP3_API.globals.player_realm_id;
	end
	return unitID:sub(1, unitID:find('-') - 1), unitID:sub(unitID:find('-') + 1);
end

--- Separates the owner ID and companion name from a companion ID
---@param companionID string
---@return string, string companionID, ownerID
function Strings.companionIDToInfo(companionID)
	if not companionID:find('_') then
		return companionID, nil;
	end
	return companionID:sub(1, companionID:find('_') - 1), companionID:sub(companionID:find('_') + 1);
end

--- Check if a text is an empty string and returns nil instead
---@param text string @ The string to check
---@return string|nil text @ Returns nil if the given text was empty
function Strings.emptyToNil(text)
	if text and #text > 0 then
		return text;
	end
	return nil;
end

--- Search if the string matches the pattern in error-safe way.
--- Useful if the pattern his user written.
---@param text string @ The string to test
---@param pattern string @ The pattern to match
---@return boolean|nil matched @ Returns true if the pattern was matched in the given text
function Strings.safeMath(text, pattern)
	local trace = {pcall(string.find, text, pattern)};
	if trace[1] then
		return type(trace[2]) == "number";
	end
	return nil; -- Pattern error
end

--- Assure that the given string will not be nil
---@param text string|nil @ A string that could be nil
---@return string text @ Always return a string, empty string if the given text was nil
function Strings.nilToEmpty(text)
	return text or "";
end

local TRP3_TAGS = {
	END_OF_COLOR = "/col", -- {/col}
	SINGLE_LETTER_COLOR = "^col%:(%a)$", -- {col:r}
	HEXADECIMAL_COLOR_CODE = "^col:(%x%x%x%x%x%x)$", -- {col:aabbcc}
	ICON = "^icon%:([%w%s%_%-%d]+)%:(%d+)$" -- {icon:texture:size}
}

local TEXT_TAGS = {
	END_OF_COLOR = "|r"
}

local DIRECT_TAG_REPLACEMENTS = {
	[TRP3_TAGS.END_OF_COLOR] = TEXT_TAGS.END_OF_COLOR,
};

---@param tag string @ Total RP 3 tag
---@return string convertedTag @ Tag converted into a UI escape sequence
local function convertTextTag(tag)

	if DIRECT_TAG_REPLACEMENTS[tag] then -- Direct replacement
		return DIRECT_TAG_REPLACEMENTS[tag];

	-- Single character color shortcut replacement ({col:r})
	elseif match(tag, TRP3_TAGS.SINGLE_LETTER_COLOR) then
		local color = TRP3_API.Colors.get(match(tag, TRP3_TAGS.SINGLE_LETTER_COLOR));
		return "|c" .. color:GenerateHexColor();

	-- Hexa color code replacement ({col:aabbcc})
	elseif match(tag, TRP3_TAGS.HEXADECIMAL_COLOR_CODE) then
		return "|cff" .. match(tag, TRP3_TAGS.HEXADECIMAL_COLOR_CODE);

	-- Icon tag replacement ({icon:texture:size})
	elseif match(tag, TRP3_TAGS.ICON) then
		local icon, size = match(tag, TRP3_TAGS.ICON);
		return TRP3_API.Textures.iconTag(icon, size);
	end

	-- If nothing was found, the text is returned as it was before, including the { }
	return "{"..tag.."}";
end

function Strings.convertTextTags(text)
	if text then
		text = text:gsub("%{(.-)%}", convertTextTag);
		return text;
	end
end

local SANITIZATION_PATTERNS = {
	["|c%x%x%x%x%x%x%x%x"] = "", -- color start
	["|r"] = "", -- color end
	["|H.-|h(.-)|h"] = "%1", -- links
	["|T.-|t"] = "", -- textures
}

---Sanitize a given text, removing potentially harmful escape sequences that could have been added by a end user (to display huge icons in their tooltips, for example).
---@param text string @ A text that should be sanitized
---@return string sanitizedText @ The sanitized version of the given text
function Strings.sanitize(text)
	if not text then
		return
	end
	for k, v in pairs(SANITIZATION_PATTERNS) do
		text = gsub(text, k, v);
	end
	return text;
end

---Crop a string of text if it is longer than the given size, and append … to indicate that the text has been cropped by default.
---@param text string @ The string of text that will be cropped
---@param size number @ The number of characters at which the text will be cropped.
---@param optional appendEllipsisAtTheEnd boolean @ Indicates if ellipsis (…) should be appended at the end of the text when cropped (defaults to true)
---@return string croppedText @ The cropped version of the text if it was longer than the given size, or the untouched version if the text was shorter.
function Strings.crop(text, size, appendEllipsisAtTheEnd)
	assert(isType(text, "text", "text"));
	assert(isType(size, "number", "size"));
	assert(size > 0, "Size has to be a positive number.");

	if appendEllipsisAtTheEnd == nil then
		appendEllipsisAtTheEnd = true;
	end

	text = strtrim(text or "");
	if text:len() > size then
		text = text:sub(1, size);
		if appendEllipsisAtTheEnd then
			text = text .. "…";
		end
	end
	return text
end

local COLORS_SHORTCUT = {
	["r"] = "RED",
	["g"] = "GREEN",
	["b"] = "BLUE",
	["y"] = "YELLOW",
	["p"] = "PURPLE",
	["c"] = "CYAN",
	["w"] = "WHITE",
	["0"] = "BLACK",
	["o"] = "ORANGE",
}

--- Returns a color tag based on a letter (shortcut)
function Strings.color(colorShortcut)
	if not colorShortcut then
		colorShortcut = "w"; -- default color if bad argument
	end
	local color = TRP3_API.Colors.COLORS[COLORS_SHORTCUT[COLORS_SHORTCUT]] or TRP3_API.Colors.COLORS.WHITE;
	return "|c" .. color:GenerateHexColor();
end