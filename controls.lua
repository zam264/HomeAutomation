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
local btnWidth = contentWidth * .45
local btnHeight = contentHeight * .08
local allControlsGroup = display.newGroup()
local lastPinResponse			--the last pin checked
local lastPin 					--true/false; did we get an actual response back
local pinCheckTimeout = 2000	--time to wait for pin response



local function onControlsBtn()
	composer.gotoScene( "controls", {effect="fade", time=200})

	return true	-- indicates successful touch
end
local function onScheduleBtn()
	composer.gotoScene( "schedule", {effect="fade", time=200})

	return true	-- indicates successful touch
end
local function onOptionsBtn()
	composer.gotoScene( "options", {effect="fade", time=200})

	return true	-- indicates successful touch
end





---------------------------------------------------------------------------------
local function getApplianceNameTextXCoordinate(theNameText)
	local positionAdjustment = 40
   return (theNameText.width / 2) + positionAdjustment
  end

  local function getApplianceNameTextHeight(theBackgroundOn)
  	local heightCoefficient = 0.45
  	return (theBackgroundOn.height * heightCoefficient)
  end

  local function getControlBackgroundXCoordinate()
  	return (contentWidth / 2)
  end

  local function getControlBackgroundHeight()
  	return (contentHeight / 8)
  end

  local function getControlGroupingYCoordinate(orderOnScreen)
  	return (100 + (getControlBackgroundHeight() * orderOnScreen))
  end

  local function getApplianceNameFont()
  	return "Helvetica Neue Thin"
  end

  local function getOnOffButtonHeight()
  	return (contentHeight + contentWidth) * 0.04
  end

  local function getOnOffButtonWidth()
  	-- return (contentHeight + contentWidth) * 0.05
  	return getOnOffButtonHeight()
  end

  local function getOnOffButtonXCoordinate()
  	return contentWidth * 0.75
  end

    local function getOnOffButtonYCoordinate()
  	return -50
  end

  local function getTabBarHeight()
  	return (contentHeight / 9) 
  end

 local function getTabBarLocation()
  	return (contentHeight / 9) * 8
  end


local function networkListener(event)
	-- native.setActivityIndicator( true )
	
	if(event.isError) then
		print("Network Error")
		return false
	else
		print("Response: " .. event.response)
		return true
	end
end

--listens for the pin status
-- local function networkListenerPinStatus(returnEvent)
local function networkListenerPinStatus(returnEvent, aGroup, aButton, pinNumber)
	if(returnEvent.isError) then
		print("Network Error")
		return false
	else
		print("Pin status (on/off): " .. returnEvent.response)
		lastPinResponse = tonumber(returnEvent.response)


		
		-- setButtonBasedOnPinStatus(aGroup, aButton, pinNumber, tonumber(returnEvent.response))			
		--want to get this working from this method so buttons are updated as soon as the server replies
		--will need to rearrange functions, etc. probably

		return true
	end
end

--toggles the specified pin
local function togglePin(pin)
	print("Pin: " .. pin .. " toggled")
	network.request("http://cpsc.xthon.com/togglePin.php?pinNum=" .. pin, "POST", networkListener)
	return true	-- indicates successful touch
end

--asks for the pin status
local function sendForPinStatus(aGroup, aButton, pinNumber)
	print("Getting pin status for\t" .. pinNumber)
	lastPin = pin
	local networkListener = function(returnEvent) return networkListenerPinStatus(returnEvent, aGroup, aButton, pinNumber) end 	--wrapper so parameters can be passed
	network.request("http://cpsc.xthon.com/getPin.php?pinNum=" .. pinNumber, "POST", networkListener)
end

--sets the button icon based on whether the pin is already on or off
local function setButtonBasedOnPinStatus(aGroup, aButton, pinNumber, result)
	print("Updating Button")
	aButton:removeSelf()
	-- if(lastPin == pinNumber) then
		local defaultFileLocation
		local overFileLocation

		if(lastPinResponse == 0) then
			defaultFileLocation = "imgs/pushButton.png"
			overFileLocation = "imgs/pushButton-over.png"
		else
			defaultFileLocation = "imgs/pushButtonOn.png"
			overFileLocation = "imgs/pushButton-overOn.png"
		end

		aButton = widget.newButton{
		defaultFile= defaultFileLocation,
		overFile= overFileLocation,
		width=getOnOffButtonWidth(),
		height=getOnOffButtonHeight(),
		onRelease = function()  
						togglePin(5) 
						sendForPinStatus(aGroup, aButton, 5)
						print("WAITING SECONDS")
						local pinStatusClosure = function() return setButtonBasedOnPinStatus(aGroup, aButton, pinNumber) end
							timer.performWithDelay(pinCheckTimeout, pinStatusClosure)
					end
		}

		aButton.anchorX = 0
		aButton.anchorY = 0
		aButton.x = getOnOffButtonXCoordinate()
		aButton.y = getOnOffButtonYCoordinate()

		aGroup:insert(aButton)
		allControlsGroup:insert(aGroup)
	-- end
end

--updates the icon/state of the button passed in
local function updateButtonState(aGroup, aButton, pinNumber)
	togglePin(pinNumber) 
	-- (aGroup, aButton, pinNumber)
	sendForPinStatus(aGroup, aButton, pinNumber)
	print("WAITING SECONDS")		--wait so many seconds for the server to respond
	local pinStatusClosure = function() return setButtonBasedOnPinStatus(aGroup, aButton, pinNumber) end
	timer.performWithDelay(pinCheckTimeout, pinStatusClosure)
end

function scene:create( event )

	sceneGroup = self.view	
	titleText1 = display.newText( "Controls", contentWidth * .5, contentHeight*.04, getApplianceNameFont() ,contentHeight * .065)
	sceneGroup:insert(titleText1)
	-- local allControlsGroup = display.newGroup()
   

	-- Create the widget
	local scrollView = widget.newScrollView
	{
		top = 0,
		left = 0,
		width = contentWidth,
		scrollWidth = contentWidth,
		height = contentHeight - 100,
		scrollHeight = contentHeight - 100,
		listener = scrollListener,
		horizontalScrollDisabled = true,
		-- isBounceEnabled = false
	}
	scrollView:insert( allControlsGroup )
	sceneGroup:insert(scrollView)

	
   	local lightGroupOne = display.newGroup()
	   	lightGroupOne.x = 0
	   	lightGroupOne.y = getControlGroupingYCoordinate(0)
	   	sceneGroup:insert(lightGroupOne)
	 	backgroundOne = display.newImage( "imgs/on_off_background.png", getControlBackgroundXCoordinate(), 0 )
	 	backgroundOne.width = contentWidth
	 	backgroundOne.height = getControlBackgroundHeight()
	 	lightGroupOne:insert( backgroundOne )

	 	local lightNameOne = display.newText( "Light 000", 0, 0, getApplianceNameFont(), getApplianceNameTextHeight(backgroundOne) )
	 	lightNameOne:setTextColor( 0, 0, 0, 255 )
	 	lightNameOne.x = getApplianceNameTextXCoordinate(lightNameOne)
	 	lightGroupOne:insert(lightNameOne)


		btn0 = widget.newButton{
			defaultFile="imgs/pushButton.png",
			overFile="imgs/pushButton-over.png",
			width=getOnOffButtonWidth(),
			height=getOnOffButtonHeight(),
			onRelease = function() return updateButtonState(lightGroupOne, btn0, 5) end
		}
		btn0.anchorX = 0
		btn0.anchorY = 0
		btn0.x = getOnOffButtonXCoordinate()
		btn0.y = getOnOffButtonYCoordinate()
		lightGroupOne:insert(btn0)
		allControlsGroup:insert(lightGroupOne)
		updateButtonState(lightGroupOne, btn0, 5) 
		--button state is initially off and this checks the server for actual state on screen load
		




   	local lightGroupTwo = display.newGroup()
	   	lightGroupTwo.x = 0
	   	lightGroupTwo.y = getControlGroupingYCoordinate(1)
	   	sceneGroup:insert(lightGroupTwo)
	 	backgroundTwo = display.newImage( "imgs/on_off_background.png", getControlBackgroundXCoordinate(), 0 )
	 	-- backgroundOne:scale( contentWidth, (0.1))
	 	backgroundTwo.width = contentWidth
	 	backgroundTwo.height = getControlBackgroundHeight()
	 	lightGroupTwo:insert( backgroundTwo )

	 	local lightNameTwo = display.newText( "Light 001", 0, 0, getApplianceNameFont(), getApplianceNameTextHeight(backgroundTwo) )
	 	lightNameTwo:setTextColor( 0, 0, 0, 255 )
	 	lightNameTwo.x = getApplianceNameTextXCoordinate(lightNameTwo)
	 	lightGroupTwo:insert(lightNameTwo)


		btn1 = widget.newButton{
			defaultFile="imgs/pushButton.png",
			overFile="imgs/pushButton-over.png",
			width=getOnOffButtonWidth(),
			height=getOnOffButtonHeight(),
			onRelease = function() return updateButtonState(lightGroupTwo, btn1, 5) end
			
		}
		btn1.anchorX = 0
		btn1.anchorY = 0
		btn1.x = getOnOffButtonXCoordinate()
		btn1.y = getOnOffButtonYCoordinate()
	lightGroupTwo:insert(btn1)
	allControlsGroup:insert(lightGroupTwo)
	updateButtonState(lightGroupTwo, btn1, 5)
	--button state is initially off and this checks the server for actual state on screen load




	local lightGroupThree = display.newGroup()
	   	lightGroupThree.x = 0
	   	lightGroupThree.y = getControlGroupingYCoordinate(2)
	   	sceneGroup:insert(lightGroupThree)
	 	backgroundThree = display.newImage( "imgs/on_off_background.png", getControlBackgroundXCoordinate(), 0 )
	 	-- backgroundOne:scale( contentWidth, (0.1))
	 	backgroundThree.width = contentWidth
	 	backgroundThree.height = getControlBackgroundHeight()
	 	lightGroupThree:insert( backgroundThree )

	 	local lightNameThree = display.newText( "Light 010", 0, 0, getApplianceNameFont(), getApplianceNameTextHeight(backgroundThree) )
	 	lightNameThree:setTextColor( 0, 0, 0, 255 )
	 	lightNameThree.x = getApplianceNameTextXCoordinate(lightNameThree)
	 	lightGroupThree:insert(lightNameThree)


		btn2 = widget.newButton{
			-- label="Light 1",
			-- fontSize = contentWidth * .05,
			-- labelColor = { default={255}, over={128} },
			defaultFile="imgs/pushButton.png",
			overFile="imgs/pushButton-over.png",
			width=getOnOffButtonWidth(),
			height=getOnOffButtonHeight(),
			onRelease = function() return updateButtonState(lightGroupThree, btn2, 2) end
		}
		btn2.anchorX = 0
		btn2.anchorY = 0
		btn2.x = getOnOffButtonXCoordinate()
		btn2.y = getOnOffButtonYCoordinate()
	lightGroupThree:insert(btn2)
	allControlsGroup:insert(lightGroupThree)
	updateButtonState(lightGroupThree, btn2, 2)
	--button state is initially off and this checks the server for actual state on screen load




	
	local lightGroupFour = display.newGroup()
	   	lightGroupFour.x = 0
	   	lightGroupFour.y = getControlGroupingYCoordinate(3)
	   	sceneGroup:insert(lightGroupFour)
	 	backgroundFour = display.newImage( "imgs/on_off_background.png", getControlBackgroundXCoordinate(), 0 )
	 	-- backgroundOne:scale( contentWidth, (0.1))
	 	backgroundFour.width = contentWidth
	 	backgroundFour.height = getControlBackgroundHeight()
	 	lightGroupFour:insert( backgroundFour )

	 	local lightNameFour = display.newText( "Light 011", 0, 0, getApplianceNameFont(), getApplianceNameTextHeight(backgroundFour) )
	 	lightNameFour:setTextColor( 0, 0, 0, 255 )
	 	lightNameFour.x = getApplianceNameTextXCoordinate(lightNameFour)
	 	lightGroupFour:insert(lightNameFour)


		btn3 = widget.newButton{
			-- label="Light 1",
			-- fontSize = contentWidth * .05,
			-- labelColor = { default={255}, over={128} },
			defaultFile="imgs/pushButton.png",
			overFile="imgs/pushButton-over.png",
			width=getOnOffButtonWidth(),
			height=getOnOffButtonHeight(),
			onRelease = function() return updateButtonState(lightGroupFour, btn3, 3) end
		}
		btn3.anchorX = 0
		btn3.anchorY = 0
		btn3.x = getOnOffButtonXCoordinate()
		btn3.y = getOnOffButtonYCoordinate()
	lightGroupFour:insert(btn3)
	allControlsGroup:insert(lightGroupFour)
	updateButtonState(lightGroupFour, btn3, 3)
	--button state is initially off and this checks the server for actual state on screen load





	local lightGroupFive = display.newGroup()
	   	lightGroupFive.x = 0
	   	lightGroupFive.y = getControlGroupingYCoordinate(4)
	   	sceneGroup:insert(lightGroupFive)
	 	backgroundFive = display.newImage( "imgs/on_off_background.png", getControlBackgroundXCoordinate(), 0 )
	 	-- backgroundOne:scale( contentWidth, (0.1))
	 	backgroundFive.width = contentWidth
	 	backgroundFive.height = getControlBackgroundHeight()
	 	lightGroupFive:insert( backgroundFive )

	 	local lightNameFive = display.newText( "Cooling", 0, 0, getApplianceNameFont(), getApplianceNameTextHeight(backgroundFive) )
	 	lightNameFive:setTextColor( 0, 0, 0, 255 )
	 	lightNameFive.x = getApplianceNameTextXCoordinate(lightNameFive)
	 	lightGroupFive:insert(lightNameFive)


		btn4 = widget.newButton{
			defaultFile="imgs/pushButton.png",
			overFile="imgs/pushButton-over.png",
			width=getOnOffButtonWidth(),
			height=getOnOffButtonHeight(),
			onRelease = function() return updateButtonState(lightGroupFive, btn4, 4) end
		}
		btn4.anchorX = 0
		btn4.anchorY = 0
		btn4.x = getOnOffButtonXCoordinate()
		btn4.y = getOnOffButtonYCoordinate()
	lightGroupFive:insert(btn4)	
	allControlsGroup:insert(lightGroupFive)
	updateButtonState(lightGroupFive, btn4, 4)
	--button state is initially off and this checks the server for actual state on screen load



	local lightGroupSix = display.newGroup()
	   	lightGroupSix.x = 0
	   	lightGroupSix.y = getControlGroupingYCoordinate(5)
	   	sceneGroup:insert(lightGroupSix)
	 	backgroundSix = display.newImage( "imgs/on_off_background.png", getControlBackgroundXCoordinate(), 0 )
	 	-- backgroundOne:scale( contentWidth, (0.1))
	 	backgroundSix.width = contentWidth
	 	backgroundSix.height = getControlBackgroundHeight()
	 	lightGroupSix:insert( backgroundSix )

	 	local lightNameSix = display.newText( "Heating", 0, 0, getApplianceNameFont(), getApplianceNameTextHeight(backgroundSix) )
	 	lightNameSix:setTextColor( 0, 0, 0, 255 )
	 	lightNameSix.x = getApplianceNameTextXCoordinate(lightNameSix)
	 	lightGroupSix:insert(lightNameSix)


		btn5 = widget.newButton{
			defaultFile="imgs/pushButton.png",
			overFile="imgs/pushButton-over.png",
			width=getOnOffButtonWidth(),
			height=getOnOffButtonHeight(),
			onRelease = function() return updateButtonState(lightGroupSix, btn5, 15) end
		}
		btn5.anchorX = 0
		btn5.anchorY = 0
		btn5.x = getOnOffButtonXCoordinate()
		btn5.y = getOnOffButtonYCoordinate()
	lightGroupSix:insert(btn5)
	allControlsGroup:insert(lightGroupSix)
	updateButtonState(lightGroupSix, btn5, 15) 
	--button state is initially off and this checks the server for actual state on screen load







	local lightGroupSeven = display.newGroup()
	   	lightGroupSeven.x = 0
	   	lightGroupSeven.y = getControlGroupingYCoordinate(6)
	   	sceneGroup:insert(lightGroupSeven)
	 	backgroundSeven = display.newImage( "imgs/on_off_background.png", getControlBackgroundXCoordinate(), 0 )
	 	-- backgroundOne:scale( contentWidth, (0.1))
	 	backgroundSeven.width = contentWidth
	 	backgroundSeven.height = getControlBackgroundHeight()
	 	lightGroupSeven:insert( backgroundSeven )

	 	local lightNameSeven = display.newText( "Fan", 0, 0, getApplianceNameFont(), getApplianceNameTextHeight(backgroundSeven) )
	 	lightNameSeven:setTextColor( 0, 0, 0, 255 )
	 	lightNameSeven.x = getApplianceNameTextXCoordinate(lightNameSeven)
	 	lightGroupSeven:insert(lightNameSeven)


		btn6 = widget.newButton{
			-- label="Light 1",
			-- fontSize = contentWidth * .05,
			-- labelColor = { default={255}, over={128} },
			defaultFile="imgs/pushButton.png",
			overFile="imgs/pushButton-over.png",
			width=getOnOffButtonWidth(),
			height=getOnOffButtonHeight(),
			onRelease = function() return updateButtonState(lightGroupSeven, btn6, 16) end
		}
		btn6.anchorX = 0
		btn6.anchorY = 0
		btn6.x = getOnOffButtonXCoordinate()
		btn6.y = getOnOffButtonYCoordinate()
	lightGroupSeven:insert(btn6)
	allControlsGroup:insert(lightGroupSeven)	
	updateButtonState(lightGroupSeven, btn6, 16)
	--button state is initially off and this checks the server for actual state on screen load

	
local tabButtons = {
    {
        width = 100, 
        height = 100,
        defaultFile = "imgs/power_tabbar.png",
        overFile = "imgs/power_tabbar_over.png",
        --label = "Tab1",
        id = "tab1",
        --selected = true,
        size = 16,
        labelYOffset = -8,
        onPress = onControlsBtn--handleTabBarEvent
    },
    {
        width = 100, 
        height = 100,
        defaultFile = "imgs/scheduler_tabbar.png",
        overFile = "imgs/scheduler_tabbar_over.png",
        --label = "Tab2",
        id = "tab2",
        size = 16,
        labelYOffset = -8,
        onPress = onScheduleBtn--handleTabBarEvent
    },
    {
        width = 100, 
        height = 100,
        defaultFile = "imgs/settings_tabbar.png",
        overFile = "imgs/settings_tabbar_over.png",
        --label = "Tab3",
        id = "tab3",
        size = 16,
        labelYOffset = -8,
        onPress = onOptionsBtn
    }
}

-- Create the widget
local tabBar = widget.newTabBar
{
    left = 0,
    top = getTabBarLocation(),
    width = contentWidth,
    height = getTabBarHeight(),
    backgroundFile = "imgs/tabBarBackground.png",
    tabSelectedLeftFile = "imgs/tabBarBackground.png",
    tabSelectedRightFile = "imgs/tabBarBackground.png",
    tabSelectedMiddleFile = "imgs/tabBarBackground.png",
    tabSelectedFrameWidth = 40,
    tabSelectedFrameHeight = 120,
    buttons = tabButtons
}

tabBar:setSelected(1)

   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
   	allControlsGroup.isVisible = true
		-- titleText1.isVisible = true
		-- btn0.isVisible = true
		-- btn1.isVisible = true
		-- btn2.isVisible = true
		-- btn3.isVisible = true
		-- btn4.isVisible = true
		-- btn5.isVisible = true
		-- btn6.isVisible = true
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
   		allControlsGroup.isVisible = false
   		-- titleText1.isVisible = false
   		-- btn0.isVisible = false
		-- btn1.isVisible = false
		-- btn2.isVisible = false
		-- btn3.isVisible = false
		-- btn4.isVisible = false
		-- btn5.isVisible = false
		-- btn6.isVisible = false
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
   allControlsGroup:removeSelf()
   -- allControlsGroup = nil
	-- titleText1:removeSelf()
	-- titleText1 = nil
	-- btn0:removeSelf()
	-- btn0 = nil
	-- btn1:removeSelf()
	-- btn1 = nil
	-- btn2:removeSelf()
	-- btn2 = nil
	-- btn3:removeSelf()
	-- btn3 = nil
	-- btn4:removeSelf()
	-- btn4 = nil
	-- btn5:removeSelf()
	-- btn5 = nil
	-- btn6:removeSelf()
	-- btn6 = nil
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

-- 