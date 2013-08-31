module(...,package.seeall)
--[[
a barra tem que progredir com o tempo do lado do monstro
o lado da menina fica fixo
]]

-- x, y = posicao na tela
-- speed = velocidade do avanco do tempo
function newTimerBar(x, y, speed)
	--local timerBar = display.newGroup()
	local timerBar = {}
	local monsterPos
	-- inicializacao
	timerBar.monsterPos = 0
	timerBar.x = x or 0
	timerBar.y = y or 0
	timerBar.barSprite = display.newImageRect("barSprite.png",200,50)
	timerBar.barSprite.x = timerBar.x
	timerBar.barSprite.y = timerBar.y
	timerBar.monsterSprite = display.newImageRect("monsterSprite.png",50,50)
	timerBar.limit = timerBar.barSprite.width
	timerBar.monsterSprite.x = timerBar.x - timerBar.limit/2
	timerBar.monsterSprite.y = timerBar.y
	--timerBar:insert(timerBar.barSprite)
	--timerBar:insert(timerBar.monsterSprite)
	timerBar.speed = speed
	timerBar.active = false
	
	-- evento a ser disparado quando o tempo expirar
	timerBar.expiredTimeEvent = {name = "expiredTime"}
	
	function timerBar:addToGroup(group)
		group:insert(self.barSprite)
		group:insert(self.monsterSprite)
	end
	
	local function updateTimerBar(event)
		if not timerBar.active then return end
		timerBar.monsterPos = timerBar.monsterPos + timerBar.speed * (event.time/1000)-- * (timerBar.limit/10)
		timerBar.monsterSprite.x = timerBar.monsterPos + timerBar.x - timerBar.limit/2
		if timerBar.monsterPos >= timerBar.limit then
			Runtime:removeEventListener("enterFrame", updateTimerBar)
			Runtime:dispatchEvent(timerBar.expiredTimeEvent)
		end
	end
	
	Runtime:addEventListener("enterFrame", updateTimerBar)
	
	function timerBar:destroy()
		self.barSprite:removeSelf()
		self.monsterSprite:removeSelf()
		self.barSprite = nil
		self.monsterSprite = nil
	end
	
	return timerBar
end