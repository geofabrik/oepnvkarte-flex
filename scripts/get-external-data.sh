#! /bin/bash

cd "$(dirname "$0")/../data/" || exit 1


if [ ! -s land-polygons-split-3857.zip ] ; then
	wget https://osmdata.openstreetmap.de/download/land-polygons-split-3857.zip
fi
unzip -q -u -o land-polygons-split-3857.zip

if [ ! -s natural_earth_vector.zip ] ; then
	wget https://naciscdn.org/naturalearth/packages/natural_earth_vector.zip
fi
unzip -q -u -o natural_earth_vector.zip

