#!/usr/bin/env bash

FILE=$1
NEW_FILE=~/"$(echo "$(basename ${FILE})" | perl -pe 's/log/timing/;s/log/csv/;')"

echo "trial,query,cpu_time,wall_time" > "${NEW_FILE}"

grep -e 'Executing' -e 'Query:' -e 'Total MapReduce CPU Time Spent:' "${FILE}" \
	| awk '{if ($0 ~ /^Executing/) {trial=$3; total=$5;} else if ($0 ~ /^Query/) {result=trial","$0;} else if ($0 ~ /^Total/) {result=result$0}; if ($0 ~ /SUCCESS/) {print result};}' \
	| perl -pe 's/Total MapReduce CPU Time Spent://g;s/ [0-9]+ / +$&/g;s/\+/0s+/;s/hive,/hive=/;s/,SUCCESS/=SUCCESS/;s/Query://;s/=/,/g;s/Time://;' \
	| while IFS="," read run query cpu_time success wall_time _; do echo "${run},${query},$(units -t "${cpu_time}" sec),${wall_time}"; done >> "${NEW_FILE}"
