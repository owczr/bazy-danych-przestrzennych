sudo su - postgres

shp2pgsql -I -s 4326 -W "latin1" T2018_KAR_POI_TABLE.shp t2018_kar_poi_table > T2018_KAR_POI_TABLE.sql
shp2pgsql -I -s 4326 -W "latin1" T2019_KAR_POI_TABLE.shp t2019_kar_poi_table > T2019_KAR_POI_TABLE.sql

psql -d bdp_cwiczenia3 -U postgres -f T2018_KAR_POI_TABLE.sql
psql -d bdp_cwiczenia3 -U postgres -f T2019_KAR_POI_TABLE.sql
