# OEPNV style

## requirements

run `./scripts/get-external-data.sh`

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
