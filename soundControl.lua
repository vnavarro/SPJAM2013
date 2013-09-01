module(...,package.seeall)
---------------------------
local anim_locks = {}
local soundHandles = {}
local soundChannels = {}

MENU_SELECTED = "menuSelected"
MENU_SELECTED2 = "menuSelected2"

local SOUND = "on"

local soundList = {
	menuSelected="sound_Intro.mp3",
	menuSelected2="sound_Intro2.mp3"
}
--Por algum motivo a bgm_goblinking.mp3 faz o jogo parar de funcionar e por isso foi removida
-- local enemies = require('enemies')
---------------------------

function isAverticallyInsideB(bounds_a,bounds_b)
	return (bounds_a.yMin >= bounds_b.yMin and bounds_a.yMin <= bounds_b.yMax) or
		(bounds_a.yMax >= bounds_b.yMin and bounds_a.yMax <= bounds_b.yMax)
end

---MATH, PHYSISCS AND OTHER FUNCTIONS
function isAcollidingWithB(bounds_a,bounds_b)
--	print("CHECK COLLISION",other_sprite.x,other_sprite.x+bounds_a.xMax,self.sprite.x +bounds_b.xMax)
	if bounds_a.xMin >= bounds_b.xMin and 
		bounds_a.xMin <= bounds_b.xMax then
		return isAverticallyInsideB(bounds_a,bounds_b)
	elseif bounds_a.xMax >= bounds_b.xMin and
		bounds_a.xMax <= bounds_b.xMax then
		return isAverticallyInsideB(bounds_a,bounds_b)
	end
	return false
end

---CONFIG FUNCTIONS

---ANIMATION FUNCTIONS
--[[Summary
some description text goes here
params 
@param1:type
@param2:type
....
return type - @description
]]--
function animGrowUpAndGoBack(display_object,grow_size,speed,onCompleteCallback)
	if anim_locks and not anim_locks[display_object] then
		local a = display_object
		local w, h = a.width,a.height
		local completeCallback = function () anim_locks[display_object] = false if onCompleteCallback then onCompleteCallback() end end
		local goBack = function () transition.to(a, {time = speed,width =a.width/grow_size,height=a.height/grow_size, onComplete = completeCallback }) end
		transition.to(a, {time = speed, width = a.width*grow_size,height=a.height*grow_size,onComplete = goBack})
		anim_locks[display_object] = true
	end
end

----Fuzzy Functions
--[[Summary
some description text goes here
params 
@param1:type
@param2:type
return type - @description
]]--
function fuzzyHighLife(life)
	if life <= 0 then 
		return 0
	elseif life > 0 and life <= 50 then
		return 2*(math.pow(life/100,2))
	elseif life > 50 and life <=100 then
		return 1-2*(math.pow((life-100)/100,2))
	elseif life > 100 then
		return 1
	end		
end
--[[Summary
some description text goes here
params 
@param1:type
@param2:type
return type - @description
]]--
function fuzzyLowLife(life)
	--return 1-fuzzyHighLife(life)
	return fuzzyHighLife(life)
end
--[[	
some description text goes here
params 
@param1:type
@param2:type
return type - @description
]]--
function shouldGivePot(life)
	local fuzzyLow = fuzzyLowLife(life)	
	print("Should give pot?",fuzzyLow)
	if fuzzyLow == 1 then --imbatível
		return false
	elseif fuzzyLow >= .8 and fuzzyLow < 1 then  -- saudável <= estado < imbatível
		return math.random(0,10) >= 9
	elseif fuzzyLow >= .5 and fuzzyLow < .8 then -- cansado <= estado <= saudável
		return math.random(0,10) >= 8
	elseif fuzzyLow >= .18 and fuzzyLow < .5 then -- ferido <= estado <= cansado
		return math.random(0,10) >= 6
	elseif fuzzyLow >= .005 and fuzzyLow < .18 then -- incapacitado <= estado <= ferido
		return math.random(0,10) >= 4
	elseif fuzzyLow < .005 then -- estado < incapacitado
		return true
	end
	
--[[	0 - 0 -- morto
	25 - 0,125 -- incapacitado
	45 - 0,405 -- ferido
	50 - 0,5 -- abatido
	55 - 0,595 -- cansado
	65 - 0,755 -- saudável
	95 - 0,995 -- imbatível
	100 - 1 -- imbatível]]--
end

function getScoreForObjectOfType(type)
	if type == enemies.ENEMY_KNIGHT then
		return 240
	elseif type == enemies.ENEMY_DUMMY then
		return 35
	elseif type == enemies.ENEMY_SOLDIER then
		return 50
	end 
	return 0
end


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
