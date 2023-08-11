local CircularAvatar = {}
CircularAvatar.material = Material("effects/flashlight001")

function CircularAvatar:Init()
  self.Avatar = vgui.Create("AvatarImage", self)
  self.Avatar:SetPaintedManually(true)
  self.poly = {}
end

function CircularAvatar:PerformLayout()
  self:OnSizeChanged(self:GetSize())
end

function CircularAvatar:SetSteamID(...)
  self.Avatar:SetSteamID(...)
end

function CircularAvatar:SetPlayer(...)
  self.Avatar:SetPlayer(...)
end

function CircularAvatar:OnSizeChanged(w,h)
  local w, h = w, h
  self.Avatar:SetSize(w, h)
  self.poly = DarkRP.Library.MakeCirclePoly(w / 2, h / 2, w / 2, math.max(w / 4, 32))
end

function CircularAvatar:DrawMask()
  surface.SetMaterial(self.material)
  surface.SetDrawColor(color_white)
  surface.DrawPoly(self.poly)
end

function CircularAvatar:Paint()
  render.ClearStencil()
  render.SetStencilEnable(true)
  render.SetStencilWriteMask(1)
  render.SetStencilTestMask(1)
  render.SetStencilReferenceValue(1)

  render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
  render.SetStencilPassOperation(STENCILOPERATION_ZERO)
  render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
  render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)

  self:DrawMask()

  render.SetStencilFailOperation(STENCILOPERATION_ZERO)
  render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
  render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
  render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)

  self.Avatar:SetPaintedManually(false)
  self.Avatar:PaintManual()
  self.Avatar:SetPaintedManually(true)

  render.SetStencilEnable(false)
  render.ClearStencil()
end

vgui.Register("Prisel.AvatarRounded", CircularAvatar)