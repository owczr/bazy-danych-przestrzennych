CREATE TABLE streets_reprojected AS
SELECT 
    gid, 
    link_id, 
    st_name,
	ref_in_id,
	nref_in_id,
	func_class,
	speed_cat,
	fr_speed_l,
	to_speed_l,
	dir_travel,
    ST_Transform(geom, 'EPSG:3068') AS geom
FROM t2019_kar_streets;