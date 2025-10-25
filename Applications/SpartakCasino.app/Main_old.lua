-- SpartakCasino - Профессиональное казино для MineOS
-- Автор: Manus AI
-- Версия: 1.0.0

local GUI = require("GUI")
local system = require("System")
local screen = require("Screen")
local filesystem = require("Filesystem")
local image = require("Image")
local paths = require("Paths")

--------------------------------------------------------------------------------

local balance = 10000
local appPath = filesystem.path(system.getCurrentScript())

--------------------------------------------------------------------------------

-- Создание главного окна
local workspace, window, menu = system.addWindow(GUI.filledWindow(1, 1, 120, 40, 0x1E1E1E))

window.backgroundPanel.colors.transparency = 0.2

-- Заголовок
local titleLabel = window:addChild(GUI.text(1, 2, 0xFFD700, "SPARTAK CASINO"))
titleLabel.width = window.width
titleLabel.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER

-- Подзаголовок
local subtitleLabel = window:addChild(GUI.text(1, 3, 0xFFAA00, "★ Премиум Казино ★"))
subtitleLabel.width = window.width
subtitleLabel.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER

-- Баланс
local balanceLabel = window:addChild(GUI.text(1, 5, 0x00FF00, "Баланс: " .. balance .. " кредитов"))
balanceLabel.width = window.width
balanceLabel.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER

-- Функция обновления баланса
local function updateBalance()
	balanceLabel.text = "💰 Баланс: " .. balance .. " кредитов"
	workspace:draw()
end

--------------------------------------------------------------------------------
-- ИГРА: СЛОТЫ
--------------------------------------------------------------------------------

