
DATABASE_HOSTNAME="$HOST"
DATABASE_PORT="$PORT"
DATABASE_USER="$USER"
DATABASE_PASSWORD="$PASSWORD" 
DATABASE_SERVER_ID="$SERVER_ID"
DATABASE_SERVER_NAME="$SERVER_NAME"
DATABASE_INCLUDE_LIST="$DATABASE_LIST"
KAFKA_BOOTSTRAP_SERVERS="$K_SERVERS"
KAFKA_TOPIC="$K_TOPIC"
DATABASE_SSL_MODE="disabled"
DATABASE_SERVER_TIMEZONE="Asia/Seoul"

/etc/confluent/docker/run &

echo "Waiting for Kafka Connect to start..."
while ! curl -s http://localhost:8083/; do
  sleep 5
done

echo "Registering MySQL connector..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: application/json" --data '{
  "name": "mysql-source",
  "config": {
    "connector.class": "io.debezium.connector.mysql.MySqlConnector",
    "tasks.max": "1",
    "database.hostname": "'"$DATABASE_HOSTNAME"'",
    "database.port": "'"$DATABASE_PORT"'",
    "database.user": "'"$DATABASE_USER"'",
    "database.password": "'"$DATABASE_PASSWORD"'",
    "database.server.id": "'"$DATABASE_SERVER_ID"'",
    "database.server.name": "'"$DATABASE_SERVER_NAME"'",
    "database.include.list": "'"$DATABASE_INCLUDE_LIST"'",
    "database.history.kafka.bootstrap.servers": "'"$KAFKA_BOOTSTRAP_SERVERS"'",
    "database.history.kafka.topic": "'"$KAFKA_TOPIC"'",
    "database.ssl.mode": "'"$DATABASE_SSL_MODE"'",
    "database.serverTimezone": "'"$DATABASE_SERVER_TIMEZONE"'"
  }
}' http://localhost:8083/connectors)

if [ "$RESPONSE" -ne 201 ]; then
  echo "Failed to register MySQL connector. HTTP response code: $RESPONSE"
  exit 1
else
  echo "MySQL connector registered successfully."
fi

wait