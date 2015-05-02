local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"		-- include Corona's "widget" library
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
display.setDefault( "background", .25 )
-- local forward references should go here
local titleText1, titleText2, controlsBtn, scheduleBtn, passwordField, ipField
local contentWidth = display.contentWidth
local contentHeight = display.contentHeight
local test = "testText"--debug

local sliderMinimumTemperature = 40
local sliderMaximumTemperatures = 100

local sliderValueGroup = display.newGroup()
sceneGroup:insert(sliderValueGroup)

local function calculatePercentToTemperature(percent)
  local maximumPercentage = 100
    local offset = sliderMinimumTemperature
  local multiplier = maximumPercentage / (sliderMaximumTemperatures - offset)
  return math.floor(((percent) / multiplier) + offset)
end

local function calculateTemperatureToPercent(temperature)
  local maximumPercentage = 100
    local offset = sliderMinimumTemperature
  local multiplier = maximumPercentage / (sliderMaximumTemperatures - offset)
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
        --network.request("http://cpsc.xthon.com/togglePin.php?pinNum=" .. pin, "POST", networkListener)
    elseif ( event.phase == "editing" ) then
        print( event.newCharacters )
        print( event.oldText )
        print( event.startPosition )
        print( event.text )
    end
end

local function sliderListener(event)
  local percentValue = event.value
  local realValue = tostring(calculatePercentToTemperature(percentValue))
  -- sliderValueGroup:removeSelf()
  -- sliderValueGroup = display.newGroup()

local options = 
{
    --parent = textGroup,
    text=realValue,
    x = 100,
    y = 600,
    width = 128,     --required for multi-line and alignment
    font = native.systemFontBold,   
    fontSize = 18,
    align = "right"  --new alignment parameter
}


  local temperature = display.newText(options)
  sliderValueGroup:removeSelf()
  sliderValueGroup = display.newGroup()
  sliderValueGroup:insert(temperature)

end
---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
    local scrollView = widget.newScrollView   --allows us to scroll
  {
    top = 0,
    left = 0,
    width = contentWidth,
    scrollWidth = contentWidth,
    height = contentHeight - 100,
    scrollHeight = contentHeight - 100,
    listener = scrollListener,
    horizontalScrollDisabled = true,
    hideBackground = true
    -- isBounceEnabled = false
  }


  sceneGroup = self.view

  local path = system.pathForFile( "pass.txt", system.DocumentsDirectory )
  local path2 = system.pathForFile( "ip.txt", system.DocumentsDirectory )
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

  titleText1 = display.newText( "Password", contentWidth * .5, contentHeight*.1, native.systemFont ,contentHeight * .065)
    -- sceneGroup:insert(titleText1)
    -- sceneGroup:insert(titleText1)
    scrollView:insert(titleText1)

  titleText2 = display.newText( "IP Address", contentWidth * .5, contentHeight*.35, native.systemFont ,contentHeight * .065)
    -- sceneGroup:insert(titleText2)
    scrollView:insert(titleText2)

  passwordField = native.newTextField( contentWidth*.5, contentHeight*.2, contentWidth*.75, contentHeight*.1 )
    passwordField.text = password
    passwordField:addEventListener( "userInput", passwordFieldListener )
    -- sceneGroup:insert(passwordField)
    scrollView:insert(passwordField)

  ipField = native.newTextField( contentWidth*.5, contentHeight*.45, contentWidth*.75, contentHeight*.1 )
    ipField.text = ipAddress
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
  local sliderOne = widget.newSlider{
    top = contentHeight * 0.65,
    left = 50,
    height = 400,
    orientation="vertical",
    value = calculateTemperatureToPercent(60),  -- Start slider at 10% (optional)
    listener = sliderListener
  }
  sliderGroup:insert(sliderOne)

  -- local textOne = native.newTextField( contentWidth*.5, contentHeight*.35, contentWidth*.75, contentHeight*.1 )



-- local theRectangle = display.newRect( 0, contentHeight * 0.7, contentWidth, contentHeight * .1 )
--   theRectangle.anchorX = 0
--   theRectangle.anchorY = 0
  -- sliderGroup:insert(theRectangle)
  local sliderTwo = widget.newSlider{
    top = contentHeight * 0.65,
    left = 150,
    height = 400,
        orientation="vertical",
    value =  calculateTemperatureToPercent(65),  -- Start slider at 10% (optional)
    listener = sliderListener
  }
  sliderGroup:insert(sliderTwo)


-- local theRectangle = display.newRect( 0, contentHeight * 0.8, contentWidth, contentHeight * .1 )
--   theRectangle.anchorX = 0
--   theRectangle.anchorY = 0
  -- sliderGroup:insert(theRectangle)
local sliderThree = widget.newSlider{
    top = contentHeight * 0.65,
    left = 250,
    height = 400,
        orientation="vertical",
    value = calculateTemperatureToPercent(70),  -- Start slider at 10% (optional)
    listener = sliderListener
  }
  sliderGroup:insert(sliderThree)
   -- Initialize the scene here.	
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

-- "scene:show()"
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
  	titleText1.isVisible = true
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
   		titleText1.isVisible = false
      passwordField.isVisible = false
      ipField.isVisible = false
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