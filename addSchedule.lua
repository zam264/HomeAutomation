local composer = require( "composer" )
local widget = require "widget"     -- include Corona's "widget" librarylocal composer = require( "composer" )
local scene = composer.newScene()
local schedule = require ("schedule")
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
function scene:overlayBegan( event )
   print("EVENT LISTENER PLS WERK")
   print( "The overlay scene is showing: " .. event.sceneName )
   print( "We get custom params too! " .. event.params.sample_var )
end

scene:addEventListener( "overlayBegan" )

local titleText
local contentWidth = display.contentWidth
local contentHeight = display.contentHeight
local horizontalOffset = contentWidth * .25
local verticalOffset = contentHeight * .2
local newVerticalOffset = contentHeight * .2
local btnWidth = 500
local btnHeight = contentWidth * .2
local controlButtonsGroup = display.newGroup()
-- display.setDefault( "background", 0, 0.371, 0.472 )

local lightsChoice 

local selections = {}


local background = display.newImageRect("imgs/button.png", contentWidth, contentHeight)
-- local background = display.newRect( 0, 0, contentWidth, contentHeight )
-- background:setFillColor( .24609375, .1953125, .35546875 )
background.anchorY = 0
background.anchorX = 0


local mainScroller = widget.newScrollView{
         top = contentHeight*0.1,
         left = 0,
         width = contentWidth,
         scrollWidth = contentWidth,
         height = contentHeight,
         scrollHeight = 0,
         listener = scrollListener,
         horizontalScrollDisabled = true,
         verticalScrollDisabled = false,
         backgroundColor = { 1, 1, 1 },
         -- hideBackground = true
      }

local lightButtons = {}
local lightNamesOptions = {
   "Living Room",
   "Kitchen",
   "Mud-room",
   "Bedroom",
   "Fan"
}

local stateButtons = {}
local stateOptions = {
   "On",
   "Off"
}

local dayButtons = {}
local dayOptions = {
   "Monday",
   "Tuesday",
   "Wednesday",
   "Thursday",
   "Friday",
   "Saturday",
   "Sunday"
}

local hourButtons = {}
local hourOptions = {}

local amPmButtons = {}
local amPmOptions = {
   "AM",
   "PM"
}

local minuteButtons = {}
local minuteOptions = {}




local allScrollers = {}
local scrollersText = {
   "light",
   "",
   "",
   "hour",
   "",
   "minute",
}



local buttonWidths = {
   500,
   contentWidth / 2,
   350,
   200,
   contentWidth / 2,
   200
}

local canSelectMultiple = {
   true,
   false,
   true,
   false,
   false,
   false
}


local allButtons = {
   lightButtons,
   stateButtons,
   dayButtons,
   hourButtons,
   amPmButtons,
   minuteButtons
}

local allOptions = {
   lightNamesOptions,
   stateOptions,
   dayOptions,
   hourOptions,
   amPmOptions,
   minuteOptions
}


local function createScrollers(mainScroller)
   local numberScrollers = table.maxn(scrollersText)
   for i = 1, numberScrollers, 1 do
      local topMultipler = ((0.11 * (i-1)))
      local options = {
          text = scrollersText[i],     
          x = 0,
          y = btnHeight / 2,
          font = native.systemFont,   
          fontSize = contentHeight * .04,
          align = "right"     
      }
      local scrollerDescription = display.newText(options)

      scrollerDescription.anchorX = scrollerDescription.width 
      scrollerDescription.x = -20
      scrollerDescription:setFillColor(0,0,0)

      allScrollers[i] = widget.newScrollView{
         top = contentHeight * topMultipler - (contentHeight * 0.06),
         left = 0,
         width = contentWidth,
         scrollWidth = contentWidth,
         height = btnHeight,
         scrollHeight = 0,
         listener = scrollListener,
         horizontalScrollDisabled = false,
         verticalScrollDisabled = true,
         backgroundColor = { 1, 1, 1 }
      }
      allScrollers[i].anchorX = 0.5
      allScrollers[i].anchorY = 0

      allScrollers[i]:insert(scrollerDescription)
      mainScroller:insert(allScrollers[i])
      -- sceneGroup:insert(allScrollers[i])
   end
end



local function updateLightsChosen(lightName)
   local lightsChoice = lightsChoice.lightsChoice
   if(lightsChoice[lightName] == false) then
      lightsChoice[lightName] = true
   else
      lightsChoice[lightName] = false
   end
end

local function updateOnOffChosen(isOff)
   local isOffChoice = lightsChoice.isOffChoice
   if(isOffChoice == true) then
      isOffChoice = false
   else
      isOffChoice = true
   end

end


local function updateDaysChosen(dayName)
   local daysChoice = lightsChoice.daysChoice
   if(daysChoice[dayName] == false) then
      daysChoice[dayName] = true
   else
      daysChoice[dayName] = false
   end
end

local function updateHourChosen(hour)
   local hourChoice = lightsChoice.daysChoice
   hourChoice = hour
end


local function updateAmPm(isAm)
   local isAm = lightsChoice.isAm
   if(isAm == true) then
      isAm = false
   else
      isAm = true
   end
end


local function updateMinute(minute)
   local minuteChoice = lightsChoice.minuteChoice
   minuteChoice = minute

end

local function createHoursAndMinutes(minuteChoices)
   local numberHours = 12
   for i = 1, numberHours, 1 do
      hourOptions[i] = i
   end

   for i = 1, minuteChoices, 1 do
      local minutesInHour = 60
      local minuteChoice = (minutesInHour / minuteChoices) * (i-1)
      minuteOptions[i] = minuteChoice
   end
end



local function createAllButtons(eventHandler)
   local numberSections = table.maxn(allScrollers)     --get the number of lights in the table

   for i = 1, numberSections, 1 do                --create the lights in a loop
      local currentScroller = allScrollers[i]
      local currentButtons = allButtons[i]
      local currentOptions = allOptions[i]
      
      local numberButtons = table.maxn(currentOptions)
      for j = 1, numberButtons, 1 do
         currentButtons[j] = widget.newButton{
            label = currentOptions[j],
            fontSize = display.contentWidth * .05,
            labelColor = { default={255}, over={128} },
            defaultFile="imgs/button.png",
            overFile="imgs/button_over.png",
            width=buttonWidths[i], 
            height=btnHeight,
            

            -- onEvent = function(event) return eventHandler(event, j, currentScroller) end

            onEvent = function(event) return eventHandler(event, currentButtons[j], currentScroller, currentButtons) end
            
         }

         currentButtons[j].anchorX = 0
         currentButtons[j].anchorY = 0
         currentButtons[j].x = buttonWidths[i] * (j - 1) * 1
         currentButtons[j].y = 0
         currentButtons[j].isButtonSelected = false
         currentButtons[j].buttonText = currentOptions[j]
         currentButtons[j].width = buttonWidths[i]
         currentButtons[j].canSelectMultiple = canSelectMultiple[i]
         currentScroller:insert(currentButtons[j])
      end

   end

end


local function onOptionSelect(x)
       
    
   --titleText1.text = titleText1.text .. "1"
   scheduleString = lightNamesOptions[x] .. " "
   local file = io.open( path, "a" )
   file:write( lightNamesOptions[x] )
   io.close( file )
   composer.gotoScene( "selectState", {effect="fade", time=200}) 
   return true -- indicates successful touch
end


local function updateSwitchButtonState(theButton, eventHandler, currentScroller, buttonsGroup)
   local defaultFileLocation
   local overFileLocation
   local newButtonSelectedState
   local theLabel 
   local xPosition 
   local buttonWidth 
   local canSelectMultiple

   -- if(theButton.canSelectMultiple == false) then
   --    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
   --    local numberButtons = table.maxn(buttonsGroup) 
   --    for i = 1, numberButtons, 1 do
   --       if(buttonsGroup[i].isButtonSelected == true) then
   --          print("LE BUTTON SELECTED")
   --          theLabel = buttonsGroup[i].buttonText
   --          xPosition = buttonsGroup[i].x
   --          canSelectMultiple = buttonsGroup[i].canSelectMultiple
   --          buttonWidth = buttonsGroup[i].width
   --          buttonsGroup[i]:removeSelf()
   --          buttonsGroup[i] = widget.newButton{
   --             label = theLabel,
   --             fontSize = display.contentWidth * .05,
   --             labelColor = { default={255}, over={128} },
   --             defaultFile="imgs/button.png",
   --             overFile="imgs/button_over.png",
   --             width=buttonWidth, 
   --             height=btnHeight,

   --             onEvent = function(event) return eventHandler(event, buttonsGroup[i], currentScroller) end,
   --          }
   --          buttonsGroup[i].anchorX = 0
   --          buttonsGroup[i].anchorY = 0
   --          buttonsGroup[i].x = xPosition
   --          buttonsGroup[i].buttonText = theLabel
   --          buttonsGroup[i].y = 0
   --          buttonsGroup[i].isButtonSelected = newButtonSelectedState
   --          buttonsGroup[i].canSelectMultiple = canSelectMultiple
   --          currentScroller:insert(buttonsGroup[i])
   --       end
   --    end
   -- end 

   if theButton.isButtonSelected == true then
      defaultFileLocation = "imgs/button.png"
      overFileLocation = "imgs/button_over.png"
      newButtonSelectedState = false
   elseif theButton.isButtonSelected == false then
      defaultFileLocation = "imgs/buttonChosen.png"
      overFileLocation = "imgs/buttonChosen_over.png"
      newButtonSelectedState = true
   end

   theLabel = theButton.buttonText
   xPosition = theButton.x
   canSelectMultiple = theButton.canSelectMultiple
   buttonWidth = theButton.width

   theButton:removeSelf()
   theButton = widget.newButton{
      label = theLabel,
      fontSize = display.contentWidth * .05,
      labelColor = { default={255}, over={128} },
      defaultFile=defaultFileLocation,
      overFile=overFileLocation,
      width=buttonWidth, 
      height=btnHeight,

      onEvent = function(event) return eventHandler(event, theButton, currentScroller) end,
   }

   theButton.anchorX = 0
   theButton.anchorY = 0
   theButton.x = xPosition
   theButton.buttonText = theLabel
   theButton.y = 0
   theButton.isButtonSelected = newButtonSelectedState
   theButton.canSelectMultiple = canSelectMultiple
   currentScroller:insert(theButton)

   -- table.insert(selections, theButton.buttonText = theButton.isButtonSelected)
