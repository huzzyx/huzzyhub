local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = nil
local HumanoidRootPart = nil

local Config = {
    AutoFarmMastery = false,
    AutoClick = true,
    FlyOnHead = true,
    FlyHeight = 5,
    ClickInterval = 0.1,
    SelectedFruit = "Leopard",
}

local function updateCharacter()
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end

updateCharacter()
LocalPlayer.CharacterAdded:Connect(updateCharacter)

-- Equipar fruta Leopard
local function equipFruit(fruitName)
    if not Character then return end
    local tool = Character:FindFirstChildOfClass("Tool")
    if tool and tool.Name == fruitName then return end
    local backpack = LocalPlayer:WaitForChild("Backpack")
    local fruit = backpack:FindFirstChild(fruitName)
    if fruit then fruit.Parent = Character end
end

local function useFruit()
    if not Character then return end
    local tool = Character:FindFirstChildOfClass("Tool")
    if tool then tool:Activate() end
end

local function getEnemies()
    local enemies = {}
    if Workspace:FindFirstChild("Enemies") then
        for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
            local humanoid = enemy:FindFirstChildOfClass("Humanoid")
            local root = enemy:FindFirstChild("HumanoidRootPart")
            if humanoid and humanoid.Health > 0 and root then
                table.insert(enemies, enemy)
            end
        end
    end
    return enemies
end

local function flyOnEnemyHead(enemy)
    if not enemy or not enemy:FindFirstChild("HumanoidRootPart") or not HumanoidRootPart then return end
    local pos = enemy.HumanoidRootPart.Position + Vector3.new(0, Config.FlyHeight, 0)
    HumanoidRootPart.CFrame = CFrame.new(pos)
end

local autoFarmThread
local function startAutoFarmMastery()
    if autoFarmThread then return end
    autoFarmThread = coroutine.create(function()
        while Config.AutoFarmMastery do
            local enemies = getEnemies()
            if #enemies > 0 and Character and HumanoidRootPart then
                local target = enemies[1]
                equipFruit(Config.SelectedFruit)
                if Config.FlyOnHead then flyOnEnemyHead(target) end
                if Config.AutoClick then
                    useFruit()
                    wait(Config.ClickInterval)
                else
                    wait(0.5)
                end
            else
                wait(1)
            end
        end
    end)
    coroutine.resume(autoFarmThread)
end

local function stopAutoFarmMastery()
    Config.AutoFarmMastery = false
    autoFarmThread = nil
end

-- GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "HuzzyHubAutoFarmLeopard"

local mainFrame = Instance.new("Frame", ScreenGui)
mainFrame.Size = UDim2.new(0, 260, 0, 130)
mainFrame.Position = UDim2.new(0, 20, 0.5, -65)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.AnchorPoint = Vector2.new(0, 0.5)
mainFrame.Active = true
mainFrame.Draggable = true
local uicorner = Instance.new("UICorner", mainFrame)
uicorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "🥭 Huzzy Hub - Auto Farm Leopard"
title.Font = Enum.Font.FredokaOne
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Center

local statusLabel = Instance.new("TextLabel", mainFrame)
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 45)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: OFF"
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 16
statusLabel.TextColor3 = Color3.fromRGB(200, 50, 50)
statusLabel.TextXAlignment = Enum.TextXAlignment.Center

local toggleButton = Instance.new("TextButton", mainFrame)
toggleButton.Size = UDim2.new(0, 90, 0, 40)
toggleButton.Position = UDim2.new(0.5, -45, 1, -45)
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 16
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "LIGAR"

local toggleSwitch = Instance.new("Frame", toggleButton)
toggleSwitch.Size = UDim2.new(0, 40, 0, 20)
toggleSwitch.Position = UDim2.new(0, 5, 0.5, -10)
toggleSwitch.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
toggleSwitch.BorderSizePixel = 0
toggleSwitch.AnchorPoint = Vector2.new(0, 0.5)
local switchCorner = Instance.new("UICorner", toggleSwitch)
switchCorner.CornerRadius = UDim.new(0, 10)

local switchCircle = Instance.new("Frame", toggleSwitch)
switchCircle.Size = UDim2.new(0, 18, 0, 18)
switchCircle.Position = UDim2.new(0, 2, 0.5, -9)
switchCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
switchCircle.BorderSizePixel = 0
switchCircle.AnchorPoint = Vector2.new(0, 0.5)
local circleCorner = Instance.new("UICorner", switchCircle)
circleCorner.CornerRadius = UDim.new(1, 0)

local function setToggleState(on)
    if on then
        statusLabel.Text = "Status: ON"
        statusLabel.TextColor3 = Color3.fromRGB(50, 200, 50)
        toggleButton.Text = "DESLIGAR"
        toggleSwitch.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        switchCircle.Position = UDim2.new(0, 20, 0.5, -9)
    else
        statusLabel.Text = "Status: OFF"
        statusLabel.TextColor3 = Color3.fromRGB(200, 50, 50)
        toggleButton.Text = "LIGAR"
        toggleSwitch.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        switchCircle.Position = UDim2.new(0, 2, 0.5, -9)
    end
end

toggleButton.MouseButton1Click:Connect(function()
    Config.AutoFarmMastery = not Config.AutoFarmMastery
    if Config.AutoFarmMastery then
        startAutoFarmMastery()
    else
        stopAutoFarmMastery()
    end
    setToggleState(Config.AutoFarmMastery)
end)

-- Inicializa estado
setToggleState(false)

print("Huzzy Hub Auto Farm Leopard iniciado! Use o painel para ligar/desligar.")
