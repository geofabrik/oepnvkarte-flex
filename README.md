# OEPNV / ÖPNV style

A version of the [ÖPNVKarte](https://www.öpnvkarte.de/) (aka public transport map) originally created by Melchior Moos, of [MeMoMaps](https://memomaps.de/). This version uses [osm2pgsql](https://osm2pgsql.org/)'s flex backend. It is currently hosted by [Geofabrik](https://geofabrik.de), under the [Geofabrik Public Transport Map](https://tools.geofabrik.de/map/#Public%20Transport/4/49.239121/3.251953).

## Requirements

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

## Metions / See also

* [“Public Transport Map” on Geofabrik Blog](https://blog.geofabrik.de/index.php/2025/03/21/public-transport-map/) _(March 2025)_
* [OpenStreetMap Wiki article on ÖPNVKarte](https://wiki.openstreetmap.org/wiki/%C3%96PNVKarte)

## Copyright

This project is released under the [CC-0](https://creativecommons.org/publicdomain/zero/1.0/) licence. (See [`./LICENCE`](./LICENCE)).

Maps produced with OpenStreetMap data, which is open data, © OpenStreetMap Contributors, under the [ODbL 1.0](https://www.openstreetmap.org/copyright) licence. See also the [Attribution Guidelines from the OpenStreetMap Foundation](https://osmfoundation.org/wiki/Licence/Attribution_Guidelines).
