#!/bin/bash

# Telegraf - https://hub.docker.com/r/arm32v7/telegraf
sudo mkdir -p /opt/docker/telegraf/etc/telegraf
cp -n telegraf.conf /opt/docker/telegraf/etc/telegraf/telegraf.conf
chmod -R a+rw /opt/docker/telegraf

# InfluxDB
sudo mkdir -p /opt/docker/influxdb/etc/influxdb
cp -n influxdb.conf /opt/docker/influxdb/etc/influxdb/influxdb.conf
sudo mkdir -p /opt/docker/influxdb/var/lib/influxdb/meta
sudo mkdir -p /opt/docker/influxdb/var/lib/influxdb/data
chmod -R a+rw /opt/docker/influxdb

# Chronograf
sudo mkdir -p /opt/docker/chronograf/var/lib/chronograf
chmod -R a+rw /opt/docker/chronograf

# Kapacitor
sudo mkdir -p /opt/docker/kapacitor/etc/kapacitor
cp -n kapacitor.conf /opt/docker/kapacitor/etc/kapacitor/kapacitor.conf
sudo mkdir -p /opt/docker/kapacitor/var/lib/kapacitor
chmod -R a+rw /opt/docker/kapacitor
