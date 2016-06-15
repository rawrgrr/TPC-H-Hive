export HADOOP_USER_NAME="hadoop"
export HADOOP_HOME="/usr"

$HADOOP_HOME/bin/hadoop fs -mkdir /tpch/ 
echo "mkdir /tpch/"

tables="customer lineitem nation orders part partsupp region supplier"
if [ ! -z "$1" ]; then
	tables=$1
fi

for table in ${tables}; do
	"${HADOOP_HOME}/bin/hadoop" fs -mkdir "/tpch/${table}"
	echo "mkdir ${table}"
	"${HADOOP_HOME}/bin/hadoop" fs -rm "/tpch/${table}/${table}.tbl"
	"${HADOOP_HOME}/bin/hadoop" fs -copyFromLocal "${table}.tbl" "/tpch/${table}/"
	echo "Done loading ${table} into HDFS"
done

