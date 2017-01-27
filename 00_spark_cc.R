myNameNode <- "<dns_name_of_head_node>"
numberOfWorkerNodes <- 10 # number of worker nodes in cluster
numberOfClusterCores <- 160 # total number of (physical) cores on data nodes you wish to use
mySparkCluster <- RxSpark(nameNode = myNameNode,
                          consoleOutput = TRUE,
                          numExecutors = numberOfWorkerNodes,
                          executorCores = floor(numberOfClusterCores/numberOfWorkerNodes),
                          executorMem = '1000m',
                          executorOverheadMem = '1000m')