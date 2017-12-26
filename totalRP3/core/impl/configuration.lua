----------------------------------------------------------------------------------
--- Total RP 3
---
--- Settings API
---
---	---------------------------------------------------------------------------
---	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--- Copyright 2017 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
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

-- public accessor
local Configuration = {};
TRP3_API.Configuration = Configuration;

TRP3_API.configuration = TRP3_API.Deprecated.setUpAPIDeprecatedWarning(TRP3_API.Configuration, "Configuration", "TRP3_API.configuration", "TRP3_API.Configuration");

-- imports
local tonumber = tonumber;
local math = math;
local tinsert = tinsert;
local type = type;
local assert = assert;
local tostring = tostring;
local pairs = pairs;
local sort = sort;
local strconcat = strconcat;
local CreateFrame = CreateFrame;

-- Total RP 3 imports
local isType = TRP3_API.Assertions.isType;
local Events = TRP3_API.Events;
local loc = TRP3_API.loc;
local Colors = TRP3_API.Colors;
local Locale = TRP3_API.Locale;
local setTooltipForFrame = TRP3_API.ui.tooltip.setTooltipForSameFrame;
local setupListBox = TRP3_API.ui.listbox.setupListBox;
local registerMenu, selectMenu = TRP3_API.navigation.menu.registerMenu, TRP3_API.navigation.menu.selectMenu;
local registerPage, setPage = TRP3_API.navigation.page.registerPage, TRP3_API.navigation.page.setPage;

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Configuration methods
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

Configuration.KEYS = {
	ADDON_LOCALE = "AddonLocale",
	HEAVY_PROFILE_ALERT = "heavy_profile_alert",
	NEW_VERSION_ALERT = "new_version_alert",
	UI_SOUNDS = "ui_sounds",
	UI_ANIMATIONS = "ui_animations",

	-- TODO We should remove these options. It leads to bad bug reports
	USE_BROADCAST_CHANNEL = "comm_broad_use",
	BROADCAST_CHANNEL_NAME = "comm_broad_chan",
}

if TRP3_Configuration == nil then
	TRP3_Configuration = {};
end

local defaultValues = {};
local configHandlers = {};

local function registerHandler(key, callback)
	assert(isType(key, "string", "key"));
	assert(isType(callback, "function", "callback"));
	assert(defaultValues[key] ~= nil, "Unknown config key: " .. tostring(key));
	if not configHandlers[key] then
		configHandlers[key] = {};
	end
	tinsert(configHandlers[key], callback);
end

--- Register a callback that will be called every time a configuration value is changed
---@param key string @ A configuration key to observe
---@param callback func @ A callback that will be run every time the configuration is changed
function Configuration.registerHandler(key, callback)
	if type(key) == "table" then
		for _, k in pairs(key) do
			registerHandler(k, callback);
		end
	else
		registerHandler(key, callback);
	end
end

---Set the value of a configuration option.
---Will fire any callback that has been registered for this option if the value changed.
---@param key string @ A configuration key used to identify the option
---@param value any @ The value that should be saved in the settings for this configuration
function Configuration.setValue(key, value)
	assert(isType(key, "string", "key"));
	assert(defaultValues[key] ~= nil, "Unknown config key: " .. tostring(key));
	local old = TRP3_Configuration[key];
	TRP3_Configuration[key] = value;

	-- Only call the callbacks if the value changed
	if configHandlers[key] and old ~= value then
		for _, callback in pairs(configHandlers[key]) do
			callback(key, value);
		end
	end
end

---Get the value for the configuration option corresponding to the given key
---@param key string @ A configuration key
---@return any keyValue @ The value for the configuration key stored
function Configuration.getValue(key)
	assert(isType(key, "string", "key"));
	assert(defaultValues[key] ~= nil, "Unknown config key: " .. tostring(key));
	return TRP3_Configuration[key];
end

---Register a new configuration key with the given default value
---@param key string @ A configuration key to register
---@param defaultValue any @ The default value for this key
function Configuration.registerConfigKey(key, defaultValue)
	assert(isType(key, "string", "key"));
	assert(not defaultValues[key], "Config key already registered: " .. tostring(key));
	defaultValues[key] = defaultValue;
	if TRP3_Configuration[key] == nil then
		Configuration.setValue(key, defaultValue);
	end
end

---Restore the default value for a configuration key
---@param key string @ A configuration key to reset
function Configuration.resetValue(key)
	assert(isType(key, "string", "key"));
	assert(defaultValues[key] ~= nil, "Unknown config key: " .. tostring(key));
	Configuration.setValue(key, defaultValues[key]);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Configuration builder
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local GENERATED_WIDGET_INDEX = 0;
local optionsDependentOnOtherOptions = {};

