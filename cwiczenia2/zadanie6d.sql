SELECT
    nazwa,
    ST_Perimeter(geometria) AS obwod
FROM budynki
ORDER BY ST_Area(geometria) DESC LIMIT 2;