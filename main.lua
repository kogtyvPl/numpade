
-- Импорт библиотек и переменные
local GUI = require("GUI")
local system = require("System")
local fs = require("Filesystem")

local textzg = ""
local codeView = ""
---------------------------------------------------------------------------------

-- Add a new window to MineOS workspace
local workspace, window, menu = system.addWindow(GUI.filledWindow(1, 1, 60, 45, 0xE1E1E1))

-- Get localization table dependent of current system language
--local localization = system.getCurrentScriptLocalization() (залупа закоментированая)



-- Add single cell layout to window
local layout = window:addChild(GUI.layout(1, 1, window.width, window.height, 1, 1))

-- Add nice gray text object to layout
layout:addChild(GUI.text(1, 1, 0x4B4B4B, "Привет, напиши свой текст, " .. system.getUser()))

local function addButton(text)
return layout:addChild(GUI.roundedButton(1, 1, 36, 3, 0xD2D2D2, 0x696969, 0x4B4B4B, 0xF0F0F0, text))
end


local namefile = layout:addChild(GUI.input(15, 21, 30, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "MyText.txt", "Имя файла"))
  
local codeView = layout:addChild(GUI.codeView(2, 2, 0, 0, 1, 1, 1, {}, {}, GUI.LUA_SYNTAX_PATTERNS, GUI.LUA_SYNTAX_COLOR_SCHEME, true, {}))

local lable = layout:addChild(GUI.input(15, 15, 30, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, textzg, "Напишите сюда текст"))
addButton("Записать изменения.txt").onTouch = function()
  if #lable.text > 0 then
    --GUI.alert(lable.text, " - этот текст был сохранён в файл")
    fs.append("/notepad/" .. namefile.text, "\n" .. lable.text)
  else
    GUI.alert("Пустая строка.")
  end
end
addButton("Загрузить файл.txt").onTouch = function()
  codeView:remove()
  local codeView = layout:addChild(GUI.codeView(2, 2, 45, 24, 1, 1, 1, {}, {}, GUI.LUA_SYNTAX_PATTERNS, GUI.LUA_SYNTAX_COLOR_SCHEME, true, {}))
  if #namefile.text > 0 then
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

layout:addChild(GUI.text(1, 1, 0x4B4B4B, "Отображение файла"))

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

---------------------------------------------------------------------------------

-- Draw changes on screen after customizing your window
workspace:draw()
