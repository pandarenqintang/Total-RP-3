----------------------------------------------------------------------------------
--- Total RP 3
--- Map marker and coordinates system
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

TRP3_API.map = {};

local MapMarkers = {};
TRP3_API.MapMarkers = MapMarkers;
TRP3_API.map = {};
TRP3_API.map.getCurrentCoordinates = TRP3_API.Deprecated.setUpDeprecatedFunctionWarning(TRP3_API.Map.getCurrentCoordinates, "TRP3_API.map.getCurrentCoordinates", "TRP3_API.Map.getCurrentCoordinates");

-- WoW imports
local tinsert, assert, tonumber, pairs, _G, wipe = tinsert, assert, tonumber, pairs, _G, wipe;
local CreateFrame = CreateFrame;
local after = C_Timer.After;

-- Total RP 3 imports
local Textures = TRP3_API.Textures;
local GameEvents = TRP3_API.GameEvents;
local Events = TRP3_API.Events;
local Configuration = TRP3_API.Configuration;
local loc = TRP3_API.loc;

local Comm = TRP3_API.communication;
local setupIconButton = TRP3_API.ui.frame.setupIconButton;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local playAnimation = TRP3_API.ui.misc.playAnimation;

---@type Frame
local TRP3_ScanLoaderFrame = TRP3_ScanLoaderFrame;

Configuration.KEYS.MAP_BUTTON_POSITION = "MAP_BUTTON_POSITION";

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Marker logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
---@type GameTooltip
local WorldMapTooltip = WorldMapTooltip
local WorldMapPOIFrame = WorldMapPOIFrame;
local MARKER_NAME_PREFIX = "TRP3_WordMapMarker";

local MAX_DISTANCE_MARKER = math.sqrt(0.5 * 0.5 + 0.5 * 0.5);

local function hideAllMarkers()
	local i = 1;
	while(_G[MARKER_NAME_PREFIX .. i]) do
		local marker = _G[MARKER_NAME_PREFIX .. i];
		marker:Hide();
		marker.scanLine = nil;
		i = i + 1;
	end
end

local function getMarker(i, tooltip)
	---@type Frame
	local marker = _G[MARKER_NAME_PREFIX .. i];

	if not marker then
		marker = CreateFrame("Frame", MARKER_NAME_PREFIX .. i, WorldMapButton, "TRP3_WorldMapUnit");
		marker:SetScript("OnEnter", function(self)
			WorldMapPOIFrame.allowBlobTooltip = false;

			WorldMapTooltip:Hide();
			WorldMapTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0);
			WorldMapTooltip:AddLine(self.tooltip, 1, 1, 1, true);

			local j = 1;
			while(_G[MARKER_NAME_PREFIX .. j]) do
				local markerWidget = _G[MARKER_NAME_PREFIX .. j];
				if markerWidget:IsVisible() and markerWidget:IsMouseOver() then
					local scanLine = markerWidget.scanLine;
					if scanLine then
						WorldMapTooltip:AddLine(scanLine, 1, 1, 1, true);
					end
				end
				j = j + 1;
			end
			WorldMapTooltip:Show();
		end);
		marker:SetScript("OnLeave", function()
			WorldMapPOIFrame.allowBlobTooltip = true;
			WorldMapTooltip:Hide();
		end);
	end
	marker.tooltip = "|cffff9900" .. (tooltip or "");
	return marker;
end

---@param marker Frame
---@param x nubmer
---@param y number
local function placeMarker(marker, x, y)
	x = (x or 0) * WorldMapDetailFrame:GetWidth();
	y = - (y or 0) * WorldMapDetailFrame:GetHeight();
	marker:ClearAllPoints();
	marker:SetPoint("CENTER", "WorldMapDetailFrame", "TOPLEFT", x, y);
end

local function animateMarker(marker, x, y, directAnimation)
	if Configuration.getValue(Configuration.KEYS.UI_ANIMATIONS) then

		local distanceX = 0.5 - x;
		local distanceY = 0.5 - y;
		local distance = math.sqrt(distanceX * distanceX + distanceY * distanceY);
		local factor = distance/MAX_DISTANCE_MARKER;

		if not directAnimation then
			after(4 * factor, function()
				marker:Show();
				marker:SetAlpha(0);
				playAnimation(marker.Bounce);
			end);
		else
			marker:Show();
			marker:SetAlpha(0);
			playAnimation(marker.Bounce);
		end
	else
		marker:Show();
	end
end

local DECORATION_TYPES = {
	HOUSE = "house",
	CHARACTER = "character"
}
TRP3_API.map.DECORATION_TYPES = DECORATION_TYPES;

