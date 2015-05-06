local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"		-- include Corona's "widget" library
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
display.setDefault( "background", 1, 1, 1)
-- local forward references should go here
local titleText1, titleText2, controlsBtn, scheduleBtn, passwordField, ipField
local contentWidth = display.contentWidth
local contentHeight = display.contentHeight
local test = "testText"--debug

local path = system.pathForFile( "pass.txt", system.DocumentsDirectory )
local path2 = system.pathForFile( "ip.txt", system.DocumentsDirectory )
local temperatureSettingsFile = system.pathForFile("temp.txt", system.DocumentsDirectory)

local temperatureTable = {}


-- local pass
local sliderMinimumTemperature = 40
local sliderMaximumTemperatures = 100
local scrollView 
local sliderValueGroup = display.newGroup()
sceneGroup:insert(sliderValueGroup)

local function getScrollerHeight()
  return contentHeight * .911971831
end

local function calculatePercentToTemperature(percent, min, max)
  local maximumPercentage = 100
  local offset = min
  local multiplier = maximumPercentage / (max - offset)
  return math.floor(((percent) / multiplier) + offset)
end

local function calculateTemperatureToPercent(temperature, min, max)
  local maximumPercentage = 100
  local offset = min
  local multiplier = maximumPercentage / (max - offset)
  return math.floor(multiplier * (temperature - offset))
end



local function passwordFieldListener( event )
    if ( event.phase == "began" ) then
        -- user begins editing defaultField
        print( event.text )
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- do something with defaultField text
        print( event.target.text )

        local path = system.pathForFile( "pass.txt", system.DocumentsDirectory )
        local file = io.open( path, "w" )
        file:write( event.target.text )
        io.close( file )
        file = nil
        native.setKeyboardFocus( ipField )

        --network.request("http://cpsc.xthon.com/togglePin.php?pinNum=" .. pin, "POST", networkListener)
    elseif ( event.phase == "editing" ) then
        print( event.newCharacters )
        print( event.oldText )
        print( event.startPosition )
        print( event.text )
    end
end

local function ipFieldListener( event )
    if ( event.phase == "began" ) then
        -- user begins editing defaultField
        print( event.text )
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- do something with defaultField text
        print( event.target.text )
        local path = system.pathForFile( "ip.txt", system.DocumentsDirectory )
        local file = io.open( path, "w" )
        file:write( event.target.text )
        io.close( file )
        file = nil
        native.setKeyboardFocus( nil )
        --network.request("http://cpsc.xthon.com/togglePin.php?pinNum=" .. pin, "POST", networkListener)
    elseif ( event.phase == "editing" ) then
        print( event.newCharacters )
        print( event.oldText )
        print( event.startPosition )
        print( event.text )
    end
end

local function drawSliderTemperatures(sliderNumber)
  sliderValueGroup:removeSelf()
  sliderValueGroup = display.newGroup()

  local writeString = ""
  for i = 1, table.maxn(temperatureTable), 1 do
    local options = 
    {
        --parent = textGroup,
        text=temperatureTable[i],
        x = contentWidth*0.8,
        y = contentHeight * (0.45 + (0.15 * (i-1))),
        width = 128,     --required for multi-line and alignment
        font = native.systemFont,   
        fontSize = 40,
        align = "right",  --new alignment parameter
        anchorX = 0,
        anchorY = 0
    }
    local temperature = display.newText(options)
    temperature:setFillColor(.6,.6,.6)
    sliderValueGroup:insert(temperature)
    scrollView:insert(sliderValueGroup)
    writeString = writeString .. temperatureTable[i]
  end

    local file = io.open( temperatureSettingsFile, "w" )
    file:write( writeString )

    io.close( file )
    file = nil
end


