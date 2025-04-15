-----------------------------------------------------------------------------
-- oepnv_buildings
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max 
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


local themepark, theme, cfg = ...

themepark:add_table{
    name = 'oepnv_buildings',
    geom = 'geometry', 
    ids_type = 'any',
    columns = themepark:columns({
        { column = 'housenumber', type = 'text'},
        { column = 'name', type = 'text'},


    }),
    tiles = {
        minzoom = 8,
    },
}

-- ---------------------------------------------------------------------------

themepark:add_proc('way', function(object)
    if object.tags.building then
        themepark:insert('oepnv_buildings', {

            name = object.tags['addr:housename'],
            geom = object:as_linestring(),
            housenumber = object.tags['addr:housenumber']

        })
    end
end)

themepark:add_proc('relation', function(object)
    if object.tags.building then
        themepark:insert('oepnv_buildings', {

            name = object.tags['addr:housename'],
            geom = object:as_multipolygon(),
            housenumber = object.tags['addr:housenumber']

        })
    end
end)
