#!/bin/bash

echo "== Health Check ==" 
cd ~/dev/kottiodev_elt

# Container Dockers + status
echo "== Docker Containers Running =="
# docker ps --filter "name=postgres" --format "{{.Names}} - {{.Status}}"

postgres_status=$(docker ps --filter "name=metabase" --format "{{.Status}}")
if [[ "$postgres_status" == *"Up"* ]]; then 
  echo "✅ Postgres: $postgres_status"
else 
  echo "❌ Postgres container Not Working: $postgres_status"
  docker restart Postgres
  echo "⚠️ Relaunch Health Check "
fi

metabase_status=$(docker ps --filter "name=metabase" --format "{{.Status}}")
if [[ "$metabase_status" == *"Up"* ]]; then 
  echo "✅ Metabase: $metabase_status"
else 
  echo "❌ Metabase container Not Working: $metabase_status"
  docker restart metabase
  echo "⚠️ Relaunch Health Check "
fi

# MOVIEDB API
echo "== Testing MovieDB API Credentials ==="
source ./venv/bin/activate
python_output=$(python movieDB_pipeline/API_test.py 2>&1)
if [ $? -eq 0 ]; then 
  echo "✅ $python_output"
else
  echo "❌ $python_output" 
fi

# Postgres Connexion : analytics_db
echo "== Testing Postgres Database =="
if docker exec postgres psql -U admin -d analytics_db -t -c "SELECT 1;" > /dev/null; then
  echo "✅ Database Connexion Working"

  movies_dashboard=$(docker exec postgres psql -U admin -d analytics_db -t -c "SELECT COUNT(DISTINCT id) FROM movies_dashboard;")
  if [ $movies_dashboard -gt 0 ]; then
    echo "✅ $movies_dashboard In our Dashboard"
  else 
    echo "❌ 0 Movies in our dashboard"
  fi

else 
  echo "❌ Database Connexion Error"
fi

# Metabase Running ports 
echo "=== Metabase ==="
docker ps --filter "name=metabase" --format {{.Ports}}

