-----------------------------------------------------------------------------------------
--
-- level.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local levelsData = require("levelsdata")
local Block = require("block")
local Board = require("board")
local TimerBar = require("timerBar")
local SelinaSprite = require("selina")

-- include Corona's "physics" library
-- local physics = require "physics"
-- physics.start(); physics.pause()

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
local tileWidth, tileHeight = 32,32
local piecesList
local textsPiecesCount = {}
local boardGrid 
local draggingPiece = false
local timerBar
local selina

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

------------------------
-- Board delegates
------------------------

------------------------
-- Block delegates
------------------------
local function onStartDragBlock(block)
	if draggingPiece or block.placed then return true end
	boardGrid:invalidatePosition(block.x, block.y)
	local piece = nil
	for i=1,#piecesList do
		piece = piecesList[i]
		if piece.name == block.name and piece.count > 0 then
			piece.count = piece.count - 1
			piecesList[i].count = piece.count
			textsPiecesCount[i].text = piece.count
			draggingPiece = true
			return true
		end
	end
	return false
end

local function onCancelDragBlock(name)
	local piece = nil	
	for i=1,#piecesList do
		piece = piecesList[i]
		if piece.name == name then
			piece.count = piece.count + 1
			piecesList[i].count = piece.count
			textsPiecesCount[i].text = piece.count
		end
	end
end

local function canPlaceBlock(x,y)
	draggingPiece = false
	return boardGrid:canPlaceBlock(x,y)
end

local function isInsideBoard(x,y)	
	return boardGrid:blockIsInside(x,y)
end

------------------------
-- Scene delegates
------------------------

function scene:generateBlocks (group,level)	
	piecesList = levelsData[level].pieces
	for i=1,#piecesList do
		local block = Block.newBlock(piecesList[i].name)		
		local column = tileWidth*12		
		block:setX(column)
		block:setY(tileHeight+(12*(i-1))+(tileHeight*i))
		block:addToGroup(group)
		block:setDragDelegate(onStartDragBlock)
		block:setDragFailDelegate(onCancelDragBlock)
		block:checkBlockPositionDelegate(canPlaceBlock)
		block:checkIsInsideBoardDelegate(isInsideBoard)
		local countText = display.newText(group,piecesList[i].count,column+tileWidth+2,tileHeight+(8*(i))+(tileHeight*i),"Braxton",20)
		table.insert(textsPiecesCount,countText)
	end
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	local levelName = "level"..event.params.level
	local levelData = levelsData[levelName]

	-- create a grey rectangle as the backdrop
	local bg = display.newImageRect( levelData.bgImg, screenW, screenH )
	bg:setReferencePoint(display.TopLeftReferencePoint)
	bg.x,bg.y = 0, 0 	
	-- all display objects must be inserted into group
	group:insert( bg )	
	
	boardGrid = Board.new(group,tileWidth,tileHeight)
	boardGrid:createTiles(group)	
	boardGrid:setupGridImages(levelData.board)
	if levelData.startPos == "up" then
		selina = SelinaSprite.new(177,30,group)
	elseif levelData.startPos == "right" then
		selina = SelinaSprite.new(280,135,group)
	elseif levelData.startPos == "down" then
		selina = SelinaSprite.new(177,255,group)
	end
	
	selina:animate()
	
	local arrows = levelData.arrows
	for k,arrow in pairs(arrows) do
		local bg = display.newImageRect( arrow.img, arrow.w,arrow.h )
		bg:setReferencePoint(display.CenterReferencePoint)
		bg.x,bg.y = arrow.x, arrow.y 	
		group:insert( bg )
	end

	if levelData.startPos == "down" then
		timerBar = TimerBar.new(halfW-60,40,0.25)
	else
		timerBar = TimerBar.new(halfW-60,screenH-45,0.25)
	end
	timerBar:addToGroup(group)

	local blocksBg = display.newImageRect(group, "hud.png", 94,250  )	
	blocksBg.x = 400
	blocksBg.y = 135

	local column = tileWidth*12
	display.newText(group,"Pontes",column-7,tileHeight-5,"Braxton",25)

	scene:generateBlocks(group,levelName)	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	timerBar.active = true
	-- physics.start()
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-- physics.stop()
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	pieceList = nil
	textsPiecesCount = nil	
	-- package.loaded[physics] = nil
	-- physics = nil
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene