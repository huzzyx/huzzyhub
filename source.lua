--[[
    Huzzy Hub - Script completo para Blox Fruits
    Completão com farm, loja, teleport, missão e UI avançada
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Configuração padrão
local Config = {
    AutoFarmEnabled = false,
    AutoClickEnabled = false,
    FlyOnHeadEnabled = false,
    FlyHeight = 5,           -- altura acima do inimigo
    ClickInterval = 0.1,     -- intervalo do clique automático (s)
    FarmSpeed = 0.5,         -- delay entre teleports do farm (s)
    SelectedWeapon = "Melee", -- "Melee", "Sword", "Gun", "Fruit"
    SelectedFruit = "Dragon Fruit", -- fruta para usar na farm
}

local powerfulFruits = {
    "Dragon Fruit", "Light Fruit", "Dark Fruit", "Bomb Fruit", "Phoenix Fruit",
    "Ice Fruit", "Love Fruit", "Sand Fruit", "Quake Fruit", "Rumble Fruit",
}

-- Criar interface
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "HuzzyHub"
ScreenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", ScreenGui)
mainFrame.Size = UDim2.new(0, 540, 0, 450)
mainFrame.Position = UDim2.new(0.5, -270, 0.5, -225)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 20)

-- Top Bar
local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
local topCorner = Instance.new("UICorner", topBar)
topCorner.CornerRadius = UDim.new(0, 20)

local titleLabel = Instance.new("TextLabel", topBar)
titleLabel.Size = UDim2.new(1, -20, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🥭 Huzzy Hub - Blox Fruits"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.FredokaOne
titleLabel.TextSize = 22
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Botão de fechar (vai esconder a UI)
local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 50, 0, 30)
closeBtn.Position = UDim2.new(1, -60, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
closeBtn.Text = "Fechar"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.Gotham
closeBtn.TextSize = 14
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0, 10)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Menu lateral
local menuFrame = Instance.new("Frame", mainFrame)
menuFrame.Size = UDim2.new(0, 160, 1, -45)
menuFrame.Position = UDim2.new(0, 0, 0, 45)
menuFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
local menuCorner = Instance.new("UICorner", menuFrame)
menuCorner.CornerRadius = UDim.new(0, 20)

-- Conteúdo principal
local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -160, 1, -45)
contentFrame.Position = UDim2.new(0, 160, 0, 45)
contentFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
local contentCorner = Instance.new("UICorner", contentFrame)
contentCorner.CornerRadius = UDim.new(0, 20)

-- Páginas armazenadas aqui
local pages = {}

-- Criar página
local function createPage(name)
    local page = Instance.new("ScrollingFrame", contentFrame)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 6
    page.Visible = false
    pages[name] = page
    return page
end

-- Criar botão menu
local function createMenuButton(name, page)
    local btn = Instance.new("TextButton", menuFrame)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, (#menuFrame:GetChildren()-1) * 50 + 10)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 10)
    btn.MouseButton1Click:Connect(function()
        for _, pg in pairs(pages) do
            pg.Visible = false
        end
        page.Visible = true
    end)
    return btn
end

-- Criar todas as páginas
local homePage = createPage("Home")
local lojaPage = createPage("Loja")
local farmPage = createPage("Farm")
local telePage = createPage("Teleport")
local missoesPage = createPage("Missoes")

-- Criar botões menu
createMenuButton("🏠 Home", homePage)
createMenuButton("🍉 Loja", lojaPage)
createMenuButton("⚔️ Farm", farmPage)
createMenuButton("🧭 Teleport", telePage)
createMenuButton("📜 Missões", missoesPage)

homePage.Visible = true

-- UTILITIES
local function createLabel(parent, text, posY)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1, -20, 0, 25)
    lbl.Position = UDim2.new(0, 10, 0, posY)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 16
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = text
    return lbl
end

