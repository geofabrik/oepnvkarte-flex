-----------------------------------------------------------------------------
-- Oepnv_ways
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max 
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


local themepark, theme, cfg = ...

themepark:add_table{
    name = 'oepnv_ways',
    geom = 'geometry', 
    ids_type = 'any',
    columns = themepark:columns({
        { column = 'name', type = 'text'},
        { column = 'type', type = 'text'},
        { column = 'layer', type = 'smallint'},
        { column = 'bridge', type = 'boolean'},
        { column = 'tunnel', type = 'boolean'},
        { column = 'ref', type = 'text'},
        { column = 'oneway', type = 'boolean'},

    }),
    tiles = {
        minzoom = 8,
    },
}



function get_way_types(object)
    
    local highwaytag = object.tags.highway
    local aerowaytag = object.tags.aeroway
    local areaways = nil

    if highwaytag=="motorway" then
        areaways = "motorway"

    elseif highwaytag=="motorway_link" then
        areaways = "motorway_link"
    
    elseif highwaytag=="trunk" then
        areaways = "trunk"

    elseif highwaytag=="trunk_link" then
        areaways = "trunk_link"

    elseif aerowaytag=="taxiway" then
        areaways = "taxiway"

    elseif aerowaytag=='runway' then
        areaways = "runway"
    
    elseif highwaytag=="primary" then
        areaways = "primary"

    elseif highwaytag=="primary_link" then
        areaways = "primary_link"

    elseif highwaytag=="secondary" then
        areaways = "secondary"

    elseif highwaytag=="secondary_link" then
        areaways = "secondary_link"

    elseif highwaytag=="tertiary" then
        areaways = "tertiary"

    elseif highwaytag=="unclassified" then
        areaways = "unclassified"

    elseif highwaytag=="residential" or highwaytag=="living_street" then
        areaways = "residential"

    elseif highwaytag=="pedestrian" then
        if object.tags.area == "yes" then
            areaways = "pedestrian_area"
        else
            areaways = "pedestrian"
        end      
    end

    return areaways
end

-- derive the tunnel and bridge function giving it a t or f value 
function derivetunnel(object)
    if object.tags.tunnel then
        return "1"

    else return "0"
    end
end

function derivebridge(object)
    if object.tags.bridge then
        return "1"

    else return "0"
    end
end
-- derive the layer value and if nothing then 0
function derivelayer(object)
    if object.tags.layer then
        return object.tags.layer

    else return "0"
    end
end

-----------------------------------------------------------------------------

themepark:add_proc('way', function(object)
    local waysarea = get_way_types(object)
    if waysarea then
    local derivebridge = derivebridge(object)
    local derivetunnel = derivetunnel(object)
    local derivelayer = derivelayer(object)
        themepark:insert('oepnv_ways', {
            geom = object:as_linestring(),
            name = object.tags['name'],
            type = waysarea,
            bridge = derivebridge,
            tunnel = derivetunnel,
            ref = object.tags.ref,
            layer = derivelayer,
            oneway = object.tags.oneway
            
        })
    end
end)

themepark:add_proc('relation', function(object)
    local waysarea = get_way_types(object)
    if waysarea then
        themepark:insert('oepnv_ways', {
            geom = object:as_multipolygon(),
            name = object.tags['name'],
            type = waysarea,
            bridge = object.tags.bridge,
            tunnel = object.tags.tunnel,
            ref = object.tags.ref,
            layer = object.tags.layer,
            oneway = object.tags.oneway

        })
    end
end)



