-----------------------------------------------------------------------------
-- Oepnv_places
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

local themepark, theme, cfg = ...

themepark:add_table({
    name = "oepnv_places",
    geom = "point",
    ids_type = "any",
    columns = themepark:columns({
        { column = "name", type = "text" },
        { column = "population", type = "integer", not_null=false },
        { column = "type", type = "text", not_null=true },
    }),
    tiles = {
        minzoom = 8,
    },
})

-----------------------------------------------------------------------------

themepark:add_proc("node", function(object)
    if is_in(object.tags["place"], {
        "hamlet",
        "village",
        "city",
        "town",
        "region",
        "suburb",
        "state",
        "country",
        "continent",
        "locality",
    }) then
        themepark:insert("oepnv_places", {

            name = object.tags["name"],
            geom = object:as_point(),
            population = tonumber(object.tags["population"]),
            type = object.tags["place"],
        })
    end
end)