local function buildConfigurationPage(structure)
	local optionsDependency = {};
	---@type Frame
	local lastWidget;
	local marginLeft = structure.marginLeft or 5;

	for index, element in pairs(structure.elements) do
		---@type Frame
		local widget = element.widget or CreateFrame("Frame", element.widgetName or ("TRP3_ConfigurationWidget"..GENERATED_WIDGET_INDEX), structure.parent, element.inherit);
		widget:ClearAllPoints();
		widget:SetPoint("LEFT", structure.parent, "LEFT", marginLeft + (element.marginLeft or 5), 0);
		widget:SetPoint("RIGHT", structure.parent, "RIGHT", -marginLeft, 0);
		if lastWidget ~= nil then
			widget:SetPoint("TOP", lastWidget, "BOTTOM", 0, element.marginTop or 0);
		else
			widget:SetPoint("TOP", structure.parent, "TOP", 0, element.marginTop or 0);
		end
		element.widget = widget;

		-- Titles
		if element.title then
			if _G[widget:GetName().."Title"] then
				_G[widget:GetName().."Title"]:SetText(element.title);
			elseif element.title and _G[widget:GetName().."Text"] then
				_G[widget:GetName().."Text"]:SetText(element.title);
			end
		end

		-- Help
		if _G[widget:GetName().."Help"] then
			local help = _G[widget:GetName().."Help"];
			if element.help then
				help:Show();
				setTooltipForFrame(help, "RIGHT", 0, 5, element.title, element.help);
			else
				help:Hide();
			end
		end

		-- Specific for Dropdown
		if _G[widget:GetName().."DropDown"] then
			local dropDown = _G[widget:GetName().."DropDown"];
			element.controller = _G[widget:GetName().."DropDownButton"];
			if element.configKey then
				if not element.listCallback then
					element.listCallback = function(value)
						Configuration.setValue(element.configKey, value);
					end
				end
			end
			setupListBox(
				dropDown,
				element.listContent or {},
				element.listCallback,
				element.listDefault or "",
				element.listWidth or 134,
				element.listCancel
			);
			if element.configKey and not element.listDefault then
				dropDown:SetSelectedValue(Configuration.getValue(element.configKey));
			end
		end

		-- Specific for Color picker
		if _G[widget:GetName().."Picker"] then
			if element.configKey then
				local button = _G[widget:GetName().."Picker"];
				element.controller = button;
				button.setColor(Colors.hexaToNumber(Configuration.getValue(element.configKey)));
				button.onSelection = function(red, green, blue)
					if red and green and blue then
						local hexa = strconcat(Colors.numberToHexa(red), Colors.numberToHexa(green), Colors.numberToHexa(blue))
						Configuration.setValue(element.configKey, hexa);
					else
						button.setColor(Colors.hexaToNumber(defaultValues[element.configKey]));
					end
				end;
			end
		end

		-- Specific for Button
		if _G[widget:GetName().."Button"] then
			local button = _G[widget:GetName().."Button"];
			element.controller = button;
			if element.callback then
				button:SetScript("OnClick", element.callback);
			end
			button:SetText(element.text or "");
		end

		-- Specific for EditBox
		if _G[widget:GetName().."Box"] then
			local box = _G[widget:GetName().."Box"];
			element.controller = box;
			if element.configKey then
				box:SetScript("OnTextChanged", function(self)
					local value = self:GetText();
					Configuration.setValue(element.configKey, value);
				end);
				box:SetText(tostring(Configuration.getValue(element.configKey)));
			end
			box:SetNumeric(element.numeric);
			box:SetMaxLetters(element.maxLetters or 0);
			local boxTitle = _G[widget:GetName().."BoxText"];
			if boxTitle then
				boxTitle:SetText(element.boxTitle);
			end
		end

		-- Specific for Check
		if _G[widget:GetName().."Check"] then
			local box = _G[widget:GetName().."Check"];
			element.controller = box;
			if element.configKey then
				box:SetScript("OnClick", function(self)
					local optionIsEnabled = self:GetChecked();
					Configuration.setValue(element.configKey, optionIsEnabled);
					
					if optionsDependentOnOtherOptions[element.configKey] then
						for _, dependentOption in pairs(optionsDependentOnOtherOptions[element.configKey]) do
							
							dependentOption.widget:SetAlpha(optionIsEnabled and 1 or 0.5);
						
							if dependentOption.controller then
								if optionIsEnabled then
									dependentOption.controller:Enable();
								else
									dependentOption.controller:Disable();
								end
							end
						end
					end
				end);
				box:SetChecked(Configuration.getValue(element.configKey));
			end
		end

		-- Specific for Sliders
		if _G[widget:GetName().."Slider"] then
			local slider = _G[widget:GetName().."Slider"];
			local text = _G[widget:GetName().."SliderValText"];
			local min = element.min or 0;
			local max = element.max or 100;

			slider:SetMinMaxValues(min, max);
			_G[widget:GetName().."SliderLow"]:SetText(min);
			_G[widget:GetName().."SliderHigh"]:SetText(max);
			slider:SetValueStep(element.step);
			slider:SetObeyStepOnDrag(element.integer);

			local onChange = function(self, value)
				if element.integer then
					value = math.floor(value);
				end
				text:SetText(value);
				if element.configKey then
					Configuration.setValue(element.configKey, value);
				end
			end
			slider:SetScript("OnValueChanged", onChange);

			if element.configKey then
				slider:SetValue(tonumber(Configuration.getValue(element.configKey)) or min);
			else
				slider:SetValue(0);
			end

			onChange(slider, slider:GetValue());
		end
		
		if element.dependentOnOptions then
			for _, dependence in pairs(element.dependentOnOptions) do
				if not optionsDependency[dependence] then
					optionsDependency[dependence] = {};
				end
				tinsert(optionsDependency[dependence], element);
			end
		end

		lastWidget = widget;
		GENERATED_WIDGET_INDEX = GENERATED_WIDGET_INDEX + 1;
	end
	
	-- Now that we have built all our widget we can go through the dependencies table
	-- and disable the elements that need to be disabled if the option they are dependent on
	-- is disabled.
	for dependence, dependentElements in pairs(optionsDependency) do
		
		-- Go through each element of the dependence
		for _, element in pairs(dependentElements) do
			
			-- If the option is disabled we render the dependent element as being disabled
			if not Configuration.getValue(dependence) then
				element.widget:SetAlpha(0.5);
				
				if element.controller then
					element.controller:Disable();
				end
			end
			
			-- Insert the dependent element in our optionsDependentOnOtherOptions table
			-- used for cross option page dependencies (like the location feature needing the broadcast protocol)
			if not optionsDependentOnOtherOptions[dependence] then
				optionsDependentOnOtherOptions[dependence] = {};
			end
			tinsert(optionsDependentOnOtherOptions[dependence], element)
		end
	end
