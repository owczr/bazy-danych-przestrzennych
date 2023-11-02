
shp2pgsql -I -s 4326 -W "latin1"  cwiczenia4/qgis_sample_data/shapefiles/trees.shp trees > trees.sql
shp2pgsql -I -s 4326 -W "latin1"  cwiczenia4/qgis_sample_data/shapefiles/railroads.shp railroads > railroads.sql
shp2pgsql -I -s 4326 -W "latin1"  cwiczenia4/qgis_sample_data/shapefiles/regions.shp regions > regions.sql
shp2pgsql -I -s 4326 -W "latin1"  cwiczenia4/qgis_sample_data/shapefiles/airports.shp airports > airports.sql
shp2pgsql -I -s 4326 -W "latin1"  cwiczenia4/qgis_sample_data/shapefiles/popp.shp popp > popp.sql
shp2pgsql -I -s 4326 -W "latin1"  cwiczenia4/qgis_sample_data/shapefiles/rivers.shp rivers > rivers.sql
shp2pgsql -I -s 4326 -W "latin1"  cwiczenia4/qgis_sample_data/shapefiles/majrivers.shp majrivers > majrivers.sql
shp2pgsql -I -s 4326 -W "latin1"  cwiczenia4/qgis_sample_data/shapefiles/swamp.shp swamp > swamp.sql

for sql in *.sql; do psql -d bdp_cwiczenia4 -U postgres -f "$sql"; done

