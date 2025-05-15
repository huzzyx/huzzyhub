-- Huzzy Hub - Script COMPLETO para Blox Fruits
-- Criado para ser funcional, bonito e avançado
-- Com base no Redz Hub, mas melhorado!

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- Configurações internas
local autoFarmEnabled = false
local autoQuestEnabled = false
local autoBuyFruitEnabled = false
local autoCollectFruitEnabled = false
local autoStoreFruitEnabled = false
local autoStatsEnabled = false
local autoAbilitiesEnabled = false

local farmTarget = nil
local farmWeapon = "Sword" -- Pode ser "Melee", "Sword", "Gun", "Fruit"
local questName = ""
local currentSea = "First Sea"

-- Lista frutas poderosas (exemplo, ajustar conforme jogo)
local powerfulFruits = {
    "Dragon Fruit",
    "Light Fruit",
    "Dark Fruit",
    "Phoenix Fruit",
    "Bomb Fruit",
    "Dough Fruit",
    "Rubber Fruit",
    "Chop Fruit",
    "Spring Fruit",
    "Venom Fruit",
    "Spin Fruit",
    "Flame Fruit",
    "Ice Fruit",
    "Barrier Fruit",
    "Gravity Fruit",
    "Kilo Fruit",
    "Paw Fruit",
    "Quake Fruit",
    "Smoke Fruit",
    "Diamond Fruit",
    "Control Fruit",
    "Rubber Fruit"
}

