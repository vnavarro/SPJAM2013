module(...,package.seeall)

local sheetInfo = require "selinass"

sheetInfo.sequenceData = {
	{name="idle", start=1, count=10, time=1000}
}

function new(x,y,group)
	local selina = {}
	-- selina.x = x
	-- selina.y = y
	-- selina.group = group
	local imageSheet = graphics.newImageSheet("selinass.png", sheetInfo:getSheet())
	selina.sprite = display.newSprite(group, imageSheet, sheetInfo.sequenceData)
	-- selina.sprite:setReferencePoint(display.TopLeftReference)
	selina.sprite.x = x
	selina.sprite.y = y
	group:insert(selina.sprite)
	
	function selina:animate()
		selina.sprite:setSequence("stop")
		selina.sprite:play()
	end
	
	function selina:destroy()
		selina.sprite:removeSelf()
	end
	return selina
end