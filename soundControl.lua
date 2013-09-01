module(...,package.seeall)
---------------------------
local anim_locks = {}
local soundHandles = {}
local soundChannels = {}

MENU_SELECTED = "menuSelected"
TRANKSMUSIK = "tranksMusik"
DANGERSOUND = "dangerSound"
DANGERGO = "dangerGo"
GAMEOVER = "gameOver"

local SOUND = "on"

local soundList = {
	menuSelected="sound_Intro.mp3",
	tranksMusik="sound_Tranks.mp3",
	dangerSound="sound_Danger.mp3",
	dangerGo="sound_VirouProMau.mp3",
	gameOver="sound_GameOver.mp3",
}

---------------------------

--[[TODO: Problema conhecido-> ao pausar ou resumir se o jogo não tiver colocado a música em play de nada adianta
	eu posso tentar colocar a música em volume 0 e deixar carregar e tocar tudo, tenho qeu testar no aparelho isso
]]--
function switchSound()
	if SOUND == "on" then
		SOUND = "off"
		pause()
	else
		SOUND = "on"
		resume()
	end
	print("SOUND",SOUND)
	db:setConfig("sound",SOUND)	
end

function isSoundOn()
	return SOUND == "on"
end

--Sound Control
--[[Summary
Load a sound with the given key into the memory and also on the handle list, so you can play it
params 
@param name - the key name on the soundList
]]--
function loadSound(name)
	if soundHandles[name] then return end
	soundHandles[name] = audio.loadSound(soundList[name])
end

--[[Summary
Unload the sound with a given key name
params 
@param name - the key name on the soundList
]]--
function unloadSound(name)
	if not soundHandles[name] then return end
	audio.dispose(soundHandles[name])
	for i=1,#soundHandles do
		if soundhandles[i] == soundHandles[name] then
			table.remove(soundHandles, i)
		end
	end
end


--[[Summary
Play a sound and unload it after
@param name - the key name on the soundList
@param unload - A boolean indicating if the sound should be unloaded
]]--
function playSound(name,unload,loop,listener)
	if SOUND == "off" then return false end
	if isPlaying(name) then return end
	if soundChannels[name] and audio.isChannelPaused(soundChannels[name]) then
		audio.resume( soundChannels[name] )
		return 
	end
	if not loop then loop = 0 end
	if unload then 
		soundChannels[name] = audio.play( soundHandles[name], { loops=loop , onComplete=function() 
				if listener then listener() end
				unloadSound(name) print("unloaded sound",name) 
			end})
	else
		soundChannels[name] = audio.play( soundHandles[name], { loops=loop, onComplete=listener } )
	end
end
function stopAll()
	audio.stop()
	for i=1,#soundChannels do
		table.remove(soundChannels, i)
	end
end

function stopSound(name)
	audio.stop( soundChannels[name] )
	for i=1,#soundChannels do
		if soundChannels[i] == soundChannels[name] then
			table.remove(soundChannels, i)
		end
	end
end

function isPlaying(name)
	return soundChannels[name] and audio.isChannelPlaying(soundChannels[name])
end

function pause(name)
	if name then 
		audio.pause(soundChannels[name])
	else
		audio.pause()
	end
end

function resume(name)
	if name then 
		audio.resume(soundChannels[name])
	else
		audio.resume()
	end
end


-----DEBUG
--[[Summary
Print  a red square for sprite top and a black square for srpite bottom
params 
@group:displayGroup - where to insert sprite
@x:int - sprite x position
@yTop:int - sprite y top position
@yBot:int - sprite y bot position
]]--
function traceSpriteHeight(group,x,yTop,yBot)
	local  bottom = display.newRect( group,x, yBot, 5, 5 )
	bottom:setFillColor(255,0,43)
	top = display.newRect( group,x, yTop, 5, 5 )
	top:setFillColor(0,0,0)
end
