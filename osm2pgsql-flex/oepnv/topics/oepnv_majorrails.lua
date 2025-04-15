-----------------------------------------------------------------------------
-- Oepnv_majorrails THIS IS STILL IN PROCESS and doesn't seem necesarry after consulting Frederik
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max 
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


local themepark, theme, cfg = ...

themepark:add_table{
    name = 'oepnv_majorrails',
    geom = 'geometry', 
    ids_type = 'any',
    columns = themepark:columns({
        { column = 'name', type = 'text'},
        { column = 'ref', type = 'text'},
        { column = 'type', type = 'text'},
        { column = 'usage', type = 'text'},
        { column = 'bridge', type = 'boolean'},
        { column = 'tunnel', type = 'boolean'},
        { column = 'layer', type = 'smallint'},


    }),
    tiles = {
        minzoom = 8,
    },
}

--deriving railwaytype 
function railway(object)

    local railwaytag = object.tags.railway


    if railwaytag=='rail' then
        return "rail"
    elseif railwaytag== 'light_rail' then
        return "light_rail"
    elseif railwaytag=='subway' then
        return "subway"
    elseif railwaytag=='tram' then
        return "tram"
    elseif railwaytag=='monorail' then
        return "monorail"
    elseif railwaytag=='narrow_gauge' then
        return "narrow_gauge"
    end 

end




-----------------------------------------------------------------------------
-- removed relations and nodes because it didn't seem necesarry
themepark:add_proc('way', function(object)

    local transptype = railway(object)
    local railsize = get_railsize(object)

    if transptype then

        themepark:insert('oepnv_majorrails', {

            geom = object:as_linestring()


        })
    end
end)


themepark:add_proc('gen', function(data)
    osm2pgsql.run_gen('raster-union', {
        schema = themepark.options.schema,
        name = 'oepnv_majorrails',
        debug = true,
        src_table = themepark.with_prefix('oepnv_rails'),
        dest_table = themepark.with_prefix('oepnv_majorrails'),
        zoom = 7,
        geom_column = 'geom',
        group_by_column = 'type',
        margin = 0.0,
        make_valid = true
        
    })

end)

