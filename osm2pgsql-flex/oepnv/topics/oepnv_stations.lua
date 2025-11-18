-----------------------------------------------------------------------------
-- Oepnv_stations
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max
-----------------------------------------------------------------------------

local themepark, theme, cfg = ...

themepark:add_table({
    name = "oepnv_stations",

    -- bit of a hack, weG
    ids_type = "any",

    columns = themepark:columns({
        { column = "id", sql_type = "serial", create_only = true },
        { column = "name", type = "text" },
        { column = "type", type = "text" },
        { column = "point", type = "point" },
        { column = "area", type = "geometry" },
    }),
    indexes = {
        { method = "btree", column = { "osm_type", "osm_id" }, unique = true },
        { method = "btree", column = { "id" }, unique = true },
},
    tiles = {
        minzoom = 8,
    },
})

-- TODO split this and put a separate stop areas for the relations like that
--
themepark:add_table({
    name = "stations",
    ids_type = "any",
    columns = themepark:columns({
        { column = "name", type = "text" },
        { column = "type", type = "text" },
        { column = "public_transport", type = "text" },
        { column = "point", type = "point" },
    }),
    tiles = false,
})

--themepark:add_table({
--    name = "stations_changed_interim",
--    ids_type = "any",
--    tiles = false,
--})

themepark:add_table({
	name = "oepnv_stations_source_obj",
    ids_type = false,
    columns = themepark:columns({
        { column = "station_id", type = "bigint" },
        { column = "osm_type", type = "text", sql_type = "character(1)", not_null = true },
        { column = "osm_id", type = "bigint", not_null = true },
    }),
    indexes = {
        --{ method = "btree", column = { "osm_type", "osm_id" }, unique = true },
        { method = "btree", column = { "station_id" } },
    },
})


themepark:add_table({
    name = "oepnv_stop_area_members",
    ids_type = "any",
    columns = themepark:columns({
        { column = "member_role", type = "text" },
        { column = "member_type", type = "text", sql_type = "character(1)", not_null = true },
        { column = "member_id", type = "bigint", not_null = true },
    }),
    indexes = {
        { method = "btree", column = { "member_type", "member_id" } },
    },
    tiles = false,
})

function kvs(object, key, values)
    for _, value in ipairs(values) do
        if object.tags[key] == value then
            return true
        end
    end
    return false
end

-- Get the type of railway
function railtype(object)
    if object.tags.train == "yes" or object.tags.railway == "station" then
        return "rail"
    elseif object.tags.tram == "yes" or object.tags.railway == "tram_stop" then
        return "tram"
    elseif object.tags.bus == "yes" or object.tags.highway == "bus_stop" then
        return "bus"
    elseif object.tags.light_rail == "yes" then
        return "light_rail"
    elseif object.tags.ferry == "yes" then
        return "ferry"
    else
        return "undefined"
    end
end

-- Derive value and combine rail and train into rail for get_transptypestation
function get_type(object)
    -- T=yes
    simple_yes_types = { "rail", "light_rail", "subway", "tram", "ferry", "monorail", "funicular", "bus" }

    for _, type in ipairs(simple_yes_types) do
        if object.tags[type] == "yes" then
            return type
        end
    end

    if object.tags["train"] == "yes" then
        return "rail"
    elseif object.tags["railway"] == "facility" then
        -- example of this r4084063
        return "rail"
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

    if highwaytag == "bus_stop" then
        transptype = "bus"
        platform = true
    elseif amenitytag == "bus_station" then
        transptype = "bus"
        polygon = true
    elseif amenitytag == "ferry_terminal" then
        transptype = "ferry"
        polygon = true
    elseif railwaytag == "station" or railwaytag == "halt" then
        transptype = "rail"
    elseif railwaytag == "tram_stop" then
        transptype = "tram"
    elseif highwaytag == "platform" or railwaytag == "platform" or pttag == "platform" then
        transptype = get_type(object)
    elseif railwaytag == "stop" then --or pttag=="stop_position" then
        transptype = get_type(object)
        stop_position = true
    end
    -- This was original in there but doesn't seem necesarry anymore
    --if pttag=="stop_position" then
    --    platform = false
    --    stop_position = true
    --    polygon = true
    --end
    if highwaytag == "platform" or railwaytag == "platform" or pttag == "platform" then
        platform = true
        stop_position = false
    end

    if pttag == "platform" then
        polygon = true
    end

    -- this is a hack and needs to be fixed later!
    if pttag == "stop_area" then
        transptype = get_type(object)
    end

    return platform, stop_position, transptype
