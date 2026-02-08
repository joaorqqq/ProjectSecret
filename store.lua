local StoreTab, Fluent = ...
local HttpService = game:GetService("HttpService")
local lp = game.Players.LocalPlayer
local FB_URL = "https://aleatoria-4cd46-default-rtdb.firebaseio.com/LojaPublica"

-- Função de Verificação (Grupo 👥, Badge 🏆, Pass 💎)
local function Check(item)
    if (item.GroupID or 0) > 0 and not lp:IsInGroup(item.GroupID) then return false, "Grupo" end
    if (item.BadgeID or 0) > 0 then
        local _, has = pcall(function() return game:GetService("BadgeService"):UserHasBadgeAsync(lp.UserId, item.BadgeID) end)
        if not has then return false, "Badge" end
    end
    if (item.GamepassID or 0) > 0 and item.Autor ~= lp.Name then
        local has = false
        pcall(function() has = game:GetService("MarketplaceService"):UserOwnsGamePassAsync(lp.UserId, item.GamepassID) end)
        if not has then game:GetService("MarketplaceService"):PromptGamePassPurchase(lp, item.GamepassID); return false, "Pass" end
    end
    return true
end

-- UI DE PUBLICAÇÃO
StoreTab:AddSection("🚀 Publicar")
local pN, pU, pG, pB, pP = "", "", 0, 0, 0
StoreTab:AddInput("n", {Title = "Nome", Callback = function(v) pN = v end})
StoreTab:AddInput("u", {Title = "Link RAW", Callback = function(v) pU = v end})
StoreTab:AddInput("g", {Title = "ID Grupo", Callback = function(v) pG = tonumber(v) or 0 end})
StoreTab:AddInput("b", {Title = "ID Badge", Callback = function(v) pB = tonumber(v) or 0 end})
StoreTab:AddInput("p", {Title = "ID Pass", Callback = function(v) pP = tonumber(v) or 0 end})

StoreTab:AddButton({
    Title = "Publicar Script",
    Callback = function()
        if pN ~= "" and pU ~= "" then
            local data = {Nome=pN, Autor=lp.Name, ScriptURL=pU, GroupID=pG, BadgeID=pB, GamepassID=pP}
            game:HttpPost(FB_URL..".json", HttpService:JSONEncode(data))
            Fluent:Notify({Title="Sucesso", Content="Postado!"})
        end
    end
})

-- LISTAGEM
StoreTab:AddSection("🔍 Comunidade")
local function Load()
    local data = HttpService:JSONDecode(game:HttpGet(FB_URL..".json"))
    if not data then return end
    for id, item in pairs(data) do
        local tags = ((item.GroupID or 0) > 0 and " 👥" or "") .. ((item.BadgeID or 0) > 0 and " 🏆" or "") .. ((item.GamepassID or 0) > 0 and " 💎" or "")
        if tags == "" then tags = " 🆓" end
        StoreTab:AddButton({
            Title = item.Nome .. tags,
            Description = "Autor: "..item.Autor,
            Callback = function()
                local ok, err = Check(item)
                if ok then loadstring(game:HttpGet(item.ScriptURL))() else Fluent:Notify({Title="Acesso Negado", Content="Falta: "..err}) end
            end
        })
    end
end
Load()

