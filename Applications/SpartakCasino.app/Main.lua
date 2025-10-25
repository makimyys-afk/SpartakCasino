-- SpartakCasino V2 - Интерактивная версия с визуальной анимацией
-- Автор: Manus AI
-- Версия: 2.0.0

local GUI = require("GUI")
local system = require("System")
local screen = require("Screen")
local filesystem = require("filesystem")
local unicode = require("unicode")

--------------------------------------------------------------------------------

local balance = 10000
local appPath = filesystem.path(system.getCurrentScript())

-- Цвета
local C = {
	BLACK = 0x000000,
	WHITE = 0xFFFFFF,
	GOLD = 0xFFD700,
	GOLD_LIGHT = 0xFFE55C,
	RED = 0xFF0000,
	RED_DARK = 0x8B0000,
	GREEN = 0x00FF00,
	GREEN_DARK = 0x006400,
	GRAY = 0x3C3C3C,
	SILVER = 0xC0C0C0,
}

--------------------------------------------------------------------------------

-- Создание главного окна
local workspace, window = system.addWindow(GUI.filledWindow(1, 1, 140, 45, 0x1E1E1E))

window.backgroundPanel.colors.transparency = 0.3

-- Заголовок
local titleLabel = window:addChild(GUI.text(1, 2, C.GOLD, "★ ═══════════════════════════════════════ ★"))
titleLabel.width = window.width
titleLabel.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER

local mainTitle = window:addChild(GUI.text(1, 3, C.GOLD_LIGHT, "SPARTAK CASINO"))
mainTitle.width = window.width
mainTitle.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER

local subtitle = window:addChild(GUI.text(1, 4, C.GOLD, "★ ═══════════════════════════════════════ ★"))
subtitle.width = window.width
subtitle.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER

-- Баланс
local balanceLabel = window:addChild(GUI.text(1, 6, C.GREEN, "💰 Баланс: " .. balance .. " кредитов"))
balanceLabel.width = window.width
balanceLabel.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER

local function updateBalance()
	balanceLabel.text = "💰 Баланс: " .. balance .. " кредитов"
	workspace:draw()
end

--------------------------------------------------------------------------------
-- РУЛЕТКА С ВИЗУАЛЬНЫМИ ЧИСЛАМИ
--------------------------------------------------------------------------------

local rouletteNumbers = {
	{num = 0, color = "green"},
	{num = 32, color = "red"}, {num = 15, color = "black"}, {num = 19, color = "red"},
	{num = 4, color = "black"}, {num = 21, color = "red"}, {num = 2, color = "black"},
	{num = 25, color = "red"}, {num = 17, color = "black"}, {num = 34, color = "red"},
	{num = 6, color = "black"}, {num = 27, color = "red"}, {num = 13, color = "black"},
	{num = 36, color = "red"}, {num = 11, color = "black"}, {num = 30, color = "red"},
	{num = 8, color = "black"}, {num = 23, color = "red"}, {num = 10, color = "black"},
	{num = 5, color = "red"}, {num = 24, color = "black"}, {num = 16, color = "red"},
	{num = 33, color = "black"}, {num = 1, color = "red"}, {num = 20, color = "black"},
	{num = 14, color = "red"}, {num = 31, color = "black"}, {num = 9, color = "red"},
	{num = 22, color = "black"}, {num = 18, color = "red"}, {num = 29, color = "black"},
	{num = 7, color = "red"}, {num = 28, color = "black"}, {num = 12, color = "red"},
	{num = 35, color = "black"}, {num = 3, color = "red"}, {num = 26, color = "black"}
}

