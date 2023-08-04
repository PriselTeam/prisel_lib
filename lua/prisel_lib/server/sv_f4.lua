util.AddNetworkString("PriselV3::F4:Graph:SendInfos")

local infos = {
  ["connect"] = 0,
  ["kill"] = 0,
  ["death"] = 0
}

hook.Add("PlayerDeath", "PriselV3::F4:Graph:PlayerDeath", function(victim, inflictor, attacker)
  infos["death"] = infos["death"] + 1
  if IsValid(attacker) and attacker:IsPlayer() and attacker ~= victim then
    infos["kill"] = infos["kill"] + 1
  end
end)

hook.Add("PlayerInitialSpawn", "PriselV3::F4:Graph:PlayerInitialSpawn", function(ply)
  infos["connect"] = infos["connect"] + 1
end)

net.Receive("PriselV3::F4:Graph:SendInfos", function(len, ply)
  print("PriselV3::F4:Graph:SendInfos")
  net.Start("PriselV3::F4:Graph:SendInfos")
    net.WriteUInt(infos["connect"], 32)
    net.WriteUInt(infos["kill"], 32)
    net.WriteUInt(infos["death"], 32)
  net.Send(ply)
end)
