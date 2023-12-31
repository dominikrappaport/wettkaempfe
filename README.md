# Diagrammerstellung für Wettkämpfe

## Zusammenfassung

Mit Hilfe von GGPlot2 erzeuge ich schöne Diagramme, die die Ergebnisse meiner Radrennen veranschaulichen. Derzeit erzeuge ich drei Diagramme:

1. ein Streudiagramm, wo die Platzierung auf der X-Achse und die Wettkampfzeit auf der Y-Achse aufgetragen sind,
2. ein Streudiagramm mit zufälliger Verschiebung der Punkte, wo die diskrete Altersklasse auf der X-Achse und die Wettkampfzeit auf der Y-Achse aufgetragen sind und
3. ein Diagramm, das die Dichte der empirischen Verteilungsfunktion bezügich der Wettkampfzeiten aller Teilnehmer zeigt.

## Eingabedaten

Zunächste übernehmen wir die Daten von der Website. Derzeit wird das Format von racetime.pro unterstützt.

![Ergebnisse der Wachauer Radtage 2023 auf racetime.pro](images/download_from_website.jpg)

Die Daten werden leicht aufbereitet und werden dann als CSV-Datei abgespeichert. Z. B. wird beim Kopieren eine leere Spalte übernommen, die entfernt werden muss. Das Ergebnis sieht dann so aus (hier die ersten fünf Platzierungen der Wachauer Radtage 2023):

| Pos | Nr   | Urk. | Name                 | Jahrgang | Zeit       | Diff     | Kat   | Kat Pos | Kat Diff | ⚤ | ⚤ Pos | ⚤ Diff   | Verein                 | Nation |
|-----|------|------|----------------------|----------|------------|----------|-------|---------|----------|---|-------|----------|------------------------|--------|
| 1   | 3024 |      |  PRILLINGER Marco    | 1994     | 01:19:59.6 |          | AKM   | 1       |          | M | 1     |          | RC Hochschwab Aflenz   |        |
| 2   | 3004 |      |  GRUBER Julian       | 1997     | 01:20:31.3 | +31.7    | AKM   | 2       | +31.7    | M | 2     | +31.7    | Team Weichberger - KTM |        |
| 3   | 3008 |      |  ALLERSTORFER Martin | 1981     | 01:20:31.4 | +31.8    | M 40+ | 1       |          | M | 3     | +31.8    | Team Rosenbauer        |        |
| 4   | 3006 |      |  HARRER Michael      | 1995     | 01:21:52.1 | +01:52.5 | AKM   | 3       | +01:52.5 | M | 4     | +01:52.5 | RSC Krems              |        |
| 5   | 3013 |      |  RIEPL Jakob         | 1998     | 01:21:55.8 | +01:56.2 | AKM   | 4       | +01:56.2 | M | 5     | +01:56.2 |                        |        |

## Steuerdaten

Um alle Wettkämpfe in einem Durchlauf zu erzeugen, tragen wir jedes Rennen als eine Zeile in der Datei `data/processed/paramteter.csv` ein.

| ergebnisdatei                                    | quelle                                                            | ausgabedatei1                                  | breite1 | titel1                | untertitel1          | ausgabedatei2                                      | breite2 | titel2                | untertitel2          | ausgabedatei3                                  | breite3 | titel3                | untertitel3          |
|--------------------------------------------------|-------------------------------------------------------------------|------------------------------------------------|---------|-----------------------|----------------------|----------------------------------------------------|---------|-----------------------|----------------------|------------------------------------------------|---------|-----------------------|----------------------|
| data/processed/ergebnis_wachauer_radtage2023.csv | https://events.racetime.pro/de/event/624/competition/3788/results | output/wachauer_radtage2023_punktediagramm.png | 1900    | Wachauer Radtage 2023 | Genuss Radtour 53 km | output/wachauer_radtage2023_kategoriendiagramm.png | 1200    | Wachauer Radtage 2023 | Genuss Radtour 53 km | output/wachauer_radtage2023_dichtediagramm.png | 1100    | Wachauer Radtage 2023 | Genuss Radtour 53 km |
| data/processed/ergebnis_sturmkriterium2023.csv   | https://events.racetime.pro/de/event/804/competition/4960/results | output/sturmkriterium2023_punktediagramm.png   | 1900    | Sturmkriterium 2023   | Staubiger 80 km      | output/sturmkriterium2023_kategoriendiagramm.png   | 1200    | Sturmkriterium 2023   | Staubiger 80 km      | output/sturmkriterium2023_dichtediagramm.png   | 1100    | Sturmkriterium 2023   | Staubiger 80 km      |