local function playRoulette()
	local rouletteWindow = GUI.addBackgroundContainer(workspace, true, true, "Рулетка")
	
	-- Заголовок
	local titleText = rouletteWindow.layout:addChild(GUI.text(1, 1, C.GOLD, "🎡 ЕВРОПЕЙСКАЯ РУЛЕТКА 🎡"))
	titleText.width = rouletteWindow.width
	titleText.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER
	
	rouletteWindow.layout:addChild(GUI.text(1, 1, C.WHITE, "Ставка: 100 кредитов | Число: x35 | Цвет: x2 | Зелёное: x35"))
	
	rouletteWindow.layout:addChild(GUI.object(1, 1, 1, 1))
	
	-- Визуальное колесо рулетки
	local wheelContainer = rouletteWindow.layout:addChild(GUI.container(1, 1, rouletteWindow.width, 15))
	
	local wheelPanel = wheelContainer:addChild(GUI.panel(1, 1, rouletteWindow.width - 4, 13, C.GRAY))
	
	-- Отображение чисел на колесе
	local wheelNumbers = {}
	for i = 1, 13 do
		wheelNumbers[i] = wheelContainer:addChild(GUI.text(1, i + 1, C.WHITE, ""))
		wheelNumbers[i].width = rouletteWindow.width - 4
		wheelNumbers[i].alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER
	end
	
	-- Результат
	local resultText = rouletteWindow.layout:addChild(GUI.text(1, 1, C.WHITE, ""))
	resultText.width = rouletteWindow.width
	resultText.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER
	
	rouletteWindow.layout:addChild(GUI.object(1, 1, 1, 1))
	
	-- Поле для ввода ставки
	local betLayout = rouletteWindow.layout:addChild(GUI.layout(1, 1, rouletteWindow.width, 3, 1, 1))
	betLayout:setDirection(1, 1, GUI.DIRECTION_HORIZONTAL)
	betLayout:setAlignment(1, 1, GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_TOP)
	betLayout:setSpacing(1, 1, 2)
	
	betLayout:addChild(GUI.text(1, 1, C.WHITE, "Номер (0-36):"))
	local numberInput = betLayout:addChild(GUI.input(1, 1, 10, 3, C.GRAY, C.WHITE, C.SILVER, C.GRAY, C.WHITE, "", "0"))
	
	rouletteWindow.layout:addChild(GUI.object(1, 1, 1, 1))
	
	-- Кнопки ставок
	local buttonsLayout = rouletteWindow.layout:addChild(GUI.layout(1, 1, rouletteWindow.width, 3, 1, 1))
	buttonsLayout:setDirection(1, 1, GUI.DIRECTION_HORIZONTAL)
	buttonsLayout:setAlignment(1, 1, GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_TOP)
	buttonsLayout:setSpacing(1, 1, 2)
	
	local function spinWheel(betType, betValue)
		if balance < 100 then
			resultText.text = "❌ Недостаточно средств!"
			resultText.color = C.RED
			workspace:draw()
			return
		end
		
		balance = balance - 100
		updateBalance()
		
		resultText.text = "Вращение..."
		resultText.color = C.WHITE
		workspace:draw()
		
		-- Анимация вращения
		local spinCount = 40
		local currentIndex = 1
		
		for spin = 1, spinCount do
			-- Очистка
			for i = 1, 13 do
				wheelNumbers[i].text = ""
			end
			
			-- Отображение чисел
			for i = 1, 13 do
				local idx = ((currentIndex + i - 7) % #rouletteNumbers) + 1
				local num = rouletteNumbers[idx]
				
				local color = C.WHITE
				if num.color == "red" then
					color = C.RED
				elseif num.color == "green" then
					color = C.GREEN
				end
				
				local symbol = "●"
				if i == 7 then
					symbol = "▶ " .. num.num .. " ◀"
					wheelNumbers[i].color = C.GOLD
				else
					symbol = num.num
					wheelNumbers[i].color = color
				end
				
				wheelNumbers[i].text = symbol
			end
			
			workspace:draw()
			
			local delay = 0.02 + (spin / spinCount) * 0.15
			os.sleep(delay)
			
			currentIndex = (currentIndex % #rouletteNumbers) + 1
		end
		
		-- Финальный результат
		local finalIdx = math.random(1, #rouletteNumbers)
		local result = rouletteNumbers[finalIdx]
		
		-- Отображение финального числа
		for i = 1, 13 do
			local idx = ((finalIdx + i - 7 - 1) % #rouletteNumbers) + 1
			local num = rouletteNumbers[idx]
			
			local color = C.WHITE
			if num.color == "red" then
				color = C.RED
			elseif num.color == "green" then
				color = C.GREEN
			end
			
			local symbol = "●"
			if i == 7 then
				symbol = "▶▶ " .. num.num .. " ◀◀"
				wheelNumbers[i].color = C.GOLD_LIGHT
			else
				symbol = num.num
				wheelNumbers[i].color = color
			end
			
			wheelNumbers[i].text = symbol
		end
		
		workspace:draw()
		os.sleep(1)
		
		-- Проверка выигрыша
		local won = false
		local winAmount = 0
		
		if betType == "number" then
			if result.num == betValue then
				won = true
				winAmount = 3500
			end
		elseif betType == "color" then
			if result.color == betValue then
				won = true
				winAmount = 200
			end
		end
		
		if won then
			balance = balance + winAmount
			updateBalance()
			resultText.text = "🎉 ВЫИГРЫШ! Выпало " .. result.num .. " (" .. result.color .. ") | +" .. winAmount .. " кредитов!"
			resultText.color = C.GREEN
		else
			resultText.text = "Выпало " .. result.num .. " (" .. result.color .. "). Не повезло!"
			resultText.color = C.RED
		end
		
		workspace:draw()
	end
	
	local numberButton = buttonsLayout:addChild(GUI.button(1, 1, 25, 3, C.GOLD, C.BLACK, C.GOLD_LIGHT, C.BLACK, "🎯 СТАВКА НА ЧИСЛО"))
	numberButton.onTouch = function()
		local num = tonumber(numberInput.text)
		if num and num >= 0 and num <= 36 then
			spinWheel("number", num)
		else
			resultText.text = "❌ Введите число от 0 до 36!"
			resultText.color = C.RED
			workspace:draw()
		end
	end
	
	local redButton = buttonsLayout:addChild(GUI.button(1, 1, 20, 3, C.RED_DARK, C.WHITE, C.RED, C.WHITE, "🔴 КРАСНОЕ"))
	redButton.onTouch = function()
		spinWheel("color", "red")
	end
	
	local blackButton = buttonsLayout:addChild(GUI.button(1, 1, 20, 3, C.BLACK, C.WHITE, C.GRAY, C.WHITE, "⚫ ЧЁРНОЕ"))
	blackButton.onTouch = function()
		spinWheel("color", "black")
	end
	
	local greenButton = buttonsLayout:addChild(GUI.button(1, 1, 20, 3, C.GREEN_DARK, C.WHITE, C.GREEN, C.WHITE, "🟢 ЗЕЛЁНОЕ"))
	greenButton.onTouch = function()
		spinWheel("color", "green")
	end
	
	rouletteWindow.layout:addChild(GUI.object(1, 1, 1, 1))
	
	-- Кнопка "Назад"
	local backButton = rouletteWindow.layout:addChild(GUI.button(1, 1, 30, 3, C.RED_DARK, C.WHITE, C.RED, C.WHITE, "◀ НАЗАД"))
	backButton.onTouch = function()
		rouletteWindow:remove()
		workspace:draw()
	end
	
	workspace:draw()
end

--------------------------------------------------------------------------------
-- СЛОТЫ С ВИЗУАЛЬНЫМИ БАРАБАНАМИ
--------------------------------------------------------------------------------

local function playSlots()
	local slotsWindow = GUI.addBackgroundContainer(workspace, true, true, "Игровые Автоматы")
	
	local titleText = slotsWindow.layout:addChild(GUI.text(1, 1, C.GOLD, "🎰 ИГРОВЫЕ АВТОМАТЫ 🎰"))
	titleText.width = slotsWindow.width
	titleText.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER
	
	slotsWindow.layout:addChild(GUI.text(1, 1, C.WHITE, "Ставка: 100 кредитов | Джекпот: 5000 кредитов"))
	
	slotsWindow.layout:addChild(GUI.object(1, 1, 1, 2))
	
	-- Барабаны
	local symbols = {"7", "💎", "🍒", "⭐", "🔔", "🍋", "🍇"}
	local symbolColors = {C.RED, C.GOLD, C.RED, C.GOLD_LIGHT, C.GOLD, C.GOLD_LIGHT, C.RED}
	
	local reelsContainer = slotsWindow.layout:addChild(GUI.container(1, 1, slotsWindow.width, 20))
	
	local reelPanels = {}
	local reelTexts = {}
	
	for i = 1, 3 do
		local x = 20 + (i - 1) * 30
		reelPanels[i] = reelsContainer:addChild(GUI.panel(x, 1, 25, 18, C.GRAY))
		
		reelTexts[i] = {}
		for j = 1, 7 do
			reelTexts[i][j] = reelsContainer:addChild(GUI.text(x + 2, j * 2 + 1, C.WHITE, ""))
			reelTexts[i][j].width = 21
			reelTexts[i][j].alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER
		end
	end
	
	-- Результат
	local resultText = slotsWindow.layout:addChild(GUI.text(1, 1, C.WHITE, ""))
	resultText.width = slotsWindow.width
	resultText.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER
	
	slotsWindow.layout:addChild(GUI.object(1, 1, 1, 1))
	
	-- Кнопка "Крутить"
	local spinButton = slotsWindow.layout:addChild(GUI.button(1, 1, 40, 3, C.GREEN_DARK, C.WHITE, C.GREEN, C.WHITE, "▶ КРУТИТЬ БАРАБАНЫ"))
	spinButton.onTouch = function()
		if balance < 100 then
			resultText.text = "❌ Недостаточно средств!"
			resultText.color = C.RED
			workspace:draw()
			return
		end
		
		balance = balance - 100
		updateBalance()
		
		resultText.text = "Вращение..."
		resultText.color = C.WHITE
		workspace:draw()
		
		local finalSymbols = {}
		
		-- Анимация вращения каждого барабана
		for reel = 1, 3 do
			local spins = 20 + reel * 5
			
			for spin = 1, spins do
				for j = 1, 7 do
					local idx = ((spin + j - 4) % #symbols) + 1
					reelTexts[reel][j].text = symbols[idx]
					reelTexts[reel][j].color = symbolColors[idx]
				end
				
				workspace:draw()
				os.sleep(0.03)
			end
			
			-- Финальный символ
			local finalIdx = math.random(1, #symbols)
			finalSymbols[reel] = finalIdx
			
			for j = 1, 7 do
				local idx = ((finalIdx + j - 4 - 1) % #symbols) + 1
				reelTexts[reel][j].text = symbols[idx]
				reelTexts[reel][j].color = symbolColors[idx]
				
				if j == 4 then
					reelTexts[reel][j].color = C.GOLD_LIGHT
				end
			end
			
			workspace:draw()
			os.sleep(0.3)
		end
		
		os.sleep(0.5)
		
		-- Проверка выигрыша
		if finalSymbols[1] == finalSymbols[2] and finalSymbols[2] == finalSymbols[3] then
			balance = balance + 5000
			updateBalance()
			resultText.text = "🎉🎉🎉 ДЖЕКПОТ! Вы выиграли 5000 кредитов! 🎉🎉🎉"
			resultText.color = C.GREEN
		elseif finalSymbols[1] == finalSymbols[2] or finalSymbols[2] == finalSymbols[3] then
			balance = balance + 200
			updateBalance()
			resultText.text = "🎉 Два совпадения! +200 кредитов!"
			resultText.color = C.GREEN
		else
			resultText.text = "Попробуйте ещё раз!"
			resultText.color = C.RED
		end
		
		workspace:draw()
	end
	
	slotsWindow.layout:addChild(GUI.object(1, 1, 1, 1))
	
	local backButton = slotsWindow.layout:addChild(GUI.button(1, 1, 30, 3, C.RED_DARK, C.WHITE, C.RED, C.WHITE, "◀ НАЗАД"))
	backButton.onTouch = function()
		slotsWindow:remove()
		workspace:draw()
	end
	
	workspace:draw()
end

--------------------------------------------------------------------------------
-- КОСТИ С ВИЗУАЛИЗАЦИЕЙ
--------------------------------------------------------------------------------

local diceFaces = {
	[1] = {"     ", "  ●  ", "     "},
	[2] = {"●    ", "     ", "    ●"},
	[3] = {"●    ", "  ●  ", "    ●"},
	[4] = {"●   ●", "     ", "●   ●"},
	[5] = {"●   ●", "  ●  ", "●   ●"},
	[6] = {"●   ●", "●   ●", "●   ●"}
}

local function playDice()
	local diceWindow = GUI.addBackgroundContainer(workspace, true, true, "Кости")
	
	local titleText = diceWindow.layout:addChild(GUI.text(1, 1, C.GOLD, "🎲 КОСТИ 🎲"))
	titleText.width = diceWindow.width
	titleText.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER
	
	diceWindow.layout:addChild(GUI.text(1, 1, C.WHITE, "Ставка: 150 кредитов | Сумма > 7 = x2"))
	
	diceWindow.layout:addChild(GUI.object(1, 1, 1, 2))
	
	-- Контейнер для костей
	local diceContainer = diceWindow.layout:addChild(GUI.container(1, 1, diceWindow.width, 12))
	
	local dice1Panel = diceContainer:addChild(GUI.panel(30, 2, 15, 7, C.GRAY))
	local dice2Panel = diceContainer:addChild(GUI.panel(55, 2, 15, 7, C.GRAY))
	
	local dice1Lines = {}
	local dice2Lines = {}
	
	for i = 1, 3 do
		dice1Lines[i] = diceContainer:addChild(GUI.text(32, 3 + i, C.WHITE, "     "))
		dice2Lines[i] = diceContainer:addChild(GUI.text(57, 3 + i, C.WHITE, "     "))
	end
	
	-- Сумма
	local sumText = diceWindow.layout:addChild(GUI.text(1, 1, C.GOLD_LIGHT, ""))
	sumText.width = diceWindow.width
	sumText.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER
	
	-- Результат
	local resultText = diceWindow.layout:addChild(GUI.text(1, 1, C.WHITE, ""))
	resultText.width = diceWindow.width
	resultText.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER
	
	diceWindow.layout:addChild(GUI.object(1, 1, 1, 1))
	
	-- Кнопка "Бросить"
	local rollButton = diceWindow.layout:addChild(GUI.button(1, 1, 35, 3, C.GREEN_DARK, C.WHITE, C.GREEN, C.WHITE, "🎲 БРОСИТЬ КОСТИ"))
	rollButton.onTouch = function()
		if balance < 150 then
			resultText.text = "❌ Недостаточно средств!"
			resultText.color = C.RED
			workspace:draw()
			return
		end
		
		balance = balance - 150
		updateBalance()
		
		sumText.text = "Бросаем..."
		sumText.color = C.WHITE
		resultText.text = ""
		workspace:draw()
		
		local d1, d2
		
		-- Анимация броска
		for i = 1, 25 do
			d1 = math.random(1, 6)
			d2 = math.random(1, 6)
			
			for j = 1, 3 do
				dice1Lines[j].text = diceFaces[d1][j]
				dice2Lines[j].text = diceFaces[d2][j]
			end
			
			workspace:draw()
			os.sleep(0.05)
		end
		
		local sum = d1 + d2
		sumText.text = "Кость 1: " .. d1 .. " | Кость 2: " .. d2 .. " | Сумма: " .. sum
		sumText.color = C.GOLD_LIGHT
		
		os.sleep(1)
		
		if sum > 7 then
			balance = balance + 300
			updateBalance()
			resultText.text = "🎉 ВЫИГРЫШ! Вы получили 300 кредитов! 🎉"
			resultText.color = C.GREEN
		else
			resultText.text = "Не повезло! Попробуйте ещё раз!"
			resultText.color = C.RED
		end
		
		workspace:draw()
	end
	
	diceWindow.layout:addChild(GUI.object(1, 1, 1, 1))
	
	local backButton = diceWindow.layout:addChild(GUI.button(1, 1, 30, 3, C.RED_DARK, C.WHITE, C.RED, C.WHITE, "◀ НАЗАД"))
	backButton.onTouch = function()
		diceWindow:remove()
		workspace:draw()
	end
	
	workspace:draw()
end

--------------------------------------------------------------------------------
-- ГЛАВНОЕ МЕНЮ
--------------------------------------------------------------------------------

window:addChild(GUI.object(1, 8, 1, 2))

local gamesLayout = window:addChild(GUI.layout(1, 10, window.width, window.height - 15, 1, 1))
gamesLayout:setAlignment(1, 1, GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_TOP)
gamesLayout:setSpacing(1, 1, 2)

local slotsButton = gamesLayout:addChild(GUI.button(1, 1, 60, 5, 0x9B30FF, C.WHITE, 0xAA00FF, C.WHITE, "🎰 ИГРОВЫЕ АВТОМАТЫ"))
slotsButton.onTouch = function()
	playSlots()
end

local rouletteButton = gamesLayout:addChild(GUI.button(1, 1, 60, 5, C.RED_DARK, C.WHITE, C.RED, C.WHITE, "🎡 ЕВРОПЕЙСКАЯ РУЛЕТКА"))
rouletteButton.onTouch = function()
	playRoulette()
end

local diceButton = gamesLayout:addChild(GUI.button(1, 1, 60, 5, C.GREEN_DARK, C.WHITE, C.GREEN, C.WHITE, "🎲 КОСТИ"))
diceButton.onTouch = function()
	playDice()
end

gamesLayout:addChild(GUI.object(1, 1, 1, 2))

local exitButton = gamesLayout:addChild(GUI.button(1, 1, 60, 5, C.GRAY, C.WHITE, C.SILVER, C.BLACK, "✖ ВЫХОД"))
exitButton.onTouch = function()
	window:remove()
end

local footerText = window:addChild(GUI.text(1, window.height - 1, 0x888888, "SpartakCasino v2.0.0 - Интерактивная версия © 2025"))
footerText.width = window.width
footerText.alignment = GUI.ALIGNMENT_HORIZONTAL_CENTER

--------------------------------------------------------------------------------

workspace:draw()

