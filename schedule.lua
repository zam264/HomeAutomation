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
-- allControlsGroup.anchorX = 0
-- allControlsGroup.anchorY = 0
path = system.pathForFile( "tasks.txt", system.DocumentsDirectory )
path2 = system.pathForFile( "taskList.txt", system.DocumentsDirectory )


local function initInputOutput()
      local file = io.open( path, "w" )
      file:write( " " )
      io.close( file )
      file = nil

      local file = io.open( path2, "w" )
      file:write( " " )
      io.close( file )
      file = nil
end

local scrollView = widget.newScrollView
   {
      top = display.contentHeight * .1,
      left = 0,
      width = contentWidth,
      scrollWidth = contentWidth,
      height = contentHeight - (400),
      scrollHeight = 0,
      listener = scrollListener,
      horizontalScrollDisabled = true,
      backgroundColor = { 1, 1, 1 }
   }
   sceneGroup:insert(scrollView)


function string:split( inSplitPattern, outResults )

   if not outResults then
      outResults = { }
   end
   local theStart = 1
   local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   while theSplitStart do
      table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
      theStart = theSplitEnd + 1
      theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   end
   table.insert( outResults, string.sub( self, theStart ) )
   return outResults
end

local function loadScheduleFromFile()
   local file = io.open( path2, "r" )
   local parameters  = {
      lightsChosen = {},
      inOnChosen = false,
      daysChosen = {},
      hourChosen = -1,
      isAmChosen = false,
      minuteChosen = -1
   }
local lineString = file:read("*l")
   for line in file:lines() do
       lineString = file:read("*l")
      -- print( lineString )

      local theToken = lineString:split(",")
      for i = 1, #theToken do
         if(i == 1) then
            table.insert(parameters.lightsChosen, theToken)
         elseif( i == 2) then
            if(theToken == "true") then
               parameters.isOnChosen = true
            else if(theToken == false) then
               parameters.isOnChosen = false
            end
         elseif(i == 3) then
            table.insert(parameters.daysChosen, theToken)
         elseif(i ==4) then
            parameters.hourChosen = theToken
         elseif(i==5) then
            if(theToken == "true") then
               parameters.isAmChosen = true
            elseif(theToken == "false") then
               parameters.isAmChosen = false
         elseif(i == 6) then
            parameters.minuteChosen = theToken
         end
      end
   end

   io.close( file )
   file = nil

   table.insert(events, parameters)
end

