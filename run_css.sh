#!/bin/bash

SERVER_DIR="/srv/srcds"
ADDONS_DIR="$SERVER_DIR/cstrike/addons"
SM_PLUGINS_DIR="$ADDONS_DIR/sourcemod/plugins"
TEMPUS_SM_PLUGINS_DIR="$SM_PLUGINS_DIR/disabled/tempus-sourcemod-plugins"
CUSTOM_DIR="$SERVER_DIR/cstrike/custom"
TEMPUS_CUSTOM_DIR="$CUSTOM_DIR/tempus"
MAPS_DIR="$TEMPUS_CUSTOM_DIR/maps"
SP_PLUGINS_DIR="$ADDONS_DIR/source-python/plugins"

cd ~/steamcmd
./steamcmd.sh +runscript update_css.txt

cd $SERVER_DIR
goh -afi -sc ./cstrike metamod sourcemod stripper accelerator

if [ ! -d $MAPS_DIR ]; then
    mkdir -p $MAPS_DIR
fi

if [ ! -d $TEMPUS_SM_PLUGINS_DIR ]; then
    mkdir $TEMPUS_SM_PLUGINS_DIR
    git clone https://bitbucket.org/jsza/tempus-sourcemod-plugins.git $TEMPUS_SM_PLUGINS_DIR
fi

cd $TEMPUS_SM_PLUGINS_DIR
git pull
ln -f plugins/tempus_keypress.smx $SM_PLUGINS_DIR

if [ ! -f "$SM_PLUGINS_DIR/updater.smx" ]; then
    wget "https://bitbucket.org/GoD_Tony/updater/downloads/updater.smx" -P "$SM_PLUGINS_DIR"
fi

# while [ ! -f "$MAPS_DIR/tempus_map_updater_run_once" ]
# do
#     echo "Map updater has not completed. Retrying in 10 seconds..."
#     sleep 10
# done

cd $SERVER_DIR
exec ./srcds_run -game cstrike $@
