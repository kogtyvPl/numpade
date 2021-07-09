
-- Import libraries
local GUI = require("GUI")
local system = require("System")
local fs = require("Filesystem")

local textzg = ""
---------------------------------------------------------------------------------

-- Add a new window to MineOS workspace
local workspace, window, menu = system.addWindow(GUI.filledWindow(1, 1, 80, 30, 0xE1E1E1))

-- Get localization table dependent of current system language
--local localization = system.getCurrentScriptLocalization() (залупа закоментированая)



-- Add single cell layout to window
local layout = window:addChild(GUI.layout(1, 1, window.width, window.height, 1, 1))

-- Add nice gray text object to layout
layout:addChild(GUI.text(1, 1, 0x4B4B4B, "Привет, напиши свой текст, " .. system.getUser()))

local function addButton(text)
return layout:addChild(GUI.roundedButton(1, 1, 36, 3, 0xD2D2D2, 0x696969, 0x4B4B4B, 0xF0F0F0, text))
end

--local kvadrato = layout:addChild(GUI.panel(15, 21, 30, 3, 0x262626))

--local namefile = layout:addChild(GUI.filesystemChooser(2, 2, 30, 3, 0xE1E1E1, 0x888888, 0x3C3C3C, 0x888888, nil, "Open", "Cancel", "Choose", "/"))
--namefile:setMode(GUI.IO_MODE_SAVE, GUI.IO_MODE_FILE)
--namefile.onSubmit = function(path)
--  GUI.alert("Файл \"" .. path .. "\" выбран")
--end

local namefile = layout:addChild(GUI.input(15, 21, 30, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "/numpad/MyText.txt", "Напишите сюда путь сохранения файла"))
  --if #namefile.text > 0 then
  --  GUI.alert("Установлен путь!")
  --end

local lable = layout:addChild(GUI.input(15, 15, 30, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, textzg, "Напишите сюда текст"))
addButton("Записать изменения.txt").onTouch = function()
  if #lable.text > 0 then
    GUI.alert(lable.text, " - этот текст был сохранён в файл")
    fs.write(namefile.text, lable.text)
  else
    GUI.alert("Пустая строка.")
  end
end
addButton("Загрузить файл.txt").onTouch = function()
  local textzg = fs.read(namefile.text)
  local textread = layout:addChild(GUI.text(1, 1, 0x4B4B4B, textzg))
end


--layout:addChild(GUI.input(37, 16, 75, 3, 0xFFFFFF, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "", "Напишите сюда текст")).onInputFinished = function()
--  GUI.alert("Текст написан!")
--end

-- Customize MineOS menu for this application by your will
local contextMenu = menu:addContextMenuItem("File")
contextMenu:addItem("Новый")
contextMenu:addSeparator()
contextMenu:addItem("Сохранить как")
contextMenu:addItem("Save", true)
contextMenu:addItem("Открыть").onTouch = function()
  local filesystemDialog = GUI.addFilesystemDialog(workspace, false, 50, math.floor(workspace.height * 0.8), "Open", "Cancel", "File name", "/")
  filesystemDialog:setMode(GUI.IO_MODE_OPEN, GUI.IO_MODE_FILE)
  filesystemDialog:addExtensionFilter(".txt")
  filesystemDialog.onSubmit = function(path)
    GUI.alert("This path was selected: " .. path)
  end
  
  
  filesystemDialog:show()
end
contextMenu:addSeparator()
contextMenu:addItem("Закрыть").onTouch = function()
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
