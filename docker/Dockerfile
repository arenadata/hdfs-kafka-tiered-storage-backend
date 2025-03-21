##
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##

# Base image based 3.8.0 + minor changes unrelated to TS included on this branch:
# https://github.com/apache/kafka/compare/3.8...aiven:kafka:3.8.0-2024-07-30
# See commits and Dockerfile for more details on base image
FROM docker.io/aivenoy/kafka:3.8.1-2024-11-21

ARG _VERSION

USER root

RUN mkdir -p /tiered-storage-for-apache-kafka/
COPY build/libs/hdfs-kafka-tiered-storage-backend-${_VERSION}-all.jar /tiered-storage-for-apache-kafka/

# Installing JMX exporter agent
ARG JMX_EXPORTER_VERSION=0.18.0
RUN mkdir -p /opt/prometheus/jmx-exporter
RUN wget https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${JMX_EXPORTER_VERSION}/jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar \
    -O /opt/prometheus/jmx-exporter/jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar
COPY docker/kafka-jmx-exporter.yml /opt/prometheus/jmx-exporter/.
ENV KAFKA_OPTS="-javaagent:/opt/prometheus/jmx-exporter/jmx_prometheus_javaagent-${JMX_EXPORTER_VERSION}.jar=7000:/opt/prometheus/jmx-exporter/kafka-jmx-exporter.yml"

# Restore the user.
USER appuser

RUN mkdir /home/appuser/kafka-tiered-storage-cache
