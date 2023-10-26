sudo su - postgres

shp2pgsql -I -s 4326 -W "latin1" T2018_KAR_BUILDINGS.shp t2018_kar_buildings > T2018_KAR_BUILDINGS.sql
shp2pgsql -I -s 4326 -W "latin1" T2019_KAR_BUILDINGS.shp t2019_kar_buildings > T2019_KAR_BUILDINGS.sql

psql -d bdp_cwiczenia3 -U postgres -f T2018_KAR_BUILDINGS.sql
psql -d bdp_cwiczenia3 -U postgres -f T2019_KAR_BUILDINGS.sql
