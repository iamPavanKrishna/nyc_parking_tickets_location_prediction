#! /bin/bash
sleep 15
/app/kafka/bin/kafka-topics.sh --create --bootstrap-server broker:9092 --replication-factor 1 --partitions 1 --topic nycparkingtickets
/app/kafka/bin/kafka-topics.sh --list --bootstrap-server broker:9092