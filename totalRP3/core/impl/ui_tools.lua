----------------------------------------------------------------------------------
-- Total RP 3
-- UI tools
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

TRP3_API.ui.listbox = {};
TRP3_API.ui.list = {};
TRP3_API.ui.text = {};

-- imports
local globals = TRP3_API.globals;
local loc = TRP3_API.locale.getText;
local floor, tinsert, pairs, wipe, assert, _G, tostring, table, type, strconcat = floor, tinsert, pairs, wipe, assert, _G, tostring, table, type, strconcat;
local math = math;
local MouseIsOver, CreateFrame, ToggleDropDownMenu = MouseIsOver, CreateFrame, L_ToggleDropDownMenu;
local UIDropDownMenu_Initialize, UIDropDownMenu_CreateInfo, UIDropDownMenu_AddButton = L_UIDropDownMenu_Initialize, L_UIDropDownMenu_CreateInfo, L_UIDropDownMenu_AddButton;
local CloseDropDownMenus = L_CloseDropDownMenus;
local TRP3_MainTooltip, TRP3_MainTooltipTextRight1, TRP3_MainTooltipTextLeft1, TRP3_MainTooltipTextLeft2 = TRP3_MainTooltip, TRP3_MainTooltipTextRight1, TRP3_MainTooltipTextLeft1, TRP3_MainTooltipTextLeft2;
local shiftDown = IsShiftKeyDown;
local UnitIsBattlePetCompanion, UnitIsUnit, UnitIsOtherPlayersPet, UnitIsOtherPlayersBattlePet = UnitIsBattlePetCompanion, UnitIsUnit, UnitIsOtherPlayersPet, UnitIsOtherPlayersBattlePet;
local UnitIsPlayer = UnitIsPlayer;
local getUnitID = TRP3_API.utils.str.getUnitID;
local numberToHexa = TRP3_API.utils.color.numberToHexa;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Frame utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local tiledBackgrounds = {
	"Interface\\DialogFrame\\UI-DialogBox-Background", -- 1
	"Interface\\BankFrame\\Bank-Background", -- 2
	"Interface\\FrameGeneral\\UI-Background-Marble", -- 3
	"Interface\\FrameGeneral\\UI-Background-Rock", -- 4
	"Interface\\GuildBankFrame\\GuildVaultBG", -- 5
	"Interface\\HELPFRAME\\DarkSandstone-Tile", -- 6
	"Interface\\HELPFRAME\\Tileable-Parchment", -- 7
	"Interface\\QuestionFrame\\question-background", -- 8
	"Interface\\RAIDFRAME\\UI-RaidFrame-GroupBg", -- 9
	"Interface\\Destiny\\EndscreenBG", -- 10
	"Interface\\Stationery\\AuctionStationery1", -- 11
	"Interface\\Stationery\\Stationery_ill1", -- 12
	"Interface\\Stationery\\Stationery_OG1", -- 13
	"Interface\\Stationery\\Stationery_TB1", -- 14
	"Interface\\Stationery\\Stationery_UC1", -- 15
	"Interface\\Stationery\\StationeryTest1", -- 16
	"Interface\\WorldMap\\UI-WorldMap-Middle1", -- 17
	"Interface\\WorldMap\\UI-WorldMap-Middle2", -- 18
	"Interface\\ACHIEVEMENTFRAME\\UI-Achievement-StatsBackground" -- 19
};

function TRP3_API.ui.frame.getTiledBackground(index)
	return tiledBackgrounds[index] or tiledBackgrounds[1];
end

function TRP3_API.ui.frame.getTiledBackgroundList()
	local tab = {};
	for index, texture in pairs(tiledBackgrounds) do
		tinsert(tab, {loc("UI_BKG"):format(tostring(index)), index, "|T" .. texture .. ":200:200|t"});
	end
	return tab;
end

