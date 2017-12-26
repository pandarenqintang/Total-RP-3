----------------------------------------------------------------------------------
--- Total RP 3
---
---    COMPRESSION / Serialization / HASH
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

local Serial = {};
TRP3_API.Serial = Serial;

-- WoW imports
local assert = assert;
local tostring = tostring;

-- Total RP 3 imports
local warning = TRP3_API.Logs.warning;

local libCompress = LibStub:GetLibrary("LibCompress");
local libCompressEncoder = libCompress:GetAddonEncodeTable();
local libSerializer = LibStub:GetLibrary("AceSerializer-3.0");

Serial.errorCount = 0;

function Serial.serialize(structure)
	return libSerializer:Serialize(structure);
end

function Serial.deserialize(structure)
	local status, data = libSerializer:Deserialize(structure);
	assert(status, "Deserialization error:\n" .. tostring(structure) .. "\n" .. tostring(data));
	return data;
end

function Serial.safeDeserialize(structure, default)
	local status, data = libSerializer:Deserialize(structure);
	if not status then
		warning("Deserialization error:\n" .. tostring(structure) .. "\n" .. tostring(data));
		return default;
	end
	return data;
end


function Serial.encodeCompressMessage(message)
	return libCompressEncoder:Encode(libCompress:Compress(message));
end

function Serial.decompressCodedMessage(message)
	return libCompress:Decompress(libCompressEncoder:Decode(message));
end

function Serial.safeEncodeCompressMessage(serial)
	local encoded = Serial.encodeCompressMessage(serial);
	-- Rollback test
	local decoded = Serial.decompressCodedMessage(encoded);
	if decoded == serial then
		return encoded;
	else
		warning("safeEncodeCompressStructure error:\n" .. tostring(serial));
		return nil;
	end
end

function Serial.decompressCodedStructure(message)
	return Serial.deserialize(libCompress:Decompress(libCompressEncoder:Decode(message)));
end

function Serial.safeDecompressCodedStructure(message)
	return Serial.safeDeserialize(libCompress:Decompress(libCompressEncoder:Decode(message)));
end

function Serial.encodeCompressStructure(structure)
	return Serial.encodeCompressMessage(Serial.serialize(structure));
end

function Serial.hashCode(str)
	return libCompress:fcs32final(libCompress:fcs32update(libCompress:fcs32init(), str));
end