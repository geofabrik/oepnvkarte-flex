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

function get_aerowaystype(object)
    local aerowaytag = object.tags.aerodrome
    local aerowaystype = nil

    if aerowaytag == "regional" then
        aerowaystype = "reg_airport"
    else
        return "airport"
    end

    return aerowaystype
end

-----------------------------------------------------------------------------

themepark:add_proc("way", function(object)
    if object.tags.aeroway == "aerodrome" then
        local aerowaystype = get_aerowaystype(object)
        themepark:insert("oepnv_airports", {

            name = object.tags["name"],
            geom = object:as_multipolygon(),
            iata = object.tags.iata,
            passengers = object.tags["passengers"],
            type = aerowaystype,
        })
    end
end)

themepark:add_proc("relation", function(object)
    if object.tags.aeroway == "aerodrome" then
        local aerowaystype = get_aerowaystype(object)
        themepark:insert("oepnv_airports", {

            iata = object.tags.iata,
            name = object.tags["name"],
            geom = object:as_multipolygon(),
            passengers = object.tags["passengers"],
            type = aerowaystype,
        })
    end
end)

themepark:add_proc("node", function(object)
    if object.tags.aeroway == "aerodrome" then
        local aerowaystype = get_aerowaystype(object)
        themepark:insert("oepnv_airports", {

            iata = object.tags.iata,
            name = object.tags["name"],
            city = object.tags["addr:city"],
            passengers = object.tags["passengers"],
            geom = object:as_point(),
            type = aerowaystype,
        })
    end
end)
