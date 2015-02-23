local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"		-- include Corona's "widget" library
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
display.setDefault( "background", .25 )
-- local forward references should go here
local titleText1, controlsBtn, scheduleBtn
local contentWidth = display.contentWidth
local contentHeight = display.contentHeight

local function onControlsBtn()
	composer.gotoScene( "controls", {effect="fromRight", time=1000})

	return true	-- indicates successful touch
end
local function onScheduleBtn()
	composer.gotoScene( "schedule", {effect="fromLeft", time=1000})

	return true	-- indicates successful touch
end


---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
    sceneGroup = self.view	
	
	titleText1 = display.newText( "Home Automation", contentWidth * .5, contentHeight*.1, native.systemFont ,contentHeight * .065)
	sceneGroup:insert(titleText1)
   
   -- Initialize the scene here.
	controlsBtn = widget.newButton{
		label="Controls",
		fontSize = contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=contentWidth * .50, height=contentHeight * .1,
		onRelease = onControlsBtn
	}
	controlsBtn.anchorX = .5
	controlsBtn.anchorY = .5
	controlsBtn.x = contentWidth * .50
	controlsBtn.y = contentHeight * .25
	sceneGroup:insert(controlsBtn)
	
	scheduleBtn = widget.newButton{
		label="Scheduling",
		fontSize = contentWidth * .05,
		labelColor = { default={255}, over={128} },
		defaultFile="imgs/button.png",
		overFile="imgs/button-over.png",
		width=contentWidth * .5, height=contentHeight * .1,
		onRelease = onScheduleBtn
	}
	scheduleBtn.anchorX = .5
	scheduleBtn.anchorY = .5
	scheduleBtn.x = contentWidth * .50
	scheduleBtn.y = contentHeight * .40
	sceneGroup:insert(scheduleBtn)
	
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.


































--  TAB/TOOLBAR -- IS NOT COMPLETE NEEDS MORE WORK *******************
local widget = require( "widget" )

-- Function to handle button events
local function handleTabBarEvent( event )
    print( event.target._id )  --reference to button's 'id' parameter
end

-- Configure the tab buttons to appear within the bar
local tabButtons = {
    {
        width = 100, 
        height = 100,
        defaultFile = "power_tabbar.png",
        overFile = "power_tabbar_over.png",
        label = "Tab1",
        id = "tab1",
        selected = true,
        size = 16,
        labelYOffset = -8,
        onPress = handleTabBarEvent
    },
    {
        width = 100, 
        height = 100,
        defaultFile = "scheduler_tabbar.png",
        overFile = "scheduler_tabbar_over.png",
        label = "Tab2",
        id = "tab2",
        size = 16,
        labelYOffset = -8,
        onPress = handleTabBarEvent
    },
    {
        width = 100, 
        height = 100,
        defaultFile = "settings_tabbar.png",
        overFile = "settings_tabbar_over.png",
        label = "Tab3",
        id = "tab3",
        size = 16,
        labelYOffset = -8,
        onPress = handleTabBarEvent
    }
}

-- Create the widget
local tabBar = widget.newTabBar
{
    left = 0,
    top = display.contentHeight-120,
    width = 580,
    height = 120,
    backgroundFile = "tabBarBackground.png",
    tabSelectedLeftFile = "tabBarBackground.png",
    tabSelectedRightFile = "tabBarBackground.png",
    tabSelectedMiddleFile = "tabBarBackground.png",
    tabSelectedFrameWidth = 40,
    tabSelectedFrameHeight = 120,
    buttons = tabButtons
}












































end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
		titleText1.isVisible = true
		controlsBtn.isVisible = true
		scheduleBtn.isVisible = true
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
		controlsBtn.isVisible = false
		scheduleBtn.isVisible = false
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
	controlsBtn:removeSelf()
	controlsBtn = nil
	scheduleBtn:removeSelf()
    scheduleBtn = nil
	
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