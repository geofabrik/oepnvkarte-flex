-----------------------------------------------------------------------------
-- Oepnv_line_part
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max 
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

local themepark, theme, cfg = ...

themepark:add_table{
    name = 'oepnv_line_parts',
    geom = 'geometry', 
    ids_type = 'any',
    columns = themepark:columns({
        { column = 'refs', type = 'text'},
        { column = 'type', type = 'text'},

    }),
    tiles = {
        minzoom = 8,
    },
}

-- Getting the type of line
function get_typeline(object)
        --creating local variabels
        local routetag = object.tags.route
        local linetag = object.tags.line
        local typeline = nil

        if linetag=="rail" or routetag=="rail" or linetag=="train" or routetag=="train" then
            typeline = "rail"

        elseif linetag=="tram" or routetag=="tram" then
            typeline = "tram"

        elseif linetag=="light_rail" or routetag=="light_rail" then
            typeline = "light_rail"

        elseif linetag=="trolleybus" or routetag=="trolleybus" then
            typeline = "trolleybus"

        elseif linetag== "bus" or routetag== "bus" then
            typeline = "bus"

        elseif linetag=="subway" or routetag=="subway" then
            typeline = "subway"

        elseif linetag== "ferry" or routetag== "ferry" then
            typeline = "ferry"

        elseif linetag=="funicular" or routetag=="funicular" then
            typeline = "funicular"

        elseif linetag=="monorail" or routetag=="monorail" then
            typeline = "monorail"

        end

         return typeline
    
end

-- Deduplicate existing data
function deduplicate(list)
    -- Creating local variabels
    local seen = {}  
    local result = {}  
    
    for _, value in ipairs(list) do
        if not seen[value] then  -- If the string hasn't been encountered
            seen[value] = true  
            table.insert(result, value)  
        end
    end
    
    return result
end

    



-----------------------------------------------------------------------------
-- Creating an empty local variable
local refs = {}

themepark:add_proc('way', function(object, data)
    if osm2pgsql.stage == 1 then -- Skipping over first stage ending this proc making it available for stage 2
        return
    end

    local info = refs[object.id]
    if not info then
        return
    end

    for mytype, myrefs in pairs(info) do
        themepark:insert('oepnv_line_parts', {

            geom = object:as_multilinestring(),
            type = mytype,
            refs = table.concat(deduplicate(myrefs), ',') 

        })
    end
end)

themepark:add_proc('select_relation_members', function(relation) -- Getting all the ways that are part of a relation
    if get_typeline(relation) then
        return { ways = osm2pgsql.way_member_ids(relation) }
    end
end)

themepark:add_proc('relation', function(object) -- Records the ways that are in the relations that are important this happens in stage 1
    local typeline = get_typeline(object)
    if typeline then

        for _, member in ipairs(object.members) do -- Here a variable is created that consists of relations where ways are part of the relation 
            if member.type == 'w' then
                if not refs[member.ref] then
                    refs[member.ref] = { } 

                end
                local mytype= get_typeline(object) -- Here those relations get filtered out
                if not refs[member.ref][mytype] then
                    refs[member.ref] [mytype]=  { } 
                end
                table.insert(refs[member.ref][mytype], object.tags.ref) -- Here it gets inserted in the table
            end
        end
        
    end
end)




