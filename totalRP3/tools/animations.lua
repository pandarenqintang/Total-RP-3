----------------------------------------------------------------------------------
--- Total RP 3
---
--- UI Animations tools
---
--- Methods and routines to check and assert variables, used through the add-on.
--- The methods will generate proper error messages using the arguments provided.
---
--- ------------------------------------------------------------------------------
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

local Animations = {};
TRP3_API.Animations = Animations;


---Play a UI animation if the settings to show UI animations is enabled.
---@param animationGroup AnimationGroup @ The animation group that should be played
---@param optional callback func @ A callback to called once the animation is finished
function Animations.playAnimation(animationGroup, callback)
	if animationGroup and TRP3_API.Configuration.getValue(TRP3_API.Configuration.KEYS.UI_ANIMATIONS) then
		animationGroup:Stop();
		animationGroup:Play();
		if callback then
			animationGroup:SetScript("OnFinished", callback)
		end
	elseif callback then
		callback();
	end
end