-----------------------------------------------------------------------------
-- Oepnv_stations
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max
-----------------------------------------------------------------------------

local themepark, theme, cfg = ...

-- ÖPNV stations. incl. the point for high zoom, and a buffer area for low zoom.
themepark:add_table({
    name = "oepnv_stations",

    ids_type = false,

    columns = themepark:columns({
        { column = "id", sql_type = "serial", create_only = true },
        { column = "name", type = "text" },
        { column = "type", type = "text" },
        { column = "point", type = "point" },
        { column = "area", type = "geometry" },
    }),
    indexes = {
        { method = "btree", column = { "type", "name" } },
        { method = "btree", column = { "id" }, unique = true },
        { method = "gist", column = { "point" } },
        { method = "gist", column = { "area" } },
    },
    tiles = {
        minzoom = 8,
    },
})

-- nodes & ways which are stations
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


-- Store relations which are stations
themepark:add_table({
    name = "stations_rels",
    ids_type = "relation",
    columns = themepark:columns({
        { column = "name", type = "text" },
        { column = "type", type = "text" },
        { column = "public_transport", type = "text" },
    }),
    tiles = false,
})

-- The memebers of all the stop area relations in the stations_rels table
themepark:add_table({
    name = "stop_area_members",
    ids_type = "relation",
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

-- When doing a data update, this table will be filled with objects that have
-- changed, so we know what to update later.
themepark:add_table({
    name = "stations_changed_interim",
    ids_type = "any",
    tiles = false,
})

-- True iff object key tables
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
        themepark:insert("stations_changed_interim", {})
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
        themepark:insert("stations_changed_interim", {})
        themepark:insert("stations_rels", {
            name = object.tags["name"],
            type = transptype,
            public_transport = object.tags["public_transport"],
        })

        if object.tags.public_transport == "stop_area" then
            for _, member in ipairs(object.members) do
                themepark:insert("stop_area_members", {
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
            -- if a relation changes, then delete all oepnv_stations which intersect one of that relation's members
            themepark.expand_template([[
	    	delete from oepnv_stations where id in (
			select stn.id from stations_changed_interim i JOIN stations_rels r ON (i.osm_id = r.relation_id AND i.osm_type = 'R') join stop_area_members m USING (relation_id) JOIN oepnv_stops stp ON (m.member_id = stp.osm_id AND m.member_type = stp.osm_type) JOIN oepnv_stations AS stn ON (stp.geom && stn.area AND ST_Intersects(stn.area, stp.geom)) 
		);
		]]),
            -- if another stop changes, delete all oepnv_stations which intersect that stop
            themepark.expand_template([[
	    	delete from oepnv_stations where id in 
		(
		select stn.id
		FROM (stations_changed_interim JOIN oepnv_stops USING (osm_type, osm_id)) stp JOIN oepnv_stations stn ON (stn.area && stp.geom AND ST_Intersects(stn.area, stp.geom))
		);
	]]),

            -- Any stations which have zero stops inside? delete them.
            themepark.expand_template([[
	    	delete from oepnv_stations where id in (
		select stn.id from oepnv_stations stn left join oepnv_stops stp ON (ST_Intersects(stn.area, stp.geom)) where stp.geom IS NULL)
		]]),
            -- clear our todo list
            themepark.expand_template([[ truncate table stations_changed_interim ]]),

            -- First the public_transport=stations relations
            themepark.expand_template([[
		WITH
		  relations_wo_stations AS (
			  select DISTINCT m.relation_id
			  from
			  	(oepnv_stops stp join stop_area_members m ON (m.member_id = stp.osm_id and m.member_type = stp.osm_type and m.member_role = 'platform'))
				left join oepnv_stations stn ON (ST_Intersects(stn.area, stp.geom))
			where stn.area IS NULL
		  )
		  ,unalloc_stations AS ( select 'R' AS osm_type, relation_id AS osm_id, name as name_rel, type from relations_wo_stations JOIN stations_rels USING (relation_id) )

		  ,station_name_point AS (
		    select
		      DISTINCT on (station_osm_type, station_osm_id)	-- we only want one entry
		      u.osm_type as station_osm_type, u.osm_id as station_osm_id, 
		      stn.osm_type as label_osm_type, stn.osm_id as label_osm_id,
		      stn.name as name, stn.point as point
		      from
			unalloc_stations u
				JOIN stop_area_members m ON (u.osm_type = 'R' AND u.osm_id = m.relation_id)
				join stations stn ON (stn.osm_id = m.member_id and stn.osm_type = m.member_type AND stn.osm_type = 'N')
			
		      )

		  ,station_platforms AS (
		  select
			  u.osm_type as station_osm_type,
			  u.osm_id as station_osm_id,
			  stp.osm_type as stop_osm_type, stp.osm_id as stop_osm_id,
			  stp.geom as geom
		from 
			unalloc_stations u
				join stop_area_members m ON (u.osm_type = 'R' AND u.osm_id = m.relation_id)
				join oepnv_stops stp ON (m.member_id = stp.osm_id and m.member_type = stp.osm_type AND m.member_role = 'platform')
		)
		  ,station_platform_hull AS ( select station_osm_type, station_osm_id, ST_Collect(geom) as geom from station_platforms group by (station_osm_type, station_osm_id) )

		  -- This is where we prepare the new row for oepnv_stations
		  ,new_data AS (
		    select
		      coalesce(unalloc_stations.name_rel, station_name_point.name) as name,
		      type,
		      coalesce(station_name_point.point, ST_Centroid(geom)) as point,
		      ST_Buffer(ST_ConvexHull(geom), 20) as area
		      from
			unalloc_stations 
			  left join station_name_point ON (unalloc_stations.osm_type = station_osm_type and unalloc_stations.osm_id = station_osm_id)
			  left join station_platform_hull h ON (unalloc_stations.osm_type = h.station_osm_type and unalloc_stations.osm_id = h.station_osm_id)
		  )


		  insert into oepnv_stations (name, type, point, area) select * from new_data
		  ;

	     ]]),

            -- Now those oepnv_stops's not in a relation. We group by nearby name
            themepark.expand_template([[
		WITH
		  stops_wo_stations AS (
			  select osm_type, osm_id
			  from
			  	oepnv_stops stp
					left join oepnv_stations stn ON (ST_Intersects(stn.area, stp.geom))
			where stn.area IS NULL
		  )

		  ,clustered_stations AS (
			  select
				name, type,
				unnest(ST_ClusterWithin(geom, 150)) as points
			  from 
			  	oepnv_stops stp JOIN stops_wo_stations USING (osm_type, osm_id)
			group by name, type
		  )

		  ,new_data AS (
		    select
		      name,
		      type,
		      ST_Centroid(points) as point,
		      ST_Buffer(ST_ConvexHull(points), 20) as area
		      from
			      clustered_stations
		      
		  )

		  insert into oepnv_stations (name, type, point, area) select * from new_data
	    
	  ]]),
        },
    })
end)
