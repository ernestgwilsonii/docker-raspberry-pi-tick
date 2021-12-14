#############################################################
# TICK Stack - Telegraf, InfluxDB, Chronograf, and Kapacitor #
#              (in Docker Containers) for Raspberry Pi      #
#      REF: https://www.influxdata.com/time-series-platform/ #
#      REF: https://www.influxdata.com/time-series-platform/telegraf/ #
#############################################################


###############################################################################
# Prerequisites
###############
ssh pi@YourPiIPAddressHere
sudo -u root bash
apt-get update && apt-get dist-upgrade -y
curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh
pip install --upgrade docker-compose
docker swarm init
###############################################################################


###############################################################################
# Quick (if using Docker Swarm and bind mounted data in /opt)
sudo -u root bash
mkdir -p /opt/docker-compose
cd /opt/docker-compose
git clone https://github.com/ernestgwilsonii/docker-raspberry-pi-tick.git
cd docker-raspberry-pi-tick
./lazy.sh
docker stack deploy -c docker-compose.yml tick-stack
docker stack ls
docker service ls
docker ps
# http://YourPiIPAddressHere:8888
#docker stack rm tick-stack
#rm -Rf /opt/chronograf /opt/influxdb /opt/kapacitor /opt/telegraf
#docker system prune -af
###############################################################################


###############################################################################
# Docker Images
sudo bash
time docker pull arm32v7/telegraf:1.10.0   # REF: https://hub.docker.com/r/arm32v7/telegraf
time docker pull arm32v7/influxdb:1.7.4     # REF: https://hub.docker.com/r/arm32v7/influxdb
time docker pull arm32v7/chronograf:1.7.8  # REF: https://hub.docker.com/r/arm32v7/chronograf
time docker pull arm32v7/kapacitor:1.5.2   # REF: https://hub.docker.com/r/arm32v7/kapacitor
docker images

# Generate new config files (optional)
#docker run --rm -p 8092:8092/udp -p 8094:8094/tcp -p 8125:8125/tcp arm32v7/telegraf:1.10.0 telegraf config > telegraf.conf
#docker run --rm -v /opt/influxdb/etc/influxdb:/etc/influxdb -v /opt/influxdb/var/lib/influxdb:/var/lib/influxdb -p 2003:2003/tcp -p 8094:8094/tcp -p 8125:8125/tcp arm32v7/influxdb:1.7.4 influxd config > influxdb.conf
#docker run --rm -v /opt/kapacitor/var/lib/kapacitor:/var/lib/kapacitor -p 9092:9092 arm32v7/kapacitor:1.5.2 kapacitord config > kapacitor.conf

# Verify (no persistence, start each container manually for testing and then shutdown and remove)
docker network create influxdb
docker run -d --name influxdb --net=influxdb -p 8086:8086/tcp -p 2003:2003/tcp -e INFLUXDB_GRAPHITE_ENABLED=true arm32v7/influxdb:1.7.4 influxd
docker run -d --name telegraf --net=influxdb -e HOST_ETC=/host/etc -e HOST_PROC=/host/proc -e HOST_SYS=/host/sys -p 8092:8092/udp -p 8094:8094/tcp -p 8125:8125/tcp -v /etc:/host/etc:ro -v /proc:/host/proc:ro -v /sys:/host/sys:ro -v /var/run/docker.sock:/var/run/docker.sock -e HOST_PROC=/host/proc -e INFLUX_URL="http://$(hostname -I | awk '{print $1}'):8086" arm32v7/telegraf:1.10.0 telegraf
docker run -d --name chronograf --net=influxdb -p 8888:8888 -e influxdb-url=http://influxdb:8086 arm32v7/chronograf:1.7.8 chronograf
docker run -d --name kapacitor --net=influxdb -p 9092:9092 -e KAPACITOR_INFLUXDB_0_URLS_0=http://influxdb:8086 arm32v7/kapacitor:1.5.2 kapacitord
docker ps
# REF: https://docs.influxdata.com/influxdb/v1.7/tools/api/
# Test stuff!
docker stop telegraf chronograf kapacitor influxdb
docker rm telegraf chronograf kapacitor influxdb
docker network rm influxdb
###############################################################################


###############################################################################
# First time setup #
####################
# Create bind mounted directories

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
###############################################################################


###############################################################################
# Deploy #
##########
# Deploy the stack into a Docker Swarm
docker stack deploy -c docker-compose.yml tick-stack
#docker stack rm tick-stack

# Verify
sudo -u root bash
docker stack ls
docker service ls | grep tick-stack
docker service logs -f tick-stack_telegraf
docker service logs -f tick-stack_influxdb
docker service logs -f tick-stack_chronograf
docker service logs -f tick-stack_kapacitor
docker ps
###############################################################################
