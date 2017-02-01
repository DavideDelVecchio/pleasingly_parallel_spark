### PARAMETERS - PLEASE CHANGE -
myNameNode <- "<dns_name_of_head_node>" # change the namenode address
coreUtilization <- 0.50 # We utilize 50% of the cluster cores - you can change this

# This function finds the number of nodes and cores in the cluster
rxGetClusterDetails <- function()
{
  xx <- system2("yarn", c("node -list -showDetails"), stderr=FALSE, stdout = TRUE)
  xx <- xx[grep("vCores",xx)]
  xx <- do.call("rbind",strsplit(xx,"vCores:"))[,2]
  xx <- as.integer(gsub(">","",xx))
  clusterDetails <- xx[seq(1, length(xx), by=2)]
  nNodes <- length(clusterDetails)
  clusterCores <- sum((clusterDetails+1)/2)
  return(list(nNodes=nNodes, totalClusterCores=clusterCores, coresByNode=(clusterDetails+1)/2))
}

clusterDetails <- rxGetClusterDetails()
numberOfWorkerNodes <- clusterDetails$nNodes # number of worker nodes in cluster
numberOfClusterCores <- floor(clusterDetails$totalClusterCores * coreUtilization) # total number of (physical) cores on data nodes you wish to use
mySparkCluster <- RxSpark(nameNode = myNameNode,
                          consoleOutput = TRUE,
                          numExecutors = numberOfWorkerNodes,
                          executorCores = floor(numberOfClusterCores/numberOfWorkerNodes),
                          executorMem = '1000m',
                          executorOverheadMem = '1000m')