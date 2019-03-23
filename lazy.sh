#!/bin/bash

# Telegraf - https://hub.docker.com/r/arm32v7/telegraf
sudo mkdir -p /opt/telegraf/etc/telegraf
chmod -R a+rwx /opt/telegraf
cp telegraf.conf /opt/telegraf/etc/telegraf/telegraf.conf

# InfluxDB
sudo mkdir -p /opt/influxdb/etc/influxdb
sudo mkdir -p /opt/influxdb/var/lib/influxdb/meta
sudo mkdir -p /opt/influxdb/var/lib/influxdb/data
chmod -R a+rwx /opt/influxdb
cp influxdb.conf /opt/influxdb/etc/influxdb.conf

# Chronograf
sudo mkdir -p /opt/chronograf/var/lib/chronograf
chmod -R a+rwx /opt/chronograf

# Kapacitor
sudo mkdir -p /opt/kapacitor/var/lib/kapacitor
cp kapacitor.conf /opt/influxdb/etc/kapacitor.conf
chmod -R a+rwx /opt/kapacitor/var/lib/kapacitor
