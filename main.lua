
-- Импорт библиотек и переменные
local GUI = require("GUI")
local system = require("System")
local fs = require("Filesystem")

local scrol = {}
local lines = {""}
local textzg = ""
local codeView = ""
local cvhei = 40
local cvwid = 48
---------------------------------------------------------------------------------

-- Add a new window to MineOS workspace
local workspace, window, menu = system.addWindow(GUI.filledWindow(1, 1, 60, 25, 0xE1E1E1))
local workspace2, window2 = system.addWindow(GUI.filledWindow(65, 1, 50, 45, 0xCC9280))
--local cont1 = GUI.container(1, 1, 30, 45)
-- Get localization table dependent of current system language
--local localization = system.getCurrentScriptLocalization() (залупа закоментированая)


-- Add single cell layout to window
local layout = window:addChild(GUI.layout(1, 12, 52, 30, 1, 1))
local textloy = window:addChild(GUI.layout(8, 2, 30, 4, 1, 1))
local inputloy = window:addChild(GUI.layout(21, 6, 30, 5, 1, 1))
local textinputl = window:addChild(GUI.layout(1, 6, 29, 5, 1, 1))
local buttonloy = window:addChild(GUI.layout(17, 11, 38, 14, 1, 1))
local textholst = window:addChild(GUI.layout(4, 15, 17, 6, 1, 1))
local layout2 = window2:addChild(GUI.layout(1, 1, window2.width, window2.height, 1, 1))

-- Add nice gray text object to layout
textloy:addChild(GUI.text(1, 1, 0x4B4B4B, "Привет, " .. system.getUser()))
textloy:addChild(GUI.text(1, 1, 0x4B4B4B, "Пиши свой текст "))

textinputl:addChild(GUI.text(1, 1, 0x4B4B4B, "Имя файла: "))
textinputl:addChild(GUI.text(1, 1, 0x4B4B4B, "Твой текст: "))

local function addButton2(text2)
return layout2:addChild(GUI.roundedButton(1, 1, 30, 1, 0xD2D2D2, 0x696969, 0x4B4B4B, 0xF0F0F0, text2))
end

local function addButton(text)
return buttonloy:addChild(GUI.roundedButton(1, 1, 30, 1, 0xD2D2D2, 0x696969, 0x4B4B4B, 0xF0F0F0, text))
end

local namefile = inputloy:addChild(GUI.input(15, 21, 30, 1, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "MyText.txt", "Имя файла"))

local codeView = layout2:addChild(GUI.codeView(2, 2, 0, 0, 1, 1, 1, scrol, {}, GUI.LUA_SYNTAX_PATTERNS, GUI.LUA_SYNTAX_COLOR_SCHEME, true, lines))

local lable = inputloy:addChild(GUI.input(15, 15, 30, 1, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, textzg, "Напишите сюда текст"))
addButton("Записать изменения.txt").onTouch = function()
  if #lable.text > 0 then
    --GUI.alert(lable.text, " - этот текст был сохранён в файл")
    fs.append("/notepad/" .. namefile.text, "\n" .. lable.text)
    codeView:remove()
    local codeView = layout2:addChild(GUI.codeView(2, 2, cvwid, cvhei, 1, 1, 1, scrol, {}, GUI.LUA_SYNTAX_PATTERNS, GUI.LUA_SYNTAX_COLOR_SCHEME, true, {}))
    local counter = 1
    for line in require("filesystem").lines("/notepad/" .. namefile.text) do
  -- Replace tab symbols to 2 whitespaces and Windows line endings to UNIX line endings
      line = line:gsub("\t", "  "):gsub("\r\n", "\n")
      codeView.maximumLineLength = math.max(codeView.maximumLineLength, unicode.len(line))
      table.insert(codeView.lines, line)

      counter = counter + 1
      if counter > codeView.height then
        break
      end
    end
  else
    GUI.alert("Пустая строка.")
  end
end
addButton("Загрузить файл.txt").onTouch = function()
  if #namefile.text > 0 then
    codeView:remove()
    local codeView = layout2:addChild(GUI.codeView(2, 2, cvwid, cvhei, 1, 1, 1, scrol, {}, GUI.LUA_SYNTAX_PATTERNS, GUI.LUA_SYNTAX_COLOR_SCHEME, true, {}))
    local counter = 1
    for line in require("filesystem").lines("/notepad/" .. namefile.text) do
  -- Replace tab symbols to 2 whitespaces and Windows line endings to UNIX line endings
      line = line:gsub("\t", "  "):gsub("\r\n", "\n")
      codeView.maximumLineLength = math.max(codeView.maximumLineLength, unicode.len(line))
      table.insert(codeView.lines, line)

      counter = counter + 1
      if counter > codeView.height then
        break
      end
    end
  else
    GUI.alert("Ошибка! Вы не можете загрузить не существующий файл!!!")
  end
end
addButton("Удалить файл").onTouch = function()
  fs.remove("/notepad/" .. namefile.text)
  GUI.alert("Файл /notepad/" .. namefile.text .. " удалён успешно.")
end
textholst:addChild(GUI.text(1, 1, 0x4B4B4B, "Размер холста:"))
addButton("24x12").onTouch = function()
  cvhei = 12
  cvwid = 24 
end
addButton("45x24").onTouch = function()
  cvhei = 24
  cvwid = 45
end
addButton("48x40").onTouch = function()
  cvhei = 40
  cvwid = 48
end
addButton("100x40 - не удобен!").onTouch = function()
  cvhei = 40
  cvwid = 100
end
layout2:addChild(GUI.text(1, 1, 0x4B4B4B, "Отображение файла"))

--local verticalScrollBar = layout:addChild(GUI.scrollBar(2, 3, 1, 15, 0x444444, 0x888888, 1, 100, 1, 10, 1, true))
--verticalScrollBar.onTouch = function()
--  GUI.alert("Вертикальную полосу тронули.")
--end

--local codeView = layout:addChild(GUI.codeView(2, 2, 45, 24, 1, 1, 1, {}, {}, GUI.LUA_SYNTAX_PATTERNS, GUI.LUA_SYNTAX_COLOR_SCHEME, true, {}))


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

window2.onResize = function(newWidth, newHeight)
  window2.backgroundPanel.width, window2.backgroundPanel.height = newWidth, newHeight
  layout.width, layout.height = newWidth, newHeight
end

---------------------------------------------------------------------------------

-- Draw changes on screen after customizing your window
workspace:draw()
