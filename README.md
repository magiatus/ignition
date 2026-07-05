<p align="center">
  <img src="assets/hero.jpg" alt="Ignition — prozeduraler Planet mit Flugzeug" width="100%">
</p>

<h1 align="center">IGNITION</h1>

<p align="center"><b>Ein Universum aus Planeten — jeder baut seinen eigenen.</b></p>

<p align="center">
  <a href="https://discord.gg/EqtFCJGrSU"><img src="https://img.shields.io/badge/Discord-beitreten-5865F2?logo=discord&logoColor=white" alt="Discord"></a>
  <img src="https://img.shields.io/badge/Engine-Unreal%205.8-313131?logo=unrealengine&logoColor=white" alt="Unreal Engine 5.8">
  <img src="https://img.shields.io/badge/Plattform-Windows-0078D6?logo=windows&logoColor=white" alt="Windows">
  <img src="https://img.shields.io/badge/Multiplayer-M0%20fertig-4cd97b" alt="Multiplayer M0">
  <img src="https://img.shields.io/badge/Status-in%20Entwicklung-ff7a3c" alt="Status">
</p>

---

**Ignition** ist ein Open-World-Erkundungsspiel mit prozeduralen Planeten in voller
Unreal-Engine-Grafik — und die Basis für eine **Portal-Welt**: ein offenes Universum,
in dem jeder seinen eigenen, selbst gehosteten Planeten andockt.

- 🌍 **Ein ganzer Planet aus einem Seed** — Kontinente, Gebirge, Küsten, deterministisch generiert
- 🌡️ **Sechs Biome** — Polar, Tundra, gemäßigt, Steppe, Wüste, Tropen aus Temperatur & Feuchte
- 🐠 **Unterwasserwelt** — Korallenriffe, Seegras und frei schwimmende Fischschwärme
- ✈️ **Frei fliegen & landen** — Schauflug-Autopilot vom Tiefflug bis zum 4,5-km-Panorama
- 🌐 **Multiplayer** — dein Planet läuft auf deinem Server (headless, ~350 MB RAM), Freunde
  verbinden sich direkt; nur der Seed reist übers Netz, nicht die Welt
- 🌀 **Die Vision** — Portale verbinden selbst gehostete Planeten mit eigener Grafik
  und eigenem Gameplay zu einem Universum

## 🚀 Roadmap

| Meilenstein | Inhalt | Status |
|---|---|---|
| **M0** | Dein Planet auf deinem Server, Client verbindet übers Internet | ✅ **fertig** |
| **M1** | Portal = Serverwechsel: durchfliegen, auf fremdem Planeten ankommen | 🔶 als Nächstes |
| **M2** | Verzeichnis & Hub: Planeten entdecken | ⬜ |
| **M3** | Welt-Format & Starter-Kit: eigene Planeten im UE-Editor bauen | ⬜ |
| **M4** | Lua-Skripting: eigene Spielmodi (Rennen, Angeln, …) | ⬜ |
| **M5** | One-Click-Selbst-Hosting für alle | ⬜ |

## 💬 Community

Entwicklung live, Feedback, erste Testflüge:
**[→ Discord beitreten](https://discord.gg/EqtFCJGrSU)**

## 🛠️ Technik (Kurzfassung)

- Unreal Engine 5.8, C++
- Prozedurale Kugelwelt mit Chunk-Streaming nach Sichtweite (kein Nachlade-Poppen)
- Server-autoritative Replikation; Dedicated-Betrieb headless via `-nullrhi -nosound`
- Deterministische Welten: `-PlanetSeed=N` erzeugt auf Server und Client dieselbe Welt

---

<p align="center">Ein Open-Source-Projekt von Magiatus · Welten gehören ihren Erstellern</p>

