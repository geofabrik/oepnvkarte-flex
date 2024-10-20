# OEPNV style

## requirements

### planet land polygons

under /opt/mapnik
```
wget --trust-server-names https://osmdata.openstreetmap.de/download/land-polygons-split-3857.zip
unzip land-polygons-split-3857.zip
```

### natural earth

under /opt/mapnik
```
wget https://naciscdn.org/naturalearth/packages/natural_earth_vector.zip
unzip natural_earth_vector.zip
```

### osm2db database

```
wget https://planet.openstreetmap.org/pbf/planet-latest.osm.pbf
osm2db -c -H localhost -U update -W UpdatePw -d gis planet-latest.osm.pbf
```

## compile style:
Adjust database settings in project.mml to your needs
```
apt-get install nodejs nodejs-legacy npm unifont
npm install -g lodash
npm install -g carto

carto project.mml > style.xml
```
