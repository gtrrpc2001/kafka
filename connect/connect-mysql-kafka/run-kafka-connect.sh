/etc/confluent/docker/run &

echo "Waiting for Kafka Connect to start..."
while ! curl -s http://localhost:${CONNECT_PORT}/; do
  sleep 5
done

echo "Registering MySQL connector..."
curl -X POST -H "Content-Type: application/json" --data '{
  "name": "mysql-source",
  "config": {
    "connector.class": "io.debezium.connector.mysql.MySqlConnector",
    "tasks.max": "1",
    "database.hostname": "${HOST}",
    "database.port": "${PORT}",
    "database.user": "${MSL_USERNAME}",
    "database.password": "${MSL_PASSWORD}",
    "database.server.id": "184054",
    "database.server.name": "dbserver1",
    "database.include.list": "${DBLIST}",
    "database.history.kafka.bootstrap.servers": "${CONNECT_BOOTSTRAP_SERVERS}",
    "database.history.kafka.topic": "schema-changes.mysql",
    "database.ssl.mode": "disabled",
    "database.serverTimezone": "Asia/Seoul",
    "database.jdbc.url": "jdbc:mysql://${HOST}:${PORT}/?useSSL=false"
  }
}' http://localhost:${CONNECT_PORT}/connectors

wait

# if [ "$response" -ne 201 ]; then
#     echo "MySQL 커넥터 등록 실패: HTTP 상태 코드 $response"
#     exit 1
# else
#     echo "MySQL 커넥터 등록 성공"
# fi