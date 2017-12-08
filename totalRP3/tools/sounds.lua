----------------------------------------------------------------------------------
--- Total RP 3
---
--- Sounds system
---
--- This part of the add-on is in charge of managing sounds, like playing music,
--- playing UI sound if the option is enabled, and more
---
---	------------------------------------------------------------------------------
--- Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
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

local Sounds = {};
TRP3_API.Sounds = Sounds;

-- WoW imports
local wipe = wipe;
local assert = assert;
local date = date;
local tinsert = table.insert;
local pairs = pairs;
local type = type;
local PlaySound = PlaySound;
local StopSound = StopSound;
local StopMusic = StopMusic;
local PlayMusic = PlayMusic;

-- Total RP 3 imports
local Logs = TRP3_API.Logs;
local Strings = TRP3_API.Strings;
local isType = TRP3_API.Assertions.isType;
local isNotNil = TRP3_API.Assertions.isNotNil;

Sounds.CHANNELS = {
	MASTER = "Master",
	SFX = "SFX",
	AMBIENCE = "Ambience",
	MUSIC = "Music",
	DIALOG = "Dialog",
}

local MUSIC_FILE_PATH = [[Sound\Music\%s.mp3"]];

local soundHandlers = {};

---Build a sound handler to be inserted inside our soundHandlers table
---@param channel string @ The channel of the sound, one of Sounds.CHANNELS
---@param id sting|number @ Either a sound path or a sound ID to play as a music
---@param handlerID number
---@param optional source string @ The source of the music (default to user)
local function buildHandler(channel, id, handlerID, source)
	assert(isType(channel, "string", "channel"));
	assert(isNotNil(id, "id"));
	assert(isType(handlerID, "number", "handlerID"));
	return {
		channel = channel,
		id = id,
		handlerID = handlerID,
		source = source or TRP3_API.globals.player_id,
		date = date("%H:%M:%S")
	}
end

function Sounds.getHandlers()
	return soundHandlers;
end

function Sounds.clearHandlers()
	return wipe(soundHandlers);
end

-- TODO I was mistaken here. Callbacks aren't the solution. We should fire an event instead.
local playedSoundCallbacks = {};

--- Register a new callback to be called everytime a sound is played.
---@param callback func @ A callback that will be called everytime a sound is played.
---@return string callbackID @ The ID used to store the callback. Can be used later to unregister the callback.
function Sounds.registerOnSoundPlayedCallback(callback)
	assert(isType(callback, "function", "callback"));

	local callbackID = Strings.generateUniqueID(playedSoundCallbacks);
	playedSoundCallbacks[callbackID] = callback;
	Logs.info("Registered new played sound callback with ID " .. callbackID);

	return callbackID;
end

--- Unregister a previsouly registered callback. It will no longer be called everytime a sound is played.
---@param callbackID string @ The ID of the callback previously registered.
function Sounds.unregisterOnSoundPlayedCallback(callbackID)
	assert(isType(callbackID, "string", "callbackID"));
	assert(playedSoundCallbacks[callbackID], "Unknown playedSound callback ID " .. callbackID);

	playedSoundCallbacks[callbackID] = nil;
	Logs.info("Unregistered played sound callback with ID " .. callbackID);
end

---Fire all callbacks registered for the sound played event
---@param playedSoundHandler table @ A table representing the played sound handler. It will be passed to the registered callbacks
local function fireOnSoundPlayedCallbacks(playedSoundHandler)
	for _, callback in pairs(playedSoundCallbacks) do
		callback(playedSoundHandler);
	end
end

---Play a sound via its ID
---@param soundID number @ The ID of the sound to play
---@param channel string @ The channel on which the sound should be played, one of Sounds.CHANNELS
---@param source string @ The source of the music (default to user)
function Sounds.playSoundID(soundID, channel, source)
	assert(isNotNil(soundID, "soundID"));

	local willPlay, handlerID = PlaySound(soundID, channel, false);

	if willPlay then
		local playedSoundHandler = buildHandler(channel, soundID, handlerID, source);
		tinsert(soundHandlers, playedSoundHandler);
		fireOnSoundPlayedCallbacks(playedSoundHandler);
	end
	return willPlay, handlerID;
end

---@param handlerID number @ A sound handler ID to stop
function Sounds.stopSound(handlerID)
	StopSound(handlerID);
end

---@param channel string @ The channel on which we should stop all sounds currently playing, one of Sounds.CHANNELS
function Sounds.stopChannel(channel)
	for index, handler in pairs(soundHandlers) do
		if not channel or handler.channel == channel then
			Sounds.stopSound(handler.handlerID);
		end
	end
end

---Stop all musics currently playing
function Sounds.stopMusic()
	StopMusic();
	Sounds.stopChannel(Sounds.CHANNELS.MUSIC);
end

---@param music string|number @ Either a sound path or a sound ID to play as a music
---@param optional source string @ The source of the music (default to user)
function Sounds.playMusic(music, source)
	assert(isNotNil(music,"music"));

	Sounds.stopMusic();

	if type(music) == "number" then
		Logs.info("Playing sound: ", music);

		Sounds.playSoundID(music, Sounds.CHANNELS.MUSIC);
	else
		Logs.info("Playing music: ", music);

		PlayMusic(MUSIC_FILE_PATH.format(music));
		local playedSoundHandler = buildHandler(Sounds.CHANNELS.MUSIC, music, 0, source);
		tinsert(soundHandlers, playedSoundHandler);
		fireOnSoundPlayedCallbacks(playedSoundHandler);
	end
end

---Try to get the title of a music from its URL or sound ID
---@param musicURL string|number @ The full URL of a music or the sound ID
---@return string musicTitle @ The title of the music
function Sounds.getTitle(musicURL)
	return type(musicURL) == "number" and musicURL or musicURL:match("[%\\]?([^%\\]+)$");
end