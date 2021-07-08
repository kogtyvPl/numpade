
-- Import libraries
local GUI = require("GUI")
local system = require("System")
local fs = require("Filesystem")

---------------------------------------------------------------------------------

-- Add a new window to MineOS workspace
local workspace, window, menu = system.addWindow(GUI.filledWindow(1, 1, 80, 30, 0xE1E1E1))

-- Get localization table dependent of current system language
--local localization = system.getCurrentScriptLocalization()



-- Add single cell layout to window
local layout = window:addChild(GUI.layout(1, 1, window.width, window.height, 1, 1))

-- Add nice gray text object to layout
layout:addChild(GUI.text(1, 1, 0x4B4B4B, "Привет, напиши свой текст, " .. system.getUser()))

local function addButton(text)
return layout:addChild(GUI.roundedButton(1, 1, 36, 3, 0xD2D2D2, 0x696969, 0x4B4B4B, 0xF0F0F0, text))
end

local namefile = layout:addChild(GUI.input(15, 21, 30, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "/numpad/MyText.txt", "Напишите сюда путь сохранения файла"))
  --if #namefile.text > 0 then
  --  GUI.alert("Установлен путь!")
  --end

local lable = layout:addChild(GUI.input(15, 15, 30, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "", "Напишите сюда текст"))
addButton("Записать изменения.txt").onTouch = function()
  if #lable.text > 0 then
    GUI.alert(lable.text, " - этот текст был сохранён в файл Mytext.txt")
    fs.append(namefile.text, lable.text)
  else
    GUI.alert("Пустая строка.")
  end
end


--layout:addChild(GUI.input(37, 16, 75, 3, 0xFFFFFF, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "", "Напишите сюда текст")).onInputFinished = function()
--  GUI.alert("Текст написан!")
--end

-- Customize MineOS menu for this application by your will
local contextMenu = menu:addContextMenuItem("File")
contextMenu:addItem("New")
contextMenu:addSeparator()
contextMenu:addItem("Open")
contextMenu:addItem("Save", true)
contextMenu:addItem("Save as")
contextMenu:addSeparator()
contextMenu:addItem("Close").onTouch = function()
  window:remove()
end

-- You can also add items without context menu
menu:addItem("Чем тут пахнет?").onTouch = function()
  GUI.alert("привет епта!")
end

-- Create callback function with resizing rules when window changes its' size
window.onResize = function(newWidth, newHeight)
  window.backgroundPanel.width, window.backgroundPanel.height = newWidth, newHeight
  layout.width, layout.height = newWidth, newHeight
end

---------------------------------------------------------------------------------

-- Draw changes on screen after customizing your window
workspace:draw()