end

-- The touch listener function for the button (created below)
local function handleButtonEvent(event, theButton, scroller, buttonsGroup)
-- lightsScroller:takeFocus( event )
    local phase = event.phase

    if ( phase == "moved" ) then
        local dy = math.abs( ( event.y - event.yStart ) )
        local dx = math.abs( ( event.x - event.xStart ) )
        -- If the touch on the button has moved more than 10 pixels,
        -- pass focus back to the scroll view so it can continue scrolling
        if ( dy > 5) then
            scroller:takeFocus( event )
        --  elseif (dx > 10)then
        --     mainScroller:takeFocus(event)
        end
        return true
    -- end
    elseif (phase == "ended") then
      updateSwitchButtonState(theButton, handleButtonEvent, scroller, buttonsGroup)
       -- onOptionSelect(x)
       return false
    end
end

local function createCancelDoneButtons(sceneGroup)
   local allControlsGroup = display.newGroup()

   local doneButton = widget.newButton{
      label = "done",
      fontSize = display.contentWidth * .05,
      labelColor = { default={255}, over={128} },
      defaultFile="imgs/buttonBottom.png",
      overFile="imgs/buttonBottom_over.png",
      width=contentWidth / 2, 
      height=(contentHeight/9) ,

      onEvent = function(event)
         -- composer.gotoScene( "schedule", {effect="fade", time=200})
         composer.hideOverlay("fade", 400)
       end
   }
   doneButton.anchorX = 0
   doneButton.anchorY = 0
   doneButton.x = contentWidth / 2
   doneButton.y = (contentHeight / 9) * 8


   local cancelButton = widget.newButton{
      label = "cancel",
      fontSize = display.contentWidth * .05,
      labelColor = { default={255}, over={128} },
      defaultFile="imgs/buttonBottom.png",
      overFile="imgs/buttonBottom_over.png",
      width=contentWidth/2, 
      height=(contentHeight/9) ,

      onEvent = function(event)
         -- composer.gotoScene( "schedule", {effect="fade", time=200})
         composer.hideOverlay("fade", 400)
       end
   }
   cancelButton.anchorX = 0
   cancelButton.anchorY = 0
   cancelButton.x = 0
   cancelButton.y = (contentHeight / 9) * 8

controlButtonsGroup:insert(doneButton)
controlButtonsGroup:insert(cancelButton)

   -- sceneGroup:insert(doneButton)
end


---------------------------------------------------------------------------------


function scene:enterScene( event )
   print("WE IN HERE NIGGA")
   local params = event.params

   print( params.var1 ) -- "custom data"
   print( params.sample_var ) -- 123
end



-- "scene:create()"
function scene:create( event )
   --composer.getScene("menu"):destroy()
   -- print(event.params.sample_var .. "\tPAREMS PLS")
   lightsChoice = event.params
   local sceneGroup = self.view
   sceneGroup:insert(background)
   titleText = display.newText( "Select options", contentWidth * .5, contentHeight*.05, native.systemFont ,contentHeight * 0.05)   
   sceneGroup:insert(titleText)


      sceneGroup:insert(mainScroller)

   createScrollers(mainScroller)
   createHoursAndMinutes(6)
   createAllButtons(handleButtonEvent)
   createCancelDoneButtons(sceneGroup)



end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase
   if ( phase == "will" ) then
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
      controlButtonsGroup.isVisible = false
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
   controlButtonsGroup:removeSelf()

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