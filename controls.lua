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
local titleText1, btn0, btn1, backBtn
local contentWidth = display.contentWidth
local contentHeight = display.contentHeight

local function networkListener(event)
	if(event.isError) then
		print("Network Error")
	else
		print("Response: " .. event.response)
	end
end

local function onBackBtn()
	composer.gotoScene( "menu", {effect="fromLeft", time=1000})

	return true	-- indicates successful touch
end

local function togglePin(pin)
	print("Pin: " .. pin .. " toggled")
	network.request("http://cpsc.xthon.com/togglePin.php?pinNum=" .. pin, "POST", networkListener)
	return true	-- indicates successful touch
end


---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

	sceneGroup = self.view	
	titleText1 = display.newText( "Controls", contentWidth * .5, contentHeight*.1, native.systemFont ,contentHeight * .065)
	sceneGroup:insert(titleText1)
   
   -- Initialize the scene here.
	btn0 = widget.newButton{
		label="Light 1",
		fontSize = contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=contentWidth * .50, height=contentHeight * .1,
		onRelease = function() return togglePin(5) end
	}
	btn0.anchorX = .5
	btn0.anchorY = .5
	btn0.x = contentWidth * .50
	btn0.y = contentHeight * .20
	sceneGroup:insert(btn0)	

	btn1 = widget.newButton{
		label="Light 2",
		fontSize = contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=contentWidth * .50, height=contentHeight * .1,
		onRelease = function() return togglePin(1) end
	}
	btn1.anchorX = .5
	btn1.anchorY = .5
	btn1.x = contentWidth * .50
	btn1.y = contentHeight * .30
	sceneGroup:insert(btn1)	

	btn2 = widget.newButton{
		label="Light 3",
		fontSize = contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=contentWidth * .50, height=contentHeight * .1,
		onRelease = function() return togglePin(2) end
	}
	btn2.anchorX = .5
	btn2.anchorY = .5
	btn2.x = contentWidth * .50
	btn2.y = contentHeight * .40
	sceneGroup:insert(btn2)

	btn3 = widget.newButton{
		label="Light 4",
		fontSize = contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=contentWidth * .50, height=contentHeight * .1,
		onRelease = function() return togglePin(3) end
	}
	btn3.anchorX = .5
	btn3.anchorY = .5
	btn3.x = contentWidth * .50
	btn3.y = contentHeight * .50
	sceneGroup:insert(btn3)

	btn4 = widget.newButton{
		label="Cooling",
		fontSize = contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=contentWidth * .50, height=contentHeight * .1,
		onRelease = function() return togglePin(4) end
	}
	btn4.anchorX = .5
	btn4.anchorY = .5
	btn4.x = contentWidth * .50
	btn4.y = contentHeight * .60
	sceneGroup:insert(btn4)			

	btn5 = widget.newButton{
		label="Heating",
		fontSize = contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=contentWidth * .50, height=contentHeight * .1,
		onRelease = function() return togglePin(15) end
	}
	btn5.anchorX = .5
	btn5.anchorY = .5
	btn5.x = contentWidth * .50
	btn5.y = contentHeight * .70
	sceneGroup:insert(btn5)

	btn6 = widget.newButton{
		label="Fan",
		fontSize = contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=contentWidth * .50, height=contentHeight * .1,
		onRelease = function() return togglePin(16) end
	}
	btn6.anchorX = .5
	btn6.anchorY = .5
	btn6.x = contentWidth * .50
	btn6.y = contentHeight * .80
	sceneGroup:insert(btn6)		

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
	backBtn.x = contentWidth * .5
	backBtn.y = contentHeight * .90
	sceneGroup:insert(backBtn)	
	
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
		titleText1.isVisible = true
		btn0.isVisible = true
		btn1.isVisible = true
		btn2.isVisible = true
		btn3.isVisible = true
		btn4.isVisible = true
		btn5.isVisible = true
		btn6.isVisible = true
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
   		btn0.isVisible = false
		btn1.isVisible = false
		btn2.isVisible = false
		btn3.isVisible = false
		btn4.isVisible = false
		btn5.isVisible = false
		btn6.isVisible = false
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
	btn0:removeSelf()
	btn0 = nil
	btn1:removeSelf()
	btn1 = nil
	btn2:removeSelf()
	btn2 = nil
	btn3:removeSelf()
	btn3 = nil
	btn4:removeSelf()
	btn4 = nil
	btn5:removeSelf()
	btn5 = nil
	btn6:removeSelf()
	btn6 = nil
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