# Cwiczenia 6

## Zadanie 1

```sql
CREATE DATABASE postgis_raster;
\c postgis_raster
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_raster;
```

```bash
pg_restore -U postgres -d postgis_raster postgis_raster.backup
```

```sql
ALTER SCHEMA schema_name RENAME TO schema_owczarek;
```
```bash
raster2pgsql -s 3763 -N -32767 -t 128x128 -I -C -M -d Landsat8_L1TP_RGBN.tif  rasters.landsat8 | psql -d postgis_raster -h localhost -U postgres -p 5432
raster2pgsql -s 3763 -N -32767 -t 100x100 -I -C -M -d srtm_1arc_v3.tif rasters.dem | psql -d postgis_raster -h localhost -U postgres -p 5432
```

## Zadanie 2
### Przklad 1
```sql
CREATE TABLE schema_owczarek.intersects AS
SELECT a.rast, b.municipality
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE ST_Intersects(a.rast, b.geom) AND b.municipality ilike 'porto';

ALTER TABLE schema_owczarek.intersects
ADD column rid SERIAL PRIMARY KEY;

CREATE INDEX idx_intersects_rast_gist ON schema_owczarek.intersects
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('schema_owczarek'::name, 'intersects'::name,'rast'::name);
```

### Przyklad 2 
```sql
CREATE TABLE schema_owczarek.clip AS
SELECT ST_Clip(a.rast, b.geom, true), b.municipality
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE ST_Intersects(a.rast, b.geom) AND b.municipality like 'PORTO';
```

### Przyklad 3
```sql
CREATE TABLE schema_owczarek.union AS
SELECT ST_Union(ST_Clip(a.rast, b.geom, true))
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast);
```

## Zadanie 3
### Przyklad 1
```sql
CREATE TABLE schema_owczarek.porto_parishes AS
WITH r AS (
    SELECT rast FROM rasters.dem
    LIMIT 1
)
SELECT ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767) AS rast
FROM vectors.porto_parishes AS a, r
WHERE a.municipality ilike 'porto';
```

### Przyklad 2
```sql
DROP TABLE schema_owczarek.porto_parishes;
CREATE TABLE schema_owczarek.porto_parishes AS
WITH r AS (
    SELECT rast FROM rasters.dem
    LIMIT 1
)
SELECT st_union(ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767)) AS rast
FROM vectors.porto_parishes AS a, r
WHERE a.municipality ilike 'porto';
```

### Przyklad 3
```sql
DROP TABLE schema_owczarek.porto_parishes; 
CREATE TABLE schema_owczarek.porto_parishes AS
WITH r AS (
    SELECT rast FROM rasters.dem
    LIMIT 1
)
SELECT st_tile(st_union(ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767)),128,128,true,-32767) AS rast
FROM vectors.porto_parishes AS a, r
WHERE a.municipality ilike 'porto';
```

## Zadanie 4
### Przyklad 1
```sql
CREATE TABLE schema_owczarek.intersection as
SELECT
    a.rid,
    (ST_Intersection(b.geom,a.rast)).geom,
    (ST_Intersection(b.geom,a.rast)).val
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);
```

### Przyklad 2
```sql
CREATE TABLE schema_owczarek.dumppolygons AS
SELECT
    a.rid,
    (ST_DumpAsPolygons(ST_Clip(a.rast,b.geom))).geom,
    (ST_DumpAsPolygons(ST_Clip(a.rast,b.geom))).val
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);
```

## Zadanie 5
### Przyklad 1
```sql
CREATE TABLE schema_owczarek.landsat_nir AS
SELECT rid, ST_Band(rast,4) AS rast
FROM rasters.landsat8;
```

### Przyklad 2
```sql
CREATE TABLE schema_owczarek.paranhos_dem AS
SELECT a.rid,ST_Clip(a.rast, b.geom,true) as rast
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);
```

### Przyklad 3
```sql
CREATE TABLE schema_owczarek.paranhos_slope AS
SELECT a.rid,ST_Slope(a.rast,1,'32BF','PERCENTAGE') as rast
FROM schema_owczarek.paranhos_dem AS a;
```

### Przyklad 4
```sql
CREATE TABLE schema_owczarek.paranhos_slope_reclass AS
SELECT a.rid,ST_Reclass(a.rast,1,']0-15]:1, (15-30]:2, (30-9999:3','32BF',0)
FROM schema_owczarek.paranhos_slope AS a;
```

### Przyklad 5
```sql
SELECT st_summarystats(a.rast) AS stats
FROM schema_owczarek.paranhos_dem AS a;
```

### Przyklad 6
```sql
SELECT st_summarystats(ST_Union(a.rast))
FROM schema_owczarek.paranhos_dem AS a;
```

