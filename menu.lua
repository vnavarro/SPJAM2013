-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"
require 'db'

-- inclune audio lib

--------------------------------------------

-- forward declarations and other locals
local audioBtnOff
local audioBtnOn


-- 'onRelease' event listener for playBtn
local function onPlayBtnTouch(event)
	
	if event.phase == "ended" then
	-- go to level1.lua scene
		storyboard.gotoScene( "levelselection", "fade", 500 )
	end
	return true	-- indicates successful touch
end

local function onAudioBtnTouch(event)
	
	if event.phase == "ended" then
		audioBtnOn.isVisible = not audioBtnOn.isVisible
		audioBtnOff.isVisible = not audioBtnOff.isVisible
		SC.switchSound()
	end
	return true	-- indicates successful touch
end

local function onCreditsBtnTouch(event)
	
	if event.phase == "ended" then
	-- go to level1.lua scene
		storyboard.gotoScene( "creditos", "fade", 500 )
	end
	return true	-- indicates successful touch
end

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	--load(sound)

	-- display a background image
	local background = display.newImageRect( "start_screen_01.jpg", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	
	local playBtn = display.newImageRect( group,"jogar.png", 58, 58 )
  playBtn:addEventListener("touch", onPlayBtnTouch)
	
	-- audio config
	audioBtnOn = display.newImageRect( group,"som_on.png", 58, 58 )
  audioBtnOn:addEventListener("touch", onAudioBtnTouch)

  audioBtnOff = display.newImageRect( group,"som_off.png", 58, 58 )
  audioBtnOff:addEventListener("touch", onAudioBtnTouch)
  audioBtnOff.isVisible = false

  local creditsBtn = display.newImageRect( group,"credits.png", 58, 58 )
  creditsBtn:addEventListener("touch", onCreditsBtnTouch)
	
	playBtn:setReferencePoint( display.CenterReferencePoint )
	playBtn.x = display.contentWidth*0.50
	playBtn.y = display.contentHeight - 100
	
	audioBtnOn:setReferencePoint( display.CenterReferencePoint )
	audioBtnOn.x = display.contentWidth*0.82
	audioBtnOn.y = display.contentHeight - 100

	audioBtnOff:setReferencePoint( display.CenterReferencePoint )
	audioBtnOff.x = display.contentWidth*0.82
	audioBtnOff.y = display.contentHeight - 100
	
	creditsBtn:setReferencePoint( display.CenterReferencePoint )
	creditsBtn.x = display.contentWidth*0.66
	creditsBtn.y = display.contentHeight - 100
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( playBtn )
	group:insert( audioBtnOn )
	group:insert( audioBtnOff )
	group:insert( creditsBtn )

	db = DB.new()   
  db:loadBase()
  db:setupBase()
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-- add menu sound
	if not SC.isPlaying(SC.MENU_SELECTED) then
		SC.playSound( SC.MENU_SELECTED, false, -1, nil ) 
	end

	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view

	--unload(sound)
	-- PRINT("DESTROY")
	-- SC.unloadSound( SC.MENU_SELECTED )
	-- SC.unloadSound( SC.DANGERGO )
	-- SC.unloadSound( SC.DANGERSOUND )
 --  SC.unloadSound( SC.GAMEOVER )
	-- SC.unloadSound( SC.TRANKSMUSIK )
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