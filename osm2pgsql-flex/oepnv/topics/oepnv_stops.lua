-----------------------------------------------------------------------------
-- Oepnv_stops
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

local themepark, theme, cfg = ...

themepark:add_table({
    name = "oepnv_stops",
    geom = "geometry",
    ids_type = "any",
    columns = themepark:columns({
        { column = "name", type = "text" },
        { column = "platform", type = "bool" },
        { column = "type", type = "text" },
        { column = "stop_position", type = "bool" },
        { column = "ref", type = "text" },
        { column = "code", type = "text" },
        { column = "polygon", type = "geometry" },
    }),
    tiles = {
        minzoom = 8,
    },
})

themepark:add_table({
    name = "stops_changed_interim",
    ids_type = "any",
    tiles = false,
})

-- Derive value and combine rail and train into rail for get_transptype
function get_type(object)
    if object.tags.rail == "yes" or object.tags.train == "yes" then
        return "rail"
    elseif object.tags.light_rail == "yes" then
        return "light_rail"
    elseif object.tags.subway == "yes" then
        return "subway"
    elseif object.tags.tram == "yes" then
        return "tram"
    elseif object.tags.ferry == "yes" then
        return "ferry"
    elseif object.tags.monorail == "yes" then
        return "monorail"
    elseif object.tags.funicular == "yes" then
        return "funicular"
    elseif object.tags.bus == "yes" then
        return "bus"
    end
    return "undefined"
end

-- Get the transport type for the stations
function get_transptype(object)
    local highwaytag = object.tags.highway
    local amenitytag = object.tags.amenity
    local railwaytag = object.tags.railway
    local pttag = object.tags.public_transport
    local platform = nil
    local stop_postition = nil
    local transptype = nil

    if highwaytag == "bus_stop" then
        transptype = "bus"
        platform = true
    elseif amenitytag == "bus_station" then
        transptype = "bus"
        polygon = true
    elseif amenitytag == "ferry_terminal" then
        transptype = "ferry"
        polygon = true
    elseif railwaytag == "station" or railwaytag == "halt" then
        transptype = "rail"
    elseif railwaytag == "tram_stop" then
        transptype = "tram"
    elseif highwaytag == "platform" or railwaytag == "platform" or pttag == "platform" then
        transptype = get_type(object)
    elseif railwaytag == "stop" then -- or pttag=="stop_position" then
        transptype = get_type(object)
        stop_position = true
    end

    --if pttag=="stop_position" then
    --    platform = false
    --    stop_position = true
    --    polygon = true
    --end
    if highwaytag == "platform" or railwaytag == "platform" or pttag == "platform" then
        platform = true
        stop_position = false
    end

    if pttag == "platform" then
        polygon = true
    end

    return platform, stop_position, transptype
end

-----------------------------------------------------------------------------

themepark:add_proc("way", function(object)
    local platform, stop_position, transptype = get_transptype(object)
    local way_or_area

    if transptype then
        if object.tags["area"] == "yes" then
            way_or_area = object:as_multipolygon()
        else
            way_or_area = object:as_multilinestring()
        end

        themepark:insert("stops_changed_interim", {})
        themepark:insert("oepnv_stops", {

            geom = way_or_area,
            point = "way",
            name = object.tags["name"],
            type = transptype,
            platform = platform,
            stop_position = stop_position,
            ref = object.tags.local_ref or object.tags.ref,
        })
    end
end)

themepark:add_proc("relation", function(object)
    local platform, stop_position, transptype = get_transptype(object)
    if transptype then
        local my_polygon = object:as_multipolygon()
        themepark:insert("stops_changed_interim", {})
        themepark:insert("oepnv_stops", {

            geom = object:as_multipolygon(),
            point = my_polygon:centroid(),
            name = object.tags["name"],
            platform = platform,
            type = transptype,
            stop_position = stop_position,
            ref = object.tags.local_ref or object.tags.ref,
        })
    end
end)

themepark:add_proc("node", function(object)
    local platform, stop_position, transptype = get_transptype(object)
    if transptype then
        themepark:insert("stops_changed_interim", {})
        themepark:insert("oepnv_stops", {
            geom = object:as_point(),
            name = object.tags["name"],
            platform = platform,
            type = transptype,
            stop_position = stop_position,
            ref = object.tags.local_ref or object.tags.ref,
        })
    end
end)
