----------------------------------------------------------------------------------
--- Total RP 3
---
---    Math tools
---
---    ---------------------------------------------------------------------------
---    Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
---    Copyright 2017 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
---    Licensed under the Apache License, Version 2.0 (the "License");
---    you may not use this file except in compliance with the License.
---    You may obtain a copy of the License at
---
---        http://www.apache.org/licenses/LICENSE-2.0
---
---    Unless required by applicable law or agreed to in writing, software
---    distributed under the License is distributed on an "AS IS" BASIS,
---    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
---    See the License for the specific language governing permissions and
---    limitations under the License.
----------------------------------------------------------------------------------


---@type TRP3_API
local _, TRP3_API = ...;

local Math = {};
TRP3_API.Math = Math;

-- WoW imports
local pow = math.pow;
local floor = math.floor;

-- Total RP 3 imports
local Colors = TRP3_API.Colors;

function Math.incrementNumber(version, figures)
	local incremented = version + 1;
	if incremented >= pow(10, figures) then
		incremented = 1;
	end
	return incremented;
end

--- Return the interpolation.
--- @param delta number @ between 0 and 1;
function Math.lerp(delta, from, to)
	local diff = to - from;
	return from + (delta * diff);
end

function Math.color(delta, fromR, fromG, fromB, toR, toG, toB)
	return Math.lerp(delta, fromR, toR), Math.lerp(delta, fromG, toG), Math.lerp(delta, fromB, toB);
end

--- Values must be 256 based
function Math.colorCode(delta, fromR, fromG, fromB, toR, toG, toB)
	return Colors.colorCode(Math.lerp(delta, fromR, toR), Math.lerp(delta, fromG, toG), Math.lerp(delta, fromB, toB));
end

function Math.round(value, decimals)
	local mult = 10 ^ (decimals or 0)
	return floor(value * mult) / mult;
end