local function showSchedule(schedule)
   allControlsGroup:removeSelf()
   allControlsGroup = display.newGroup()
   scrollView:insert( allControlsGroup )
   local buttonCounter = 0
   local numberSpecificEvents = table.maxn(events)
   for h = 1, numberSpecificEvents, 1 do
      local daysChosenTable = events[h].daysChosen
      local numberOfDays = table.maxn(daysChosenTable)
      for i = 1, numberOfDays, 1 do                --create the lights in a loop
         local lightsChosenTable = events[h].lightsChosen
         local numberOfLights = table.maxn(lightsChosenTable)
         -- print("IN LOOP")
         for j = 1, numberOfLights, 1 do
            local buttonNumber = i + j + h 
            local currentGroup = display.newGroup()
            buttonCounter = buttonCounter + 1
               currentGroup.width = contentWidth
               currentGroup.height = display.contentHeight * 0.1
               currentGroup.anchorX = 0
               currentGroup.anchorY = 0
               currentGroup.x = 0
               currentGroup.y = display.contentHeight * 0.1 * (buttonCounter - 1)
               

            local background = display.newImage( "imgs/on_off_background.png", 0, 0 )
               background.width = contentWidth
               background.height = display.contentHeight * 0.1
               background.anchorX = 0
               background.anchorY = 0
               background.x = 0
               background.y = display.contentHeight * 0.1 * (buttonCounter - 0)
               -- background.y = 0
            currentGroup:insert(background)

            local lightName = display.newText(lightsChosenTable[j], 0, 0, "Helvetica Neue Thin", background.height * 0.4)
               lightName:setTextColor( 0, 0, 0, 255 )
               -- lightName.anchorY = 0
               -- lightName.anchorX = 0
               lightName.x = (lightName.width / 2) + 40
               lightName.y = (display.contentHeight * 0.1 * (buttonCounter - 1)) + (display.contentHeight * 0.1 )
            currentGroup:insert(lightName)

            local dayName = display.newText(daysChosenTable[i], 0, 0, "Helvetica Neue Thin", background.height * 0.4)
               dayName:setTextColor( 0, 0, 0, 255 )
               -- lightName.anchorY = 0
               -- lightName.anchorX = 0
               dayName.x = ((dayName.width / 2) + 40)
               dayName.y = (display.contentHeight * 0.1 * (buttonCounter - 1)) + (display.contentHeight * 0.1 ) + lightName.height
            currentGroup:insert(dayName)

            local hourString
            if(tonumber(events[h].hourChosen) <= 9)then
               hourString = "0" .. events[h].hourChosen
            else
               hourString = events[h].hourChosen
            end
            
            local minuteString
            if(tonumber(events[h].minuteChosen) <= 9) then
               minuteString = "0" .. events[h].minuteChosen
            else
               minuteString = events[h].minuteChosen
            end
            local amPmString
            if(events[h].isAmChosen) then
               amPmString = "am"
            else
               amPmString = "pm"
            end
            local concatTime = hourString .. ":" .. minuteString .. amPmString
            local theTime = display.newText(concatTime, 0, 0, "Helvetica Neue Thin", background.height * 0.4)
               theTime:setTextColor( 0, 0, 0, 255 )
               -- lightName.anchorY = 0
               -- lightName.anchorX = 0
               theTime.x = (contentWidth - (theTime.width / 2))
               theTime.y = (display.contentHeight * 0.1 * (buttonCounter - 1)) + (display.contentHeight * 0.1 ) + lightName.height
            currentGroup:insert(theTime)






            local boolState = events[h].isOnChosen
            local stateString
            if(boolState) then
               stateString = "on"
            elseif(boolState == false) then
               stateString = "off"
            end
            local lightState = display.newText(stateString, 0, 0, "Helvetica Neue Thin", background.height * 0.4)
               lightState:setTextColor( 0, 0, 0, 255 )
               -- lightName.anchorY = 0
               -- lightName.anchorX = 0
               lightState.x = (contentWidth - (dayName.width / 2))
               lightState.y = (display.contentHeight * 0.1 * (buttonCounter - 1)) + (display.contentHeight * 0.1 )
            currentGroup:insert(lightState)


            -- currentGroup:insert(button)
            allControlsGroup:insert(currentGroup)
            -- initializeButtonStatus(currentGroup, button, i)
         end
      end
   end



end


local function writeSchedule(schedule)

   local parsedLights = {}
   local lightsTable = schedule.lightsChosen
      local numberLights = table.maxn(lightsTable)
      for i = 1, numberLights, 1 do
         local light = lightsTable[i]
         if(light == "Living Room") then
            parsedLights[i] = "1"
         elseif(light == "Kitchen") then
            parsedLights[i] = "2"
         elseif(light == "Mud-room") then
            parsedLights[i] = "3"
         elseif(light == "Bedroom") then
            parsedLights[i] = "4"
         elseif(light == "Fan") then
            parsedLights[i] = "5"
         end
      end

   

   local parsedOnOff
   local isOnChosen = schedule.isOnChosen
      if(isOnChosen) then
         parsedOnOff = "1"
      elseif(isOnChosen == false) then
         parsedOnOff = "0"
      end


   local parsedDays = {}
   local daysChosen = schedule.daysChosen
      local numberDays = table.maxn(daysChosen)
      for i = 1, numberDays, 1 do
         local longDayString = daysChosen[i]
         local shortDayString = longDayString:sub(1,3)
         parsedDays[i] = shortDayString
      end


   local parsedHour
   local hourChosen = schedule.hourChosen
      local theHour = schedule.hourChosen
      local isAmChosen = schedule.isAmChosen

      if(isAmChosen) then 
         if(theHour == 12) then
            parsedHour = "00"
         elseif(theHour <= 9) then
            parsedHour = "0" .. tostring( theHour )
         else
            parsedHour = tostring(theHour)
         end
      else
         if(theHour == 12) then
            parsedHour = tostring(theHour)
         else
            parsedHour = tostring(theHour + 12)
         end
      end




   local parsedMinute
   local minuteChosen = schedule.minuteChosen
   if(minuteChosen == 0) then
      parsedMinute = "00"
   else
      parsedMinute = tostring(minuteChosen)
   end

   local numberDays = table.maxn(parsedDays)
   local serverFormat = io.open( path, "a" )
   local localFormat = io.open( path2, "a" )
   for i = 1, numberDays, 1 do
      local numberLights = table.maxn(parsedLights)
      for j = 1, numberLights, 1 do
         local serverString = parsedLights[j] .. parsedOnOff .. parsedDays[i] .. parsedHour .. parsedMinute .. "\n"
         serverFormat:write( serverString)
         local localString = lightsTable[j] .. "," .. tostring(schedule.isOnChosen)  .. "," .. daysChosen[j] .. "," .. schedule.hourChosen .. "," .. tostring(schedule.isAmChosen) .. "," .. schedule.minuteChosen .. "\n"
         -- print(localString)
         
         -- localFormat:write(  )
      end
   end
   io.close( serverFormat )
   -- io.close( localFormat )
   serverFormat = nil
   localFormat = nil