end

local configurationPageCount = 0;
local registeredConfiPage = {};

---@param pageStructure table @ A configuration page structure
--- TODO Document this better
function Configuration.registerConfigurationPage(pageStructure)
	assert(not registeredConfiPage[pageStructure.id], "Already registered page id: " .. pageStructure.id);
	registeredConfiPage[pageStructure.id] = pageStructure;

	configurationPageCount = configurationPageCount + 1;
	pageStructure.frame = CreateFrame("Frame", "TRP3_ConfigurationPage" .. configurationPageCount, TRP3_MainFramePageContainer, "TRP3_ConfigurationPage");
	pageStructure.frame:Hide();
	pageStructure.parent = _G["TRP3_ConfigurationPage" .. configurationPageCount .. "InnerScrollContainer"];
	_G["TRP3_ConfigurationPage" .. configurationPageCount .. "Title"]:SetText(pageStructure.pageText);

	registerPage({
		id = pageStructure.id,
		frame = pageStructure.frame,
	});

	registerMenu({
		id = "main_91_config_" .. pageStructure.id,
		text = pageStructure.menuText,
		isChildOf = "main_90_config",
		onSelected = function() setPage(pageStructure.id); end,
	});

	buildConfigurationPage(pageStructure);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- GENERAL SETTINGS
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local function changeLocale(newLocale)
	if newLocale ~= Locale.getCurrentLocale() then
		Configuration.setValue(Configuration.KEYS.ADDON_LOCALE, newLocale);

		local localeText = Locale.getLocaleText(newLocale);
		localeText = Colors.COLORS.GREEN:WrapTextInColorCode(localeText);

		TRP3_API.popup.showConfirmPopup(loc(loc.CO_GENERAL_CHANGELOCALE_ALERT, localeText), function()
			ReloadUI();
		end);
	end
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- INIT
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

