local PANEL = {}

function PANEL:Init()
    self.Data = {}
end
 
function PANEL:AddData(label, value)
    table.insert(self.Data, { label = label, value = value, lerp = 0 })
end

local function formatNumber(n)
    if not n then return "" end
    if n >= 1e14 then return tostring(n) end
    n = tostring(n)
    local sep = sep or " "
    local dp = string.find(n, "% ") or #n+1
    for i=dp-4, 1, -3 do
        n = n:sub(1, i) .. sep .. n:sub(i+1)
    end
    return n
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(color_white)
    surface.DrawRect(DarkRP.ScrW * 0.02, 20, 1, h - DarkRP.ScrH * 0.0375)

    local maxValue = 0
    for _, data in ipairs(self.Data) do
        if data.value > maxValue then
            maxValue = data.value
        end
    end

    local barWidth = (w - 30*(#self.Data)) / #self.Data
    local barSpacing = 5
    for i, data in ipairs(self.Data) do
        data.lerp = Lerp(FrameTime() * 2, data.lerp, data.value)
        local barHeight = (data.lerp / maxValue) * (h - DarkRP.ScrH * 0.0375)
        local barX = DarkRP.ScrW * 0.025 + (i - 1) * (barWidth + barSpacing)
        local barY = h - 20 - barHeight

        draw.RoundedBox(DarkRP.Config.RoundedBoxValue, barX, barY, barWidth, barHeight, DarkRP.Config.Colors["Blue"])

        draw.SimpleTextOutlined(formatNumber(math.Round(data.lerp)), DarkRP.Library.Font(6), barX + barWidth * 0.5, barY - 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
        draw.SimpleText(data.label, DarkRP.Library.Font(7,0, "Montserrat Bold"), barX + barWidth * 0.5, h+3, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
    end
end

vgui.Register("Prisel.GraphBarre", PANEL, "Panel")