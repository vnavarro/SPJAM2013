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
--class sounds
local SC = require ("soundControl")


--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
local tileWidth, tileHeight = 32,32
local piecesList
local textsPiecesCount = {}
local boardGrid 
local draggingPiece = false
local timerBar
local changedToBad = false
local badScreenFile = "tela_ruim.png"
local levelName

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
	boardGrid:invalidatePosition(block.x, block.y)
	if draggingPiece or block.placed then return true end		
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

local function onBlockInsertedDelegate(block)
	if boardGrid:checkIfWon(levelsData[levelName].solution) then
		scene:Won()
		return
	end
	if block:isDown() then
		timerBar.speed = timerBar.speed + 0.025
		scene:changeToBad()		
	end
end

local function onEndedRotation(event)	
	boardGrid:updateBlockAt(event)
	if boardGrid:checkIfWon(levelsData[levelName].solution) then
		scene:Won()
	end
end

------------------------
-- Timer Bar Delegate
------------------------
local function expiredTimeEvent()
	scene:gameOver()
end

------------------------
-- Scene other 
------------------------

local function canPlaceBlock(event)
	draggingPiece = false
	print(event.name,event.rot,event.x,event.y)
	return boardGrid:canPlaceBlock(event)
end

local function isInsideBoard(x,y)	
	return boardGrid:blockIsInside(x,y)
end

function scene:hasChangedToBad()
	return changedToBad
end

function scene:changeToBad()
	if self:hasChangedToBad() then return end
	local bg = display.newImageRect( "tela_ruim.png", screenW, screenH )
	bg:setReferencePoint(display.TopLeftReferencePoint)
	bg.x,bg.y = 0, 0 	
	bg.alpha = 0
	self.view:insert(2,bg)
	transition.to(bg, {time = 800, alpha = 1, onComplete = function() 
		self.view.bg:removeSelf()
		end})
	changedToBad = true

		-- change to bad scene
		if ( changedToBad == true ) then
			SC.stopAll()
		    SC.loadSound( SC.DANGERGO )
		    SC.playSound( SC.DANGERGO, true, "0", nil ) 
		    SC.loadSound( SC.DANGERSOUND )
		    SC.playSound( SC.DANGERSOUND, true, "-1", nil ) 
		end

end

function scene:createPiecesList(piecesData)
	piecesList = {}
	for k,piece in pairs(piecesData) do
		table.insert(piecesList,{name=piece.name,count=piece.count})
	end
end

function scene:generateBlocks (group,level)	
	self:createPiecesList(levelsData[level].pieces)
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
		block.onBlockInserted = onBlockInsertedDelegate
		block.onEndedRotation = onEndedRotation
		local countText = display.newText(group,piecesList[i].count,column+tileWidth+2,tileHeight+(8*(i))+(tileHeight*i),"Braxton",20)
		table.insert(textsPiecesCount,countText)
	end
end

function scene:won()

end

function makeTransition(group)
	local redBg = display.newRect(group,0,0,display.contentWidth, display.contentHeight)
	redBg:setFillColor(255,0,0)
	redBg.alpha = 0
	local gameOverSprite = display.newImageRect(group, "GameOver.png",266,79)
	gameOverSprite.alpha = 0
	gameOverSprite.x, gameOverSprite.y = display.contentWidth/2, display.contentHeight/2
	local filter = display.newImageRect(group,"embed.png", display.contentWidth, display.contentHeight)
	filter.blendMode = "multiply" 
	filter.x, filter.y = display.contentWidth/2, display.contentHeight/2
	filter.alpha = 0
	
	transition.to(redBg,{time=2000, alpha = 0.7})
	transition.to(filter,{time=2000, alpha = 1})
	transition.to(gameOverSprite,{time=500, alpha = 1})
	
	timer.performWithDelay(4000, function() storyboard.gotoScene( "loadNextScene", {effect = "fade", time = 200, params={nextScene = "levelselection"} }) end)
end



function scene:gameOver()
	makeTransition(self.view)
end

function scene:reset()
	print("RESET CARALHO!!!")
	piecesList = nil
	textsPiecesCount = {}
	boardGrid = nil
	draggingPiece = false
	timerBar:destroy()
	timerBar = nil
	changedToBad = false
	levelName = nil
end

------------------------
-- Scene delegates
------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	print("CREATE!!")

	levelName = "level"..event.params.level
	local levelData = levelsData[levelName]

	-- create a grey rectangle as the backdrop
	local bgImg = levelData.bgImg
	if bgImg == badScreenFile then
		changedToBad = true		
	end
	group.bg = display.newImageRect( bgImg, screenW, screenH )
	group.bg:setReferencePoint(display.TopLeftReferencePoint)
	group.bg.x,group.bg.y = 0, 0 	
	-- all display objects must be inserted into group
	group:insert( group.bg )	
	
	boardGrid = Board.new(group,tileWidth,tileHeight)
	boardGrid:createTiles(group)	
	boardGrid:setupGridImages(levelData.board)
	boardGrid.solution = levelData.solution

	local selina = nil
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

	local speed = 3--0.25
	if changedToBad then
		speed = 0.275
	end
	if levelData.startPos == "down" then
		timerBar = TimerBar.new(halfW-60,40,speed)
	else
		timerBar = TimerBar.new(halfW-60,screenH-45,speed)
	end
	timerBar:addToGroup(group)
	Runtime:addEventListener("expiredTime", expiredTimeEvent)

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
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	timerBar.active = false	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	scene:reset()

	pieceList = nil
	textsPiecesCount = nil	
	Runtime:removeEventListener("expiredTime", expiredTimeEvent)
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