local function playSlots()
	local slotsWindow = GUI.addBackgroundContainer(workspace, true, true, "Игровые Автоматы")
	
	-- Заголовок
	local titleText = slotsWindow.layout:addChild(GUI.text(1, 1, 0xFFD700, "🎰 ИГРОВЫЕ АВТОМАТЫ 🎰"))
	titleText.width = slotsWindow.width
	titleText.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER
	
	-- Информация
	slotsWindow.layout:addChild(GUI.text(1, 1, 0xFFFFFF, "Ставка: 100 кредитов | Джекпот: 1000 кредитов"))
	slotsWindow.layout:addChild(GUI.text(1, 1, 0xCCCCCC, "Соберите 3 одинаковых символа для выигрыша!"))
	
	slotsWindow.layout:addChild(GUI.object(1, 1, 1, 2))
	
	-- Слоты
	local slotsLayout = slotsWindow.layout:addChild(GUI.layout(1, 1, slotsWindow.width, 10, 1, 1))
	slotsLayout:setDirection(1, 1, GUI.DIRECTION_HORIZONTAL)
	slotsLayout:setAlignment(1, 1, GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_TOP)
	slotsLayout:setSpacing(1, 1, 3)
	
	local slot1 = slotsLayout:addChild(GUI.panel(1, 1, 15, 8, 0x3C3C3C))
	local slot2 = slotsLayout:addChild(GUI.panel(1, 1, 15, 8, 0x3C3C3C))
	local slot3 = slotsLayout:addChild(GUI.panel(1, 1, 15, 8, 0x3C3C3C))
	
	local slot1Text = slotsLayout:addChild(GUI.text(1, 1, 0xFFD700, "?"))
	local slot2Text = slotsLayout:addChild(GUI.text(1, 1, 0xFFD700, "?"))
	local slot3Text = slotsLayout:addChild(GUI.text(1, 1, 0xFFD700, "?"))
	
	slot1Text.width = 15
	slot2Text.width = 15
	slot3Text.width = 15
	slot1Text.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER
	slot2Text.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER
	slot3Text.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER
	
	slotsWindow.layout:addChild(GUI.object(1, 1, 1, 2))
	
	-- Результат
	local resultText = slotsWindow.layout:addChild(GUI.text(1, 1, 0xFFFFFF, ""))
	resultText.width = slotsWindow.width
	resultText.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER
	
	slotsWindow.layout:addChild(GUI.object(1, 1, 1, 1))
	
	-- Кнопка "Крутить"
	local spinButton = slotsWindow.layout:addChild(GUI.button(1, 1, 30, 3, 0x00AA00, 0xFFFFFF, 0x00FF00, 0xFFFFFF, "▶ КРУТИТЬ"))
	spinButton.onTouch = function()
		if balance < 100 then
			resultText.text = "❌ Недостаточно средств!"
			resultText.color = 0xFF0000
			workspace:draw()
			return
		end
		
		balance = balance - 100
		updateBalance()
		
		local symbols = {"7️⃣", "💎", "🍒", "⭐", "🔔"}
		local colors = {0xFF0000, 0x00FFFF, 0xFF0000, 0xFFD700, 0xFFAA00}
		
		-- Анимация
		for i = 1, 20 do
			local r1 = math.random(1, #symbols)
			local r2 = math.random(1, #symbols)
			local r3 = math.random(1, #symbols)
			
			slot1Text.text = symbols[r1]
			slot2Text.text = symbols[r2]
			slot3Text.text = symbols[r3]
			
			slot1Text.color = colors[r1]
			slot2Text.color = colors[r2]
			slot3Text.color = colors[r3]
			
			workspace:draw()
			os.sleep(0.05)
		end
		
		local r1 = math.random(1, #symbols)
		local r2 = math.random(1, #symbols)
		local r3 = math.random(1, #symbols)
		
		slot1Text.text = symbols[r1]
		slot2Text.text = symbols[r2]
		slot3Text.text = symbols[r3]
		
		slot1Text.color = colors[r1]
		slot2Text.color = colors[r2]
		slot3Text.color = colors[r3]
		
		if r1 == r2 and r2 == r3 then
			balance = balance + 1000
			updateBalance()
			resultText.text = "🎉 ДЖЕКПОТ! Вы выиграли 1000 кредитов! 🎉"
			resultText.color = 0x00FF00
		else
			resultText.text = "Попробуйте ещё раз!"
			resultText.color = 0xFF0000
		end
		
		workspace:draw()
	end
	
	slotsWindow.layout:addChild(GUI.object(1, 1, 1, 1))
	
	-- Кнопка "Назад"
	local backButton = slotsWindow.layout:addChild(GUI.button(1, 1, 30, 3, 0xAA0000, 0xFFFFFF, 0xFF0000, 0xFFFFFF, "◀ НАЗАД"))
	backButton.onTouch = function()
		slotsWindow:remove()
		workspace:draw()
	end
	
	workspace:draw()
end

--------------------------------------------------------------------------------
-- ИГРА: РУЛЕТКА
--------------------------------------------------------------------------------

local function playRoulette()
	local rouletteWindow = GUI.addBackgroundContainer(workspace, true, true, "Рулетка")
	
	-- Заголовок
	local titleText = rouletteWindow.layout:addChild(GUI.text(1, 1, 0xFFD700, "🎡 РУЛЕТКА 🎡"))
	titleText.width = rouletteWindow.width
	titleText.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER
	
	-- Информация
	rouletteWindow.layout:addChild(GUI.text(1, 1, 0xFFFFFF, "Ставка: 200 кредитов | Красное/Чёрное: x2 | Зелёное: x10"))
	
	rouletteWindow.layout:addChild(GUI.object(1, 1, 1, 2))
	
	-- Колесо рулетки
	local wheelPanel = rouletteWindow.layout:addChild(GUI.panel(1, 1, 40, 10, 0x3C3C3C))
	
	local wheelText = rouletteWindow.layout:addChild(GUI.text(1, 1, 0xFFD700, "?"))
	wheelText.width = rouletteWindow.width
	wheelText.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER
	
	rouletteWindow.layout:addChild(GUI.object(1, 1, 1, 2))
	
	-- Результат
	local resultText = rouletteWindow.layout:addChild(GUI.text(1, 1, 0xFFFFFF, ""))
	resultText.width = rouletteWindow.width
	resultText.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER
	
	rouletteWindow.layout:addChild(GUI.object(1, 1, 1, 1))
	
	-- Кнопки выбора
	local buttonsLayout = rouletteWindow.layout:addChild(GUI.layout(1, 1, rouletteWindow.width, 3, 1, 1))
	buttonsLayout:setDirection(1, 1, GUI.DIRECTION_HORIZONTAL)
	buttonsLayout:setAlignment(1, 1, GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_TOP)
	buttonsLayout:setSpacing(1, 1, 2)
	
	local function spinRoulette(choice)
		if balance < 200 then
			resultText.text = "❌ Недостаточно средств!"
			resultText.color = 0xFF0000
			workspace:draw()
			return
		end
		
		balance = balance - 200
		updateBalance()
		
		local options = {"red", "black", "red", "black", "red", "black", "green"}
		local symbols = {red = "🔴", black = "⚫", green = "🟢"}
		
		-- Анимация
		for i = 1, 20 do
			local temp = options[math.random(1, #options)]
			wheelText.text = symbols[temp]
			workspace:draw()
			os.sleep(0.08)
		end
		
		local result = options[math.random(1, #options)]
		wheelText.text = symbols[result]
		
		os.sleep(0.5)
		
		if choice == result then
			local win = (result == "green") and 2000 or 400
			balance = balance + win
			updateBalance()
			resultText.text = "🎉 ВЫИГРЫШ! Вы получили " .. win .. " кредитов! 🎉"
			resultText.color = 0x00FF00
		else
			resultText.text = "Не повезло! Попробуйте ещё раз!"
			resultText.color = 0xFF0000
		end
		
		workspace:draw()
	end
	
	local redButton = buttonsLayout:addChild(GUI.button(1, 1, 20, 3, 0xAA0000, 0xFFFFFF, 0xFF0000, 0xFFFFFF, "🔴 КРАСНОЕ"))
	redButton.onTouch = function()
		spinRoulette("red")
	end
	
	local blackButton = buttonsLayout:addChild(GUI.button(1, 1, 20, 3, 0x3C3C3C, 0xFFFFFF, 0x5A5A5A, 0xFFFFFF, "⚫ ЧЁРНОЕ"))
	blackButton.onTouch = function()
		spinRoulette("black")
	end
	
	local greenButton = buttonsLayout:addChild(GUI.button(1, 1, 20, 3, 0x00AA00, 0xFFFFFF, 0x00FF00, 0xFFFFFF, "🟢 ЗЕЛЁНОЕ"))
	greenButton.onTouch = function()
		spinRoulette("green")
	end
	
	rouletteWindow.layout:addChild(GUI.object(1, 1, 1, 1))
	
	-- Кнопка "Назад"
	local backButton = rouletteWindow.layout:addChild(GUI.button(1, 1, 30, 3, 0xAA0000, 0xFFFFFF, 0xFF0000, 0xFFFFFF, "◀ НАЗАД"))
	backButton.onTouch = function()
		rouletteWindow:remove()
		workspace:draw()
	end
	
	workspace:draw()
end

--------------------------------------------------------------------------------
-- ИГРА: КОСТИ
--------------------------------------------------------------------------------

local function playDice()
	local diceWindow = GUI.addBackgroundContainer(workspace, true, true, "Кости")
	
	-- Заголовок
	local titleText = diceWindow.layout:addChild(GUI.text(1, 1, 0xFFD700, "🎲 КОСТИ 🎲"))
	titleText.width = diceWindow.width
	titleText.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER
	
	-- Информация
	diceWindow.layout:addChild(GUI.text(1, 1, 0xFFFFFF, "Ставка: 150 кредитов | Сумма > 7 = x2"))
	
	diceWindow.layout:addChild(GUI.object(1, 1, 1, 2))
	
	-- Кости
	local diceLayout = diceWindow.layout:addChild(GUI.layout(1, 1, diceWindow.width, 10, 1, 1))
	diceLayout:setDirection(1, 1, GUI.DIRECTION_HORIZONTAL)
	diceLayout:setAlignment(1, 1, GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_TOP)
	diceLayout:setSpacing(1, 1, 3)
	
	local dice1Panel = diceLayout:addChild(GUI.panel(1, 1, 12, 8, 0x3C3C3C))
	local dice2Panel = diceLayout:addChild(GUI.panel(1, 1, 12, 8, 0x3C3C3C))
	
	local dice1Text = diceLayout:addChild(GUI.text(1, 1, 0xFFFFFF, "?"))
	local dice2Text = diceLayout:addChild(GUI.text(1, 1, 0xFFFFFF, "?"))
	
	dice1Text.width = 12
	dice2Text.width = 12
	dice1Text.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER
	dice2Text.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER
	
	diceWindow.layout:addChild(GUI.object(1, 1, 1, 2))
	
	-- Сумма
	local sumText = diceWindow.layout:addChild(GUI.text(1, 1, 0xFFD700, ""))
	sumText.width = diceWindow.width
	sumText.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER
	
	-- Результат
	local resultText = diceWindow.layout:addChild(GUI.text(1, 1, 0xFFFFFF, ""))
	resultText.width = diceWindow.width
	resultText.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER
	
	diceWindow.layout:addChild(GUI.object(1, 1, 1, 1))
	
	-- Кнопка "Бросить"
	local rollButton = diceWindow.layout:addChild(GUI.button(1, 1, 30, 3, 0x00AA00, 0xFFFFFF, 0x00FF00, 0xFFFFFF, "🎲 БРОСИТЬ"))
	rollButton.onTouch = function()
		if balance < 150 then
			resultText.text = "❌ Недостаточно средств!"
			resultText.color = 0xFF0000
			workspace:draw()
			return
		end
		
		balance = balance - 150
		updateBalance()
		
		local d1, d2
		
		-- Анимация
		for i = 1, 20 do
			d1 = math.random(1, 6)
			d2 = math.random(1, 6)
			dice1Text.text = tostring(d1)
			dice2Text.text = tostring(d2)
			workspace:draw()
			os.sleep(0.06)
		end
		
		local sum = d1 + d2
		sumText.text = "Сумма: " .. sum
		
		os.sleep(0.5)
		
		if sum > 7 then
			balance = balance + 300
			updateBalance()
			resultText.text = "🎉 ВЫИГРЫШ! Вы получили 300 кредитов! 🎉"
			resultText.color = 0x00FF00
		else
			resultText.text = "Не повезло! Попробуйте ещё раз!"
			resultText.color = 0xFF0000
		end
		
		workspace:draw()
	end
	
	diceWindow.layout:addChild(GUI.object(1, 1, 1, 1))
	
	-- Кнопка "Назад"
	local backButton = diceWindow.layout:addChild(GUI.button(1, 1, 30, 3, 0xAA0000, 0xFFFFFF, 0xFF0000, 0xFFFFFF, "◀ НАЗАД"))
	backButton.onTouch = function()
		diceWindow:remove()
		workspace:draw()
	end
	
	workspace:draw()
end

--------------------------------------------------------------------------------
-- ГЛАВНОЕ МЕНЮ
--------------------------------------------------------------------------------

-- Разделитель
window:addChild(GUI.object(1, 7, 1, 2))

-- Кнопки игр
local gamesLayout = window:addChild(GUI.layout(1, 9, window.width, window.height - 15, 1, 1))
gamesLayout:setAlignment(1, 1, GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_TOP)
gamesLayout:setSpacing(1, 1, 2)

local slotsButton = gamesLayout:addChild(GUI.button(1, 1, 50, 5, 0x9B30FF, 0xFFFFFF, 0xAA00FF, 0xFFFFFF, "🎰 ИГРОВЫЕ АВТОМАТЫ"))
slotsButton.onTouch = function()
	playSlots()
end

local rouletteButton = gamesLayout:addChild(GUI.button(1, 1, 50, 5, 0xAA0000, 0xFFFFFF, 0xFF0000, 0xFFFFFF, "🎡 РУЛЕТКА"))
rouletteButton.onTouch = function()
	playRoulette()
end

local diceButton = gamesLayout:addChild(GUI.button(1, 1, 50, 5, 0x00AA00, 0xFFFFFF, 0x00FF00, 0xFFFFFF, "🎲 КОСТИ"))
diceButton.onTouch = function()
	playDice()
end

gamesLayout:addChild(GUI.object(1, 1, 1, 2))

local exitButton = gamesLayout:addChild(GUI.button(1, 1, 50, 5, 0x3C3C3C, 0xFFFFFF, 0x5A5A5A, 0xFFFFFF, "✖ ВЫХОД"))
exitButton.onTouch = function()
	window:remove()
end

-- Футер
local footerText = window:addChild(GUI.text(1, window.height - 1, 0x888888, "SpartakCasino v1.0.0 © 2025 | Manus AI"))
footerText.width = window.width
footerText.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER

--------------------------------------------------------------------------------

workspace:draw()