function TRP3_API.ui.frame.createRefreshOnFrame(frame, time, callback)
	assert(frame and time and callback, "Argument must be not nil");
	frame.refreshTimer = 1000;
	frame:SetScript("OnUpdate", function(arg, elapsed)
		frame.refreshTimer = frame.refreshTimer + elapsed;
		if frame.refreshTimer > time then
			frame.refreshTimer = 0;
			callback(frame, frame.refreshTimer);
		end
	end);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Drop down
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local DROPDOWN_FRAME = "TRP3_UIDD";
local dropDownFrame, currentlyOpenedDrop;

local function openDropDown(anchoredFrame, values, callback, space, addCancel)
	assert(anchoredFrame, "No anchoredFrame");

	if not dropDownFrame then
		dropDownFrame = CreateFrame("Frame", DROPDOWN_FRAME, UIParent, "UIDropDownMenuTemplate");
	end

	if _G["L_DropDownList1"]:IsVisible() then
		CloseDropDownMenus();
		return;
	end

	UIDropDownMenu_Initialize(dropDownFrame,
		function(uiFrame, level, menuList)
			local levelValues = menuList or values;
			level = level or 1;
			for index, tab in pairs(levelValues) do
				assert(type(tab) == "table", "Level value is not a table !");
				local text = tab[1];
				local value = tab[2];
				local tooltipText = tab[3];
				local info = UIDropDownMenu_CreateInfo();
				info.notCheckable = "true";
				if text == "" then
					info.dist = 0;
					info.isTitle = true;
					info.isUninteractable = true;
					info.iconOnly = 1;
					info.icon = "Interface\\Common\\UI-TooltipDivider-Transparent";
					info.iconInfo = {
						tCoordLeft = 0,
						tCoordRight = 1,
						tCoordTop = 0,
						tCoordBottom = 1,
						tSizeX = 0,
						tSizeY = 8,
						tFitDropDownSizeX = true
					};
				else
					info.text = text;
					info.isTitle = false;
					info.tooltipOnButton = tooltipText ~= nil;
					info.tooltipTitle = text;
					info.tooltipText = tooltipText;
					if type(value) == "table" then
						info.hasArrow = true;
						info.keepShownOnClick = true;
						info.menuList = value;
					elseif value ~= nil then
						info.func = function()
							anchoredFrame:GetParent().selectedValue = value;
							if callback then
								callback(value, anchoredFrame);
							end
							if level > 1 then
								ToggleDropDownMenu(nil, nil, dropDownFrame);
							end
							currentlyOpenedDrop = nil;
						end;
					else
						info.disabled = true;
						info.isTitle = tooltipText == nil;
					end
				end
				UIDropDownMenu_AddButton(info, level);
			end
			if menuList == nil and addCancel then
				local info = UIDropDownMenu_CreateInfo();
				info.notCheckable = "true";
				info.text = CANCEL;
				UIDropDownMenu_AddButton(info, level);
			end

		end,
		"MENU"
	);
	dropDownFrame:SetParent(anchoredFrame);
	ToggleDropDownMenu(1, nil, dropDownFrame, anchoredFrame:GetName() or "cursor", -((space or -10)), 0);
	TRP3_API.ui.misc.playUISound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
	currentlyOpenedDrop = anchoredFrame;
end
TRP3_API.ui.listbox.displayDropDown = openDropDown;

--- Setup a drop down menu for a clickable (Button ...)
local function setupDropDownMenu(hasClickFrame, values, callback, space, addCancel, rightClick)
	hasClickFrame:SetScript("OnClick", function(self, button)
		if (rightClick and button ~= "RightButton") or (not rightClick and button ~= "LeftButton") then return; end
		openDropDown(hasClickFrame, values, callback, space, addCancel);
	end);
end
TRP3_API.ui.listbox.setupDropDownMenu = setupDropDownMenu;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- ListBox tools
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function listBoxSetSelected(self, index)
	assert(self and self.values, "Badly initialized listbox");
	assert(self.values[index], "Array index out of bound");
	_G[self:GetName().."Text"]:SetText(self.values[index][1]);
	self.selectedValue = self.values[index][2];
	if self.callback then
		self.callback(self.values[index][2], self);
	end
end

