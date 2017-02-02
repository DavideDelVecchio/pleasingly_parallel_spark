
# foreach - local ---------------------------------------------------------

library(foreach)
library(doParallel)
library(doRSR)

# Setting number of cores to 4 since this was run on a 4-core machine

cl <- makeCluster(4)
registerDoParallel(cl)

nTasks=1000

results <- foreach(i = 1:nTasks) %dopar% {
    setMKLthreads(1)
    txt <- RxTextData(paste0("timeseriesfolder/sku", i, ".csv"), delimiter = ",", fileSystem = RxNativeFileSystem())
    x <- rxDataStep(txt)$x
    model <- arima(x, order = c(1, 0, 0))
    return(model)
}

stopCluster(cl)

# foreach - Spark ---------------------------------------------------------

registerDoRSR(mySparkCluster)

nTasks <- 1000
myChunkSize <- ceiling(nTasks / (mySparkCluster@executorCores*mySparkCluster@numExecutors))
results <- foreach(i = 1:nTasks, .options.rsr=list(chunkSize=myChunkSize)) %dopar% {
    setMKLthreads(1)
    txt <- RxTextData(paste0("timeseriesfolder/sku", i, ".csv"), delimiter = ",", fileSystem = RxHdfsFileSystem())
    x <- rxDataStep(txt)$x
    model <- arima(x, order = c(1, 0, 0))
    return(model)
}

