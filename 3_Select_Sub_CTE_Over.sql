USE Cinemas
GO

-- SAMPLE SELECTS: 

-- 
SELECT Ci.Name, Screen_Quality, COUNT(Screen_Quality) AS No_of_screens
	FROM Cinema_Room AS Cr 
	INNER JOIN Cinema AS Ci
	ON Cr.Id_Cinema = Ci.Id
GROUP BY Screen_Quality, Ci.Name

SELECT Title, DATEDIFF(MONTH, Available_From, Available_Until) as Avaiable_Months 
FROM Movie
WHERE DATEDIFF(MONTH, Available_From, Available_Until) BETWEEN 12 AND 24;


SELECT Show_Date, COUNT(*) AS No_movie
FROM Show
GROUP BY Show_Date
ORDER BY Show_Date;


SELECT * FROM Show 
WHERE Id_movie IN (
					SELECT Id FROM movie 
					WHERE Title like '%odz%' 
					OR Title like '%mila%')

SELECT Title FROM Movie 
WHERE Id IN (
			 SELECT Id_Movie FROM Show 
			 WHERE Show_Date = '20210508')


SELECT Title, cm.Name, cr.Name, shw.Show_Hour
FROM Show as shw 
	INNER JOIN Movie as mv 
	ON shw.Id_Movie = mv.Id
	INNER JOIN Cinema_Room as cr
	ON shw.Id_Cinema_Room = cr.Id
	INNER JOIN Cinema as cm
	ON cr.Id_Cinema = cm.Id
WHERE Title LIKE '%od%';


SELECT Title, License_Cost
		FROM Movie
		ORDER BY License_Cost DESC;

SELECT Title, License_Cost,
		RANK() OVER(ORDER BY License_Cost DESC) AS Cost_Rank
		from movie

SELECT Title, License_Cost,
		ROW_NUMBER() OVER(ORDER BY License_Cost DESC) AS Cost_Rank
		from movie

		SELECT Title, cm.Name, cr.Name, shw.Show_Hour

SELECT cm.Name, title, mv.License_Cost,
	DENSE_RANK() OVER(PARTITION BY cm.Name ORDER BY mv.License_Cost DESC) as Lic_Rank
FROM Show as shw 
	INNER JOIN Movie as mv 
	ON shw.Id_Movie = mv.Id
	INNER JOIN Cinema_Room as cr
	ON shw.Id_Cinema_Room = cr.Id
	INNER JOIN Cinema as cm
	ON cr.Id_Cinema = cm.Id
GROUP BY cm.Name, title, mv.License_Cost;

SELECT cm.Name, title, mv.License_Cost,
	DENSE_RANK() OVER(PARTITION BY cm.Name ORDER BY mv.License_Cost DESC) as Lic_Rank
FROM Show as shw 
	INNER JOIN Movie as mv 
	ON shw.Id_Movie = mv.Id
	INNER JOIN Cinema_Room as cr
	ON shw.Id_Cinema_Room = cr.Id
	INNER JOIN Cinema as cm
	ON cr.Id_Cinema = cm.Id
GROUP BY cm.Name, title, mv.License_Cost;


WITH base1 AS(
	SELECT cm.Name, Title, mv.License_Cost,
		DENSE_RANK() OVER(PARTITION BY cm.Name ORDER BY mv.License_Cost DESC) as Lic_Rank
	FROM Show as shw 
		INNER JOIN Movie as mv 
		ON shw.Id_Movie = mv.Id
		INNER JOIN Cinema_Room as cr
		ON shw.Id_Cinema_Room = cr.Id
		INNER JOIN Cinema as cm
		ON cr.Id_Cinema = cm.Id
	GROUP BY cm.Name, title, mv.License_Cost
	)

SELECT * FROM base1 WHERE Lic_Rank <= 3
