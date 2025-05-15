-- Huzzy Hub - Interface moderna com categorias e toggles

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Cria a GUI base
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HuzzyHubGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Frame principal (janela)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 300)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = ScreenGui

-- Função para tornar frame arrastável
local dragging
local dragInput
local dragStart
local startPos

local function updatePosition(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

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
        updatePosition(input)
    end
end)

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
title.BorderSizePixel = 0
title.Text = "Huzzy Hub - Blox Fruits"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Parent = mainFrame

-- Botão fechar
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.Parent = mainFrame

closeBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Menu lateral
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 120, 1, -40)
menuFrame.Position = UDim2.new(0, 0, 0, 40)
menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
menuFrame.BorderSizePixel = 0
menuFrame.Parent = mainFrame

local pages = {}

local function createMenuButton(name, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Parent = menuFrame
    return btn
end

-- Conteúdo das abas (painel principal)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -120, 1, -40)
contentFrame.Position = UDim2.new(0, 120, 0, 40)
contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Função para criar toggle buttons dentro das abas
local function createToggle(name, position, parent, state)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 250, 0, 35)
    btn.Position = position
    btn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Text = (state and "Desativar " or "Ativar ") .. name
    btn.Parent = parent
    return btn
end

-- Configurações iniciais e salvamento
local HttpService = game:GetService("HttpService")

local function saveConfig(config)
    if writefile then
        writefile("HuzzyHubConfig.txt", HttpService:JSONEncode(config))
    end
end

local function loadConfig()
    if readfile then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile("HuzzyHubConfig.txt"))
        end)
        if success then return data end
    end
    return {}
end

local config = loadConfig()
config.autoFarm = config.autoFarm or false
config.autoHaki = config.autoHaki or false
config.autoSkills = config.autoSkills or false

-- Criar páginas
local homePage = Instance.new("Frame")
homePage.Size = UDim2.new(1, 0, 1, 0)
homePage.BackgroundTransparency = 1
homePage.Visible = true
homePage.Parent = contentFrame

local farmPage = Instance.new("Frame")
farmPage.Size = UDim2.new(1, 0, 1, 0)
farmPage.BackgroundTransparency = 1
farmPage.Visible = false
farmPage.Parent = contentFrame

local teleportPage = Instance.new("Frame")
teleportPage.Size = UDim2.new(1, 0, 1, 0)
teleportPage.BackgroundTransparency = 1
teleportPage.Visible = false
teleportPage.Parent = contentFrame

pages = {homePage, farmPage, teleportPage}

-- Menu buttons
local homeBtn = createMenuButton("Home", 0)
local farmBtn = createMenuButton("Farm", 45)
local teleportBtn = createMenuButton("Teleport", 90)

local function setPage(page)
    for _, p in pairs(pages) do
        p.Visible = false
    end
    page.Visible = true
end

homeBtn.MouseButton1Click:Connect(function() setPage(homePage) end)
farmBtn.MouseButton1Click:Connect(function() setPage(farmPage) end)
teleportBtn.MouseButton1Click:Connect(function() setPage(teleportPage) end)

-- Conteúdo Home
local welcomeLabel = Instance.new("TextLabel")
welcomeLabel.Size = UDim2.new(1, -20, 0, 50)
welcomeLabel.Position = UDim2.new(0, 10, 0, 10)
welcomeLabel.BackgroundTransparency = 1
welcomeLabel.TextColor3 = Color3.new(1,1,1)
welcomeLabel.Font = Enum.Font.GothamBold
welcomeLabel.TextSize = 24
welcomeLabel.Text = "Bem-vindo ao Huzzy Hub!"
welcomeLabel.Parent = homePage

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 0, 100)
infoLabel.Position = UDim2.new(0, 10, 0, 70)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.Font = Enum.Font.SourceSans
infoLabel.TextSize = 16
infoLabel.Text = "Use as abas para navegar pelas funções do hub.\nAtive ou desative as opções nas abas específicas."
infoLabel.TextWrapped = true
infoLabel.Parent = homePage

-- Conteúdo Farm
local autoFarmBtn = createToggle("Auto Farm", UDim2.new(0, 10, 0, 10), farmPage, config.autoFarm)
local autoHakiBtn = createToggle("Auto Haki", UDim2.new(0, 10, 0, 60), farmPage, config.autoHaki)
local autoSkillsBtn = createToggle("Auto Skills", UDim2.new(0, 10, 0, 110), farmPage, config.autoSkills)

-- Toggle handlers Farm
autoFarmBtn.MouseButton1Click:Connect(function()
    config.autoFarm = not config.autoFarm
    autoFarmBtn.BackgroundColor3 = config.autoFarm and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    autoFarmBtn.Text = (config.autoFarm and "Desativar " or "Ativar ") .. "Auto Farm"
    saveConfig(config)
end)

autoHakiBtn.MouseButton1Click:Connect(function()
    config.autoHaki = not config.autoHaki
    autoHakiBtn.BackgroundColor3 = config.autoHaki and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    autoHakiBtn.Text = (config.autoHaki and "Desativar " or "Ativar ") .. "Auto Haki"
    saveConfig(config)
end)

autoSkillsBtn.MouseButton1Click:Connect(function()
    config.autoSkills = not config.autoSkills
    autoSkillsBtn.BackgroundColor3 = config.autoSkills and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    autoSkillsBtn.Text = (config.autoSkills and "Desativar " or "Ativar ") .. "Auto Skills"
    saveConfig(config)
end)

-- Conteúdo Teleport
local teleports = {
    ["Starter Island"] = CFrame.new(930, 27, 1035),
    ["Second Island"] = CFrame.new(2500, 27, 2500),
    ["Third Island"] = CFrame.new(4200, 27, 3000),
}

local yPos = 10
for name, cf in pairs(teleports) do
    local tpBtn = Instance.new("TextButton")
    tpBtn.Size = UDim2.new(0, 300, 0, 35)
    tpBtn.Position = UDim2.new(0, 10, 0, yPos)
    tpBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 170)
    tpBtn.TextColor3 = Color3.new(1,1,1)
    tpBtn.Font = Enum.Font.GothamBold
    tpBtn.TextSize = 18
    tpBtn.Text = "Teleportar: " .. name
    tpBtn.Parent = teleportPage

    tpBtn.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = cf
        end
    end)

    yPos = yPos + 45
end
