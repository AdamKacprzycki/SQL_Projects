/*
INSERTS:

Intro table inserts, values wil be changes with procedures later.

*/

USE Cinemas
GO

-- ################################################### CINEMA #####################################################################################

INSERT INTO Cinema(Name, City, Street, Post_Code, Open_Date, Close_Date) VALUES('Blue Diamond', 'Wroclove', 'Sucha 12', '00-001', '20200601', NULL);
INSERT INTO Cinema(Name, City, Street, Post_Code, Open_Date, Close_Date) VALUES('Jadeite', 'Warsaw', 'Ostrobramska 74', '00-002', '20210421', NULL);
INSERT INTO Cinema(Name, City, Street, Post_Code, Open_Date, Close_Date) VALUES('Emerald', 'Cracov', 'Podgorska 43', '00-003', '19010801', NULL);
INSERT INTO Cinema(Name, City, Street, Post_Code, Open_Date, Close_Date) VALUES('Blac Opal', 'Gdansk', 'Schubertta 120B', '00-004', '20190812', NULL);
INSERT INTO Cinema(Name, City, Street, Post_Code, Open_Date, Close_Date) VALUES('Red Beryl', 'Poznan', 'Boleslawa 72', '00-001', '20170507', NULL);
INSERT INTO Cinema(Name, City, Street, Post_Code, Open_Date, Close_Date) VALUES('Bixbite', 'Lodz', 'Drewnowska 57', '00-001', '20150915', NULL);
INSERT INTO Cinema(Name, City, Street, Post_Code, Open_Date, Close_Date) VALUES('Coal', 'Sopot', 'Nadmorska 101', '00-007', '20190818', NULL);

/*
-- Sample table updates:

UPDATE Cinema
SET Open_Date = '20181027',
	Close_Date = '20210421'		
	WHERE Name = 'Jadeite'

UPDATE Cinema SET Post_Code = '00-005' WHERE Name = 'Red Beryl';
UPDATE Cinema SET Post_Code = '00-006' WHERE Name = 'Bixbite'

DELETE FROM Cinema WHERE Name = 'Bixbite' AND City = 'Sopot';
DELETE FROM Cinema WHERE Id BETWEEN 8 AND 14; -- table was overwrite twice, here are sample code how to delete selected rows.
*/

-- ############################################ CINEMA_ROOM TABLE ##################################################################################

-- SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = N'Cinema_Room'

BULK INSERT Cinema_Room
	FROM   'C:\Users\Ela\Desktop\SQL_Crash_Course\Project\Cinema_Rooms.csv'
	WITH
	(
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n', 
		CODEPAGE =  'ACP' -- | 'OEM' | 'RAW' | 'code_page'  
	)

-- ################################################# CINEMA_SEATS ###########################################################################################

BULK INSERT Cinema_Seats
	FROM   'C:\Users\Ela\Desktop\SQL_Crash_Course\Project\Cinema_Seats.csv'
	WITH
	(	
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n', 
		CODEPAGE =  'ACP' -- | 'OEM' | 'RAW' | 'code_page'  
	)

-- ################################################# MOVIE ###########################################################################################

 BULK INSERT Movie
	FROM   'C:\Users\Ela\Desktop\SQL_Crash_Course\Project\Movie.csv'
	WITH
	(	
		FIELDTERMINATOR = '|',
		ROWTERMINATOR = '\n',
		CODEPAGE =  '65001' -- | 'OEM' | 'RAW' | 'code_page'  --- UTF 8 65001
	)

-- ################################################# SHOW ###########################################################################################

BULK INSERT Show
	FROM   'C:\Users\Ela\Desktop\SQL_Crash_Course\Project\Shows.csv'
	WITH
	(
		FIELDTERMINATOR = ';',
		ROWTERMINATOR = '\n', 
		CODEPAGE =  'ACP' -- | 'OEM' | 'RAW' | 'code_page'  
	)

-- ################################################# CHEKING QUERIES ###########################################################################################
/*

-- Checking if there are duplicated values:
WITH base2 AS
(SELECT Id, Id_Cinema_Room, Show_Date, COUNT(*) OVER (PARTITION BY Id_Cinema_Room, Show_Date) AS Cnt_Cinema_Room
FROM Show
)

SELECT *
FROM base2
WHERE Cnt_Cinema_Room > 1;

---- 
-- Checking unused id:

WITH base3 
AS
(SELECT DISTINCT(Id_Cinema_Room) as Dist_Id_Cin FROM Show)

SELECT Id FROM Cinema_Room AS Cr
WHERE Id not in (SELECT Dist_Id_Cin FROM base3)

SELECT * FROM Show

USE Cinemas
DROP DATABASE Cinemas
*/