local function decorateMarker(marker, decorationType)
	if not decorationType or decorationType == DECORATION_TYPES.CHARACTER then
		marker.Icon:SetTexture("Interface\\Minimap\\OBJECTICONS");
		marker.Icon:SetTexCoord(0, 0.125, 0, 0.125);
	elseif decorationType == DECORATION_TYPES.HOUSE then
		marker.Icon:SetTexture("Interface\\Minimap\\POIICONS");
		marker.Icon:SetTexCoord(0.357143, 0.422, 0, 0.036);
	end
end

---@param structure table
local function displayMarkers(structure)
	if not WorldMapFrame:IsVisible() then
		return;
	end

	local i = 1;
	for key, entry in pairs(structure.saveStructure) do
		local marker = getMarker(i, structure.scanTitle);
		placeMarker(marker, entry.x, entry.y);

		decorateMarker(marker, DECORATION_TYPES.CHARACTER);

		-- Implementation can be adapted by decorator
		if structure.scanMarkerDecorator then
			structure.scanMarkerDecorator(key, entry, marker);
		end

		animateMarker(marker, entry.x, entry.y, structure.noAnim);

		i = i + 1;
	end
end

function TRP3_API.map.placeSingleMarker(x, y, tooltip, decorationType)
	hideAllMarkers();
	local marker = getMarker(1, tooltip);
	placeMarker(marker, x, y);
	animateMarker(marker, x, y, true);
	decorateMarker(marker, decorationType);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Scan logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local SCAN_STRUCTURES = {};
local currentMapID;
local launchScan;

local function registerScan(structure)
	assert(structure and structure.id, "Must have a structure and a structure.id!");
	SCAN_STRUCTURES[structure.id] = structure;
	if structure.scanResponder and structure.scanCommand then
		Comm.broadcast.registerCommand(structure.scanCommand, structure.scanResponder);
	end
	if not structure.saveStructure then
		structure.saveStructure = {};
	end
	if structure.scanAssembler and structure.scanCommand then
		Comm.broadcast.registerP2PCommand(structure.scanCommand, function(...)
			structure.scanAssembler(structure.saveStructure, ...);
		end)
	end
end
TRP3_API.map.registerScan = registerScan;

function launchScan(scanID)
	assert(SCAN_STRUCTURES[scanID], ("Unknown scan id %s"):format(scanID));
	local structure = SCAN_STRUCTURES[scanID];
	if structure.scan then
		hideAllMarkers();
		wipe(structure.saveStructure);
		structure.scan(structure.saveStructure);
		if structure.scanDuration then
			local mapID = GetCurrentMapAreaID();
			currentMapID = mapID;
			TRP3_WorldMapButton:Disable();
			setupIconButton(TRP3_WorldMapButton, "ability_mage_timewarp");
			TRP3_WorldMapButton.Cooldown:SetCooldown(GetTime(), structure.scanDuration)
			TRP3_ScanLoaderFrame.time = structure.scanDuration;
			TRP3_ScanLoaderFrame:Show();
			TRP3_ScanLoaderAnimationRotation:SetDuration(structure.scanDuration);
			TRP3_ScanLoaderGlowRotation:SetDuration(structure.scanDuration);
			TRP3_ScanLoaderBackAnimation1Rotation:SetDuration(structure.scanDuration);
			TRP3_ScanLoaderBackAnimation2Rotation:SetDuration(structure.scanDuration);
			playAnimation(TRP3_ScanLoaderAnimation);
			playAnimation(TRP3_ScanFadeIn);
			playAnimation(TRP3_ScanLoaderGlow);
			playAnimation(TRP3_ScanLoaderBackAnimation1);
			playAnimation(TRP3_ScanLoaderBackAnimation2);
			TRP3_API.ui.misc.playSoundKit(40216);
			after(structure.scanDuration, function()
				TRP3_WorldMapButton:Enable();
				setupIconButton(TRP3_WorldMapButton, "icon_treasuremap");
				if mapID == GetCurrentMapAreaID() then
					if structure.scanComplete then
						structure.scanComplete(structure.saveStructure);
					end
					displayMarkers(structure);
					TRP3_API.ui.misc.playSoundKit(43493);
				end
				playAnimation(TRP3_ScanLoaderBackAnimationGrow1);
				playAnimation(TRP3_ScanLoaderBackAnimationGrow2);
				playAnimation(TRP3_ScanFadeOut);
				if Configuration.getValue(Configuration.KEYS.UI_ANIMATIONS) then
					after(1, function()
						TRP3_ScanLoaderFrame:Hide();
						TRP3_ScanLoaderFrame:SetAlpha(1);
					end);
				else
					TRP3_ScanLoaderFrame:Hide();
				end
			end);
		else
			if structure.scanComplete then
				structure.scanComplete(structure.saveStructure);
			end
			displayMarkers(structure);
			TRP3_API.ui.misc.playSoundKit(43493);
		end
	end