local function listBoxSetSelectedValue(self, value)
	assert(self and self.values, "Badly initialized listbox");
	for index, tab in pairs(self.values) do
		local val = tab[2];
		if val == value then
			listBoxSetSelected(self, index);
			break;
		end
	end
end

local function listBoxGetValue(self)
	return self.selectedValue;
end

-- Setup a ListBox. When the player choose a value, it triggers the function passing the value of the selected element
local function setupListBox(listBox, values, callback, defaultText, boxWidth, addCancel)
	assert(listBox and values, "Invalid arguments");
	assert(_G[listBox:GetName().."Button"], "Invalid arguments: listbox doesn't have a button");
	boxWidth = boxWidth or 115;
	listBox.values = values;
	listBox.callback = callback;
	local listCallback = function(value)
		for index, tab in pairs(values) do
			local text = tab[1];
			local val = tab[2];
			if val == value then
				_G[listBox:GetName().."Text"]:SetText(text);
			end
		end
		if callback then
			callback(value, listBox);
		end
	end;

	setupDropDownMenu(_G[listBox:GetName().."Button"], values, listCallback, boxWidth, addCancel, false);

	listBox.SetSelectedIndex = listBoxSetSelected;
	listBox.GetSelectedValue = listBoxGetValue;
	listBox.SetSelectedValue = listBoxSetSelectedValue;

	if defaultText then
		_G[listBox:GetName().."Text"]:SetText(defaultText);
	end
	_G[listBox:GetName().."Middle"]:SetWidth(boxWidth);
	_G[listBox:GetName().."Text"]:SetWidth(boxWidth-20);
	listBox:SetWidth(boxWidth+50);
end
TRP3_API.ui.listbox.setupListBox = setupListBox;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- List tools
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- Handle the mouse wheel for the frame in order to slide the slider
TRP3_API.ui.list.handleMouseWheel = function(frame, slider)
	frame:SetScript("OnMouseWheel",function(self, delta)
		if slider:IsEnabled() then
			local mini,maxi = slider:GetMinMaxValues();
			if delta == 1 and slider:GetValue() > mini then
				slider:SetValue(slider:GetValue()-1);
			elseif delta == -1 and slider:GetValue() < maxi then
				slider:SetValue(slider:GetValue()+1);
			end
		end
	end);
	frame:EnableMouseWheel(1);
end

local function listShowPage(infoTab, pageNum)
	assert(infoTab.uiTab, "Error : no uiTab in infoTab.");

	-- Hide all widgets
	for k=1,infoTab.maxPerPage do
		infoTab.widgetTab[k]:Hide();
	end

	-- Show list
	for widgetIndex=1, infoTab.maxPerPage do
		local dataIndex = pageNum*infoTab.maxPerPage + widgetIndex;
		if dataIndex <= #infoTab.uiTab then
			infoTab.widgetTab[widgetIndex]:Show();
			infoTab.decorate(infoTab.widgetTab[widgetIndex], infoTab.uiTab[dataIndex]);
		else
			break;
		end
	end
end

