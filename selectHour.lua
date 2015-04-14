local composer = require( "composer" )
local widget = require "widget"		-- include Corona's "widget" librarylocal composer = require( "composer" )
local scene = composer.newScene()
local schedule = require ("schedule")
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
local titleText
local rowWidth = 5
local contentWidth = display.contentWidth
local contentHeight = display.contentHeight
local horizontalOffset = contentWidth * (1 / (rowWidth + 1))
local verticalOffset = contentHeight * .15
local newVerticalOffset = contentHeight * .20 --This acts as the starting point for the rows
local btnWidth = contentWidth * .2
local btnHeight = contentWidth * .2
local optionBtns = {}
local options = {
	"00",
	"01",
	"02",
	"03",
	"04",
	"05",
	"06",
	"07",
	"08",
	"09",
	"10",
	"11",
	"12",
	"13",
	"14",
	"15",
	"16",
	"17",
	"18",
	"19",
	"20",
	"21",
	"22",
	"23"	
}

local function onOptionSelect(x)
   --titleText1.text = titleText1.text .. "1"
   scheduleString = scheduleString .. options[x] .. ":"
   local file = io.open( path, "a" )
   file:write( options[x] )
   io.close( file )
   composer.gotoScene( "selectMinute", {effect="fade", time=200}) 
   return true -- indicates successful touch
end
---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
	--composer.getScene("menu"):destroy()
	local sceneGroup = self.view
	titleText = display.newText( "Select hour for task", contentWidth * .5, contentHeight*.1, native.systemFont ,contentHeight * .05)	
	sceneGroup:insert(titleText)

	local i = 1
	while i <= #options do
		local x = i
		optionBtns[i] = widget.newButton{
			label=options[i],
			fontSize = display.contentWidth * .05,
			labelColor = { default={255}, over={128} },
			defaultFile="imgs/button.png",
			overFile="imgs/button_over.png",
			width=btnWidth, height=btnHeight,
			onRelease = function() return onOptionSelect(x) end
   		}
	    optionBtns[i].anchorX = .5
		optionBtns[i].anchorY = .5
		if (i % rowWidth == 0) then
			optionBtns[i].y = newVerticalOffset 
			optionBtns[i].x = horizontalOffset * rowWidth
			newVerticalOffset = newVerticalOffset + verticalOffset
		else
			optionBtns[i].y = newVerticalOffset
			optionBtns[i].x = horizontalOffset * (i % rowWidth)
		end
		sceneGroup:insert(optionBtns[i])

		i = i + 1
	end
	-- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
   end
end

-- "scene:hide()"
function scene:hide( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end
end

-- "scene:destroy()"
function scene:destroy( event )

   local sceneGroup = self.view

   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene