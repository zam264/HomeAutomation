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

local DEFAULT_SCENE = 1

local function onControlsBtn()
	composer.gotoScene( "controls")

	return true	-- indicates successful touch
end
local function onScheduleBtn()
	composer.gotoScene( "schedule")

	return true	-- indicates successful touch
end
local function onOptionsBtn()
	composer.gotoScene( "options")

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

  function getTabBarHeight()
  	return (contentHeight / 9) 
  end

 local function getTabBarLocation()
  	return (contentHeight / 9) * 8
  end

local function getScrollerHeight()
	return contentHeight * .911971831
end

local function getTabIconDimension()
	return getTabBarHeight() * .792253521
end 


local function getTabbarSelectedFrameWidth()
	return contentWidth * .0625
end

local function getTabbarSelectedFrameHeight()
	return contentHeight * .105633803
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


---------------------------------------------NETWORK REQUEST STUFF (STARTS AT BOTTOM OF THIS BREAK) --------------------------------------------------------------


--4. verifies the current status
-- next layer in the stack
-- NEEDS SOME WORK ON THE VERIFICATION END OF THINGS<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
-- checks to make sure the current pin status on the server matches what we asked for
-- (we don't assume an 'okay' from the server actually means okay)
-- NEEDS ERROR HANDLING IF THIS FAILS
-- then sets the button image based on the current pin state (shows a light bulb if power is currently
	-- on to the specified pin)
local function verifyPinStatusNetworkListener(listener, aGroup, aButton, pinNumber, assumedStatus, togglePin)
	local actualStatus = tonumber(listener.response)
	if(listener.isError) then
			print("Network Error")
			print(listener.response)
			return false
	else 

	-- else if(actualStatus == assumedStatus)  then
		-- print("Current status (on/off): " .. listener.response)
			-- print("5. Updating Button")
			aButton:removeSelf()
			-- if(lastPin == pinNumber) then
			local defaultFileLocation
			local overFileLocation
			-- print("6. Verifying status (actual,assumed) " .. actualStatus .. ',' .. assumedStatus)
			if(actualStatus == 0) then
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
				-- onRelease = function() return togglePins(lightGroupOne, btn0, 5) end

				onRelease = function() return togglePin(aGroup, aButton, pinNumber) end
			}

		aButton.anchorX = 0
		aButton.anchorY = 0
		aButton.x = getOnOffButtonXCoordinate()
		aButton.y = getOnOffButtonYCoordinate()

		aGroup:insert(aButton)

		allControlsGroup:insert(aGroup)
	-- else
	-- 	print("ERROR!!!! ASSUMED PIN STATUS DOES NOT MATCH ACTUAL STATUS")
	end
end








--3. sets the current status
-- next layer in the stack
-- this gets a pass/fail from the server
--based on the success of the pin state change
-- then makes a request to verify that the new
-- pin status we wanted is the current pin status
local function setPinStatusNetworkListener(listener, aGroup, aButton, pinNumber, newStatus, togglePin)
	if(listener.isError) then
		print("Network Error")
		print(listener.response)
		return false
	else
		-- print("Pin status changed to (on/off): " .. newStatus .. listener.response)
		-- lastPinResponse = tonumber(listener.response)
		-- print('4. Verifying pin# ' .. pinNumber)

		local assumedStatus = newStatus

		local body = "pass=" .. password .. "&pinNum=" .. pinNumber
		local params = {}
		params.body = body

		local networkListener = function(returnEvent) return verifyPinStatusNetworkListener(returnEvent, aGroup, aButton, pinNumber, assumedStatus, togglePin) end 	--wrapper so parameters can be passed
		network.request(ipAddress .. "/getPin.php", "POST", networkListener, params)
	return true
	end
end




--2. gets the current status
-- next layer in the stack
--this gets the current status of a pin
--then makes a request to set the pin to the
--opposite status (eg. if off, then on)
local function askPinStatusNetworkListener(listener, aGroup, aButton, pinNumber, togglePin)
	if(listener.isError) then
		print("Network Error")
		print(listener.response)
		return false
	else
		-- print("2. Current status " .. listener.response)
		local newStatus = tonumber(listener.response)
		if(newStatus == 1) then
			newStatus = 0
		else
			newStatus = 1
		end

		-- print("3. New status " .. newStatus)

		-- local body = "pass=abcd4321&pinNum=" .. pinNumber .. "&state=" .. newStatus
		local body = "pass=" .. password .. "&pinNum=" .. pinNumber .. "&state=" .. newStatus
		local params = {}
		params.body = body

		local networkListener = function(returnEvent) return setPinStatusNetworkListener(returnEvent, aGroup, aButton, pinNumber, newStatus, togglePin) end 	--wrapper so parameters can be passed
		-- network.request("http://cpsc.xthon.com/setPin.php?pass=abcd4321&pinNum=" .. pinNumber .. "&state" .. newStatus, "POST", networkListener)
		network.request(ipAddress .. "/setPin.php", "POST", networkListener, params)

		return true
	end
end




--1.0 starts here
--CALL THIS FUNCTION TO BEGIN PIN TOGGLE
--THIS FUNCTION INITIATES A STACK OF FUNCTIONS
--EACH CONTINUING FROM THE PREVIOUS SERVER RESULT
--MESSY BUT WORKS DUE TO asynchronous WEB REQUESTS
local function togglePin(aGroup, aButton, pinNumber)
	-- print('\n\n\n1. Toggling pin# ' .. pinNumber)
	
	-- local body = "pass=abcd4321&pinNum=" .. pinNumber
	local body = "pass=" .. password .. "&pinNum=" .. pinNumber
	local params = {}
	params.body = body

	local networkListener = function(returnEvent) return askPinStatusNetworkListener(returnEvent, aGroup, aButton, pinNumber, togglePin) end 	--wrapper so parameters can be passed
	network.request(ipAddress .. "/getPin.php", "POST", networkListener, params)
	-- network.request("http://cpsc.xthon.com/getPin.php?pass=abcd4321&pinNum=" .. pinNumber, "POST", networkListener)

end


--1.1 this is called to initialize all the buttons to
--the correct state on screen load
local function initializeButtonStatus(aGroup, aButton, pinNumber)
	-- print("0. Initializing button-pin state # " .. pinNumber)
	local body = "pass=abcd4321&pinNum=" .. pinNumber
	local params = {}
	params.body = body
	local assumedStatus = 0
	local networkListener = function(returnEvent) return verifyPinStatusNetworkListener(returnEvent, aGroup, aButton, pinNumber, assumedStatus, togglePin) end 	--wrapper so parameters can be passed
			network.request(ipAddress .. "/getPin.php", "POST", networkListener, params)
end

---------------------------------------------NETWORK REQUEST STUFF --------------------------------------------------------------


