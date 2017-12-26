----------------------------------------------------------------------------------
--- Total RP 3
---
--- Tooltips tools
---
--- ------------------------------------------------------------------------------
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--- Copyright 2017 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
---     http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;

local Tooltips = {};
TRP3_API.Tooltips = Tooltips;

-- WoW imports
local assert = assert;

-- Total RP 3 imports
local isType = TRP3_API.Assertions.isType;
local Events = TRP3_API.Events;

---@type GameTooltip
local mainTooltip = TRP3_MainTooltip;
---@type FontString
mainTooltip.textRight = TRP3_MainTooltipTextRight1;
---@type FontString
mainTooltip.textLeft1 = TRP3_MainTooltipTextLeft1;
---@type FontString
mainTooltip.textLeft2 = TRP3_MainTooltipTextLeft2;

Events.listenToEvent(Events.EVENTS.WORKFLOW_ON_LOADED, function()

	TRP3_API.Configuration.KEYS.CONFIG_TOOLTIP_SIZE = "CONFIG_TOOLTIP_SIZE";
	TRP3_API.Configuration.registerConfigKey(TRP3_API.Configuration.KEYS.CONFIG_TOOLTIP_SIZE, 11);

end);

local function getTooltipSize()
	return TRP3_API.Configuration.getConfigValue(TRP3_API.Configuration.KEYS.CONFIG_TOOLTIP_SIZE) or 11;
end


--- Show the tooltip for this Frame (the frame must have been set up with setTooltipForFrame).
--- If already shown, the tooltip text will be refreshed.
function Tooltips.refreshTooltip(Frame)
	if Frame.titleText and Frame.GenFrame and Frame.GenFrameX and Frame.GenFrameY and Frame.GenFrameAnch then
		mainTooltip:Hide();
		mainTooltip:SetOwner(Frame.GenFrame, Frame.GenFrameAnch, Frame.GenFrameX, Frame.GenFrameY);

		if not Frame.rightText then
			mainTooltip:AddLine(Frame.titleText, 1, 1, 1, true);
		else
			mainTooltip:AddDoubleLine(Frame.titleText, Frame.rightText);
			local font, _, flag = mainTooltip.textRight1:GetFont();
			mainTooltip.textRight1:SetFont(font, getTooltipSize() + 4, flag);
			mainTooltip.textRight1:SetNonSpaceWrap(true);
			mainTooltip.textRight1:SetTextColor(1, 1, 1);
		end

		do
			local font, _, flag = mainTooltip.textLeft1:GetFont();
			mainTooltip.textLeft1:SetFont(font, getTooltipSize() + 4, flag);
			mainTooltip.textLeft1:SetNonSpaceWrap(true);
			mainTooltip.textLeft1:SetTextColor(1, 1, 1);
		end

		if Frame.bodyText then
			mainTooltip:AddLine(Frame.bodyText, 1, 0.6666, 0, true);
			local font, _, flag = mainTooltip.textLeft2:GetFont();
			mainTooltip.textLeft2:SetFont(font, getTooltipSize(), flag);
			mainTooltip.textLeft2:SetNonSpaceWrap(true);
			mainTooltip.textLeft2:SetTextColor(1, 0.75, 0);
		end

		mainTooltip:Show();
	end
end
TRP3_RefreshTooltipForFrame = Tooltips.refreshTooltip; -- For XML integration without too much perf' issue

local function tooltipSimpleOnEnter(self)
	Tooltips.refreshTooltip(self);
end

local function tooltipSimpleOnLeave(self)
	mainTooltip:Hide();
end

--- Setup the frame tooltip(position and text)
--- The tooltip can be shown by using refreshTooltip(Frame)
function Tooltips.setTooltipForFrame(Frame, GenFrame, GenFrameAnch, GenFrameX, GenFrameY, titleText, bodyText, rightText)
	assert(isType(Frame, "table", "Frame"))
	assert(isType(GenFrame, "table", "GenFrame"));

	if Frame and GenFrame then
		Frame.GenFrame = GenFrame;
		Frame.GenFrameX = GenFrameX;
		Frame.GenFrameY = GenFrameY;
		Frame.titleText = titleText;
		Frame.bodyText = bodyText;
		Frame.rightText = rightText;
		if GenFrameAnch then
			Frame.GenFrameAnch = "ANCHOR_" .. GenFrameAnch;
		else
			Frame.GenFrameAnch = "ANCHOR_TOPRIGHT";
		end
	end
end

--- Setup the frame tooltip (position and text)
--- The tooltip can be shown by using refreshTooltip(Frame)
function Tooltips.setTooltipForSameFrame(Frame, GenFrameAnch, GenFrameX, GenFrameY, titleText, bodyText, rightText)
	Tooltips.setTooltipForFrame(Frame, Frame, GenFrameAnch, GenFrameX, GenFrameY, titleText, bodyText, rightText);
end

--- Setup the frame tooltip and add the Enter and Leave scripts
function Tooltips.setTooltipAll(Frame, GenFrameAnch, GenFrameX, GenFrameY, titleText, bodyText, rightText)
	Frame:SetScript("OnEnter", tooltipSimpleOnEnter);
	Frame:SetScript("OnLeave", tooltipSimpleOnLeave);
	Tooltips.setTooltipForFrame(Frame, Frame, GenFrameAnch, GenFrameX, GenFrameY, titleText, bodyText, rightText);
end

-- Define a common behaviour for any frame or button that has a tooltip attached to it
-- Will be inherited in our XML declarations to automatically get this behavior
TRP3_MainTooltipMouseOverScriptMixin = {};

function TRP3_MainTooltipMouseOverScriptMixin:OnEnter()
	Tooltips.refreshTooltip(self);
end

function TRP3_MainTooltipMouseOverScriptMixin:OnLeave()
	mainTooltip:Hide();
end