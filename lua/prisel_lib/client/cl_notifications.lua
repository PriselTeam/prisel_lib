local Colors = {
	[NOTIFY_GENERIC] = Color(52, 73, 94),
	[NOTIFY_ERROR] = Color(192, 57, 43),
	[NOTIFY_UNDO] = Color(41, 128, 185),
	[NOTIFY_HINT] = Color(39, 174, 96),
	[NOTIFY_CLEANUP] = Color(243, 156, 18)
}

local Icons = {
	[NOTIFY_GENERIC] = "notifications/generic",
	[NOTIFY_ERROR] = "notifications/error",
	[NOTIFY_UNDO] = "notifications/undo",
	[NOTIFY_HINT] = "notifications/hint",
	[NOTIFY_CLEANUP] = "notifications/cleanup"
}

local Notifications = {}
local NotifTables = {}

local function DrawNotification(x, y, w, h, text, icon, col, progress)
	draw.RoundedBoxEx(DarkRP.Config.RoundedBoxValue, x, y, w, h, DarkRP.Config.Colors["Main"], false, true, false, true)

	draw.SimpleText(text, DarkRP.Library.Font(6), x + 42, y + h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	surface.SetDrawColor(color_white)
	surface.SetMaterial(DarkRP.Library.FetchCDN(icon or Icons[NOTIFY_GENERIC]))
	surface.DrawTexturedRect(x, y, h, h)
	surface.SetDrawColor(DarkRP.Config.Colors["Secondary"])
	surface.DrawOutlinedRect(x, y, h, h, 2)
end

local function AddNotification(text, type, time, progress)
	if NotifTables[text] then return end
	surface.SetFont(DarkRP.Library.Font(6))
	local textSize = surface.GetTextSize(text)
	local w = textSize + 54
	local h = 32
	local x = DarkRP.ScrW
	local y = 10

	NotifTables[text] = true

	table.insert(Notifications, 1, { x = x, y = y, w = w, h = h, text = text, col = Colors[type], icon = Icons[type], time = CurTime() + time, progress = progress })
end

function notification.AddLegacy(text, type, time)
	AddNotification(text, type, time, nil)
end

function notification.AddProgress(id, text, frac)
	local notificationFound = false
	for k, v in ipairs(Notifications) do
		if v.id == id then
			v.text = text
			v.progress = frac
			notificationFound = true
			break
		end
	end

	if not notificationFound then
		AddNotification(text, nil, math.huge, math.Clamp(frac or 0, 0, 1))
	end
end

function notification.Kill(id)
	for k, v in ipairs(Notifications) do
		if v.id == id then
			v.time = 0
			break
		end
	end
end

hook.Add("HUDPaint", "DrawNotifications", function()
	for k, v in ipairs(Notifications) do
		DrawNotification(math.Round(v.x), math.Round(v.y), v.w, v.h, v.text, v.icon, v.col, v.progress)
		v.x = Lerp(FrameTime() * 10, v.x, v.time > CurTime() and ScrW() - v.w - 10 or ScrW() + 1)
		v.y = Lerp(FrameTime() * 10, v.y, DarkRP.ScrW * 0.02 + (k - 1) * (v.h + 5))
	end

	for k = #Notifications, 1, -1 do
		if Notifications[k].x >= ScrW() and Notifications[k].time < CurTime() then
			if NotifTables[Notifications[k].text] then NotifTables[Notifications[k].text] = nil end
			table.remove(Notifications, k)
		end
	end
end)

function notifDark(msg)
	local msg = msg:ReadString()
	print(msg)
	notification.AddLegacy(msg, NOTIFY_GENERIC, 5)
end

usermessage.Hook("_Notify", notifDark)