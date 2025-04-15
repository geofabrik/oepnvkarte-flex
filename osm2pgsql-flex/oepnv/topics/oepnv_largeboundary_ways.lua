-----------------------------------------------------------------------------
-- Oepnv_largeboundary_ways
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max 
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


local themepark, theme, cfg = ...

themepark:add_table{
    name = 'oepnv_largeboundary_ways',
    geom = 'multilinestring', 
    ids_type = 'any',
    columns = themepark:columns({
        { column = 'type', type = 'text'},
        { column = 'level', type = 'smallint'},

    }),
    tiles = {
        minzoom = 8,
    },
}


function get_boundary_type(object)

    local boundarytype = object.tags.boundary
    local boundarytag = nil

    if boundarytype=="administrative" then
        boundarytag = "administrative"

    elseif boundarytype=="postal_code" then
        boundarytag = "postcode"
        end

    return boundarytag

end

function get_admin_level(object)

    local adminlevel = object.tags['admin_level']
    local adminvalue = nil

    if adminlevel=="1" then
        adminvalue = "1"

    elseif adminlevel=="2" then
        adminvalue = "2"
    
    elseif adminlevel=="3" then
        adminvalue = "3"
    
    elseif adminlevel=="4" then
        adminvalue = "4"
    end

    return adminvalue

end
        -- ---------------------------------------------------------------------------

themepark:add_proc('way', function(object)
    local boundarytag = get_boundary_type(object)
    local adminvalue = get_admin_level(object)
    if boundarytag and adminvalue then
        themepark:insert('oepnv_largeboundary_ways', {

            geom = object:as_multilinestring(),
            type = boundarytag,
            level = adminvalue

        })
    end
end)




