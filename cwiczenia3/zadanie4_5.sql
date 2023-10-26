CREATE TABLE input_points (
    gid SERIAL PRIMARY KEY,
    geom GEOMETRY(Point, 3068)
);

INSERT INTO input_points (geom)
VALUES 
    (ST_SetSRID(ST_MakePoint(8.36093, 49.03174), 3068)),
    (ST_SetSRID(ST_MakePoint(8.39876, 49.00644), 3068));

SELECT * FROM input_points
