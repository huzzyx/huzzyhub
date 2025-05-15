-- Huzzy Hub - Script completo para Blox Fruits com melhorias avançadas

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- Interface
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "HuzzyHub"
ScreenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", ScreenGui)
mainFrame.Size = UDim2.new(0, 520, 0, 420)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -210)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Visible = true

local uicorner = Instance.new("UICorner", mainFrame)
uicorner.CornerRadius = UDim.new(0, 15)

local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local topBarCorner = Instance.new("UICorner", topBar)
topBarCorner.CornerRadius = UDim.new(0, 15)

local titleLabel = Instance.new("TextLabel", topBar)
titleLabel.Size = UDim2.new(1, -20, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🥭 Huzzy Hub - Blox Fruits"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.FredokaOne
titleLabel.TextSize = 20
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local menuFrame = Instance.new("Frame", mainFrame)
menuFrame.Size = UDim2.new(0, 150, 1, -40)
menuFrame.Position = UDim2.new(0, 0, 0, 40)
menuFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
local menuCorner = Instance.new("UICorner", menuFrame)
menuCorner.CornerRadius = UDim.new(0, 15)

local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -150, 1, -40)
contentFrame.Position = UDim2.new(0, 150, 0, 40)
contentFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
local contentCorner = Instance.new("UICorner", contentFrame)
contentCorner.CornerRadius = UDim.new(0, 15)

local pages, buttons = {}, {}

function createPage(name)
    local page = Instance.new("ScrollingFrame", contentFrame)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.CanvasSize = UDim2.new(0, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 6
    pages[name] = page
    return page
end

function createButton(name, page)
    local button = Instance.new("TextButton", menuFrame)
    button.Size = UDim2.new(1, -10, 0, 35)
    button.Position = UDim2.new(0, 5, 0, #menuFrame:GetChildren() * 38)
    button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 15
    local uibtncorner = Instance.new("UICorner", button)
    uibtncorner.CornerRadius = UDim.new(0, 8)
    button.MouseButton1Click:Connect(function()
        for _, pg in pairs(pages) do pg.Visible = false end
        page.Visible = true
    end)
end

-- Criar páginas
local homePage = createPage("Home")
local lojaPage = createPage("Loja")
local farmPage = createPage("Farm")
local telePage = createPage("Teleport")
local questPage = createPage("Missoes")

-- Criar botões
createButton("🏠 Home", homePage)
createButton("🍉 Loja", lojaPage)
createButton("⚔️ Farm", farmPage)
createButton("🧭 Teleport", telePage)
createButton("📜 Missoes", questPage)

-- Funções loja
local function createLojaButton(text, callback)
    local btn = Instance.new("TextButton", lojaPage)
    btn.Size = UDim2.new(0, 300, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, #lojaPage:GetChildren() * 45)
    btn.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    local uic = Instance.new("UICorner", btn)
    uic.CornerRadius = UDim.new(0, 10)
    btn.MouseButton1Click:Connect(callback)
end

createLojaButton("🎲 Comprar Fruta Aleatória", function()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyRandomFruit", true)
end)

createLojaButton("🌍 Pegar Frutas do Mapa", function()
    for _, fruit in pairs(Workspace:GetDescendants()) do
        if fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
            fruit.Handle.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end)

createLojaButton("📦 Armazenar Todas Frutas", function()
    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
        if item:IsA("Tool") and string.find(item.Name, "Fruit") then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", item.Name)
        end
    end
end)

-- Exemplo simples de Farm automático
local autoFarm = false
local function toggleAutoFarm()
    autoFarm = not autoFarm
    if autoFarm then
        spawn(function()
            while autoFarm do
                local enemies = Workspace.Enemies:GetChildren()
                for _, enemy in ipairs(enemies) do
                    if enemy:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                        wait(0.2)
                    end
                end
                wait(1)
            end
        end)
    end
end

local farmBtn = Instance.new("TextButton", farmPage)
farmBtn.Size = UDim2.new(0, 300, 0, 40)
farmBtn.Position = UDim2.new(0, 10, 0, 10)
farmBtn.Text = "⚔️ Toggle Auto Farm"
farmBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
farmBtn.TextColor3 = Color3.new(1, 1, 1)
farmBtn.Font = Enum.Font.Gotham
farmBtn.TextSize = 14
farmBtn.MouseButton1Click:Connect(toggleAutoFarm)

-- Toggle com tecla Home
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Home then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- Drag para mover
local dragging, dragInput, mousePos, framePos = false, nil, nil, nil
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - mousePos
        mainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)
