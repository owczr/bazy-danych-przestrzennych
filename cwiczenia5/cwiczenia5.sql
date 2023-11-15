CREATE DATABASE bdp_cwiczenia5;
CREATE EXTENSION postgis;
-- 1
CREATE TABLE obiekty(
    id INT,
    geometria GEOMETRY,
    nazwa VARCHAR(50)
);
-- 1a
INSERT INTO obiekty
VALUES (
        1,
        ST_COLLECT(
            ARRAY ['LINESTRING(0 1, 1 1)','CIRCULARSTRING(1 1, 2 0, 3 1)', 'CIRCULARSTRING(3 1, 4 2, 5 1)', 'LINESTRING(5 1, 6 1)']
        ),
        'obiekt1'
    );

-- 1b
INSERT INTO obiekty
VALUES (
        2,
        ST_COLLECT(
            ARRAY ['LINESTRING(10 6, 14 6)', 'CIRCULARSTRING(14 6, 16 4, 14 2)', 'CIRCULARSTRING(14 2, 12 0, 10 2)', 'LINESTRING(10 2, 10 16)', 'CIRCULARSTRING(11 2, 12 3, 13 2, 12 1, 11 2)']
        ),
        'obiekt2'
    )
    
 -- 1c
INSERT INTO obiekty
VALUES (
        3,
        ST_COLLECT(
            ARRAY ['LINESTRING(7 15, 10 17)', 'LINESTRING(10 17, 12 13)', 'LINESTRING(12 13, 7 15)']
        ),
        'obiekt3'
    ) 
    
-- 1c
INSERT INTO obiekty
VALUES (
        4,
        ST_COLLECT(
            ARRAY ['LINESTRING(20 20, 25 25)', 'LINESTRING(25 25, 27 24)', 'LINESTRING(27 24, 25 22)', 'LINESTRING(25 22, 26 21)', 'LINESTRING(26 21, 22 19)', 'LINESTRING(22 19, 20.5 19.5)']
        ),
        'obiekt4'
    ) 
    
-- 1d
INSERT INTO obiekty
VALUES (
        5,
        ST_COLLECT(
            ARRAY [ST_MakePoint(30, 30, 59), ST_MakePoint(38, 32, 234)]
        ),
        'obiekt5'
    )
    
-- 1e
INSERT INTO obiekty
VALUES (
        6,
        ST_COLLECT(ARRAY ['LINESTRING(1 1, 3 2)', 'POINT(4 2)']),
        'obiekt6'
    ) 

-- 2
SELECT ST_AREA(
        ST_BUFFER(ST_SHORTESTLINE(o3.geometria, o4.geometria), 5)
    ) AS pole
FROM obiekty AS o3
    CROSS JOIN obiekty AS o4
WHERE o3.id = 3
    AND o4.id = 4

-- 3
UPDATE obiekty
SET geometria = (
        SELECT ST_POLYGONIZE(
                ST_COLLECT(ARRAY [geometria, 'LINESTRING(20.5 19.5, 20 20)'])
            )
        FROM obiekty
        WHERE id = 4
    )
WHERE id = 4

-- 4
INSERT INTO obiekty
VALUES (
        7,
        (
            SELECT ST_COLLECT(o3.geometria, o4.geometria)
            FROM obiekty AS o3
                CROSS JOIN obiekty AS o4
            WHERE o3.id = 3
                AND o4.id = 4
        ),
        'obiekt7'
    ) 
    
-- 5
SELECT ST_AREA(ST_BUFFER(geometria, 5)) AS pole
FROM obiekty
WHERE NOT ST_HASARC(geometria)
