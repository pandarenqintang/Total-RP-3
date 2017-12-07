----------------------------------------------------------------------------------
--- Total RP 3
---
---	HTML engine
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

local HTML = {};
TRP3_API.HTML = HTML;

-- WoW imports
local strtrim = strtrim;
local pairs = pairs;
local gsub = string.gsub;
local find = string.find;
local match = string.match;
local format = string.format;
local sub = string.sub;
local tinsert = table.insert;
local tonumber = tonumber;
local strsplit = strsplit;
local strconcat = strconcat;
local HTML_START = HTML_START;
local HTML_END = HTML_END;

-- Total RP 3 imports
local Strings = TRP3_API.Strings;
local Colors = TRP3_API.Colors;
local Textures = TRP3_API.Textures;
local Logs = TRP3_API.Logs;
local loc = TRP3_API.loc;

-- List of Total RP 3's custom text tags
local TRP3_TEXT_TAGS = {
	TITLE = "{h(%d)}",
	TITLE_CENTER = "{h(%d):c}",
	TITLE_RIGHT = "{h(%d):r}",
	END_OF_TITLE = "{/h(%d)}",

	PARAGRAPH = "{p}",
	PARAGRAPH_CENTER = "{p:c}",
	PARAGRAPH_RIGHT = "{p:r}",
	END_OF_PARAGRAPH = "{/p}",

	END_OF_LINE = "\n",

	LINK = "{link%*(.-)%*(.-)}", -- {link*www.google.com*Google}
	TWITTER_LINK = "{twitter%*(.-)%*(.-)}", -- {twitter*EllypseCelwe*Ellypse lord of cats}
	IMAGE = "{img%:(.-)%:(.-)%:(.-)%}", -- {img:path/to/texture:16:9}
}

-- List of supported HTML tags
local HTML_TAGS = {
	TITLE = [[<h%s>]],
	TITLE_CENTER = [[<h%s align="center">]],
	TITLE_RIGHT = [[<h%s align="right">]],
	END_OF_TITLE = [[</h%s>]],

	PARAGRAPH = [[<P>]],
	PARAGRAPH_CENTER = [[<P align="center">]],
	PARAGRAPH_RIGHT = [[<P align="right">]],
	END_OF_PARAGRAPH = [[</P>]],

	END_OF_LINE = "<br/>",

	LINK = [[<a href="%s">[%s]</a>]];
	IMAGE = [[<img src="%s" align="center" width="%s" height="%s"/>]]
};

-- Mapping of the simple replacements ({h1} => <h1>)
local SIMPLE_REPLACEMENTS = {
	[TRP3_TEXT_TAGS.TITLE] = format(HTML_TAGS.TITLE, "%1"),
	[TRP3_TEXT_TAGS.TITLE_CENTER] = format(HTML_TAGS.TITLE_CENTER, "%1"),
	[TRP3_TEXT_TAGS.TITLE_RIGHT] = format(HTML_TAGS.TITLE_RIGHT, "%1"),
	[TRP3_TEXT_TAGS.END_OF_TITLE] = format(HTML_TAGS.END_OF_TITLE, "%1"),

	[TRP3_TEXT_TAGS.PARAGRAPH] = HTML_TAGS.PARAGRAPH,
	[TRP3_TEXT_TAGS.PARAGRAPH_CENTER] = HTML_TAGS.PARAGRAPH_CENTER,
	[TRP3_TEXT_TAGS.PARAGRAPH_RIGHT] = HTML_TAGS.PARAGRAPH_RIGHT,
	[TRP3_TEXT_TAGS.END_OF_PARAGRAPH] = HTML_TAGS.END_OF_PARAGRAPH,
	[TRP3_TEXT_TAGS.END_OF_LINE] = HTML_TAGS.END_OF_LINE,
}

-- List of the supporterd Markdown tags
local MARKDOWN_TAGS = {
	TITLES = {
		"^(#+)(.-)\n"
		"\n(#+)(.-)\n"
		"\n(#+)(.-)$"
		"^(#+)(.-)$"
	},
	TEXTURE = "%!%[(.-)%]%((.-)%)", -- ![path/to/texture](16,9) or ![iconName](25)
	LINK = "%[(.-)%]%((.-)%)", -- [Google](www.google.com)
}

local ESCAPED_HTML_CHARACTERS = {
	["<"] = "&lt;",
	[">"] = "&gt;",
	["\""] = "&quot;",
};

local LINKS_COLOR = Colors.COLORS.GREEN;

