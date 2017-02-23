# function to parallelize -------------------------------------------------

timeSeriesModel <- function(i) {
    setMKLthreads(1)
    txt <- RxTextData(paste0(filePath, "sku", i, ".csv"), delimiter = ",", fileSystem = fileSystemToUse)
    x <- rxDataStep(txt)$x
    model <- arima(x, order = c(1, 0, 0))
    return(model)
}


# rxExec - local ----------------------------------------------------------

rxSetComputeContext("localpar")
fileSystemToUse <- RxNativeFileSystem()
filePath <- "timeseriesfolder/"
results <- rxExec(timeSeriesModel, elemArgs = 1:1000, execObjects = c("fileSystemToUse", "filePath"))


# rxExec - Spark ----------------------------------------------------------
rxSetComputeContext(mySparkCluster)
fileSystemToUse <- RxHdfsFileSystem(hostName = myNameNode)
filePath <- "/timeseriesfolder/"
myChunkSize <- ceiling(nTasks / (mySparkCluster@executorCores * mySparkCluster@numExecutors))
results <- rxExec(timeSeriesModel, elemArgs = 1:1000, execObjects = c("fileSystemToUse", "filePath"),
                  taskChunkSize = myChunkSize)

