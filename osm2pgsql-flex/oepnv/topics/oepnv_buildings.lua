-----------------------------------------------------------------------------
-- oepnv_buildings
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

local themepark, theme, cfg = ...

themepark:add_table({
    name = "oepnv_buildings",
    geom = "multipolygon",
    ids_type = "any",
    columns = themepark:columns({
        { column = "housenumber", type = "text" },
        { column = "name", type = "text" },
    }),
    tiles = {
        minzoom = 8,
    },
})

-- ---------------------------------------------------------------------------

themepark:add_proc("area", function(object)
    if object.tags["building"] then
        themepark:insert("oepnv_buildings", {
            name = object.tags["addr:housename"],
            housenumber = object.tags["addr:housenumber"],
            geom = object:as_multipolygon(),
        })
    end
end)
