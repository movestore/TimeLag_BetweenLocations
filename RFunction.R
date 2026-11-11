library("move2")
library("ggplot2")
library("units")

## Plot colours
barFill   <- "#3182BD"   # blue bars (individuals)
allFill   <- "#08519C"   # darker blue bars (all individuals)
medColour <- "#E6550D"   # orange median line and label
stripFill <- "#DEEBF7"   # light blue panel header

## Helper: median of a time lag vector, keeping its unit
medianLag <- function(timelag) {
  m <- median(as.numeric(timelag), na.rm = TRUE)
  units(m) <- units(timelag)
  m
}

## Helper: styled histogram of time lags with the median as a dashed line
histWithMedian <- function(dataI, fill = barFill) {
  med <- medianLag(dataI$timelag)
  ggplot(dataI[!is.na(dataI$timelag), ], aes(timelag)) +
    geom_histogram(bins = 100, fill = fill, colour = "white", linewidth = 0.1) +
    geom_vline(xintercept = med, colour = medColour,
               linetype = "dashed", linewidth = 0.8) +
    scale_y_continuous(expand = expansion(mult = c(0, 0.05))) +
    labs(x = "Time lag", y = "Number of time lags",
         subtitle = paste0("Median: ", signif(as.numeric(med), 3), " ",
                           deparse_unit(dataI$timelag))) +
    theme_minimal(base_size = 12) +
    theme(plot.title         = element_text(face = "bold", size = 15),
          plot.subtitle      = element_text(colour = medColour, face = "bold"),
          axis.title         = element_text(colour = "grey30"),
          axis.line.x        = element_line(colour = "grey40"),
          panel.grid.minor   = element_blank(),
          panel.grid.major.x = element_blank(),
          strip.background   = element_rect(fill = stripFill, colour = NA),
          strip.text         = element_text(face = "bold", size = 12))
}

rFunction <- function(data, units, ...) {
  
  ## Time lag between consecutive locations, assigned to the first location of
  ## each segment (last location of each track is NA). The column keeps the
  ## unit information (class "units").
  data$timelag <- mt_time_lags(data, units)
  logger.info(paste0("Time lags calculated in '", units, "' for ",
                     mt_n_tracks(data), " track(s)."))
  
  ## Median time lag per track, added to the track data table in the same unit
  trackIdCol <- mt_track_id_column(data)
  medLag <- tapply(as.numeric(data$timelag), as.character(mt_track_id(data)),
                   median, na.rm = TRUE)
  trackData <- mt_track_data(data)
  medianTimelag <- as.numeric(medLag[as.character(trackData[[trackIdCol]])])
  units(medianTimelag) <- units(data$timelag)
  trackData$median_timelag <- medianTimelag
  data <- mt_set_track_data(data, trackData)
  logger.info("Column 'median_timelag' added to the track data table.")
  
  ## Histogram artefact: all individuals (only if more than one track),
  ## followed by one page per individual; median shown on each plot
  pdf(appArtifactPath("timelag_histogram.pdf"), width = 8, height = 5.5)
  if (mt_n_tracks(data) > 1) {
    print(histWithMedian(data, fill = allFill) + ggtitle("All Individuals"))
  }
  for (dataI in split(data, mt_track_id(data))) {
    print(histWithMedian(dataI) +
            facet_grid(~ .data[[mt_track_id_column(dataI)]]))
  }
  dev.off()
  
  return(data)
}