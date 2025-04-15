-----------------------------------------------------------------------------
--oepnv_areas
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max 
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


local themepark, theme, cfg = ...

themepark:add_table{
    name = 'oepnv_areas',
    geom = 'multipolygon', 
    ids_type = 'any',
    columns = themepark:columns({
        { column = 'name', type = 'text'},
        { column = 'type', type = 'text'},
        { column = 'layer', type = 'smallint'},
        { column = 'largetype', type = 'text'},

    }),
    tiles = {
        minzoom = 8,
    },
}


-- Get the type of the area
function get_area_type(object)
    
    local landusetag = object.tags.landuse
    local naturaltag = object.tags.natural
    local waterwaytag = object.tags.waterway
    local leisuretag = object.tags.leisure
    local amenitytag = object.tags.amenity
    local aerowaytag = object.tags.aeroway
    local boundarytag = object.tags.boundary
    local landuse = nil

    if landusetag=="forest" or landusetag=="wood" then
        landuse = "forest"

    elseif naturaltag=="scrub" or naturaltag=="heath" or naturaltag=="grassland" or naturaltag=="fell" then
        landuse = "bush"
    
    elseif landusetag=="recreation_ground" or landusetag=="village_green" or landusetag=="allotments" or leisuretag=="park" or leisuretag=="pitch" or leisuretag=="track" or leisuretag=="golf_course" or leisuretag=="common" or leisuretag=="playground" or leisuretag=="garden" then
        landuse = "park"

    elseif naturaltag=="water" or naturaltag=="lake" or waterwaytag=="riverbank" or landusetag=="basin" or landusetag=="reservoir" then
        landuse = "water"

    elseif landusetag=="residential" or landusetag=="industrial" or landusetag=="commercial" or landusetag=="retail" then
        landuse = "city"

    elseif landusetag=="farm" or landusetag=="farmland" or landusetag=="meadow" or landusetag=="orchard"  then
        landuse = "farm"
    
    elseif landusetag=="cemetery" then
        landuse = "cemetery"

    elseif naturaltag=="glacier" then
        landuse = "ice"

    elseif naturaltag=="beach" then
        landuse = "beach"

    elseif amenitytag=="parking" then
        return amenitytag

    elseif aerowaytag=="apron" or aerowaytag=="aerodrome" then
        landuse = "airport"

    elseif landusetag=="grass" then
        landuse = "grass"

    elseif boundarytag=="national_park" then
        landuse = "national_park"
    
    end

    return landuse

end

--Get the large type of the area
function get_large_area_type(object)
    
    local landusetag = object.tags.landuse
    local naturaltag = object.tags.natural
    local waterwaytag = object.tags.waterway

    local largeforest = nil
    local largewater = nil
    local largecity = nil
    local largefarm = nil


    if landusetag=="forest" or landusetag=="wood" then
        largeforest = "forest"

    elseif naturaltag=="water" or naturaltag=="lake" or waterwaytag=="riverbank" or landusetag=="basin" or landusetag=="reservoir" then
        largeforest = "water"

    elseif landusetag=="residential" or landusetag=="industrial" or landusetag=="commercial" or landusetag=="retail" then
        largeforest = "city"

    elseif landusetag=="farm" or landusetag=="farmland" or landusetag=="meadow" or landusetag=="orchard"  then
        largeforest = "farm"


    
    end

    return largeforest

end

-----------------------------------------------------------------------------

themepark:add_proc('area', function(object)
    local landuse = get_area_type(object)
    if landuse then
        local largeareatype = get_large_area_type(object)
        themepark:insert('oepnv_areas', {

            geom = object:as_multipolygon(),
            name = object.tags['name'],
            type = landuse,
            layer = object.tags.layer,
            largetype = largeareatype
        })
    end
end)





