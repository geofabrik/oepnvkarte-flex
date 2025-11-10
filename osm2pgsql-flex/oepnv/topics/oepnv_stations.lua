-----------------------------------------------------------------------------
-- Oepnv_stations
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max 
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


local themepark, theme, cfg = ...

themepark:add_table{
    name = 'oepnv_stations',
    geom = 'geometry', 
    ids_type = 'any',
    columns = themepark:columns({
        { column = 'name', type = 'text'},
        { column = 'type', type = 'text'},
        { column = 'lines_count', type = 'smallint'},
        { column = 'stops', type = 'bigint'},
        { column = 'point', type = 'point'},
        { column = 'area', type = 'geometry'},
    }),
    tiles = {
        minzoom = 8,
    },
}

themepark:add_table{
    name = 'oepnv_nodecontrolstations', 
    ids_type = 'any',
    columns = themepark:columns({
        { column = 'member_type', type = 'text', sql_type = 'character(1)', not_null = true},
        { column = 'member_id', type = 'bigint', not_null = true},
    }),
    indexes = {
	    { method='btree', column = {'member_type', 'member_id'} }
    },
    tiles = {
        minzoom = 8,
    },
}

-- Get the type of railway
function railtype(object)

    if object.tags.train=='yes' or object.tags.railway=='station' then
        return "rail"

    elseif object.tags.tram=='yes' or object.tags.railway=='tram_stop' then
        return "tram"

    elseif object.tags.bus=='yes' or object.tags.highway=='bus_stop' then
        return "bus"

    elseif object.tags.light_rail=='yes' then
        return "light_rail"

    elseif object.tags.ferry=='yes' then
        return "ferry"

    else return "undefined"

    end

end


-- Derive value and combine rail and train into rail for get_transptypestation
function get_type(object)
    if object.tags.rail=='yes' or object.tags.train=='yes' then
        return "rail"
    elseif object.tags.light_rail =='yes' then
        return "light_rail"
    elseif object.tags.subway=='yes' then
        return "subway"
    elseif object.tags.tram=='yes' then
        return "tram"
    elseif object.tags.ferry=='yes' then
        return "ferry"
    elseif object.tags.monorail=='yes' then
        return "monorail"
    elseif object.tags.funicular=='yes' then
        return "funicular"
    elseif object.tags.bus=='yes' then
        return "bus"
    end
    return "undefined"

end

-- Get the transport type for the stations
function get_transptypestation(object)
    
    local highwaytag = object.tags.highway
    local amenitytag = object.tags.amenity
    local railwaytag = object.tags.railway
    local pttag = object.tags.public_transport

    local platform
    local stop_position
    local transptype


    if highwaytag== "bus_stop" then
        transptype="bus"
        platform = true
    

    elseif amenitytag=="bus_station" then
        transptype="bus"
        polygon = true

    elseif amenitytag=="ferry_terminal" then
        transptype="ferry"
        polygon = true       

    elseif railwaytag=="station" or railwaytag=="halt" then
        transptype="rail"

    elseif railwaytag=="tram_stop" then
        transptype="tram"

    elseif highwaytag=="platform" or railwaytag=="platform" or pttag=="platform" then
        transptype=get_type(object)
    
    elseif railwaytag=="stop" then --or pttag=="stop_position" then
        transptype=get_type(object)
        stop_position = true
    end
    -- This was original in there but doesn't seem necesarry anymore
    --if pttag=="stop_position" then
    --    platform = false
    --    stop_position = true
    --    polygon = true
    --end
    if highwaytag=="platform" or railwaytag=="platform" or pttag=="platform" then
        platform = true
        stop_position = false
    end
    
    if  pttag=="platform" then
        polygon = true
    end

    -- this is a hack and needs to be fixed later!
    if pttag == 'stop_area' then
	    if object.tags.bus == 'yes' then
		    transptype = 'bus'
	else
		transptype = 'x'
	end
    end



	return  platform, stop_position, transptype 

end



-----------------------------------------------------------------------------



themepark:add_proc('relation', function(object)
    local my_collection = object:as_geometrycollection()
    local platform, stop_position, transptype = get_transptypestation(object)
    if transptype then
        themepark:insert('oepnv_stations', {

            geom = my_collection,
            name = object.tags['name'],
            type = transptype,
            stops = stop_position,
            point = my_collection:centroid(),
            area = nil})

        if object.tags.public_transport=='stop_area' then
                for _, member in ipairs(object.members) do
                        themepark:insert('oepnv_nodecontrolstations', {
                            member_type = string.upper(member.type),
                            member_id = member.ref
                        })
                end
        end
    end
end)

--themepark:add_proc('node', function(object)
--    local platform, stop_position, transptype = get_transptypestation(object)
--    if transptype then
--
--        themepark:insert('oepnv_stops', {
--            geom = object:as_point(),
--            name = object.tags['name'],
--            stops = stop_position,
--            type = transptype,
--            point = object:as_point()
--
--        })     
--    end
--end) 

-- Creating a buffer around the stations and stops
themepark:add_proc('gen', function(data)
    osm2pgsql.run_sql({
        description = 'Create a buffer around points',
        transaction = true,
        sql = {
        themepark.expand_template([[
		WITH clustered_points as (
		select
			stn.osm_id as osm_id, stn.osm_type as osm_type,
			unnest(ST_ClusterWithin(stp.geom, 150)) as geom
		FROM
			{prefix}oepnv_stops stp
			JOIN {prefix}oepnv_nodecontrolstations c ON stp.osm_id=c.member_id AND stp.osm_type=c.member_type
			JOIN {prefix}oepnv_stations stn ON stn.osm_id = c.osm_id AND stn.osm_type=c.osm_type
		WHERE stn.name is not null
		GROUP BY stn.osm_id, stn.osm_type
		)

	update {prefix}oepnv_stations
		SET
			point = ST_Centroid(clustered_points.geom),
			area = st_buffer(st_convexhull(clustered_points.geom),20)
		FROM clustered_points
		WHERE {prefix}oepnv_stations.osm_id = clustered_points.osm_id
			AND {prefix}oepnv_stations.osm_type = clustered_points.osm_type
	 ]]
        ),

	}
    })
end)

