#!/bin/bash

# Telegraf - https://hub.docker.com/r/arm32v7/telegraf
sudo mkdir -p /opt/telegraf/etc/telegraf
cp -n telegraf.conf /opt/telegraf/etc/telegraf/telegraf.conf
chmod -R a+rw /opt/telegraf

# InfluxDB
sudo mkdir -p /opt/influxdb/etc/influxdb
cp -n influxdb.conf /opt/influxdb/etc/influxdb/influxdb.conf
sudo mkdir -p /opt/influxdb/var/lib/influxdb/meta
sudo mkdir -p /opt/influxdb/var/lib/influxdb/data
chmod -R a+rw /opt/influxdb

# Chronograf
sudo mkdir -p /opt/chronograf/var/lib/chronograf
chmod -R a+rw /opt/chronograf

# Kapacitor
sudo mkdir -p /opt/kapacitor/etc/kapacitor
cp -n kapacitor.conf /opt/kapacitor/etc/kapacitor/kapacitor.conf
sudo mkdir -p /opt/kapacitor/var/lib/kapacitor
chmod -R a+rw /opt/kapacitor