end

-----------------------------------------------------------------------------

themepark:add_proc("node", function(object)
    if object.tags["name"] == nil then
        return
    end
    local platform, stop_position, transptype = get_transptypestation(object)

    if object.tags["public_transport"] == "station" then
        --themepark:insert("stations_changed_interim", {})
        themepark:insert("stations", {
            name = object.tags["name"],
            public_transport = object.tags["public_transport"],
            type = transptype,
            point = object:as_point(),
        })
    end
end)

themepark:add_proc("relation", function(object)
    if object.tags["name"] == nil then
        return
    end
    local platform, stop_position, transptype = get_transptypestation(object)
    if transptype or kvs(object, "public_transport", { "stop_area" }) then
        --themepark:insert("stations_changed_interim", {})
        themepark:insert("stations", {
            name = object.tags["name"],
            type = transptype,
            public_transport = object.tags["public_transport"],
            point = nil,
        })

        if object.tags.public_transport == "stop_area" then
            for _, member in ipairs(object.members) do
                themepark:insert("oepnv_stop_area_members", {
                    member_role = member.role,
                    member_type = string.upper(member.type),
                    member_id = member.ref,
                })
            end
        end
    end
end)

themepark:add_proc("gen", function(data)
    osm2pgsql.run_sql({
        description = "Assemble all the stops to make a station",
        transaction = true,
        sql = {
	-- Hack for now, just recreate everything
    -- Later we can just delete the _stations for changed objects and this should all work
            themepark.expand_template([[ truncate table oepnv_stations; ]]),
            themepark.expand_template([[ truncate table oepnv_stations_source_obj; ]]),

	    -- First the public_transport=stations relations
            themepark.expand_template([[
WITH
  -- These are the objects we need
  unalloc_stations AS ( select osm_type, osm_id, name as name_rel, type from stations left join oepnv_stations_source_obj USING (osm_type, osm_id) where public_transport  = 'stop_area' and station_id IS NULL)

  ,station_name_point AS (
    select
      DISTINCT on (station_osm_type, station_osm_id)
      unalloc_stations.osm_type as station_osm_type, unalloc_stations.osm_id as station_osm_id, 
      stations.osm_type as label_osm_type, stations.osm_id as label_osm_id,
      stations.name as name, stations.point as point
      from
        unalloc_stations JOIN
        (oepnv_stop_area_members join stations ON (stations.osm_id = member_id and stations.osm_type = member_type AND stations.osm_type = 'N'))
        ON (unalloc_stations.osm_type = oepnv_stop_area_members.osm_type and unalloc_stations.osm_id = oepnv_stop_area_members.osm_id)
      )

  ,station_platforms AS ( select unalloc_stations.osm_type as station_osm_type, unalloc_stations.osm_id as station_osm_id, stp.osm_type as stop_osm_type, stp.osm_id as stop_osm_id, stp.geom as geom from (unalloc_stations join oepnv_stop_area_members USING (osm_type, osm_id)) join oepnv_stops stp ON (member_id = stp.osm_id and member_type = stp.osm_type) where member_role = 'platform')
  ,station_platform_hull AS ( select station_osm_type, station_osm_id, ST_Collect(geom) as geom from station_platforms group by (station_osm_type, station_osm_id) )

  -- This is where we prepare the new row for oepnv_stations
  ,new_data AS (
    select
      osm_type, osm_id,
      coalesce(unalloc_stations.name_rel, station_name_point.name) as name,
      type,
      coalesce(station_name_point.point, ST_Centroid(geom)) as point,
      ST_Buffer(ST_ConvexHull(geom), 20) as area
      from
        unalloc_stations
          left join station_name_point ON (unalloc_stations.osm_type = station_osm_type and unalloc_stations.osm_id = station_osm_id)
          left join station_platform_hull h ON (unalloc_stations.osm_type = h.station_osm_type and unalloc_stations.osm_id = h.station_osm_id)
  )


  -- Here we actualy insert into oepnv_stations and get our new station_id
  ,new_station_id AS ( insert into oepnv_stations (osm_type, osm_id, name, type, point, area) select * from new_data returning id as station_id, osm_type, osm_id )

  -- We need to insert a few more dependant 
  ,insert0 AS ( insert into oepnv_stations_source_obj select * from new_station_id )
  
  ,insert1 AS ( insert into oepnv_stations_source_obj select station_id, s.label_osm_type as osm_type, s.label_osm_id as osm_id from new_station_id n join station_name_point s ON (n.osm_type = s.station_osm_type AND n.osm_id = s.station_osm_id) )
  ,insert2 AS ( insert into oepnv_stations_source_obj select station_id, p.stop_osm_type as osm_type, p.stop_osm_id as osm_id from new_station_id n join station_platforms p ON (n.osm_type = p.station_osm_type AND n.osm_id = p.station_osm_id) )

  select 1

  ;

	     ]]),

	     -- Now those oepnv_stops's not in a relation. We group by nearby name
            themepark.expand_template([[
WITH
  -- These are the objects we need
  unalloc_stops AS (
	select
		osm_type, osm_id, gid, name, type,
		geom,
		ST_ClusterWithinWin(geom, 150) OVER (partition by name, type) as cluster_id
	from oepnv_stops
		left join oepnv_stations_source_obj USING (osm_type, osm_id)
	where station_id IS NULL
),


  ,new_data AS (
    select
      first_value(osm_type) OVER (order by gid) as osm_type, first_value(osm_id) OVER (order by gid) as osm_id,
      name
      type,
      ST_Centroid(geom) as point,
      ST_Buffer(ST_ConvexHull(geom), 20) as area
      from
        unalloc_stations
      group by name, type, cluster_id
  )


  -- Here we actualy insert into oepnv_stations and get our new station_id
  ,new_station_id AS ( insert into oepnv_stations (osm_type, osm_id, name, type, point, area) select * from new_data returning id as station_id, osm_type, osm_id )

  -- We need to insert a few more dependant objects
  --
  ,insert0 AS ( insert into oepnv_stations_source_obj select * from new_station_id )

  select osm_type, osm_id from unalloc_stations group by name, type, cluster_id
  
--- aaaaaah let's do this in python instead!



            -- themepark.expand_template([[
	    -- ]]),gg

        }
    })
end)

---- Creating a buffer around the stations and stops
--themepark:add_proc("gen", function(data)
--    osm2pgsql.run_sql({
--        description = "Create a buffer around points",
--        transaction = true,
--        sql = {
--            -- First every thing that's in a relation
--            themepark.expand_template([[
--		WITH clustered_points as (
--		select
--			stn.osm_id as osm_id, stn.osm_type as osm_type,
--			unnest(ST_ClusterWithin(stp.geom, 150)) as geom
--		FROM
--			{prefix}oepnv_stops stp
--			JOIN (
--				{prefix}oepnv_stop_area_members c
--				JOIN {prefix}oepnv_stations stn ON stn.osm_id = c.osm_id AND stn.osm_type=c.osm_type
--				)
--				ON stp.osm_id=c.member_id AND stp.osm_type=c.member_type
--		WHERE stn.name is not null
--		GROUP BY stn.osm_id, stn.osm_type
--		)
--
--	update {prefix}oepnv_stations
--		SET
--			point = ST_Centroid(clustered_points.geom),
--			area = st_buffer(st_convexhull(clustered_points.geom),20)
--		FROM clustered_points
--		WHERE {prefix}oepnv_stations.osm_id = clustered_points.osm_id
--			AND {prefix}oepnv_stations.osm_type = clustered_points.osm_type
--	 ]]),
--            -- Then things that aren't in a relation, but grouped by name & location
--            themepark.expand_template([[
--		WITH clustered_points as (
--		select
--			stp.name as name, stp.type as type,
--			unnest(ST_ClusterWithin(stp.geom, 150)) as geom
--		FROM
--			{prefix}oepnv_stops stp
--			LEFT JOIN {prefix}oepnv_stop_area_members c
--			ON stp.osm_id=c.member_id AND stp.osm_type=c.member_type
--		WHERE c.osm_id IS NULL
--		GROUP BY stp.name, stp.type
--		)
--
--	INSERT INTO {prefix}oepnv_stations
--		(osm_type, osm_id, name, type, point, area, geom)
--	select
--		'X' as osm_type, 0 as osm_id,
--		name, type,
--		ST_Centroid(clustered_points.geom) as point,
--		st_buffer(st_convexhull(clustered_points.geom),20) as area,
--		'GEOMETRYCOLLECTION EMPTY'::geometry as geom
--	from clustered_points
--
--	 ]]),
--        },
--    })
--end)