local function createToggle(parent, text, posY, initialState, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -20, 0, 35)
    frame.Position = UDim2.new(0, 10, 0, posY)
    frame.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.75, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton", frame)
    toggleBtn.Size = UDim2.new(0.2, 0, 0.6, 0)
    toggleBtn.Position = UDim2.new(0.8, 0, 0.2, 0)
    toggleBtn.BackgroundColor3 = initialState and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(150, 0, 0)
    toggleBtn.Text = initialState and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.new(1,1,1)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 14
    local btnCorner = Instance.new("UICorner", toggleBtn)
    btnCorner.CornerRadius = UDim.new(0, 8)

    toggleBtn.MouseButton1Click:Connect(function()
        local newState = not (toggleBtn.Text == "ON")
        toggleBtn.Text = newState and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = newState and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(150, 0, 0)
        callback(newState)
    end)

    return toggleBtn
end

local function createDropdown(parent, text, options, posY, initialValue, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -20, 0, 45)
    frame.Position = UDim2.new(0, 10, 0, posY)
    frame.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.75, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left

    local dropdownBtn = Instance.new("TextButton", frame)
    dropdownBtn.Size = UDim2.new(0.25, -5, 0.6, 0)
    dropdownBtn.Position = UDim2.new(0.75, 0, 0.2, 0)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    dropdownBtn.Text = initialValue or options[1]
    dropdownBtn.TextColor3 = Color3.new(1,1,1)
    dropdownBtn.Font = Enum.Font.GothamBold
    dropdownBtn.TextSize = 14
    local dropCorner = Instance.new("UICorner", dropdownBtn)
    dropCorner.CornerRadius = UDim.new(0, 8)

    local dropdownList = Instance.new("Frame", frame)
    dropdownList.Size = UDim2.new(0.25, 0, #options * 30, 0)
    dropdownList.Position = UDim2.new(0.75, 0, 1, 5)
    dropdownList.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    dropdownList.Visible = false
    local dropListCorner = Instance.new("UICorner", dropdownList)
    dropListCorner.CornerRadius = UDim.new(0, 8)

    for i, option in ipairs(options) do
        local optBtn = Instance.new("TextButton", dropdownList)
        optBtn.Size = UDim2.new(1, 0, 0, 30)
        optBtn.Position = UDim2.new(0, 0, 0, (i-1)*30)
        optBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
        optBtn.Text = option
        optBtn.TextColor3 = Color3.new(1,1,1)
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 14

        optBtn.MouseButton1Click:Connect(function()
            dropdownBtn.Text = option
            dropdownList.Visible = false
            callback(option)
        end)
    end

    dropdownBtn.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
    end)

    -- Esconder dropdown se clicar fora
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            local guiPos = dropdownList.AbsolutePosition
            local guiSize = dropdownList.AbsoluteSize
            if not (mousePos.X >= guiPos.X and mousePos.X <= guiPos.X + guiSize.X and
                    mousePos.Y >= guiPos.Y and mousePos.Y <= guiPos.Y + guiSize.Y) then
                dropdownList.Visible = false
            end
        end
    end)

    return dropdownBtn
end

local function createSlider(parent, text, min, max, default, posY, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.Position = UDim2.new(0, 10, 0, posY)
    frame.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left

    local slider = Instance.new("Frame", frame)
    slider.Size = UDim2.new(0.4, 0, 0.4, 0)
    slider.Position = UDim2.new(0.55, 0, 0.3, 0)
    slider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    local sliderCorner = Instance.new("UICorner", slider)
    sliderCorner.CornerRadius = UDim.new(0, 8)

    local sliderFill = Instance.new("Frame", slider)
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    local fillCorner = Instance.new("UICorner", sliderFill)
    fillCorner.CornerRadius = UDim.new(0, 8)

    local dragging = false

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = input.Position.X
            local sliderX = slider.AbsolutePosition.X
            local sliderWidth = slider.AbsoluteSize.X
            local pos = math.clamp(mouseX - sliderX, 0, sliderWidth)
            local value = (pos / sliderWidth) * (max - min) + min
            sliderFill.Size = UDim2.new(pos/sliderWidth, 0, 1, 0)
            label.Text = text .. ": " .. string.format("%.2f", value)
            callback(value)
        end
    end)

    return frame
