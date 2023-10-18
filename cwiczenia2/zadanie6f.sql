SELECT 
    ST_Area(ST_Difference(bC.geometria, ST_Buffer(bB.geometria, 0.5))) 
FROM budynki AS bC, budynki AS bB 
WHERE bC.nazwa = 'BuildingC' AND bB.nazwa = 'BuildingB';