Events.listenToEvent(Events.EVENTS.WORKFLOW_ON_LOAD, function()

	-- Resizing
	Events.listenToEvent(Events.EVENTS.NAVIGATION_RESIZED, function(containerWidth, containerHeight)
		for _, structure in pairs(registeredConfiPage) do
			structure.parent:SetSize(containerWidth - 70, 50);
		end
	end);

	-- Page and menu
	registerMenu({
		id = "main_90_config",
		text = loc.CO_CONFIGURATION,
		onSelected = function() selectMenu("main_91_config_main_config_aaa_general") end,
	});

	Configuration.CONFIG_FRAME_PAGE = {
		id = "main_config_toolbar",
		menuText = loc.CO_TOOLBAR,
		pageText = loc.CO_TOOLBAR,
		elements = {},
	};
	
	-- GENERAL SETTINGS INIT
	-- localization
	local localeTab = {};
	for _, locale in pairs(Locale.getLocales()) do
		tinsert(localeTab, { Locale.getLocaleText(locale), locale });
	end

	Configuration.registerConfigKey(Configuration.KEYS.HEAVY_PROFILE_ALERT, true);
	Configuration.registerConfigKey(Configuration.KEYS.NEW_VERSION_ALERT, true);
	Configuration.registerConfigKey(Configuration.KEYS.UI_SOUNDS, true);
	Configuration.registerConfigKey(Configuration.KEYS.UI_ANIMATIONS, true);
	Configuration.registerConfigKey(Configuration.KEYS.USE_BROADCAST_CHANNEL, true);
	Configuration.registerConfigKey(Configuration.KEYS.BROADCAST_CHANNEL_NAME, "xtensionxtooltip2");

	-- Build widgets
	Configuration.CONFIG_STRUCTURE_GENERAL = {
		id = "main_config_aaa_general",
		menuText = loc.CO_GENERAL,
		pageText = loc.CO_GENERAL,
		elements = {
			{
				inherit = "TRP3_ConfigH1",
				title = loc.CO_GENERAL_LOCALE,
			},
			{
				inherit = "TRP3_ConfigDropDown",
				widgetName = "TRP3_ConfigurationGeneral_LangWidget",
				title = loc.CO_GENERAL_LOCALE,
				listContent = localeTab,
				listCallback = changeLocale,
				listDefault = Locale.getLocaleText(Locale.getCurrentLocale()),
				listCancel = true,
			},
			{
				inherit = "TRP3_ConfigH1",
				title = loc.CO_GENERAL_COM,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_GENERAL_BROADCAST,
				configKey = Configuration.KEYS.USE_BROADCAST_CHANNEL,
				help = loc.CO_GENERAL_BROADCAST_TT,
			},
			{
				inherit = "TRP3_ConfigEditBox",
				title = loc.CO_GENERAL_BROADCAST_C,
				configKey = Configuration.KEYS.BROADCAST_CHANNEL_NAME,
				dependentOnOptions = { Configuration.KEYS.USE_BROADCAST_CHANNEL },
			},
			{
				inherit = "TRP3_ConfigH1",
				title = loc.CO_GENERAL_MISC,
			},
			{
				inherit = "TRP3_ConfigSlider",
				title = loc.CO_GENERAL_TT_SIZE,
				configKey = TRP3_API.ui.tooltip.CONFIG_TOOLTIP_SIZE,
				min = 6,
				max = 25,
				step = 1,
				integer = true,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_GENERAL_HEAVY,
				configKey = Configuration.KEYS.HEAVY_PROFILE_ALERT,
				help = loc.CO_GENERAL_HEAVY_TT,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_GENERAL_NEW_VERSION,
				configKey = Configuration.KEYS.NEW_VERSION_ALERT,
				help = loc.CO_GENERAL_NEW_VERSION_TT,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_GENERAL_UI_SOUNDS,
				configKey = Configuration.KEYS.UI_SOUNDS,
				help = loc.CO_GENERAL_UI_SOUNDS_TT,
			},
			{
				inherit = "TRP3_ConfigCheck",
				title = loc.CO_GENERAL_UI_ANIMATIONS,
				configKey = Configuration.KEYS.UI_ANIMATIONS,
				help = loc.CO_GENERAL_UI_ANIMATIONS_TT,
			},
		}
	}
end);

function Configuration.constructConfigPage()
	Configuration.registerConfigurationPage(Configuration.CONFIG_FRAME_PAGE);
	Configuration.registerConfigurationPage(Configuration.CONFIG_STRUCTURE_GENERAL);
end


TRP3_API.configuration.getConfigValue = TRP3_API.Deprecated.setUpDeprecatedFunctionWarning(Configuration.getValue, "TRP3_API.configuration.getConfigValue", "TRP3_API.Configuration.getValue");