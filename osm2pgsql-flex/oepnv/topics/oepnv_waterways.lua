-----------------------------------------------------------------------------
-- Oepnv_waterways
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

local themepark, theme, cfg = ...

themepark:add_table({
    name = "oepnv_waterways",
    geom = "linestring",
    ids_type = "any",
    columns = themepark:columns({
        { column = "name", type = "text" },
        { column = "width", type = "smallint" },
        { column = "bridge", type = "bool", not_null = true },
        { column = "tunnel", type = "bool", not_null = true },
        { column = "layer", type = "smallint" },
        { column = "type", type = "text", not_null = true },
    }),
    tiles = {
        minzoom = 8,
    },
})

-----------------------------------------------------------------------------
-- Removed relations and nodes because it didn't seem necesarry
themepark:add_proc("way", function(object)
    if is_in(object.tags["waterway"], { "river", "canal" }) then
        themepark:insert("oepnv_waterways", {
            name = object.tags["name"],
            bridge = object.tags["bridge"] or "no",
            tunnel = object.tags["tunnel"] or "no",
            width = object.tags["width"],
            layer = object.tags["layer"],
            type = object.tags["waterway"],
            geom = object:as_linestring(),
        })
    end
end)
