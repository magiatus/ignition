# Starter-Kit: eigene Welt gestalten

Eine Welt in Ignition ist ein **Deskriptor** — ein paar Parameter, die bestimmen, wie dein
Planet aussieht. Du gestaltest sie in einer `world.json`, legst sie **neben deinen Server**
und startest ihn. Der Server schickt die Welt automatisch an alle Clients, die beitreten.

## So geht's

1. Nimm eine der Vorlagen hier als Ausgangspunkt (z. B. [`world.ice.json`](world.ice.json)).
2. Speichere sie als **`world.json`** neben `Ignition.exe` (bzw. gib den Pfad mit
   `-WorldConfig=C:\pfad\world.json` an).
3. Starte deinen Server — er liest `world.json` und baut daraus deine Welt.
4. Trag deine Welt ins [Verzeichnis](../planets.json) ein (siehe [WORLDS.md](../WORLDS.md)).

## Die Parameter

| Feld | Wirkung | Bereich |
|---|---|---|
| `seed` | Form der Kontinente & Gebirge. Jede Zahl = andere Landverteilung. | ganze Zahl |
| `mountainScale` | Gebirgs-Überhöhung: flach ↔ dramatische Gipfel. | `0.3` – `2.6` |
| `waterLevel` | Meeresspiegel: viel Land ↔ Ozeanwelt mit Inseln. | `-0.3` – `+0.2` |
| `climateBias` | Klima: Eiswelt (kalt) ↔ Wüste/Tropen (heiß). | `-1.0` – `+0.7` |
| `treeDensity` | Baumdichte: kahl ↔ dichter Wald. | `0.0` – `2.0` |
| `name` | Anzeigename der Welt. | Text |
| `placements` | Designte Objekte an festen Punkten (siehe unten). | Liste |
| `anchors` | Benannte Punkte, z. B. `spawn` = Startpunkt. | Liste |

## Objekte platzieren (`placements`)

Du kannst Objekte aus der **Starter-Palette** an feste Punkte auf deiner Welt setzen —
Position als Breite/Länge in Grad, das Objekt landet automatisch **auf** dem Gelände:

```json
"placements": [
  { "asset": "cylinder", "lat": 15.0, "lon": 40.0, "scale": 20, "color": "#E03020" },
  { "asset": "cone",     "lat": 15.0, "lon": 40.0, "alt": 20, "scale": 15, "color": "#FFD020" },
  { "asset": "pine_tall", "lat": 15.05, "lon": 39.95, "scale": 2.5 }
]
```

| Feld | Wirkung | Standard |
|---|---|---|
| `asset` | Palette-Name (siehe Liste unten) | Pflicht |
| `lat` / `lon` | Breite (−90…+90) / Länge (−180…+180) in Grad | `0` |
| `alt` | Höhe **über dem Gelände** in Metern (zum Stapeln, z. B. Dach auf Turm) | `0` |
| `yaw` | Drehung in Grad | `0` |
| `scale` | Größenfaktor (Grundformen sind 1 m groß → `scale: 20` = 20 m) | `1` |
| `color` | Nur Grundformen: Hex-Farbe `#RRGGBB` | grau |

Grundformen stehen mit der Unterkante auf dem Boden (Pivot wird ausgeglichen). Punkte im
Wasser schwimmen auf dem Meeresspiegel. 1 Grad ≈ 260 m auf dem Standard-Planeten.

**Palette** (`asset`-Namen, wächst über die Zeit):

| Gruppe | Namen |
|---|---|
| Bäume & Pflanzen | `tree` · `tree_tall` · `pine` · `pine_tall` · `stump` · `log` · `bush` · `bush_wide` · `shrub` · `grass_tuft` · `grass_a` · `grass_b` · `grass_c` |
| Steine & Felsen | `stone` · `stone_a` · `stone_c` · `stone_d` · `boulder` · `boulder_big` · `rock` · `rock2` · `river_rock` · `scree` · `scree2` · `scree_bend` · `cliff` · `rockface` · `rockface_closed` |
| Schnee & Berge | `snow` · `snow_b` · `snow_c` · `snow_d` · `mountain` · `mountain2` · `cloud` |
| Grundformen (färbbar) | `cube` · `sphere` · `cone` · `cylinder` · `plane` |

> Nur die Grundformen zeigen `color`. Alle anderen bringen ihre eigene Textur mit.
> `mountain`/`mountain2` sind sehr groß — schon bei `scale: 1` echte Landmarken.

## Anker (`anchors`)

Benannte Punkte auf der Welt. Heute zählt vor allem **`spawn`** — dort starten die Spieler
(liegt der Punkt im Wasser, nimmt das Spiel die nächste Küste). Weitere Anker
(`checkpoint_1…n`, `fishing_spot` …) werden die Andockpunkte für Gameplay-Skripte (nächster
Meilenstein):

```json
"anchors": [
  { "name": "spawn", "lat": -4.26, "lon": 15.74 }
]
```

