local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local lp = game.Players.LocalPlayer

-- Configuração da Janela
local Window = Fluent:CreateWindow({
    Title = "SecretHub V5 🥑",
    SubTitle = "by joaorqqq",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Admin = Window:AddTab({ Title = "Admin", Icon = "shield" }),
    Market = Window:AddTab({ Title = "Marketplace", Icon = "shopping-bag" }),
    Editor = Window:AddTab({ Title = "Editor", Icon = "code" })
}

-------------------------------------------------------------------------------
-- [[ ABA: PLAYER ]]
-------------------------------------------------------------------------------
Tabs.Player:AddSlider("WalkSpeed", { Title = "Velocidade", Default = 16, Min = 16, Max = 500, Rounding = 1, Callback = function(v) if lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.WalkSpeed = v end end })
Tabs.Player:AddSlider("JumpPower", { Title = "Pulo", Default = 50, Min = 50, Max = 1000, Rounding = 1, Callback = function(v) if lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.JumpPower = v end end })
Tabs.Player:AddSlider("Gravity", { Title = "Gravidade", Default = 196.2, Min = 0, Max = 500, Rounding = 1, Callback = function(v) workspace.Gravity = v end })
Tabs.Player:AddToggle("InfJump", {Title = "Pulo Infinito 🚀", Default = false})
UIS.JumpRequest:Connect(function() if Fluent.Options.InfJump.Value and lp.Character then lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end end)

-------------------------------------------------------------------------------
-- [[ ABA: VISUALS (SISTEMA ESP) ]]
-------------------------------------------------------------------------------
Tabs.Visuals:AddSection("Esp de Jogadores")

local ESP_Enabled = false
Tabs.Visuals:AddToggle("EspToggle", {Title = "Ativar ESP (Boxes/Names)", Default = false, Callback = function(v) ESP_Enabled = v end})

-- Lógica do ESP simples e funcional
RunService.RenderStepped:Connect(function()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= lp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local existing = hrp:FindFirstChild("SecretESP")
            
            if ESP_Enabled then
                if not existing then
                    local bgui = Instance.new("BillboardGui", hrp)
                    bgui.Name = "SecretESP"
                    bgui.AlwaysOnTop = true
                    bgui.Size = UDim2.new(0, 200, 0, 50)
                    bgui.ExtentsOffset = Vector3.new(0, 3, 0)
                    
                    local txt = Instance.new("TextLabel", bgui)
                    txt.BackgroundTransparency = 1
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.TextColor3 = Color3.fromRGB(0, 255, 136)
                    txt.TextStrokeTransparency = 0
                    txt.TextSize = 14
                    txt.Text = player.Name
                else
                    existing.TextLabel.Text = player.Name .. " [" .. math.floor((hrp.Position - lp.Character.HumanoidRootPart.Position).Magnitude) .. "m]"
                end
            else
                if existing then existing:Destroy() end
            end
        end
    end
end)

-------------------------------------------------------------------------------
-- [[ ABA: ADMIN ]]
-------------------------------------------------------------------------------
Tabs.Admin:AddButton({ Title = "Infinite Yield 🆓", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end })
Tabs.Admin:AddButton({ Title = "FE Admin (CMD) ⚡", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/lxte/cmd/main/main.lua"))() end })
Tabs.Admin:AddButton({ 
    Title = "SP Hub (Brookhaven) 🏡", 
    Callback = function() 
        if game.PlaceId == 492414410 then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/as6cd0/SP_Hub/refs/heads/main/Brookhaven"))()
        else
            if queuescript then
                queuescript([[repeat wait() until game:IsLoaded() loadstring(game:HttpGet("https://raw.githubusercontent.com/as6cd0/SP_Hub/refs/heads/main/Brookhaven"))()]])
            end
            TeleportService:Teleport(492414410, lp)
        end
    end 
})

-------------------------------------------------------------------------------
-- [[ ABA: EDITOR ]]
-------------------------------------------------------------------------------
local FilePath = "SecretHub_V5/Scripts/"
if not isfolder("SecretHub_V5/") then makefolder("SecretHub_V5/") end
if not isfolder(FilePath) then makefolder(FilePath) end

local newFN, newFC = "", ""
Tabs.Editor:AddInput("FN", {Title = "Nome do Arquivo", Callback = function(v) newFN = v end})
Tabs.Editor:AddInput("FC", {Title = "Código", Callback = function(v) newFC = v end})
Tabs.Editor:AddButton({ Title = "Salvar Script", Callback = function() if newFN ~= "" and newFC ~= "" then writefile(FilePath..newFN..".lua", newFC) end end })

-------------------------------------------------------------------------------
-- [[ MARKETPLACE & BUBBLE ]]
-------------------------------------------------------------------------------
task.spawn(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/joaorqqq/ProjectSecret/refs/heads/main/store.lua"))(Tabs.Market, Fluent) end) end)

local Bubble = Instance.new("TextButton")
Bubble.Name = "SecretBubble"; Bubble.Parent = CoreGui; Bubble.Size = UDim2.new(0, 60, 0, 60)
Bubble.Position = UDim2.new(0.05, 0, 0.4, 0); Bubble.BackgroundColor3 = Color3.fromRGB(0, 255, 136)
Bubble.Text = "🥑"; Bubble.TextSize = 30; Bubble.ZIndex = 10000
Instance.new("UICorner", Bubble).CornerRadius = UDim.new(1, 0)

-- Arrastar e Minimizar
local drag, dStart, sPos
Bubble.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true; dStart = i.Position; sPos = Bubble.Position end end)
UIS.InputChanged:Connect(function(i) if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
    local delta = i.Position - dStart
    Bubble.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
end end)
Bubble.InputEnded:Connect(function(i) drag = false end)
Bubble.MouseButton1Click:Connect(function() Window:Minimize() end)

Window:SelectTab(1)
