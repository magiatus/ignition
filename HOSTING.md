# Deinen eigenen Planeten hosten

Ignition ist **föderiert**: du hostest deine Welt selbst, wie einen Minecraft-Server. Der
Owner betreibt nur das Verzeichnis. So bringst du deinen Planeten online.

> Kurzfassung: Server-Build besorgen → `world.json` (+ optional `world.lua`) danebenlegen →
> Port öffnen → starten → im Verzeichnis eintragen (Pull Request gegen `planets.json`).

---

## 1. Server-Build besorgen

Du brauchst den **paketierten Ignition-Server** (headless, ohne Grafik — läuft auf jedem
Windows-Rechner oder VPS, ~1 GB, im Betrieb nur ~350 MB RAM). Lade ihn von den
[Releases](https://github.com/magiatus/ignition/releases).

## 2. Deine Welt danebenlegen

Leg deine Welt-Dateien **neben die Server-Exe** (in denselben Ordner wie `Ignition.exe`):

- **`world.json`** — dein Welt-Deskriptor (Seed, Klima, Platzierungen, Anker). Siehe die
  Vorlagen und die Doku im [Starter-Kit](worlds/).
- **`world.lua`** *(optional)* — dein Gameplay-Skript. Siehe die
  [Beispiel-Modi](worlds/) (Rennen, Sammeln, Schatzsuche, Kino).

Der Server liest beides automatisch beim Start. Alternativ mit Pfad:
`-WorldConfig=C:\pfad\world.json -WorldScript=C:\pfad\world.lua`.

## 3. Starten

Starte die **innere** Exe headless (nicht den Bootstrapper):

```
Ignition\Binaries\Win64\Ignition.exe /Game/PlanetTest?listen -nullrhi -nosound -unattended -log
```

- `?listen` macht ihn zum Server, `-nullrhi -nosound` = kein Bildschirm/Ton (headless).
- **Nie** ein sichtbares `-log`-Konsolenfenster anklicken — QuickEdit friert den Prozess ein.
  Auf einem Server lieber als **geplante Aufgabe** (Autostart, Neustart) laufen lassen.

## 4. Port öffnen

Der Server lauscht auf **UDP 7777** (weitere Welten: 7778, 7779 …). Beide Seiten freigeben:

```
netsh advfirewall firewall add rule name="Ignition 7777" dir=in action=allow protocol=UDP localport=7777
```

Beim Provider/Router denselben UDP-Port durchleiten. Hinter CGNAT (typisch bei Heim-DSL/Mobil)
klappt reines Port-Forwarding oft nicht — dann einen **VPS mit öffentlicher IP** nehmen.

## 5. Ins Verzeichnis eintragen

Damit deine Welt im Hub erscheint: einen **Pull Request** gegen
[`planets.json`](planets.json) stellen und deinen Eintrag ergänzen:

```json
{ "name": "Meine Welt", "address": "DEINE.IP:7777", "seed": 1, "author": "DeinName" }
```

`seed` muss zum `seed` in deiner `world.json` passen. Ein automatischer Check prüft deinen
Eintrag; nach dem Merge zeigt der Client deine Welt **ohne Neubau** an.

---

## Betriebs-Tipps

- **Dauerbetrieb:** als geplante Aufgabe (SYSTEM, At-Startup, Neustart bei Absturz) — dann
  läuft der Planet ohne Anmeldung/RDP weiter.
- **Mehrere Welten:** je eine Exe-Instanz mit eigenem Port + eigener `world.json`.
- **Persistenz:** `ign.store`/`ign.load` legen eine `<welt>_store.json` neben deine world.json —
  sichere die mit, wenn dir Fortschritt wichtig ist.
- **Update-Pflicht:** bei einem Client-Update müssen die Server nachziehen (Versions-Handshake).
