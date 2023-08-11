local PANEL = {}

function PANEL:Init()
    self:SetSize(DarkRP.ScrW * 0.02, DarkRP.ScrH * 0.02)
    self:SetFont(DarkRP.Library.Font(12))
    self:SetDrawLanguageID(false)
end


function PANEL:Paint(w, h)
    local x, y = self:LocalToScreen(0,0)

    BSHADOWS.BeginShadow()
        draw.RoundedBox(DarkRP.Config.RoundedBoxValue, x, y, w, h, DarkRP.Config.Colors["Main"])
    BSHADOWS.EndShadow(1, 2, 2, 255, 0, 0)
    self:DrawTextEntryText(color_white, DarkRP.Config.Colors["Blue"], DarkRP.Config.Colors["Blue"])
end

function PANEL:OnMousePressed()
    self:RequestFocus()
end

vgui.Register("Prisel.TextEntry", PANEL, "DTextEntry")