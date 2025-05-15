-- 🦁 Huzzy Hub - Mastery Farm para Leopard (Terceiro Mar)
-- Requer: Fruta Leopard equipada e habilidades desbloqueadas

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualInput = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local Player = Players.LocalPlayer

-- Interface
local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
ScreenGui.Name = "LeopardFarmUI"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 320, 0, 230)
Frame.Position = UDim2.new(0, 20, 0.5, -115)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Frame.BorderSizePixel = 0
local corner = Instance.new("UICorner", Frame)
corner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "🦁 Huzzy - Farm de Maestria (Leopard)"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.BackgroundTransparency = 1

-- Status
local Status = Instance.new("TextLabel", Frame)
Status.Position = UDim2.new(0, 0, 0, 35)
Status.Size = UDim2.new(1, 0, 0, 20)
Status.Text = "Status: ⛔ Desligado"
Status.TextColor3 = Color3.new(1, 0.4, 0.4)
Status.Font = Enum.Font.Gotham
Status.TextSize = 14
Status.BackgroundTransparency = 1

-- Checkboxes para habilidades
local skillUse = {
    Z = true,
    X = false,
    C = false,
    V = false
}

local function createCheckbox(parent, key, yPos)
    local box = Instance.new("TextButton", parent)
    box.Size = UDim2.new(0, 150, 0, 25)
    box.Position = UDim2.new(0, 10, 0, yPos)
    box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    box.Text = "[✅] Usar " .. key
    box.TextColor3 = Color3.new(1, 1, 1)
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.MouseButton1Click:Connect(function()
        skillUse[key] = not skillUse[key]
        box.Text = skillUse[key] and "[✅] Usar " .. key or "[❌] Usar " .. key
    end)
end

createCheckbox(Frame, "Z", 65)
createCheckbox(Frame, "X", 95)
createCheckbox(Frame, "C", 125)
createCheckbox(Frame, "V", 155)

-- Botão de ativar
local toggle = false
local ToggleBtn = Instance.new("TextButton", Frame)
ToggleBtn.Position = UDim2.new(0, 10, 0, 190)
ToggleBtn.Size = UDim2.new(0, 300, 0, 30)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
ToggleBtn.Text = "▶️ Iniciar Farm"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14

-- Função de ataque
local function usarSkills()
    for key, usar in pairs(skillUse) do
        if usar then
            VirtualInput:SendKeyEvent(true, key, false, game)
            wait(0.1)
            VirtualInput:SendKeyEvent(false, key, false, game)
            wait(1)
        end
    end
end

-- Função de farm
local function iniciarFarm()
    while toggle do
        local enemies = Workspace.Enemies:GetChildren()
        for _, npc in pairs(enemies) do
            if npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                pcall(function()
                    -- Move para cima do inimigo
                    Player.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame + Vector3.new(0, 20, 0)
                    usarSkills()
                end)
                wait(0.5)
            end
        end
        wait(1)
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    toggle = not toggle
    if toggle then
        Status.Text = "Status: ✅ Ativado"
        Status.TextColor3 = Color3.fromRGB(0, 255, 0)
        ToggleBtn.Text = "⛔ Parar Farm"
        iniciarFarm()
    else
        Status.Text = "Status: ⛔ Desligado"
        Status.TextColor3 = Color3.fromRGB(255, 100, 100)
        ToggleBtn.Text = "▶️ Iniciar Farm"
    end
end)
