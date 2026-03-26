#!/bin/bash

echo "=== Start Pipeline ==="
echo "$(date)"

ERROR_LOG=./orchestration/logs/error.log

cd /Users/kottio/dev/kottiodev_elt

echo "== Python ETL =="
source ./venv/bin/activate


python_output=$(python ./movieDB_pipeline/main_pipeline.py 2>&1)
python_status_code=$?

if [ $python_status_code -eq 0 ]; then 
  echo "ETL Success"
  echo "==="
  echo "$python_output"
  echo "==="

  echo "=== Refreshing dashboard View ==="
  docker_psql_output=$(docker exec postgres psql -U admin -d analytics_db -c "REFRESH MATERIALIZED VIEW movies_dashboard;" 2>&1)
  docker_psql_status_code=$?

  if [ $docker_psql_status_code -eq 0 ]; then 
    echo "✅ Dashboard Refresh Successful"
    echo "==="
    echo "$docker_psql_output"
    echo "==="

    psql_output=$(docker exec postgres psql -U admin -d analytics_db -t -c "SELECT COUNT(DISTINCT id) FROM movies_dashboard;")
    echo "$psql_output Movies in the dashboard"

  else 
    echo "❌ Dashboard Refresh Failed"
    echo "$docker_psql_ouput"
    echo "=====================" >> $ERROR_LOG
    echo "$(date) == Failed Pipeline : VIEW Refresh" >> $ERROR_LOG
    echo "$docker_psql_ouput" >> $ERROR_LOG
    exit 1
  fi

else
  echo "❌ ETL Failed"
  echo "=====================" >> $ERROR_LOG
  echo "$(date) == Failed Pipeline : Python ETL" >> $ERROR_LOG
  echo "$python_output" | grep "Error" >> $ERROR_LOG
  exit 1
fi 

echo "=== Pipeline Completed Successfully ===="
