-- Rennen (M4-Beispielmodus): fliege der Reihe nach durch alle Checkpoints.
-- Checkpoints = Anker "checkpoint_1".."checkpoint_n" aus der world.json.
local cps = {}        -- Checkpoint-Liste {lat, lon}
local progress = {}   -- Spieler -> naechster Checkpoint-Index
local finished = {}   -- Spieler -> Zielzeit in Sekunden
local start_time = 0
local RADIUS = 400    -- Meter: so nah muss man an den Checkpoint ran

function on_start()
  local i = 1
  while true do
    local lat, lon = ign.anchor("checkpoint_" .. i)
    if not lat then break end
    cps[i] = { lat = lat, lon = lon }
    i = i + 1
  end
  start_time = ign.time()
  ign.log("Rennen gestartet: " .. #cps .. " Checkpoints")
  ign.hud("RENNEN\nCheckpoints: " .. #cps)
end

function on_player_join(p)
  progress[p] = 1
  ign.log("Spieler " .. p .. " ist dabei")
end

function on_tick(dt)
  if #cps == 0 then return end
  local lines = { string.format("RENNEN   %.0f s", ign.time() - start_time) }
  for p = 1, ign.player_count() do
    progress[p] = progress[p] or 1
    local lat, lon = ign.player_pos(p)
    if lat and not finished[p] then
      local cp = cps[progress[p]]
      if cp and ign.dist(lat, lon, cp.lat, cp.lon) < RADIUS then
        if progress[p] == #cps then
          finished[p] = ign.time() - start_time
          ign.log(string.format("Spieler %d im ZIEL: %.1f s", p, finished[p]))
        else
          ign.log(string.format("Spieler %d: Checkpoint %d erreicht", p, progress[p]))
        end
        progress[p] = progress[p] + 1
      end
    end
    if finished[p] then
      lines[#lines + 1] = string.format("Spieler %d:  ZIEL  %.1f s", p, finished[p])
    else
      lines[#lines + 1] = string.format("Spieler %d:  Checkpoint %d/%d", p, math.min(progress[p], #cps), #cps)
    end
  end
  ign.hud(table.concat(lines, "\n"))
end
