local composer = require( "composer" )
--local pinSelect = require ("pinSelect")
local scene = composer.newScene()
local widget = require "widget"     -- include Corona's "widget" library
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
display.setDefault( "background", .25 )
-- local forward references should go here
local titleText1, addBtn
scheduleString = " "
local contentWidth = display.contentWidth
local contentHeight = display.contentHeight
local verticalOffset = contentHeight * .1
local verticalOffsetNew = contentHeight * .25 
local verticalOffsetStart = verticalOffsetNew --this acts as the start point for events list
local events = {}
local allControlsGroup = display.newGroup()
path = system.pathForFile( "tasks.txt", system.DocumentsDirectory )
path2 = system.pathForFile( "taskList.txt", system.DocumentsDirectory )

function scene:overlayBegan( event )
   print( "The overlay scene is showing: " .. event.sceneName )
   print( "We get custom params too! " .. event.params.sample_var )
end

scene:addEventListener( "overlayBegan" )

local scrollView = widget.newScrollView
   {
      top = display.contentHeight * .1,
      left = 0,
      width = contentWidth,
      scrollWidth = contentWidth,
      -- height = contentHeight - 100,
      -- scrollHeight = contentHeight - 300,
      height = contentHeight - 400,
      scrollHeight = 0,
      listener = scrollListener,
      horizontalScrollDisabled = true,
      -- hideBackground = true
      backgroundColor = { 1, 1, 1 }
      -- isBounceEnabled = false
   }
   scrollView:insert( allControlsGroup )
   sceneGroup:insert(scrollView)


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
end


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
end
---------------------------------------------------------------------------------
local function networkListener( event )

    if ( event.isError ) then
        print( "Network error!" )
    else
        print ( "RESPONSE: " .. event.response )
    end
end



local function onAddBtn()
   --titleText1.text = titleText1.text .. "1"
   -- composer.gotoScene( "selectPin", {effect="fade", time=200})

      -- composer.gotoScene( "addSchedule", {effect="fade", time=200})

   local options =
   {
   effect = "fade",
   time = 400,
   isModal = true,
   params = {
            }
   }
   composer.showOverlay( "addSchedule", options )

   return true -- indicates successful touch
end

local function onClrBtn()
   local file = io.open( path, "w" )
   file:write( "" )
   io.close( file )
   local file = io.open( path2, "w" )
   file:write( "" )
   io.close( file )
   refreshScreen()
   --composer.removeScene("schedule")
end

local function onPushBtn()
   titleText1.text = "Event pushed to server"
   local params = {}
   local body = "pass=abcd4321"

   local file = io.open( path, "r" )     
   i = 1
   for line in file:lines() do
      body = body .. "&pin" .. i .. "=" .. line:sub(1, 1)
      body = body .. "&state" .. i .. "=" .. line:sub(2, 2)
      body = body .. "&day" .. i .. "=" .. line:sub(3, 5)
      body = body .. "&hour" .. i .. "=" .. line:sub(6, 7)
      body = body .. "&min" .. i .. "=" .. line:sub(8, 9)
      print( line )
      i = i + 1
   end
   i = 0
   io.close(file)
   print(body)    
   --params.body = body
   --network.request( "http://cpsc.xthon.com/setSchedule.php", "POST", networkListener, params )
   print("PUSH")
end

function refreshScreen()
   titleText1.text = "Most Recent Event"
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
   local file = io.open( path2, "r" )     
   i = 1
   for line in file:lines() do
      --if i % 4 == 0 then
      events[i] = display.newText( line, contentWidth * .5, verticalOffsetNew-200, native.systemFont ,contentHeight * .045)
      -- sceneGroup:insert(events[i])
      events[i]:setTextColor( 0,0,0 )
      allControlsGroup:insert(events[i])

      print( line )
      verticalOffsetNew = verticalOffsetNew + verticalOffset 
      i = i + 1
   end
      io.close(file)  
end


-- "scene:create()"
function scene:create( event )
   sceneGroup = self.view  

   titleText1 = display.newText( scheduleString, contentWidth * .5, contentHeight*.1, native.systemFont ,contentHeight * .045)
   sceneGroup:insert(titleText1)

   scrollView:insert( allControlsGroup )
   sceneGroup:insert(scrollView)




   addBtn = widget.newButton{
      label="Add",
      fontSize = display.contentWidth * .05,
      labelColor = { default={255}, over={128} },
      defaultFile="imgs/button.png",
      overFile="imgs/button_over.png",
      width=display.contentWidth / 3, 
      height=display.contentHeight * .1,
      onRelease = onAddBtn
   }
   addBtn.anchorX = 0
   addBtn.anchorY = 0
   addBtn.x = 0
   addBtn.y = 0
   sceneGroup:insert(addBtn)

   clrBtn = widget.newButton{
      label="Clear",
      fontSize = display.contentWidth * .05,
      labelColor = { default={255}, over={128} },
      defaultFile="imgs/button.png",
      overFile="imgs/button_over.png",
      width=display.contentWidth / 3, 
      height=display.contentHeight * .1,
      onRelease = onClrBtn
   }
   clrBtn.anchorX = 0
   clrBtn.anchorY = 0
   clrBtn.x = (display.contentWidth / 3) * 1
   clrBtn.y = 0
   sceneGroup:insert(clrBtn)
   
   pushBtn = widget.newButton{
      label="Push",
      fontSize = display.contentWidth * .05,
      labelColor = { default={255}, over={128} },
      defaultFile="imgs/button.png",
      overFile="imgs/button_over.png",
      width=display.contentWidth / 3, 
      height=display.contentHeight * .1,
      onRelease = onPushBtn
   }
   pushBtn.anchorX = 0
   pushBtn.anchorY = 0
   pushBtn.x = (display.contentWidth / 3) * 2
   pushBtn.y = 0
   sceneGroup:insert(pushBtn)

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
      refreshScreen()
      allControlsGroup.isVisible = true
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
   -- local allControlsGroup.isVisible = false
   local phase = event.phase

   if ( phase == "will" ) then
         titleText1.isVisible = false
         addBtn.isVisible = false
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