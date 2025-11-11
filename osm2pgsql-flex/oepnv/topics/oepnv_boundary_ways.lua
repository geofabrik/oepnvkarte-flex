-----------------------------------------------------------------------------
--oepnv_boundary_ways
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

local themepark, theme, cfg = ...

themepark:add_table({
    name = "oepnv_boundary_ways",
    geom = "multilinestring",
    ids_type = "any",
    columns = themepark:columns({
        { column = "type", type = "text" },
        { column = "level", type = "smallint" },
    }),
    tiles = {
        minzoom = 8,
    },
})

-- Getting the boundary type, pay attention this does not only filter on way this happens in add_proc
function get_boundary_type_ways(object)
    local boundarytype = object.tags.boundary
    local boundarytag = nil

    if boundarytype == "administrative" then
        boundarytag = "administrative"
    elseif boundarytype == "postal_code" then
        boundarytag = "postcode"
    end

    return boundarytag
end
-- ---------------------------------------------------------------------------

themepark:add_proc("way", function(object)
    local boundarytag = get_boundary_type_ways(object)
    if boundarytag then
        themepark:insert("oepnv_boundary_ways", {

            geom = object:as_multilinestring(),
            type = boundarytag,
            level = object.tags["admin_level"],
        })
    end
end)
