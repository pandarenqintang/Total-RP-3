----------------------------------------------------------------------------------
--- Total RP 3
---
--- Frames tools
---
--- Methods and routines to check and assert variables, used through the add-on.
--- The methods will generate proper error messages using the arguments provided.
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

local Frames = {};
TRP3_API.Frames = Frames;

-- WoW imports
local assert = assert;
local ceil = math.ceil;
local pairs = pairs;
local after = C_Timer.After;
local IsShiftKeyDown = IsShiftKeyDown;
local MouseIsOver = MouseIsOver;

-- Total RP 3 imports
local loc = TRP3_API.loc;
local isType = TRP3_API.Assertions.isType;
local Colors = TRP3_API.Colors;
local Animations = TRP3_API.Animations;
local Textures = TRP3_API.Textures;

---@type Frame
local resizeShadowFrame = TRP3_ResizeShadowFrame;

---Makes a frame movable
---@param frame Frame @ A frame that we want to make movable
function Frames.makeMovable(frame)
	frame:RegisterForDrag("LeftButton");
	frame:SetScript("OnDragStart", function(self)
		self:StartMoving();
	end);
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing();
	end)
end

---Makes a frame resizeable
---@param resizeButton Button @ The resize button in the frame. Must have a minWidth and minHeight properties
function Frames.makeResizable(resizeButton)
	assert(isType(resizeButton.minWidth, "number", "resizeButton.minWidth"));
	assert(isType(resizeButton.minHeight, "number", "resizeButton.minHeight"));

	-- If the resizable frame hasn't been indicated inside the button, we use the parent by default
	if not resizeButton.resizableFrame then
		resizeButton.resizableFrame = resizeButton:GetParent();
	end

	TRP3_API.ui.tooltip.setTooltipAll(resizeButton, "BOTTOMLEFT", 0, 0, loc.CM_RESIZE, loc.CM_RESIZE_TT);

	---@type Frame
	local parentFrame = resizeButton.resizableFrame;
	resizeButton:RegisterForDrag("LeftButton");
	resizeButton:SetScript("OnDragStart", function(self)
		if not self.onResizeStart or not self.onResizeStart() then
			resizeShadowFrame.minWidth = self.minWidth;
			resizeShadowFrame.minHeight = self.minHeight;
			resizeShadowFrame:ClearAllPoints();
			resizeShadowFrame:SetPoint("CENTER", self.resizableFrame, "CENTER", 0, 0);
			resizeShadowFrame:SetWidth(parentFrame:GetWidth());
			resizeShadowFrame:SetHeight(parentFrame:GetHeight());
			resizeShadowFrame:Show();
			resizeShadowFrame:StartSizing();
			parentFrame.isSizing = true;
		end
	end);
	resizeButton:SetScript("OnDragStop", function(self)
		if parentFrame.isSizing then
			resizeShadowFrame:StopMovingOrSizing();
			parentFrame.isSizing = false;
			local height, width = resizeShadowFrame:GetHeight(), resizeShadowFrame:GetWidth()
			resizeShadowFrame:Hide();
			if height < self.minHeight then
				height = self.minHeight;
			end
			if width < self.minWidth then
				width = self.minWidth;
			end
			parentFrame:SetSize(width, height);
			if self.onResizeStop then
				after(0.1, function()
					self.onResizeStop(width, height);
				end);
			end
		end
	end);
end

local VALID_RESIZING_COLOR = Colors.COLORS.GREEN:Clone();
local INVALID_RESIZING_COLOR = Colors.COLORS.RED:Clone();

resizeShadowFrame:SetScript("OnUpdate", function(self)
	local height, width = self:GetHeight(), self:GetWidth();

	if height < self.minHeight then
		height = INVALID_RESIZING_COLOR:WrapTextInColorCode(ceil(height));
	else
		height = VALID_RESIZING_COLOR:WrapTextInColorCode(ceil(height))
	end

	if width < self.minWidth then
		width = INVALID_RESIZING_COLOR:WrapTextInColorCode(ceil(width));
	else
		width = VALID_RESIZING_COLOR:WrapTextInColorCode(ceil(width))
	end

	resizeShadowFrame.text:SetText(width .. " x " .. height);
end);

