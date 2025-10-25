-- SpartakCasino Installer
-- Автоматическая установка для MineOS

local component = require("component")
local filesystem = require("filesystem")
local internet = require("internet")
local shell = require("shell")
local term = require("term")
local gpu = component.gpu

local REPO_URL = "https://raw.githubusercontent.com/makimyys-afk/SpartakCasino/master/"
local INSTALL_PATH = "/MineOS/Applications/SpartakCasino.app/"

local files = {
	"Applications/SpartakCasino.app/Main.lua",
	"Images/logo.png",
	"Images/slot_machine.png",
	"Images/roulette.png",
	"Images/dice.png",
	"Images/background.png",
	"Localizations/Russian.lang",
	"Localizations/English.lang"
}

local function download(url, path)
	local result, response = pcall(internet.request, url)
	if not result then
		return false, "Failed to connect: " .. tostring(response)
	end
	
	local data = ""
	for chunk in response do
		data = data .. chunk
	end
	
	filesystem.makeDirectory(filesystem.path(path))
	
	local file, reason = io.open(path, "wb")
	if not file then
		return false, "Failed to open file: " .. reason
	end
	
	file:write(data)
	file:close()
	
	return true
end

local function printColored(text, color)
	local oldColor = gpu.getForeground()
	gpu.setForeground(color)
	print(text)
	gpu.setForeground(oldColor)
end

term.clear()
printColored("╔═══════════════════════════════════════════╗", 0xFFD700)
printColored("║                                           ║", 0xFFD700)
printColored("║       SPARTAK CASINO INSTALLER            ║", 0xFFD700)
printColored("║                                           ║", 0xFFD700)
printColored("╚═══════════════════════════════════════════╝", 0xFFD700)
print("")

printColored("Установка SpartakCasino...", 0xFFFFFF)
print("")

-- Проверка MineOS
if not filesystem.exists("/MineOS/") then
	printColored("❌ ОШИБКА: MineOS не установлена!", 0xFF0000)
	printColored("Пожалуйста, установите MineOS сначала.", 0xFF0000)
	return
end

-- Создание директорий
printColored("Создание директорий...", 0x00FF00)
filesystem.makeDirectory(INSTALL_PATH)
filesystem.makeDirectory(INSTALL_PATH .. "Images/")
filesystem.makeDirectory(INSTALL_PATH .. "Localizations/")

-- Скачивание файлов
local success = 0
local failed = 0

for i, file in ipairs(files) do
	local url = REPO_URL .. file
	local targetPath = INSTALL_PATH .. file:gsub("Applications/SpartakCasino.app/", "")
	
	printColored(string.format("[%d/%d] Скачивание %s...", i, #files, file), 0xFFFFFF)
	
	local ok, err = download(url, targetPath)
	if ok then
		printColored("  ✓ Успешно", 0x00FF00)
		success = success + 1
	else
		printColored("  ✗ Ошибка: " .. err, 0xFF0000)
		failed = failed + 1
	end
end

print("")
printColored("╔═══════════════════════════════════════════╗", 0xFFD700)
printColored("║                                           ║", 0xFFD700)

if failed == 0 then
	printColored("║  ✓ УСТАНОВКА ЗАВЕРШЕНА УСПЕШНО!          ║", 0x00FF00)
	printColored("║                                           ║", 0xFFD700)
	printColored("║  Перезапустите MineOS или обновите        ║", 0xFFFFFF)
	printColored("║  список приложений.                       ║", 0xFFFFFF)
else
	printColored("║  ⚠ УСТАНОВКА ЗАВЕРШЕНА С ОШИБКАМИ        ║", 0xFFAA00)
	printColored("║                                           ║", 0xFFD700)
	printColored(string.format("║  Успешно: %d | Ошибок: %d                ║", success, failed), 0xFFFFFF)
end

printColored("║                                           ║", 0xFFD700)
printColored("╚═══════════════════════════════════════════╝", 0xFFD700)
print("")
printColored("Спасибо за установку SpartakCasino! 🎰", 0xFFD700)

