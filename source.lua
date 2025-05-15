--[[
Huzzy Hub v1.0 - Script completo para Blox Fruits
Interface moderna, funcional, com múltiplas abas e funções automáticas.
Toggle da interface com Right Shift.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- GUI principal
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "HuzzyHub"

-- Container principal (frame arredondado)
local mainFrame = Instance.new("Frame", ScreenGui)
mainFrame.Size = UDim2.new(0, 480, 0, 380)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.ClipsDescendants = true
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Visible = false -- começa escondido

-- Arredondamento (UICorner)
local uicorner = Instance.new("UICorner", mainFrame)
uicorner.CornerRadius = UDim.new(0, 15)

-- Barra superior (drag + titulo + minimizar)
local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
topBar.ClipsDescendants = true

local topBarCorner = Instance.new("UICorner", topBar)
topBarCorner.CornerRadius = UDim.new(0, 15)

-- Título
local titleLabel = Instance.new("TextLabel", topBar)
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Huzzy Hub"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextYAlignment = Enum.TextYAlignment.Center

-- Botão minimizar
local minimizeBtn = Instance.new("TextButton", topBar)
minimizeBtn.Size = UDim2.new(0, 60, 1, 0)
minimizeBtn.Position = UDim2.new(1, -70, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 25
minimizeBtn.AutoButtonColor = false
minimizeBtn.ClipsDescendants = true

local minimizeCorner = Instance.new("UICorner", minimizeBtn)
minimizeCorner.CornerRadius = UDim.new(0, 8)

-- Área do menu (coluna esquerda)
local menuFrame = Instance.new("Frame", mainFrame)
menuFrame.Size = UDim2.new(0, 140, 1, -40)
menuFrame.Position = UDim2.new(0, 0, 0, 40)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local menuCorner = Instance.new("UICorner", menuFrame)
menuCorner.CornerRadius = UDim.new(0, 15)

-- Área do conteúdo (lado direito)
local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -140, 1, -40)
contentFrame.Position = UDim2.new(0, 140, 0, 40)
contentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local contentCorner = Instance.new("UICorner", contentFrame)
contentCorner.CornerRadius = UDim.new(0, 15)

-- Função para criar botões do menu
local function createMenuButton(text, posY)
	local btn = Instance.new("TextButton", menuFrame)
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.TextColor3 = Color3.new(1, 1, 1)
	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(0, 10)
	return btn
end

-- Função para criar toggles na interface
local function createToggle(text, yPos, parent, callback)
	local toggleBtn = Instance.new("TextButton", parent)
	toggleBtn.Size = UDim2.new(0, 280, 0, 35)
	toggleBtn.Position = UDim2.new(0, 10, 0, yPos)
	toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
	toggleBtn.TextColor3 = Color3.new(1, 1, 1)
	toggleBtn.Font = Enum.Font.GothamBold
	toggleBtn.TextSize = 18
	toggleBtn.Text = "Ativar " .. text
	toggleBtn.AutoButtonColor = false
	local toggle = false

	local corner = Instance.new("UICorner", toggleBtn)
	corner.CornerRadius = UDim.new(0, 8)

	toggleBtn.MouseButton1Click:Connect(function()
		toggle = not toggle
		toggleBtn.BackgroundColor3 = toggle and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
		toggleBtn.Text = (toggle and "Desativar " or "Ativar ") .. text
		callback(toggle)
	end)
	return toggleBtn
end

-- Criar as abas
local pages = {}

local function newPage()
	local frame = Instance.new("ScrollingFrame", contentFrame)
	frame.Size = UDim2.new(1, -20, 1, -20)
	frame.Position = UDim2.new(0, 10, 0, 10)
	frame.BackgroundTransparency = 1
	frame.ScrollBarThickness = 6
	frame.Visible = false
	frame.CanvasSize = UDim2.new(0, 0, 2, 0)
	frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	return frame
end

pages.Farm = newPage()
pages.Mission = newPage()
pages.Shop = newPage()
pages.Other = newPage()
pages.Home = newPage()

pages.Home.Visible = true

-- Função para mostrar página e esconder as outras
local function showPage(page)
	for _, p in pairs(pages) do
		p.Visible = false
	end
	page.Visible = true
end

-- Criar botões no menu
local btnHome = createMenuButton("Home", 10)
local btnFarm = createMenuButton("Farm", 60)
local btnMission = createMenuButton("Missões/Itens", 110)
local btnShop = createMenuButton("Loja", 160)
local btnOther = createMenuButton("Outros", 210)

btnHome.MouseButton1Click:Connect(function() showPage(pages.Home) end)
btnFarm.MouseButton1Click:Connect(function() showPage(pages.Farm) end)
btnMission.MouseButton1Click:Connect(function() showPage(pages.Mission) end)
btnShop.MouseButton1Click:Connect(function() showPage(pages.Shop) end)
btnOther.MouseButton1Click:Connect(function() showPage(pages.Other) end)

-- Variáveis para controle de toggles
local toggles = {}

-- Helper para esperar Character e HRP
local function getCharacterAndHRP()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	return char, hrp
end

-- Função para atacar inimigos (exemplo)
local function attackEnemy(target)
	if target and target:FindFirstChild("HumanoidRootPart") then
		local _, hrp = getCharacterAndHRP()
		hrp.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
		pcall(function()
			ReplicatedStorage.Remotes.Skill1:FireServer()
		end)
	end
end

-- Funções automáticas resumidas

-- Auto Farm
toggles.autoFarm = false
spawn(function()
	while true do
		wait(0.5)
		if toggles.autoFarm then
			for _, enemy in pairs(workspace.Enemies:GetChildren()) do
				if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
					attackEnemy(enemy)
					wait(1)
				end
			end
		end
	end
end)

-- Auto Haki
toggles.autoHaki = false
spawn(function()
	while true do
		wait(5)
		if toggles.autoHaki then
			pcall(function()
				ReplicatedStorage.Remotes.Haki:FireServer()
			end)
		end
	end
end)

-- Auto Skills
toggles.autoSkills = false
spawn(function()
	while true do
		wait(3)
		if toggles.autoSkills then
			for _, skill in pairs({"Skill1", "Skill2", "Skill3"}) do
				pcall(function()
					ReplicatedStorage.Remotes[skill]:FireServer()
				end)
			end
		end
	end
end)

-- Auto Quest
toggles.autoQuest = false
spawn(function()
	while true do
		wait(10)
		if toggles.autoQuest then
			pcall(function()
				local questRemote = ReplicatedStorage:FindFirstChild("QuestRemote")
				if questRemote then
					questRemote:FireServer("GetQuest")
					questRemote:FireServer("CompleteQuest")
				end
			end)
		end
	end
end)

-- Auto Sell
toggles.autoSell = false
spawn(function()
	while true do
		wait(15)
		if toggles.autoSell then
			pcall(function()
				local sellRemote = ReplicatedStorage:FindFirstChild("SellRemote")
				if sellRemote then
					sellRemote:FireServer()
				end
			end)
		end
	end
end)

-- Auto Buy
toggles.autoBuy = false
spawn(function()
	while true do
		wait(20)
		if toggles.autoBuy then
			pcall(function()
				local shopRemote = ReplicatedStorage:FindFirstChild("ShopRemote")
				if shopRemote then
					shopRemote:FireServer("BuyAll")
				end
			end)
		end
	end
end)

-- Auto Rebirth
toggles.autoRebirth = false
spawn(function()
	while true do
		wait(60)
		if toggles.autoRebirth then
			pcall(function()
				local rebirthRemote = ReplicatedStorage:FindFirstChild("RebirthRemote")
				if rebirthRemote then
					rebirthRemote:FireServer()
				end
			end)
		end
	end
end)

-- Teleport para Boss (exemplo)
toggles.teleportBoss = false
local bossCFrame = CFrame.new(2000, 50, 2000) -- Ajuste conforme o mapa
spawn(function()
	while true do
		wait(5)
		if toggles.teleportBoss then
			local char, hrp = getCharacterAndHRP()
			hrp.CFrame = bossCFrame
		end
	end
end)

-- Criando toggles para cada aba

-- Farm
createToggle("Auto Farm", 10, pages.Farm, function(on) toggles.autoFarm = on end)
createToggle("Auto Haki", 60, pages.Farm, function(on) toggles.autoHaki = on end)
createToggle("Auto Skills", 110, pages.Farm, function(on) toggles.autoSkills = on end)

-- Missões/Itens
createToggle("Auto Quest", 10, pages.Mission, function(on) toggles.autoQuest = on end)
createToggle("Auto Sell", 60, pages.Mission, function(on) toggles.autoSell = on end)
createToggle("Auto Buy", 110, pages.Mission, function(on) toggles.autoBuy = on end)

-- Loja
createToggle("Auto Rebirth", 10, pages.Shop, function(on) toggles.autoRebirth = on end)

-- Outros
createToggle("Teleportar para Boss", 10, pages.Other, function(on) toggles.teleportBoss = on end)

-- Home (informações)
local homeLabel = Instance.new("TextLabel", pages.Home)
homeLabel.Size = UDim2.new(1, -20, 1, -20)
homeLabel.Position = UDim2.new(0, 10, 0, 10)
homeLabel.BackgroundTransparency = 1
homeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
homeLabel.TextWrapped = true
homeLabel.Font = Enum.Font.GothamBold
homeLabel.TextSize = 18
homeLabel.Text = [[
Bem-vindo ao Huzzy Hub!

Use as abas para ativar várias funções automáticas, como farm, missões, loja e muito mais.

Pressione Right Shift para abrir/fechar este menu.
]]

-- Drag para o frame principal
local dragging, dragInput, dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Botão minimizar
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		contentFrame.Visible = false
		menuFrame.Visible = false
		mainFrame.Size = UDim2.new(0, 200, 0, 40)
	else
		contentFrame.Visible = true
		menuFrame.Visible = true
		mainFrame.Size = UDim2.new(0, 480, 0, 380)
	end
end)

-- Toggle com tecla Right Shift para abrir/fechar o menu
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
		mainFrame.Visible = not mainFrame.Visible
	end
end)

print("Huzzy Hub carregado. Pressione Right Shift para abrir/fechar.")

