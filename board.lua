module(...,package.seeall)

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

  function board:createTiles()
    for i=1,5 do
      local rowTiles = {}
      for j=1,5 do
        local crate = display.newImageRect("crate.png",tileWidth,tileHeight)
        crate:setReferencePoint(display.TopLeftReferencePoint)
        crate.x,crate.y = tileWidth*2+(tileWidth*i),tileHeight+(tileHeight*j)
        table.insert(rowTiles,{x=crate.x,y=crate.y})
        self.group:insert( crate )
      end   
      table.insert(board.tiles,rowTiles)
    end
  end

  function board:blockIsInside(x,y)
    return x >= board.x and x <= board.xMax and y >= board.y and y <= board.yMax
  end

  function board:canPlaceBlock(x,y)
    if not self:blockIsInside(x,y) then
      return false
    end
    for i=1,5 do
      for j=1,5 do
        local position = board.tiles[i][j];
        if x > position.x and x < position.x+board.tileWidth and 
          y > position.y and y < position.y+board.tileHeight then
          return true,position.x,position.y
        end
      end
    end
    return false
  end

  return board
end