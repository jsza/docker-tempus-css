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

if [ ! -d $AUSSURF_SM_PLUGINS_REPO_DIR ]; then
    mkdir $AUSSURF_SM_PLUGINS_REPO_DIR
    git clone https://github.com/jsza/aussurf-sourcemod-plugins.git $AUSSURF_SM_PLUGINS_REPO_DIR
fi

cd $AUSSURF_SM_PLUGINS_REPO_DIR
git pull
ln --symbolic --force --no-target-directory "$AUSSURF_SM_PLUGINS_REPO_DIR/plugins/" $TEMPUS_SM_PLUGINS_DIR

for filename in plugins/*.smx; do
    rm -f "$SM_PLUGINS_DIR/$(basename $filename)"
done

if [ -d $AUSSURF_SM_PLUGINS_REPO_DIR/gamedata ]; then
    ln --symbolic --force $AUSSURF_SM_PLUGINS_REPO_DIR/gamedata/* "$ADDONS_DIR/sourcemod/gamedata"
fi

if [ ! -d $AUSSURF_BLOCKER_MODEL_DIR ]; then
    mkdir $AUSSURF_BLOCKER_MODEL_DIR
    git clone https://github.com/jsza/aussurf-blocker-model.git $AUSSURF_BLOCKER_MODEL_DIR
fi

while [ ! -f "$MAPS_DIR/tempus_map_updater_run_once" ]
do
    echo "Map updater has not completed. Retrying in 10 seconds..."
    sleep 10
done

cd $SERVER_DIR
exec ./srcds_run -game cstrike $@