end

-- FUNÇÕES FARM

local function getEnemies()
    local enemies = {}
    if Workspace:FindFirstChild("Enemies") then
        for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
            local humanoid = enemy:FindFirstChildOfClass("Humanoid")
            local rootPart = enemy:FindFirstChild("HumanoidRootPart")
            if humanoid and humanoid.Health > 0 and rootPart then
                table.insert(enemies, enemy)
            end
        end
    end
    return enemies
end

local function equipTool(toolName)
    local backpack = LocalPlayer.Backpack
    local character = LocalPlayer.Character
    if not backpack or not character then return end
    -- se já está equipado, ignora
    local currentTool = character:FindFirstChildOfClass("Tool")
    if currentTool and currentTool.Name == toolName then return end

    local tool = backpack:FindFirstChild(toolName)
    if tool then
        tool.Parent = character
        wait(0.1)
    end
end

local function useWeapon()
    local character = LocalPlayer.Character
    if not character then return end
    local tool = character:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
    end
end

local autoClickConn
local autoFarmCoroutine

local function startAutoClick()
    if autoClickConn then return end
    autoClickConn = RunService.Heartbeat:Connect(function()
        if Config.AutoClickEnabled then
            local character = LocalPlayer.Character
            if character then
                local tool = character:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Handle") then
                    tool:Activate()
                end
            end
        end
    end)
end

local function stopAutoClick()
    if autoClickConn then
        autoClickConn:Disconnect()
        autoClickConn = nil
    end
end

local function flyOnHead(enemy)
    if not enemy or not enemy:FindFirstChild("HumanoidRootPart") or not LocalPlayer.Character then return end
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    local targetPos = enemy.HumanoidRootPart.CFrame * CFrame.new(0, Config.FlyHeight, 0)
    rootPart.CFrame = targetPos
end

local function startAutoFarm()
    if autoFarmCoroutine then return end
    autoFarmCoroutine = coroutine.create(function()
        while Config.AutoFarmEnabled do
            local enemies = getEnemies()
            if #enemies == 0 then
                wait(1)
                continue
            end
            local target = enemies[1]

            -- Equipar arma/fruta certa
            if Config.SelectedWeapon == "Fruit" then
                equipTool(Config.SelectedFruit)
            else
                equipTool(Config.SelectedWeapon)
            end

            if Config.FlyOnHeadEnabled then
                flyOnHead(target)
            else
                local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local pos = target.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                    rootPart.CFrame = pos
                end
            end

            useWeapon()
            wait(Config.ClickInterval)
            wait(Config.FarmSpeed)
        end
    end)
    coroutine.resume(autoFarmCoroutine)
end

local function stopAutoFarm()
    Config.AutoFarmEnabled = false
    if autoFarmCoroutine then
        coroutine.close(autoFarmCoroutine)
        autoFarmCoroutine = nil
    end
end

-- UI FARM
createLabel(farmPage, "Configurações de Farm", 10)

createToggle(farmPage, "Auto Farm", 40, Config.AutoFarmEnabled, function(state)
    Config.AutoFarmEnabled = state
    if state then
        startAutoFarm()
    else
        stopAutoFarm()
    end
end)

createToggle(farmPage, "Auto Click", 85, Config.AutoClickEnabled, function(state)
    Config.AutoClickEnabled = state
    if state then
        startAutoClick()
    else
        stopAutoClick()
    end
end)

createToggle(farmPage, "Voar na Cabeça (Sem Dano)", 130, Config.FlyOnHeadEnabled, function(state)
    Config.FlyOnHeadEnabled = state
end)

