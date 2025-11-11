-- ---------------------------------------------------------------------------
--
-- Example config for basic/generic topics
--
-- Configuration for the osm2pgsql Themepark framework
--
-- ---------------------------------------------------------------------------


local themepark = require('themepark')

themepark.debug = false

-- ---------------------------------------------------------------------------

themepark:add_topic('oepnv/oepnv_buildings')
themepark:add_topic('oepnv/oepnv_airports')
themepark:add_topic('oepnv/oepnv_places')
themepark:add_topic('oepnv/oepnv_rails')
themepark:add_topic('oepnv/oepnv_areas')
themepark:add_topic('oepnv/oepnv_ways')
themepark:add_topic('oepnv/oepnv_boundary_areas')
themepark:add_topic('oepnv/oepnv_boundary_ways')
themepark:add_topic('oepnv/oepnv_waterways')
themepark:add_topic('oepnv/oepnv_minorwaterways')
themepark:add_topic('oepnv/oepnv_lines')
themepark:add_topic('oepnv/oepnv_largeareas')
themepark:add_topic('oepnv/oepnv_verylargeareas')
themepark:add_topic('oepnv/oepnv_minorrails')
themepark:add_topic('oepnv/oepnv_line_parts')
themepark:add_topic('oepnv/oepnv_largeboundary_ways')
themepark:add_topic('oepnv/oepnv_largeways')
themepark:add_topic('oepnv/oepnv_minorways')
themepark:add_topic('oepnv/oepnv_oepnvpois')
themepark:add_topic('oepnv/oepnv_stations')
themepark:add_topic('oepnv/oepnv_stops')

--themepark:add_topic('oepnv/oepnv_majorrails') Didn't need it, just changed the style color and it works just fine








-- ---------------------------------------------------------------------------
