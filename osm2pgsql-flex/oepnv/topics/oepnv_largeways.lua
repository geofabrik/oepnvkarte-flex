-----------------------------------------------------------------------------
-- Oepnv_largeways
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

local themepark, theme, cfg = ...

themepark:add_table({
    name = "oepnv_largeways",
    geom = "geometry",
    ids_type = "any",
    columns = themepark:columns({
        { column = "type", type = "text", not_null = true },
    }),
    tiles = {
        minzoom = 8,
    },
})

themepark:add_proc("way", function(object)
    if is_in(object.tags["highway"], { "motorway", "trunk", "primary", "secondary", "tertiary" }) then
        themepark:insert("oepnv_largeways", {
            geom = object:as_linestring(),
            type = object.tags["highway"],
        })
    end
end)

themepark:add_proc("relation", function(object)
    if is_in(object.tags["highway"], { "motorway", "trunk", "primary", "secondary", "tertiary" }) then
        themepark:insert("oepnv_largeways", {
            geom = object:as_multipolygon(),
            type = object.tags["highway"],
        })
    end
end)