local function sliderListener(event, min, max, sliderNumber)
  local percentValue = event.value
  local numericValue = calculatePercentToTemperature(percentValue, min, max)
  temperatureTable[sliderNumber] = numericValue
  -- local realValue = tostring(numericValue)
  -- sliderValueGroup:removeSelf()
  -- sliderValueGroup = display.newGroup()
    drawSliderTemperatures(sliderNumber)
end



---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
    scrollView = widget.newScrollView   --allows us to scroll
  {
    top = 0,
    left = 0,
    width = contentWidth,
    scrollWidth = contentWidth,
    height = getScrollerHeight(),
    scrollHeight = getScrollerHeight(),
    listener = scrollListener,
    horizontalScrollDisabled = true,
    hideBackground = true
    -- isBounceEnabled = false
  }



  sceneGroup = self.view


  local fhd = io.open( path )

  if fhd then
     print( "File exists" )
     fhd:close()
  else
      --fhd:close()
      print( "File does not exist!" )

      local file = io.open( path, "w" )
      file:write( "" )
      io.close( file )
      file = nil
  end
  local file = io.open( path, "r" )
  local password = file:read( "*a" )
  io.close( file )
  file = nil


  local fhd = io.open( path2 )
  if fhd then
     print( "File exists" )
     fhd:close()
  else
      --fhd:close()
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

  local fhd = io.open(temperatureSettingsFile)
  if fhd then
    print("Temperature file exists")
    fhd:close()
  else
    print("Temperature file does not exist!")
    local file = io.open(temperatureSettingsFile, "w")
    file:write("")
    io.close(file)
    file = nil
  end
  local file = io.open(temperatureSettingsFile, "r")
  local temperatures = file:read("*a")
  print("STRING LENGTH")
  print(string.len(temperatures))
  if(string.len(temperatures) == 5) then
    temperatureTable[1] = string.sub( temperatures, 1, 2 )
    temperatureTable[2] = string.sub( temperatures, 3, 4 )
    temperatureTable[3] = string.sub( temperatures, 5, 5 )
    io.close(file)
    file = nil
  else
    temperatureTable[1] = "65"
    temperatureTable[2] = "55"
    temperatureTable[3] = "2"
    local file = io.open( temperatureSettingsFile, "w" )
    file:write( temperatureTable[1] .. temperatureTable[2] .. temperatureTable[3] )
    io.close( file )
    file = nil
