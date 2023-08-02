local PANEL = {}

function PANEL:Init()
    self:SetSize(DarkRP.ScrW * 0.1, DarkRP.ScrH * 0.05)
    self:SetText("")
    self:SetCursor("hand")

    self.BaseColor = DarkRP.Library.ColorNuance(DarkRP.Config.Colors["Main"], 40)
    self.CurrentColor = self.BaseColor
    self.HoveredColor = DarkRP.Library.ColorNuance(self.BaseColor, 20)
    self.Hovered = false

    self.OnCursorEntered = function() self.Hovered = true end
    self.OnCursorExited = function() self.Hovered = false end
    self.OnMousePressed = function()
        if self.DoClick then
            self:DoClick()
        end
    end

    self.Paint = function(self, w, h)
        self.CurrentColor = DarkRP.Library.LerpColor(FrameTime() * 10, self.CurrentColor, self.Hovered and self.HoveredColor or self.BaseColor)
        draw.RoundedBox(DarkRP.Config.RoundedBoxValue, 0, 0, w, h, self.CurrentColor)
        draw.RoundedBoxEx(DarkRP.Config.RoundedBoxValue, 0, h - h * 0.1, w, h * 0.1, DarkRP.Library.ColorNuance(self.CurrentColor, -20), false, false, true, true)

        if self.icon then
            surface.SetDrawColor(color_white)
            surface.SetMaterial(self.icon)
            surface.DrawTexturedRect(8, h / 2 - 28 / 2 - 2, 28, 28)

            draw.SimpleTextOutlined(self.text, self.font or DarkRP.Library.Font(10, 0, "Montserrat Bold"), 8 + w / 2, h / 2 - 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
        else
            draw.SimpleTextOutlined(self.text, self.font or DarkRP.Library.Font(10, 0, "Montserrat Bold"), w / 2, h / 2 - 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
        end
    end
end

function PANEL:SetIcon(icon)
    self.icon = DarkRP.Library.FetchCDN(icon)
end

function PANEL:SetText(text)
    self.text = text
end

function PANEL:SetFont(font)
    self.font = font
end

function PANEL:SetBackgroundColor(color)
    self.BaseColor = color
    self.HoveredColor = DarkRP.Library.ColorNuance(color, 20)
end

vgui.Register("Prisel.Button", PANEL, "EditablePanel")
