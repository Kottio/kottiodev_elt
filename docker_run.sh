docker run -d \
  --name postgres  \
  --network data_network \
  -p 5432:5432 \
  -e POSTGRES_USER=admin \
  -e POSTGRES_PASSWORD=kottioELT \
  -e POSTGRES_DB=metabase_db \
  -v postgres_data:/var/lib/postgresql/data \
  postgres:16

docker run -d \
  --name metabase \
  --network data_network \
  -e MB_DB_TYPE=postgres \
  -e MB_DB_HOST=postgres\
  -e MB_DB_PORT=5432 \
  -e MB_DB_USER=admin \
  -e MB_DB_PASS=kottioELT \
  -e MB_DB_DBNAME=metabase_db \
  -p 3000:3000 \
  metabase/metabase  

