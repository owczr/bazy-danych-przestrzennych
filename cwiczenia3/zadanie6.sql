CREATE TABLE streets_node_2019_reprojected AS
SELECT
	gid,
	node_id,
	link_id,
	point_num,
	z_level,
	'intersect',
	lat,
	lon,
    ST_Transform(geom, 3068) AS geom
FROM t2019_kar_street_node;

CREATE VIEW line_points AS
SELECT st_makeline(geom) AS geom
FROM input_points;

SELECT * FROM line_points;

SELECT DISTINCT node_id
FROM line_points AS l, streets_node_2019_reprojected AS n
WHERE st_contains(st_buffer(l.geom, 0.002), n.geom)
