-- Huzzy Hub: Farm de Maestria para Leopard (Ultra Completo)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Mouse = LocalPlayer:GetMouse()

-- Interface
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "HuzzyFarmUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 260)
MainFrame.Position = UDim2.new(0, 30, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "🦁 Leopard Mastery Farm"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.FredokaOne
Title.TextSize = 18

-- Toggle
local Toggle = Instance.new("TextButton", MainFrame)
Toggle.Size = UDim2.new(0, 260, 0, 40)
Toggle.Position = UDim2.new(0, 20, 0, 50)
Toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle.Text = "🔴 Farm: OFF"
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 16

local isFarming = false

-- Checkboxes para Skills
local skillBinds = {
    Z = true,
    X = true,
    C = false,
    V = false,
}

local Y = 100
for skill, enabled in pairs(skillBinds) do
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 60, 0, 30)
    btn.Position = UDim2.new(0, 20 + ((#MainFrame:GetChildren() - 3) * 70), 0, Y)
    btn.BackgroundColor3 = enabled and Color3.fromRGB(70, 200, 70) or Color3.fromRGB(70, 70, 70)
    btn.Text = skill
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(function()
        skillBinds[skill] = not skillBinds[skill]
        btn.BackgroundColor3 = skillBinds[skill] and Color3.fromRGB(70, 200, 70) or Color3.fromRGB(70, 70, 70)
    end)
end

-- Utilidades
local function equipLeopard()
    for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.Name:lower():find("leopard") then
            LocalPlayer.Character.Humanoid:EquipTool(v)
        end
    end
end

local function attack()
    local VirtualInput = game:GetService("VirtualInputManager")
    VirtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    VirtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 0)

    for skill, use in pairs(skillBinds) do
        if use then
            keypress(Enum.KeyCode[skill])
            task.wait(0.2)
            keyrelease(Enum.KeyCode[skill])
        end
    end
end

-- Encontrar inimigos
local function getClosestEnemy()
    local minDist = math.huge
    local closest = nil
    for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
        if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            local dist = (HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
            if dist < minDist then
                minDist = dist
                closest = enemy
            end
        end
    end
    return closest
end

-- Loop de farm
Toggle.MouseButton1Click:Connect(function()
    isFarming = not isFarming
    Toggle.Text = isFarming and "🟢 Farm: ON" or "🔴 Farm: OFF"

    if isFarming then
        spawn(function()
            equipLeopard()
            while isFarming do
                local enemy = getClosestEnemy()
                if enemy and enemy:FindFirstChild("HumanoidRootPart") then
                    pcall(function()
                        local pos = enemy.HumanoidRootPart.Position + Vector3.new(0, 8, 0)
                        HumanoidRootPart.CFrame = CFrame.new(pos)
                        attack()
                    end)
                end
                wait(0.5)
            end
        end)
    end
end)
