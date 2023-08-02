require("mysqloo")

local db = mysqloo.connect("109.122.198.111", "prisel_v3", "P[kUbSp]L7N1-D1V", "prisel_v3", 3306)

local function getCurrentDay()
    local jours = {"Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"}
    local jourActuel = jours[tonumber(os.date("%w")) + 1]
    return jourActuel
end

function db:onConnected()
    local createTableQuery = [[
        CREATE TABLE IF NOT EXISTS player_times (
            id INT AUTO_INCREMENT PRIMARY KEY,
            steamid VARCHAR(255) NOT NULL,
            times JSON NOT NULL
        )
    ]]

    local query1 = db:query(createTableQuery)
    query1:start()

    query1.onError = function(_, err)
        print("Erreur lors de la création de la table player_times: " .. err)
    end
end

function db:onConnectionFailed(err)
    print("Erreur lors de la connexion à la base de données: " .. err)
end

db:connect()

local PLAYER = FindMetaTable("Player")

function PLAYER:SaveTime()
    local steamid = self:SteamID64()
    local sessionTimes = self:GetUTimeSessionTime()
    local day = getCurrentDay()

    local query = db:query("SELECT times FROM player_times WHERE steamid = '" .. steamid .. "'")

    query.onSuccess = function(_, result)
        local times = {}

        if result[1] then
            times = util.JSONToTable(result[1].times)
        end

        times[day] = math.Round((times[day] or 0) + sessionTimes)

        local jsonTimes = util.TableToJSON(times)
        local query2

        if result[1] then
            query2 = db:query("UPDATE player_times SET times = '" .. jsonTimes .. "' WHERE steamid = '" .. steamid .. "'")
        else
            query2 = db:query("INSERT INTO player_times (steamid, times) VALUES ('" .. steamid .. "', '" .. jsonTimes .. "')")
        end

        query2:start()

        query2.onError = function(_, err)
            print("Erreur lors de la mise à jour des données dans la base de données: " .. err)
        end
    end

    query.onError = function(_, err)
        print("Erreur lors de la récupération des données depuis la base de données: " .. err)
    end

    query:start()
end

hook.Add("PlayerDisconnected", "PriselV3:CalcTimes", function(ply)
    if not ply:IsPlayer() then return end
    if ply:IsBot() then return end

    ply:SaveTime()
end)

hook.Add("ShutDown", "PriselV3:CalcTimes", function()
    for _, ply in ipairs(player.GetHumans()) do
        ply:SaveTime()
    end
end)