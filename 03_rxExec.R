
# function to parallelize -------------------------------------------------

timeSeriesModel <- function(i)
{
    setMKLthreads(1)
    txt <- RxTextData(paste0("timeseriesfolder/sku", i, ".csv"), delimiter = ",", fileSystem = fileSystemToUse)
    x <- rxDataStep(txt)$x
    model <- arima(x, order = c(1, 0, 0))
    return(model)
}


# rxExec - local ----------------------------------------------------------

rxSetComputeContext("localpar")
fileSystemToUse <- RxNativeFileSystem()
results <- rxExec(timeSeriesModel, elemArgs = 1:1000, execObjects = c("fileSystemToUse"))


# rxExec - Spark ----------------------------------------------------------
rxSetComputeContext(mySparkCluster)
fileSystemToUse <- RxHdfsFileSystem()
results <- rxExec(timeSeriesModel, elemArgs = 1:1000, execObjects = c("fileSystemToUse"))
