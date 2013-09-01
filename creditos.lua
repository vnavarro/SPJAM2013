-----------------------------------------------------------------------------------------
--
-- creditos.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library

--------------------------------------------

-- forward declarations and other locals

-- 'onRelease' event listener for playBtn
local function onBackBtnTouch(event)
  
  if event.phase == "ended" then
  -- go to level1.lua scene
    storyboard.gotoScene( "menu", "fade", 500 )
  end
  return true -- indicates successful touch
end

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--     unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
  local group = self.view

  -- display a background image
  local background = display.newImageRect(group, "BG_stage_select.png", display.contentWidth, display.contentHeight )
  background:setReferencePoint( display.TopLeftReferencePoint )
  background.x, background.y = 0, 0

  -- create/position logo/title image on upper-half of the screen
  local stage = display.newImageRect(group, "blend.png", display.contentWidth, display.contentHeight )
  stage:setReferencePoint( display.TopLeftReferencePoint )
  stage.x, stage.y = 0, 0
  stage.blendMode = "multiply" 

  local backBtn = display.newImageRect( group,"back.png", 58, 58 )
  backBtn:addEventListener("touch", onBackBtnTouch)
  
  backBtn:setReferencePoint( display.CenterReferencePoint )
  backBtn.x = display.contentWidth - 50
  backBtn.y = display.contentHeight - 50
  
  -- all display objects must be inserted into group
  group:insert( background )  
  group:insert( backBtn )
  group:insert( stage )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
  local group = self.view
  
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