#!/usr/bin/env bash

# ./tpch_benchmark.sh 'serial'|'parallel' num_trials description
./tpch_benchmark.sh "$1" "$2" | tee "tpch_100_$1_$3_log_$(date +%FT%TZ.log)"
