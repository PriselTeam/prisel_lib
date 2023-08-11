local PANEL = {}

function PANEL:Init()
    self:SetSize(DarkRP.ScrW * 0.04, DarkRP.ScrH * 0.04)
    self:SetCursor("hand")


    self.checked = false
    self.CheckedColor = DarkRP.Config.Colors["Green"]
    self.UnCheckedColor = DarkRP.Config.Colors["Red"]
    self.BaseColor = self:IsChecked() and self.CheckedColor or self.UnCheckedColor

    self.checkX = self:GetWide()*.7
    self.checkY = self:GetTall()/2

    self.uncheckX = self:GetWide()*0.3
    self.uncheckY = self:GetTall()/2

    self.CurrentPos = self:IsChecked() and {x = self.checkX, y = self.checkY} or {x = self.uncheckX, y = self.uncheckY}


end

function PANEL:Paint(w,h)
    self.BaseColor = DarkRP.Library.LerpColor(FrameTime()*2, self.BaseColor, self:IsChecked() and self.CheckedColor or self.UnCheckedColor)
    self.CurrentPos = self:IsChecked() and DarkRP.Library.Lerp2DPos(FrameTime()*6, self.CurrentPos, {x = self.checkX, y = self.checkY}) or DarkRP.Library.Lerp2DPos(FrameTime()*6, self.CurrentPos, {x = self.uncheckX, y = self.uncheckY})

    draw.RoundedBox(90, 0, 0, self:GetWide(), self:GetTall(), Color(0, 0, 0, 200))

    draw.NoTexture()
    surface.SetDrawColor(self.BaseColor)
    DarkRP.Library.DrawCircle(self.CurrentPos.x, self.CurrentPos.y, self:GetTall()*0.45, 90)
end

function PANEL:OnMousePressed()
    self.checked = not self.checked
    self:OnChange(self.checked)
end

function PANEL:IsChecked()
    return self.checked
end

function PANEL:SetChecked(bBool)
    self.checked = bBool
end

function PANEL:OnChange(bBool)
end

vgui.Register("Prisel.CheckBox", PANEL, "EditablePanel")