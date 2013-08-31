-----------------------------------------------------------------------------------------
--
-- level.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local levelsData = require("levelsdata")
local blocks = require("block")

-- include Corona's "physics" library
-- local physics = require "physics"
-- physics.start(); physics.pause()

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

function scene:createBoard (group)
	for i=1,5 do
		for j=1,5 do
			local crate = display.newImageRect("crate.png",32,32)
			crate:setReferencePoint(display.TopLeftReferencePoint)
			crate.x,crate.y = 64+(32*i),32+(32*j)
			group:insert( crate )
		end		
	end	
end

function scene:generateBlocks (group,level)
	print(levelsData,blocks)
	local pieces = levelsData[level].pieces
	for i=1,#pieces do
		local block = blocks.newBlock(pieces[i].name,pieces[i].rot)		
		local column = 384
		local yPadding = i
		if i > 6 then
			column = 416
			yPadding = i-6
		end
		block:setX(column)
		block:setY(32+(32*yPadding))
		group:insert( block ) 
	end
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- create a grey rectangle as the backdrop
	local bg = display.newImageRect( "puzzle_screen.jpg", screenW, screenH )
	bg:setReferencePoint(display.TopLeftReferencePoint)
	bg.x,bg.y = 0, 0 	
	-- all display objects must be inserted into group
	group:insert( bg )	

	scene:createBoard(group)
	scene:generateBlocks(group,"level1")
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
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