-- Init a list.
-- Arguments :
-- 		infoTab, a structure containing :
-- 			- A widgetTab (the list of all widget used in a full page)
-- 			- A decorate function, which will receive 3 arguments : a widget and an ID. Decorate will be called on every couple "widget from widgetTab" and "id from dataTab".
--		dataTab, all the possible values
--		slider, the slider :3
TRP3_API.ui.list.initList = function(infoTab, dataTab, slider)
	assert(infoTab and dataTab and slider, "Error : no argument can be nil.");
	assert(infoTab.widgetTab, "Error : no widget tab in infoTab.");
	assert(infoTab.decorate, "Error : no decorate function in infoTab.");

	local count = 0;
	local maxPerPage = #infoTab.widgetTab;
	infoTab.maxPerPage = maxPerPage;

	if not infoTab.uiTab then
		infoTab.uiTab = {};
	end

	slider:Disable();
	slider:SetValueStep(1);
	slider:SetObeyStepOnDrag(true);
	wipe(infoTab.uiTab);

	if type(dataTab) == "table" then
		for key,_ in pairs(dataTab) do
			tinsert(infoTab.uiTab, key);
		end
	else
		for i=1, dataTab, 1 do
			tinsert(infoTab.uiTab, i);
		end
	end
	count = #infoTab.uiTab;

	table.sort(infoTab.uiTab);

	local checkUpDown = function(self)
		local minValue, maxValue = self:GetMinMaxValues();
		local value = self:GetValue();
		if self.downButton then
			self.downButton:Disable();
			if value < maxValue then
				self.downButton:Enable();
			end
		end
		if self.upButton then
			self.upButton:Disable();
			if value > minValue then
				self.upButton:Enable();
			end
		end
	end

	slider:SetScript("OnValueChanged", nil);
	if count > maxPerPage then
		slider:Enable();
		local total = floor((count-1)/maxPerPage);
		slider:SetMinMaxValues(0, total);
	else
		slider:SetMinMaxValues(0, 0);
		slider:SetValue(0);
	end
	checkUpDown(slider);
	slider:SetScript("OnValueChanged",function(self)
		if self:IsVisible() then
			listShowPage(infoTab, floor(self:GetValue()));
			checkUpDown(self);
		end
	end);
	listShowPage(infoTab, slider:GetValue());
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Companion ID
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local DUMMY_TOOLTIP = CreateFrame("GameTooltip", "TRP3_DUMMY_TOOLTIP", nil, "GameTooltipTemplate");
DUMMY_TOOLTIP:SetOwner( WorldFrame, "ANCHOR_NONE" );

local findPetOwner, findBattlePetOwner, UnitName = TRP3_API.locale.findPetOwner, TRP3_API.locale.findBattlePetOwner, UnitName;
TRP3_API.ui.misc.TYPE_CHARACTER = "CHARACTER";
TRP3_API.ui.misc.TYPE_PET = "PET";
TRP3_API.ui.misc.TYPE_BATTLE_PET = "BATTLE_PET";
TRP3_API.ui.misc.TYPE_MOUNT = "MOUNT";
TRP3_API.ui.misc.TYPE_NPC = "NPC";
local TYPE_CHARACTER = TRP3_API.ui.misc.TYPE_CHARACTER;
local TYPE_PET = TRP3_API.ui.misc.TYPE_PET;
local TYPE_BATTLE_PET = TRP3_API.ui.misc.TYPE_BATTLE_PET;
local TYPE_NPC = TRP3_API.ui.misc.TYPE_NPC;

function TRP3_API.ui.misc.isTargetTypeACompanion(unitType)
	return unitType == TYPE_BATTLE_PET or unitType == TYPE_PET;
end

---
-- Returns target type as first return value and boolean isMine as second.
function TRP3_API.ui.misc.getTargetType(unitType)
	if UnitIsPlayer(unitType) then
		return TYPE_CHARACTER, getUnitID(unitType) == globals.player_id;
	elseif UnitIsBattlePetCompanion(unitType) then
		return TYPE_BATTLE_PET, not UnitIsOtherPlayersBattlePet(unitType);
	elseif UnitIsUnit(unitType, "pet") or UnitIsOtherPlayersPet(unitType) then
		return TYPE_PET, UnitIsUnit(unitType, "pet");
	end
	if TRP3_API.utils.str.getUnitNPCID(unitType) then
		return TYPE_NPC, false;
	end
end

local function getDummyGameTooltipTexts()
	local tab = {};
	for j = 1, DUMMY_TOOLTIP:NumLines() do
		tab[j] = _G["TRP3_DUMMY_TOOLTIPTextLeft" ..  j]:GetText();
	end
	return tab;
end

local function getCompanionOwner(unitType, targetType)
	DUMMY_TOOLTIP:SetUnit(unitType);
	if targetType == TYPE_PET then
		return findPetOwner(getDummyGameTooltipTexts());
	elseif targetType == TYPE_BATTLE_PET then
		return findBattlePetOwner(getDummyGameTooltipTexts());
	end
end
TRP3_API.ui.misc.getCompanionOwner = getCompanionOwner;

