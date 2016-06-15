#!/usr/bin/env bash

export LOG_DIR=logs
export HADOOP_USER_NAME=hadoop
export HADOOP_HOME=/usr
export HIVE_HOME=/srv/hive-latest

execution_style='serial'
if [ 'parallel' == "$1" ]; then
	execution_style='parallel'
fi


function time_query {
	local query=$1
	local result_query="Query:${query}"
	local result_hive_logs="$(${TIME_CMD} ${HIVE_CMD} -f ${BASE_DIR}/${query} 2>&1 | tee -a ${LOG_FILE})"
	local result_cpu_time="$(echo "${result_hive_logs}" | grep '^Total MapReduce CPU Time Spent:')"
	local result_wall_time="$(echo "${result_hive_logs}" | grep '^Time:')"
	local returncode=${PIPESTATUS[0]}
	local result="${result_query},${result_cpu_time}"
	local result_status=""
	if [ ${returncode} -ne 0 ]; then
		result_status="FAILED:${returncode}"
	else
		result_status="SUCCESS"
	fi
	result+=",${result_status},${result_wall_time}"
	echo -e "${result}"
}

# set up configurations
source benchmark.conf;

if [ -e "${LOG_FILE}" ]; then
	timestamp=`date "+%F-%R" --reference=${LOG_FILE}`
	backupFile="${LOG_FILE}.$timestamp"
	mv ${LOG_FILE} ${LOG_DIR}/${backupFile}
fi

if [ ! -z "$2" ]; then
	NUM_OF_TRIALS=$2
fi

echo ""
echo "***********************************************"
echo "*           PC-H benchmark on Hive            *"
echo "***********************************************"
echo "                                               " 
echo "Running Hive from ${HIVE_HOME}" | tee -a ${LOG_FILE}
echo "Running Hadoop from ${HADOOP_HOME}" | tee -a ${LOG_FILE}
echo "See ${LOG_FILE} for more details of query errors."
echo ""

trial=0
while [ ${trial} -lt ${NUM_OF_TRIALS} ]; do
	trial=`expr ${trial} + 1`
	echo "Executing Trial #${trial} of ${NUM_OF_TRIALS} trial(s)..."

	for query in ${HIVE_TPCH_QUERIES_ALL[@]}; do
		if [ "${execution_style}" == 'parallel' ]; then
			time_query "${query}" &
		else
			time_query "${query}"
		fi
	done

	wait # for all queries to be done before starting next trial
done # TRIAL
echo "***********************************************"
echo ""
