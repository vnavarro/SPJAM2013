-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- inclune audio lib
SC = require ("soundControl")
  SC.loadSound( SC.MENU_SELECTED )
  SC.loadSound( SC.DANGERGO )
  SC.loadSound( SC.DANGERSOUND )
  SC.loadSound( SC.GAMEOVER )
  SC.loadSound( SC.TRANKSMUSIK )

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "storyboard" module
local storyboard = require "storyboard"

-- load menu screen
storyboard.gotoScene( "splash", "fade", 1000)