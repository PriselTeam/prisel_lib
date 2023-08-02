util.AddNetworkString("PriselV3::F4:Graph:SendInfos")

local infos = {
  ["connect"] = 0,
  ["disconnect"] = 0,
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

hook.Add("PlayerDisconnected", "PriselV3::F4:Graph:PlayerDisconnected", function(ply)
  infos["disconnect"] = infos["disconnect"] + 1
end)

net.Receive("PriselV3::F4:Graph:SendInfos", function(len, ply)
  net.Start("PriselV3::F4:Graph:SendInfos")
  net.WriteTable(infos)
  net.Send(ply)
end)
