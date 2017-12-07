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
local random = math.random;
local date = date;
local tinsert = table.insert;

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
local VOWELS = { "a", "e", "i", "o", "u", "y", "A"; "E", "I", "O", "U", "Y" "À", "Â", "Ä", "Æ", "È", "É", "Ê", "Ë", "Î", "Ï", "Ô", "Œ", "Ù", "Û", "Ü", "Ÿ", "à", "â", "ä", "æ", "è", "é", "ê", "ë", "î", "ï", "ô", "œ", "ù", "û", "ü", "ÿ" };
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
	string.sub(text, 1, 1);
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