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

local currentDragging = nil

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
  block.checkIsInsideBoard = nil
  block.placed = false

  function block:setDragDelegate(func)
	self.onDragDelegate = func
  end
  
  function block:setDragFailDelegate(func)
	self.onDragFailDelegate = func
  end
  
  function block:checkBlockPositionDelegate(func)
	self.checkBlockPositionDelegate = func
  end
  
  function block:checkIsInsideBoardDelegate(func)
	self.checkIsInsideBoard = func
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
    self.image.x = x+self.image.width/2
    self.x = x
  end
  function block:setY(y)
    self.image.y = y+self.image.height/2
    self.y = y
  end

  function block:duplicate()
    local duplicateBlock =  newBlock(self.name,0)    
    duplicateBlock:setX(self.x)
    duplicateBlock:setY(self.y)    
	duplicateBlock:setDragDelegate(self.onDragDelegate)
	duplicateBlock:setDragFailDelegate(self.onDragFailDelegate)
	duplicateBlock:checkBlockPositionDelegate(self.checkBlockPositionDelegate)
	duplicateBlock:checkIsInsideBoardDelegate(self.checkIsInsideBoard)	
    return duplicateBlock
  end

  local isDragging = false
  
  function block:touch(event)		
	if currentDragging ~= nil and currentDragging ~= self then 
		return true 
	end	
    if event.phase == "began" then		
		if self.checkIsInsideBoard then
			local valid, x, y = self.checkIsInsideBoard(self.image.x, self.image.y)			
			self.placed = valid
		end
		self.image:toFront()
	elseif event.phase == "moved" then		
		currentDragging = self
		if not isDragging then
			isDragging = true
			if self.onDragDelegate and not self.onDragDelegate(self) then					
				isDragging = false
				return
			end
			if self.checkIsInsideBoard then
				local valid, x, y = self.checkIsInsideBoard(self.image.x, self.image.y)
				if not valid then
					self:duplicate():addToGroup(self.image.parent)
				end
			end
		end
		self:setX(event.x-self.image.width/2)
		self:setY(event.y-self.image.height/2)
	elseif event.phase == "ended" then
		if isDragging then
			if self.checkBlockPositionDelegate then
				local valid, x, y = self.checkBlockPositionDelegate(self.image.x, self.image.y)
				if valid then
					self:setX(x)
					self:setY(y)
				else
					if self.onDragFailDelegate then
						self.onDragFailDelegate(self.name)
						self:destroy()
					end
				end
			end
			isDragging = false
		else
			if CurrentDragging == self or not CurrentDragging then
				self.image.rotation = self.image.rotation + 90
			end
		end
		currentDragging = nil
	end		
  end

  block.image:addEventListener("touch", block)

  return block
end