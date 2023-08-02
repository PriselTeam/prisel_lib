local PANEL = {}

function PANEL:Init()
    self:SetAlpha(0)
    self:SetDBack(true)
    self:AlphaTo(255, 0.1, 0, function() end)
    self.w = self:GetWide()
    self.h = self:GetTall()
    self:ShowCloseButton(true)

    timer.Simple(0, function()
        if not IsValid(self) then return end
        if not self.showClose then return end
        self.closeBut = vgui.Create("DButton", self)
        self.closeBut:SetText("")
        self.closeBut:SetSize(DarkRP.ScrW * 0.03, DarkRP.ScrW * 0.03)
        self.closeBut:SetPos(self:GetWide() - DarkRP.ScrW * 0.032, (DarkRP.ScrH * 0.073 - DarkRP.ScrW * 0.03) / 2)
        self.closeBut.OnCursorEntered = function()
            self.closeBut.isHovered = true
            self.closeBut:AlphaTo(120, 0.2)
        end

        self.closeBut.OnCursorExited = function()
            self.closeBut.isHovered = false
            self.closeBut:AlphaTo(255, 0.2)
        end
        self.closeBut.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, DarkRP.Config.Colors["Invisible"])
            surface.SetDrawColor(color_white)
            surface.SetMaterial(DarkRP.Library.FetchCDN("prisel_frame/close"))
            surface.DrawTexturedRect(0, 0, w, h)
        end

        self.closeBut.DoClick = function()
            self:AlphaTo(0, 0.1, 0, function() self:Remove() end)
        end

        self.closeBut.Think = function(me)
            if not IsValid(me) then return end
            if self.w ~= self:GetWide() or self.h ~= self:GetTall() then
                self.w = self:GetWide()
                self.h = self:GetTall()
                me:SetPos(self:GetWide() - DarkRP.ScrW * 0.032, (DarkRP.ScrH * 0.073 - DarkRP.ScrW * 0.03) / 2)
            end
        end
    end)
end

function PANEL:SetDBack(bool)
    self.dBack = bool
end

function PANEL:SetTitle(title)
    self.title = title
end

function PANEL:SetDescription(description)
    self.description = description
end

function PANEL:Close()
    self:AlphaTo(0, 0.15, 0, function() self:Remove() end)
end

function PANEL:ShowCloseButton(bool)
    self.showClose = bool
    if not IsValid(self.closeBut) then return end
    self.closeBut:Remove()
end

function PANEL:DrawBackground()
    if not self.dBack then return end
    local w, h = self:GetWide(), self:GetTall()
    local x, y = self:LocalToScreen(0, 0)

    draw.RoundedBox(DarkRP.Config.RoundedBoxValue, x, y, w, h, DarkRP.Config.Colors["Main"])
    draw.RoundedBox(DarkRP.Config.RoundedBoxValue, x, y, w, DarkRP.ScrH * 0.073, DarkRP.Config.Colors["Secondary"])

    surface.SetDrawColor(color_white)
    surface.SetMaterial(DarkRP.Library.FetchCDN("prisel_main/prisel_logo_bleu"))
    surface.DrawTexturedRect(x + (439 / 8) - DarkRP.ScrW / DarkRP.ScrW - DarkRP.ScrH * 0.073 / 2, y + (439 / 8) + DarkRP.ScrW / DarkRP.ScrW - DarkRP.ScrH * 0.073 / 2, (624 / 8) - DarkRP.ScrW / DarkRP.ScrW, (439 / 8) - DarkRP.ScrW / DarkRP.ScrW)

    draw.SimpleText(self.title or "PRISEL", DarkRP.Library.Font(14, 0, "Montserrat Bold"), x + DarkRP.ScrW * 0.055, ((self.description == nil) and y + DarkRP.ScrH * 0.073 / 2 or y + DarkRP.ScrH * 0.06 / 2), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    if self.description ~= nil then
        draw.SimpleText(self.description or "", DarkRP.Library.Font(6), x + DarkRP.ScrW * 0.055, y + DarkRP.ScrH * 0.11 / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end

function PANEL:Paint()
    BSHADOWS.BeginShadow()
        self:DrawBackground()
    BSHADOWS.EndShadow(2, 4, 2, 255, 0, 0)
end

vgui.Register("Prisel.Frame", PANEL, "EditablePanel")