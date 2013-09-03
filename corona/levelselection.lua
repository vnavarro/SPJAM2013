-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"
--------------------------------------------

-- 'onRelease' event listener for playBtn
local function onPlayBtnTouch(event)

  if event.phase == "ended" then
	storyboard.gotoScene( "level", { "fade", 500, params = {level=event.target.selectedLevel}} )
  end
  
  return true -- indicates successful touch
end

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
  
  group.buttonList = {}
  for i=1,6 do    
    -- if db:isLevelUnlocked(i) then
      -- create a widget button (which will loads level1.lua on release)
      local playBtn = display.newImageRect( group,"0"..i..".png", 58, 58 )
      playBtn.selectedLevel = i
      playBtn:addEventListener("touch", onPlayBtnTouch)
      playBtn:setReferencePoint( display.CenterReferencePoint )
      paddingX = (68 * (i-1))
      paddingY = 0
      if i > 3 then
        paddingX = (68 * (i-4))
        paddingY = 68 
      end
      playBtn.x = display.contentWidth/3 + paddingX
      playBtn.y = display.contentHeight/2.5 + paddingY
      
      -- all display objects must be inserted into group
      group:insert( playBtn ) 
    -- end
  end

  local backBtn = display.newImageRect( group,"back.png", 58, 58 )
  backBtn:addEventListener("touch", onBackBtnTouch)
  
  backBtn:setReferencePoint( display.CenterReferencePoint )
  backBtn.x = 50
  backBtn.y = display.contentHeight - 50

  -- create/position logo/title image on upper-half of the screen
  local stage = display.newImageRect(group, "blend.png", display.contentWidth, display.contentHeight )
  stage:setReferencePoint( display.TopLeftReferencePoint )
  stage.x, stage.y = 0, 0
  stage.blendMode = "multiply"
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
  local group = self.view
  
  -- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
  print("PORRA",SC.isPlaying(SC.MENU_SELECTED))
  if not SC.isPlaying(SC.MENU_SELECTED) then
    SC.playSound( SC.MENU_SELECTED, false, -1, nil ) 
  end
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
  local group = self.view
  
  -- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
  
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
  local group = self.view
  
  local count = #group.buttonList
  for i=1,count do
    local playBtn = group.buttonList[i]
    if playBtn then
      playBtn:removeSelf()  -- widgets must be manually removed
      playBtn = nil
    end
  end
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