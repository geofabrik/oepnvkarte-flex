-----------------------------------------------------------------------------
-- Oepnv_verylargeareas
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

local themepark, theme, cfg = ...

themepark:add_table({
    name = "oepnv_verylargeareas",
    geom = "geometry",
    ids_type = "tile",
    columns = themepark:columns({
        { column = "type", type = "text" },
    }),
    tiles = {
        minzoom = 7,
    },
})

-----------------------------------------------------------------------------

themepark:add_proc("gen", function(data)
    osm2pgsql.run_gen("raster-union", {
        schema = themepark.options.schema,
        name = "oepnv_verylargeareas",
        debug = true,
        src_table = themepark.with_prefix("oepnv_areas"),
        dest_table = themepark.with_prefix("oepnv_verylargeareas"),
        zoom = 10,
        geom_column = "geom",
        group_by_column = "type",
        margin = 0.0,
        make_valid = true,
    })
end)