end
TRP3_API.map.launchScan = launchScan;

local DEFAULT_SCAN_ICON = "Inv_misc_enggizmos_20";
local function onButtonClicked(self)
	local structure = {};
	for scanID, scanStructure in pairs(SCAN_STRUCTURES) do
		if not scanStructure.canScan or scanStructure.canScan() == true then
			tinsert(structure, { Textures.iconTag(scanStructure.buttonIcon or DEFAULT_SCAN_ICON, 20) .. " " .. (scanStructure.buttonText or scanID), scanID});
		end
	end
	if #structure == 0 then
		tinsert(structure, {loc("MAP_BUTTON_NO_SCAN"), nil});
	end
	displayDropDown(self, structure, launchScan, 0, true);
end

local function onWorldMapUpdate()
	local mapID = GetCurrentMapAreaID();
	if currentMapID ~= mapID then
		currentMapID = mapID;
		hideAllMarkers();
	end
end

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()
	setupIconButton(TRP3_WorldMapButton, "icon_treasuremap");
	TRP3_WorldMapButton.title = loc("MAP_BUTTON_TITLE");
	TRP3_WorldMapButton.subtitle = "|cffff9900" .. loc("MAP_BUTTON_SUBTITLE");
	TRP3_WorldMapButton:SetScript("OnClick", onButtonClicked);
	TRP3_ScanLoaderFrameScanning:SetText(loc("MAP_BUTTON_SCANNING"));

	TRP3_ScanLoaderFrame:SetScript("OnShow", function(self)
		self.refreshTimer = 0;
	end);
	TRP3_ScanLoaderFrame:SetScript("OnUpdate", function(self, elapsed)
		self.refreshTimer = self.refreshTimer + elapsed;
	end);

	GameEvents.registerHandler("WORLD_MAP_UPDATE", onWorldMapUpdate)
end);


---@param position string
local function placeMapButton(position)
	position = position or "BOTTOMLEFT";

	---@type Frame
	local worldMapButton = TRP3_WorldMapButton;

	worldMapButton:SetParent(WorldMapFrame.UIElementsFrame);
	TRP3_ScanLoaderFrame:SetParent(WorldMapFrame.UIElementsFrame)
	worldMapButton:ClearAllPoints();

	local xPadding = 10;
	local yPadding = 10;

	if position == "TOPRIGHT" then
		xPadding = -10;
		yPadding = -45;
	elseif position == "TOPLEFT" then
		yPadding = -30;
	elseif position == "BOTTOMRIGHT" then
		xPadding = -10;
		yPadding = 40;
	end

	worldMapButton:SetPoint(position, WorldMapFrame.UIElementsFrame, position, xPadding, yPadding);

	Configuration.setValue(Configuration.KEYS.MAP_BUTTON_POSITION, position);
end

Events.listenToEvent(Events.EVENTS.WORKFLOW_ON_LOADED, function()

	Configuration.registerConfigKey(Configuration.KEYS.MAP_BUTTON_POSITION, "BOTTOMLEFT");

	tinsert(Configuration.CONFIG_FRAME_PAGE.elements, {
		inherit = "TRP3_ConfigH1",
		title = loc.CO_MAP_BUTTON,
	});

	tinsert(Configuration.CONFIG_FRAME_PAGE.elements, {
		inherit = "TRP3_ConfigDropDown",
		widgetName = "TRP3_ConfigurationFrame_MapButtonWidget",
		title = loc.CO_MAP_BUTTON_POS,
		listContent = {
			{loc.CO_ANCHOR_BOTTOM_LEFT, "BOTTOMLEFT"},
			{loc.CO_ANCHOR_TOP_LEFT, "TOPLEFT"},
			{loc.CO_ANCHOR_BOTTOM_RIGHT, "BOTTOMRIGHT"},
			{loc.CO_ANCHOR_TOP_RIGHT, "TOPRIGHT"}
		},
		listCallback = placeMapButton,
		listCancel = true,
		configKey = Configuration.KEYS.MAP_BUTTON_POSITION,
	});

	placeMapButton(Configuration.getValue(Configuration.KEYS.MAP_BUTTON_POSITION));

end);