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
        { column = "population", type = "smallint" },
        { column = "type", type = "text" },
    }),
    tiles = {
        minzoom = 8,
    },
})

-- Return true iff value is contained in list
function is_in(value, list)
    for _, el in ipairs(list) do
        if value == el then
            return true
        end
    end
    return false
end

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
            population = object.tags.population or "0",
            type = object.tags["place"],
        })
    end
end)
