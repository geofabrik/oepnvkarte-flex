-----------------------------------------------------------------------------
-- Oepnv_waterways
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max 
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


local themepark, theme, cfg = ...

themepark:add_table{
    name = 'oepnv_waterways',
    geom = 'linestring',
    ids_type = 'any',
    columns = themepark:columns({
        { column = 'name', type = 'text'},
        { column = 'width', type = 'smallint'},
        { column = 'bridge', type = 'bool'},
        { column = 'tunnel', type = 'bool'},
        { column = 'layer', type = 'smallint'},
        { column = 'type', type = 'text'},

    }),
    tiles = {
        minzoom = 8,
    },
}


function get_waterway(object)
    
        local waterwaytag = object.tags.waterway
        local waterways = nil

        if waterwaytag== "river" then
            waterways = "river"

        elseif waterwaytag== "canal" then
            waterways = "canal"
        end
       return waterways
end



    
    


-----------------------------------------------------------------------------
-- Removed relations and nodes because it didn't seem necesarry
themepark:add_proc('way', function(object)
    local waterways = get_waterway(object)
    if waterways then
        themepark:insert('oepnv_waterways', {

            geom = object:as_linestring(),
            name = object.tags['name'],
            bridge = object.tags.bridge,
            tunnel = object.tags.tunnel,
            width = object.tags.width,
            layer = object.tags.layer,
            type = waterways

        })
    end
end)