end

function clearFile()
   initInputOutput()
   events = {}
end

function scene:captureChosenSchedule(schedule)
   table.insert( events, schedule ) 
   print(table.maxn(events))
   showSchedule(schedule)
   print("writing schedule")
   loadScheduleFromFile()
   writeSchedule(schedule)

end

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

   local options =
   {
   effect = "fade",
   time = 400,
   isModal = true,
   params = {
            lightsChosen = {},
            isOnChosen = false,
            daysChosen = {},
            hourChosen = -1,
            isAmChosen = false,
            minuteChosen = -1
            }
   }
   composer.showOverlay( "addSchedule", options )

   return true -- indicates successful touch
end

local function onClrBtn()
   -- local file = io.open( path, "w" )
   -- file:write( "" )
   -- io.close( file )
   -- local file = io.open( path2, "w" )
   -- file:write( "" )
   -- io.close( file )
   clearFile()
   allControlsGroup:removeSelf()
   allControlsGroup = display.newGroup()
   events = {}
   --composer.removeScene("schedule")
end

local function onPushBtn()
   titleText1.text = "Event pushed to server"
   local params = {}
   local userID = system.getInfo( "deviceID" )
   local body = "pass=abcd4321&userID=" .. userID
   local numLines = 0  
   local file = io.open( path, "r" )  
   i = 1
   local bodySchedule = ""
   for line in file:lines() do
      bodySchedule = bodySchedule .. "&pinOne" .. i .. "=" .. line:sub(1, 1)
      bodySchedule = bodySchedule .. "&pinTwo" .. i .. "=" .. line:sub(2, 2)
      bodySchedule = bodySchedule .. "&pinThree" .. i .. "=" .. line:sub(3, 3)
      bodySchedule = bodySchedule .. "&pinFour" .. i .. "=" .. line:sub(4, 4)
      bodySchedule = bodySchedule .. "&day" .. i .. "=" .. line:sub(5, 7)
      bodySchedule = bodySchedule .. "&hour" .. i .. "=" .. line:sub(8, 9)
      bodySchedule = bodySchedule .. "&min" .. i .. "=" .. line:sub(10, 11)
      print( line )
      i = i + 1
      numLines = numLines + 1
   end
   body = body .. "&numLines=" .. numLines 
   body = body .. "&hvacTemp=70&hvacAway=50&hvacRange=2"
   body = body .. bodySchedule
   i = 0
   numLines = 0
   io.close(file)
   print(body)    
   params.body = body
   network.request( "http://cpsc.xthon.com/writeSchedule.php", "POST", networkListener, params )
   print("PUSH")
end

-- "scene:create()"
function scene:create( event )
   sceneGroup = self.view  

   titleText1 = display.newText( scheduleString, contentWidth * .5, contentHeight*.1, native.systemFont ,contentHeight * .045)
   sceneGroup:insert(titleText1)

   scrollView:insert( allControlsGroup )
   sceneGroup:insert(scrollView)

   initInputOutput()


   addBtn = widget.newButton{
      label="+",
      fontSize = display.contentWidth * .08,
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
      label="-",
      fontSize = display.contentWidth * .08,
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
      label="↑",
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
      showSchedule()
      -- refreshScreen()
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