module(...,package.seeall)

local images = {
  powercurve="powercurve.png",
  powerstraight="powerstraight.png",
  downcurve="downcurve.png",
  downstraight="downstraight.png"
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
  block.onBlockInserted = nil
  block.onEndedRotation = nil
  block.placed = false
  block.selected = false
  block.onBlockSelected = nil

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

  function block:setRotation(rot)
    self.image.rotation = rot
    local rotationLimit = 360
    if self.name == names.powerstraight or self.name == names.downstraight then
      rotationLimit = 180
    end
    self.image.rotation = self.image.rotation % rotationLimit
  end

  function block:doDuplicate(x,y,group)
    local duplicateBlock =  newBlock(self.name,0)       
    duplicateBlock:setX(x)
    duplicateBlock:setY(y)    
    duplicateBlock:setDragDelegate(self.onDragDelegate)
    duplicateBlock:setDragFailDelegate(self.onDragFailDelegate)
    duplicateBlock:checkBlockPositionDelegate(self.checkBlockPositionDelegate)
    duplicateBlock:checkIsInsideBoardDelegate(self.checkIsInsideBoard)	
    duplicateBlock.onBlockInserted = self.onBlockInserted    
    duplicateBlock.onEndedRotation = self.onEndedRotation
    duplicateBlock:addToGroup(group)
    -- return duplicateBlock
  end

  function block:duplicate()
    local currentX,currentY = self.x,self.y
    local group = self.image.parent
    -- wrap spawnBall and randomPosition inside a closure
    local myclosure = function() self:doDuplicate(currentX,currentY,group) end
    timer.performWithDelay(50, myclosure, 1)
    --spawnBall()
end

  function block:isDown()
    return block.name == names.downcurve or block.name == names.downstraight
  end

  function block:tap(event)
    print("tapped")
    if block.placed and event.numTaps == 1 then
      if CurrentDragging == self or not CurrentDragging then
        self:setRotation(self.image.rotation + 90)
        self.onEndedRotation({x=self.image.x,y=self.image.y,name=self.name,rot=self.image.rotation})
      end
    end
  end

  local isDragging = false
  
  function block:newtouch(event)
    if event.phase == "began" then
    elseif event.phase == "ended" and not block.checkIsInsideBoard(self.image.x,self.image.y) then      
      print("touched")
      block.selected = not block.selected
      block.onBlockSelected(block)
    end
  end

  -- local function blockTouch (event)
  function block:touch(event)
  	if currentDragging ~= nil and currentDragging ~= self then 
  		return true 
  	end	
    self.image:toFront()
    if event.phase == "began" then		
  		if self.checkIsInsideBoard then
  			local valid, x, y = self.checkIsInsideBoard(self.image.x, self.image.y)			
  			self.placed = valid
  		end

      display.getCurrentStage():setFocus( self.image )
      self.image.isFocus = true
  	elseif event.phase == "moved" then		
  		currentDragging = self
  		if not isDragging then
  			isDragging = true
  			if self.onDragDelegate and not self.onDragDelegate(self) then					
  				isDragging = false
          currentDragging = nil
  				return
  			end
  			if self.checkIsInsideBoard then
  				local valid, x, y = self.checkIsInsideBoard(self.image.x, self.image.y)
  				if not valid then
  					self:duplicate(self.image.parent)
  				end
  			end
  		end
  		self:setX(event.x-self.image.width/2)
  		self:setY(event.y-self.image.height/2)
  	elseif event.phase == "ended" then
  		if isDragging then
  			if self.checkBlockPositionDelegate then
  				local valid, x, y = self.checkBlockPositionDelegate({x=self.image.x, y=self.image.y,name=self.name,rot=self.image.rotation})
  				if valid then
  					self:setX(x)
  					self:setY(y)
            self.onBlockInserted(self)
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
          local rotationLimit = 360
          if self.name == names.powerstraight or self.name == names.downstraight then
            rotationLimit = 180
          end
          self.image.rotation = self.image.rotation % rotationLimit
          self.onEndedRotation({x=self.image.x,y=self.image.y,name=self.name,rot=self.image.rotation})
  			end
  		end
  		currentDragging = nil      
      display.getCurrentStage():setFocus( nil )
      self.image.isFocus = nil
  	end		
    return true
  end


  block.image:addEventListener("touch", block)
  -- block.image:addEventListener("tap", block)
  -- Runtime:addEventListener("touch", block)

  return block
end