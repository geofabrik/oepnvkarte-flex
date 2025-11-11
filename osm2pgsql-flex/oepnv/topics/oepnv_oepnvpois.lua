-----------------------------------------------------------------------------
-- Oepnv_oepnvpois
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

local themepark, theme, cfg = ...

themepark:add_table({
    name = "oepnv_oepnvpois",
    geom = "point",
    ids_type = "any",
    columns = themepark:columns({
        { column = "name", type = "text" },
        { column = "type", type = "text" },
    }),
    tiles = {
        minzoom = 8,
    },
})

-- Get the type of amenity
function get_amenity(object)
    local amenitytag = object.tags.amenity
    local accessability = object.tags.access
    local amenitytype = nil -- Making sure the variable is zero

    if amenitytag == "car_sharing" and accessability ~= "private" then
        amenitytype = "car_sharing"
    elseif amenitytag == "car_rental" and accessability ~= "private" then
        amenitytype = "car_rental"
    elseif amenitytag == "parking" and accessability ~= "private" then
        amenitytype = "parking"
    elseif amenitytag == "taxi" and accessability ~= "private" then
        amenitytype = "taxi"
    elseif amenitytag == "bicycle_rental" and accessability ~= "private" then
        amenitytype = "bicycle_rental"
    end

    return amenitytype
end

-----------------------------------------------------------------------------

themepark:add_proc("node", function(object)
    local amenitytype = get_amenity(object)
    if amenitytype then
        themepark:insert("oepnv_oepnvpois", {

            name = object.tags["name"],
            geom = object:as_point(),
            type = amenitytype,
        })
    end
end)

themepark:add_proc("area", function(object)
    local amenitytype = get_amenity(object)
    if amenitytype then
        local my_polygon = object:as_multipolygon()
        themepark:insert("oepnv_oepnvpois", {

            name = object.tags["name"],
            geom = my_polygon:centroid(),
            type = amenitytype,
        })
    end
end)
