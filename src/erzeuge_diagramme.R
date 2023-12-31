# Installiere Pakete, wenn notwendig

if(!require(devtools)) install.packages("devtools")
if(!require(pacman)) install.packages("pacman")

# Installiere BBC-Thema von GitHub

devtools::install_github("bbc/bbplot")

# Importiere Bibliotheken

pacman::p_load(
  "tidyverse", "lubridate", "scales", "scales", "ggbeeswarm", "gapminder",
  "ggalt", "forcats", "R.utils", "png", "grid", "ggpubr", "bbplot")

# Definiere Konstanten

schrittweise.platz <- 50
schrittweite.minuten <- 30

# Definiere Hilfsfunktionen

runde.auf <- function(wert, vielfaches) {
  ceiling(wert / vielfaches) * vielfaches
}

runde.ab <- function(wert, vielfaches) {
  floor(wert / vielfaches) * vielfaches
}

meine.zeit <- function(ergebnis) {
  filter(ergebnis, grepl("rappaport", tolower(Name)))$Zeit.Minuten
}

meine.kategorie <- function(ergebnis) {
  filter(ergebnis, grepl("rappaport", tolower(Name)))$Kat
}

meine.position <- function(ergebnis) {
  filter(ergebnis, grepl("rappaport", tolower(Name)))$Pos
}

verarbeite.ergebnisdatei <- function(eingabedatei) {
  ergebnis <- read_csv(eingabedatei)
  
  ergebnis <- ergebnis %>% 
    mutate(Zeit.Minuten = period_to_seconds(hms(Zeit)) / 60) %>%
    mutate(`⚤` = as.factor(`⚤`)) %>%
    mutate(Kat = as.factor(Kat)) %>%
    filter(!is.na(Zeit.Minuten))
  
  ergebnis
}

format.platz <- function(platz, letzter) {
  ifelse(
    platz == letzter, 
    paste(format(platz, trim = TRUE), ". Platz", sep=""), 
    paste(format(platz, trim = TRUE), ".", sep=""))
}

format.minuten <- function(minute, letzte) {
  ifelse(
    minute == letzte, 
    paste(format(minute, trim = TRUE), " Minuten", sep=""), 
    format(minute, trim = TRUE))
}

# Definiere diagrammerzeugende Funktionen

erzeuge.punktediagramm <- function(ergebnis, ausgabedatei, titel, untertitel, breite, quelle) {
  letzter <- runde.auf(max(ergebnis$Pos), schrittweise.platz)
  zeit <- meine.zeit(ergebnis)
  pos <- meine.position(ergebnis)

  diagramm <- ergebnis %>%
    ggplot(aes(x = Pos, y = Zeit.Minuten)) +
    geom_point() +
    geom_point(x = pos, y = zeit, color = "red", size = 4) +
    geom_hline(yintercept = 0, size = 1, colour="#333333") +
    scale_x_continuous(
      limits = c(1, letzter),
      breaks = c(1, seq(50, letzter, schrittweise.platz)),
      labels = format.platz(c(1, seq(50, letzter, schrittweise.platz)), letzter)) +
    scale_y_continuous(
      breaks = seq(0, 24*60, 60), 
      labels = label_dollar(prefix = NULL, suffix = " min")) +
    bbc_style() +
    labs(title = titel, subtitle = ifelse(!is.na(untertitel), untertitel, NULL))
  
  finalise_plot(plot_name = diagramm,
                source = paste("Quelle:", quelle),
                width_pixels = breite,
                save_filepath = ausgabedatei
  )
}

