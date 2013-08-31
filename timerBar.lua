module(...,package.seeall)
--[[
a barra tem que progredir com o tempo do lado do monstro
o lado da menina fica fixo
]]

-- x, y = posicao na tela
-- speed = velocidade do avanco do tempo
function new(x, y, speed)
	--local timerBar = display.newGroup()
	local timerBar = {}
	local monsterPos
	-- inicializacao
	timerBar.monsterPos = 0
	timerBar.x = x or 0
	timerBar.y = y or 0
	timerBar.barSprite = display.newImageRect("barra_externa.png",268,16)
	timerBar.barSprite.x = timerBar.x
	timerBar.barSprite.y = timerBar.y
	timerBar.frontBarSprite = display.newImageRect("barra_interna.png",268,16)
	timerBar.frontBarSprite.x = timerBar.x
	timerBar.frontBarSprite.y = timerBar.y
	timerBar.monsterSprite = display.newImageRect("barra_monster.png",32,50)
	timerBar.limit = timerBar.barSprite.width
	timerBar.monsterSprite.x = timerBar.x - timerBar.limit/2
	timerBar.monsterSprite.y = timerBar.y
	timerBar.girlSprite = display.newImageRect("barra_menina.png",44,36)
	timerBar.girlSprite.x = timerBar.x + timerBar.limit/2
	timerBar.girlSprite.y = timerBar.y
	timerBar.barMask = graphics.newMask("barra_mask.png")
	timerBar.frontBarSprite:setMask(timerBar.barMask)
	timerBar.frontBarSprite.maskX = -timerBar.frontBarSprite.width 
	timerBar.frontBarSprite.maskY = timerBar.frontBarSprite.contentHeight*0.5
	--timerBar:insert(timerBar.barSprite)
	--timerBar:insert(timerBar.monsterSprite)
	timerBar.speed = speed
	timerBar.active = false
	
	-- evento a ser disparado quando o tempo expirar
	timerBar.expiredTimeEvent = {name = "expiredTime"}
	
	function timerBar:resetTime()
		self.monsterPos = 0
	end
	
	function timerBar:addToGroup(group)
		group:insert(self.barSprite)
		group:insert(self.frontBarSprite)
		group:insert(self.girlSprite)
		group:insert(self.monsterSprite)
	end
	
	local lastUpdate
	local function updateTimerBar(event)
		if not timerBar.active then return end
		if not lastUpdate then lastUpdate = event.time end
		timerBar.monsterPos = timerBar.monsterPos + timerBar.speed * ((event.time-lastUpdate)/1000) * (timerBar.limit/10)
		timerBar.monsterSprite.x = timerBar.monsterPos + timerBar.x - timerBar.limit/2
		timerBar.frontBarSprite.maskX = timerBar.monsterPos + timerBar.x - timerBar.frontBarSprite.width - 40
		if timerBar.monsterPos >= timerBar.limit then
			Runtime:removeEventListener("enterFrame", updateTimerBar)
			Runtime:dispatchEvent(timerBar.expiredTimeEvent)
		end
		lastUpdate = event.time
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