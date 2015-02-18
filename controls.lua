local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"		-- include Corona's "widget" library
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
display.setDefault( "background", .25 )
-- local forward references should go here

--Variables
local titleText1, btn1, backBtn
local contentWidth = display.contentWidth
local contentHeight = display.contentHeight

local function onBackBtn()
	composer.gotoScene( "menu", {effect="fromLeft", time=1000})

	return true	-- indicates successful touch
end

local function onbtn1()
	print("Testing TESTING")

	return true	-- indicates successful touch
end

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
    sceneGroup = self.view	
	
	titleText1 = display.newText( "Controls", contentWidth * .5, contentHeight*.1, "fonts/Rufscript010" ,contentHeight * .065)
	sceneGroup:insert(titleText1)
   
   -- Initialize the scene here.
	btn1 = widget.newButton{
		label="Button 1",
		fontSize = contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=contentWidth * .50, height=contentHeight * .1,
		onRelease = onbtn1
	}
	btn1.anchorX = .5
	btn1.anchorY = .5
	btn1.x = contentWidth * .50
	btn1.y = contentHeight * .25
	sceneGroup:insert(btn1)	

	backBtn = widget.newButton{
		label="Back",
		fontSize = contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=contentWidth * .50, height=contentHeight * .1,
		onRelease = onBackBtn
	}
	backBtn.anchorX = .5
	backBtn.anchorY = .5
	backBtn.x = contentWidth * .50
	backBtn.y = contentHeight * .85
	sceneGroup:insert(backBtn)	
	
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
		titleText1.isVisible = true
		backBtn.isVisible = true
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
   		titleText1.isVisible = false
		backBtn.isVisible = false
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

	titleText1:removeSelf()
	titleText1 = nil
	backBtn:removeSelf()
	backBtn = nil

	
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