---configureHoverFrame
---@param frame Frame @ The hover frame we want to setup
---@param hoveredFrame Frame @ The frame that is being hovered by the hover frame
---@param arrowPosition string @ The position of the hover frame (RIGHT, LEFT, TOP, BOTTOM or CENTER) (defaults to CENTER)
---@param x number @ An horizontal offset to apply to the hover frame
---@param y number @ A vertical offset to apply to the hover frame
---@param optional noStrataChange boolean @ Indicates if we should change the strata of the hover frame explicitly (fixes some issues with layered frames)
---@param optional parent Frame @ The parent frame of the hover frame. If none is indicated, the hover frame's actual parent will be used
function Frames.configureHoverFrame(frame, hoveredFrame, arrowPosition, x, y, noStrataChange, parent)
	x = x or 0;
	y = y or 0;

	frame:ClearAllPoints();

	if not noStrataChange then
		frame:SetParent(parent or hoveredFrame:GetParent());
		frame:SetFrameStrata("HIGH");
	else
		frame:SetParent(parent or hoveredFrame);
		frame:Raise();
	end

	frame.ArrowRIGHT:Hide();
	frame.ArrowUP:Hide();
	frame.ArrowDOWN:Hide();
	frame.ArrowLEFT:Hide();

	local animation;

	if arrowPosition == "RIGHT" then
		frame:SetPoint("RIGHT", hoveredFrame, "LEFT", -10 + x, 0 + y);
		frame.ArrowLEFT:Show();
		animation = "showAnimationFromRight";
	elseif arrowPosition == "LEFT" then
		frame:SetPoint("LEFT", hoveredFrame, "RIGHT", 10 + x, 0 + y);
		frame.ArrowRIGHT:Show();
		animation = "showAnimationFromLeft";
	elseif arrowPosition == "TOP" then
		frame:SetPoint("TOP", hoveredFrame, "BOTTOM", 0 + x, -20 + y);
		frame.ArrowDOWN:Show();
		animation = "showAnimationFromTop";
	elseif arrowPosition == "BOTTOM" then
		frame:SetPoint("BOTTOM", hoveredFrame, "TOP", 0 + x, 20 + y);
		frame.ArrowUP:Show();
		animation = "showAnimationFromBottom";
	else
		frame:SetPoint("CENTER", hoveredFrame, "CENTER", 0 + x, 0 + y);
	end

	frame:Show();
	if frame[animation] then
		Animations.playAnimation(frame[animation]);
	end
end

---Set up tab key navigation inside a group of EditBoxes
---@param tabEditBoxes EditBox[] @ A list of EditBox widget to cycle through. The order of the table will set the order of the navigation
function Frames.setupEditBoxesNavigation(tabEditBoxes)
	local maxBound = #tabEditBoxes;
	local minBound = 1;

	for index, editBox in pairs(tabEditBoxes) do
		editBox:SetScript("OnTabPressed", function(self, button)
			local cursor = index;
			if IsShiftKeyDown() then
				if cursor == minBound then
					cursor = maxBound;
				else
					cursor = cursor - 1;
				end
			else
				if cursor == maxBound then
					cursor = minBound;
				else
					cursor = cursor + 1;
				end
			end
			tabEditBoxes[cursor]:SetFocus();
		end)
	end
end

---Set the icon of a button by looking for either an icon key in the button frame or a named child frame (`button.Icon` or `_G[button:GetName() .. "Icon"]`).
---@param button Button @ A button with either a icon as a key or as a named child
---@param icon string @ An icon texture
function Frames.setupIconButton(button, icon)
	assert(isType(button, "Button", "button"));
	local iconFrame = button.Icon or (button:GetName() and _G[button:GetName() .. "Icon"]);
	assert(isType(iconFrame, "Texture", "button.Icon"));
	iconFrame:SetTexture(Textures.iconPath(icon));
end

---Show a frame if the cursor is over another frame
---@param frame Frame @ The frame that will be shown
---@param frameOver Frame @ The frame to check if the cursor is over
function Frames.showIfMouseOverFrame(frame, frameOver)
	assert(isType(frame, "Frame", "frame"))
	assert(isType(frameOver, "Frame", "frame"));

	if MouseIsOver(frameOver) then
		frame:Show();
	else
		frame:Hide();
	end
end