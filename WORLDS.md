# Deine eigene Welt andocken

Ignition ist eine **Portal-Welt**: Jeder kann seinen eigenen Planeten hosten und ins
Verzeichnis eintragen. Der Client holt die Welten-Liste live aus [`planets.json`](planets.json) —
eine Welt hinzuzufügen heißt einfach, dort einen Eintrag zu ergänzen.

## 1. Eigenen Welt-Server starten

Du brauchst den Ignition-Server (der gepackte Build). Starte ihn headless mit **deinem
eigenen Seed** und einem freien Port:

```
Ignition.exe /Game/PlanetTest?listen -PlanetSeed=42 -port=7780 -nullrhi -nosound -unattended
```

- `-PlanetSeed=N` bestimmt, wie dein Planet aussieht — **jede Zahl ergibt eine andere Welt**
  (Kontinente, Gebirge, Klimazonen, Küsten). Probier ein paar aus, bis dir eine gefällt.
- `-port=N` — ein freier UDP-Port. Öffne ihn in deiner Firewall (und ggf. im Router).
- `-nullrhi -nosound` — läuft ohne Grafik/Ton (günstig, ~350 MB RAM). Der Server *rendert
  nichts* — das machen die Clients aus dem Seed.

## 2. In die Portal-Liste eintragen

Trag deine Welt in [`planets.json`](planets.json) ein — per **Pull Request** gegen dieses Repo:

```json
{
  "name": "Meine Welt",
  "address": "DEINE.IP.ADRESSE:7780",
  "seed": 42,
  "author": "deinname"
}
```

| Feld | Bedeutung |
|---|---|
| `name` | Anzeigename in der Welten-Liste (oben rechts im Spiel) |
| `address` | Öffentliche `IP:Port` deines Servers |
| `seed` | **Muss zum `-PlanetSeed` deines Servers passen** — sonst sähe der Client eine andere Welt als der Server |
| `author` | Dein Name |

Sobald der PR gemergt ist, taucht deine Welt bei **allen** Spielern in der Liste auf —
ohne dass irgendjemand seinen Client neu installieren muss.

## Wichtig

- **Seed = Server-Seed.** Der Client baut den Planeten aus dem Seed, den ihm der Server
  schickt. Der `seed` in der Liste ist nur die Anzeige/ID — die echte Welt kommt vom Server.
  Halte beide gleich.
- Der Client ist aktuell **Windows**. Weitere Plattformen später.
- Das ist ein früher Prototyp — Format und Ablauf können sich noch ändern.
