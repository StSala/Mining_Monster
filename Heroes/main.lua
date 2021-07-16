-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

--takes away the display bar at the top of the screen
display.setStatusBar(display.HiddenStatusBar)

math.randomseed( os.time() * os.time())

-- Go to the menu screen
composer.gotoScene( "menu" )


audio.reserveChannels( 1 )

audio.setVolume( 0.4, { channel=1 } )

