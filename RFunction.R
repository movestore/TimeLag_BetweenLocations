library('move')
library("ggplot2")
library("units")


rFunction <-  function(data, unitsSEL="mins") {
  if(unitsSEL=="mins"){unts <- as_units("min")}else{unts <- as_units(unitsSEL)} # using pkg units to save units along with calculated values
  data$timelag <- set_units(unlist(lapply(timeLag(data, units=unitsSEL), function(x) c(as.vector(x), NA))), unts, mode = "standard")
    
    if(length(levels(trackId(data)))==1){
      dataDF <- data.frame(timelag=data$timelag,indv=namesIndiv(data))
      timeLagHist <- ggplot(dataDF, aes(as.numeric(timelag)))+geom_histogram(bins=100)+facet_grid(~indv)+ xlab(paste0("Time lag ","(",unitsSEL,")"))+theme_bw()
      pdf(paste0(Sys.getenv(x = "APP_ARTIFACTS_DIR", "/tmp/"), "timeLag_histogram.pdf"))
      print(timeLagHist)
      dev.off()
    } else {
    pdf(paste0(Sys.getenv(x = "APP_ARTIFACTS_DIR", "/tmp/"), "timeLag_histogram.pdf"))
      timeLagHistAll <- ggplot(data@data, aes(as.numeric(timelag)))+geom_histogram(bins=100)+ xlab(paste0("Time lag ","(",unitsSEL,")"))+ggtitle("All Individuals") +theme_bw()
    print(timeLagHistAll)
    lapply(split(data), function(x){
      dataDF <- data.frame(timelag=x$timelag, indv=namesIndiv(x)) 
      timeLagHist <- ggplot(dataDF, aes(as.numeric(timelag)))+geom_histogram(bins=100)+facet_grid(~indv)+ xlab(paste0("Time lag ","(",unitsSEL,")"))+theme_bw()
      print(timeLagHist)
    })
    dev.off() 
    
  }
  return(data)
}