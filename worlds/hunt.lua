-- BEISPIEL-MODUS: Schatzsuche.
-- Zeigt: anchor, marker/remove_marker, zone + on_enter, spawn + set_label,
-- on_interact (E), score, title, burst, msg. Anker: checkpoint_1..3 + treasure.

local step = 1
local N = 3
local chest = nil

local function next_clue()
  local lat, lon = ign.anchor("checkpoint_" .. step)
  if lat then
    ign.marker("ziel", lat, lon, "#FFD020")   -- HUD-Pfeil zeigt zum naechsten Ziel
    ign.zone("ziel", lat, lon, 150)
  end
end

function on_start()
  ign.hud("SCHATZSUCHE\nFolge dem gelben Marker")
  ign.title("SCHATZSUCHE")
  after(2.5, function() ign.title("") end)
  next_clue()
end

function on_enter(p, zone)
  if zone ~= "ziel" then return end
  local lat, lon = ign.anchor("checkpoint_" .. step)
  ign.remove_zone("ziel"); ign.remove_marker("ziel")
  if lat then ign.burst("fire", lat, lon, 40, 2) end
  ign.msg(p, "Station " .. step .. "/" .. N)
  step = step + 1
  if step <= N then
    next_clue()
  else
    local flat, flon = ign.anchor("treasure")
    flat = flat or lat; flon = flon or lon
    chest = ign.spawn("cube", flat, flon, 0, 0, 18, "#FFD020")
    ign.set_label(chest, "SCHATZ - E druecken")
    ign.marker("schatz", flat, flon, "#FFD020")
    ign.hud("Finde den SCHATZ und druecke E")
  end
end

function on_interact(p, id)
  if chest and id == chest then
    ign.add_score(p, 100)
    ign.title("SCHATZ GEHOBEN!")
    local plat, plon = ign.player_pos(p)
    if plat then ign.burst("explosion3", plat, plon, 60, 4) end
    ign.remove_marker("schatz")
    ign.despawn(chest); chest = nil
  end
end