local function titleTag(titleLevel, title)
	return strconcat("\n", format(HTML_TAGS.TITLE, titleLevel), strtrim(title), HTML_TAGS.END_OF_TITLE);
end;

local function markdownTitleTag(titleChars, title)
	return titleTag(#titleChars, title);
end

local function generateHTMLImage(texture, width, height)
	if not width then
		width = 128;
	end
	if not height then
		height = width;
	end
	strconcat(HTML_TAGS.END_OF_PARAGRAPH, format(HTML_TAGS.IMAGE, texture, width, height), HTML_TAGS.PARAGRAPH);
end

local function markdownTextureToHTML(texture, size)
	-- The icon is a path, it will be insert as an image
	if find(texture, "\\") then
		local width, height;
		-- Height and width are separated by a ,
		if find(size, "%,") then
			width, height = strsplit(",", size);
		else
			-- If only one value is provided, use it for both width and height
			width = tonumber(size);
		end
		return generateHTMLImage(texture, width, height);
	end
	-- Else the texture is a text, an icon name, and an icon tag will be used instead
	return Textures.iconTag(texture, tonumber(size) or 25);
end

local function generateHTMLLink(linkText, url, linkColor)
	if LINKS_COLOR then
		linkText = LINKS_COLOR:WrapTextInColorCode(linkText);
	end
	return format(HTML_TAGS.LINK, url, linkText);
end

function HTML.convertTRP3TagsIntoHTML(text, noColor)

	-- 1) Replacement : & character
	text = gsub(text, "&", "&amp;");

	-- 2) Replacement : escape HTML characters
	for pattern, replacement in pairs(ESCAPED_HTML_CHARACTERS) do
		text = gsub(text, pattern, replacement);
	end

	-- 3) Replace Markdown
	for _, titleTag in pairs(MARKDOWN_TAGS) do
		text = gsub(text, titleTag, markdownTitleTag);
	end

	-- 4) Replacement : text tags
	for pattern, replacement in pairs(SIMPLE_REPLACEMENTS) do
		text = gsub(text, pattern, replacement);
	end

	local tab = {};
	local i = 1;
	while find(text, "<") and i < 500 do

		local before;
		before = sub(text,1, find(text, "<") - 1);
		if #before > 0 then
			tinsert(tab, before);
		end

		local tagText;

		local tag = match(text, "</(.-)>");
		if tag then
			tagText = sub(text,  find(text, "<"), find(text, "</") + #tag + 2);
			if #tagText == #tag + 3 then
				return loc.PATTERN_ERROR;
			end
			tinsert(tab, tagText);
		else
			return loc.PATTERN_ERROR;
		end

		local after;
		after = sub(text, #before + #tagText + 1);
		text = after;

		i =  i + 1;

		if i == 500 then
			Logs.severe("HTML overfloooow !");
		end
	end

	if #text > 0 then
		tinsert(tab, text); -- Rest of the text
	end

	local finalText = "";
	for _, line in pairs(tab) do

		-- If there is absolutely no tag in the text, it needs to at least be inside a <P> tag
		if not find(line, "<") then
			line = HTML_TAGS.PARAGRAPH .. line .. HTML_TAGS.END_OF_PARAGRAPH;
		end

		-- Replace all end of lines with the <br/> tag
		line = gsub(line, TRP3_TEXT_TAGS.END_OF_LINE,HTML_TAGS.END_OF_LINE);

		-- Replace TRP3 image tags
		line = gsub(line, TRP3_TEXT_TAGS.IMAGE, generateHTMLImage);

		-- Markdown styled images ![texture path](size)
		line = gsub(line, MARKDOWN_TAGS.TEXTURE, markdownTextureToHTML);

		-- Markdown styled links [link text](url)
		line = gsub(line, MARKDOWN_TAGS.LINK, function(linkText, url)
			generateHTMLLink(linkText, url, not noColor and LINKS_COLOR)
		end );

		-- TRP3 styled links
		line = gsub(line, TRP3_TEXT_TAGS.LINK, function(url, linkText)
			generateHTMLLink(linkText, url, not noColor and LINKS_COLOR);
		end);

		-- Twitter links
		line = gsub(line, TRP3_TEXT_TAGS.TWITTER_LINK, function(twitterHandle, twitterUsername)
			generateHTMLLink(twitterUsername, "twitter" .. twitterHandle, not noColor and Colors.COLORS.TWITTER);
		end);

		finalText = finalText .. line;
	end

	finalText = Strings.convertTextTags(finalText);

	return HTML_START .. finalText .. HTML_END;
end