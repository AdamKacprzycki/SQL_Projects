-- CREATE VIEW--

CREATE VIEW summary_view AS
SELECT shw.Show_Date, shw.Show_Hour, shw.Ticket_Price, mv.Title, mv.Duration, mv.Release_Year, cr.Name as Cinema_Room, cin.Name as Cinema, cin.City
FROM Show as shw
LEFT JOIN Movie AS mv ON shw.Id_Movie = mv.Id
LEFT JOIN Cinema_Room AS cr ON shw.Id_Cinema_Room = cr.Id
LEFT JOIN Cinema AS cin ON cr.Id_Cinema = cin.Id

SELECT * FROM summary_view WHERE Show_Date = '20210508'