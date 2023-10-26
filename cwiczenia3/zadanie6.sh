sudo su - postgres

shp2pgsql -I -s 4326 -W "latin1" T2018_KAR_STREET_NODE.shp t2018_kar_street_node > T2018_KAR_STREET_NODE.sql
shp2pgsql -I -s 4326 -W "latin1" T2019_KAR_STREET_NODE.shp t2019_kar_street_node > T2019_KAR_STREET_NODE.sql

psql -d bdp_cwiczenia3 -U postgres -f T2018_KAR_STREET_NODE.sql
psql -d bdp_cwiczenia3 -U postgres -f T2019_KAR_STREET_NODE.sql
