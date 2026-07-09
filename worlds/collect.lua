-- BEISPIEL-MODUS: Kugeln sammeln.
-- Zeigt: random_land, spawn/despawn, spin, set_label, zone + on_enter, score, msg,
-- burst, title, after. Als world.lua neben world.collect.json legen.

local orbs = {}   -- zone-name -> objekt-id
local left = 0

function on_start()
  local slat, slon = ign.anchor("spawn")
  slat = slat or -4.26; slon = slon or 15.74

  -- 6 leuchtende, drehende Kugeln an zufaelligen Landpunkten im Umkreis, je mit Trigger-Zone
  for i = 1, 6 do
    local la, lo = ign.random_land(slat, slon, 1500)
    if la then
      local id = ign.spawn("sphere", la, lo, 60, 0, 14, "#30E0FF")
      ign.spin(id, 70)
      ign.set_label(id, "?")
      local zname = "orb" .. i
      ign.zone(zname, la, lo, 130)
      orbs[zname] = id
      left = left + 1
    end
  end

  ign.set_score(1, 0)
  ign.hud("SAMMLE DIE " .. left .. " KUGELN")
  ign.title("SAMMELN!")
  after(2.5, function() ign.title("") end)
end

function on_player_join(p)
  ign.set_score(p, 0)
end

-- Durch die Zone einer Kugel fliegen = einsammeln.
function on_enter(p, zone)
  local id = orbs[zone]
  if not id then return end
  local la, lo = ign.obj_pos(id)
  ign.despawn(id)
  ign.remove_zone(zone)
  orbs[zone] = nil
  if la then ign.burst("explosion", la, lo, 60, 2) end
  ign.add_score(p, 10)
  left = left - 1
  ign.msg(p, "Kugel eingesammelt!  Noch " .. left)

  if left == 0 then
    ign.title("GEWONNEN!")
    ign.hud("Alle Kugeln gesammelt — GG!")
    local plat, plon = ign.player_pos(p)
    if plat then ign.burst("explosion3", plat, plon, 80, 4) end
  else
    ign.hud("SAMMLE DIE KUGELN — noch " .. left)
  end
end