function TRP3_API.ui.misc.getCompanionFullID(unitType, targetType)
	local unitName = UnitName(unitType);
	if unitName then
		local owner = getCompanionOwner(unitType, targetType);
		if owner ~= nil then
			if not owner:find("-") then
				owner = owner .. "-" .. globals.player_realm_id;
			end
			return owner .. "_" .. unitName, owner;
		end
	end
	return nil;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Toast
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
local TRP3_Toast, TRP3_ToastTextLeft1 = TRP3_Toast, TRP3_ToastTextLeft1;

local function toastUpdate(self, elapsed)
	self.delay = self.delay - elapsed;
	if self.delay <= 0 and not self.isFading then
		self.isFading = true;
		self:FadeOut();
	end
end

TRP3_Toast.delay = 0;
TRP3_Toast:SetScript("OnUpdate", toastUpdate);

function TRP3_API.ui.tooltip.toast(text, duration)
	TRP3_Toast:Hide();
	TRP3_Toast:SetOwner(TRP3_MainFramePageContainer, "ANCHOR_BOTTOM", 0, 60);
	TRP3_Toast:AddLine(text, 1, 1, 1, true);
	local font, _, outline = TRP3_ToastTextLeft1:GetFont();
	TRP3_ToastTextLeft1:SetFont(font, getTooltipSize(), outline);
	TRP3_ToastTextLeft1:SetNonSpaceWrap(true);
	TRP3_ToastTextLeft1:SetTextColor(1, 1, 1);
	TRP3_Toast:Show();
	TRP3_Toast.delay = duration or 3;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Fieldsets
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local FIELDSET_DEFAULT_CAPTION_WIDTH = 100;

function TRP3_API.ui.frame.setupFieldPanel(fieldset, text, size)
	if fieldset and _G[fieldset:GetName().."CaptionPanelCaption"] then
		_G[fieldset:GetName().."CaptionPanelCaption"]:SetText(text);
		if _G[fieldset:GetName().."CaptionPanel"] then
			_G[fieldset:GetName().."CaptionPanel"]:SetWidth(size or FIELDSET_DEFAULT_CAPTION_WIDTH);
		end
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Tab bar
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local tabBar_index = 0;
local tabBar_HEIGHT_SELECTED = 34;
local tabBar_HEIGHT_NORMAL = 32;

