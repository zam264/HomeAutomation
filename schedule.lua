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
temperatureSettingsFile = system.pathForFile("temp.txt", system.DocumentsDirectory)





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

local function getToolbarButtonWidth()
   return display.contentWidth / 3
end

local function getToolbarButtonHeight()
   return display.contentHeight * 0.1
end

local function getToolbarButtonXPosition(buttonNumber)
   return (display.contentWidth / 3) * buttonNumber
end

local function getButtonFontSize()
   return display.contentWidth * 0.08
end

local function getScrollerTop()
   return display.contentHeight * 0.1
end

local function getScrollerHeight()
   return display.contentHeight - getToolbarButtonHeight() - getTabBarHeight()
end

local function getScheduledEventYPosition(eventNumber)
   return display.contentHeight * 0.1 * (eventNumber - 1)
end

local function getScheduledEventHeight()
   return display.contentHeight * 0.1
end

local function getEventBackgroundHeight()
   return display.contentHeight * 0.1
end

local function getScheduledEventBackgroundYPosition(eventNumber)
   return display.contentHeight * 0.1 * (eventNumber - 0)
end

local function getLightNameXPosition(lightName)
   return (lightName.width / 2) + 40
end

local function getLightNameYPosition(eventNumber)
   return (display.contentHeight * 0.1 * (eventNumber - 1)) + (display.contentHeight * 0.1 )
end

local function getDayNameXPosition(dayName)
   return ((dayName.width / 2) + 40)
end

local function getDayNameYPosition(eventNumber, lightName)
   return (display.contentHeight * 0.1 * (eventNumber - 1)) + (display.contentHeight * 0.1 ) + lightName.height
end

local function getEventTextSize(background)
   return background.height * 0.4
end

local function getTimeXPosition(timeText)
   return (contentWidth - (timeText.width / 2))
end

local function getTimeYPosition(eventNumber, lightName)
   return (display.contentHeight * 0.1 * (eventNumber - 1)) + (display.contentHeight * 0.1 ) + lightName.height
end

local function getLightStateXPosition(dayName)
   return (contentWidth - (dayName.width / 2))
end

local function getLightStateYPosition(eventNumber)
   return (display.contentHeight * 0.1 * (eventNumber - 1)) + (display.contentHeight * 0.1 )
end


local scrollView = widget.newScrollView
   {
      top = getScrollerTop(),
      left = 0,
      width = contentWidth,
      scrollWidth = contentWidth,
      height = getScrollerHeight(),
      scrollHeight = getScrollerHeight(),
      listener = scrollListener,
      horizontalScrollDisabled = true,
      backgroundColor = { 1, 1, 1 }
   }
   sceneGroup:insert(scrollView)



local function loadScheduleFromFile()
   events = {}
   local file = io.open( path2, "r" )

   local lineString = file:read("*l")

   while(lineString ~= nil) do
         local parameters  = {
      lightsChosen = {},
      inOnChosen = false,
      daysChosen = {},
      hourChosen = -1,
      isAmChosen = false,
      minuteChosen = -1
   }

      local theToken = lineString:split(",")

      table.insert(parameters.lightsChosen, theToken[1])

      if(theToken[2] == "true") then
         parameters.isOnChosen = true
      elseif(theToken[2] == "false") then
         parameters.isOnChosen = false
      end

      table.insert(parameters.daysChosen, theToken[3])

      parameters.hourChosen = theToken[4]

      if(theToken[5] == "true") then
         parameters.isAmChosen = true
      elseif(theToken[5] == "false") then
         parameters.isAmChosen = false
      end

      parameters.minuteChosen = theToken[6]
      table.insert(events, parameters)

      lineString = file:read("*l")
end

   io.close( file )
   file = nil

   
end

