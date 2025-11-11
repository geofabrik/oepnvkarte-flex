-----------------------------------------------------------------------------
-- Oepnv_minor_waterways
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

local themepark, theme, cfg = ...

themepark:add_table({
    name = "oepnv_minorwaterways",
    geom = "linestring",
    ids_type = "any",
    columns = themepark:columns({
        { column = "name", type = "text" },
        { column = "width", type = "smallint" },
        { column = "bridge", type = "bool" },
        { column = "tunnel", type = "bool" },
        { column = "layer", type = "smallint" },
        { column = "type", type = "text" },
    }),
    tiles = {
        minzoom = 8,
    },
})

-- Get the waterwaytype
local function get_waterway(object)
    local waterwaytag = object.tags.waterway
    local waterways = nil

    if waterwaytag == "stream" then
        waterways = "stream"
    elseif waterwaytag == "drain" then
        waterways = "drain"
    elseif waterwaytag == "ditch" then
        waterways = "ditch"
    end

    return waterways
end

-----------------------------------------------------------------------------

themepark:add_proc("way", function(object)
    local waterways = get_waterway(object)
    if waterways then
        themepark:insert("oepnv_minorwaterways", {

            geom = object:as_linestring(),
            name = object.tags["name"],
            bridge = object.tags.bridge,
            tunnel = object.tags.tunnel,
            width = object.tags.width,
            layer = object.tags.layer,
            type = waterways,
        })
    end
end)
