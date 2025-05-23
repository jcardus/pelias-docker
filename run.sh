#!/bin/bash
set -x

# cd into the project directory
cd projects/brazil

# create a directory to store Pelias data files
# see: https://github.com/pelias/docker#variable-data_dir
# note: use 'gsed' instead of 'sed' on a Mac
mkdir ./data
sed -i '/DATA_DIR/d' .env
echo 'DATA_DIR=./data' >> .env

# run build
pelias compose pull
pelias elastic start
pelias elastic wait
pelias elastic create
pelias download osm
pelias download wof
pelias download oa

mkdir -p ./data/polylines
cd data/polylines
wget https://data.geocode.earth/osm/2022-35/brazil-valhalla.polylines.0sv.gz
gunzip brazil-valhalla.polylines.0sv.gz
cd ../..

pelias import polylines
pelias import osm
pelias import wof
pelias compose up