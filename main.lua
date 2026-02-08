local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

local Window = Fluent:CreateWindow({
    Title = "SecretHub V5 🥑",
    SubTitle = "A MAIOR CENTRAL MOBILE",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- [[ ABA: PLAYER ]]
local PlayerTab = Window:AddTab({ Title = "Player", Icon = "user" })
PlayerTab:AddSlider("WalkSpeed", { Title = "Velocidade", Default = 16, Min = 16, Max = 500, Rounding = 1, Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end })
PlayerTab:AddSlider("JumpPower", { Title = "Pulo", Default = 50, Min = 50, Max = 1000, Rounding = 1, Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.JumpPower = v end })
PlayerTab:AddToggle("InfJump", {Title = "Pulo Infinito", Default = false})
game:GetService("UserInputService").JumpRequest:Connect(function()
    if Fluent.Options.InfJump.Value then game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
end)

-- [[ ABA: ADMIN ]]
local AdminTab = Window:AddTab({ Title = "Admin", Icon = "shield" })
AdminTab:AddButton({ Title = "Infinite Yield 🆓", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end })
AdminTab:AddButton({ Title = "Nameless Admin 🆓", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source'))() end })

-- [[ ABA: MARKETPLACE (CHAMANDO SEU LINK) ]]
local StoreTab = Window:AddTab({ Title = "Marketplace 🥑", Icon = "shopping-bag" })
task.spawn(function()
    local store_url = "https://raw.githubusercontent.com/joaorqqq/ProjectSecret/refs/heads/main/store.lua"
    local success, store_code = pcall(function() return game:HttpGet(store_url) end)
    if success then 
        loadstring(store_code)(StoreTab, Fluent) 
    else
        Fluent:Notify({Title = "Erro", Content = "Falha ao carregar store.lua"})
    end
end)

-- [[ BOTÃO FLUTUANTE 🥑 ]]
local Bubble = Instance.new("TextButton", CoreGui)
Bubble.Size = UDim2.new(0, 60, 0, 60); Bubble.Position = UDim2.new(0.1, 0, 0.5, 0)
Bubble.BackgroundColor3 = Color3.fromRGB(0, 255, 136); Bubble.Text = "🥑"; Bubble.TextSize = 35
Instance.new("UICorner", Bubble).CornerRadius = UDim.new(1, 0)

local drag, dStart, sPos
Bubble.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true; dStart = i.Position; sPos = Bubble.Position end end)
UIS.InputChanged:Connect(function(i) if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
    local delta = i.Position - dStart
    Bubble.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
end end)
Bubble.InputEnded:Connect(function(i) drag = false end)
Bubble.MouseButton1Click:Connect(function() Window:Minimize() end)

Fluent:Notify({Title = "SecretHub V5", Content = "Legenda: 🆓 Grátis | 👥 Grupo | 🏆 Badge | 💎 Gamepass", Duration = 10})