function scene:create( event )
	--get our ip and password variables set
   local path1 = system.pathForFile( "pass.txt", system.DocumentsDirectory )
   local path2 = system.pathForFile( "ip.txt", system.DocumentsDirectory )

   local fhd = io.open( path1 )
   if fhd then
      print( "File exists" )
      fhd:close()
   else
      print( "File does not exist!" )
      local file = io.open( path1, "w" )
      file:write( "" )
      io.close( file )
      file = nil
   end

   local file = io.open( path1, "r" )
    password = file:read( "*a" )
   io.close( file )
   file = nil

   local fhd = io.open( path2 )
   if fhd then
      print( "File exists" )
      fhd:close()
   else
      print( "File does not exist!" )
      local file = io.open( path2, "w" )
      file:write( "" )
      io.close( file )
      file = nil
   end

   local file = io.open( path2, "r" )
    ipAddress = file:read( "*a" )
   io.close( file )
   file = nil

	sceneGroup = self.view	
	titleText1 = display.newText( "Controls", contentWidth * .5, contentHeight*.04, getApplianceNameFont() ,contentHeight * .065)
	sceneGroup:insert(titleText1)
  	local lightGroupTable = {}			--holds each group of lights
	local lightNames = {				--name of lights; adding name here will add the light (pin number assumingly increments by one)
			"Living Room",
			"Kitchen",
			"Mud-room",
			"Bedroom"
		}

	local scrollView = widget.newScrollView		--allows us to scroll
	{
		top = 0,
		left = 0,
		width = contentWidth,
		scrollWidth = contentWidth,
		height = getScrollerHeight(),
		scrollHeight = getScrollerHeight(),
		listener = scrollListener,
		horizontalScrollDisabled = true,
		-- isBounceEnabled = false
	}
	scrollView:insert( allControlsGroup )
	sceneGroup:insert(scrollView)

	
	local numberLights = table.maxn(lightNames)		--get the number of lights in the table
	for i = 1, numberLights, 1 do 					--create the lights in a loop
		local currentGroup = lightGroupTable[i]
			currentGroup = display.newGroup()
			currentGroup.x = 0
			currentGroup.y = getControlGroupingYCoordinate(i-1)
		-- sceneGroup:insert(currentGroup)

		local background = display.newImage( "imgs/on_off_background.png", getControlBackgroundXCoordinate(), 0 )
			background.width = contentWidth
			background.height = getControlBackgroundHeight()
		currentGroup:insert(background)

		local lightName = display.newText( lightNames[i], 0, 0, getApplianceNameFont(), getApplianceNameTextHeight(background) )
			lightName:setTextColor( 0, 0, 0, 255 )
 			lightName.x = getApplianceNameTextXCoordinate(lightName)
 		currentGroup:insert(lightName)

 		button = widget.newButton{
			defaultFile="imgs/pushButton.png",
			overFile="imgs/pushButton-over.png",
			width=getOnOffButtonWidth(),
			height=getOnOffButtonHeight(),
			onRelease = function() return togglePin(currentGroup, button, i) end
		}
		button.anchorX = 0
		button.anchorY = 0
		button.x = getOnOffButtonXCoordinate()
		button.y = getOnOffButtonYCoordinate()

		currentGroup:insert(button)
		allControlsGroup:insert(currentGroup)
		initializeButtonStatus(currentGroup, button, i)
	end

	
	
local tabButtonActions = {
						onControlsBtn,
						onScheduleBtn,
						onOptionsBtn
						}

local tabButtonImages = {
						"imgs/power_tabbar.png",
						"imgs/power_tabbar_over.png",
						"imgs/scheduler_tabbar.png",
						"imgs/scheduler_tabbar_over.png",
						"imgs/settings_tabbar.png",
        				"imgs/settings_tabbar_over.png"
						}

local tabButtons = {}
local numberTabs = table.maxn(tabButtonActions)
local counterOffset = 1
for i = 1, numberTabs, 1 do
	local tableButton = {
			        width = getTabIconDimension(), 
			        height = getTabIconDimension(),
			        defaultFile = tabButtonImages[counterOffset],
			        overFile = tabButtonImages[counterOffset + 1],
			        --label = "Tab1",
			        id = "tab" .. i,
			        --selected = true,
			        size = 16,
			        labelYOffset = -8,
			        onPress = tabButtonActions[i]--handleTabBarEvent
				}
				counterOffset = counterOffset + 2

	table.insert(tabButtons, tableButton)
end



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
    tabSelectedFrameWidth = getTabbarSelectedFrameWidth(),
    tabSelectedFrameHeight = getTabbarSelectedFrameHeight(),
    buttons = tabButtons
}

tabBar:setSelected(DEFAULT_SCENE)

   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
   	allControlsGroup.isVisible = true
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