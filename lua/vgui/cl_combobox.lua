/*
 * -------------------------
 * • Fichier: cl_combobox.lua
 * • Projet: client
 * • Création : Thursday, 13th July 2023 1:32:51 am
 * • Auteur : Ekali
 * • Modification : Thursday, 13th July 2023 2:36:47 am
 * • Destiné à Prisel.fr en V3
 * -------------------------
 */
local PANEL = {}

function PANEL:Init()
    self:SetSize(DarkRP.ScrW * 0.1, DarkRP.ScrH * 0.05)
    self:SetText("")
    self:SetCursor("hand")

    self.options = {}
    self.selectedOption = nil

    self.BaseColor = DarkRP.Config.Colors["Main"]
    self.CurrentColor = self.BaseColor
    self.HoveredColor = DarkRP.Library.ColorNuance(self.BaseColor, 20)
    self.Hovered = false

    
    local empty = false 

    timer.Simple(0.1, function()
        empty = table.IsEmpty(self.options)
    end)

    self.OnCursorEntered = function() self.Hovered = true end
    self.OnCursorExited = function() self.Hovered = false end
    self.OnMousePressed = function()
        if empty then return end
        if self:IsMenuOpen() then
            if IsValid(self.menu) then
                self.menu:SlideUp(0.5, function()
                    self.menu:CloseMenu()
                end)
                return
            end
            self:CloseMenu()
        else
            self:OpenMenu()
        end
    end

    self.Paint = function(self, w, h)
        local x, y = self:LocalToScreen(0, 0)
        BSHADOWS.BeginShadow()
            self.CurrentColor = DarkRP.Library.LerpColor(FrameTime() * 10, self.CurrentColor, self.Hovered and self.HoveredColor or self.BaseColor)
            draw.RoundedBox(DarkRP.Config.RoundedBoxValue, x, y, w, h, self.CurrentColor)
            draw.SimpleText(self:GetSelectedText() or "", DarkRP.Library.Font(12, 0, "Montserrat Bold"), x + w / 2, y + h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            if empty then
                draw.SimpleText("Aucune option disponible", DarkRP.Library.Font(12, 0, "Montserrat Bold"), x + w / 2, y + h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        BSHADOWS.EndShadow(1, 2, 2, 255, 0, 0)
    end
end

function PANEL:AddChoice(text, value)
    local option = {text = text, value = value}
    table.insert(self.options, option)

    if not self.selectedOption then
        self.selectedOption = option
    end
end

function PANEL:GetSelectedOption()
    return self.selectedOption
end

function PANEL:GetSelectedValue()
    return self.selectedOption and self.selectedOption.value
end

function PANEL:GetSelectedText()
    return self.selectedOption and self.selectedOption.text
end

function PANEL:OpenMenu()
    if self:IsMenuOpen() then return end
    local menu = vgui.Create("DPanel")
    self.menu = menu
    self.menu:SetSize(self:GetWide(), DarkRP.ScrH*0.0335 * math.Clamp(#self.options, 0, 5))
    self.menu:SetPos(self:LocalToScreen(0, self:GetTall()+5))
    self.menu:SlideDown(0.5)

    local scroll = vgui.Create("DScrollPanel", self.menu)
    scroll:Dock(FILL)

    local empty = table.IsEmpty(self.options)

    function self.menu:Paint(w, h)
        local x, y = self:LocalToScreen(0, 0)
        BSHADOWS.BeginShadow()
            draw.RoundedBox(DarkRP.Config.RoundedBoxValue, x, y, w, h, DarkRP.Config.Colors["Main"])
        BSHADOWS.EndShadow(1, 2, 2, 255, 0, 0)
    end

    if empty then if IsValid(menu) then menu:Remove() end return end

    local sbar = scroll:GetVBar()
    sbar:SetWide(0)

    for k, v in ipairs(self.options) do
        local option = scroll:Add("Prisel.Button")
        option:Dock(TOP)
        option:DockMargin(scroll:GetWide()*0.05, scroll:GetWide()*0.05, scroll:GetWide()*0.05, scroll:GetWide()*0.05)
        option:SetTall(DarkRP.ScrH*0.028)
        option:CenterHorizontal()
        option:SetText(v.text)
        option:SetCursor("hand")
        option.DoClick = function()
            self.selectedOption = v
            self.menu:SlideUp(0.5, function()
                self.menu:CloseMenu()
            end)
        end
    end

    self.menu:MakePopup()

    menu.Think = function(me)
        me:MoveToFront()
        if not IsValid(self) then
            me:Remove()
        end
    end
end

function PANEL:CloseMenu()
    if not self:IsMenuOpen() then return end

    if IsValid(self.menu) then
        self.menu:Remove()
    end

    self.menu = nil
end

function PANEL:IsMenuOpen()
    return IsValid(self.menu) and self.menu:IsVisible()
end

vgui.Register("Prisel.ComboBox", PANEL, "EditablePanel")
