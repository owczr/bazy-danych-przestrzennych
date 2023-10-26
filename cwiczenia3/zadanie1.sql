SELECT *
FROM t2018_kar_buildings AS b2019
LEFT JOIN t2019_kar_buildings AS b2018
ON b2018.geom = b2019.geom
WHERE b2018.gid IS NULL