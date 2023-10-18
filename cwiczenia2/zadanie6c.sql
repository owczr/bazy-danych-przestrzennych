SELECT 
    nazwa, 
    ST_Area(geometria) AS pole
FROM budynki
WHERE ST_GeometryType(geometria) = 'ST_Polygon'
ORDER BY nazwa;