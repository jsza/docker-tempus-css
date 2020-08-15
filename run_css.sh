#!/bin/bash

SERVER_DIR="/srv/srcds"
ADDONS_DIR="$SERVER_DIR/cstrike/addons"
SM_PLUGINS_DIR="$ADDONS_DIR/sourcemod/plugins"
TEMPUS_SM_PLUGINS_DIR="$SM_PLUGINS_DIR/disabled/tempus-sourcemod-plugins"
CUSTOM_DIR="$SERVER_DIR/cstrike/custom"
TEMPUS_CUSTOM_DIR="$CUSTOM_DIR/tempus"
MAPS_DIR="$TEMPUS_CUSTOM_DIR/maps"
SP_PLUGINS_DIR="$ADDONS_DIR/source-python/plugins"
AUSSURF_BLOCKER_MODEL_DIR="$CUSTOM_DIR/blocker"

cd ~/steamcmd
./steamcmd.sh +runscript update_css.txt

cd $SERVER_DIR
/venv/bin/goh -afi -sc ./cstrike metamod sourcemod stripper accelerator dhooks

cs $SM_PLUGINS_DIR
rm -f basetriggers.smx nextmap.smx

if [ ! -d $MAPS_DIR ]; then
    mkdir -p $MAPS_DIR
fi

if [ ! -d $TEMPUS_SM_PLUGINS_DIR ]; then
    mkdir $TEMPUS_SM_PLUGINS_DIR
    git clone https://bitbucket.org/jsza/tempus-sourcemod-plugins.git $TEMPUS_SM_PLUGINS_DIR
fi

if [ ! -d $AUSSURF_BLOCKER_MODEL_DIR ]; then
    mkdir $AUSSURF_BLOCKER_MODEL_DIR
    git clone https://github.com/jsza/aussurf-blocker-model.git $AUSSURF_BLOCKER_MODEL_DIR
fi

cd $TEMPUS_SM_PLUGINS_DIR
git pull
ln -f plugins/tempus_keypress.smx $SM_PLUGINS_DIR
ln -sf $TEMPUS_SM_PLUGINS_DIR/plugins/css_surf_plugins $SM_PLUGINS_DIR/surf

while [ ! -f "$MAPS_DIR/tempus_map_updater_run_once" ]
do
    echo "Map updater has not completed. Retrying in 10 seconds..."
    sleep 10
done

cd $SERVER_DIR
exec ./srcds_run -game cstrike $@
