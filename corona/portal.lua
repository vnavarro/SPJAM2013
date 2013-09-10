module(...,package.seeall)

local sheetInfo = require "portalss"

function new(x,y,group,pType)
  local portal = {}
  if pType == "good" then 
    sheetInfo.sequenceData = {
      {name="anim", start=1, count=6, time=300}
    }
  else 
    sheetInfo.sequenceData = {
      {name="anim", start=7,count=6, time=300,loopCount=0,loopDirection="forward"}
    }
  end
  
  local imageSheet = graphics.newImageSheet("portalss.png", sheetInfo:getSheet())
  print(imageSheet,group,sheetInfo.sequenceData)
  portal.sprite = display.newSprite(group,imageSheet, sheetInfo.sequenceData)
  -- portal.sprite:setReferencePoint(display.TopLeftReference)
  portal.sprite.x = x+16
  portal.sprite.y = y+16
  group:insert(portal.sprite)
  
  function portal:animate()
    portal.sprite:setSequence("anim")
    portal.sprite:play()
  end
  
  function portal:destroy()
    portal.sprite:removeSelf()
  end
  return portal
end

