sudo su - postgres

shp2pgsql -I -s 4326 -W "latin1" T2019_KAR_STREETS.shp t2019_kar_streets > T2019_KAR_STREETS.sql

psql -d bdp_cwiczenia3 -U postgres -f T2019_KAR_STREETS.sql
