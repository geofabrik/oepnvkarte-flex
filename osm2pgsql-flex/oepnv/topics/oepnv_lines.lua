-----------------------------------------------------------------------------
-- Oepnv_lines
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

local themepark, theme, cfg = ...

themepark:add_table({
    name = "oepnv_lines",
    geom = "multilinestring",
    ids_type = "any",
    columns = themepark:columns({
        { column = "name", type = "text" },
        { column = "ref", type = "text" },
        { column = "from", type = "text" },
        { column = "to", type = "text" },
        { column = "stops", type = "bigint" },
        { column = "type", type = "text" },
        { column = "back_stops", type = "bigint" },
        { column = "valid", type = "bool" },
        { column = "color", type = "text" },
        { column = "operator", type = "text" },
        { column = "network", type = "text" },
        { column = "back_geom", type = "geometry" },
        { column = "other", type = "jsonb" },
    }),
    tiles = {
        minzoom = 8,
    },
})

-- Getting type of line
function get_typeline(object)
    local routetag = object.tags.route
    local linetag = object.tags.line
    local typeline = nil

    if linetag == "rail" or routetag == "rail" then
        typeline = "rail"
    elseif linetag == "tram" or routetag == "tram" then
        typeline = "tram"
    elseif linetag == "light_rail" or routetag == "light_rail" then
        typeline = "light_rail"
    elseif linetag == "trolleybus" or routetag == "trolleybus" then
        typeline = "trolleybus"
    elseif linetag == "bus" or routetag == "bus" then
        typeline = "bus"
    elseif linetag == "subway" or routetag == "subway" then
        typeline = "subway"
    elseif linetag == "ferry" or routetag == "ferry" then
        typeline = "ferry"
    elseif linetag == "funicular" or routetag == "funicular" then
        typeline = "funicular"
    elseif linetag == "monorail" or routetag == "monorail" then
        typeline = "monorail"
    elseif linetag == "train" or routetag == "train" then
        typeline = "train"
    end

    return typeline
end

-----------------------------------------------------------------------------

themepark:add_proc("relation", function(object)
    local typeline = get_typeline(object)
    local tbl = { object.tags }
    if typeline then
        themepark:insert("oepnv_lines", {

            geom = object:as_multilinestring(),
            name = object.tags["name"],
            ref = object.tags.ref,
            from = object.tags.from,
            to = object.tags.to,
            stops = nil,
            back_stops = nil,
            type = typeline,
            color = object.tags.colour,
            network = object.tags.network,
            operator = object.tags.operator,
            back_geom = object:as_multilinestring(),
            other = object.tags,
        })
    end
end)
