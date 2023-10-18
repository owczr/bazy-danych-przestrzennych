SELECT *
FROM budynki
WHERE ST_Y(ST_Centroid(budynki.geometria)) > (
    SELECT ST_Y(ST_Centroid(geometria))
    FROM drogi
    WHERE nazwa = 'RoadX'
);