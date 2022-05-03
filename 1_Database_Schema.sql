/* 
DATABASE SCHEMA

In this script I will show how to create sample database from scratch 
and how to modify table elements at this stage. All conception base on the
ER diagram/db model -> it was prepared on the website app.diagrams.net 

*/ 

CREATE DATABASE Cinemas

USE Cinemas
------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Cinema (

	Id INT IDENTITY PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	City VARCHAR(50) NOT NULL,
	Street VARCHAR(100),			-- in same cases the adress may be missing
	Post_Code CHAR(6),				-- constant value
	Open_Date DATE NOT NULL,		-- YYYY-MM-DD
	Close_Date DATE					-- cinema can be still open, NULL val allowed
);

------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Cinema_Room (
	Id INT IDENTITY PRIMARY KEY,
	Name VARCHAR(50) NOT NULL,
	Room_Floor VARCHAR(5),
	Screen_Quality VARCHAR(10),
	Id_Cinema INT FOREIGN KEY REFERENCES Cinema(Id)
);

------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Cinema_Seats (
	Id INT IDENTITY PRIMARY KEY,
	No_Seats VARCHAR(50),
	No_Row VARCHAR(5),
	Id_Cinema INT FOREIGN KEY REFERENCES Cinema_Room(Id)
);

------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Movie (
	Id INT IDENTITY PRIMARY KEY,
	Title VARCHAR(300) NOT NULL,
	Duration INT NOT NULL,				-- duration in min
	Release_Year CHAR(4),
	Movie_Info VARCHAR(1000),
	Language_Ver VARCHAR(2),			-- PL, ENG, ES, RU ect.
	Subtitle_PL CHAR(1),				-- Y, N, optional could be BIT
	Film_Genre VARCHAR(50) NOT NULL,	-- maybe it would be reasonable to create dict (another table) here
	Age_Limit VARCHAR(3),				-- +7,+12,+16 ect.
	Available_From DATE NOT NULL,
	Available_Until DATE NOT NULL,
	License_Cost MONEY					-- alternatively REAL
);

------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Show (
	Id INT IDENTITY PRIMARY KEY,
	--Title VARCHAR(200) NOT NULL,
	Show_Date DATE NOT NULL,
	Show_Hour TIME(0) NOT NULL,
	Ticket_Price MONEY NOT NULL,		-- there is no free shows in cinema :)
	Id_Movie INT FOREIGN KEY REFERENCES Movie(Id) NOT NULL, 
	Id_Cinema_Room INT FOREIGN KEY REFERENCES Cinema_Room(Id) NOT NULL
);

------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Client (
	Id INT IDENTITY PRIMARY KEY,
	Name VARCHAR(20) NOT NULL,
	Last_Name VARCHAR(50) NOT NULL,
	Client_Log VARCHAR(20) NOT NULL,
	Email VARCHAR(20),
	Account_Creation_Date DATETIME NOT NULL
);

------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Reservation (
	Id INT IDENTITY PRIMARY KEY,
	Reservation_Date DATE NOT NULL,
	Reservation_hour TIME(0),
	Paymeny_Check CHAR(1),						-- paid y, unpaid n
	Payment_Type VARCHAR(10),					-- internet, mobile, cinema ect.
	Id_Show INT FOREIGN KEY REFERENCES Show(Id) NOT NULL,
	Id_Cinema_Room INT FOREIGN KEY REFERENCES Cinema_Room(Id) NOT NULL,
	Id_Client INT FOREIGN KEY REFERENCES Client(Id)
);

------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
SAMPLE CHANGES:

--- drop colum & changing data type:

ALTER TABLE Show DROP COLUMN Title;			-- title in Show table is redundant // there is the same col in Movie table

ALTER TABLE Show
ALTER COLUMN Id_Movie INT NOT NULL;			-- I forgot to add NOT NULL statment

ALTER TABLE Show
ALTER COLUMN Id_Cinema_Room INT NOT NULL;	-- same as above


EXEC sp_fkeys 'Show'  --- check fk keys connected with table
USE Cinemas
DROP TABLE Show;

--- adding new column:

ALTER TABLE Client
ADD Id INT IDENTITY PRIMARY KEY;

ALTER TABLE Client
ADD Birth_Date DATE NOT NULL;

--- rename of columns:

-- Attention, the reletionship ID still will be based on previous col name!

EXEC sp_rename 'Reservation.id_seansu', 'Id_Show', 'COLUMN';
EXEC sp_rename 'Reservation.id_miejsca', 'Id_Cinema_Room', 'COLUMN';
EXEC sp_rename 'Reservation.id_klienta', 'Id_Client', 'COLUMN';
