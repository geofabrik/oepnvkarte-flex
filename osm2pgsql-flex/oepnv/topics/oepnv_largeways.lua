-----------------------------------------------------------------------------
-- Oepnv_largeways
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

local themepark, theme, cfg = ...

themepark:add_table({
    name = "oepnv_largeways",
    geom = "geometry",
    ids_type = "any",
    columns = themepark:columns({
        { column = "type", type = "text" },
    }),
    tiles = {
        minzoom = 8,
    },
})

-- Getting the large types this does not filter on the way!
function get_way_largetypes(object)
    local highwaytag = object.tags.highway
    local aerowaytag = object.tags.aeroway
    local wayslargearea = nil

    if highwaytag == "motorway" then
        wayslargearea = "motorway"
    elseif highwaytag == "trunk" then
        wayslargearea = "trunk"
    elseif highwaytag == "primary" then
        wayslargearea = "primary"
    elseif highwaytag == "secondary" then
        wayslargearea = "secondary"
    elseif highwaytag == "tertiary" then
        wayslargearea = "tertiary"
    end

    return wayslargearea
end

-----------------------------------------------------------------------------

themepark:add_proc("way", function(object)
    local wayslargearea = get_way_largetypes(object)
    if wayslargearea then
        themepark:insert("oepnv_largeways", {

            geom = object:as_linestring(),
            type = wayslargearea,
        })
    end
end)

themepark:add_proc("relation", function(object)
    local wayslargearea = get_way_largetypes(object)
    if wayslargearea then
        themepark:insert("oepnv_largeways", {

            geom = object:as_multipolygon(),
            type = wayslargearea,
        })
    end
end)
