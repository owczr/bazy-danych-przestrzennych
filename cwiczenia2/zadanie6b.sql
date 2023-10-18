SELECT
    ST_AsText(geometria) AS geometry_WKT,
    ST_Area(geometria) AS area,
    ST_Perimeter(geometria) AS perimeter
FROM budynki
WHERE nazwa = 'BuildingA';
