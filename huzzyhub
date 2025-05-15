-- Huzzy Hub - Auto Farm Simples
local plr = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", plr.PlayerGui)
local btn = Instance.new("TextButton", gui)

btn.Size = UDim2.new(0, 200, 0, 50)
btn.Position = UDim2.new(0, 20, 0, 20)
btn.Text = "Ativar Auto Farm"
btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 20

local farming = false

btn.MouseButton1Click:Connect(function()
    farming = not farming
    btn.Text = farming and "Desativar Auto Farm" or "Ativar Auto Farm"
    btn.BackgroundColor3 = farming and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)

    if farming then
        spawn(function()
            while farming do
                wait(1)
                -- Detecta inimigos em workspace.Enemies
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        plr.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                        wait(0.5)
                        -- Simula ataque (se permitido pelo executor)
                        mouse1click()
                        break
                    end
                end
            end
        end)
    end
end)
