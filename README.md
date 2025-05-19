# OEPNV style

## requirements

run `./scripts/get-external-data.sh`

## Data import

Need osm2pgsql version 1.9.0 or later.

```bash
cd osm2pgsql-flex
osm2pgsql -O flex -S ./config/oepnv.lua FILENAME.osm.pbf
```

## compile style:

```
apt-get install nodejs nodejs-legacy npm unifont
npm install -g lodash
npm install -g carto

carto project.mml > style.xml
```
