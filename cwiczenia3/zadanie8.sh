sudo su - postgres

shp2pgsql -I -s 4326 -W "latin1" T2018_KAR_RAILWAYS.shp t2018_kar_railways > T2018_KAR_RAILWAYS.sql
shp2pgsql -I -s 4326 -W "latin1" T2019_KAR_RAILWAYS.shp t2019_kar_railways > T2019_KAR_RAILWAYS.sql

psql -d bdp_cwiczenia3 -U postgres -f T2018_KAR_RAILWAYS.sql
psql -d bdp_cwiczenia3 -U postgres -f T2019_KAR_RAILWAYS.sql

shp2pgsql -I -s 4326 -W "latin1" T2018_KAR_WATER_LINES.shp t2018_kar_water_lines > T2018_KAR_WATER_LINES.sql
shp2pgsql -I -s 4326 -W "latin1" T2019_KAR_WATER_LINES.shp t2019_kar_water_lines > T2019_KAR_WATER_LINES.sql

psql -d bdp_cwiczenia3 -U postgres -f T2018_KAR_WATER_LINES.sql
psql -d bdp_cwiczenia3 -U postgres -f T2019_KAR_WATER_LINES.sql
