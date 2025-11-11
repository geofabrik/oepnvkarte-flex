-----------------------------------------------------------------------------
-- Oepnv_rails
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

local themepark, theme, cfg = ...

themepark:add_table({
    name = "oepnv_rails",
    geom = "linestring", -- needs to support polygon and multipolygon
    ids_type = "any",
    columns = themepark:columns({
        { column = "name", type = "text" },
        { column = "ref", type = "text" },
        { column = "type", type = "text" },
        { column = "usage", type = "text" },
        { column = "bridge", type = "boolean" },
        { column = "tunnel", type = "boolean" },
        { column = "layer", type = "smallint" },
    }),
    tiles = {
        minzoom = 8,
    },
})

-- Get the type of railway
local function railway(object)
    local railwaytag = object.tags.railway

    if railwaytag == "rail" then
        return "rail"
    elseif railwaytag == "light_rail" then
        return "light_rail"
    elseif railwaytag == "subway" then
        return "subway"
    elseif railwaytag == "tram" then
        return "tram"
    elseif railwaytag == "monorail" then
        return "monorail"
    elseif railwaytag == "narrow_gauge" then
        return "narrow_gauge"
    end
end

-- "lua find out if way is one of list"
local function get_railuse(object)
    local usagetag = object.tags.usage

    if
        usagetag == "highspeed"
        or usagetag == "main"
        or usagetag == "branch"
        or usagetag == "tourism"
        or usagetag == "industrial"
        or usagetag == "military"
        or usagetag == "test"
    then
        return usagetag
    end
    return nil
end

-- creating a value to filter minor on regular rails
local function get_railsize(object)
    local servicetag = object.tags.service

    if servicetag == "yard" or servicetag == "siding" or servicetag == "spur" or servicetag == "crossover" then
        return "service"
    end
    return nil
end

local as_bool = function(value)
    return value == "yes" or value == "true" or value == "1"
end
-----------------------------------------------------------------------------
-- Removed relations and nodes because it didn't seem necesarry
themepark:add_proc("way", function(object)
    if railway(object) and not get_railsize(object) then
        themepark:insert("oepnv_rails", {

            geom = object:as_linestring(),
            name = object.tags["name"],
            ref = object.tags.ref,
            type = railway(object),
            usage = get_railuse(object),
            bridge = as_bool(object.tags.bridge),
            tunnel = as_bool(object.tags.tunnel),
            layer = object.tags.layer or "0",
        })
    end
end)
