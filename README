Reynold Xin
rxin@cs.berkeley.edu

## Tools and scripts for running TPC-H benchmark on Apache Hive.

Mainly consists of two packages:

1. TPC-H DBGEN (http://www.tpc.org/tpch/)

2. TPC-H for Hive by Yuntao Jia (https://issues.apache.org/jira/browse/hive-600)

## Instructions

```
# Generate data (in this case using scale factor of 100)
TPC-H-Hive/dbgen $ dbgen -s 100 -f

# Load data
TPC-H-Hive $ mv -v dbgen/*.tbl TPC-H_on_Hive/data/.
TPC-H-Hive/TPC-H_on_Hive/data $ ./tpch_prepare_data.sh

# Run the benchmark
TPC-H-Hive/TPC-H_on_Hive $ nohup ./run_tpch_benchmark.sh parallel 30 control_case &

# Generate csv files
TPC-H-Hive/TPC-H_on_Hive $ ./process_logs tpch_100_parallel_control_case_log_123.log
```
