SELECT 
    ST_Area(
        ST_Symdifference(
            geometria,
            'POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'
        )
    ) 
FROM budynki 
WHERE nazwa = 'BuildingC'