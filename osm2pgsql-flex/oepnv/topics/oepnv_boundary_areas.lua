-----------------------------------------------------------------------------
--oepnv_boundary_areas
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max 
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


local themepark, theme, cfg = ...

themepark:add_table{
    name = 'oepnv_boundary_areas',
    geom = 'multipolygon', 
    ids_type = 'any',
    columns = themepark:columns({
        { column = 'name', type = 'text'},
        { column = 'level', type = 'smallint'},
        { column = 'type', type = 'text'},
        { column = 'postcode', type = 'text'},

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

    elseif boundarytype=="maritime" then
        boundarytag = "maritime"

    elseif boundarytype=="postal_code" then
        boundarytag = "postcode"
    end

    return boundarytag

end
        -- ---------------------------------------------------------------------------


themepark:add_proc('relation', function(object)
    local boundarytag = get_boundary_type(object)
    if boundarytag then
        themepark:insert('oepnv_boundary_areas', {

            geom = object:as_multipolygon(),
            name = object.tags['name'],
            postcode = object.tags['postal_code'],
            level = object.tags['admin_level'],
            type = boundarytag

        })
    end
end)

