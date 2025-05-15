-- Huzzy Hub - Script completo para Blox Fruits

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- Interface
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "HuzzyHub"

local mainFrame = Instance.new("Frame", ScreenGui)
mainFrame.Size = UDim2.new(0, 480, 0, 380)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -190)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.ClipsDescendants = true
mainFrame.Visible = true

local uicorner = Instance.new("UICorner", mainFrame)
uicorner.CornerRadius = UDim.new(0, 15)

local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

local topBarCorner = Instance.new("UICorner", topBar)
topBarCorner.CornerRadius = UDim.new(0, 15)

local titleLabel = Instance.new("TextLabel", topBar)
titleLabel.Size = UDim2.new(1, -20, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Huzzy Hub"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextYAlignment = Enum.TextYAlignment.Center

local menuFrame = Instance.new("Frame", mainFrame)
menuFrame.Size = UDim2.new(0, 140, 1, -40)
menuFrame.Position = UDim2.new(0, 0, 0, 40)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local menuCorner = Instance.new("UICorner", menuFrame)
menuCorner.CornerRadius = UDim.new(0, 15)

local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -140, 1, -40)
contentFrame.Position = UDim2.new(0, 140, 0, 40)
contentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local contentCorner = Instance.new("UICorner", contentFrame)
contentCorner.CornerRadius = UDim.new(0, 15)

local pages = {}
local buttons = {}

function createPage(name)
    local page = Instance.new("ScrollingFrame", contentFrame)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.CanvasSize = UDim2.new(0, 0, 0, 500)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 8
    pages[name] = page
    return page
end

function createButton(name, page)
    local button = Instance.new("TextButton", menuFrame)
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.Text = name
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 16
    local uibtncorner = Instance.new("UICorner", button)
    uibtncorner.CornerRadius = UDim.new(0, 8)
    
    button.MouseButton1Click:Connect(function()
        for _, pg in pairs(pages) do pg.Visible = false end
        page.Visible = true
        mainFrame.Visible = not mainFrame.Visible
    end)
end

-- Páginas
local homePage = createPage("Home")
local lojaPage = createPage("Loja")
pages["Home"] = homePage
pages["Loja"] = lojaPage

-- Botões
createButton("Home", homePage)
createButton("Loja", lojaPage)

-- Textos da página Home
local homeText = Instance.new("TextLabel", homePage)
homeText.Size = UDim2.new(1, -20, 0, 200)
homeText.Position = UDim2.new(0, 10, 0, 10)
homeText.BackgroundTransparency = 1
homeText.TextColor3 = Color3.new(1, 1, 1)
homeText.TextWrapped = true
homeText.TextYAlignment = Enum.TextYAlignment.Top
homeText.Font = Enum.Font.Gotham
homeText.TextSize = 16
homeText.Text = [[
Huzzy Hub - Script Blox Fruits
Use o menu à esquerda para navegar pelas funções.
Clique em "Home" para esconder/exibir o menu.
]]

-- Funções Loja
local function createLojaButton(text, callback)
    local btn = Instance.new("TextButton", lojaPage)
    btn.Size = UDim2.new(0, 280, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, #lojaPage:GetChildren() * 45)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    local uic = Instance.new("UICorner", btn)
    uic.CornerRadius = UDim.new(0, 10)
    btn.MouseButton1Click:Connect(callback)
end

createLojaButton("Comprar Fruta Aleatória", function()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyRandomFruit", true)
end)

createLojaButton("Pegar Frutas no Mapa", function()
    for _, fruit in pairs(Workspace:GetDescendants()) do
        if fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
            fruit.Handle.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end)

createLojaButton("Armazenar Todas Frutas", function()
    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
        if item:IsA("Tool") and string.find(item.Name, "Fruit") then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", item.Name)
        end
    end
end)

-- Toggle interface com tecla RightShift
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- Dragging
local dragging = false
local dragInput, mousePos, framePos

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - mousePos
        mainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)
