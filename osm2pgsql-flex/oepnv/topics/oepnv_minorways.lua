-----------------------------------------------------------------------------
-- Oepnv_ways
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

local themepark, theme, cfg = ...

themepark:add_table({
    name = "oepnv_minorways",
    geom = "geometry",
    ids_type = "any",
    columns = themepark:columns({
        { column = "name", type = "text" },
        { column = "type", type = "text" },
        { column = "layer", type = "smallint" },
        { column = "bridge", type = "boolean" },
        { column = "tunnel", type = "boolean" },
        { column = "oneway", type = "boolean" },
    }),
    tiles = {
        minzoom = 8,
    },
})

-- Get the way of the minorway types
function get_way_minortypes(object)
    local highwaytag = object.tags.highway
    local aerowaytag = object.tags.aeroway
    local minorwaysarea = nil

    if highwaytag == "path" or highwaytag == "footway" or highwaytag == "cycleway" or highwaytag == "footpath" then
        minorwaysarea = "path"
    elseif highwaytag == "track" then
        minorwaysarea = "track"
    elseif highwaytag == "minor" or highwaytag == "service" then
        minorwaysarea = "minor"
    elseif highwaytag == "steps" then
        minorwaysarea = "steps"
    end

    return minorwaysarea
end

-- derive the tunnel and bridge function giving it a t or f value
local function derivetunnel(object)
    if object.tags.tunnel then
        return "1"
    else
        return "0"
    end
end

local function derivebridge(object)
    if object.tags.bridge then
        return "1"
    else
        return "0"
    end
end

-- derive the layer value and if nothing then 0
local function derivelayer(object)
    if object.tags.layer then
        return object.tags.layer
    else
        return "0"
    end
end

-----------------------------------------------------------------------------

themepark:add_proc("way", function(object)
    local minorwaysarea = get_way_minortypes(object)
    if minorwaysarea then
        themepark:insert("oepnv_minorways", {
            geom = object:as_multilinestring(),
            name = object.tags["name"],
            type = minorwaysarea,
            bridge = derivebridge(object),
            tunnel = derivetunnel(object),
            layer = derivelayer(object),
            oneway = object.tags.oneway or "0",
        })
    end
end)

themepark:add_proc("relation", function(object)
    local minorwaysarea = get_way_minortypes(object)
    if minorwaysarea then
        themepark:insert("oepnv_minorways", {
            geom = object:as_multipolygon(),
            name = object.tags["name"],
            type = minorwaysarea,
            bridge = derivebridge(object),
            tunnel = derivetunnel(object),
            layer = derivelayer(object),
            oneway = object.tags.oneway or "0",
        })
    end
end)
