-----------------------------------------------------------------------------
-- Oepnv_stations
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

local themepark, theme, cfg = ...

themepark:add_table({
    name = "oepnv_stations",
    geom = "geometry",
    ids_type = "any",
    columns = themepark:columns({
        { column = "name", type = "text" },
        { column = "type", type = "text" },
        { column = "lines_count", type = "smallint" },
        { column = "stops", type = "bigint" },
        { column = "point", type = "point" },
        { column = "area", type = "geometry" },
    }),
    tiles = {
        minzoom = 8,
    },
})

themepark:add_table({
    name = "oepnv_stop_area_platforms",
    ids_type = "any",
    columns = themepark:columns({
        { column = "member_type", type = "text", sql_type = "character(1)", not_null = true },
        { column = "member_id", type = "bigint", not_null = true },
    }),
    indexes = {
        { method = "btree", column = { "member_type", "member_id" } },
    },
    tiles = {
        minzoom = 8,
    },
})

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

themepark:add_proc("relation", function(object)
    local geom = object:as_geometrycollection()
    local platform, stop_position, transptype = get_transptypestation(object)
    if transptype then
        themepark:insert("oepnv_stations", {

            geom = geom,
            name = object.tags["name"],
            type = transptype,
            stops = stop_position,
            point = geom:centroid(),
            area = nil,
        })

        if object.tags.public_transport == "stop_area" then
            for _, member in ipairs(object.members) do
                if member.role == "platform" then
                    themepark:insert("oepnv_stop_area_platforms", {
                        member_type = string.upper(member.type),
                        member_id = member.ref,
                    })
                end
            end
        end
    end
end)

-- Creating a buffer around the stations and stops
themepark:add_proc("gen", function(data)
    osm2pgsql.run_sql({
        description = "Create a buffer around points",
        transaction = true,
        sql = {
            -- First every thing that's in a relation
            themepark.expand_template([[
		WITH clustered_points as (
		select
			stn.osm_id as osm_id, stn.osm_type as osm_type,
			unnest(ST_ClusterWithin(stp.geom, 150)) as geom
		FROM
			{prefix}oepnv_stops stp
			JOIN (
				{prefix}oepnv_stop_area_platforms c
				JOIN {prefix}oepnv_stations stn ON stn.osm_id = c.osm_id AND stn.osm_type=c.osm_type
				)
				ON stp.osm_id=c.member_id AND stp.osm_type=c.member_type
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
	 ]]),
            -- Then things that aren't in a relation, but grouped by name & location
            themepark.expand_template([[
		WITH clustered_points as (
		select
			stp.name as name, stp.type as type,
			unnest(ST_ClusterWithin(stp.geom, 150)) as geom
		FROM
			{prefix}oepnv_stops stp
			LEFT JOIN {prefix}oepnv_stop_area_platforms c
			ON stp.osm_id=c.member_id AND stp.osm_type=c.member_type
		WHERE c.osm_id IS NULL
		GROUP BY stp.name, stp.type
		)

	INSERT INTO {prefix}oepnv_stations
		(osm_type, osm_id, name, type, point, area, geom)
	select
		'X' as osm_type, 0 as osm_id,
		name, type,
		ST_Centroid(clustered_points.geom) as point,
		st_buffer(st_convexhull(clustered_points.geom),20) as area,
		'GEOMETRYCOLLECTION EMPTY'::geometry as geom
	from clustered_points

	 ]]),
        },
    })
end)
