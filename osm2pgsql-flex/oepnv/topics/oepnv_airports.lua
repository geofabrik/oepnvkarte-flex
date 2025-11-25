-----------------------------------------------------------------------------
--oepnv_airports
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

local themepark, theme, cfg = ...

themepark:add_table({
    name = "oepnv_airports",
    geom = "geometry",
    ids_type = "any",
    columns = themepark:columns({
        { column = "name", type = "text" },
        { column = "iata", type = "text" },
        { column = "city", type = "text" },
        { column = "passengers", type = "bigint" },
        { column = "type", type = "text" },
    }),
    tiles = {
        minzoom = 8,
    },
})

function insert_airport(object, geom)
    local type = first_tag_match(object, {
        { { aerodrome = "public" }, "airport" },
        { { aerodrome = "regional" }, "reg_airport" },
        { { aerodrome = "continental" }, "cont_airport" },
        { { aerodrome = "international" }, "int_airport" },
    }) or "airport"

    themepark:insert("oepnv_airports", {
        name = object.tags["name"],
        iata = object.tags["iata"],
        city = object.tags["addr:city"],
        passengers = object.tags["passengers"],
        type = type,
        geom = geom,
    })
end

themepark:add_proc("node", function(object)
    if object.tags["aeroway"] == "aerodrome" and object.tags["access"] ~= "private" then
        insert_airport(object, object:as_point())
    end
end)

themepark:add_proc("way", function(object)
    if object.tags["aeroway"] == "aerodrome" and object.tags["access"] ~= "private" then
        insert_airport(object, object:as_multipolygon())
    end
end)

themepark:add_proc("relation", function(object)
    if object.tags["aeroway"] == "aerodrome" and object.tags["access"] ~= "private" then
        insert_airport(object, object:as_multipolygon())
    end
end)
