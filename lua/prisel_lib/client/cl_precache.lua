local precacheModelsTBL = {}
local PANEL_WIDTH = 624 / 3
local PANEL_HEIGHT = 439 / 3
local CacheFrame
local currentModel = 0
local progress = 0

local function PaintCacheFrame(self, w, h)
    progress = Lerp(FrameTime() * 5, progress, currentModel / #precacheModelsTBL)

    draw.RoundedBox(0, 0, 0, w, h, DarkRP.Library.AlphaColor(DarkRP.Config.Colors["Secondary"], 230))

    DarkRP.Library.DrawMaterialSwing(DarkRP.Library.FetchCDN("prisel_main/prisel_logo_bleu"), w / 2, h / 2 - h * 0.15, PANEL_WIDTH - w / w, PANEL_HEIGHT - h / h, 10, 2)
    draw.SimpleTextOutlined("Précache des modèles en cours", DarkRP.Library.Font(12, 0, "Montserrat, Bold"), w / 2, h / 2 - h *0.03, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)

    draw.SimpleTextOutlined(currentModel.."/"..#precacheModelsTBL, DarkRP.Library.Font(8, 0, "Montserrat Bold"), w / 2, h / 2 + h * 0.02, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)

    draw.RoundedBox(DarkRP.Config.RoundedBoxValue, w/2 - w*0.5/2 , h/2 + h*0.05, w * 0.5, h * 0.05, DarkRP.Library.AlphaColor(DarkRP.Config.Colors["Main"], 230))
    draw.RoundedBox(DarkRP.Config.RoundedBoxValue, w/2 - w*0.5/2 , h/2 + h*0.05, math.Clamp(w * 0.5 * progress, 0, w*0.5), h * 0.05, DarkRP.Library.AlphaColor(DarkRP.Config.Colors["Blue"], 255))

    draw.SimpleTextOutlined(math.Round(progress * 100) .. "%", DarkRP.Library.Font(12, 0, "Montserrat Bold"), w / 2, h / 2 + h * 0.075, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)


end

for k, v in pairs(player_manager.AllValidModels()) do
    precacheModelsTBL[#precacheModelsTBL + 1] = v
end

for k, v in pairs(list.Get("Vehicles")) do
    precacheModelsTBL[#precacheModelsTBL + 1] = v.Model
end

local function precacheModels()
    if IsValid(CacheFrame) then
        CacheFrame:Remove()
        return
    end

    CacheFrame = vgui.Create("DPanel")
    CacheFrame:SetSize(DarkRP.ScrW, DarkRP.ScrH)
    CacheFrame:SetAlpha(0)
    CacheFrame:MakePopup()
    CacheFrame:AlphaTo(255, 0.3, 0)
    CacheFrame:Center()
    CacheFrame.Paint = function(self, w, h)
        PaintCacheFrame(self, w, h)
    end

    timer.Create("Prisel_Cache_Model", 0.1, 0, function()
        if currentModel > #precacheModelsTBL then
            timer.Remove("Prisel_Cache_Model")
            CacheFrame:AlphaTo(0, 0.3, 0, function()
                CacheFrame:Remove()
            end)
            return
        end

        if not IsValid(CacheFrame) then
            timer.Remove("Prisel_Cache_Model")
            gui.EnableScreenClicker(false)
            return
        end

        currentModel = currentModel + 1
        if precacheModelsTBL[currentModel] ~= nil then
            util.PrecacheModel(precacheModelsTBL[currentModel])
        end
    end)
end

concommand.Add("prisel_precache", precacheModels)

hook.Add("DarkRPFinishedLoading", "PriselV3:PrecacheMenu", function()
    precacheModels()
end)