> **Tipp:** Liegt dein `spawn`-Anker im Wasser, verschiebt das Spiel den Startpunkt zur
> nächsten Küste — deine `placements` bleiben aber am Anker. Das Server-Log zeigt beim
> Start `[World] Spieler-Spawn bei lat=… lon=…` — nimm DIESE Koordinaten als Zentrum
> für Anker + Platzierungen, dann passt alles zusammen.

## Welt-Skripte (`world.lua`) — eigene Spielmodi

Leg eine **`world.lua`** neben deine `world.json` (oder gib sie mit
`-WorldScript=C:\pfad\world.lua` an) — der Server führt sie aus und macht aus deiner Welt
einen **Spielmodus**. Das Skript läuft **nur auf dem Server** (gesandboxt: kein Datei-,
Netz- oder OS-Zugriff; Endlosschleifen und Speicherfresser werden abgebrochen, ohne den
Server zu reißen). Die Spieler brauchen **kein Update** — sie sehen das replizierte HUD.

**Callbacks** (definierst du als globale Funktionen, alle optional):

| Funktion | Wann |
|---|---|
| `on_start()` | einmal beim Serverstart (Welt steht) |
| `on_tick(dt)` | jeden Frame, `dt` = Sekunden seit letztem Tick |
| `on_player_join(p)` / `on_player_leave(p)` | Spieler `p` (1-basiert) kommt/geht |
| `on_enter(p, zone)` / `on_exit(p, zone)` | Spieler betritt/verlässt eine `ign.zone` |
| `on_interact(p, id)` | Spieler drückt **E** vor einem Objekt (`id`) |
| `on_key(p, key)` | Spieler drückt eine Taste (`"Q"`,`"R"`,`"T"`,`"C"`,`"V"`,`"B"`,`"3"`…`"9"`) |

**Timer & Komfort** (eingebaut, ohne `ign.`-Präfix): `after(sek, fn)`, `every(sek, fn)` → Handle,
`stop(handle)`, `countdown(sek, präfix, fn)` (zeigt Countdown im HUD, ruft `fn` bei 0),
`daycycle(minuten)` (dreht die Sonne einmal pro `minuten` durch Tag/Nacht).

**API** (`ign.*` — Werkzeugkasten; `ign.api_version` = 5. Die Decke wächst — Modi wie
Rennen oder Angeln baust DU aus diesen Bausteinen, siehe [`race.lua`](race.lua)):

*Info & Spieler*

| Funktion | Wirkung |
|---|---|
| `ign.log(text)` | Zeile ins Server-Log (`print` geht auch dorthin) |
| `ign.hud(text)` | HUD-Panel oben links bei ALLEN Spielern (mehrzeilig via `\n`) |
| `ign.title(text)` | große Einblendung in der Bildschirmmitte (`""` = weg) |
| `ign.time()` | → Sekunden seit Serverstart |
| `ign.set_score(p, n)` / `ign.add_score(p, d)` / `ign.score(p)` | Punktestand — HUD zeigt automatisch ein Scoreboard |
| `ign.set_var(key, wert)` / `ign.var(key)` | Welt-Variable (Zahl/Text), repliziert; `nil` löscht |
| `ign.store(key, wert)` / `ign.load(key)` | welt-lokale **Persistenz** (überlebt Neustart), Quota 256 Keys |
| `ign.marker(name, lat, lon [, color])` / `ign.remove_marker(name)` | Welt-Marker (HUD projiziert + Rand-Pfeil) |
| `ign.msg(p, text)` | private Einblendung NUR für Spieler `p` |
| `ign.nearest_player(lat, lon)` | → Index des nächsten Spielers |
| `ign.restart()` | Welt-Skript frisch neu laden (`on_start` feuert erneut) |
| `ign.world_name()` | → Name der Welt |
| `ign.player_count()` | → Anzahl Spieler |
| `ign.player_name(p)` | → Anzeigename von Spieler `p` |
| `ign.player_pos(p)` | → `lat, lon, alt_m` von Spieler `p` (oder `nil`) |
| `ign.player_vel(p)` | → Tempo in m/s |
| `ign.player_heading(p)` | → Kompass-Kurs 0–360° |
| `ign.player_mode(p)` | → `"plane"` oder `"walker"` |
| `ign.teleport(p, lat, lon [, alt_m])` | Spieler versetzen (Standard: 90 m über Grund) |
| `ign.respawn(p)` | zurück zum `spawn`-Anker (sonst nächstes Land) |
| `ign.set_mode(p, "plane"\|"walker")` | Bewegungsmodus wechseln (fliegen ↔ laufen) |
| `ign.set_speed(p, mult)` | Tempo-Faktor 0.1–20 auf die Basiswerte |
| `ign.set_autopilot(p, an)` | Schauflug an/aus (nur Flieger) |
| `ign.freeze(p, an)` | Fortbewegung stoppen (Umschauen bleibt) |
| `ign.set_gravity(p, faktor)` / `ign.set_jump(p, faktor)` | Schwerkraft / Sprungkraft (Läufer) |

*Welt abfragen* (der prozedurale Planet ist per Code lesbar)

