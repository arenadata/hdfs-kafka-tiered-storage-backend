# Demo

The plugin demos.

Docker images built from Aiven Kafka fork (e.g. https://github.com/aiven/kafka/tree/3.3-2022-10-06-tiered-storage) is used.

## Requirements

To run the demos, you need:
- Docker Compose
- `make`
- `jq` (optional)

## Running

### HDFS as remote storage: `compose-hdfs.yml`

This scenario uses `HdfsStorage` as the remote storage.

```bash
# Start the compose
make run_hdfs

# Create the topic with any variation
make create_topic_by_time_ts
# or
# make create_topic_by_size_ts
# or with TS disabled
# make create_topic_*_no_ts

# Fill the topic
make fill_topic

# See that segments are uploaded to the remote storage
# (this may take several seconds)
make show_remote_data_hdfs

# Check that early segments are deleted
# (completely or renamed with `.deleted` suffix)
# from the local storage (this may take several seconds)
make show_local_data

# Check the data is consumable
make consume
```

You can also see the remote data in http://localhost:9870/explorer.html#/tmp/kafka/tiered-storage-demo

## Additional features

### Encryption

Generate RSA key pair:

```shell
make rsa_keys
```

and set paths on `compose.yml` file:

```yaml
  kafka:
    # ...
    volumes:
      # ...
      - ./public.pem:/kafka/plugins/public.pem
      - ./private.pem:/kafka/plugins/private.pem
    environment:
      # ...
      KAFKA_RSM_CONFIG_STORAGE_ENCRYPTION_ENABLED: true
      KAFKA_RSM_CONFIG_STORAGE_ENCRYPTION_PUBLIC_KEY_FILE: /kafka/plugins/public.pem
      KAFKA_RSM_CONFIG_STORAGE_ENCRYPTION_PRIVATE_KEY_FILE: /kafka/plugins/private.pem
      # ...
```

### Metrics

Metrics are available as JMX MBeans, and exposed using [JMX Exporter](https://github.com/prometheus/jmx_exporter) at port `7000`

```shell
curl http://localhost:7000 | grep kafka_tiered
```
