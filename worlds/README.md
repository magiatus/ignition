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

## Vorlagen

- [`world.default.json`](world.default.json) — gemäßigte Standardwelt (grün, Wälder, Küsten)
- [`world.ice.json`](world.ice.json) — Eiswelt (kalt, Schnee bis in die Tropen, keine Bäume)
- [`world.ocean.json`](world.ocean.json) — Ozeanwelt (fast nur Wasser, verstreute Inseln)
- [`world.desert.json`](world.desert.json) — Wüstenwelt (heiß, sandig, kaum Bäume)
- [`world.alpine.json`](world.alpine.json) — Alpenwelt (dramatische Gipfel, kühl)

> Hinweis: Der Client baut den Planeten aus dem Seed **und** den Parametern, die der Server
> schickt — er sieht also GENAU deine Welt. Terrain wird nicht übers Netz übertragen, nur
> der Deskriptor. Das ist ein früher Prototyp; das Format kann sich noch erweitern (eigene
> Meshes/Layout im UE-Editor sind der nächste Ausbau).
