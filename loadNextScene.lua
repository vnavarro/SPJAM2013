-----------------------------------------------------------------------------------------
--
-- creditos.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local nextScene = ""
local nextScreenParams
-- include Corona's "widget" library

--------------------------------------------

-- forward declarations and other locals
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
  -- create/position logo/title image on upper-half of the screen
  local logo = display.newImageRect(group, "logo.png", 244, 176 )
  --logo:setReferencePoint( display.TopLeftReferencePoint )
  logo.x, logo.y = display.contentWidth/2, display.contentHeight/2
  
  group:insert( logo )
  
end

local function goToScene(event)
  storyboard.gotoScene( nextScene,{ effect = "fade", time = 500, params={nextScreenParams}} )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
for k,v in pairs(event) do print(k,v) end
  print(event.params, event.params.nextScene)
  local group = self.view
  nextScene = event.params.nextScene
  nextScreenParams = event.params.nextScreenParams
  timer.performWithDelay(1500, goToScene)
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