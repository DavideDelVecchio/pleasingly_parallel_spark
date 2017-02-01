# Pleasingly parallel jobs in Microsoft R Server on Spark
This is a simple R project that highlights the best practices for running pleasingly parallel jobs in 
Microsoft R Server. A short description of the R files is given below:

- 00_spark_cc.R - this defines the Spark compute context. It also automatically detects the number of nodes and cores in the cluster using a custom function called rxClusterDetails. You will need to change the following variables: 
    - `myNameNode` - the name (or IP address) of the head node in the cluster
    - `coreUtilization` - the percentage of cluster cores you want to use for your pleasingly parallel job. In the script this is set to 50% i.e. if the cluster has 160 cores across all the worker nodes, our job will utilize 80 cores.

- 01_data_generator.R - this generates 1000 time series files ARIMA(1,0,0). You can set this this be a higher number. This file also demonstrates how to upload files to HDFS using `rxHadoopCopyFromLocal` function.

- 02_foreach.R - how to run the job using `foreach %dopar%` in both local and spark compute contexts

- 03_rxExec.R - how to run the job using the `rxExec` function in Microsoft R Server

Run the commands in the file order given above i.e. 00_spark_cc.R > 01_data_generator.R > 02_foreach.R > 03_rxExec.R.

The R files contain all the best practices for running pleasingly parallel workloads in R Server. However, we summarize this below:

1. Always read objects from HDFS when you are on Spark. Do not pass large objects around the cluster

2. Set Intel Math Kernel Library threads to 1 to prevent contention

3. Optimize the Spark compute context

    a. `executorMem` and `executorOverheadMem` – setting this lower than the default RxSpark CC (4gb), gives much more parallelism because you don’t need so much resource for each executor

    b. `numExecutors` – this should be set to the number of nodes in the cluster

    c. `executorCores` – this should be set to the number of usable cores in the entire cluster *divided* by the number of nodes. By ‘usable cores’ we mean numberOfClusterCores-numberOfNodes i.e. we give 1 core per node for other Hadoop processes