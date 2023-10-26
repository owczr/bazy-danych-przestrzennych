sudo su - postgres

shp2pgsql -I -s 4326 -W "latin1" T2018_KAR_LAND_USE.shp t2018_kar_land_use > T2018_KAR_LAND_USE.sql
shp2pgsql -I -s 4326 -W "latin1" T2019_KAR_LAND_USE.shp t2019_kar_land_use > T2019_KAR_LAND_USE.sql

psql -d bdp_cwiczenia3 -U postgres -f T2018_KAR_LAND_USE.sql
psql -d bdp_cwiczenia3 -U postgres -f T2019_KAR_LAND_USE.sql
