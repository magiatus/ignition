-- BEISPIEL-MODUS: Kino / Stimmung.
-- Zeigt: daycycle, sun/fog/grade, orbit, spawn, burst, title, every.
-- Kein Ziel — reine Atmosphaere zum Anschauen.

function on_start()
  daycycle(2)                                  -- Tag/Nacht-Zyklus in 2 Minuten
  local s = ign.spawn("sphere", -4.26, 15.74, 220, 0, 30, "#30E0FF")
  ign.orbit(s, -4.26, 15.74, 450, 12)          -- leuchtende Kugel zieht ihre Bahn
  ign.spin(s, 40)
  ign.title("IGNITION")
  after(4, function() ign.title("") end)
  ign.hud("KINO-MODUS\nTag/Nacht - Orbit - Effekte")

  -- Stimmung wechselt alle 8 s
  local mood = 0
  every(8, function()
    mood = (mood + 1) % 3
    if mood == 0 then     ign.fog(0.00020, 0.6, 0.7, 0.9); ign.grade(1.10, 1.05, 0.30)
    elseif mood == 1 then ign.fog(0.00060, 1.0, 0.6, 0.3); ign.grade(1.40, 1.10, 0.50)
    else                  ign.fog(0.00040, 0.4, 0.5, 0.7); ign.grade(0.90, 1.20, 0.40) end
  end)

  -- gelegentliche Effekte am Horizont
  every(3, function()
    ign.burst("explosion2", -4.26 + (math.random() - 0.5) * 0.25, 15.74 + (math.random() - 0.5) * 0.25, 120, 3)
  end)
end
