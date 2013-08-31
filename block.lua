module(...,package.seeall)

local images = {
  powercurve="chainl.png",
  powerstraight="chain.png",
  downcurve="chainl.png",
  downstraight="chain.png"
}

local names = {
  powercurve="powercurve",
  powerstraight="powerstraight",
  downcurve="downcurve",
  downstraight="downstraight"
}

function newBlock(name)
  local block = {}
  block.name = name
  block.image = display.newImageRect(images[name], 32, 32 )
  block.image.rotation = 0
  block.image:setReferencePoint(display.CenterReferencePoint)
  block.x = block.image.x
  block.y = block.image.y

  function block:addToGroup(group)
    group:insert(self.image);
  end

  function block:destroy()
    self.image:removeSelf()
    self = nil;
  end

  function block:setX(x)
    self.image.x = x+block.image.width/2
    self.x = x
  end
  function block:setY(y)
    self.image.y = y+block.image.height/2
    self.y = y
  end

  function block:duplicate()
    local duplicateBlock =  newBlock(self.name,0)    
    duplicateBlock:setX(self.x)
    duplicateBlock:setY(self.y)    
    return duplicateBlock
  end

  function block:touch(event)
    if event.phase == "ended" then
      print(self.image.parent)
      self:duplicate():addToGroup(self.image.parent)
    end
  end

  block.image:addEventListener("touch", block)

  return block
end