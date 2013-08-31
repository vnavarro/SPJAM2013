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
  block.onDragDelegate = nil
  block.onDragFailDelegate = nil
  block.checkBlockPositionDelegate = nil

  function block:setDragDelegate(func)
	self.onDragDelegate = func
  end
  
  function block:setDragFailDelegate(func)
	self.onDragFailDelegate = func
  end
  
  function block:checkBlockPositionDelegate(func)
	self.checkBlockPositionDelegate = func
  end
  
  function block:addToGroup(group)
    group:insert(self.image);
  end

  function block:destroy()
	self.image:removeEventListener("touch", self)
    self.image:removeSelf()
	self.onDragDelegate = nil
	self.onDragFailDelegate = nil
	self.checkBlockPositionDelegate = nil
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

  function block:isValidBoardPosition(board)
	-- TODO: ligação com a função de checagem de board
	return true
  end
  
  local isDragging = false
  
  function block:touch(event)
    if event.phase == "began" then
	
	elseif event.phase == "moved" then
		if not isDragging then
			if self.onDragDelegate then
				self.onDragDelegate()
			end
			isDragging = true
		end
		self:setX(event.x)
		self:setY(event.y)
	elseif event.phase == "ended" then
		if isDragging then
			if self.checkBlockPositionDelegate then
				local valid, x, y = self.checkBlockPositionDelegate(self.image.x, self.image.y)
				if valid then
					self:setX(x)
					self:setY(y)
				else
					if self.onDragFailDelegate then
						self.onDragFailDelegate()
						self:destroy()
					end
				end
			end
		else
			block.image.rotation = block.image.rotation + 90
		end
	end
	
	if event.phase == "ended" then
      print(self.image.parent)
      self:duplicate():addToGroup(self.image.parent)
    end
  end

  block.image:addEventListener("touch", block)

  return block
end