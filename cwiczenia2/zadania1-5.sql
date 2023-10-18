CREATE DATABASE cwiczenia2;

CREATE EXTENSION postgis;

CREATE TABLE budynki (
    id INT,
    geometria GEOMETRY,
    nazwa VARCHAR
);

CREATE TABLE drogi (
    id INT,
    geometria GEOMETRY,
    nazwa VARCHAR
);

CREATE TABLE punkty_informacyjne (
    id INT,
    geometria GEOMETRY,
    nazwa VARCHAR
);

INSERT INTO budynki VALUES
    (1, 'POLYGON((8 1.5, 10.5 1.5, 10.5 4, 8  4, 8 1.5))', 'BuildingA'),
    (2, 'POLYGON((4 5, 6 5, 6 7, 4 7, 4 5))', 'BuildingB'),
    (3, 'POLYGON((3 6, 5 6, 5 8, 3 8, 3 6))', 'BuildingC'),
    (4, 'POLYGON((9 8, 10 8, 10 9, 9 9, 9 8))', 'BuildingD'),
    (5, 'POLYGON((1 1, 2 1, 2 2, 1 2, 1 1))', 'BuildingF');

INSERT INTO drogi VALUES
    (1,'LINESTRING(0 4.5,12 4.5)','RoadX'),
	(2,'LINESTRING(7.5 0,7.5 10.5)','RoadY');

INSERT INTO punkty_informacyjne VALUES
    (1,'POINT(1 3.5)','G'),
	(2,'POINT(5.5 1.5)','H'),
	(3,'POINT(9.5 6)','I'),
	(4,'POINT(6.5 6)','J'),
	(5,'POINT(6 9.5)','K');

