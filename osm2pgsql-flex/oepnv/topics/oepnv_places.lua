-----------------------------------------------------------------------------
-- Oepnv_places
-- Owner: Geofabrik GmbH
-- Date created: 20-01-25
-- Author: Max 
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


local themepark, theme, cfg = ...

themepark:add_table{
    name = 'oepnv_places',
    geom = 'point', 
    ids_type = 'any',
    columns = themepark:columns({
        { column = 'name', type = 'text'},
        { column = 'population', type = 'smallint'},
        { column = 'type', type = 'text'},

    }),
    tiles = {
        minzoom = 8,
    },
}

-- Get the type of place
function get_places(object)
    
    local placestag = object.tags.place
    local placestype = nil

    if placestag== "hamlet" then
        placestype = "hamlet"

    elseif placestag== "village" then
        placestype = "village"

    elseif placestag== "city" then
        placestype = "city"

    elseif placestag== "town" then
        placestype = "town"

    elseif placestag== "region" then
        placestype = "region"

    elseif placestag== "suburb" then
        placestype = "suburb"

    elseif placestag== "state" then
        placestype = "state"

    elseif placestag== "country" then
        placestype = "country"

    elseif placestag== "continent" then
        placestype = "continent"

    elseif placestag== "locality" then
        placestype = "locality"
    end

   return placestype

end

-----------------------------------------------------------------------------


themepark:add_proc('node', function(object)
    local placestype = get_places(object)
    if placestype  then

        themepark:insert('oepnv_places', {

            name = object.tags['name'],
            geom = object:as_point(),
            population = object.tags.population or "0",
            type = placestype

            })
    end
end) 

