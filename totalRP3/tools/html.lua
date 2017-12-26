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
}

-- List of the supporterd Markdown tags
local MARKDOWN_TAGS = {
	TITLES = {
		"^(#+)(.-)\n",
		"\n(#+)(.-)\n",
		"\n(#+)(.-)$",
		"^(#+)(.-)$",
	},
	TEXTURE = "%!%[(.-)%]%((.-)%)", -- ![path/to/texture](16,9) or ![iconName](25)
	LINK = "%[(.-)%]%((.-)%)", -- [Google](www.google.com)
}

local LINKS_COLOR = Colors.COLORS.GREEN;

local function titleTag(titleLevel, title)
	return "\n<h" .. titleLevel .. ">" .. strtrim(title) .. "</h" .. titleLevel .. ">";
end

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

local ESCAPED_HTML_CHARACTERS = {
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

function HTML.convertTRP3TagsIntoHTML(text, noColor)

	local linkColor = "|cff00ff00";
	if noColor then
		linkColor = "";
	end

	-- 1) Replacement : & character
	text = gsub(text, "&", "&amp;");

	-- 2) Replacement : escape HTML characters
	for pattern, replacement in pairs(ESCAPED_HTML_CHARACTERS) do
		text = gsub(text, pattern, replacement);
	end

	-- 3) Replace Markdown
	local titleFunction = function(titleChars, title)
		local titleLevel = #titleChars;
		return "\n<h" .. titleLevel .. ">" .. strtrim(title) .. "</h" .. titleLevel .. ">";
	end;

	-- 3) Replace Markdown
	text = gsub(text, "^(#+)(.-)\n", titleFunction);
	text = gsub(text, "\n(#+)(.-)\n", titleFunction);
	text = gsub(text, "\n(#+)(.-)$", titleFunction);
	text = gsub(text, "^(#+)(.-)$", titleFunction);

	-- 4) Replacement : text tags
	for pattern, replacement in pairs(structureTags) do
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
			return Textures.icon(icon, tonumber(size) or 25);
		end);

		line = line:gsub("%[(.-)%]%((.-)%)",
		"<a href=\"%2\">" .. linkColor .. "[%1]|r</a>");

		line = line:gsub("{link%*(.-)%*(.-)}",
		"<a href=\"%1\">" .. linkColor .. "[%2]|r</a>");

		line = line:gsub("{twitter%*(.-)%*(.-)}",
		"<a href=\"twitter%1\">|cff61AAEE%2|r</a>");

		finalText = finalText .. line;
	end

	finalText = Strings.convertTextTags(finalText);

	return "<HTML><BODY>" .. finalText .. "</BODY></HTML>";
end