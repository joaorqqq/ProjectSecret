local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

local Window = Fluent:CreateWindow({
    Title = "SecretHub V5 🥑",
    SubTitle = "by joaorqqq",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- [[ ABA: PLAYER (MAIOR E COMPLETA) ]]
local PlayerTab = Window:AddTab({ Title = "Player", Icon = "user" })

PlayerTab:AddSlider("WalkSpeed", {
    Title = "Velocidade",
    Default = 16, Min = 16, Max = 500, Rounding = 1,
    Callback = function(v) 
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v 
        end
    end 
})

PlayerTab:AddSlider("JumpPower", {
    Title = "Pulo",
    Default = 50, Min = 50, Max = 1000, Rounding = 1,
    Callback = function(v) 
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = v 
        end
    end 
})

PlayerTab:AddToggle("InfJump", {Title = "Pulo Infinito 🚀", Default = false})
UIS.JumpRequest:Connect(function()
    if Fluent.Options.InfJump.Value and game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

PlayerTab:AddButton({
    Title = "Anti-AFK (Prevenir Kick)",
    Callback = function()
        local vu = game:GetService("VirtualUser")
        game.Players.LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
        Fluent:Notify({Title = "Sistema", Content = "Anti-AFK Ativado!"})
    end
})

-- [[ ABA: ADMIN (GRÁTIS) ]]
local AdminTab = Window:AddTab({ Title = "Admin", Icon = "shield" })
AdminTab:AddSection("Ferramentas Gratuitas")

AdminTab:AddButton({ 
    Title = "Infinite Yield 🆓", 
    Description = "Comandos de Admin",
    Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end 
})

AdminTab:AddButton({ 
    Title = "Nameless Admin 🆓", 
    Description = "Admin FE Invisível",
    Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source'))() end 
})

-- [[ ABA: MARKETPLACE (CHAMANDO SEU REPOSITÓRIO) ]]
local StoreTab = Window:AddTab({ Title = "Marketplace 🥑", Icon = "shopping-bag" })

task.spawn(function()
    -- Puxando o seu link oficial do store.lua
    local store_url = "https://raw.githubusercontent.com/joaorqqq/ProjectSecret/refs/heads/main/store.lua"
    local success, store_code = pcall(function() return game:HttpGet(store_url) end)
    
    if success then 
        local func = loadstring(store_code)
        if func then
            func(StoreTab, Fluent)
        end
    else
        Fluent:Notify({Title = "Erro Crítico", Content = "Não foi possível conectar ao store.lua no GitHub."})
    end
end)

-- [[ BOTÃO FLUTUANTE 🥑 (DRAG & DROP) ]]
local Bubble = Instance.new("TextButton")
Bubble.Name = "SecretBubble"; Bubble.Parent = CoreGui; Bubble.Size = UDim2.new(0, 65, 0, 65)
Bubble.Position = UDim2.new(0.05, 0, 0.4, 0); Bubble.BackgroundColor3 = Color3.fromRGB(0, 255, 136)
Bubble.Text = "🥑"; Bubble.TextSize = 35; Bubble.ZIndex = 10000
local BCorner = Instance.new("UICorner", Bubble); BCorner.CornerRadius = UDim.new(1, 0)

local drag, dStart, sPos
Bubble.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true; dStart = i.Position; sPos = Bubble.Position end end)
UIS.InputChanged:Connect(function(i) if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
    local delta = i.Position - dStart
    Bubble.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
end end)
Bubble.InputEnded:Connect(function(i) drag = false end)
Bubble.MouseButton1Click:Connect(function() Window:Minimize() end)

-- Notificação Inicial
Fluent:Notify({
    Title = "SecretHub V5 Carregado",
    Content = "Marketplace conectado ao repositório de joaorqqq",
    Duration = 5
})

Window:SelectTab(1)
