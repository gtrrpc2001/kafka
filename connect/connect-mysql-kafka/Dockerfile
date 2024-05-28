FROM confluentinc/cp-kafka-connect:5.5.1

RUN confluent-hub install --no-prompt debezium/debezium-connector-mysql:1.6.0

# COPY run-kafka-connect.sh /usr/local/bin/run-kafka-connect.sh
# RUN chmod +x /usr/local/bin/run-kafka-connect.sh

# CMD ["/usr/local/bin/run-kafka-connect.sh"]