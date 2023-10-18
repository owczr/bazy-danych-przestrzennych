SELECT
    ST_Distance(
        budynki.geometria, punkty_informacyjne.geometria
    ) AS najkrotsza_odleglosc
FROM budynki
CROSS JOIN punkty_informacyjne
WHERE budynki.nazwa = 'BuildingC' AND punkty_informacyjne.nazwa = 'K';