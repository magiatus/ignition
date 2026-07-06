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
| `asset` | Palette-Name: `tree`, `tree_tall`, `pine`, `pine_tall`, `stone`, `cube`, `sphere`, `cone`, `cylinder` | Pflicht |
| `lat` / `lon` | Breite (−90…+90) / Länge (−180…+180) in Grad | `0` |
| `alt` | Höhe **über dem Gelände** in Metern (zum Stapeln, z. B. Dach auf Turm) | `0` |
| `yaw` | Drehung in Grad | `0` |
| `scale` | Größenfaktor (Grundformen sind 1 m groß → `scale: 20` = 20 m) | `1` |
| `color` | Nur Grundformen: Hex-Farbe `#RRGGBB` | grau |

Grundformen stehen mit der Unterkante auf dem Boden (Pivot wird ausgeglichen). Punkte im
Wasser schwimmen auf dem Meeresspiegel. 1 Grad ≈ 260 m auf dem Standard-Planeten.

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

**API** (`ign.*` — die Decke wächst mit der Zeit):

| Funktion | Wirkung |
|---|---|
| `ign.log(text)` | Zeile ins Server-Log (`print` geht auch dorthin) |
| `ign.hud(text)` | HUD-Panel oben links bei ALLEN Spielern (mehrzeilig via `\n`) |
| `ign.anchor(name)` | → `lat, lon` des Ankers aus der world.json (oder `nil`) |
| `ign.player_count()` | → Anzahl Spieler |
| `ign.player_pos(p)` | → `lat, lon, alt_m` von Spieler `p` (oder `nil`) |
| `ign.dist(lat1,lon1,lat2,lon2)` | → Großkreis-Distanz in Metern |
| `ign.time()` | → Sekunden seit Serverstart |

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