-- Função para criar a interface arredondada e dragável
local function createUI()
    -- ScreenGui
    local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    screenGui.Name = "HuzzyHub"
    screenGui.ResetOnSpawn = false

    -- Main Frame
    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 540, 0, 460)
    mainFrame.Position = UDim2.new(0.5, -270, 0.5, -230)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    local mainUICorner = Instance.new("UICorner", mainFrame)
    mainUICorner.CornerRadius = UDim.new(0, 20)

    -- Dragging Variables
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

    -- Top Bar
    local topBar = Instance.new("Frame", mainFrame)
    topBar.Size = UDim2.new(1, 0, 0, 45)
    topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    local topUICorner = Instance.new("UICorner", topBar)
    topUICorner.CornerRadius = UDim.new(0, 20)

    local titleLabel = Instance.new("TextLabel", topBar)
    titleLabel.Size = UDim2.new(1, -20, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🥭 Huzzy Hub - Blox Fruits"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.FredokaOne
    titleLabel.TextSize = 22
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Menu (abas)
    local menuFrame = Instance.new("Frame", mainFrame)
    menuFrame.Size = UDim2.new(0, 140, 1, -45)
    menuFrame.Position = UDim2.new(0, 0, 0, 45)
    menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    local menuCorner = Instance.new("UICorner", menuFrame)
    menuCorner.CornerRadius = UDim.new(0, 20)

    -- Container para conteúdo
    local contentFrame = Instance.new("Frame", mainFrame)
    contentFrame.Size = UDim2.new(1, -140, 1, -45)
    contentFrame.Position = UDim2.new(0, 140, 0, 45)
    contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    local contentCorner = Instance.new("UICorner", contentFrame)
    contentCorner.CornerRadius = UDim.new(0, 20)

    -- Abas e páginas
    local pages = {}
    local buttons = {}

    -- Função para criar páginas
    local function createPage(name)
        local page = Instance.new("ScrollingFrame", contentFrame)
        page.Name = name .. "Page"
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.ScrollBarThickness = 6
        page.CanvasSize = UDim2.new(0, 0, 2, 0)
        pages[name] = page
        return page
    end

    -- Função para criar botão do menu
    local function createMenuButton(name, emoji, page)
        local btn = Instance.new("TextButton", menuFrame)
        btn.Size = UDim2.new(1, -20, 0, 45)
        btn.Position = UDim2.new(0, 10, 0, (#menuFrame:GetChildren() - 2) * 50) -- ignorando UICorner e Border
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.FredokaOne
        btn.TextSize = 18
        btn.AutoButtonColor = false
        btn.Text = emoji .. " " .. name
        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 15)
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
        end)
        btn.MouseLeave:Connect(function()
            if page.Visible then return end
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)
        btn.MouseButton1Click:Connect(function()
            for _, p in pairs(pages) do
                p.Visible = false
            end
            page.Visible = true
            -- Update menu button colors
            for _, b in pairs(menuFrame:GetChildren()) do
                if b:IsA("TextButton") then
                    b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                end
            end
            btn.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
        end)
        buttons[#buttons+1] = btn
        return btn
    end

    -- Criar páginas
    local homePage = createPage("Home")
    local lojaPage = createPage("Loja")
    local farmPage = createPage("Farm")
    local telePage = createPage("Teleport")
    local questPage = createPage("Missoes")
    local outrosPage = createPage("Outros")

    -- Criar botões do menu
    createMenuButton("Home", "🏠", homePage)
    createMenuButton("Loja", "🍉", lojaPage)
    createMenuButton("Farm", "⚔️", farmPage)
    createMenuButton("Teleport", "🧭", telePage)
    createMenuButton("Missões", "📜", questPage)
    createMenuButton("Outros", "⚙️", outrosPage)

    -- Mostrar Home por padrão
    homePage.Visible = true
    buttons[1].BackgroundColor3 = Color3.fromRGB(65,65,65)

    -- Função para criar botão dentro de páginas
    local function createPageButton(parent, text, positionY, callback, toggle)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 400, 0, 40)
        btn.Position = UDim2.new(0, 10, 0, positionY)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.FredokaOne
        btn.TextSize = 16
        btn.Text = text
        btn.AutoButtonColor = true
        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0, 10)
        if toggle then
            btn.Text = text .. " [OFF]"
            btn.MouseButton1Click:Connect(function()
                toggle = not toggle
                if toggle then
                    btn.Text = text .. " [ON]"
                else
                    btn.Text = text .. " [OFF]"
                end
                callback(toggle)
            end)
        else
            btn.MouseButton1Click:Connect(callback)
        end
        return btn
    end

    ------------------------
    -- Home Page Conteúdo --
    ------------------------
    local homeLabel = Instance.new("TextLabel", homePage)
    homeLabel.Size = UDim2.new(1, -20, 0, 50)
    homeLabel.Position = UDim2.new(0, 10, 0, 10)
    homeLabel.BackgroundTransparency = 1
    homeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    homeLabel.Font = Enum.Font.FredokaOne
    homeLabel.TextSize = 24
    homeLabel.Text = "Bem-vindo ao Huzzy Hub!"
    homeLabel.TextXAlignment = Enum.TextXAlignment.Left

    local homeDesc = Instance.new("TextLabel", homePage)
    homeDesc.Size = UDim2.new(1, -20, 0, 120)
    homeDesc.Position = UDim2.new(0, 10, 0, 60)
    homeDesc.BackgroundTransparency = 1
    homeDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
    homeDesc.Font = Enum.Font.Gotham
    homeDesc.TextSize = 16
    homeDesc.TextWrapped = true
    homeDesc.Text = [[
Este script foi criado para trazer todas as funcionalidades essenciais do Redz Hub,
mais funcionalidades avançadas como auto farm completo, auto quest, auto compra e armazenamento
de frutas poderosas, teleports, auto stats, e muito mais.

Use as abas ao lado para navegar pelas funcionalidades.

Use com cuidado e divirta-se!]]
    homeDesc.TextXAlignment = Enum.TextXAlignment.Left

    ------------------------
    -- Loja Page Conteúdo --
    ------------------------
    local lojaY = 10
    -- Comprar fruta aleatória (toggle)
    local buyRandomFruitBtn = createPageButton(lojaPage, "Comprar Fruta Aleatória", lojaY, function(on)
        autoBuyFruitEnabled = on
        if on then
            spawn(function()
                while autoBuyFruitEnabled do
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyRandomFruit", true)
                    wait(5)
                end
            end)
        end
    end, true)
    lojaY = lojaY + 50

    -- Pegar frutas do mapa (toggle)
    local collectFruitBtn = createPageButton(lojaPage, "Coletar Frutas do Mapa", lojaY, function(on)
        autoCollectFruitEnabled = on
        if on then
            spawn(function()
                while autoCollectFruitEnabled do
                    for _, fruit in pairs(Workspace:GetChildren()) do
                        if fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
                            fruit.Handle.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                        end
                    end
                    wait(2)
                end
            end)
        end
    end, true)
    lojaY = lojaY + 50

    -- Armazenar frutas (toggle)
    local storeFruitBtn = createPageButton(lojaPage, "Armazenar Todas as Frutas", lojaY, function(on)
        autoStoreFruitEnabled = on
        if on then
            spawn(function()
                while autoStoreFruitEnabled do
                    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
                        if item:IsA("Tool") and table.find(powerfulFruits, item.Name) then
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", item.Name)
                        end
                    end
                    wait(5)
                end
            end)
        end
    end, true)
    lojaY = lojaY + 50

    -- Botão para comprar frutas específicas
    for i, fruitName in ipairs(powerfulFruits) do
        local btn = createPageButton(lojaPage, "Comprar " .. fruitName, lojaY, function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyFruit", fruitName)
        end)
        lojaY = lojaY + 45
    end

    ------------------------
    -- Farm Page Conteúdo --
    ------------------------
    local farmY = 10

    -- Toggle Auto Farm
    local autoFarmBtn = createPageButton(farmPage, "Ativar Auto Farm", farmY, function(on)
        autoFarmEnabled = on
        if on then
            spawn(function()
                while autoFarmEnabled do
                    -- Definir alvo principal
                    local enemies = {}
                    if Workspace:FindFirstChild("Enemies") then
                        enemies = Workspace.Enemies:GetChildren()
                    end

                    if #enemies > 0 then
                        -- Alvo: o primeiro inimigo vivo
                        for _, enemy in pairs(enemies) do
                            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid") and enemy:FindFirstChildOfClass("Humanoid").Health > 0 then
                                farmTarget = enemy
                                break
                            end
                        end
                    else
                        farmTarget = nil
                    end

                    if farmTarget then
                        -- Teleportar perto do inimigo
                        local targetPos = farmTarget.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                        LocalPlayer.Character.HumanoidRootPart.CFrame = targetPos

                        -- Atacar inimigo
                        if LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                            if tool and tool:FindFirstChild("Handle") then
                                tool:Activate()
                            end
                        end
                    end

                    wait(0.5)
                end
            end)
        end
    end, true)
    farmY = farmY + 50

    -- Escolha de arma
    local armaLabel = Instance.new("TextLabel", farmPage)
    armaLabel.Size = UDim2.new(0, 400, 0, 30)
    armaLabel.Position = UDim2.new(0, 10, 0, farmY)
    armaLabel.BackgroundTransparency = 1
    armaLabel.TextColor3 = Color3.fromRGB(255,255,255)
    armaLabel.Font = Enum.Font.FredokaOne
    armaLabel.TextSize = 16
    armaLabel.Text = "Escolha a arma para farm:"
    farmY = farmY + 35

    local armas = {"Melee", "Sword", "Gun", "Fruit"}
    local selectedWeapon = armas[1]

    for i, arma in ipairs(armas) do
        local btn = createPageButton(farmPage, arma, farmY, function()
            selectedWeapon = arma
            farmWeapon = arma
            for _, b in pairs(farmPage:GetChildren()) do
                if b:IsA("TextButton") and table.find(armas, b.Text) then
                    b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                end
            end
            btn.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
        end)
        farmY = farmY + 45
    end

    ------------------------
    -- Teleport Page Conteúdo --
    ------------------------
    local teleY = 10

    -- Função para criar botão de teleport
    local function createTeleportButton(name, cframe)
        local btn = createPageButton(telePage, "Teleportar: " .. name, teleY, function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
            end
        end)
        teleY = teleY + 45
        return btn
    end

    -- Exemplo de teleports (ajustar coordenadas conforme jogo)
    local teleports = {
        {Name = "Starter Island", CFrame = CFrame.new(2111, 34, 1530)},
        {Name = "Pirate Village", CFrame = CFrame.new(409, 43, 1617)},
        {Name = "Desert Island", CFrame = CFrame.new(-4000, 50, -900)},
        {Name = "Frozen Village", CFrame = CFrame.new(-6000, 50, 2000)},
        {Name = "Sky Island", CFrame = CFrame.new(2000, 300, 4000)},
        {Name = "First Sea", CFrame = CFrame.new(1000, 40, 1000)}
        -- Adicione mais conforme necessidade
    }

    for _, t in ipairs(teleports) do
        createTeleportButton(t.Name, t.CFrame)
    end

    ------------------------
    -- Missões Page Conteúdo --
    ------------------------
    local questY = 10

    local questLabel = Instance.new("TextLabel", questPage)
    questLabel.Size = UDim2.new(1, -20, 0, 40)
    questLabel.Position = UDim2.new(0, 10, 0, questY)
    questLabel.BackgroundTransparency = 1
    questLabel.TextColor3 = Color3.fromRGB(255,255,255)
    questLabel.Font = Enum.Font.FredokaOne
    questLabel.TextSize = 20
    questLabel.Text = "Auto Quest"
    questY = questY + 50

    local autoQuestToggle = createPageButton(questPage, "Ativar Auto Quest", questY, function(on)
        autoQuestEnabled = on
        if on then
            spawn(function()
                while autoQuestEnabled do
                    local questRemote = ReplicatedStorage.Remotes.CommF_
                    questRemote:InvokeServer("StartQuest", questName or "")
                    wait(5)
                end
            end)
        end
    end, true)
    questY = questY + 50

    -- Escolha das quests - Exemplo para First Sea e Second Sea
    local quests = {"Bandit Quest", "Pirate Quest", "Marine Quest", "Fishman Quest", "Sky Quest"}

    local function setQuest(quest)
        questName = quest
    end

    for _, q in pairs(quests) do
        local btn = createPageButton(questPage, "Selecionar Quest: " .. q, questY, function()
            setQuest(q)
        end)
        questY = questY + 45
    end

    ------------------------
    -- Outros Page Conteúdo --
    ------------------------
    local outrosY = 10

    -- Auto Stats (toggle)
    local autoStatsBtn = createPageButton(outrosPage, "Ativar Auto Stats", outrosY, function(on)
        autoStatsEnabled = on
        if on then
            spawn(function()
                while autoStatsEnabled do
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1)
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Sword", 1)
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Gun", 1)
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Devil Fruit", 1)
                    wait(1)
                end
            end)
        end
    end, true)
    outrosY = outrosY + 50

    -- Auto Abilities (toggle)
    local autoAbilitiesBtn = createPageButton(outrosPage, "Ativar Auto Habilidades", outrosY, function(on)
        autoAbilitiesEnabled = on
        if on then
            spawn(function()
                while autoAbilitiesEnabled do
                    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool and tool.Name == "Dragon Fruit" then
                        -- Exemplo para usar habilidade (ajustar conforme fruta)
                        tool:Activate()
                    end
                    wait(5)
                end
            end)
        end
    end, true)
    outrosY = outrosY + 50

    return screenGui
end

local ui = createUI()

-- Mensagem de carregamento
print("[Huzzy Hub] Script carregado com sucesso! Divirta-se!")