local function tabBar_onSelect(tabGroup, index)
	assert(#tabGroup.tabs >= index, "Index out of bound.");
	local i;
	for i=1, #tabGroup.tabs do
		local widget = tabGroup.tabs[i];
		if i == index then
			widget:SetAlpha(1);
			widget:Disable();
			widget:LockHighlight();
			_G[widget:GetName().."Left"]:SetHeight(tabBar_HEIGHT_SELECTED);
			_G[widget:GetName().."Middle"]:SetHeight(tabBar_HEIGHT_SELECTED);
			_G[widget:GetName().."Right"]:SetHeight(tabBar_HEIGHT_SELECTED);
			widget:GetHighlightTexture():SetAlpha(0.7);
			widget:GetHighlightTexture():SetDesaturated(1);
			tabGroup.current = index;
		else
			widget:SetAlpha(0.85);
			widget:Enable();
			widget:UnlockHighlight();
			_G[widget:GetName().."Left"]:SetHeight(tabBar_HEIGHT_NORMAL);
			_G[widget:GetName().."Middle"]:SetHeight(tabBar_HEIGHT_NORMAL);
			_G[widget:GetName().."Right"]:SetHeight(tabBar_HEIGHT_NORMAL);
			widget:GetHighlightTexture():SetAlpha(0.5);
			widget:GetHighlightTexture():SetDesaturated(0);
		end
	end
end

local function tabBar_redraw(tabGroup)
	local lastWidget;
	for _, tabWidget in pairs(tabGroup.tabs) do
		if tabWidget:IsShown() then
			tabWidget:ClearAllPoints();
			if lastWidget == nil then
				tabWidget:SetPoint("LEFT", 0, 0);
			else
				tabWidget:SetPoint("LEFT", lastWidget, "RIGHT", 2, 0);
			end
			lastWidget = tabWidget;
		end
	end
end

local function tabBar_size(tabGroup)
	return #tabGroup.tabs;
end

local function tabBar_setTabVisible(tabGroup, index, isVisible)
	assert(tabGroup.tabs[index], "Tab index out of bound.");
	if isVisible then
		tabGroup.tabs[index]:Show();
	else
		tabGroup.tabs[index]:Hide();
	end
	tabGroup:Redraw();
end

local function tabBar_selectTab(tabGroup, index)
	assert(tabGroup.tabs[index], "Tab index out of bound.");
	assert(tabGroup.tabs[index]:IsShown(), "Try to select a hidden tab.");
	tabGroup.tabs[index]:GetScript("OnClick")(tabGroup.tabs[index]);
end

function TRP3_API.ui.frame.createTabPanel(tabBar, data, callback, confirmCallback)
	assert(tabBar, "The tabBar can't be nil");

	local tabGroup = {};
	tabGroup.tabs = {};
	for index, tabData in pairs(data) do
		local text = tabData[1];
		local value = tabData[2];
		local width = tabData[3];
		local tabWidget = CreateFrame("Button", "TRP3_TabBar_Tab_" .. tabBar_index, tabBar, "TRP3_TabBar_Tab");
		tabWidget:SetText(text);
		tabWidget:SetWidth(width or (text:len() * 11));
		local clickFunction = function()
			tabBar_onSelect(tabGroup, index);
				if callback then
					callback(tabWidget, value);
				end
		end
		tabWidget:SetScript("OnClick", function(self)
			if not confirmCallback then
				clickFunction();
			else
				confirmCallback(function() clickFunction() end);
			end
		end);
		tinsert(tabGroup.tabs, tabWidget);
		tabBar_index = tabBar_index + 1;
	end

	tabGroup.Redraw = tabBar_redraw;
	tabGroup.Size = tabBar_size;
	tabGroup.SetTabVisible = tabBar_setTabVisible;
	tabGroup.SelectTab = tabBar_selectTab;
	tabGroup:Redraw();

	return tabGroup;
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Text toolbar
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local TAGS_INFO = {
	{
		openTags = {"{h1}", "{h1:c}", "{h1:r}"},
		closeTag = "{/h1}",
	},
	{
		openTags = {"{h2}", "{h2:c}", "{h2:r}"},
		closeTag = "{/h2}",
	},
	{
		openTags = {"{h3}", "{h3:c}", "{h3:r}"},
		closeTag = "{/h3}",
	},
	{
		openTags = {"{p:c}", "{p:r}"},
		closeTag = "{/p}",
	}
}

local function insertTag(tag, index, frame)
	local text = frame:GetText();
	local pre = text:sub(1, index);
	local post = text:sub(index + 1);
	text = strconcat(pre, tag, post);
	frame:SetText(text);
end

local function postInsertHighlight(index, tagSize, textSize, frame)
	frame:SetCursorPosition(index + tagSize + textSize);
	frame:HighlightText(index + tagSize, index + tagSize + textSize);
end

local function insertContainerTag(alignIndex, button, frame)
	assert(button.tagIndex and TAGS_INFO[button.tagIndex], "Button is not properly init with a tag index");
	local tagInfo = TAGS_INFO[button.tagIndex];
	local cursorIndex = frame:GetCursorPosition();
	insertTag(strconcat(tagInfo.openTags[alignIndex], loc("REG_PLAYER_ABOUT_T1_YOURTEXT"), tagInfo.closeTag), cursorIndex, frame);
	postInsertHighlight(cursorIndex, tagInfo.openTags[alignIndex]:len(), loc("REG_PLAYER_ABOUT_T1_YOURTEXT"):len(), frame);
end

local function onColorTagSelected(red, green, blue, frame)
	local cursorIndex = frame:GetCursorPosition();
	local tag = ("{col:%s}"):format(strconcat(numberToHexa(red), numberToHexa(green), numberToHexa(blue)));
	insertTag(tag .. "{/col}", cursorIndex, frame);
	frame:SetCursorPosition(cursorIndex + tag:len());
end

local function onIconTagSelected(icon, frame)
	local cursorIndex = frame:GetCursorPosition();
	local tag = ("{icon:%s:25}"):format(icon);
	insertTag(tag, cursorIndex, frame);
	frame:SetCursorPosition(cursorIndex + tag:len());
end

local function onImageTagSelected(image, frame)
	local cursorIndex = frame:GetCursorPosition();
	local tag = ("{img:%s:%s:%s}"):format(image.url, math.min(image.width, 512), math.min(image.height, 512));
	insertTag(tag, cursorIndex, frame);
	frame:SetCursorPosition(cursorIndex + tag:len());
end

local function onLinkTagClicked(frame)
	local cursorIndex = frame:GetCursorPosition();
	local tag = ("{link*%s*%s}"):format(loc("UI_LINK_URL"), loc("UI_LINK_TEXT"));
	insertTag(tag, cursorIndex, frame);
	frame:SetCursorPosition(cursorIndex + 6);
	frame:HighlightText(cursorIndex + 6, cursorIndex + 6 + loc("UI_LINK_URL"):len());
end

-- Drop down
local function onContainerTagClicked(button, frame, isP)
	local values = {};
	if not isP then
		tinsert(values, {loc("REG_PLAYER_ABOUT_P")});
		tinsert(values, {loc("CM_LEFT"), 1});
		tinsert(values, {loc("CM_CENTER"), 2});
		tinsert(values, {loc("CM_RIGHT"), 3});
	else
		tinsert(values, {loc("REG_PLAYER_ABOUT_HEADER")});
		tinsert(values, {loc("CM_CENTER"), 1});
		tinsert(values, {loc("CM_RIGHT"), 2});
	end
	openDropDown(button, values, function(alignIndex, button) insertContainerTag(alignIndex, button, frame) end, 0, true);
end

function TRP3_API.ui.text.setupToolbar(toolbar, textFrame, parentFrame, point, parentPoint)
	toolbar.title:SetText(loc("REG_PLAYER_ABOUT_TAGS"));
	toolbar.image:SetText(loc("CM_IMAGE"));
	toolbar.icon:SetText(loc("CM_ICON"));
	toolbar.color:SetText(loc("CM_COLOR"));
	toolbar.link:SetText(loc("CM_LINK"));
	toolbar.h1.tagIndex = 1;
	toolbar.h2.tagIndex = 2;
	toolbar.h3.tagIndex = 3;
	toolbar.p.tagIndex = 4;
	toolbar.h1:SetScript("OnClick", function(button) onContainerTagClicked(button, textFrame) end);
	toolbar.h2:SetScript("OnClick", function(button) onContainerTagClicked(button, textFrame) end);
	toolbar.h3:SetScript("OnClick", function(button) onContainerTagClicked(button, textFrame) end);
	toolbar.p:SetScript("OnClick", function(button) onContainerTagClicked(button, textFrame, true) end);
	toolbar.icon:SetScript("OnClick", function()
		TRP3_API.popup.showPopup(
			TRP3_API.popup.ICONS,
			{parent = parentFrame, point = point, parentPoint = parentPoint},
			{function(icon) onIconTagSelected(icon, textFrame) end});
	end);
	toolbar.color:SetScript("OnClick", function()
		TRP3_API.popup.showPopup(
			TRP3_API.popup.COLORS,
			{parent = parentFrame, point = point, parentPoint = parentPoint},
			{function(red, green, blue) onColorTagSelected(red, green, blue, textFrame) end});
	end);
	toolbar.image:SetScript("OnClick", function()
		TRP3_API.popup.showPopup(
			TRP3_API.popup.IMAGES,
			{parent = parentFrame, point = point, parentPoint = parentPoint},
			{function(image) onImageTagSelected(image, textFrame) end});
	end);
	toolbar.link:SetScript("OnClick", function() onLinkTagClicked(textFrame) end);
end