| Funktion | Wirkung |
|---|---|
| `ign.ground(lat, lon)` | → Geländehöhe über Meer in m (negativ = unter Wasser) |
| `ign.is_water(lat, lon)` | → liegt der Punkt im Wasser? |
| `ign.slope(lat, lon)` | → Hangneigung in Grad (0 = flach, 90 = senkrecht) |
| `ign.biome(lat, lon)` | → `temp` (0 polar…1 tropisch), `moist` (0 trocken…1 nass) |
| `ign.anchor(name)` | → `lat, lon` des Ankers aus der world.json (oder `nil`) |
| `ign.find_land(lat, lon)` | → nächster Landpunkt als `lat, lon` |
| `ign.random_land(lat, lon, radius_m)` | → zufälliger Landpunkt im Umkreis (oder `nil`) |
| `ign.bearing(lat1,lon1,lat2,lon2)` | → Kurswinkel 0–360° von A nach B |
| `ign.dist(lat1,lon1,lat2,lon2)` | → Großkreis-Distanz in Metern |
| `ign.raycast(lat1,lon1,alt1, lat2,lon2,alt2)` | → Sichtlinie: Treffer als `lat, lon` (oder `nil`) |
| `ign.players_in(lat, lon, radius_m)` | → Anzahl Spieler im Umkreis |

*Objekte & Trigger*

| Funktion | Wirkung |
|---|---|
| `ign.spawn(asset, lat, lon [, alt, yaw, scale, color])` | Objekt zur Laufzeit spawnen → `id` |
| `ign.despawn(id)` | Objekt entfernen → `true`/`false` |
| `ign.objects()` | → Liste aller Laufzeit-Objekt-Ids |
| `ign.obj_pos(id)` | → `lat, lon, alt` des Objekts |
| `ign.move(id, lat, lon [, alt])` | Objekt versetzen (sofort; Gleit-Animation kommt) |
| `ign.set_color(id, "#RRGGBB")` / `ign.set_scale(id, s)` | Objekt umfärben / skalieren |
| `ign.set_yaw(id, grad)` | Objekt drehen (feste Ausrichtung) |
| `ign.spin(id, grad_pro_sek)` | Dauerrotation um die Hochachse (0 = stopp) |
| `ign.set_visible(id, an)` / `ign.set_collision(id, an)` | sichtbar / durchfliegbar schalten |
| `ign.zone(name, lat, lon, radius_m)` | Trigger-Kreis anlegen → `on_enter`/`on_exit` |
| `ign.remove_zone(name)` | Trigger-Kreis entfernen |

*Umwelt* (repliziert — alle Spieler sehen dieselbe Stimmung)

| Funktion | Wirkung |
|---|---|
| `ign.sun(pitch, yaw)` | Sonnenwinkel in Grad (−90 = senkrecht Mittag, ~0 = Horizont) — Tag/Nacht per Skript |
| `ign.fog(dichte [, r, g, b])` | Nebel: Dichte (~0.00015 Standard) + Farbe 0–1 |
| `ign.grade(sättigung, kontrast [, vignette])` | Farbstimmung (1 = neutral) — Filmlook per Skript |
| `ign.set_water_level(level)` | Meeresspiegel ändern (Flut/Ebbe) — baut die Welt neu auf, repliziert |

**Beispiel:** [`race.lua`](race.lua) — ein komplettes Rennen über Checkpoint-Anker
(`checkpoint_1…n`): Fortschritt und Zielzeit pro Spieler live im HUD. Zum Ausprobieren
als `world.lua` neben deine world.json legen und Checkpoint-Anker eintragen.

## Vorlagen

- [`world.default.json`](world.default.json) — gemäßigte Standardwelt (grün, Wälder, Küsten)
- [`world.ice.json`](world.ice.json) — Eiswelt (kalt, Schnee bis in die Tropen, keine Bäume)
- [`world.ocean.json`](world.ocean.json) — Ozeanwelt (fast nur Wasser, verstreute Inseln)
- [`world.desert.json`](world.desert.json) — Wüstenwelt (heiß, sandig, kaum Bäume)
- [`world.alpine.json`](world.alpine.json) — Alpenwelt (dramatische Gipfel, kühl)
- [`world.lighthouse.json`](world.lighthouse.json) — Leuchtturm-Küste (Beispiel für
  `placements` + `spawn`-Anker: Turm, Formen-Ring, Bäume am Startpunkt)
- [`world.race.json`](world.race.json) + [`race.lua`](race.lua) — Küsten-Rennen
  (4 Checkpoint-Anker mit Markierungs-Kugeln + komplettes Rennen-Skript; die Lua-Datei
  als `world.lua` neben die world.json legen)

> Hinweis: Der Client baut den Planeten aus dem Seed **und** den Parametern, die der Server
> schickt — er sieht also GENAU deine Welt. Terrain wird nicht übers Netz übertragen, nur
> der Deskriptor. Das ist ein früher Prototyp; das Format kann sich noch erweitern (eigene
> Meshes/Layout im UE-Editor sind der nächste Ausbau).