end

  local inputRectangle = display.newRect( 0, 0, (contentWidth), contentHeight * .35 )
  inputRectangle:setFillColor(63/255,44/255,81/255)
  inputRectangle.anchorX = 0
  inputRectangle.anchorY = 0
  scrollView:insert(inputRectangle)
  titleText1 = display.newText( "System Access", contentWidth * .5, contentHeight*.03, native.systemFont ,contentHeight * .03)
  titleText1:setTextColor(1,1,1)
  titleText1.anchorY = 0
    -- sceneGroup:insert(titleText1)
    -- sceneGroup:insert(titleText1)
    scrollView:insert(titleText1)

  -- titleText2 = display.newText( "IP Address", contentWidth * .5, contentHeight*.3, native.systemFont ,contentHeight * .065)
  -- titleText2:setTextColor(0,0,0)
    -- sceneGroup:insert(titleText2)
  -- scrollView:insert(titleText2)

  passwordField = native.newTextField( contentWidth*.1, contentHeight*.1, contentWidth*.75, contentHeight*.07 )
    passwordField.anchorX = 0
    passwordField.anchorY = 0
    passwordField.text = password
    passwordField:addEventListener( "userInput", passwordFieldListener )
    passwordField.placeholder = "password"
    -- sceneGroup:insert(passwordField)
    scrollView:insert(passwordField)

  ipField = native.newTextField( contentWidth*.1, contentHeight*.21, contentWidth*.75, contentHeight*.07 )
    ipField.anchorX = 0
    ipField.anchorY = 0
    ipField.text = ipAddress
    ipField.placeholder = "http://10.1.237.71"
    ipField:addEventListener( "userInput", ipFieldListener )
    -- sceneGroup:insert(ipField)
      scrollView:insert(ipField)


  -- scrollView:insert( allControlsGroup )
  sceneGroup:insert(scrollView)

  local sliderGroup = display.newGroup()
  scrollView:insert(sliderGroup)

  -- local theRectangle = display.newRect( 0, contentHeight * 0.6, contentWidth, contentHeight * .1 )
  -- theRectangle.anchorX = 0
  -- theRectangle.anchorY = 0
  -- sliderGroup:insert(theRectangle)
  local sliderOneText = display.newText( "At-Home Temperature", contentWidth * .1, contentHeight*.4, native.systemFont ,contentHeight * 0.03)
  sliderOneText:setTextColor(0,0,0)
  sliderOneText.anchorX = 0
  sliderOneText.anchorY = 0
    scrollView:insert(sliderOneText)
  local sliderOne = widget.newSlider{
    top = contentHeight * 0.45,
    left = contentWidth * 0.1,
    width = contentWidth * 0.6,
    orientation="horizontal",
    value = calculateTemperatureToPercent(tonumber(temperatureTable[1]), 40, 90),  -- Start slider at 10% (optional)
    listener = function(event) sliderListener(event, 40, 90, 1) end
  }
  sliderGroup:insert(sliderOne)
  -- temperatureTable[1] = "65"

  -- local textOne = native.newTextField( contentWidth*.5, contentHeight*.35, contentWidth*.75, contentHeight*.1 )



 local sliderTwoText = display.newText( "Away Temperature", contentWidth * .1, contentHeight*.55, native.systemFont ,contentHeight * 0.03)
  sliderTwoText:setTextColor(0,0,0)
  sliderTwoText.anchorX = 0
  sliderTwoText.anchorY = 0
    scrollView:insert(sliderTwoText)
  local sliderTwo = widget.newSlider{
    top = contentHeight * 0.6,
    left = contentWidth * 0.1,
    width = contentWidth * 0.6,
        orientation="horizontal",
    value =  calculateTemperatureToPercent(tonumber(temperatureTable[2]), 40, 90),  -- Start slider at 10% (optional)
    listener = function(event) sliderListener(event, 40, 90, 2) end
  }
  sliderGroup:insert(sliderTwo)
  -- temperatureTable[2] = "55"


 local sliderThreeText = display.newText( "Flucuation Delta", contentWidth * .1, contentHeight*.7, native.systemFont ,contentHeight * 0.03)
  sliderThreeText:setTextColor(0,0,0)
  sliderThreeText.anchorX = 0
  sliderThreeText.anchorY = 0
    scrollView:insert(sliderThreeText)
local sliderThree = widget.newSlider{
    top = contentHeight * 0.75,
    left = contentWidth * 0.1,
    width = contentWidth * 0.6,
        orientation="horizontal",
    value = calculateTemperatureToPercent(tonumber(temperatureTable[3]), 0, 9),  -- Start slider at 10% (optional)
    listener = function(event) sliderListener(event, 0, 9, 3) end
  }
  sliderGroup:insert(sliderThree)
  -- temperatureTable[3] = "2"

  drawSliderTemperatures()
   -- Initialize the scene here.	
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

-- "scene:show()"
function scene:show( event )
    display.setDefault( "background", 1, 1, 1 )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
  	-- titleText1.isVisible = true
    scrollView.isVisible = true
    passwordField.isVisible = true
    ipField.isVisible = true
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
   		-- titleText1.isVisible = false
      passwordField.isVisible = false
      ipField.isVisible = false
      scrollView.isVisible = false
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
	-- titleText1:removeSelf()
	-- titleText1 = nil
  scrollView:removeSelf()
  scrollView = nil
  passwordField:removeSelf()
  passwordField = nil
  ipField:removeSelf()
  ipField = nil
   if ( phase == "will" ) then
      titleText1.isVisible = false
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end
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