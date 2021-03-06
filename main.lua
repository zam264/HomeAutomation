-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "storyboard" module
local composer = require "composer"

-- load menu screen
local rect
holding = {}
inUse = {}

 
composer.gotoScene( "controls" )

--Codes the keys for back button functionality 
local function onKeyEvent(event)
	local phase = event.phase
    local keyName = event.keyName 
    
	if ( "back" == keyName and phase == "up" ) then
		--composer.gotoScene( storyboard.returnTo, "fade", 250 )
		return true	-- indicates successful touch
		
	else 
		return false ; 
	end
end

Runtime:addEventListener( "key", onKeyEvent )