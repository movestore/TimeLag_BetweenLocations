library('move')
library("ggplot2")
library("units")


rFunction <-  function(data, units=units) {
  data$timelag <- mt_time_lags(data, units)
  
  if(mt_n_tracks(data)==1){
    timelagHist <- ggplot(data[!is.na(data$timelag),], aes(timelag))+geom_histogram(bins=100)+facet_grid(~.data[[mt_track_id_column(data)]])+ xlab("Timelag")+theme_bw()
    pdf(appArtifactPath("timelag_histogram.pdf"))
    print(timelagHist)
    dev.off()
  } else {
    pdf(appArtifactPath("timelag_histogram.pdf"))
    timelagHistAll <- ggplot(data[!is.na(data$timelag),], aes(timelag))+geom_histogram(bins=100)+ xlab("Timelag")+ggtitle("All Individuals")+ theme_bw()
    print(timelagHistAll)
    lapply(split(data, mt_track_id(data)), function(dataI){
      timelagHist <- ggplot(dataI[!is.na(dataI$timelag),], aes(timelag))+geom_histogram(bins=100)+facet_grid(~.data[[mt_track_id_column(dataI)]])+ xlab("Timelag")+theme_bw()
      print(timelagHist)
    })
    dev.off()
  }
  return(data)
}
