SELECT
    sshops.poi_name AS sport_shop_name,
    parks.name AS park_name
FROM t2019_kar_poi_table AS sshops
JOIN t2019_kar_land_use AS parks
ON ST_Intersects(sshops.geom, ST_Buffer(parks.geom, 0.003))
WHERE sshops.type = 'Sporting Goods Store';