local function showSchedule()
   loadScheduleFromFile()
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
               currentGroup.height = getScheduledEventHeight()
               currentGroup.anchorX = 0
               currentGroup.anchorY = 0
               currentGroup.x = 0
               currentGroup.y = getScheduledEventYPosition(buttonCounter)


            local background = display.newImage( "imgs/on_off_background.png", 0, 0 )
               background.width = contentWidth
               background.height = getEventBackgroundHeight()
               background.anchorX = 0
               background.anchorY = 0
               background.x = 0
               background.y = getScheduledEventBackgroundYPosition(buttonCounter)
               -- background.y = 0
            currentGroup:insert(background)

            local lightName = display.newText(lightsChosenTable[j], 0, 0, "Helvetica Neue Thin", getEventTextSize(background))
               lightName:setTextColor( 0, 0, 0, 255 )
               lightName.x = getLightNameXPosition(lightName)
               lightName.y = getLightNameYPosition(buttonCounter)
            currentGroup:insert(lightName)

            local dayName = display.newText(daysChosenTable[i], 0, 0, "Helvetica Neue Thin", getEventTextSize(background))
               dayName:setTextColor( 0, 0, 0, 255 )
               -- lightName.anchorY = 0
               -- lightName.anchorX = 0
               dayName.x = getDayNameXPosition(dayName)
               dayName.y = getDayNameYPosition(buttonCounter, lightName)
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
            local theTime = display.newText(concatTime, 0, 0, "Helvetica Neue Thin", getEventTextSize(background))
               theTime:setTextColor( 0, 0, 0, 255 )
               -- lightName.anchorY = 0
               -- lightName.anchorX = 0
               theTime.x = getTimeXPosition(theTime)
               theTime.y = getTimeYPosition(buttonCounter, lightName)
            currentGroup:insert(theTime)




            local boolState = events[h].isOnChosen
            local stateString
            if(boolState) then
               stateString = "on"
            elseif(boolState == false) then
               stateString = "off"
            end



            local lightState = display.newText(stateString, 0, 0, "Helvetica Neue Thin", getEventTextSize(background))
               lightState:setTextColor( 0, 0, 0, 255 )
               -- lightName.anchorY = 0
               -- lightName.anchorX = 0
               lightState.x = getLightStateXPosition(dayName)
               lightState.y = getLightStateYPosition(buttonCounter)
            currentGroup:insert(lightState)


            -- currentGroup:insert(button)
            allControlsGroup:insert(currentGroup)
            -- initializeButtonStatus(currentGroup, button, i)
         end
      end
   end



end


local function writeSchedule(schedule)

   local parsedLights = ""
   local parsedLightsTable = {   "0",
                                 "0",
                                 "0",
                                 "0",
                                 "0"
                           }
   local lightsTable = schedule.lightsChosen
      local numberLights = table.maxn(lightsTable)
      for i = 1, numberLights, 1 do
         local light = lightsTable[i]

         if(light == "Living Room") then
            parsedLightsTable[1] = "1"
         elseif(light == "Kitchen") then
            -- parsedLights[i] = "2"
            parsedLightsTable[2] = "1"
         elseif(light == "Mud-room") then
            -- parsedLights[i] = "3"
            parsedLightsTable[3] = "1"
         elseif(light == "Bedroom") then
            -- parsedLights[i] = "4"
            parsedLightsTable[4] = "1"
         elseif(light == "Fan") then
            -- parsedLights[i] = "5"
            parsedLightsTable[5] = "1"
         end
      end

   local numberLights = table.maxn(parsedLightsTable)
   for i = 1, numberLights, 1 do
      parsedLights = parsedLights .. parsedLightsTable[i]
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
      local numberLights = table.maxn(lightsTable)

      local serverString = parsedLights .. parsedOnOff .. parsedDays[i] .. parsedHour .. parsedMinute .. "\n"
      serverFormat:write( serverString)

      for j = 1, numberLights, 1 do
         local localString = lightsTable[j] .. "," .. tostring(schedule.isOnChosen)  .. "," .. daysChosen[i] .. "," .. schedule.hourChosen .. "," .. tostring(schedule.isAmChosen) .. "," .. schedule.minuteChosen .. "\n"
         localFormat:write (localString)
         print("WRITING OUR FILE")
         -- print(localString)
         
         -- localFormat:write(  )
      end
   end
   io.close( serverFormat )
   io.close( localFormat )
   serverFormat = nil
   localFormat = nil
