# Generate n number of time series data files in a directory

n <- 1000
dirPath <- "timeseriesfolder/"

for(i in 1 : 1000)
{
    x <- arima.sim(model = list(ar=.8), n = 1000)
    write.csv(data.frame(x),paste0(dirPath,"sku",i,".csv"))
}

# copy to / in HDFS - you may want to change this location according to your cluster settings
rxHadoopCopyFromLocal(dirPath, dirPath)