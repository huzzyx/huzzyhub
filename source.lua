local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = nil
local HumanoidRootPart = nil

-- Configurações
local Config = {
    AutoFarmMastery = false,
    AutoClick = true,
    FlyOnHead = true,
    FlyHeight = 5,
    ClickInterval = 0.1,
    SelectedFruit = "Leopard", -- Configurado para Leopard
}

-- Atualizar personagem e humanoid root part
local function updateCharacter()
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end

updateCharacter()
LocalPlayer.CharacterAdded:Connect(updateCharacter)

-- Equipar fruta
local function equipFruit(fruitName)
    if not Character then return end
    local tool = Character:FindFirstChildOfClass("Tool")
    if tool and tool.Name == fruitName then
        return -- já equipado
    end
    local backpack = LocalPlayer:WaitForChild("Backpack")
    local fruit = backpack:FindFirstChild(fruitName)
    if fruit then
        fruit.Parent = Character
    end
end

-- Usar fruta (clicar)
local function useFruit()
    if not Character then return end
    local tool = Character:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
    end
end

-- Pegar inimigos vivos próximos (NPCs)
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

-- Voar na cabeça do inimigo para evitar dano
local function flyOnEnemyHead(enemy)
    if not enemy or not enemy:FindFirstChild("HumanoidRootPart") or not HumanoidRootPart then return end
    local pos = enemy.HumanoidRootPart.Position + Vector3.new(0, Config.FlyHeight, 0)
    HumanoidRootPart.CFrame = CFrame.new(pos)
end

-- Loop principal do auto farm de maestria
local autoFarmThread
local function startAutoFarmMastery()
    if autoFarmThread then return end
    autoFarmThread = coroutine.create(function()
        while Config.AutoFarmMastery do
            local enemies = getEnemies()
            if #enemies > 0 and Character and HumanoidRootPart then
                local target = enemies[1]

                -- Equipar fruta
                equipFruit(Config.SelectedFruit)

                -- Posicionar voando na cabeça do inimigo
                if Config.FlyOnHead then
                    flyOnEnemyHead(target)
                end

                -- Atacar com clique automático
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

-- Ativar/desativar auto farm de maestria pela tecla F
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        Config.AutoFarmMastery = not Config.AutoFarmMastery
        if Config.AutoFarmMastery then
            startAutoFarmMastery()
            print("Auto Farm de Maestria (Leopard) LIGADO")
        else
            stopAutoFarmMastery()
            print("Auto Farm de Maestria (Leopard) DESLIGADO")
        end
    end
end)

print("Script de Auto Farm Maestria para Leopard iniciado. Pressione F para ativar/desativar.")