end

function clearFile()

   local file = io.open( path, "w" )
   file:write( "" )
   io.close( file )


   local file = io.open( path2, "w" )
   file:write( "" )
   io.close( file )

   events = {}
end

function scene:captureChosenSchedule(schedule)
   -- table.insert( events, schedule ) 
   -- print(table.maxn(events))
   writeSchedule(schedule)
   -- loadScheduleFromFile()
   showSchedule()
   

end


local function initFiles()
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
      -- loadScheduleFromFile()
      showSchedule()
   else
      --fhd:close()
      print( "File does not exist!" )
      local file = io.open( path2, "w" )
      file:write( "" )
      io.close( file )
   end
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
   effect = "fromBottom",
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

   local body = "pass=" .. password .. "&userID=" .. userID
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

     local fhd = io.open(temperatureSettingsFile)
     if fhd then
       print("Temperature file exists")
       fhd:close()
     else
       print("Temperature file does not exist!")
       local tempsFile = io.open(temperatureSettingsFile, "w")
       tempsFile:write("")
       io.close(tempsFile)
       tempsFile = nil
     end
     local tempsFile = io.open(temperatureSettingsFile, "r")
     local temperatures = tempsFile:read("*a")
     print("STRING LENGTH")
     print(string.len(temperatures))
     local hvacTemp
     local hvacAway
     local hvacRange
     if(string.len(temperatures) == 5) then
       hvacTemp = string.sub( temperatures, 1, 2 )
       hvacAway = string.sub( temperatures, 3, 4 )
       hvacRange = string.sub( temperatures, 5, 5 )
       io.close(tempsFile)
       tempsFile = nil
     else
       hvacTemp  = "65"
       hvacAway = "55"
       hvacRange = "2"
   end


   body = body .. "&numLines=" .. numLines 
   -- body = body .. "&hvacTemp=70&hvacAway=50&hvacRange=2"
   body = body .. "&hvacTemp=" .. hvacTemp  .. "&hvacAway=" .. hvacAway .. "&hvacRange=" .. hvacRange
   body = body .. bodySchedule
   i = 0
   numLines = 0
   io.close(file)
   print(body)    
   params.body = body
   network.request( ipAddress .. "/writeSchedule.php", "POST", networkListener, params )
   print("PUSH")
end

-- "scene:create()"
function scene:create( event )
   sceneGroup = self.view  

   titleText1 = display.newText( scheduleString, contentWidth * .5, contentHeight*.1, native.systemFont ,contentHeight * .045)
   sceneGroup:insert(titleText1)

   scrollView:insert( allControlsGroup )
   sceneGroup:insert(scrollView)

   


local toolbarSymbols = {
   "+",
   "-",
   "↑"
}

local toolbarActions = {
                        onAddBtn,
                        onClrBtn,
                        onPushBtn
                     }

local toolbarButtons = {}

local numberButtons = table.maxn(toolbarSymbols)
for i = 1, numberButtons, 1 do
   tempButton = widget.newButton{
      label=toolbarSymbols[i],
      fontSize = getButtonFontSize(),
      labelColor = { default={255}, over={128} },
      defaultFile="imgs/button.png",
      overFile="imgs/button_over.png",
      width=getToolbarButtonWidth(), 
      height=getToolbarButtonHeight(),
      onRelease = toolbarActions[i]
   }
   tempButton.anchorX = 0
   tempButton.anchorY = 0
   tempButton.x = getToolbarButtonXPosition(i-1)
   tempButton.y = 0
   sceneGroup:insert(tempButton)
   table.insert(toolbarButtons, tempButton)

end

   initFiles()

end

-- "scene:show()"
function scene:show( event )
   local sceneGroup = self.view
   local phase = event.phase
   if ( phase == "will" ) then
      titleText1.isVisible = true
      -- addBtn.isVisible = true
      sceneGroup.isVisible = true
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
         -- addBtn.isVisible = false
         sceneGroup.isVisible = false
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