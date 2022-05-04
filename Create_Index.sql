USE Cinemas
GO

SET STATISTICS TIME ON -- feature to asses execution time

------------------------------------------------------------------------------------------------------------------------------------------------------------
-- sample queries of full table scan:

SELECT Title 
FROM Movie 
WHERE Release_Year = '2019'

--  SQL Server Execution Times: CPU time = 188 ms,  elapsed time = 295 ms.
--  Estimated Execution Plan info: CPU Cost 1,1 unit, Rows to be read = all (full scan)

------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Creating index on column used in WHERE clause:

CREATE INDEX Movie_Release_Year_idx ON Movie(Release_Year)

SELECT Title 
FROM Movie 
WHERE Release_Year = '2019'

-- Unfortunatelly, time of execution is almost the same:
--  SQL Server Execution Times: CPU time = 172 ms,  elapsed time = 288 ms.
--  Estimated Execution Plan info: CPU Cost 1,1 unit, Rows to be read = all (full scan), hovewer
--  there are information about, adding to the index Title column (INCLUDE ([Title])) - I will try it in nex step

------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Expanded analysis of Execution Plan and adding additional column to index:

CREATE NONCLUSTERED INDEX [Mov_Rel_Title_idx]
ON [dbo].[Movie] ([Release_Year])
INCLUDE ([Title])

SELECT Title 
FROM Movie 
WHERE Release_Year = '2019'

-- Finally we achived the expected results!:
-- SQL Server Execution Times: CPU time = 0 ms,  elapsed time = 204 ms.
-- Estimated Execution Plan info: CPU Cost 0,41 unit, Rows to be read = around 17000 (huge change)

-- There is no reason to use initial index >> Movie_Release_Year_idx:

DROP INDEX Movie_Release_Year_idx ON Movie

------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
-- Import new data from CSV file (over 1 mln recodrs)

BULK INSERT Movie
	FROM   'C:\Users\Ela\Desktop\SQL_Crash_Course\Strefa_kursów_SQL\Movie_Generator.csv'
	WITH
	(	
		FIELDTERMINATOR = ';',
		ROWTERMINATOR = '\n',
		CODEPAGE =  '65001' -- | 'OEM' | 'RAW' | 'code_page'  --- UTF 8 65001
		)

-- Delete duplicated values:

WITH base3 AS(
	SELECT *, 
	ROW_NUMBER() OVER(PARTITION BY Title ORDER BY Id) AS DuplicateCount
	FROM Movie)

DELETE FROM Movie
WHERE Movie.Id IN (SELECT Id FROM base3 WHERE  DuplicateCount > 1)

-- Change char values as needed:

UPDATE Movie
SET
	Film_Genre = 'AKCJA'
WHERE 
	Film_Genre LIKE 'AKCJI'

*/