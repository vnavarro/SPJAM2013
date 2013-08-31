module(...,package.seeall)

local images = {
  curve="chainl.png",
  straight="chain.png",
  powercurve="",
  powerstraight="",
  downcurve="",
  downstraight=""
}

local names = {
  curve="curve",
  straight="straight",
  powercurve="powercurve",
  powerstraight="powerstraight",
  downcurve="downcurve",
  downstraight="downstraight"
}

function newBlock(name,rotation)
  local block = display.newGroup()
  block.name = name
  block.image = display.newImageRect(images[name], 32, 32 )
  block.image.rotation = rotation
  -- block.image:setReferencePoint(display.TopLeftReferencePoint)

  function block:setX(x)
    self.image.x = x+16
  end
  function block:setY(y)
    self.image.y = y+16
  end

  return block
end