CREATE VIEW changed_buildings AS
SELECT b2019.*
FROM t2018_kar_buildings AS b2019
LEFT JOIN t2019_kar_buildings AS b2018
ON b2018.geom = b2019.geom
WHERE b2018.gid IS NULL;

SELECT poi_2019.type, COUNT(poi_2019.gid) as poi_count
FROM t2019_kar_poi_table AS poi_2019
JOIN changed_buildings AS cb
ON ST_Intersects(ST_Buffer(cb.geom, 0.005), poi_2019.geom)
GROUP BY poi_2019.type;