### Przyklad 7
```sql
WITH t AS (
    SELECT st_summarystats(ST_Union(a.rast)) AS stats
    FROM schema_owczarek.paranhos_dem AS a
)
SELECT (stats).min,(stats).max,(stats).mean FROM t;
```

### Przyklad 8
```sql
WITH t AS (
    SELECT
        b.parish AS parish,
        st_summarystats(ST_Union(ST_Clip(a.rast,b.geom,true))) AS stats
    FROM rasters.dem AS a, vectors.porto_parishes AS b
    WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast)
    GROUP BY b.parish
)
SELECT parish,(stats).min,(stats).max,(stats).mean FROM t;
```

### Przyklad 9
```sql
SELECT b.name,st_value(a.rast,(ST_Dump(b.geom)).geom)
FROM rasters.dem a, vectors.places AS b
WHERE ST_Intersects(a.rast,b.geom)
ORDER BY b.name;
```

### Przyklad 10
```sql
CREATE TABLE schema_owczarek.tpi30 AS
SELECT ST_TPI(a.rast,1) AS rast
FROM rasters.dem a;

CREATE INDEX idx_tpi30_rast_gist ON schema_owczarek.tpi30
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('schema_owczarek'::name,
'tpi30'::name,'rast'::name);
```

## Zadanie 6
### Przyklad 1
```sql
CREATE TABLE schema_owczarek.porto_ndvi AS
WITH r AS (
    SELECT a.rid,ST_Clip(a.rast, b.geom,true) AS rast
    FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.municipality ilike 'porto' AND ST_Intersects(b.geom,a.rast)
)
SELECT
    r.rid,
    ST_MapAlgebra(
        r.rast, 1,
        r.rast, 4,
        '([rast2.val] - [rast1.val]) / ([rast2.val] + [rast1.val])::float','32BF'
    ) AS rast
FROM r;

CREATE INDEX idx_porto_ndvi_rast_gist ON schema_owczarek.porto_ndvi
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('schema_owczarek'::name, 'porto_ndvi'::name,'rast'::name);
```

### Przyklad 2
```sql
CREATE OR REPLACE FUNCTION schema_owczarek.ndvi(
value double precision [] [] [],
pos integer [][],
VARIADIC userargs text []
)
RETURNS double precision AS
$$
BEGIN
--RAISE NOTICE 'Pixel Value: %', value [1][1][1];-->For debug
purposes
RETURN (value [2][1][1] - value [1][1][1])/(value [2][1][1]+value
[1][1][1]); --> NDVI calculation!
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE COST 1000;
```
```sql
CREATE TABLE schema_owczarek.porto_ndvi2 AS
WITH r AS (
SELECT a.rid,ST_Clip(a.rast, b.geom,true) AS rast
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast)
)
SELECT
r.rid,ST_MapAlgebra(
r.rast, ARRAY[1,4],
'schema_owczarek.ndvi(double precision[],
integer[],text[])'::regprocedure, --> This is the function!
'32BF'::text
) AS rast
FROM r;

CREATE INDEX idx_porto_ndvi2_rast_gist ON schema_owczarek.porto_ndvi2
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('schema_owczarek'::name,
'porto_ndvi2'::name,'rast'::name);
```

## Zadanie 7
### Przyklad 1
```sql
SELECT ST_AsTiff(ST_Union(rast))
FROM schema_owczare.porto_ndvi;
```

### Przyklad 2
```sql
SELECT ST_AsGDALRaster(ST_Union(rast), 'GTiff', ARRAY['COMPRESS=DEFLATE',
'PREDICTOR=2', 'PZLEVEL=9'])
FROM schema_owczarek.porto_ndvi;
```

```sql
CREATE TABLE tmp_out AS
SELECT lo_from_bytea(0,
ST_AsGDALRaster(ST_Union(rast), 'GTiff', ARRAY['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9'])) AS loid
FROM schema_owczarek.porto_ndvi;

SELECT lo_export(loid, 'myraster.tiff')
FROM tmp_out;

SELECT lo_unlink(loid)
FROM tmp_out;
```

```bash
gdal_translate -co COMPRESS=DEFLATE -co PREDICTOR=2 -co ZLEVEL=9 PG:"host=localhost port=5432 dbname=postgis_raster user=postgres password=postgis schema=schema_owczarek table=porto_ndvi mode=2" porto_ndvi.tiff
```

```sql
CREATE TABLE schema_owczarek.tpi30_porto AS
SELECT ST_TPI(a.rast,1) as rast
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE ST_Intersects(a.rast, b.geom) AND b.municipality ilike 'porto'

CREATE INDEX idx_tpi30_porto_rast_gist ON schema_owczarek.tpi30_porto
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('schema_owczarek'::name,
'tpi30_porto'::name,'rast'::name);
```


