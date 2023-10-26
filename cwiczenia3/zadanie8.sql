CREATE TABLE T2019_KAR_BRIDGES AS
SELECT
    r.gid AS railway_gid,
    w.gid AS water_line_gid,
    ST_Intersection(r.geom, w.geom) AS intersection_geom
FROM
    t2019_kar_railways AS r,
    t2019_kar_water_lines AS w
WHERE
    ST_Intersects(r.geom, w.geom);