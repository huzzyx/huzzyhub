-- Huzzy Hub completo para Blox Fruits
-- Interface com abas e funções integradas

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Criar GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HuzzyHubGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 480, 0, 360)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = ScreenGui

-- Função de drag
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

-- Título e fechar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
title.BorderSizePixel = 0
title.Text = "Huzzy Hub - Blox Fruits"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Parent = mainFrame

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
menuFrame.Size = UDim2.new(0, 140, 1, -40)
menuFrame.Position = UDim2.new(0, 0, 0, 40)
menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
menuFrame.BorderSizePixel = 0
menuFrame.Parent = mainFrame

-- Conteúdo
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -140, 1, -40)
contentFrame.Position = UDim2.new(0, 140, 0, 40)
contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Função para criar botões do menu
local function createMenuButton(text, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Parent = menuFrame
    return btn
end

-- Função para criar toggles na interface
local function createToggle(text, posY, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 280, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Text = "Ativar " .. text
    btn.Parent = parent
    return btn
end

-- Criação das páginas (frames)
local pages = {}

local function createPage()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = contentFrame
    return frame
end

local homePage = createPage()
local farmPage = createPage()
local missionPage = createPage()
local shopPage = createPage()
local otherPage = createPage()

pages.homePage = homePage
pages.farmPage = farmPage
pages.missionPage = missionPage
pages.shopPage = shopPage
pages.otherPage = otherPage

-- Mostrar uma página e esconder as outras
local function showPage(page)
    for _, v in pairs(pages) do
        v.Visible = false
    end
    page.Visible = true
end

-- Menu buttons
local homeBtn = createMenuButton("Home", 0)
local farmBtn = createMenuButton("Farm", 45)
local missionBtn = createMenuButton("Missões/Itens", 90)
local shopBtn = createMenuButton("Loja", 135)
local otherBtn = createMenuButton("Outros", 180)

homeBtn.MouseButton1Click:Connect(function() showPage(homePage) end)
farmBtn.MouseButton1Click:Connect(function() showPage(farmPage) end)
missionBtn.MouseButton1Click:Connect(function() showPage(missionPage) end)
shopBtn.MouseButton1Click:Connect(function() showPage(shopPage) end)
otherBtn.MouseButton1Click:Connect(function() showPage(otherPage) end)

showPage(homePage)

-- --- Conteúdo Home ---
local homeLabel = Instance.new("TextLabel")
homeLabel.Size = UDim2.new(1, -20, 0, 50)
homeLabel.Position = UDim2.new(0, 10, 0, 10)
homeLabel.BackgroundTransparency = 1
homeLabel.TextColor3 = Color3.new(1,1,1)
homeLabel.Font = Enum.Font.GothamBold
homeLabel.TextSize = 24
homeLabel.Text = "Bem-vindo ao Huzzy Hub!"
homeLabel.Parent = homePage

local homeInfo = Instance.new("TextLabel")
homeInfo.Size = UDim2.new(1, -20, 0, 100)
homeInfo.Position = UDim2.new(0, 10, 0, 70)
homeInfo.BackgroundTransparency = 1
homeInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
homeInfo.Font = Enum.Font.SourceSans
homeInfo.TextSize = 16
homeInfo.Text = "Use o menu lateral para navegar pelas abas.\nAtive ou desative as opções para controlar o jogo.\nDivirta-se!"
homeInfo.TextWrapped = true
homeInfo.Parent = homePage

-- Variáveis de controle das funções
local toggles = {
    autoFarm = false,
    autoHaki = false,
    autoSkills = false,
    autoQuest = false,
    autoSell = false,
    autoBuy = false,
    autoRebirth = false,
    teleportToBoss = false,
}

-- --- Conteúdo Farm ---

local autoFarmBtn = createToggle("Auto Farm", 10, farmPage)
local autoHakiBtn = createToggle("Auto Haki", 60, farmPage)
local autoSkillsBtn = createToggle("Auto Skills", 110, farmPage)

autoFarmBtn.MouseButton1Click:Connect(function()
    toggles.autoFarm = not toggles.autoFarm
    if toggles.autoFarm then
        autoFarmBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        autoFarmBtn.Text = "Desativar Auto Farm"
    else
        autoFarmBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        autoFarmBtn.Text = "Ativar Auto Farm"
    end
end)

autoHakiBtn.MouseButton1Click:Connect(function()
    toggles.autoHaki = not toggles.autoHaki
    if toggles.autoHaki then
        autoHakiBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        autoHakiBtn.Text = "Desativar Auto Haki"
    else
        autoHakiBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        autoHakiBtn.Text = "Ativar Auto Haki"
    end
end)

autoSkillsBtn.MouseButton1Click:Connect(function()
    toggles.autoSkills = not toggles.autoSkills
    if toggles.autoSkills then
        autoSkillsBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        autoSkillsBtn.Text = "Desativar Auto Skills"
    else
        autoSkillsBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        autoSkillsBtn.Text = "Ativar Auto Skills"
    end
end)

-- --- Conteúdo Missões/Itens ---

local autoQuestBtn = createToggle("Auto Quest", 10, missionPage)
local autoSellBtn = createToggle("Auto Sell", 60, missionPage)

autoQuestBtn.MouseButton1Click:Connect(function()
    toggles.autoQuest = not toggles.autoQuest
    if toggles.autoQuest then
        autoQuestBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        autoQuestBtn.Text = "Desativar Auto Quest"
    else
        autoQuestBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        autoQuestBtn.Text = "Ativar Auto Quest"
    end
end)

autoSellBtn.MouseButton1Click:Connect(function()
    toggles.autoSell = not toggles.autoSell
    if toggles.autoSell then
        autoSellBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        autoSellBtn.Text = "Desativar Auto Sell"
    else
        autoSellBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        autoSellBtn.Text = "Ativar Auto Sell"
    end
end)

-- --- Conteúdo Loja ---

local autoBuyBtn = createToggle("Auto Buy Weapons", 10, shopPage)

autoBuyBtn.MouseButton1Click:Connect(function()
    toggles.autoBuy = not toggles.autoBuy
    if toggles.autoBuy then
        autoBuyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        autoBuyBtn.Text = "Desativar Auto Buy"
    else
        autoBuyBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        autoBuyBtn.Text = "Ativar Auto Buy"
    end
end)

-- --- Conteúdo Outros ---

local autoRebirthBtn = createToggle("Auto Rebirth", 10, otherPage)
local teleportBossBtn = createToggle("Teleport to Boss", 60, otherPage)

autoRebirthBtn.MouseButton1Click:Connect(function()
    toggles.autoRebirth = not toggles.autoRebirth
    if toggles.autoRebirth then
        autoRebirthBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        autoRebirthBtn.Text = "Desativar Auto Rebirth"
    else
        autoRebirthBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        autoRebirthBtn.Text = "Ativar Auto Rebirth"
    end
end)

teleportBossBtn.MouseButton1Click:Connect(function()
    toggles.teleportToBoss = not toggles.teleportToBoss
    if toggles.teleportToBoss then
        teleportBossBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        teleportBossBtn.Text = "Desativar Teleport to Boss"
    else
        teleportBossBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        teleportBossBtn.Text = "Ativar Teleport to Boss"
    end
end)

-- FUNÇÕES REAIS DAS FEATURES

-- Função para atacar inimigos (exemplo simples)
local function attackEnemy(target)
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end
    local hrp = HumanoidRootPart
    hrp.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    -- Usar skill ou atacar normalmente
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Combat = ReplicatedStorage:WaitForChild("Combat")
    -- Exemplo: ativar skill 1 (pode variar)
    pcall(function()
        Combat:FireServer("Skill1")
    end)
end

-- Auto Farm básico (farm mobs na ilha atual)
local function autoFarm()
    spawn(function()
        while toggles.autoFarm do
            local enemies = workspace.Enemies:GetChildren()
            for _, enemy in pairs(enemies) do
                if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                    attackEnemy(enemy)
                    wait(1)
                end
            end
            wait(0.5)
        end
    end)
end

-- Auto Haki (usar haki sempre)
local function autoHaki()
    spawn(function()
        while toggles.autoHaki do
            pcall(function()
                -- Exemplo de comando para ativar haki
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                ReplicatedStorage.Remotes:WaitForChild("Haki"):FireServer()
            end)
            wait(5)
        end
    end)
end

-- Auto Skills (usar skills automaticamente)
local function autoSkills()
    spawn(function()
        while toggles.autoSkills do
            pcall(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                ReplicatedStorage.Remotes:WaitForChild("Skill1"):FireServer()
                ReplicatedStorage.Remotes:WaitForChild("Skill2"):FireServer()
                ReplicatedStorage.Remotes:WaitForChild("Skill3"):FireServer()
            end)
            wait(3)
        end
    end)
end

-- Auto Quest (pegar e completar quests automaticamente)
local function autoQuest()
    spawn(function()
        while toggles.autoQuest do
            pcall(function()
                local QuestRemote = ReplicatedStorage:FindFirstChild("QuestRemote")
                if QuestRemote then
                    QuestRemote:FireServer("GetQuest")
                    QuestRemote:FireServer("CompleteQuest")
                end
            end)
            wait(10)
        end
    end)
end

-- Auto Sell (vender itens automaticamente)
local function autoSell()
    spawn(function()
        while toggles.autoSell do
            pcall(function()
                local SellRemote = ReplicatedStorage:FindFirstChild("SellRemote")
                if SellRemote then
                    SellRemote:FireServer()
                end
            end)
            wait(15)
        end
    end)
end

-- Auto Buy (comprar armas automaticamente)
local function autoBuy()
    spawn(function()
        while toggles.autoBuy do
            pcall(function()
                local ShopRemote = ReplicatedStorage:FindFirstChild("ShopRemote")
                if ShopRemote then
                    ShopRemote:FireServer("BuyAll")
                end
            end)
            wait(20)
        end
    end)
end

-- Auto Rebirth
local function autoRebirth()
    spawn(function()
        while toggles.autoRebirth do
            pcall(function()
                local RebirthRemote = ReplicatedStorage:FindFirstChild("RebirthRemote")
                if RebirthRemote then
                    RebirthRemote:FireServer()
                end
            end)
            wait(60)
        end
    end)
end

-- Teleport para o Boss (exemplo)
local bossPosition = CFrame.new(2000, 50, 2000) -- Ajuste conforme o mapa

local function teleportToBoss()
    spawn(function()
        while toggles.teleportToBoss do
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = bossPosition
            end
            wait(5)
        end
    end)
end

-- Monitorar os toggles e ativar/desativar as funções
RunService.Heartbeat:Connect(function()
    if toggles.autoFarm and not _G.autoFarmRunning then
        _G.autoFarmRunning = true
        autoFarm()
    elseif not toggles.autoFarm then
        _G.autoFarmRunning = false
    end

    if toggles.autoHaki and not _G.autoHakiRunning then
        _G.autoHakiRunning = true
        autoHaki()
    elseif not toggles.autoHaki then
        _G.autoHakiRunning = false
    end

    if toggles.autoSkills and not _G.autoSkillsRunning then
        _G.autoSkillsRunning = true
        autoSkills()
    elseif not toggles.autoSkills then
        _G.autoSkillsRunning = false
    end

    if toggles.autoQuest and not _G.autoQuestRunning then
        _G.autoQuestRunning = true
        autoQuest()
    elseif not toggles.autoQuest then
        _G.autoQuestRunning = false
    end

    if toggles.autoSell and not _G.autoSellRunning then
        _G.autoSellRunning = true
        autoSell()
    elseif not toggles.autoSell then
        _G.autoSellRunning = false
    end

    if toggles.autoBuy and not _G.autoBuyRunning then
        _G.autoBuyRunning = true
        autoBuy()
    elseif not toggles.autoBuy then
        _G.autoBuyRunning = false
    end

    if toggles.autoRebirth and not _G.autoRebirthRunning then
        _G.autoRebirthRunning = true
        autoRebirth()
    elseif not toggles.autoRebirth then
        _G.autoRebirthRunning = false
    end

    if toggles.teleportToBoss and not _G.teleportBossRunning then
        _G.teleportBossRunning = true
        teleportToBoss()
    elseif not toggles.teleportToBoss then
        _G.teleportBossRunning = false
    end
end)
