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

local function passwordFieldListener( event )
    if ( event.phase == "began" ) then
        -- user begins editing defaultField
        print( event.text )
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- do something with defaultField text
        print( event.target.text )
        titleText1.text = event.target.text--debug
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
        titleText2.text = event.target.text--debug
        --network.request("http://cpsc.xthon.com/togglePin.php?pinNum=" .. pin, "POST", networkListener)
    elseif ( event.phase == "editing" ) then
        print( event.newCharacters )
        print( event.oldText )
        print( event.startPosition )
        print( event.text )
    end
end

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
  sceneGroup = self.view	
  titleText1 = display.newText( "passField", contentWidth * .5, contentHeight*.1, native.systemFont ,contentHeight * .065)
  sceneGroup:insert(titleText1)
  titleText2 = display.newText( "ipField", contentWidth * .5, contentHeight*.2, native.systemFont ,contentHeight * .065)
  sceneGroup:insert(titleText2)
  passwordField = native.newTextField( contentWidth*.5, contentHeight*.35, contentWidth*.75, contentHeight*.1 )
  passwordField.text = "passwordField"
  passwordField:addEventListener( "userInput", passwordFieldListener )
  sceneGroup:insert(passwordField)
  ipField = native.newTextField( contentWidth*.5, contentHeight*.50, contentWidth*.75, contentHeight*.1 )
  ipField.text = "ipField"
  ipField:addEventListener( "userInput", ipFieldListener )
  sceneGroup:insert(ipField)
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
  passwordField.removeSelf()
  passwordField = nil
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