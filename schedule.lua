local composer = require( "composer" )
--local pinSelect = require ("pinSelect")
local scene = composer.newScene()
local widget = require "widget"		-- include Corona's "widget" library
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
display.setDefault( "background", .25 )
-- local forward references should go here
local titleText1, addBtn
scheduleString = "testString"
local contentWidth = display.contentWidth
local contentHeight = display.contentHeight
local verticalOffset = contentHeight * .15
local verticalOffsetNew = contentHeight * .25 
local verticalOffsetStart = verticalOffsetNew --this acts as the start point for events list
local events = {}

path = system.pathForFile( "tasks.txt", system.DocumentsDirectory )

---------------------------------------------------------------------------------

local function onAddBtn()
   --titleText1.text = titleText1.text .. "1"
   composer.gotoScene( "pinSelect", {effect="fade", time=200})
   return true -- indicates successful touch
end

local function onClrBtn()
   local file = io.open( path, "w" )
   file:write( "clear" )
   io.close( file )
   --composer.removeScene("schedule")
end

-- "scene:create()"
function scene:create( event )
   sceneGroup = self.view	

	titleText1 = display.newText( scheduleString, contentWidth * .5, contentHeight*.1, native.systemFont ,contentHeight * .065)
	sceneGroup:insert(titleText1)

   addBtn = widget.newButton{
      label="Add Event",
      fontSize = display.contentWidth * .05,
      labelColor = { default={255}, over={128} },
      defaultFile="imgs/button.png",
      overFile="imgs/button_over.png",
      width=display.contentWidth * .50, height=display.contentHeight * .1,
      onRelease = onAddBtn
   }
   addBtn.anchorX = .5
   addBtn.anchorY = .5
   addBtn.x = display.contentWidth * .25
   addBtn.y = display.contentHeight * .8
   sceneGroup:insert(addBtn)

   clrBtn = widget.newButton{
      label="Clear Tasks",
      fontSize = display.contentWidth * .05,
      labelColor = { default={255}, over={128} },
      defaultFile="imgs/button.png",
      overFile="imgs/button_over.png",
      width=display.contentWidth * .50, height=display.contentHeight * .1,
      onRelease = onClrBtn
   }
   clrBtn.anchorX = .5
   clrBtn.anchorY = .5
   clrBtn.x = display.contentWidth * .75
   clrBtn.y = display.contentHeight * .8
   sceneGroup:insert(clrBtn)
   
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

-- "scene:show()"
function scene:show( event )
   local sceneGroup = self.view
   local phase = event.phase
   if ( phase == "will" ) then
		titleText1.isVisible = true
      addBtn.isVisible = true

      local i = 1 --loop control variable
      local j = #events
      print(j)
      if j > 0 then --check if there are any events to handle
         --there are events, remove them and prepare to re-draw them
         print("Handling events")
         while i <= j do
            events[i]:removeSelf()
            events[i] = nil
            i = i + 1 
         end
         verticalOffsetNew = verticalOffsetStart
      end
      --(re)populate events
      local file = io.open( path, "r" )     
      i = 1
      for line in file:lines() do
         events[i] = display.newText( line, contentWidth * .5, verticalOffsetNew, native.systemFont ,contentHeight * .045)
         sceneGroup:insert(events[i])
         print( line )
         verticalOffsetNew = verticalOffsetNew + verticalOffset
         i = i + 1
      end
      io.close(file)  
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      titleText1.text = scheduleString
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
         addBtn.isVisible = false
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
   addBtn:removeSelf()
   addBtn = nil

	
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