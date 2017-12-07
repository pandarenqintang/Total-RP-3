----------------------------------------------------------------------------------
--- Total RP 3
---
--- Assertions tools
---
--- Methods and routines to check and assert variables, used through the add-on.
--- The methods will generate proper error messages using the arguments provided.
---
---	------------------------------------------------------------------------------
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

local Assertions = {};
TRP3_API.Assertions = Assertions;

-- WoW imports
local type = type;
local format = string.format;
local next = next;
local pairs = pairs;

-- Error messages
local DEBUG_NIL_PARAMETER = [[Unexpected nil parameter "%s".]];
local DEBUG_WRONG_PARAM_TYPE = [[Invalid parameter type "%2$s" for parameter "%1$s", expected "%3$s".]];
local DEBUG_WRONG_PARAM_TYPES = [[Invalid parameter type "%2$s" for parameter "%1$s", expected one of (%3$s).]];
local DEBUG_EMPTY_PARAMETER = [[Parameter "%s" cannot be empty.]];

---Check if a variable is of the expected type
---@param variable any @ Any kind of variable, to be tested for its type
---@param expectedType string @ Expected type of the variable
---@param variableName string @ The name of the variable being tested, will be visible in the error message
---@return boolean, string isType, errorMessage @ Returns true if the variable was of the expected type, or false with an error message if it wasn't.
function Assertions.isType(variable, expectedType, variableName)
	local variableType = type(variable);
	local isOfExpectedType = variableType == expectedType;
	if not isOfExpectedType then
		return false, format(DEBUG_WRONG_PARAM_TYPE, variableName, variableType, expectedType);
	else
		return true;
	end
end

---Check if a variable is of one of the types expected
---@param variable any @ Any kind of variable, to be tested for its type
---@param expectedTypes string[] @ A list of expected types for the variable
---@param variableName string @ The name of the variable being tested, will be visible in the error message
---@return boolean, string isType, errorMessage @ Returns true if the variable was of the expected type, or false with an error message if it wasn't.
function Assertions.isOfTypes(variable, expectedTypes, variableName)
	local variableType = type(variable);
	local isOfExpectedType = false;

	for _, expectedType in pairs(expectedTypes) do
		if variableType == expectedType then
			isOfExpectedType = true;
			break;
		end
	end

	if not isOfExpectedType then
		local expectedTypesString = "";
		for _, expectedType in pairs(expectedTypes) do
			if expectedTypesString ~= "" then
				expectedTypesString = expectedTypesString .. "|";
			end
			expectedTypesString = expectedTypesString .. expectedType;
		end
		return false, format(DEBUG_WRONG_PARAM_TYPES, variableName, variableType, expectedTypesString);
	else
		return true;
	end
end

---Check if a variable is not nil
---@param variable any @ Any kind of variable, will be checked if it is nil
---@param variableName string @ The name of the variable being tested, will be visible in the error message
---@return boolean, string isNotNil, errorMessage @ Returns true if the variable was not nil, or false with an error message if it wasn't.
function Assertions.isNotNil(variable, variableName)
	local isVariableNil = variable == nil;
	if isVariableNil then
		return false, format(DEBUG_NIL_PARAMETER, variableName);
	else
		return true;
	end
end

---Check if a variable is empty
---@param variable any @ Any kind of variable that can be checked to be empty
---@param variableName string @ The name of the variable being tested, will be visible in the error message
---@return boolean, string isNotEmpty, errorMessage @ Returns true if the variable was not empty, or false with an error message if it was.
function Assertions.isNotEmpty(variable, variableName)
	local variableType = type(variable);
	local isEmpty = false;

	if variableType == "nil" then
		isEmpty = true;
	elseif variableType == "table" then
		-- To check if a table is empty we can just try to get its next field
		isEmpty = not next(variable);
	elseif variableType == "string" then
		-- A string is considered empty if it is equal to empty string ""
		isEmpty = variable == "";
	end

	if isEmpty then
		return false, format(DEBUG_EMPTY_PARAMETER, variableName);
	else
		return true;
	end
end