erzeuge.kategoriendiagramm <- function(ergebnis, ausgabedatei, titel, untertitel, breite, quelle) {
  letzter <- runde.auf(max(ergebnis$Pos), schrittweise.platz)
  zeit <- meine.zeit(ergebnis)
  kat <- meine.kategorie(ergebnis)
  
  diagramm <- ergebnis %>%
    ggplot(aes(x = Kat, y = Zeit.Minuten)) +
    geom_quasirandom(width = 0.3) +
    geom_point(x = kat, y = zeit, color = "red", size = 4) + 
    scale_y_continuous(
      breaks = seq(0, 24*60, 60), 
      labels = label_dollar(prefix = NULL, suffix = " min")) +
    geom_hline(yintercept = 0, size = 1, colour="#333333") +
    bbc_style() +
    labs(title = titel, subtitle = ifelse(!is.na(untertitel), untertitel, NULL))
  
  finalise_plot(plot_name = diagramm,
                source = paste("Quelle:", quelle),
                width_pixels = breite,
                save_filepath = ausgabedatei
  )
}

erzeuge.dichtediagramm <- function(ergebnis, ausgabedatei, titel, untertitel, breite, quelle) {
  erste <- runde.ab(min(ergebnis$Zeit.Minuten), schrittweite.minuten)
  letzte <- runde.auf(max(ergebnis$Zeit.Minuten), schrittweite.minuten)
  zeit <- meine.zeit(ergebnis)
  kat <- meine.kategorie(ergebnis)
  
  diagramm <- ergebnis %>%
    ggplot(aes(x = Zeit.Minuten)) +
    geom_density(color = "red", fill = alpha("red", 0.3)) +
    geom_segment(x = zeit, xend = zeit, y = 0, yend = density(ergebnis$Zeit.Minuten, from=zeit, to=zeit)$y[1], color = "red", size = 1) +
    scale_x_continuous(
      limits = c(erste, letzte),
      breaks = seq(0, letzte, schrittweite.minuten),
      labels = format.minuten(seq(0, letzte, schrittweite.minuten), letzte)
      ) +
    geom_hline(yintercept = 0, size = 1, colour="#333333") +
    scale_y_continuous(labels = label_percent()) +
    bbc_style() +
    labs(title = titel, subtitle = ifelse(!is.na(untertitel), untertitel, NULL))
  
  finalise_plot(plot_name = diagramm,
                source = paste("Quelle:", quelle),
                width_pixels = breite,
                save_filepath = ausgabedatei
  )
}

# Definiere die Funktionen zum Verabreiten der Wettkämpfe

verarbeite.wettkampf <- function(ergebnisdatei,
                                quelle,
                                ausgabedatei1,
                                breite1,
                                titel1,
                                untertitel1,
                                ausgabedatei2,
                                breite2,
                                titel2,
                                untertitel2,
                                ausgabedatei3,
                                breite3,
                                titel3,
                                untertitel3) {
  ergebnis <- verarbeite.ergebnisdatei(ergebnisdatei)
  
  erzeuge.punktediagramm(ergebnis, ausgabedatei1, titel1, untertitel1, breite1, quelle)
  erzeuge.kategoriendiagramm(ergebnis, ausgabedatei2, titel2, untertitel2, breite2, quelle)
  erzeuge.dichtediagramm(ergebnis, ausgabedatei3, titel3, untertitel3, breite3, quelle)
}

verarbeite.wettkämpfe <- function(parameterdatei) {
  wettkämpfe <- read_csv(parameterdatei)
  
  for(i in 1:nrow(wettkämpfe)) {
    wettkampf <- wettkämpfe[i,]
    
    verarbeite.wettkampf(wettkampf$ergebnisdatei,
                         wettkampf$quelle,
                         wettkampf$ausgabedatei1,
                         wettkampf$breite1,
                         wettkampf$titel1,
                         wettkampf$untertitel1,
                         wettkampf$ausgabedatei2,
                         wettkampf$breite2,
                         wettkampf$titel2,
                         wettkampf$untertitel2,
                         wettkampf$ausgabedatei3,
                         wettkampf$breite3,
                         wettkampf$titel3,
                         wettkampf$untertitel3
                         )
  }
}

verarbeite.wettkämpfe("data/processed/parameter.csv")