createSlider(farmPage, "Altura do Voo", 1, 10, Config.FlyHeight, 175, function(val)
    Config.FlyHeight = val
end)

createSlider(farmPage, "Intervalo do Clique (s)", 0.05, 1, Config.ClickInterval, 220, function(val)
    Config.ClickInterval = val
end)

createSlider(farmPage, "Velocidade do Farm (s)", 0.1, 2, Config.FarmSpeed, 265, function(val)
    Config.FarmSpeed = val
end)

-- Dropdown armas
local weaponsList = {"Melee", "Sword", "Gun", "Fruit"}
createDropdown(farmPage, "Selecionar Arma", weaponsList, 310, Config.SelectedWeapon, function(choice)
    Config.SelectedWeapon = choice
end)

-- Dropdown frutas (para usar na farm)
createDropdown(farmPage, "Selecionar Fruta", powerfulFruits, 355, Config.SelectedFruit, function(choice)
    Config.SelectedFruit = choice
end)

-- LOJA - Comprar frutas, armazenar e coletar frutas do mapa
createLabel(lojaPage, "Loja de Frutas", 10)

local lojaButtonsY = 40

local function buyFruit(fruitName)
    local args = {
        [1] = fruitName
    }
    local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("BuyFruit")
    remote:InvokeServer(unpack(args))
end

local function storeFruit(fruitName)
    local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("StoreFruit")
    remote:InvokeServer(fruitName)
end

local function collectMapFruits()
    local fruits = Workspace:FindFirstChild("Fruits")
    if not fruits then return end
    for _, fruit in pairs(fruits:GetChildren()) do
        if fruit:IsA("Tool") then
            fruit.Handle.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end

createToggle(lojaPage, "Auto Comprar Frutas", lojaButtonsY, Config.AutoBuyFruits, function(state)
    Config.AutoBuyFruits = state
    if state then
        spawn(function()
            while Config.AutoBuyFruits do
                for _, fruit in pairs(powerfulFruits) do
                    buyFruit(fruit)
                    wait(2)
                end
                wait(10)
            end
        end)
    end
end)

createToggle(lojaPage, "Auto Armazenar Frutas", lojaButtonsY + 45, Config.AutoStoreFruits, function(state)
    Config.AutoStoreFruits = state
    if state then
        spawn(function()
            while Config.AutoStoreFruits do
                for _, fruit in pairs(powerfulFruits) do
                    storeFruit(fruit)
                    wait(1)
                end
                wait(10)
            end
        end)
    end
end)

createToggle(lojaPage, "Auto Coletar Frutas do Mapa", lojaButtonsY + 90, Config.AutoCollectFruits, function(state)
    Config.AutoCollectFruits = state
    if state then
        spawn(function()
            while Config.AutoCollectFruits do
                collectMapFruits()
                wait(5)
            end
        end)
    end
end)

-- Aqui termina o código completo que une interface, funções farm e loja com controle automático.

return HuzzyHub -- retornar a interface principal, se desejar

--[[

Resumo das funções:

- createDropdown: cria dropdown personalizado.
- createSlider: cria slider personalizado.
- AutoFarm: farm automático de inimigos com opções de voar, arma/fruta selecionada, velocidade e clique automático.
- Loja: comprar frutas, armazenar e coletar automaticamente.

Config guarda o estado das opções.

Use esse script dentro de um LocalScript no Roblox, com permissões para usar Remotes do jogo.

--]]Aqui está um código completo e organizado para a sua interface e funções principais do Huzzy Hub em Blox Fruits, incluindo:

- Dropdown customizado
- Slider customizado
- Auto farm com arma ou fruta selecionada, voar na cabeça dos inimigos, ajuste de velocidade e clique automático
- Loja de frutas com auto compra, auto armazenar e auto coletar frutas do mapa

```lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- Configurações padrões
local Config = {
    AutoFarmEnabled = false,
    AutoClickEnabled = false,
    FlyOnHeadEnabled = false,
    FlyHeight = 5,
    ClickInterval = 0.1,
    FarmSpeed = 0.5,
    SelectedWeapon = "Melee", -- "Melee", "Sword", "Gun", "Fruit"
    SelectedFruit = "Dragon",
    AutoBuyFruits = false,
    AutoStoreFruits = false,
    AutoCollectFruits = false,
}

local powerfulFruits = {"Dragon", "Light", "Dark", "Bomb", "Phoenix", "Dough", "Quake", "Rubber", "Sand", "Ice"}

-- UI Helper Functions
local function createLabel(parent, text, posY)
    local label = Instance.new("TextLabel", parent)
    label.Size = UDim2.new(1, -20, 0, 30)
    label.Position = UDim2.new(0, 10, 0, posY)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    return label
end

local function createToggle(parent, text, posY, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.Position = UDim2.new(0, 10, 0, posY)
    frame.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.75, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggle = Instance.new("TextButton", frame)
    toggle.Size = UDim2.new(0.2, 0, 0.6, 0)
    toggle.Position = UDim2.new(0.75, 0, 0.2, 0)
    toggle.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    toggle.Text = default and "ON" or "OFF"
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 14
    local cornerToggle = Instance.new("UICorner", toggle)
    cornerToggle.CornerRadius = UDim.new(0, 8)

    toggle.MouseButton1Click:Connect(function()
        local state = toggle.Text == "OFF"
        toggle.Text = state and "ON" or "OFF"
        toggle.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        callback(state)
    end)

    return toggle
end

local function createDropdown(parent, text, options, posY, initialValue, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -20, 0, 45)
    frame.Position = UDim2.new(0, 10, 0, posY)
    frame.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.75, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left

    local dropdownBtn = Instance.new("TextButton", frame)
    dropdownBtn.Size = UDim2.new(0.25, -5, 0.6, 0)
    dropdownBtn.Position = UDim2.new(0.75, 0, 0.2, 0)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    dropdownBtn.Text = initialValue or options[1]
    dropdownBtn.TextColor3 = Color3.new(1,1,1)
    dropdownBtn.Font = Enum.Font.GothamBold
    dropdownBtn.TextSize = 14
    local dropCorner = Instance.new("UICorner", dropdownBtn)
    dropCorner.CornerRadius = UDim.new(0, 8)

    local dropdownList = Instance.new("Frame", frame)
    dropdownList.Size = UDim2.new(0.25, 0, #options * 30, 0)
    dropdownList.Position = UDim2.new(0.75, 0, 1, 5)
    dropdownList.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    dropdownList.Visible = false
    local dropListCorner = Instance.new("UICorner", dropdownList)
    dropListCorner.CornerRadius = UDim.new(0, 8)

    for i, option in ipairs(options) do
        local optBtn = Instance.new("TextButton", dropdownList)
        optBtn.Size = UDim2.new(1, 0, 0, 30)
        optBtn.Position = UDim2.new(0, 0, 0, (i-1)*30)
        optBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
        optBtn.Text = option
        optBtn.TextColor3 = Color3.new(1,1,1)
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 14

        optBtn.MouseButton1Click:Connect(function()
            dropdownBtn.Text = option
            dropdownList.Visible = false
            callback(option)
        end)
    end

    dropdownBtn.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
    end)

    -- Esconder dropdown se clicar fora
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            local guiPos = dropdownList.AbsolutePosition
            local guiSize = dropdownList.AbsoluteSize
            if not (mousePos.X >= guiPos.X and mousePos.X <= guiPos.X + guiSize.X and
                    mousePos.Y >= guiPos.Y and mousePos.Y <= guiPos.Y + guiSize.Y) then
                dropdownList.Visible = false
            end
        end
    end)

    return dropdownBtn
end

local function createSlider(parent, text, min, max, default, posY, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.Position = UDim2.new(0, 10, 0, posY)
    frame.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left

    local slider = Instance.new("Frame", frame)
    slider.Size = UDim2.new(0.4, 0, 0.4, 0)
    slider.Position = UDim2.new(0.55, 0, 0.3, 0)
    slider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    local sliderCorner = Instance.new("UICorner", slider)
    sliderCorner.CornerRadius = UDim.new(0, 8)

    local sliderFill = Instance.new("Frame", slider)
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    local fillCorner = Instance.new("UICorner", sliderFill)
    fillCorner.CornerRadius = UDim.new(0, 8)

    local dragging = false

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = input.Position.X
            local sliderX = slider.AbsolutePosition.X
            local sliderWidth = slider.AbsoluteSize.X
            local pos = math.clamp(mouseX - sliderX, 0, sliderWidth)
            local value = (pos / sliderWidth) * (max - min) + min
            sliderFill.Size = UDim2.new(pos/sliderWidth, 0, 1, 0)
            label.Text = text .. ": " .. string.format("%.2f", value)
            callback(value)
        end
    end)

    return frame
end

-- Funções do farm

local function getEnemies()
    local enemies = {}
    if Workspace:FindFirstChild("Enemies") then
        for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
            local humanoid = enemy:FindFirstChildOfClass("Humanoid")
            local rootPart = enemy:FindFirstChild("HumanoidRootPart")
            if humanoid and humanoid.Health > 0 and rootPart then
                table.insert(enemies, enemy)
            end
        end
    end
    return enemies
end

local function equipTool(toolName)
    local backpack = LocalPlayer.Backpack
    local character = LocalPlayer.Character
    if not backpack or not character then return end
    local currentTool = character:FindFirstChildOfClass("Tool")
    if currentTool and currentTool.Name == toolName then return end
    local tool = backpack:FindFirstChild(toolName)
    if tool then
        tool.Parent = character
        wait(0.1)
    end
end

local function useWeapon()
    local character = LocalPlayer.Character
    if not character then return end
    local tool = character:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
    end
end

local autoClickConn
local autoFarmCoroutine

local function startAutoClick()
    if autoClickConn then return end
    autoClickConn = RunService.Heartbeat:Connect(function()
        if Config.AutoClickEnabled then
            local character = LocalPlayer.Character
            if character then
                local tool = character:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Handle") then
                    tool:Activate()
                end
            end
        end
    end)
end

local function stopAutoClick()
    if autoClickConn then
        autoClickConn:Disconnect()
        autoClickConn = nil
    end
end

local function flyOnHead(enemy)
    if not enemy or not enemy:FindFirstChild("HumanoidRootPart") or not LocalPlayer.Character then return end
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    local targetPos = enemy.HumanoidRootPart.CFrame * CFrame.new(0, Config.FlyHeight, 0)
    rootPart.CFrame = targetPos
end

local function startAutoFarm()
    if autoFarmCoroutine then return end
    autoFarmCoroutine = coroutine.create(function()
        while Config.AutoFarmEnabled do
            local enemies = getEnemies()
            if #enemies == 0 then
                wait(1)
            else
                local target = enemies[1]

                if Config.SelectedWeapon == "Fruit" then
                    equipTool(Config.SelectedFruit)
                else
                    equipTool(Config.SelectedWeapon)
                end

                if Config.FlyOnHeadEnabled then
                    flyOnHead(target)
                else
                    local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        local pos = target.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                        rootPart.CFrame = pos
                    end
                end

                useWeapon()
                wait(Config.ClickInterval)
                wait(Config.FarmSpeed)
            end
        end
    end)
    coroutine.resume(autoFarmCoroutine)
end

local function stopAutoFarm()
    Config.AutoFarmEnabled = false
    if autoFarmCoroutine then
        coroutine.close(autoFarmCoroutine)
        autoFarmCoroutine = nil
    end
end

-- Loja de frutas: comprar, armazenar e coletar

local function buyFruit(fruitName)
    local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("BuyFruit")
    pcall(function()
        remote:InvokeServer(fruitName)
    end)
end

local function storeFruit(fruitName)
    local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("StoreFruit")
    pcall(function()
        remote:InvokeServer(fruitName)
    end)
end

local function collectMapFruits()
    local fruits = Workspace:FindFirstChild("Fruits")
    if not fruits then return end
    for _, fruit in pairs(fruits:GetChildren()) do
        if fruit:IsA("Tool") then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                fruit.Handle.CFrame = character.HumanoidRootPart.CFrame
            end
        end
    end
end

-- Exemplo de conexão para auto comprar, armazenar e coletar frutas (spawned threads)
spawn(function()
    while true do
        if Config.AutoBuyFruits then
            for _, fruit in pairs(powerfulFruits) do
                buyFruit(fruit)
                wait(2)
            end
        end
        wait(10)
    end
end)

spawn(function()
    while true do
        if Config.AutoStoreFruits then
            for _, fruit in pairs(powerfulFruits) do
                storeFruit(fruit)
                wait(1)
            end
        end
        wait(10)
    end
end)

spawn(function()
    while true do
        if Config.AutoCollectFruits then
            collectMapFruits()
        end
        wait(5)
    end
end)

-- Interface principal (exemplo, adapte para seu GUI)
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "HuzzyHub"

local farmPage = Instance.new("Frame", ScreenGui)
farmPage.Size = UDim2.new(0, 300, 0, 400)
farmPage.Position = UDim2.new(0, 50, 0, 50)
farmPage.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
local farmTitle = createLabel(farmPage, "Farm Config", 10)

createToggle(farmPage, "Auto Farm", 50, Config.AutoFarmEnabled, function(state)
    Config.AutoFarmEnabled = state
    if state then
        startAutoFarm()
        startAutoClick()
    else
        stopAutoFarm()
        stopAutoClick()
    end
end)

createToggle(farmPage, "Auto Click", 95, Config.AutoClickEnabled, function(state)
    Config.AutoClickEnabled = state
    if state then
        startAutoClick()
    else
        stopAutoClick()
    end
end)

createToggle(farmPage, "Fly On Head", 140, Config.FlyOnHeadEnabled, function(state)
    Config.FlyOnHeadEnabled = state
end)

createSlider(farmPage, "Fly Height", 1, 20, Config.FlyHeight, 185, function(value)
    Config.FlyHeight = value
end)

createSlider(farmPage, "Click Interval", 0.05, 1, Config.ClickInterval, 230, function(value)
    Config.ClickInterval = value
end)

createDropdown(farmPage, "Weapon", {"Melee", "Sword", "Gun", "Fruit"}, 275, Config.SelectedWeapon, function(value)
    Config.SelectedWeapon = value
end)

createDropdown(farmPage, "Fruit", powerfulFruits, 320, Config.SelectedFruit, function(value)
    Config.SelectedFruit = value
end)

local lojaPage = Instance.new("Frame", ScreenGui)
lojaPage.Size = UDim2.new(0, 300, 0, 200)
lojaPage.Position = UDim2.new(0, 400, 0, 50)
lojaPage.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
local lojaTitle = createLabel(lojaPage, "Loja de Frutas", 10)

createToggle(lojaPage, "Auto Comprar Frutas", 50, Config.AutoBuyFruits, function(state)
    Config.AutoBuyFruits = state
end)

createToggle(lojaPage, "Auto Armazenar Frutas", 95, Config.AutoStoreFruits, function(state)
    Config.AutoStoreFruits = state
end)

createToggle(lojaPage, "Auto Coletar Frutas do Mapa", 140, Config.AutoCollectFruits, function(state)
    Config.AutoCollectFruits = state
end)

-- Você pode expandir essa interface para outras abas, salvar configs, etc.

