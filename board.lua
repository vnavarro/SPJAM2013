module(...,package.seeall)
local Block = require("block")

function new(group,tileWidth,tileHeight)
  local board = {}
  board.group = group
  board.tiles = {}
  board.tileWidth = tileWidth
  board.tileHeight = tileHeight
  board.width = 160
  board.height = 160
  board.x = 96
  board.y = 64
  board.xMax = board.x+board.width
  board.yMax = board.y+board.height
  board.onNewBlockFromSetupGrid = nil

  function board:createTiles()
    for i=1,5 do
      local rowTiles = {}
      for j=1,5 do
        local tx, ty = tileWidth*2+(tileWidth*j),tileHeight+(tileHeight*i)
        table.insert(rowTiles,{x=tx, y=ty, hasBlock = false})
      end   
      table.insert(board.tiles,rowTiles)
    end
  end

  function board:blockIsInside(x,y)
    return x >= board.x and x <= board.xMax and y >= board.y and y <= board.yMax
  end

  function board:invalidatePosition(x,y) 
  	if not self:blockIsInside(x,y) then return end
  	for i=1,5 do
      for j=1,5 do
        local position = board.tiles[i][j];
        if x == position.x and  y == position.y and position.hasBlock then
      		  position.hasBlock = false
            position.name = nil
            position.rotation = -1
            print("invalidate",i,j,position.x,position.y)
        end
      end
    end
  end

  function board:updateBlockAt(event)    
    if not self:blockIsInside(event.x,event.y) then return end    
    for i=1,5 do
      for j=1,5 do
        local position = board.tiles[i][j];
        if event.x >= position.x and event.x <= position.x+board.tileWidth and 
          event.y >= position.y and event.y <= position.y+board.tileHeight then
            position.name = event.name
            position.rotation = event.rot
            print("UPDATE AT",position.name,position.rotation,position.hasBlock)
        end
      end
    end
  end
  
  function board:canPlaceBlock(event)
    if not self:blockIsInside(event.x,event.y) then
      return false
    end
    for i=1,5 do
      for j=1,5 do
        local position = board.tiles[i][j]
        if event.x > position.x and event.x < position.x+board.tileWidth and 
          event.y > position.y and event.y < position.y+board.tileHeight and not position.hasBlock 
          and not position.hasObject then
    		  position.hasBlock = true 
          position.name = event.name
          position.rotation = event.rot
          print("canPlaceBlock",position.name,position.rotation,position.hasBlock)
          return true,position.x,position.y
        end
      end
    end
    return false
  end

  function board:setupGridImages(boardData)
    for i=1,#boardData do
      for j=1,#boardData[i] do            
        if boardData[i][j].tileType == "stone" then
          self.tiles[i][j].hasObject = true
          local stone = display.newImageRect( self.group,"stone01.png", 32, 32 )
          stone:setReferencePoint(display.TopLeftReferencePoint)          
          stone.x,stone.y = self.tileWidth*2+(self.tileWidth*j),self.tileHeight+(self.tileHeight*i)
        elseif boardData[i][j].tileType == "block" then
          self.tiles[i][j].hasBlock = true
          self.tiles[i][j].name = boardData[i][j].name
          self.tiles[i][j].rotation = boardData[i][j].rotation

          local block = Block.newBlock(boardData[i][j].name)
          block:setRotation(boardData[i][j].rotation)
          block:setX(self.tiles[i][j].x)
          block:setY(self.tiles[i][j].y)
          block:addToGroup(self.group)
          block.placed = true

          block.image:removeEventListener("touch", block)
        end
      end      
    end
  end

  function board:checkIfWon(solution)
    local count = 0
    print(">>>>>>>")
    for i=1,#solution do
      local blockSolution = solution[i]
      local position = self.tiles[blockSolution.position.y][blockSolution.position.x]      
      print("checkIfWon AT",position.name,position.rotation,position.hasBlock)
      if position.name == blockSolution.name and 
        position.rotation == blockSolution.rotation and position.hasBlock then
        count = count +1
      end      
    end
    print("WON?",count,#solution)
    print(">>>>>>>")
    return count == #solution
  end

  return board
end