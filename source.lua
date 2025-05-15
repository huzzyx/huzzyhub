local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuração do farm
local Config = {
    AutoFarm = false,
    FlyHeight = 6,
    ClickInterval = 0.1,
}

-- Efeito de fundo (blur)
local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 10

-- GUI principal
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "LeopardFarmPanel"
gui.ResetOnSpawn = false

-- Painel principal
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0, 420, 0, 160)
panel.Position = UDim2.new(0.5, -210, 0.5, -80)
panel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
panel.BackgroundTransparency = 0.2
panel.AnchorPoint = Vector2.new(0.5, 0.5)

local panelCorner = Instance.new("UICorner", panel)
panelCorner.CornerRadius = UDim.new(0, 20)

local stroke = Instance.new("UIStroke", panel)
stroke.Color = Color3.fromRGB(90, 90, 90)
stroke.Thickness = 1.8

-- Título
local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🐆 Huzzy Hub | Maestria Leopard"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.FredokaOne
title.TextSize = 20
title.TextStrokeTransparency = 0.7

-- Status Dinâmico
local statusInfo = Instance.new("TextLabel", panel)
statusInfo.Position = UDim2.new(0, 20, 0, 50)
statusInfo.Size = UDim2.new(1, -40, 0, 25)
statusInfo.BackgroundTransparency = 1
statusInfo.Font = Enum.Font.Gotham
statusInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
statusInfo.TextSize = 14
statusInfo.Text = "Status: OFF | Alvo: N/A | Tempo ativo: 0s"

-- Botão visual toggle
local toggleFrame = Instance.new("Frame", panel)
toggleFrame.Position = UDim2.new(0, 20, 0, 90)
toggleFrame.Size = UDim2.new(0, 60, 0, 30)
toggleFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
local tfCorner = Instance.new("UICorner", toggleFrame)
tfCorner.CornerRadius = UDim.new(0, 15)

local toggleBtn = Instance.new("Frame", toggleFrame)
toggleBtn.Position = UDim2.new(0, 2, 0, 2)
toggleBtn.Size = UDim2.new(0, 26, 0, 26)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
local tbCorner = Instance.new("UICorner", toggleBtn)
tbCorner.CornerRadius = UDim.new(0, 13)

toggleBtn.Parent = toggleFrame

-- Botão clicável invisível
local toggleClick = Instance.new("TextButton", panel)
toggleClick.Size = toggleFrame.Size
toggleClick.Position = toggleFrame.Position
toggleClick.BackgroundTransparency = 1
toggleClick.Text = ""

-- Texto do botão
local toggleLabel = Instance.new("TextLabel", panel)
toggleLabel.Position = UDim2.new(0, 90, 0, 90)
toggleLabel.Size = UDim2.new(0, 200, 0, 30)
toggleLabel.BackgroundTransparency = 1
toggleLabel.Text = "Ativar Farm"
toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleLabel.Font = Enum.Font.GothamBold
toggleLabel.TextSize = 16
toggleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Variáveis
local farmAtivo = false
local tempoAtivo = 0

-- Funções visuais
local function atualizarPainel()
    statusInfo.Text = string.format("Status: %s | Alvo: %s | Tempo ativo: %ds",
        farmAtivo and "ON" or "OFF",
        Config.CurrentTarget or "N/A",
        tempoAtivo
    )
end

local function toggleVisual(on)
    local newPos = on and UDim2.new(0, 32, 0, 2) or UDim2.new(0, 2, 0, 2)
    local newColor = on and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    TweenService:Create(toggleBtn, TweenInfo.new(0.25), { Position = newPos, BackgroundColor3 = newColor }):Play()
    toggleLabel.Text = on and "Desativar Farm" or "Ativar Farm"
    atualizarPainel()
end

-- Lógica de farm
local function equiparFruta()
    local fruit = LocalPlayer.Backpack:FindFirstChild("Leopard Fruit")
    if fruit then
        LocalPlayer.Character.Humanoid:EquipTool(fruit)
    end
end

local function usarFruta()
    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then tool:Activate() end
end

local function voarSobreInimigo(inimigo)
    if not inimigo or not inimigo:FindFirstChild("HumanoidRootPart") then return end
    local bp = Instance.new("BodyPosition", HumanoidRootPart)
    bp.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bp.P = 1e4
    bp.D = 100
    bp.Position = inimigo.HumanoidRootPart.Position + Vector3.new(0, Config.FlyHeight, 0)
    delay(1.5, function() bp:Destroy() end)
end

-- Loop
spawn(function()
    while true do
        wait(1)
        if farmAtivo then
            tempoAtivo += 1
            local inimigos = workspace:FindFirstChild("Enemies") and workspace.Enemies:GetChildren() or {}
            if #inimigos > 0 then
                local alvo = inimigos[1]
                Config.CurrentTarget = alvo.Name
                equiparFruta()
                voarSobreInimigo(alvo)
                usarFruta()
            else
                Config.CurrentTarget = "N/A"
            end
        end
        atualizarPainel()
    end
end)

-- Clique no botão
toggleClick.MouseButton1Click:Connect(function()
    farmAtivo = not farmAtivo
    toggleVisual(farmAtivo)
    if not farmAtivo then tempoAtivo = 0 end
end)

-- Inicialização
toggleVisual(false)
