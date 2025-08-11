--Drop Database cm_database_proj;
--Create Database cm_database_proj;
Use cm_database_proj;


--Drop Table If Exists Feedback, OrderDetail, Ticket, [Order], Booking, Show, Staff, Seat, StaffShift, FoodItem, Customer, Hall, Movie;


Create Table Movie (
    MovieID Int Primary Key Identity(1,1),
    Title Varchar(100) Unique,
    Genre Varchar(50),
    Duration Int,
    Language Varchar(20),
    Rating Int Check (Rating Between 1 And 5),
    ReleaseDate Date
);

Create Table Hall (
    HallID Int Primary Key Identity(1,1),
    HallName Varchar(50),
    SeatingCapacity Int,
    ScreenType Varchar(10),
    FloorNumber Int Check (FloorNumber In (1, 2))
);

Create Table Customer (
    CustomerID Int Primary Key Identity(1,1),
    FullName Varchar(100) Unique,
    Email Varchar(100),
    Phone Varchar(20),
    Gender Varchar(10)
);

Create Table FoodItem (
    FoodItemID Int Primary Key Identity(1,1),
    ItemName Varchar(100),
    Price Decimal(10,2),
    Category Varchar(20) Check (Category In ('Snack', 'Drink', 'Beverage', 'Dessert', 'Candy', 'Meal')),
    IsAvailable varchar(20)
);

Create Table StaffShift (
    ShiftID Int Primary Key Identity(1,1),
    ShiftName Varchar(20),
    StartTime Time,
    EndTime Time,
    DateAssigned Date
);

Create Table Seat (
    SeatID Int Primary Key,
    HallID Int Foreign Key References Hall(HallID),
    SeatNumber Varchar(10),
    SeatType Varchar(20),
    Status Varchar(20) DEFAULT 'Available' Check (Status In ('Available', 'Booked'))
);

Create Table Staff (
    StaffID Int Primary Key Identity(1,1),
    Name Varchar(100),
    Role Varchar(50),
    ShiftID Int Foreign Key References StaffShift(ShiftID),
    HallID Int Foreign Key References Hall(HallID),
    Phone Varchar(20)
);

Create Table Show (
    ShowID Int Primary Key,
    MovieID Int Foreign Key References Movie(MovieID),
    HallID Int Foreign Key References Hall(HallID),
    ShowDate Date,
    StartTime Time,
    EndTime Time,
    TicketSold Int
);


Create Table Booking (
    BookingID Int Primary Key Identity(1,1),
    CustomerID Int Foreign Key References Customer(CustomerID),
    BookingDate Date,
    TotalAmount Decimal(10,2),
    PaymentMethod Varchar(10) Check (PaymentMethod In ('Cash', 'Card')),
    PaymentDate Date
);

Create Table [Order] (
    OrderID Int Primary Key Identity(1,1),
    CustomerID Int Foreign Key References Customer(CustomerID),
    OrderDate Date,
    PaymentMethod Varchar(10)
);

Create Table Ticket (
    TicketID Int Primary Key Identity(1,1),
    BookingID Int Foreign Key References Booking(BookingID),
    ShowID Int Foreign Key References Show(ShowID),
    SeatID Int Foreign Key References Seat(SeatID),
    Price Decimal(10,2)
);

Create Table OrderDetail (
    OrderDetailID Int Primary Key Identity(1,1),
    OrderID Int Foreign Key References [Order](OrderID),
    FoodItemID Int Foreign Key References FoodItem(FoodItemID),
    Quantity Int
);

Create Table Feedback (
    FeedbackID Int Primary Key Identity(1,1),
    CustomerID Int Foreign Key References Customer(CustomerID),
    MovieID Int Foreign Key References Movie(MovieID),
    Rating DECIMAL(2,1) CHECK (Rating BETWEEN 1.0 AND 5.0),
    Comments Varchar(500)
);


ALTER TABLE Ticket
ADD CONSTRAINT UQ_Ticket_ShowID_SeatID UNIQUE (ShowID, SeatID);

-- CHECK TOTAL ENTRIES OF DATABASE
/*
WITH TableCounts AS (SELECT 'Movie' AS TableName, COUNT(*) AS TotalRows FROM Movie
    UNION ALL
    SELECT 'Hall', COUNT(*) FROM Hall
    UNION ALL
    SELECT 'Customer', COUNT(*) FROM Customer
    UNION ALL
    SELECT 'FoodItem', COUNT(*) FROM FoodItem
    UNION ALL
    SELECT 'StaffShift', COUNT(*) FROM StaffShift
    UNION ALL
    SELECT 'Seat', COUNT(*) FROM Seat
    UNION ALL
    SELECT 'Staff', COUNT(*) FROM Staff
    UNION ALL
    SELECT 'Show', COUNT(*) FROM Show
    UNION ALL
    SELECT 'Booking', COUNT(*) FROM Booking
    UNION ALL
    SELECT '[Order]', COUNT(*) FROM [Order]
    UNION ALL
    SELECT 'Ticket', COUNT(*) FROM Ticket
    UNION ALL
    SELECT 'OrderDetail', COUNT(*) FROM OrderDetail
    UNION ALL
    SELECT 'Feedback', COUNT(*) FROM Feedback
)
SELECT * FROM TableCounts
UNION ALL
SELECT 'Total' AS TableName, SUM(TotalRows) FROM TableCounts;

*/
-- FOR HALL TABLE (6)


Insert Into Hall (HallName, FloorNumber) Values
('Alpha', 1),
('Beta', 1),
('Gamma', 1),
('Sigma', 2),
('Delta', 2),
('Omega', 2);

-- Floor 1 halls get 100 seats
Update Hall
Set SeatingCapacity = 100
Where FloorNumber = 1;

-- Floor 2 halls get 200 seats
Update Hall
Set SeatingCapacity = 200
Where FloorNumber = 2;

-- Floor 1 halls are 2D
Update Hall
Set ScreenType = '2D'
Where FloorNumber = 1;

-- Floor 2 halls are 3D
Update Hall
Set ScreenType = '3D'
Where FloorNumber = 2;

-- FOR FoodItemTABLE (11)

-- Snacks
Insert Into FoodItem (ItemName, Price, Category, IsAvailable) Values
('Popcorn', 200.00, 'Snack', 'Yes'),
('Biscuits', 40.00, 'Snack', 'Yes'),
('Chips', 100.00, 'Snack', 'Yes');

-- Beverages
Insert Into FoodItem (ItemName, Price, Category, IsAvailable) Values
('Coca-Cola', 120.00, 'Beverage', 'Yes'),
('Sprite', 120.00, 'Beverage', 'Yes'),
('Water', 60.00, 'Beverage', 'Yes'),
('Coffee', 300.00, 'Beverage', 'Yes');

-- Dessert
Insert Into FoodItem (ItemName, Price, Category, IsAvailable) Values
('Ice Cream', 300.00, 'Dessert', 'Yes');

-- Candy
Insert Into FoodItem (ItemName, Price, Category, IsAvailable) Values
('Chocolate Bar', 100.00, 'Candy', 'Yes');

-- Meal
Insert Into FoodItem (ItemName, Price, Category, IsAvailable) Values
('Pizza Slice', 180.00, 'Meal', 'Yes'),
('Special Pizza Slice', 380.00, 'Meal', 'No');




--  FOR MOVIE TABLE (100)

Insert Into Movie (Title, Genre, Duration, Language, Rating, ReleaseDate) Values
('Harry Potter and the Sorcerer Stone', 'Fantasy', 152, 'English', 5, '2001-11-16'),
('Harry Potter and the Chamber of Secrets', 'Fantasy', 161, 'English', 5, '2002-11-15'),
('Harry Potter and the Prisoner of Azkaban', 'Fantasy', 142, 'English', 5, '2004-06-04'),
('Harry Potter and the Goblet of Fire', 'Fantasy', 157, 'English', 5, '2005-11-18'),
('Harry Potter and the Order of the Phoenix', 'Fantasy', 138, 'English', 5, '2007-07-11'),
('Harry Potter and the Half-Blood Prince', 'Fantasy', 153, 'English', 5, '2009-07-15'),
('Harry Potter and the Deathly Hallows: Part 1', 'Fantasy', 146, 'English', 5, '2010-11-19'),
('Harry Potter and the Deathly Hallows: Part 2', 'Fantasy', 130, 'English', 5, '2011-07-15'),

('Mission: Impossible', 'Action', 110, 'English', 4, '1996-05-22'),
('Mission: Impossible 2', 'Action', 123, 'English', 4, '2000-05-24'),
('Mission: Impossible III', 'Action', 126, 'English', 4, '2006-05-05'),
('Mission: Impossible – Ghost Protocol', 'Action', 132, 'English', 5, '2011-12-16'),
('Mission: Impossible – Rogue Nation', 'Action', 131, 'English', 5, '2015-07-31'),
('Mission: Impossible – Fallout', 'Action', 147, 'English', 5, '2018-07-27'),
('Mission: Impossible – Dead Reckoning Part One', 'Action', 163, 'English', 4, '2023-07-12'),

('The Lord of the Rings: The Fellowship of the Ring', 'Fantasy', 168, 'English', 5, '2001-12-19'),
('The Lord of the Rings: The Two Towers', 'Fantasy', 169, 'English', 5, '2002-12-18'),
('The Lord of the Rings: The Return of the King', 'Fantasy', 165, 'English', 5, '2003-12-17'),

('The Hobbit: An Unexpected Journey', 'Fantasy', 169, 'English', 4, '2012-12-14'),
('The Hobbit: The Desolation of Smaug', 'Fantasy', 161, 'English', 4, '2013-12-13'),
('The Hobbit: The Battle of the Five Armies', 'Fantasy', 144, 'English', 4, '2014-12-17'),

('Iron Man', 'Action', 126, 'English', 5, '2008-05-02'),
('Iron Man 2', 'Action', 124, 'English', 4, '2010-05-07'),
('Iron Man 3', 'Action', 130, 'English', 4, '2013-05-03'),

('Captain America: The First Avenger', 'Action', 124, 'English', 4, '2011-07-22'),
('Captain America: The Winter Soldier', 'Action', 136, 'English', 5, '2014-04-04'),
('Captain America: Civil War', 'Action', 147, 'English', 5, '2016-05-06'),

('Avengers: Assemble', 'Action', 143, 'English', 5, '2012-05-04'),
('Avengers: Age of Ultron', 'Action', 141, 'English', 4, '2015-05-01'),
('Avengers: Infinity War', 'Action', 149, 'English', 5, '2018-04-27'),
('Avengers: Endgame', 'Action', 170, 'English', 5, '2019-04-26'),

('Thor', 'Action', 115, 'English', 4, '2011-05-06'),
('Thor: The Dark World', 'Action', 112, 'English', 4, '2013-11-08'),
('Thor: Ragnarok', 'Action', 130, 'English', 5, '2017-11-03'),
('Thor: Love and Thunder', 'Action', 119, 'English', 3, '2022-07-08'),

('Spider-Man', 'Action', 121, 'English', 4, '2002-05-03'),
('Spider-Man 2', 'Action', 127, 'English', 5, '2004-06-30'),
('Spider-Man 3', 'Action', 139, 'English', 3, '2007-05-04'),
('The Amazing Spider-Man', 'Action', 136, 'English', 4, '2012-07-03'),
('The Amazing Spider-Man 2', 'Action', 142, 'English', 3, '2014-05-02'),
('Spider-Man: Homecoming', 'Action', 133, 'English', 5, '2017-07-07'),
('Spider-Man: Far From Home', 'Action', 129, 'English', 4, '2019-07-02'),
('Spider-Man: No Way Home', 'Action', 148, 'English', 5, '2021-12-17'),

('Black Panther', 'Action', 134, 'English', 5, '2018-02-16'),
('Doctor Strange', 'Action', 115, 'English', 4, '2016-11-04'),
('Doctor Strange in the Multiverse of Madness', 'Action', 126, 'English', 4, '2022-05-06'),
('Ant-Man', 'Action', 117, 'English', 4, '2015-07-17'),
('Ant-Man and the Wasp', 'Action', 118, 'English', 4, '2018-07-06'),

('Guardians of the Galaxy', 'Sci-Fi', 121, 'English', 5, '2014-08-01'),
('Guardians of the Galaxy Vol. 2', 'Sci-Fi', 136, 'English', 5, '2017-05-05'),
('Guardians of the Galaxy Vol. 3', 'Sci-Fi', 150, 'English', 5, '2023-05-05'),

('Captain Marvel', 'Action', 123, 'English', 4, '2019-03-08'),
('Eternals', 'Action', 157, 'English', 3, '2021-11-05'),
('Shang-Chi and the Legend of the Ten Rings', 'Action', 132, 'English', 5, '2021-09-03'),

('Black Widow', 'Action', 134, 'English', 4, '2021-07-09'),
('The Marvels', 'Action', 105, 'English', 3, '2023-11-10'),

('Titanic', 'Romance', 172, 'English', 5, '1997-12-19'),
('Avatar', 'Sci-Fi', 162, 'English', 5, '2009-12-18'),
('Avatar: The Way of Water', 'Sci-Fi', 170, 'English', 5, '2022-12-16'),

('Inception', 'Sci-Fi', 148, 'English', 5, '2010-07-16'),
('Interstellar', 'Sci-Fi', 169, 'English', 5, '2014-11-07'),
('The Prestige', 'Drama', 130, 'English', 5, '2006-10-20'),
('Dunkirk', 'War', 106, 'English', 4, '2017-07-21'),
('Tenet', 'Sci-Fi', 150, 'English', 4, '2020-08-26'),

('The Batman', 'Action', 166, 'English', 5, '2022-03-04'),
('The Dark Knight', 'Action', 152, 'English', 5, '2008-07-18'),
('The Dark Knight Rises', 'Action', 165, 'English', 5, '2012-07-20'),
('Batman Begins', 'Action', 140, 'English', 5, '2005-06-15'),

('Frozen', 'Animation', 102, 'English', 5, '2013-11-27'),
('Frozen II', 'Animation', 103, 'English', 4, '2019-11-22'),
('Zootopia', 'Animation', 108, 'English', 5, '2016-03-04'),
('Moana', 'Animation', 107, 'English', 5, '2016-11-23'),
('Encanto', 'Animation', 102, 'English', 5, '2021-11-24'),
('Coco', 'Animation', 105, 'English', 5, '2017-11-22'),
('Toy Story 3', 'Animation', 103, 'English', 5, '2010-06-18'),
('Inside Out', 'Animation', 95, 'English', 5, '2015-06-19'),
('Finding Nemo', 'Animation', 100, 'English', 5, '2003-05-30'),
('Despicable Me', 'Animation', 95, 'English', 4, '2010-07-09');

Insert Into Movie (Title, Genre, Duration, Language, Rating, ReleaseDate) Values
('The Matrix', 'Sci-Fi', 136, 'English', 5, '1999-03-31'),
('The Matrix Reloaded', 'Sci-Fi', 138, 'English', 4, '2003-05-15'),
('The Matrix Revolutions', 'Sci-Fi', 129, 'English', 3, '2003-11-05'),
('The Matrix Resurrections', 'Sci-Fi', 148, 'English', 3, '2021-12-22'),

('The Lion King', 'Animation', 88, 'English', 5, '1994-06-24'),
('Ratatouille', 'Animation', 111, 'English', 5, '2007-06-29'),
('Brave', 'Animation', 93, 'English', 4, '2012-06-22'),
('Big Hero 6', 'Animation', 102, 'English', 5, '2014-11-07'),

('Up', 'Animation', 96, 'English', 5, '2009-05-29'),
('Luca', 'Animation', 95, 'English', 4, '2021-06-18'),
('Soul', 'Animation', 100, 'English', 5, '2020-12-25'),
('Turning Red', 'Animation', 100, 'English', 4, '2022-03-11'),

('The Hunger Games', 'Action', 142, 'English', 4, '2012-03-23'),
('The Hunger Games: Catching Fire', 'Action', 146, 'English', 5, '2013-11-22'),
('The Hunger Games: Mockingjay – Part 1', 'Action', 123, 'English', 3, '2014-11-21'),
('The Hunger Games: Mockingjay – Part 2', 'Action', 137, 'English', 3, '2015-11-20'),

('Joker', 'Drama', 122, 'English', 5, '2019-10-04'),
('Oppenheimer', 'Drama', 170, 'English', 5, '2023-07-21'),
('Barbie', 'Comedy', 114, 'English', 4, '2023-07-21'),

('Dune', 'Sci-Fi', 155, 'English', 5, '2021-10-22'),
('Dune: Part Two', 'Sci-Fi', 166, 'English', 5, '2024-03-01'),
('Wonka', 'Fantasy', 116, 'English', 4, '2023-12-08');






-- FOR STAFFSHIFT TABLE (100)

-- January 2025 (5 days × 4 shifts)
INSERT INTO staffshift (ShiftName, DateAssigned) VALUES
('Morning', '2025-01-01'), ('Afternoon', '2025-01-01'), ('Evening', '2025-01-01'), ('Night', '2025-01-01'),
('Morning', '2025-01-02'), ('Afternoon', '2025-01-02'), ('Evening', '2025-01-02'), ('Night', '2025-01-02'),
('Morning', '2025-01-03'), ('Afternoon', '2025-01-03'), ('Evening', '2025-01-03'), ('Night', '2025-01-03'),
('Morning', '2025-01-04'), ('Afternoon', '2025-01-04'), ('Evening', '2025-01-04'), ('Night', '2025-01-04'),
('Morning', '2025-01-05'), ('Afternoon', '2025-01-05'), ('Evening', '2025-01-05'), ('Night', '2025-01-05');

-- February 2025
INSERT INTO staffshift (ShiftName, DateAssigned) VALUES
('Morning', '2025-02-01'), ('Afternoon', '2025-02-01'), ('Evening', '2025-02-01'), ('Night', '2025-02-01'),
('Morning', '2025-02-02'), ('Afternoon', '2025-02-02'), ('Evening', '2025-02-02'), ('Night', '2025-02-02'),
('Morning', '2025-02-03'), ('Afternoon', '2025-02-03'), ('Evening', '2025-02-03'), ('Night', '2025-02-03'),
('Morning', '2025-02-04'), ('Afternoon', '2025-02-04'), ('Evening', '2025-02-04'), ('Night', '2025-02-04'),
('Morning', '2025-02-05'), ('Afternoon', '2025-02-05'), ('Evening', '2025-02-05'), ('Night', '2025-02-05');

-- March 2025
INSERT INTO staffshift (ShiftName, DateAssigned) VALUES
('Morning', '2025-03-01'), ('Afternoon', '2025-03-01'), ('Evening', '2025-03-01'), ('Night', '2025-03-01'),
('Morning', '2025-03-02'), ('Afternoon', '2025-03-02'), ('Evening', '2025-03-02'), ('Night', '2025-03-02'),
('Morning', '2025-03-03'), ('Afternoon', '2025-03-03'), ('Evening', '2025-03-03'), ('Night', '2025-03-03'),
('Morning', '2025-03-04'), ('Afternoon', '2025-03-04'), ('Evening', '2025-03-04'), ('Night', '2025-03-04'),
('Morning', '2025-03-05'), ('Afternoon', '2025-03-05'), ('Evening', '2025-03-05'), ('Night', '2025-03-05');

-- April 2025
INSERT INTO staffshift (ShiftName, DateAssigned) VALUES
('Morning', '2025-04-01'), ('Afternoon', '2025-04-01'), ('Evening', '2025-04-01'), ('Night', '2025-04-01'),
('Morning', '2025-04-02'), ('Afternoon', '2025-04-02'), ('Evening', '2025-04-02'), ('Night', '2025-04-02'),
('Morning', '2025-04-03'), ('Afternoon', '2025-04-03'), ('Evening', '2025-04-03'), ('Night', '2025-04-03'),
('Morning', '2025-04-04'), ('Afternoon', '2025-04-04'), ('Evening', '2025-04-04'), ('Night', '2025-04-04'),
('Morning', '2025-04-05'), ('Afternoon', '2025-04-05'), ('Evening', '2025-04-05'), ('Night', '2025-04-05');

-- May 2025
INSERT INTO staffshift (ShiftName, DateAssigned) VALUES
('Morning', '2025-05-01'), ('Afternoon', '2025-05-01'), ('Evening', '2025-05-01'), ('Night', '2025-05-01'),
('Morning', '2025-05-02'), ('Afternoon', '2025-05-02'), ('Evening', '2025-05-02'), ('Night', '2025-05-02'),
('Morning', '2025-05-03'), ('Afternoon', '2025-05-03'), ('Evening', '2025-05-03'), ('Night', '2025-05-03'),
('Morning', '2025-05-04'), ('Afternoon', '2025-05-04'), ('Evening', '2025-05-04'), ('Night', '2025-05-04'),
('Morning', '2025-05-05'), ('Afternoon', '2025-05-05'), ('Evening', '2025-05-05'), ('Night', '2025-05-05');



-- Morning Shift (9 AM to 12 PM)
Update StaffShift 
Set StartTime = '09:00:00', EndTime = '12:00:00'
Where ShiftName = 'Morning';

-- Afternoon Shift (12 PM to 3 PM)
Update StaffShift 
Set StartTime = '12:00:00', EndTime = '15:00:00'
Where ShiftName = 'Afternoon';

-- Evening Shift (3 PM to 9 PM)
Update StaffShift 
Set StartTime = '15:00:00', EndTime = '21:00:00'
Where ShiftName = 'Evening';

-- Night Shift (9 PM to 12 AM)
Update StaffShift 
Set StartTime = '21:00:00', EndTime = '23:59:59'
Where ShiftName = 'Night';








-- FOR STAFF TABLE (100)

Insert Into Staff (Name, Role, ShiftID, HallID, Phone) VALUES
-- Pakistan
('Sarfraz Ahmed', 'Box Office Staff', 1, 1, '555-201-1001'),
('Babar Azam', 'Ticket Checker', 2, 2, '555-201-1002'),
('Fakhar Zaman', 'Usher', 3, 3, '555-201-1003'),
('Muhammad Amir', 'Cleaner', 4, 4, '555-201-1004'),
('Hassan Ali', 'Security', 5, 5, '555-201-1005'),
('Shadab Khan', 'Box Office Staff', 6, 6, '555-201-1006'),
('Imad Wasim', 'Ticket Checker', 7, 1, '555-201-1007'),
('Wahab Riaz', 'Usher', 8, 2, '555-201-1008'),
('Ahmed Shehzad', 'Cleaner', 9, 3, '555-201-1009'),
('Haris Sohail', 'Security', 10, 4, '555-201-1010'),

-- India
('Virat Kohli', 'Box Office Staff', 11, 5, '555-202-1001'),
('MS Dhoni', 'Ticket Checker', 12, 6, '555-202-1002'),
('Rohit Sharma', 'Usher', 13, 1, '555-202-1003'),
('Shikhar Dhawan', 'Cleaner', 14, 2, '555-202-1004'),
('Ravindra Jadeja', 'Security', 15, 3, '555-202-1005'),
('Jasprit Bumrah', 'Box Office Staff', 16, 4, '555-202-1006'),
('KL Rahul', 'Ticket Checker', 17, 5, '555-202-1007'),
('Hardik Pandya', 'Usher', 18, 6, '555-202-1008'),
('Rishabh Pant', 'Cleaner', 19, 1, '555-202-1009'),
('Yuzvendra Chahal', 'Security', 20, 2, '555-202-1010'),

-- Australia
('Steve Smith', 'Box Office Staff', 21, 3, '555-203-1001'),
('David Warner', 'Ticket Checker', 22, 4, '555-203-1002'),
('Aaron Finch', 'Usher', 23, 5, '555-203-1003'),
('Pat Cummins', 'Cleaner', 24, 6, '555-203-1004'),
('Mitchell Starc', 'Security', 25, 1, '555-203-1005'),
('Marcus Stoinis', 'Box Office Staff', 26, 2, '555-203-1006'),
('Glenn Maxwell', 'Ticket Checker', 27, 3, '555-203-1007'),
('Josh Hazlewood', 'Usher', 28, 4, '555-203-1008'),
('Travis Head', 'Cleaner', 29, 5, '555-203-1009'),
('Matthew Wade', 'Security', 30, 6, '555-203-1010'),

-- England
('Joe Root', 'Box Office Staff', 31, 1, '555-204-1001'),
('Ben Stokes', 'Ticket Checker', 32, 2, '555-204-1002'),
('Eoin Morgan', 'Usher', 33, 3, '555-204-1003'),
('Jofra Archer', 'Cleaner', 34, 4, '555-204-1004'),
('Chris Woakes', 'Security', 35, 5, '555-204-1005'),
('Jonny Bairstow', 'Box Office Staff', 36, 6, '555-204-1006'),
('Moeen Ali', 'Ticket Checker', 37, 1, '555-204-1007'),
('Sam Curran', 'Usher', 38, 2, '555-204-1008'),
('Adil Rashid', 'Cleaner', 39, 3, '555-204-1009'),
('Jos Buttler', 'Security', 40, 4, '555-204-1010'),

-- South Africa
('AB de Villiers', 'Box Office Staff', 41, 5, '555-205-1001'),
('Faf du Plessis', 'Ticket Checker', 42, 6, '555-205-1002'),
('Quinton de Kock', 'Usher', 43, 1, '555-205-1003'),
('Hashim Amla', 'Cleaner', 44, 2, '555-205-1004'),
('Kagiso Rabada', 'Security', 45, 3, '555-205-1005'),
('Dale Steyn', 'Box Office Staff', 46, 4, '555-205-1006'),
('David Miller', 'Ticket Checker', 47, 5, '555-205-1007'),
('JP Duminy', 'Usher', 48, 6, '555-205-1008'),
('Imran Tahir', 'Cleaner', 49, 1, '555-205-1009'),
('Lungi Ngidi', 'Security', 50, 2, '555-205-1010');


-- Staff assigned to ShiftID 51–100 (repeating the first 50 with new ShiftIDs)
Insert Into Staff (Name, Role, ShiftID, HallID, Phone) VALUES
('Sarfraz Ahmed', 'Box Office Staff', 51, 1, '555-201-1051'),
('Babar Azam', 'Ticket Checker', 52, 2, '555-201-1052'),
('Fakhar Zaman', 'Usher', 53, 3, '555-201-1053'),
('Muhammad Amir', 'Cleaner', 54, 4, '555-201-1054'),
('Hassan Ali', 'Security', 55, 5, '555-201-1055'),
('Shadab Khan', 'Box Office Staff', 56, 6, '555-201-1056'),
('Imad Wasim', 'Ticket Checker', 57, 1, '555-201-1057'),
('Wahab Riaz', 'Usher', 58, 2, '555-201-1058'),
('Ahmed Shehzad', 'Cleaner', 59, 3, '555-201-1059'),
('Haris Sohail', 'Security', 60, 4, '555-201-1060'),

('Virat Kohli', 'Box Office Staff', 61, 5, '555-202-1061'),
('MS Dhoni', 'Ticket Checker', 62, 6, '555-202-1062'),
('Rohit Sharma', 'Usher', 63, 1, '555-202-1063'),
('Shikhar Dhawan', 'Cleaner', 64, 2, '555-202-1064'),
('Ravindra Jadeja', 'Security', 65, 3, '555-202-1065'),
('Jasprit Bumrah', 'Box Office Staff', 66, 4, '555-202-1066'),
('KL Rahul', 'Ticket Checker', 67, 5, '555-202-1067'),
('Hardik Pandya', 'Usher', 68, 6, '555-202-1068'),
('Rishabh Pant', 'Cleaner', 69, 1, '555-202-1069'),
('Yuzvendra Chahal', 'Security', 70, 2, '555-202-1070'),

('Steve Smith', 'Box Office Staff', 71, 3, '555-203-1071'),
('David Warner', 'Ticket Checker', 72, 4, '555-203-1072'),
('Aaron Finch', 'Usher', 73, 5, '555-203-1073'),
('Pat Cummins', 'Cleaner', 74, 6, '555-203-1074'),
('Mitchell Starc', 'Security', 75, 1, '555-203-1075'),
('Marcus Stoinis', 'Box Office Staff', 76, 2, '555-203-1076'),
('Glenn Maxwell', 'Ticket Checker', 77, 3, '555-203-1077'),
('Josh Hazlewood', 'Usher', 78, 4, '555-203-1078'),
('Travis Head', 'Cleaner', 79, 5, '555-203-1079'),
('Matthew Wade', 'Security', 80, 6, '555-203-1080'),

('Joe Root', 'Box Office Staff', 81, 1, '555-204-1081'),
('Ben Stokes', 'Ticket Checker', 82, 2, '555-204-1082'),
('Eoin Morgan', 'Usher', 83, 3, '555-204-1083'),
('Jofra Archer', 'Cleaner', 84, 4, '555-204-1084'),
('Chris Woakes', 'Security', 85, 5, '555-204-1085'),
('Jonny Bairstow', 'Box Office Staff', 86, 6, '555-204-1086'),
('Moeen Ali', 'Ticket Checker', 87, 1, '555-204-1087'),
('Sam Curran', 'Usher', 88, 2, '555-204-1088'),
('Adil Rashid', 'Cleaner', 89, 3, '555-204-1089'),
('Jos Buttler', 'Security', 90, 4, '555-204-1090'),

('AB de Villiers', 'Box Office Staff', 91, 5, '555-205-1091'),
('Faf du Plessis', 'Ticket Checker', 92, 6, '555-205-1092'),
('Quinton de Kock', 'Usher', 93, 1, '555-205-1093'),
('Hashim Amla', 'Cleaner', 94, 2, '555-205-1094'),
('Kagiso Rabada', 'Security', 95, 3, '555-205-1095'),
('Dale Steyn', 'Box Office Staff', 96, 4, '555-205-1096'),
('David Miller', 'Ticket Checker', 97, 5, '555-205-1097'),
('JP Duminy', 'Usher', 98, 6, '555-205-1098'),
('Imran Tahir', 'Cleaner', 99, 1, '555-205-1099'),
('Lungi Ngidi', 'Security', 100, 2, '555-205-1100');







--INSERTING  400 entries for customer
-- Bollywood Actor/Actress 
Insert Into Customer (FullName, Email, Phone, Gender) Values
('Shah Rukh Khan', 'srk@example.com', '03001234501', 'Male'),
('Amitabh Bachchan', 'amitabh@example.com', '03001234502', 'Male'),
('Aamir Khan', 'aamir@example.com', '03001234503', 'Male'),
('Salman Khan', 'sallu@example.com', '03001234504', 'Male'),
('Hrithik Roshan', 'hrithik@example.com', '03001234505', 'Male'),
('Ranbir Kapoor', 'ranbir@example.com', '03001234506', 'Male'),
('Akshay Kumar', 'akshay@example.com', '03001234507', 'Male'),
('Ajay Devgn', 'ajay@example.com', '03001234508', 'Male'),
('Ranveer Singh', 'ranveer@example.com', '03001234509', 'Male'),
('Varun Dhawan', 'varun@example.com', '03001234510', 'Male'),
('Deepika Padukone', 'deepika@example.com', '03001234511', 'Female'),
('Priyanka Chopra', 'priyanka@example.com', '03001234512', 'Female'),
('Kareena Kapoor', 'kareena@example.com', '03001234513', 'Female'),
('Katrina Kaif', 'katrina@example.com', '03001234514', 'Female'),
('Alia Bhatt', 'alia@example.com', '03001234515', 'Female'),
('Anushka Sharma', 'anushka@example.com', '03001234516', 'Female'),
('Kangana Ranaut', 'kangana@example.com', '03001234517', 'Female'),
('Sonam Kapoor', 'sonam@example.com', '03001234518', 'Female'),
('Shraddha Kapoor', 'shraddha@example.com', '03001234519', 'Female'),
('Madhuri Dixit', 'madhuri@example.com', '03001234520', 'Female'),
('Aishwarya Rai', 'aishwarya@example.com', '03001234521', 'Female'),
('Vidya Balan', 'vidya@example.com', '03001234522', 'Female'),
('Rani Mukerji', 'rani@example.com', '03001234523', 'Female'),
('Saif Ali Khan', 'saif@example.com', '03001234524', 'Male'),
('Shahid Kapoor', 'shahid@example.com', '03001234525', 'Male'),
('Arjun Kapoor', 'arjun@example.com', '03001234526', 'Male'),
('Tiger Shroff', 'tiger@example.com', '03001234527', 'Male'),
('Ayushmann Khurrana', 'ayushmann@example.com', '03001234528', 'Male'),
('Rajkummar Rao', 'rajkummar@example.com', '03001234529', 'Male'),
('Vicky Kaushal', 'vicky@example.com', '03001234530', 'Male'),
('Pankaj Tripathi', 'pankaj@example.com', '03001234531', 'Male'),
('Irrfan Khan', 'irrfan@example.com', '03001234532', 'Male'),
('Nawazuddin Siddiqui', 'nawaz@example.com', '03001234533', 'Male'),
('Manoj Bajpayee', 'manoj@example.com', '03001234534', 'Male'),
('Kartik Aaryan', 'kartik@example.com', '03001234536', 'Male'),
('Sidharth Malhotra', 'sidharth@example.com', '03001234537', 'Male'),
('Aditya Roy Kapur', 'aditya@example.com', '03001234538', 'Male'),
('Farhan Akhtar', 'farhan@example.com', '03001234539', 'Male'),
('John Abraham', 'john@example.com', '03001234540', 'Male'),
('Sunny Deol', 'sunny@example.com', '03001234541', 'Male'),
('EB', 'eb@example.com', '03001234542', 'Male'),
('Anil Kapoor', 'anil@example.com', '03001234543', 'Male'),
('Jackie Shroff', 'jackie@example.com', '03001234544', 'Male'),
('Dharmendra', 'dharmendra@example.com', '03001234545', 'Male'),
('Akshaye Khanna', 'akshaye@example.com', '03001234546', 'Male'),
('Emraan Hashmi', 'emraan@example.com', '03001234547', 'Male'),
('Riteish Deshmukh', 'riteish@example.com', '03001234548', 'Male'),
('Arshad Warsi', 'arshad@example.com', '03001234549', 'Male'),
('Nana Patekar', 'nana@example.com', '03001234550', 'Male'),
('Tabu', 'tabu@example.com', '03001234551', 'Female'),
('Juhi Chawla', 'juhi@example.com', '03001234552', 'Female'),
('Sridevi', 'sridevi@example.com', '03001234553', 'Female'),
('Jaya Bachchan', 'jaya@example.com', '03001234554', 'Female'),
('Rekha', 'rekha@example.com', '03001234555', 'Female'),
('Dimple Kapadia', 'dimple@example.com', '03001234556', 'Female'),
('Hema Malini', 'hema@example.com', '03001234557', 'Female'),
('Sonali Bendre', 'sonali@example.com', '03001234558', 'Female'),
('Twinkle Khanna', 'twinkle@example.com', '03001234559', 'Female'),
('Kajol', 'kajol@example.com', '03001234560', 'Female'),
('Raveena Tandon', 'raveena@example.com', '03001234561', 'Female'),
('Karisma Kapoor', 'karisma@example.com', '03001234562', 'Female'),
('Preity Zinta', 'preity@example.com', '03001234563', 'Female'),
('Bipasha Basu', 'bipasha@example.com', '03001234564', 'Female'),
('Lara Dutta', 'lara@example.com', '03001234565', 'Female'),
('Dia Mirza', 'dia@example.com', '03001234566', 'Female'),
('Amrita Rao', 'amrita@example.com', '03001234567', 'Female'),
('Genelia D Souza', 'genelia@example.com', '03001234568', 'Female'),
('Asin Thottumkal', 'asin@example.com', '03001234569', 'Female'),
('Sonakshi Sinha', 'sonakshi@example.com', '03001234570', 'Female'),
('Parineeti Chopra', 'parineeti@example.com', '03001234571', 'Female'),
('Jacqueline Fernandez', 'jacqueline@example.com', '03001234572', 'Female'),
('Kriti Sanon', 'kriti@example.com', '03001234573', 'Female'),
('Kiara Advani', 'kiara@example.com', '03001234574', 'Female'),
('Bhumi Pednekar', 'bhumi@example.com', '03001234575', 'Female'),
('Taapsee Pannu', 'taapsee@example.com', '03001234576', 'Female'),
('Radhika Apte', 'radhika@example.com', '03001234577', 'Female'),
('Yami Gautam', 'yami@example.com', '03001234578', 'Female'),
('Disha Patani', 'disha@example.com', '03001234579', 'Female'),
('Ananya Panday', 'ananya@example.com', '03001234580', 'Female'),
('Tara Sutaria', 'tara@example.com', '03001234581', 'Female'),
('Janhvi Kapoor', 'janhvi@example.com', '03001234582', 'Female'),
('Sara Ali Khan', 'sara@example.com', '03001234583', 'Female'),
('Nushrat Bharucha', 'nushrat@example.com', '03001234584', 'Female'),
('Mrunal Thakur', 'mrunal@example.com', '03001234585', 'Female'),
('Fatima Sana Shaikh', 'fatima@example.com', '03001234586', 'Female'),
('Sanya Malhotra', 'sanya@example.com', '03001234587', 'Female'),
('Pooja Hegde', 'pooja@example.com', '03001234588', 'Female'),
('Nimrat Kaur', 'nimrat@example.com', '03001234589', 'Female'),
('Huma Qureshi', 'huma@example.com', '03001234590', 'Female'),
('Richa Chadha', 'richa@example.com', '03001234591', 'Female'),
('Kalki Koechlin', 'kalki@example.com', '03001234592', 'Female'),
('Aditi Rao Hydari', 'aditi@example.com', '03001234593', 'Female'),
('Shilpa Shetty', 'shilpa@example.com', '03001234594', 'Female'),
('Malaika Arora', 'malaika@example.com', '03001234595', 'Female'),
('Neha Dhupia', 'neha@example.com', '03001234596', 'Female'),
('Chitrangda Singh', 'chitrangda@example.com', '03001234597', 'Female'),
('Gul Panag', 'gul@example.com', '03001234598', 'Female'),
('Amisha Patel', 'amisha@example.com', '03001234599', 'Female'),
('Esha Deol', 'esha@example.com', '03001234600', 'Female'),
-- Bollywood Singers/Rappers
('Arijit Singh', 'arijit.singh@example.com', '03001234601', 'Male'),
('Neha Kakkar', 'neha.kakkar@example.com', '03001234602', 'Female'),
('Badshah', 'badshah@example.com', '03001234603', 'Male'),
('Shreya Ghoshal', 'shreya.ghoshal@example.com', '03001234604', 'Female'),
('Yo Yo Honey Singh', 'honey.singh@example.com', '03001234605', 'Male'),
('Sunidhi Chauhan', 'sunidhi.chauhan@example.com', '03001234606', 'Female'),
('Jubin Nautiyal', 'jubin.nautiyal@example.com', '03001234607', 'Male'),
('Kanika Kapoor', 'kanika.kapoor@example.com', '03001234608', 'Female'),
('Diljit Dosanjh', 'diljit.dosanjh@example.com', '03001234609', 'Male'),
('Alka Yagnik', 'alka.yagnik@example.com', '03001234610', 'Female'),
('Kumar Sanu', 'kumar.sanu@example.com', '03001234611', 'Male'),
('Palak Muchhal', 'palak.muchhal@example.com', '03001234612', 'Female'),
('Mika Singh', 'mika.singh@example.com', '03001234613', 'Male'),
('Asees Kaur', 'asees.kaur@example.com', '03001234614', 'Female'),
('Armaan Malik', 'armaan.malik@example.com', '03001234615', 'Male'),
('Tulsi Kumar', 'tulsi.kumar@example.com', '03001234616', 'Female'),
('Udit Narayan', 'udit.narayan@example.com', '03001234617', 'Male'),
('Neeti Mohan', 'neeti.mohan@example.com', '03001234618', 'Female'),
('Darshan Raval', 'darshan.raval@example.com', '03001234619', 'Male'),
('Sukhwinder Singh', 'sukhwinder.singh@example.com', '03001234620', 'Male'),
('Monali Thakur', 'monali.thakur@example.com', '03001234621', 'Female'),
('Raftaar', 'raftaar@example.com', '03001234622', 'Male'),
('Shan', 'shan@example.com', '03001234623', 'Male'),
('Sona Mohapatra', 'sona.mohapatra@example.com', '03001234624', 'Female'),
('Nakash Aziz', 'nakash.aziz@example.com', '03001234625', 'Male'),
('Dhvani Bhanushali', 'dhvani.bhanushali@example.com', '03001234626', 'Female'),
('Hardy Sandhu', 'hardy.sandhu@example.com', '03001234627', 'Male'),
('Richa Sharma', 'richa.sharma@example.com', '03001234628', 'Female'),
('B Praak', 'b.praak@example.com', '03001234629', 'Male'),
('Shalmali Kholgade', 'shalmali.k@example.com', '03001234630', 'Female'),
('Ankit Tiwari', 'ankit.tiwari@example.com', '03001234631', 'Male'),
('Harshdeep Kaur', 'harshdeep.kaur@example.com', '03001234632', 'Female'),
('Jassie Gill', 'jassie.gill@example.com', '03001234633', 'Male'),
('Aditi Singh Sharma', 'aditi.sharma@example.com', '03001234634', 'Female'),
('Dev Negi', 'dev.negi@example.com', '03001234635', 'Male'),
('Akasa Singh', 'akasa.singh@example.com', '03001234636', 'Female'),
('Tony Kakkar', 'tony.kakkar@example.com', '03001234637', 'Male'),
('Prakriti Kakar', 'prakriti.kakar@example.com', '03001234638', 'Female'),
('Sachet Tandon', 'sachet.tandon@example.com', '03001234639', 'Male'),
('Parampara Thakur', 'parampara.thakur@example.com', '03001234640', 'Female'),
('Raghav Chaitanya', 'raghav.chaitanya@example.com', '03001234641', 'Male'),
('Meghna Mishra', 'meghna.mishra@example.com', '03001234642', 'Female'),
('Ash King', 'ash.king@example.com', '03001234643', 'Male'),
('Shilpa Rao', 'shilpa.rao@example.com', '03001234644', 'Female'),
('Vishal Dadlani', 'vishal.dadlani@example.com', '03001234645', 'Male'),
('Sneha Khanwalkar', 'sneha.k@example.com', '03001234646', 'Female'),
('Maninder Buttar', 'maninder.buttar@example.com', '03001234647', 'Male'),
('Jonita Gandhi', 'jonita.gandhi@example.com', '03001234648', 'Female'),
('Ritviz', 'ritviz@example.com', '03001234649', 'Male'),
('Anushka Manchanda', 'anushka.m@example.com', '03001234650', 'Female'),
('Nikhita Gandhi', 'nikhita.gandhi@example.com', '03001234651', 'Female'),
('Aditya Narayan', 'aditya.narayan@example.com', '03001234652', 'Male'),
('Shweta Pandit', 'shweta.pandit@example.com', '03001234653', 'Female'),
('Amaal Mallik', 'amaal.mallik@example.com', '03001234654', 'Male'),
('Antara Mitra', 'antara.mitra@example.com', '03001234655', 'Female'),
('Ali Quli Mirza', 'ali.mirza@example.com', '03001234656', 'Male'),
('Mamta Sharma', 'mamta.sharma@example.com', '03001234657', 'Female'),
('Sanjay Dutt', 'sanjay.dutt@example.com', '03001234658', 'Male'),
('Rekha Bhardwaj', 'rekha.b@example.com', '03001234659', 'Female'),
('Zubeen Garg', 'zubeen.garg@example.com', '03001234660', 'Male'),
('Harsh Varrdhan', 'harsh.v@example.com', '03001234661', 'Male'),
('Sagarika', 'sagarika@example.com', '03001234662', 'Female'),
('Abhijeet Bhattacharya', 'abhijeet.b@example.com', '03001234663', 'Male'),
('Anuradha Paudwal', 'anuradha.p@example.com', '03001234664', 'Female'),
('Anup Jalota', 'anup.jalota@example.com', '03001234665', 'Male'),
('Alisha Chinai', 'alisha.chinai@example.com', '03001234666', 'Female'),
('Lucky Ali', 'lucky.ali@example.com', '03001234667', 'Male'),
('Sadhana Sargam', 'sadhana.s@example.com', '03001234668', 'Female'),
('Hariharan', 'hariharan@example.com', '03001234669', 'Male'),
('Chitra Singh', 'chitra.singh@example.com', '03001234670', 'Female'),
('Kailash Kher', 'kailash.kher@example.com', '03001234671', 'Male'),
('Annie Khalid', 'annie.khalid@example.com', '03001234672', 'Female'),
('Shantanu Mukherjee', 'shantanu.m@example.com', '03001234673', 'Male'),
('Reshma', 'reshma@example.com', '03001234674', 'Female'),
('Ali Zafar', 'ali.zafar@example.com', '03001234675', 'Male'),
('Sanjana Sanghi', 'sanjana.s@example.com', '03001234676', 'Female'),
('Papon', 'papon@example.com', '03001234677', 'Male'),
('Sireesha Bhagavatula', 'sireesha.b@example.com', '03001234678', 'Female'),
('Vishal Mishra', 'vishal.mishra@example.com', '03001234679', 'Male'),
('Shraddha Pandit', 'shraddha.pandit@example.com', '03001234680', 'Female'),
('Avneet Khurmi', 'avneet.k@example.com', '03001234681', 'Female'),
('Nikhil D’Souza', 'nikhil.dsouza@example.com', '03001234682', 'Male'),
('Sunali Rathod', 'sunali.rathod@example.com', '03001234683', 'Female'),
('Sidhu Moose Wala', 'sidhu.moosewala@example.com', '03001234684', 'Male'),
('J Star', 'j.star@example.com', '03001234685', 'Male'),
('Bohemia', 'bohemia@example.com', '03001234686', 'Male'),
('Divine', 'divine@example.com', '03001234687', 'Male'),
('Naezy', 'naezy@example.com', '03001234688', 'Male'),
('MC Stan', 'mc.stan@example.com', '03001234689', 'Male'),
('Ikka', 'ikka@example.com', '03001234690', 'Male'),
('Emiway Bantai', 'emiway@example.com', '03001234691', 'Male'),
('KR$NA', 'krishna@example.com', '03001234692', 'Male'),
('Bali', 'bali@example.com', '03001234693', 'Male'),
('Seedhe Maut', 'seedhe.maut@example.com', '03001234694', 'Male'),
('Dino James', 'dino.james@example.com', '03001234695', 'Male'),
('SlowCheeta', 'slowcheeta@example.com', '03001234696', 'Male'),
('Spitfire', 'spitfire@example.com', '03001234697', 'Male'),
('Raja Kumari', 'raja.kumari@example.com', '03001234698', 'Female'),
('Fotty Seven', 'fotty.seven@example.com', '03001234699', 'Male'),
('MC Altaf', 'mc.altaf@example.com', '03001234700', 'Male');

--Hollywood Singers/Rappers 
Insert Into Customer (FullName, Email, Phone, Gender) Values
('Eminem', 'eminem@example.com', '03001234701', 'Male'),
('Taylor Swift', 'taylor.swift@example.com', '03001234702', 'Female'),
('Drake', 'drake@example.com', '03001234703', 'Male'),
('Ariana Grande', 'ariana.grande@example.com', '03001234704', 'Female'),
('Kanye West', 'kanye.west@example.com', '03001234705', 'Male'),
('Beyoncé', 'beyonce@example.com', '03001234706', 'Female'),
('Post Malone', 'post.malone@example.com', '03001234707', 'Male'),
('Rihanna', 'rihanna@example.com', '03001234708', 'Female'),
('Lil Wayne', 'lil.wayne@example.com', '03001234709', 'Male'),
('Billie Eilish', 'billie.eilish@example.com', '03001234710', 'Female'),
('Jay-Z', 'jay.z@example.com', '03001234711', 'Male'),
('Lady Gaga', 'lady.gaga@example.com', '03001234712', 'Female'),
('Travis Scott', 'travis.scott@example.com', '03001234713', 'Male'),
('Dua Lipa', 'dua.lipa@example.com', '03001234714', 'Female'),
('Kendrick Lamar', 'kendrick.lamar@example.com', '03001234715', 'Male'),
('Doja Cat', 'doja.cat@example.com', '03001234716', 'Female'),
('The Weeknd', 'the.weeknd@example.com', '03001234717', 'Male'),
('Miley Cyrus', 'miley.cyrus@example.com', '03001234718', 'Female'),
('Nicki Minaj', 'nicki.minaj@example.com', '03001234719', 'Female'),
('Justin Bieber', 'justin.bieber@example.com', '03001234720', 'Male'),
('Snoop Dogg', 'snoop.dogg@example.com', '03001234721', 'Male'),
('Katy Perry', 'katy.perry@example.com', '03001234722', 'Female'),
('50 Cent', '50cent@example.com', '03001234723', 'Male'),
('Camila Cabello', 'camila.cabello@example.com', '03001234724', 'Female'),
('Lil Nas X', 'lil.nasx@example.com', '03001234725', 'Male'),
('Selena Gomez', 'selena.gomez@example.com', '03001234726', 'Female'),
('Tyler, The Creator', 'tyler.creator@example.com', '03001234727', 'Male'),
('Halsey', 'halsey@example.com', '03001234728', 'Female'),
('G-Eazy', 'g.eazy@example.com', '03001234729', 'Male'),
('Cardi B', 'cardi.b@example.com', '03001234730', 'Female'),
('Machine Gun Kelly', 'mgk@example.com', '03001234731', 'Male'),
('Lizzo', 'lizzo@example.com', '03001234732', 'Female'),
('J. Cole', 'j.cole@example.com', '03001234733', 'Male'),
('Adele', 'adele@example.com', '03001234734', 'Female'),
('Bruno Mars', 'bruno.mars@example.com', '03001234735', 'Male'),
('Sia', 'sia@example.com', '03001234736', 'Female'),
('Childish Gambino', 'childish.gambino@example.com', '03001234737', 'Male'),
('Normani', 'normani@example.com', '03001234738', 'Female'),
('Pitbull', 'pitbull@example.com', '03001234739', 'Male'),
('Ellie Goulding', 'ellie.goulding@example.com', '03001234740', 'Female'),
('Chris Brown', 'chris.brown@example.com', '03001234741', 'Male'),
('Meghan Trainor', 'meghan.trainor@example.com', '03001234742', 'Female'),
('French Montana', 'french.montana@example.com', '03001234743', 'Male'),
('Alicia Keys', 'alicia.keys@example.com', '03001234744', 'Female'),
('Usher', 'usher@example.com', '03001234745', 'Male'),
('Tinashe', 'tinashe@example.com', '03001234746', 'Female'),
('Ty Dolla Sign', 'ty.dolla@example.com', '03001234747', 'Male'),
('Lana Del Rey', 'lana.del.rey@example.com', '03001234748', 'Female'),
('Offset', 'offset@example.com', '03001234749', 'Male'),
('Tove Lo', 'tove.lo@example.com', '03001234750', 'Female'),
('Future', 'future@example.com', '03001234751', 'Male'),
('Fergie', 'fergie@example.com', '03001234752', 'Female'),
('Wiz Khalifa', 'wiz.khalifa@example.com', '03001234753', 'Male'),
('Avril Lavigne', 'avril.lavigne@example.com', '03001234754', 'Female'),
('21 Savage', '21.savage@example.com', '03001234755', 'Male'),
('Becky G', 'becky.g@example.com', '03001234756', 'Female'),
('Tyga', 'tyga@example.com', '03001234757', 'Male'),
('Jennifer Lopez', 'jlo@example.com', '03001234758', 'Female'),
('Nas', 'nas@example.com', '03001234759', 'Male'),
('Bebe Rexha', 'bebe.rexha@example.com', '03001234760', 'Female'),
('Polo G', 'polo.g@example.com', '03001234761', 'Male'),
('Tory Lanez', 'tory.lanez@example.com', '03001234762', 'Male'),
('H.E.R.', 'her@example.com', '03001234763', 'Female'),
('DaBaby', 'dababy@example.com', '03001234764', 'Male'),
('Jessie J', 'jessie.j@example.com', '03001234765', 'Female'),
('Roddy Ricch', 'roddy.ricch@example.com', '03001234766', 'Male'),
('Iggy Azalea', 'iggy.azalea@example.com', '03001234767', 'Female'),
('A$AP Rocky', 'asap.rocky@example.com', '03001234768', 'Male'),
('Ashanti', 'ashanti@example.com', '03001234769', 'Female'),
('Logic', 'logic@example.com', '03001234770', 'Male'),
('Kesha', 'kesha@example.com', '03001234771', 'Female'),
('B.o.B', 'bob@example.com', '03001234772', 'Male'),
('Demi Lovato', 'demi.lovato@example.com', '03001234773', 'Female'),
('Anderson .Paak', 'anderson.paak@example.com', '03001234774', 'Male'),
('Julia Michaels', 'julia.michaels@example.com', '03001234775', 'Female'),
('NAV', 'nav@example.com', '03001234776', 'Male'),
('Christina Aguilera', 'christina.aguilera@example.com', '03001234777', 'Female'),
('Trippie Redd', 'trippie.redd@example.com', '03001234778', 'Male'),
('Maren Morris', 'maren.morris@example.com', '03001234779', 'Female'),
('Joji', 'joji@example.com', '03001234780', 'Male'),
('Rita Ora', 'rita.ora@example.com', '03001234781', 'Female'),
('Lil Uzi Vert', 'lil.uzi@example.com', '03001234782', 'Male'),
('Zara Larsson', 'zara.larsson@example.com', '03001234783', 'Female'),
('Quavo', 'quavo@example.com', '03001234784', 'Male'),
('Noah Cyrus', 'noah.cyrus@example.com', '03001234785', 'Female'),
('Jack Harlow', 'jack.harlow@example.com', '03001234786', 'Male'),
('Tori Kelly', 'tori.kelly@example.com', '03001234787', 'Female'),
('Lil Yachty', 'lil.yachty@example.com', '03001234788', 'Male'),
('Kehlani', 'kehlani@example.com', '03001234789', 'Female'),
('Metro Boomin', 'metro.boomin@example.com', '03001234790', 'Male'),
('Sabrina Carpenter', 'sabrina.carpenter@example.com', '03001234791', 'Female'),
('PnB Rock', 'pnb.rock@example.com', '03001234792', 'Male'),
('Hailee Steinfeld', 'hailee.steinfeld@example.com', '03001234793', 'Female'),
('Russ', 'russ@example.com', '03001234794', 'Male'),
('Florence Welch', 'florence.welch@example.com', '03001234795', 'Female'),
('Big Sean', 'big.sean@example.com', '03001234796', 'Male'),
('Grimes', 'grimes@example.com', '03001234797', 'Female'),
('Yungblud', 'yungblud@example.com', '03001234798', 'Male'),
('Skylar Grey', 'skylar.grey@example.com', '03001234799', 'Female'),
('JoJo', 'jojo@example.com', '03001234800', 'Female');

--Hollywood Actors
INSERT INTO Customer (FullName, Email, Phone, Gender) VALUES
('Leonardo DiCaprio', 'leonardo.d@example.com', '03001234801', 'Male'),
('Scarlett Johansson', 'scarlett.j@example.com', '03001234802', 'Female'),
('Brad Pitt', 'brad.pitt@example.com', '03001234803', 'Male'),
('Angelina Jolie', 'angelina.j@example.com', '03001234804', 'Female'),
('Johnny Depp', 'johnny.depp@example.com', '03001234805', 'Male'),
('Jennifer Lawrence', 'j.lawrence@example.com', '03001234806', 'Female'),
('Robert Downey Jr.', 'rdj@example.com', '03001234807', 'Male'),
('Emma Watson', 'emma.watson@example.com', '03001234808', 'Female'),
('Tom Cruise', 'tom.cruise@example.com', '03001234809', 'Male'),
('Natalie Portman', 'natalie.p@example.com', '03001234810', 'Female'),
('Chris Hemsworth', 'chris.h@example.com', '03001234811', 'Male'),
('Anne Hathaway', 'anne.h@example.com', '03001234812', 'Female'),
('Christian Bale', 'christian.b@example.com', '03001234813', 'Male'),
('Mila Kunis', 'mila.k@example.com', '03001234814', 'Female'),
('Ryan Gosling', 'ryan.g@example.com', '03001234815', 'Male'),
('Emma Stone', 'emma.stone@example.com', '03001234816', 'Female'),
('Will Smith', 'will.smith@example.com', '03001234817', 'Male'),
('Sandra Bullock', 'sandra.b@example.com', '03001234818', 'Female'),
('Chris Evans', 'chris.evans@example.com', '03001234819', 'Male'),
('Charlize Theron', 'charlize.t@example.com', '03001234820', 'Female'),
('Dwayne Johnson', 'dwayne.j@example.com', '03001234821', 'Male'),
('Gal Gadot', 'gal.gadot@example.com', '03001234822', 'Female'),
('Hugh Jackman', 'hugh.j@example.com', '03001234823', 'Male'),
('Zendaya', 'zendaya@example.com', '03001234824', 'Female'),
('Mark Wahlberg', 'mark.w@example.com', '03001234825', 'Male'),
('Jennifer Aniston', 'jennifer.a@example.com', '03001234826', 'Female'),
('Keanu Reeves', 'keanu.r@example.com', '03001234827', 'Male'),
('Reese Witherspoon', 'reese.w@example.com', '03001234828', 'Female'),
('Jason Momoa', 'jason.m@example.com', '03001234829', 'Male'),
('Kristen Stewart', 'kristen.s@example.com', '03001234830', 'Female'),
('Matt Damon', 'matt.d@example.com', '03001234831', 'Male'),
('Megan Fox', 'megan.f@example.com', '03001234832', 'Female'),
('Ben Affleck', 'ben.a@example.com', '03001234833', 'Male'),
('Julia Roberts', 'julia.r@example.com', '03001234834', 'Female'),
('Tom Hanks', 'tom.hanks@example.com', '03001234835', 'Male'),
('Anne Heche', 'anne.heche@example.com', '03001234836', 'Female'),
('Jake Gyllenhaal', 'jake.g@example.com', '03001234837', 'Male'),
('Kate Winslet', 'kate.w@example.com', '03001234838', 'Female'),
('Andrew Garfield', 'andrew.g@example.com', '03001234839', 'Male'),
('Dakota Johnson', 'dakota.j@example.com', '03001234840', 'Female'),
('Samuel L. Jackson', 'samuel.j@example.com', '03001234841', 'Male'),
('Emily Blunt', 'emily.b@example.com', '03001234842', 'Female'),
('Joaquin Phoenix', 'joaquin.p@example.com', '03001234843', 'Male'),
('Margot Robbie', 'margot.r@example.com', '03001234844', 'Female'),
('Jeremy Renner', 'jeremy.r@example.com', '03001234845', 'Male'),
('Amy Adams', 'amy.adams@example.com', '03001234846', 'Female'),
('Chris Pratt', 'chris.p@example.com', '03001234847', 'Male'),
('Chloë Grace Moretz', 'chloe.m@example.com', '03001234848', 'Female'),
('Michael B. Jordan', 'michael.j@example.com', '03001234849', 'Male'),
('Saoirse Ronan', 'saoirse.r@example.com', '03001234850', 'Female'),
('Tobey Maguire', 'tobey.m@example.com', '03001234851', 'Male'),
('Jessica Chastain', 'jessica.c@example.com', '03001234852', 'Female'),
('Harrison Ford', 'harrison.f@example.com', '03001234853', 'Male'),
('Winona Ryder', 'winona.r@example.com', '03001234854', 'Female'),
('Paul Rudd', 'paul.rudd@example.com', '03001234855', 'Male'),
('Meryl Streep', 'meryl.s@example.com', '03001234856', 'Female'),
('John Cena', 'john.cena@example.com', '03001234857', 'Male'),
('Blake Lively', 'blake.l@example.com', '03001234858', 'Female'),
('Tom Holland', 'tom.holland@example.com', '03001234859', 'Male'),
('Brie Larson', 'brie.l@example.com', '03001234860', 'Female'),
('Rami Malek', 'rami.malek@example.com', '03001234861', 'Male'),
('Zoë Kravitz', 'zoe.k@example.com', '03001234862', 'Female'),
('Idris Elba', 'idris.e@example.com', '03001234863', 'Male'),
('Mandy Moore', 'mandy.m@example.com', '03001234864', 'Female'),
('Jared Leto', 'jared.l@example.com', '03001234865', 'Male'),
('Kirsten Dunst', 'kirsten.d@example.com', '03001234866', 'Female'),
('James Franco', 'james.f@example.com', '03001234867', 'Male'),
('Eva Mendes', 'eva.m@example.com', '03001234868', 'Female'),
('Channing Tatum', 'channing.t@example.com', '03001234869', 'Male'),
('Lily Collins', 'lily.c@example.com', '03001234870', 'Female'),
('Ryan Reynolds', 'ryan.r@example.com', '03001234871', 'Male'),
('Shailene Woodley', 'shailene.w@example.com', '03001234872', 'Female'),
('Josh Brolin', 'josh.b@example.com', '03001234873', 'Male'),
('Natalie Dormer', 'natalie.d@example.com', '03001234874', 'Female'),
('Joseph Gordon-Levitt', 'joseph.g@example.com', '03001234875', 'Male'),
('Rose Byrne', 'rose.b@example.com', '03001234876', 'Female'),
('Ethan Hawke', 'ethan.h@example.com', '03001234877', 'Male'),
('Tessa Thompson', 'tessa.t@example.com', '03001234878', 'Female'),
('Sebastian Stan', 'sebastian.s@example.com', '03001234879', 'Male'),
('Zoey Deutch', 'zoey.d@example.com', '03001234880', 'Female'),
('Ashton Kutcher', 'ashton.k@example.com', '03001234881', 'Male'),
('Elizabeth Olsen', 'elizabeth.o@example.com', '03001234882', 'Female'),
('David Harbour', 'david.h@example.com', '03001234883', 'Male'),
('Kristen Bell', 'kristen.b@example.com', '03001234884', 'Female'),
('Paul Bettany', 'paul.b@example.com', '03001234885', 'Male'),
('Naomi Watts', 'naomi.w@example.com', '03001234886', 'Female'),
('Orlando Bloom', 'orlando.b@example.com', '03001234887', 'Male'),
('Drew Barrymore', 'drew.b@example.com', '03001234888', 'Female'),
('Steve Carell', 'steve.c@example.com', '03001234889', 'Male'),
('Zooey Deschanel', 'zooey.d@example.com', '03001234890', 'Female'),
('Josh Hutcherson', 'josh.h@example.com', '03001234891', 'Male'),
('Nina Dobrev', 'nina.d@example.com', '03001234892', 'Female'),
('Bill Skarsgård', 'bill.s@example.com', '03001234893', 'Male'),
('Amber Heard', 'amber.h@example.com', '03001234894', 'Female'),
('Aaron Taylor-Johnson', 'aaron.tj@example.com', '03001234895', 'Male'),
('Elisabeth Moss', 'elisabeth.m@example.com', '03001234896', 'Female'),
('Ansel Elgort', 'ansel.e@example.com', '03001234897', 'Male'),
('Olivia Wilde', 'olivia.w@example.com', '03001234898', 'Female'),
('Cole Sprouse', 'cole.s@example.com', '03001234899', 'Male'),
('Millie Bobby Brown', 'millie.b@example.com', '03001234900', 'Female');

--Characters Names
Insert Into Customer (FullName, Email, Phone, Gender) Values
('Tony Stark', 'tony.stark@example.com', '03001234901', 'Male'),
('Bruce Wayne', 'bruce.wayne@example.com', '03001234902', 'Male'),
('Diana Prince', 'diana.prince@example.com', '03001234903', 'Female'),
('Clark Kent', 'clark.kent@example.com', '03001234904', 'Male'),
('Natasha Romanoff', 'natasha.r@example.com', '03001234905', 'Female'),
('Steve Rogers', 'steve.rogers@example.com', '03001234906', 'Male'),
('Peter Parker', 'peter.parker@example.com', '03001234907', 'Male'),
('Selina Kyle', 'selina.kyle@example.com', '03001234908', 'Female'),
('Thor Odinson', 'thor@example.com', '03001234909', 'Male'),
('Loki Laufeyson', 'loki@example.com', '03001234910', 'Male'),
('Gamora', 'gamora@example.com', '03001234911', 'Female'),
('Wanda Maximoff', 'wanda.m@example.com', '03001234912', 'Female'),
('Stephen Strange', 'stephen.s@example.com', '03001234913', 'Male'),
('Nick Fury', 'nick.fury@example.com', '03001234914', 'Male'),
('Pepper Potts', 'pepper.potts@example.com', '03001234915', 'Female'),
('Challa', 'tchalla@example.com', '03001234916', 'Male'),
('Shuri', 'shuri@example.com', '03001234917', 'Female'),
('Peter Quill', 'peter.quill@example.com', '03001234918', 'Male'),
('Rocket Raccoon', 'rocket.r@example.com', '03001234919', 'Male'),
('Groot', 'groot@example.com', '03001234920', 'Male'),
('Drax the Destroyer', 'drax@example.com', '03001234921', 'Male'),
('Scott Lang', 'scott.lang@example.com', '03001234922', 'Male'),
('Hope van Dyne', 'hope.v@example.com', '03001234923', 'Female'),
('Bucky Barnes', 'bucky.b@example.com', '03001234924', 'Male'),
('Sam Wilson', 'sam.wilson@example.com', '03001234925', 'Male'),
('Harley Quinn', 'harley.quinn@example.com', '03001234926', 'Female'),
('Arthur Fleck', 'arthur.f@example.com', '03001234927', 'Male'),
('Deadpool', 'deadpool@example.com', '03001234928', 'Male'),
('Wade Wilson', 'wade.w@example.com', '03001234929', 'Male'),
('Jean Grey', 'jean.g@example.com', '03001234930', 'Female'),
('Logan', 'logan@example.com', '03001234931', 'Male'),
('Charles Xavier', 'charles.x@example.com', '03001234932', 'Male'),
('Magneto', 'magneto@example.com', '03001234933', 'Male'),
('Mystique', 'mystique@example.com', '03001234934', 'Female'),
('Storm', 'storm@example.com', '03001234935', 'Female'),
('Rogue', 'rogue@example.com', '03001234936', 'Female'),
('Beast', 'beast@example.com', '03001234937', 'Male'),
('Cyclops', 'cyclops@example.com', '03001234938', 'Male'),
('Professor X', 'prof.x@example.com', '03001234939', 'Male'),
('Erik Lehnsherr', 'erik.l@example.com', '03001234940', 'Male'),
('James Bond', 'james.bond@example.com', '03001234941', 'Male'),
('Jason Bourne', 'jason.bourne@example.com', '03001234942', 'Male'),
('Ethan Hunt', 'ethan.hunt@example.com', '03001234943', 'Male'),
('Dominic Toretto', 'dom.toretto@example.com', '03001234944', 'Male'),
('Letty Ortiz', 'letty.o@example.com', '03001234945', 'Female'),
('Mia Toretto', 'mia.t@example.com', '03001234946', 'Female'),
('Brian O Conner', 'brian.o@example.com', '03001234947', 'Male'),
('Neo', 'neo@example.com', '03001234948', 'Male'),
('Trinity', 'trinity@example.com', '03001234949', 'Female'),
('Morpheus', 'morpheus@example.com', '03001234950', 'Male'),
('John Wick', 'john.wick@example.com', '03001234951', 'Male'),
('Vito Corleone', 'vito.c@example.com', '03001234952', 'Male'),
('Michael Corleone', 'michael.c@example.com', '03001234953', 'Male'),
('Frodo Baggins', 'frodo.b@example.com', '03001234954', 'Male'),
('Samwise Gamgee', 'samwise.g@example.com', '03001234955', 'Male'),
('Gandalf', 'gandalf@example.com', '03001234956', 'Male'),
('Aragorn', 'aragorn@example.com', '03001234957', 'Male'),
('Legolas', 'legolas@example.com', '03001234958', 'Male'),
('Gimli', 'gimli@example.com', '03001234959', 'Male'),
('Bilbo Baggins', 'bilbo.b@example.com', '03001234960', 'Male'),
('Thorin Oakenshield', 'thorin.o@example.com', '03001234961', 'Male'),
('Smaug', 'smaug@example.com', '03001234962', 'Male'),
('Katniss Everdeen', 'katniss.e@example.com', '03001234963', 'Female'),
('Peeta Mellark', 'peeta.m@example.com', '03001234964', 'Male'),
('Gale Hawthorne', 'gale.h@example.com', '03001234965', 'Male'),
('Effie Trinket', 'effie.t@example.com', '03001234966', 'Female'),
('Haymitch Abernathy', 'haymitch.a@example.com', '03001234967', 'Male'),
('President Snow', 'snow@example.com', '03001234968', 'Male'),
('Newt Scamander', 'newt.s@example.com', '03001234969', 'Male'),
('Albus Dumbledore', 'dumbledore@example.com', '03001234970', 'Male'),
('Harry Potter', 'harry.p@example.com', '03001234971', 'Male'),
('Hermione Granger', 'hermione.g@example.com', '03001234972', 'Female'),
('Ron Weasley', 'ron.w@example.com', '03001234973', 'Male'),
('Draco Malfoy', 'draco.m@example.com', '03001234974', 'Male'),
('Luna Lovegood', 'luna.l@example.com', '03001234975', 'Female'),
('Severus Snape', 'snape@example.com', '03001234976', 'Male'),
('Voldemort', 'voldemort@example.com', '03001234977', 'Male'),
('Hagrid', 'hagrid@example.com', '03001234978', 'Male'),
('Minerva McGonagall', 'mcgonagall@example.com', '03001234979', 'Female'),
('Bellatrix Lestrange', 'bellatrix.l@example.com', '03001234980', 'Female'),
('Jacob Kowalski', 'jacob.k@example.com', '03001234981', 'Male'),
('Edward Cullen', 'edward.c@example.com', '03001234982', 'Male'),
('Bella Swan', 'bella.s@example.com', '03001234983', 'Female'),
('Jacob Black', 'jacob.b@example.com', '03001234984', 'Male'),
('Beatrix Kiddo', 'beatrix.k@example.com', '03001234985', 'Female'),
('Jules Winnfield', 'jules.w@example.com', '03001234986', 'Male'),
('Vincent Vega', 'vincent.v@example.com', '03001234987', 'Male'),
('Clarice Starling', 'clarice.s@example.com', '03001234988', 'Female'),
('Hannibal Lecter', 'hannibal.l@example.com', '03001234989', 'Male'),
('Andy Dufresne', 'andy.d@example.com', '03001234990', 'Male'),
('Red Redding', 'red.r@example.com', '03001234991', 'Male'),
('Maximus Decimus', 'maximus.d@example.com', '03001234992', 'Male'),
('Commodus', 'commodus@example.com', '03001234993', 'Male'),
('The Bride', 'the.bride@example.com', '03001234994', 'Female'),
('Tyler Durden', 'tyler.d@example.com', '03001234995', 'Male'),
('Marla Singer', 'marla.s@example.com', '03001234996', 'Female'),
('Forrest Gump', 'forrest.g@example.com', '03001234997', 'Male'),
('Jenny Curran', 'jenny.c@example.com', '03001234998', 'Female'),
('Woody', 'woody@example.com', '03001234999', 'Male'),
('Buzz Lightyear', 'buzz.l@example.com', '03001235000', 'Male');

Insert Into Customer (FullName, Email, Phone, Gender) Values
('Allu Arjun', 'allu@example.com', '03003214564', 'Male');
-------------------------------------------



Insert Into Seat (SeatID, HallID, SeatNumber, SeatType, Status)
VALUES
(1, 1, 'A1', 'Premium', 'Available'),
(2, 1, 'A2', 'Premium', 'Available'),
(3, 1, 'A3', 'Premium', 'Available'),
(4, 1, 'A4', 'Premium', 'Available'),
(5, 1, 'A5', 'Premium', 'Available'),
(6, 1, 'A6', 'Premium', 'Available'),
(7, 1, 'A7', 'Premium', 'Available'),
(8, 1, 'A8', 'Premium', 'Available'),
(9, 1, 'A9', 'Premium', 'Available'),
(10, 1, 'A10', 'Premium', 'Available'),
(11, 1, 'B1', 'Premium', 'Available'),
(12, 1, 'B2', 'Premium', 'Available'),
(13, 1, 'B3', 'Premium', 'Available'),
(14, 1, 'B4', 'Premium', 'Available'),
(15, 1, 'B5', 'Premium', 'Available'),
(16, 1, 'B6', 'Premium', 'Available'),
(17, 1, 'B7', 'Premium', 'Available'),
(18, 1, 'B8', 'Premium', 'Available'),
(19, 1, 'B9', 'Premium', 'Available'),
(20, 1, 'B10', 'Premium', 'Available'),
(21, 1, 'C1', 'Premium', 'Available'),
(22, 1, 'C2', 'Premium', 'Available'),
(23, 1, 'C3', 'Premium', 'Available'),
(24, 1, 'C4', 'Premium', 'Available'),
(25, 1, 'C5', 'Premium', 'Available'),
(26, 1, 'C6', 'Premium', 'Available'),
(27, 1, 'C7', 'Premium', 'Available'),
(28, 1, 'C8', 'Premium', 'Available'),
(29, 1, 'C9', 'Premium', 'Available'),
(30, 1, 'C10', 'Premium', 'Available'),
(31, 1, 'D1', 'Premium', 'Available'),
(32, 1, 'D2', 'Premium', 'Available'),
(33, 1, 'D3', 'Premium', 'Available'),
(34, 1, 'D4', 'Premium', 'Available'),
(35, 1, 'D5', 'Premium', 'Available'),
(36, 1, 'D6', 'Premium', 'Available'),
(37, 1, 'D7', 'Premium', 'Available'),
(38, 1, 'D8', 'Premium', 'Available'),
(39, 1, 'D9', 'Premium', 'Available'),
(40, 1, 'D10', 'Premium', 'Available'),
(41, 1, 'E1', 'Premium', 'Available'),
(42, 1, 'E2', 'Premium', 'Available'),
(43, 1, 'E3', 'Premium', 'Available'),
(44, 1, 'E4', 'Premium', 'Available'),
(45, 1, 'E5', 'Premium', 'Available'),
(46, 1, 'E6', 'Premium', 'Available'),
(47, 1, 'E7', 'Premium', 'Available'),
(48, 1, 'E8', 'Premium', 'Available'),
(49, 1, 'E9', 'Premium', 'Available'),
(50, 1, 'E10', 'Premium', 'Available'),
(51, 1, 'F1', 'Standard', 'Available'),
(52, 1, 'F2', 'Standard', 'Available'),
(53, 1, 'F3', 'Standard', 'Available'),
(54, 1, 'F4', 'Standard', 'Available'),
(55, 1, 'F5', 'Standard', 'Available'),
(56, 1, 'F6', 'Standard', 'Available'),
(57, 1, 'F7', 'Standard', 'Available'),
(58, 1, 'F8', 'Standard', 'Available'),
(59, 1, 'F9', 'Standard', 'Available'),
(60, 1, 'F10', 'Standard', 'Available'),
(61, 1, 'G1', 'Standard', 'Available'),
(62, 1, 'G2', 'Standard', 'Available'),
(63, 1, 'G3', 'Standard', 'Available'),
(64, 1, 'G4', 'Standard', 'Available'),
(65, 1, 'G5', 'Standard', 'Available'),
(66, 1, 'G6', 'Standard', 'Available'),
(67, 1, 'G7', 'Standard', 'Available'),
(68, 1, 'G8', 'Standard', 'Available'),
(69, 1, 'G9', 'Standard', 'Available'),
(70, 1, 'G10', 'Standard', 'Available'),
(71, 1, 'H1', 'Standard', 'Available'),
(72, 1, 'H2', 'Standard', 'Available'),
(73, 1, 'H3', 'Standard', 'Available'),
(74, 1, 'H4', 'Standard', 'Available'),
(75, 1, 'H5', 'Standard', 'Available'),
(76, 1, 'H6', 'Standard', 'Available'),
(77, 1, 'H7', 'Standard', 'Available'),
(78, 1, 'H8', 'Standard', 'Available'),
(79, 1, 'H9', 'Standard', 'Available'),
(80, 1, 'H10', 'Standard', 'Available'),
(81, 1, 'I1', 'Standard', 'Available'),
(82, 1, 'I2', 'Standard', 'Available'),
(83, 1, 'I3', 'Standard', 'Available'),
(84, 1, 'I4', 'Standard', 'Available'),
(85, 1, 'I5', 'Standard', 'Available'),
(86, 1, 'I6', 'Standard', 'Available'),
(87, 1, 'I7', 'Standard', 'Available'),
(88, 1, 'I8', 'Standard', 'Available'),
(89, 1, 'I9', 'Standard', 'Available'),
(90, 1, 'I10', 'Standard', 'Available'),
(91, 1, 'J1', 'Standard', 'Available'),
(92, 1, 'J2', 'Standard', 'Available'),
(93, 1, 'J3', 'Standard', 'Available'),
(94, 1, 'J4', 'Standard', 'Available'),
(95, 1, 'J5', 'Standard', 'Available'),
(96, 1, 'J6', 'Standard', 'Available'),
(97, 1, 'J7', 'Standard', 'Available'),
(98, 1, 'J8', 'Standard', 'Available'),
(99, 1, 'J9', 'Standard', 'Available'),
(100, 1, 'J10', 'Standard', 'Available'),
(101, 2, 'A1', 'Premium', 'Available'),
(102, 2, 'A2', 'Premium', 'Available'),
(103, 2, 'A3', 'Premium', 'Available'),
(104, 2, 'A4', 'Premium', 'Available'),
(105, 2, 'A5', 'Premium', 'Available'),
(106, 2, 'A6', 'Premium', 'Available'),
(107, 2, 'A7', 'Premium', 'Available'),
(108, 2, 'A8', 'Premium', 'Available'),
(109, 2, 'A9', 'Premium', 'Available'),
(110, 2, 'A10', 'Premium', 'Available'),
(111, 2, 'B1', 'Premium', 'Available'),
(112, 2, 'B2', 'Premium', 'Available'),
(113, 2, 'B3', 'Premium', 'Available'),
(114, 2, 'B4', 'Premium', 'Available'),
(115, 2, 'B5', 'Premium', 'Available'),
(116, 2, 'B6', 'Premium', 'Available'),
(117, 2, 'B7', 'Premium', 'Available'),
(118, 2, 'B8', 'Premium', 'Available'),
(119, 2, 'B9', 'Premium', 'Available'),
(120, 2, 'B10', 'Premium', 'Available'),
(121, 2, 'C1', 'Premium', 'Available'),
(122, 2, 'C2', 'Premium', 'Available'),
(123, 2, 'C3', 'Premium', 'Available'),
(124, 2, 'C4', 'Premium', 'Available'),
(125, 2, 'C5', 'Premium', 'Available'),
(126, 2, 'C6', 'Premium', 'Available'),
(127, 2, 'C7', 'Premium', 'Available'),
(128, 2, 'C8', 'Premium', 'Available'),
(129, 2, 'C9', 'Premium', 'Available'),
(130, 2, 'C10', 'Premium', 'Available'),
(131, 2, 'D1', 'Premium', 'Available'),
(132, 2, 'D2', 'Premium', 'Available'),
(133, 2, 'D3', 'Premium', 'Available'),
(134, 2, 'D4', 'Premium', 'Available'),
(135, 2, 'D5', 'Premium', 'Available'),
(136, 2, 'D6', 'Premium', 'Available'),
(137, 2, 'D7', 'Premium', 'Available'),
(138, 2, 'D8', 'Premium', 'Available'),
(139, 2, 'D9', 'Premium', 'Available'),
(140, 2, 'D10', 'Premium', 'Available'),
(141, 2, 'E1', 'Premium', 'Available'),
(142, 2, 'E2', 'Premium', 'Available'),
(143, 2, 'E3', 'Premium', 'Available'),
(144, 2, 'E4', 'Premium', 'Available'),
(145, 2, 'E5', 'Premium', 'Available'),
(146, 2, 'E6', 'Premium', 'Available'),
(147, 2, 'E7', 'Premium', 'Available'),
(148, 2, 'E8', 'Premium', 'Available'),
(149, 2, 'E9', 'Premium', 'Available'),
(150, 2, 'E10', 'Premium', 'Available'),
(151, 2, 'F1', 'Standard', 'Available'),
(152, 2, 'F2', 'Standard', 'Available'),
(153, 2, 'F3', 'Standard', 'Available'),
(154, 2, 'F4', 'Standard', 'Available'),
(155, 2, 'F5', 'Standard', 'Available'),
(156, 2, 'F6', 'Standard', 'Available'),
(157, 2, 'F7', 'Standard', 'Available'),
(158, 2, 'F8', 'Standard', 'Available'),
(159, 2, 'F9', 'Standard', 'Available'),
(160, 2, 'F10', 'Standard', 'Available'),
(161, 2, 'G1', 'Standard', 'Available'),
(162, 2, 'G2', 'Standard', 'Available'),
(163, 2, 'G3', 'Standard', 'Available'),
(164, 2, 'G4', 'Standard', 'Available'),
(165, 2, 'G5', 'Standard', 'Available'),
(166, 2, 'G6', 'Standard', 'Available'),
(167, 2, 'G7', 'Standard', 'Available'),
(168, 2, 'G8', 'Standard', 'Available'),
(169, 2, 'G9', 'Standard', 'Available'),
(170, 2, 'G10', 'Standard', 'Available'),
(171, 2, 'H1', 'Standard', 'Available'),
(172, 2, 'H2', 'Standard', 'Available'),
(173, 2, 'H3', 'Standard', 'Available'),
(174, 2, 'H4', 'Standard', 'Available'),
(175, 2, 'H5', 'Standard', 'Available'),
(176, 2, 'H6', 'Standard', 'Available'),
(177, 2, 'H7', 'Standard', 'Available'),
(178, 2, 'H8', 'Standard', 'Available'),
(179, 2, 'H9', 'Standard', 'Available'),
(180, 2, 'H10', 'Standard', 'Available'),
(181, 2, 'I1', 'Standard', 'Available'),
(182, 2, 'I2', 'Standard', 'Available'),
(183, 2, 'I3', 'Standard', 'Available'),
(184, 2, 'I4', 'Standard', 'Available'),
(185, 2, 'I5', 'Standard', 'Available'),
(186, 2, 'I6', 'Standard', 'Available'),
(187, 2, 'I7', 'Standard', 'Available'),
(188, 2, 'I8', 'Standard', 'Available'),
(189, 2, 'I9', 'Standard', 'Available'),
(190, 2, 'I10', 'Standard', 'Available'),
(191, 2, 'J1', 'Standard', 'Available'),
(192, 2, 'J2', 'Standard', 'Available'),
(193, 2, 'J3', 'Standard', 'Available'),
(194, 2, 'J4', 'Standard', 'Available'),
(195, 2, 'J5', 'Standard', 'Available'),
(196, 2, 'J6', 'Standard', 'Available'),
(197, 2, 'J7', 'Standard', 'Available'),
(198, 2, 'J8', 'Standard', 'Available'),
(199, 2, 'J9', 'Standard', 'Available'),
(200, 2, 'J10', 'Standard', 'Available'),
(201, 3, 'A1', 'Premium', 'Available'),
(202, 3, 'A2', 'Premium', 'Available'),
(203, 3, 'A3', 'Premium', 'Available'),
(204, 3, 'A4', 'Premium', 'Available'),
(205, 3, 'A5', 'Premium', 'Available'),
(206, 3, 'A6', 'Premium', 'Available'),
(207, 3, 'A7', 'Premium', 'Available'),
(208, 3, 'A8', 'Premium', 'Available'),
(209, 3, 'A9', 'Premium', 'Available'),
(210, 3, 'A10', 'Premium', 'Available'),
(211, 3, 'B1', 'Premium', 'Available'),
(212, 3, 'B2', 'Premium', 'Available'),
(213, 3, 'B3', 'Premium', 'Available'),
(214, 3, 'B4', 'Premium', 'Available'),
(215, 3, 'B5', 'Premium', 'Available'),
(216, 3, 'B6', 'Premium', 'Available'),
(217, 3, 'B7', 'Premium', 'Available'),
(218, 3, 'B8', 'Premium', 'Available'),
(219, 3, 'B9', 'Premium', 'Available'),
(220, 3, 'B10', 'Premium', 'Available'),
(221, 3, 'C1', 'Premium', 'Available'),
(222, 3, 'C2', 'Premium', 'Available'),
(223, 3, 'C3', 'Premium', 'Available'),
(224, 3, 'C4', 'Premium', 'Available'),
(225, 3, 'C5', 'Premium', 'Available'),
(226, 3, 'C6', 'Premium', 'Available'),
(227, 3, 'C7', 'Premium', 'Available'),
(228, 3, 'C8', 'Premium', 'Available'),
(229, 3, 'C9', 'Premium', 'Available'),
(230, 3, 'C10', 'Premium', 'Available'),
(231, 3, 'D1', 'Premium', 'Available'),
(232, 3, 'D2', 'Premium', 'Available'),
(233, 3, 'D3', 'Premium', 'Available'),
(234, 3, 'D4', 'Premium', 'Available'),
(235, 3, 'D5', 'Premium', 'Available'),
(236, 3, 'D6', 'Premium', 'Available'),
(237, 3, 'D7', 'Premium', 'Available'),
(238, 3, 'D8', 'Premium', 'Available'),
(239, 3, 'D9', 'Premium', 'Available'),
(240, 3, 'D10', 'Premium', 'Available'),
(241, 3, 'E1', 'Premium', 'Available'),
(242, 3, 'E2', 'Premium', 'Available'),
(243, 3, 'E3', 'Premium', 'Available'),
(244, 3, 'E4', 'Premium', 'Available'),
(245, 3, 'E5', 'Premium', 'Available'),
(246, 3, 'E6', 'Premium', 'Available'),
(247, 3, 'E7', 'Premium', 'Available'),
(248, 3, 'E8', 'Premium', 'Available'),
(249, 3, 'E9', 'Premium', 'Available'),
(250, 3, 'E10', 'Premium', 'Available'),
(251, 3, 'F1', 'Standard', 'Available'),
(252, 3, 'F2', 'Standard', 'Available'),
(253, 3, 'F3', 'Standard', 'Available'),
(254, 3, 'F4', 'Standard', 'Available'),
(255, 3, 'F5', 'Standard', 'Available'),
(256, 3, 'F6', 'Standard', 'Available'),
(257, 3, 'F7', 'Standard', 'Available'),
(258, 3, 'F8', 'Standard', 'Available'),
(259, 3, 'F9', 'Standard', 'Available'),
(260, 3, 'F10', 'Standard', 'Available'),
(261, 3, 'G1', 'Standard', 'Available'),
(262, 3, 'G2', 'Standard', 'Available'),
(263, 3, 'G3', 'Standard', 'Available'),
(264, 3, 'G4', 'Standard', 'Available'),
(265, 3, 'G5', 'Standard', 'Available'),
(266, 3, 'G6', 'Standard', 'Available'),
(267, 3, 'G7', 'Standard', 'Available'),
(268, 3, 'G8', 'Standard', 'Available'),
(269, 3, 'G9', 'Standard', 'Available'),
(270, 3, 'G10', 'Standard', 'Available'),
(271, 3, 'H1', 'Standard', 'Available'),
(272, 3, 'H2', 'Standard', 'Available'),
(273, 3, 'H3', 'Standard', 'Available'),
(274, 3, 'H4', 'Standard', 'Available'),
(275, 3, 'H5', 'Standard', 'Available'),
(276, 3, 'H6', 'Standard', 'Available'),
(277, 3, 'H7', 'Standard', 'Available'),
(278, 3, 'H8', 'Standard', 'Available'),
(279, 3, 'H9', 'Standard', 'Available'),
(280, 3, 'H10', 'Standard', 'Available'),
(281, 3, 'I1', 'Standard', 'Available'),
(282, 3, 'I2', 'Standard', 'Available'),
(283, 3, 'I3', 'Standard', 'Available'),
(284, 3, 'I4', 'Standard', 'Available'),
(285, 3, 'I5', 'Standard', 'Available'),
(286, 3, 'I6', 'Standard', 'Available'),
(287, 3, 'I7', 'Standard', 'Available'),
(288, 3, 'I8', 'Standard', 'Available'),
(289, 3, 'I9', 'Standard', 'Available'),
(290, 3, 'I10', 'Standard', 'Available'),
(291, 3, 'J1', 'Standard', 'Available'),
(292, 3, 'J2', 'Standard', 'Available'),
(293, 3, 'J3', 'Standard', 'Available'),
(294, 3, 'J4', 'Standard', 'Available'),
(295, 3, 'J5', 'Standard', 'Available'),
(296, 3, 'J6', 'Standard', 'Available'),
(297, 3, 'J7', 'Standard', 'Available'),
(298, 3, 'J8', 'Standard', 'Available'),
(299, 3, 'J9', 'Standard', 'Available'),
(300, 3, 'J10', 'Standard', 'Available'),
(301, 4, 'A1', 'Premium', 'Available'),
(302, 4, 'A2', 'Premium', 'Available'),
(303, 4, 'A3', 'Premium', 'Available'),
(304, 4, 'A4', 'Premium', 'Available'),
(305, 4, 'A5', 'Premium', 'Available'),
(306, 4, 'A6', 'Premium', 'Available'),
(307, 4, 'A7', 'Premium', 'Available'),
(308, 4, 'A8', 'Premium', 'Available'),
(309, 4, 'A9', 'Premium', 'Available'),
(310, 4, 'A10', 'Premium', 'Available'),
(311, 4, 'A11', 'Premium', 'Available'),
(312, 4, 'A12', 'Premium', 'Available'),
(313, 4, 'A13', 'Premium', 'Available'),
(314, 4, 'A14', 'Premium', 'Available'),
(315, 4, 'A15', 'Premium', 'Available'),
(316, 4, 'A16', 'Premium', 'Available'),
(317, 4, 'A17', 'Premium', 'Available'),
(318, 4, 'A18', 'Premium', 'Available'),
(319, 4, 'A19', 'Premium', 'Available'),
(320, 4, 'A20', 'Premium', 'Available'),
(321, 4, 'B1', 'Premium', 'Available'),
(322, 4, 'B2', 'Premium', 'Available'),
(323, 4, 'B3', 'Premium', 'Available'),
(324, 4, 'B4', 'Premium', 'Available'),
(325, 4, 'B5', 'Premium', 'Available'),
(326, 4, 'B6', 'Premium', 'Available'),
(327, 4, 'B7', 'Premium', 'Available'),
(328, 4, 'B8', 'Premium', 'Available'),
(329, 4, 'B9', 'Premium', 'Available'),
(330, 4, 'B10', 'Premium', 'Available'),
(331, 4, 'B11', 'Premium', 'Available'),
(332, 4, 'B12', 'Premium', 'Available'),
(333, 4, 'B13', 'Premium', 'Available'),
(334, 4, 'B14', 'Premium', 'Available'),
(335, 4, 'B15', 'Premium', 'Available'),
(336, 4, 'B16', 'Premium', 'Available'),
(337, 4, 'B17', 'Premium', 'Available'),
(338, 4, 'B18', 'Premium', 'Available'),
(339, 4, 'B19', 'Premium', 'Available'),
(340, 4, 'B20', 'Premium', 'Available'),
(341, 4, 'C1', 'Premium', 'Available'),
(342, 4, 'C2', 'Premium', 'Available'),
(343, 4, 'C3', 'Premium', 'Available'),
(344, 4, 'C4', 'Premium', 'Available'),
(345, 4, 'C5', 'Premium', 'Available'),
(346, 4, 'C6', 'Premium', 'Available'),
(347, 4, 'C7', 'Premium', 'Available'),
(348, 4, 'C8', 'Premium', 'Available'),
(349, 4, 'C9', 'Premium', 'Available'),
(350, 4, 'C10', 'Premium', 'Available'),
(351, 4, 'C11', 'Premium', 'Available'),
(352, 4, 'C12', 'Premium', 'Available'),
(353, 4, 'C13', 'Premium', 'Available'),
(354, 4, 'C14', 'Premium', 'Available'),
(355, 4, 'C15', 'Premium', 'Available'),
(356, 4, 'C16', 'Premium', 'Available'),
(357, 4, 'C17', 'Premium', 'Available'),
(358, 4, 'C18', 'Premium', 'Available'),
(359, 4, 'C19', 'Premium', 'Available'),
(360, 4, 'C20', 'Premium', 'Available'),
(361, 4, 'D1', 'Premium', 'Available'),
(362, 4, 'D2', 'Premium', 'Available'),
(363, 4, 'D3', 'Premium', 'Available'),
(364, 4, 'D4', 'Premium', 'Available'),
(365, 4, 'D5', 'Premium', 'Available'),
(366, 4, 'D6', 'Premium', 'Available'),
(367, 4, 'D7', 'Premium', 'Available'),
(368, 4, 'D8', 'Premium', 'Available'),
(369, 4, 'D9', 'Premium', 'Available'),
(370, 4, 'D10', 'Premium', 'Available'),
(371, 4, 'D11', 'Premium', 'Available'),
(372, 4, 'D12', 'Premium', 'Available'),
(373, 4, 'D13', 'Premium', 'Available'),
(374, 4, 'D14', 'Premium', 'Available'),
(375, 4, 'D15', 'Premium', 'Available'),
(376, 4, 'D16', 'Premium', 'Available'),
(377, 4, 'D17', 'Premium', 'Available'),
(378, 4, 'D18', 'Premium', 'Available'),
(379, 4, 'D19', 'Premium', 'Available'),
(380, 4, 'D20', 'Premium', 'Available'),
(381, 4, 'E1', 'Premium', 'Available'),
(382, 4, 'E2', 'Premium', 'Available'),
(383, 4, 'E3', 'Premium', 'Available'),
(384, 4, 'E4', 'Premium', 'Available'),
(385, 4, 'E5', 'Premium', 'Available'),
(386, 4, 'E6', 'Premium', 'Available'),
(387, 4, 'E7', 'Premium', 'Available'),
(388, 4, 'E8', 'Premium', 'Available'),
(389, 4, 'E9', 'Premium', 'Available'),
(390, 4, 'E10', 'Premium', 'Available'),
(391, 4, 'E11', 'Premium', 'Available'),
(392, 4, 'E12', 'Premium', 'Available'),
(393, 4, 'E13', 'Premium', 'Available'),
(394, 4, 'E14', 'Premium', 'Available'),
(395, 4, 'E15', 'Premium', 'Available'),
(396, 4, 'E16', 'Premium', 'Available'),
(397, 4, 'E17', 'Premium', 'Available'),
(398, 4, 'E18', 'Premium', 'Available'),
(399, 4, 'E19', 'Premium', 'Available'),
(400, 4, 'E20', 'Premium', 'Available'),
(401, 4, 'F1', 'Standard', 'Available'),
(402, 4, 'F2', 'Standard', 'Available'),
(403, 4, 'F3', 'Standard', 'Available'),
(404, 4, 'F4', 'Standard', 'Available'),
(405, 4, 'F5', 'Standard', 'Available'),
(406, 4, 'F6', 'Standard', 'Available'),
(407, 4, 'F7', 'Standard', 'Available'),
(408, 4, 'F8', 'Standard', 'Available'),
(409, 4, 'F9', 'Standard', 'Available'),
(410, 4, 'F10', 'Standard', 'Available'),
(411, 4, 'F11', 'Standard', 'Available'),
(412, 4, 'F12', 'Standard', 'Available'),
(413, 4, 'F13', 'Standard', 'Available'),
(414, 4, 'F14', 'Standard', 'Available'),
(415, 4, 'F15', 'Standard', 'Available'),
(416, 4, 'F16', 'Standard', 'Available'),
(417, 4, 'F17', 'Standard', 'Available'),
(418, 4, 'F18', 'Standard', 'Available'),
(419, 4, 'F19', 'Standard', 'Available'),
(420, 4, 'F20', 'Standard', 'Available'),
(421, 4, 'G1', 'Standard', 'Available'),
(422, 4, 'G2', 'Standard', 'Available'),
(423, 4, 'G3', 'Standard', 'Available'),
(424, 4, 'G4', 'Standard', 'Available'),
(425, 4, 'G5', 'Standard', 'Available'),
(426, 4, 'G6', 'Standard', 'Available'),
(427, 4, 'G7', 'Standard', 'Available'),
(428, 4, 'G8', 'Standard', 'Available'),
(429, 4, 'G9', 'Standard', 'Available'),
(430, 4, 'G10', 'Standard', 'Available'),
(431, 4, 'G11', 'Standard', 'Available'),
(432, 4, 'G12', 'Standard', 'Available'),
(433, 4, 'G13', 'Standard', 'Available'),
(434, 4, 'G14', 'Standard', 'Available'),
(435, 4, 'G15', 'Standard', 'Available'),
(436, 4, 'G16', 'Standard', 'Available'),
(437, 4, 'G17', 'Standard', 'Available'),
(438, 4, 'G18', 'Standard', 'Available'),
(439, 4, 'G19', 'Standard', 'Available'),
(440, 4, 'G20', 'Standard', 'Available'),
(441, 4, 'H1', 'Standard', 'Available'),
(442, 4, 'H2', 'Standard', 'Available'),
(443, 4, 'H3', 'Standard', 'Available'),
(444, 4, 'H4', 'Standard', 'Available'),
(445, 4, 'H5', 'Standard', 'Available'),
(446, 4, 'H6', 'Standard', 'Available'),
(447, 4, 'H7', 'Standard', 'Available'),
(448, 4, 'H8', 'Standard', 'Available'),
(449, 4, 'H9', 'Standard', 'Available'),
(450, 4, 'H10', 'Standard', 'Available'),
(451, 4, 'H11', 'Standard', 'Available'),
(452, 4, 'H12', 'Standard', 'Available'),
(453, 4, 'H13', 'Standard', 'Available'),
(454, 4, 'H14', 'Standard', 'Available'),
(455, 4, 'H15', 'Standard', 'Available'),
(456, 4, 'H16', 'Standard', 'Available'),
(457, 4, 'H17', 'Standard', 'Available'),
(458, 4, 'H18', 'Standard', 'Available'),
(459, 4, 'H19', 'Standard', 'Available'),
(460, 4, 'H20', 'Standard', 'Available'),
(461, 4, 'I1', 'Standard', 'Available'),
(462, 4, 'I2', 'Standard', 'Available'),
(463, 4, 'I3', 'Standard', 'Available'),
(464, 4, 'I4', 'Standard', 'Available'),
(465, 4, 'I5', 'Standard', 'Available'),
(466, 4, 'I6', 'Standard', 'Available'),
(467, 4, 'I7', 'Standard', 'Available'),
(468, 4, 'I8', 'Standard', 'Available'),
(469, 4, 'I9', 'Standard', 'Available'),
(470, 4, 'I10', 'Standard', 'Available'),
(471, 4, 'I11', 'Standard', 'Available'),
(472, 4, 'I12', 'Standard', 'Available'),
(473, 4, 'I13', 'Standard', 'Available'),
(474, 4, 'I14', 'Standard', 'Available'),
(475, 4, 'I15', 'Standard', 'Available'),
(476, 4, 'I16', 'Standard', 'Available'),
(477, 4, 'I17', 'Standard', 'Available'),
(478, 4, 'I18', 'Standard', 'Available'),
(479, 4, 'I19', 'Standard', 'Available'),
(480, 4, 'I20', 'Standard', 'Available'),
(481, 4, 'J1', 'Standard', 'Available'),
(482, 4, 'J2', 'Standard', 'Available'),
(483, 4, 'J3', 'Standard', 'Available'),
(484, 4, 'J4', 'Standard', 'Available'),
(485, 4, 'J5', 'Standard', 'Available'),
(486, 4, 'J6', 'Standard', 'Available'),
(487, 4, 'J7', 'Standard', 'Available'),
(488, 4, 'J8', 'Standard', 'Available'),
(489, 4, 'J9', 'Standard', 'Available'),
(490, 4, 'J10', 'Standard', 'Available'),
(491, 4, 'J11', 'Standard', 'Available'),
(492, 4, 'J12', 'Standard', 'Available'),
(493, 4, 'J13', 'Standard', 'Available'),
(494, 4, 'J14', 'Standard', 'Available'),
(495, 4, 'J15', 'Standard', 'Available'),
(496, 4, 'J16', 'Standard', 'Available'),
(497, 4, 'J17', 'Standard', 'Available'),
(498, 4, 'J18', 'Standard', 'Available'),
(499, 4, 'J19', 'Standard', 'Available'),
(500, 4, 'J20', 'Standard', 'Available'),
(501, 5, 'A1', 'Premium', 'Available'),
(502, 5, 'A2', 'Premium', 'Available'),
(503, 5, 'A3', 'Premium', 'Available'),
(504, 5, 'A4', 'Premium', 'Available'),
(505, 5, 'A5', 'Premium', 'Available'),
(506, 5, 'A6', 'Premium', 'Available'),
(507, 5, 'A7', 'Premium', 'Available'),
(508, 5, 'A8', 'Premium', 'Available'),
(509, 5, 'A9', 'Premium', 'Available'),
(510, 5, 'A10', 'Premium', 'Available'),
(511, 5, 'A11', 'Premium', 'Available'),
(512, 5, 'A12', 'Premium', 'Available'),
(513, 5, 'A13', 'Premium', 'Available'),
(514, 5, 'A14', 'Premium', 'Available'),
(515, 5, 'A15', 'Premium', 'Available'),
(516, 5, 'A16', 'Premium', 'Available'),
(517, 5, 'A17', 'Premium', 'Available'),
(518, 5, 'A18', 'Premium', 'Available'),
(519, 5, 'A19', 'Premium', 'Available'),
(520, 5, 'A20', 'Premium', 'Available'),
(521, 5, 'B1', 'Premium', 'Available'),
(522, 5, 'B2', 'Premium', 'Available'),
(523, 5, 'B3', 'Premium', 'Available'),
(524, 5, 'B4', 'Premium', 'Available'),
(525, 5, 'B5', 'Premium', 'Available'),
(526, 5, 'B6', 'Premium', 'Available'),
(527, 5, 'B7', 'Premium', 'Available'),
(528, 5, 'B8', 'Premium', 'Available'),
(529, 5, 'B9', 'Premium', 'Available'),
(530, 5, 'B10', 'Premium', 'Available'),
(531, 5, 'B11', 'Premium', 'Available'),
(532, 5, 'B12', 'Premium', 'Available'),
(533, 5, 'B13', 'Premium', 'Available'),
(534, 5, 'B14', 'Premium', 'Available'),
(535, 5, 'B15', 'Premium', 'Available'),
(536, 5, 'B16', 'Premium', 'Available'),
(537, 5, 'B17', 'Premium', 'Available'),
(538, 5, 'B18', 'Premium', 'Available'),
(539, 5, 'B19', 'Premium', 'Available'),
(540, 5, 'B20', 'Premium', 'Available'),
(541, 5, 'C1', 'Premium', 'Available'),
(542, 5, 'C2', 'Premium', 'Available'),
(543, 5, 'C3', 'Premium', 'Available'),
(544, 5, 'C4', 'Premium', 'Available'),
(545, 5, 'C5', 'Premium', 'Available'),
(546, 5, 'C6', 'Premium', 'Available'),
(547, 5, 'C7', 'Premium', 'Available'),
(548, 5, 'C8', 'Premium', 'Available'),
(549, 5, 'C9', 'Premium', 'Available'),
(550, 5, 'C10', 'Premium', 'Available'),
(551, 5, 'C11', 'Premium', 'Available'),
(552, 5, 'C12', 'Premium', 'Available'),
(553, 5, 'C13', 'Premium', 'Available'),
(554, 5, 'C14', 'Premium', 'Available'),
(555, 5, 'C15', 'Premium', 'Available'),
(556, 5, 'C16', 'Premium', 'Available'),
(557, 5, 'C17', 'Premium', 'Available'),
(558, 5, 'C18', 'Premium', 'Available'),
(559, 5, 'C19', 'Premium', 'Available'),
(560, 5, 'C20', 'Premium', 'Available'),
(561, 5, 'D1', 'Premium', 'Available'),
(562, 5, 'D2', 'Premium', 'Available'),
(563, 5, 'D3', 'Premium', 'Available'),
(564, 5, 'D4', 'Premium', 'Available'),
(565, 5, 'D5', 'Premium', 'Available'),
(566, 5, 'D6', 'Premium', 'Available'),
(567, 5, 'D7', 'Premium', 'Available'),
(568, 5, 'D8', 'Premium', 'Available'),
(569, 5, 'D9', 'Premium', 'Available'),
(570, 5, 'D10', 'Premium', 'Available'),
(571, 5, 'D11', 'Premium', 'Available'),
(572, 5, 'D12', 'Premium', 'Available'),
(573, 5, 'D13', 'Premium', 'Available'),
(574, 5, 'D14', 'Premium', 'Available'),
(575, 5, 'D15', 'Premium', 'Available'),
(576, 5, 'D16', 'Premium', 'Available'),
(577, 5, 'D17', 'Premium', 'Available'),
(578, 5, 'D18', 'Premium', 'Available'),
(579, 5, 'D19', 'Premium', 'Available'),
(580, 5, 'D20', 'Premium', 'Available'),
(581, 5, 'E1', 'Premium', 'Available'),
(582, 5, 'E2', 'Premium', 'Available'),
(583, 5, 'E3', 'Premium', 'Available'),
(584, 5, 'E4', 'Premium', 'Available'),
(585, 5, 'E5', 'Premium', 'Available'),
(586, 5, 'E6', 'Premium', 'Available'),
(587, 5, 'E7', 'Premium', 'Available'),
(588, 5, 'E8', 'Premium', 'Available'),
(589, 5, 'E9', 'Premium', 'Available'),
(590, 5, 'E10', 'Premium', 'Available'),
(591, 5, 'E11', 'Premium', 'Available'),
(592, 5, 'E12', 'Premium', 'Available'),
(593, 5, 'E13', 'Premium', 'Available'),
(594, 5, 'E14', 'Premium', 'Available'),
(595, 5, 'E15', 'Premium', 'Available'),
(596, 5, 'E16', 'Premium', 'Available'),
(597, 5, 'E17', 'Premium', 'Available'),
(598, 5, 'E18', 'Premium', 'Available'),
(599, 5, 'E19', 'Premium', 'Available'),
(600, 5, 'E20', 'Premium', 'Available'),
(601, 5, 'F1', 'Standard', 'Available'),
(602, 5, 'F2', 'Standard', 'Available'),
(603, 5, 'F3', 'Standard', 'Available'),
(604, 5, 'F4', 'Standard', 'Available'),
(605, 5, 'F5', 'Standard', 'Available'),
(606, 5, 'F6', 'Standard', 'Available'),
(607, 5, 'F7', 'Standard', 'Available'),
(608, 5, 'F8', 'Standard', 'Available'),
(609, 5, 'F9', 'Standard', 'Available'),
(610, 5, 'F10', 'Standard', 'Available'),
(611, 5, 'F11', 'Standard', 'Available'),
(612, 5, 'F12', 'Standard', 'Available'),
(613, 5, 'F13', 'Standard', 'Available'),
(614, 5, 'F14', 'Standard', 'Available'),
(615, 5, 'F15', 'Standard', 'Available'),
(616, 5, 'F16', 'Standard', 'Available'),
(617, 5, 'F17', 'Standard', 'Available'),
(618, 5, 'F18', 'Standard', 'Available'),
(619, 5, 'F19', 'Standard', 'Available'),
(620, 5, 'F20', 'Standard', 'Available'),
(621, 5, 'G1', 'Standard', 'Available'),
(622, 5, 'G2', 'Standard', 'Available'),
(623, 5, 'G3', 'Standard', 'Available'),
(624, 5, 'G4', 'Standard', 'Available'),
(625, 5, 'G5', 'Standard', 'Available'),
(626, 5, 'G6', 'Standard', 'Available'),
(627, 5, 'G7', 'Standard', 'Available'),
(628, 5, 'G8', 'Standard', 'Available'),
(629, 5, 'G9', 'Standard', 'Available'),
(630, 5, 'G10', 'Standard', 'Available'),
(631, 5, 'G11', 'Standard', 'Available'),
(632, 5, 'G12', 'Standard', 'Available'),
(633, 5, 'G13', 'Standard', 'Available'),
(634, 5, 'G14', 'Standard', 'Available'),
(635, 5, 'G15', 'Standard', 'Available'),
(636, 5, 'G16', 'Standard', 'Available'),
(637, 5, 'G17', 'Standard', 'Available'),
(638, 5, 'G18', 'Standard', 'Available'),
(639, 5, 'G19', 'Standard', 'Available'),
(640, 5, 'G20', 'Standard', 'Available'),
(641, 5, 'H1', 'Standard', 'Available'),
(642, 5, 'H2', 'Standard', 'Available'),
(643, 5, 'H3', 'Standard', 'Available'),
(644, 5, 'H4', 'Standard', 'Available'),
(645, 5, 'H5', 'Standard', 'Available'),
(646, 5, 'H6', 'Standard', 'Available'),
(647, 5, 'H7', 'Standard', 'Available'),
(648, 5, 'H8', 'Standard', 'Available'),
(649, 5, 'H9', 'Standard', 'Available'),
(650, 5, 'H10', 'Standard', 'Available'),
(651, 5, 'H11', 'Standard', 'Available'),
(652, 5, 'H12', 'Standard', 'Available'),
(653, 5, 'H13', 'Standard', 'Available'),
(654, 5, 'H14', 'Standard', 'Available'),
(655, 5, 'H15', 'Standard', 'Available'),
(656, 5, 'H16', 'Standard', 'Available'),
(657, 5, 'H17', 'Standard', 'Available'),
(658, 5, 'H18', 'Standard', 'Available'),
(659, 5, 'H19', 'Standard', 'Available'),
(660, 5, 'H20', 'Standard', 'Available'),
(661, 5, 'I1', 'Standard', 'Available'),
(662, 5, 'I2', 'Standard', 'Available'),
(663, 5, 'I3', 'Standard', 'Available'),
(664, 5, 'I4', 'Standard', 'Available'),
(665, 5, 'I5', 'Standard', 'Available'),
(666, 5, 'I6', 'Standard', 'Available'),
(667, 5, 'I7', 'Standard', 'Available'),
(668, 5, 'I8', 'Standard', 'Available'),
(669, 5, 'I9', 'Standard', 'Available'),
(670, 5, 'I10', 'Standard', 'Available'),
(671, 5, 'I11', 'Standard', 'Available'),
(672, 5, 'I12', 'Standard', 'Available'),
(673, 5, 'I13', 'Standard', 'Available'),
(674, 5, 'I14', 'Standard', 'Available'),
(675, 5, 'I15', 'Standard', 'Available'),
(676, 5, 'I16', 'Standard', 'Available'),
(677, 5, 'I17', 'Standard', 'Available'),
(678, 5, 'I18', 'Standard', 'Available'),
(679, 5, 'I19', 'Standard', 'Available'),
(680, 5, 'I20', 'Standard', 'Available'),
(681, 5, 'J1', 'Standard', 'Available'),
(682, 5, 'J2', 'Standard', 'Available'),
(683, 5, 'J3', 'Standard', 'Available'),
(684, 5, 'J4', 'Standard', 'Available'),
(685, 5, 'J5', 'Standard', 'Available'),
(686, 5, 'J6', 'Standard', 'Available'),
(687, 5, 'J7', 'Standard', 'Available'),
(688, 5, 'J8', 'Standard', 'Available'),
(689, 5, 'J9', 'Standard', 'Available'),
(690, 5, 'J10', 'Standard', 'Available'),
(691, 5, 'J11', 'Standard', 'Available'),
(692, 5, 'J12', 'Standard', 'Available'),
(693, 5, 'J13', 'Standard', 'Available'),
(694, 5, 'J14', 'Standard', 'Available'),
(695, 5, 'J15', 'Standard', 'Available'),
(696, 5, 'J16', 'Standard', 'Available'),
(697, 5, 'J17', 'Standard', 'Available'),
(698, 5, 'J18', 'Standard', 'Available'),
(699, 5, 'J19', 'Standard', 'Available'),
(700, 5, 'J20', 'Standard', 'Available'),
(701, 6, 'A1', 'Premium', 'Available'),
(702, 6, 'A2', 'Premium', 'Available'),
(703, 6, 'A3', 'Premium', 'Available'),
(704, 6, 'A4', 'Premium', 'Available'),
(705, 6, 'A5', 'Premium', 'Available'),
(706, 6, 'A6', 'Premium', 'Available'),
(707, 6, 'A7', 'Premium', 'Available'),
(708, 6, 'A8', 'Premium', 'Available'),
(709, 6, 'A9', 'Premium', 'Available'),
(710, 6, 'A10', 'Premium', 'Available'),
(711, 6, 'A11', 'Premium', 'Available'),
(712, 6, 'A12', 'Premium', 'Available'),
(713, 6, 'A13', 'Premium', 'Available'),
(714, 6, 'A14', 'Premium', 'Available'),
(715, 6, 'A15', 'Premium', 'Available'),
(716, 6, 'A16', 'Premium', 'Available'),
(717, 6, 'A17', 'Premium', 'Available'),
(718, 6, 'A18', 'Premium', 'Available'),
(719, 6, 'A19', 'Premium', 'Available'),
(720, 6, 'A20', 'Premium', 'Available'),
(721, 6, 'B1', 'Premium', 'Available'),
(722, 6, 'B2', 'Premium', 'Available'),
(723, 6, 'B3', 'Premium', 'Available'),
(724, 6, 'B4', 'Premium', 'Available'),
(725, 6, 'B5', 'Premium', 'Available'),
(726, 6, 'B6', 'Premium', 'Available'),
(727, 6, 'B7', 'Premium', 'Available'),
(728, 6, 'B8', 'Premium', 'Available'),
(729, 6, 'B9', 'Premium', 'Available'),
(730, 6, 'B10', 'Premium', 'Available'),
(731, 6, 'B11', 'Premium', 'Available'),
(732, 6, 'B12', 'Premium', 'Available'),
(733, 6, 'B13', 'Premium', 'Available'),
(734, 6, 'B14', 'Premium', 'Available'),
(735, 6, 'B15', 'Premium', 'Available'),
(736, 6, 'B16', 'Premium', 'Available'),
(737, 6, 'B17', 'Premium', 'Available'),
(738, 6, 'B18', 'Premium', 'Available'),
(739, 6, 'B19', 'Premium', 'Available'),
(740, 6, 'B20', 'Premium', 'Available'),
(741, 6, 'C1', 'Premium', 'Available'),
(742, 6, 'C2', 'Premium', 'Available'),
(743, 6, 'C3', 'Premium', 'Available'),
(744, 6, 'C4', 'Premium', 'Available'),
(745, 6, 'C5', 'Premium', 'Available'),
(746, 6, 'C6', 'Premium', 'Available'),
(747, 6, 'C7', 'Premium', 'Available'),
(748, 6, 'C8', 'Premium', 'Available'),
(749, 6, 'C9', 'Premium', 'Available'),
(750, 6, 'C10', 'Premium', 'Available'),
(751, 6, 'C11', 'Premium', 'Available'),
(752, 6, 'C12', 'Premium', 'Available'),
(753, 6, 'C13', 'Premium', 'Available'),
(754, 6, 'C14', 'Premium', 'Available'),
(755, 6, 'C15', 'Premium', 'Available'),
(756, 6, 'C16', 'Premium', 'Available'),
(757, 6, 'C17', 'Premium', 'Available'),
(758, 6, 'C18', 'Premium', 'Available'),
(759, 6, 'C19', 'Premium', 'Available'),
(760, 6, 'C20', 'Premium', 'Available'),
(761, 6, 'D1', 'Premium', 'Available'),
(762, 6, 'D2', 'Premium', 'Available'),
(763, 6, 'D3', 'Premium', 'Available'),
(764, 6, 'D4', 'Premium', 'Available'),
(765, 6, 'D5', 'Premium', 'Available'),
(766, 6, 'D6', 'Premium', 'Available'),
(767, 6, 'D7', 'Premium', 'Available'),
(768, 6, 'D8', 'Premium', 'Available'),
(769, 6, 'D9', 'Premium', 'Available'),
(770, 6, 'D10', 'Premium', 'Available'),
(771, 6, 'D11', 'Premium', 'Available'),
(772, 6, 'D12', 'Premium', 'Available'),
(773, 6, 'D13', 'Premium', 'Available'),
(774, 6, 'D14', 'Premium', 'Available'),
(775, 6, 'D15', 'Premium', 'Available'),
(776, 6, 'D16', 'Premium', 'Available'),
(777, 6, 'D17', 'Premium', 'Available'),
(778, 6, 'D18', 'Premium', 'Available'),
(779, 6, 'D19', 'Premium', 'Available'),
(780, 6, 'D20', 'Premium', 'Available'),
(781, 6, 'E1', 'Premium', 'Available'),
(782, 6, 'E2', 'Premium', 'Available'),
(783, 6, 'E3', 'Premium', 'Available'),
(784, 6, 'E4', 'Premium', 'Available'),
(785, 6, 'E5', 'Premium', 'Available'),
(786, 6, 'E6', 'Premium', 'Available'),
(787, 6, 'E7', 'Premium', 'Available'),
(788, 6, 'E8', 'Premium', 'Available'),
(789, 6, 'E9', 'Premium', 'Available'),
(790, 6, 'E10', 'Premium', 'Available'),
(791, 6, 'E11', 'Premium', 'Available'),
(792, 6, 'E12', 'Premium', 'Available'),
(793, 6, 'E13', 'Premium', 'Available'),
(794, 6, 'E14', 'Premium', 'Available'),
(795, 6, 'E15', 'Premium', 'Available'),
(796, 6, 'E16', 'Premium', 'Available'),
(797, 6, 'E17', 'Premium', 'Available'),
(798, 6, 'E18', 'Premium', 'Available'),
(799, 6, 'E19', 'Premium', 'Available'),
(800, 6, 'E20', 'Premium', 'Available'),
(801, 6, 'F1', 'Standard', 'Available'),
(802, 6, 'F2', 'Standard', 'Available'),
(803, 6, 'F3', 'Standard', 'Available'),
(804, 6, 'F4', 'Standard', 'Available'),
(805, 6, 'F5', 'Standard', 'Available'),
(806, 6, 'F6', 'Standard', 'Available'),
(807, 6, 'F7', 'Standard', 'Available'),
(808, 6, 'F8', 'Standard', 'Available'),
(809, 6, 'F9', 'Standard', 'Available'),
(810, 6, 'F10', 'Standard', 'Available'),
(811, 6, 'F11', 'Standard', 'Available'),
(812, 6, 'F12', 'Standard', 'Available'),
(813, 6, 'F13', 'Standard', 'Available'),
(814, 6, 'F14', 'Standard', 'Available'),
(815, 6, 'F15', 'Standard', 'Available'),
(816, 6, 'F16', 'Standard', 'Available'),
(817, 6, 'F17', 'Standard', 'Available'),
(818, 6, 'F18', 'Standard', 'Available'),
(819, 6, 'F19', 'Standard', 'Available'),
(820, 6, 'F20', 'Standard', 'Available'),
(821, 6, 'G1', 'Standard', 'Available'),
(822, 6, 'G2', 'Standard', 'Available'),
(823, 6, 'G3', 'Standard', 'Available'),
(824, 6, 'G4', 'Standard', 'Available'),
(825, 6, 'G5', 'Standard', 'Available'),
(826, 6, 'G6', 'Standard', 'Available'),
(827, 6, 'G7', 'Standard', 'Available'),
(828, 6, 'G8', 'Standard', 'Available'),
(829, 6, 'G9', 'Standard', 'Available'),
(830, 6, 'G10', 'Standard', 'Available'),
(831, 6, 'G11', 'Standard', 'Available'),
(832, 6, 'G12', 'Standard', 'Available'),
(833, 6, 'G13', 'Standard', 'Available'),
(834, 6, 'G14', 'Standard', 'Available'),
(835, 6, 'G15', 'Standard', 'Available'),
(836, 6, 'G16', 'Standard', 'Available'),
(837, 6, 'G17', 'Standard', 'Available'),
(838, 6, 'G18', 'Standard', 'Available'),
(839, 6, 'G19', 'Standard', 'Available'),
(840, 6, 'G20', 'Standard', 'Available'),
(841, 6, 'H1', 'Standard', 'Available'),
(842, 6, 'H2', 'Standard', 'Available'),
(843, 6, 'H3', 'Standard', 'Available'),
(844, 6, 'H4', 'Standard', 'Available'),
(845, 6, 'H5', 'Standard', 'Available'),
(846, 6, 'H6', 'Standard', 'Available'),
(847, 6, 'H7', 'Standard', 'Available'),
(848, 6, 'H8', 'Standard', 'Available'),
(849, 6, 'H9', 'Standard', 'Available'),
(850, 6, 'H10', 'Standard', 'Available'),
(851, 6, 'H11', 'Standard', 'Available'),
(852, 6, 'H12', 'Standard', 'Available'),
(853, 6, 'H13', 'Standard', 'Available'),
(854, 6, 'H14', 'Standard', 'Available'),
(855, 6, 'H15', 'Standard', 'Available'),
(856, 6, 'H16', 'Standard', 'Available'),
(857, 6, 'H17', 'Standard', 'Available'),
(858, 6, 'H18', 'Standard', 'Available'),
(859, 6, 'H19', 'Standard', 'Available'),
(860, 6, 'H20', 'Standard', 'Available'),
(861, 6, 'I1', 'Standard', 'Available'),
(862, 6, 'I2', 'Standard', 'Available'),
(863, 6, 'I3', 'Standard', 'Available'),
(864, 6, 'I4', 'Standard', 'Available'),
(865, 6, 'I5', 'Standard', 'Available'),
(866, 6, 'I6', 'Standard', 'Available'),
(867, 6, 'I7', 'Standard', 'Available'),
(868, 6, 'I8', 'Standard', 'Available'),
(869, 6, 'I9', 'Standard', 'Available'),
(870, 6, 'I10', 'Standard', 'Available'),
(871, 6, 'I11', 'Standard', 'Available'),
(872, 6, 'I12', 'Standard', 'Available'),
(873, 6, 'I13', 'Standard', 'Available'),
(874, 6, 'I14', 'Standard', 'Available'),
(875, 6, 'I15', 'Standard', 'Available'),
(876, 6, 'I16', 'Standard', 'Available'),
(877, 6, 'I17', 'Standard', 'Available'),
(878, 6, 'I18', 'Standard', 'Available'),
(879, 6, 'I19', 'Standard', 'Available'),
(880, 6, 'I20', 'Standard', 'Available'),
(881, 6, 'J1', 'Standard', 'Available'),
(882, 6, 'J2', 'Standard', 'Available'),
(883, 6, 'J3', 'Standard', 'Available'),
(884, 6, 'J4', 'Standard', 'Available'),
(885, 6, 'J5', 'Standard', 'Available'),
(886, 6, 'J6', 'Standard', 'Available'),
(887, 6, 'J7', 'Standard', 'Available'),
(888, 6, 'J8', 'Standard', 'Available'),
(889, 6, 'J9', 'Standard', 'Available'),
(890, 6, 'J10', 'Standard', 'Available'),
(891, 6, 'J11', 'Standard', 'Available'),
(892, 6, 'J12', 'Standard', 'Available'),
(893, 6, 'J13', 'Standard', 'Available'),
(894, 6, 'J14', 'Standard', 'Available'),
(895, 6, 'J15', 'Standard', 'Available'),
(896, 6, 'J16', 'Standard', 'Available'),
(897, 6, 'J17', 'Standard', 'Available'),
(898, 6, 'J18', 'Standard', 'Available'),
(899, 6, 'J19', 'Standard', 'Available'),
(900, 6, 'J20', 'Standard', 'Available');


Insert Into Show (ShowID, MovieID, HallID, ShowDate, StartTime, EndTime, TicketSold) VALUES
(1, 1, 1, '2025-01-01', '09:00:00', '12:00:00', 20),
(2, 2, 1, '2025-01-01', '12:00:00', '15:00:00', 17),
(3, 3, 1, '2025-01-01', '15:00:00', '18:00:00', 11),
(4, 4, 1, '2025-01-01', '18:00:00', '21:00:00', 52),
(5, 5, 1, '2025-01-01', '21:00:00', '00:00:00', 14),
(6, 6, 2, '2025-01-01', '09:00:00', '12:00:00', 17),
(7, 7, 2, '2025-01-01', '12:00:00', '15:00:00', 40),
(8, 8, 2, '2025-01-01', '15:00:00', '18:00:00', 45),
(9, 9, 2, '2025-01-01', '18:00:00', '21:00:00', 30),
(10, 10, 2, '2025-01-01', '21:00:00', '00:00:00', 45),
(11, 11, 3, '2025-01-01', '09:00:00', '12:00:00', 77),
(12, 12, 3, '2025-01-01', '12:00:00', '15:00:00', 53),
(13, 13, 3, '2025-01-01', '15:00:00', '18:00:00', 30),
(14, 14, 3, '2025-01-01', '18:00:00', '21:00:00', 11),
(15, 15, 3, '2025-01-01', '21:00:00', '00:00:00', 30),
(16, 16, 4, '2025-01-01', '09:00:00', '12:00:00', 29),
(17, 17, 4, '2025-01-01', '12:00:00', '15:00:00', 154),
(18, 18, 4, '2025-01-01', '15:00:00', '18:00:00', 66),
(19, 19, 4, '2025-01-01', '18:00:00', '21:00:00', 134),
(20, 20, 4, '2025-01-01', '21:00:00', '00:00:00', 162),
(21, 21, 5, '2025-01-01', '09:00:00', '12:00:00', 32),
(22, 22, 5, '2025-01-01', '12:00:00', '15:00:00', 197),
(23, 23, 5, '2025-01-01', '15:00:00', '18:00:00', 163),
(24, 24, 5, '2025-01-01', '18:00:00', '21:00:00', 42),
(25, 25, 5, '2025-01-01', '21:00:00', '00:00:00', 170),
(26, 26, 6, '2025-01-01', '09:00:00', '12:00:00', 55),
(27, 27, 6, '2025-01-01', '12:00:00', '15:00:00', 109),
(28, 28, 6, '2025-01-01', '15:00:00', '18:00:00', 65),
(29, 29, 6, '2025-01-01', '18:00:00', '21:00:00', 25),
(30, 30, 6, '2025-01-01', '21:00:00', '00:00:00', 20),
(31, 31, 1, '2025-01-02', '09:00:00', '12:00:00', 98),
(32, 32, 1, '2025-01-02', '12:00:00', '15:00:00', 18),
(33, 33, 1, '2025-01-02', '15:00:00', '18:00:00', 23),
(34, 34, 1, '2025-01-02', '18:00:00', '21:00:00', 43),
(35, 35, 1, '2025-01-02', '21:00:00', '00:00:00', 17),
(36, 36, 2, '2025-01-02', '09:00:00', '12:00:00', 86),
(37, 37, 2, '2025-01-02', '12:00:00', '15:00:00', 41),
(38, 38, 2, '2025-01-02', '15:00:00', '18:00:00', 22),
(39, 39, 2, '2025-01-02', '18:00:00', '21:00:00', 15),
(40, 40, 2, '2025-01-02', '21:00:00', '00:00:00', 80),
(41, 41, 3, '2025-01-02', '09:00:00', '12:00:00', 84),
(42, 42, 3, '2025-01-02', '12:00:00', '15:00:00', 54),
(43, 43, 3, '2025-01-02', '15:00:00', '18:00:00', 49),
(44, 44, 3, '2025-01-02', '18:00:00', '21:00:00', 67),
(45, 45, 3, '2025-01-02', '21:00:00', '00:00:00', 49),
(46, 46, 4, '2025-01-02', '09:00:00', '12:00:00', 157),
(47, 47, 4, '2025-01-02', '12:00:00', '15:00:00', 32),
(48, 48, 4, '2025-01-02', '15:00:00', '18:00:00', 21),
(49, 49, 4, '2025-01-02', '18:00:00', '21:00:00', 166),
(50, 50, 4, '2025-01-02', '21:00:00', '00:00:00', 129),
(51, 51, 5, '2025-01-02', '09:00:00', '12:00:00', 72),
(52, 52, 5, '2025-01-02', '12:00:00', '15:00:00', 187),
(53, 53, 5, '2025-01-02', '15:00:00', '18:00:00', 154),
(54, 54, 5, '2025-01-02', '18:00:00', '21:00:00', 191),
(55, 55, 5, '2025-01-02', '21:00:00', '00:00:00', 32),
(56, 56, 6, '2025-01-02', '09:00:00', '12:00:00', 186),
(57, 57, 6, '2025-01-02', '12:00:00', '15:00:00', 96),
(58, 58, 6, '2025-01-02', '15:00:00', '18:00:00', 137),
(59, 59, 6, '2025-01-02', '18:00:00', '21:00:00', 137),
(60, 60, 6, '2025-01-02', '21:00:00', '00:00:00', 38),
(61, 61, 1, '2025-01-03', '09:00:00', '12:00:00', 16),
(62, 62, 1, '2025-01-03', '12:00:00', '15:00:00', 19),
(63, 63, 1, '2025-01-03', '15:00:00', '18:00:00', 91),
(64, 64, 1, '2025-01-03', '18:00:00', '21:00:00', 90),
(65, 65, 1, '2025-01-03', '21:00:00', '00:00:00', 70),
(66, 66, 2, '2025-01-03', '09:00:00', '12:00:00', 28),
(67, 67, 2, '2025-01-03', '12:00:00', '15:00:00', 60),
(68, 68, 2, '2025-01-03', '15:00:00', '18:00:00', 42),
(69, 69, 2, '2025-01-03', '18:00:00', '21:00:00', 24),
(70, 70, 2, '2025-01-03', '21:00:00', '00:00:00', 97),
(71, 71, 3, '2025-01-03', '09:00:00', '12:00:00', 13),
(72, 72, 3, '2025-01-03', '12:00:00', '15:00:00', 69),
(73, 73, 3, '2025-01-03', '15:00:00', '18:00:00', 24),
(74, 74, 3, '2025-01-03', '18:00:00', '21:00:00', 94),
(75, 75, 3, '2025-01-03', '21:00:00', '00:00:00', 21),
(76, 76, 4, '2025-01-03', '09:00:00', '12:00:00', 62),
(77, 77, 4, '2025-01-03', '12:00:00', '15:00:00', 47),
(78, 78, 4, '2025-01-03', '15:00:00', '18:00:00', 24),
(79, 79, 4, '2025-01-03', '18:00:00', '21:00:00', 161),
(80, 80, 4, '2025-01-03', '21:00:00', '00:00:00', 85),
(81, 81, 5, '2025-01-03', '09:00:00', '12:00:00', 195),
(82, 82, 5, '2025-01-03', '12:00:00', '15:00:00', 103),
(83, 83, 5, '2025-01-03', '15:00:00', '18:00:00', 162),
(84, 84, 5, '2025-01-03', '18:00:00', '21:00:00', 150),
(85, 85, 5, '2025-01-03', '21:00:00', '00:00:00', 109),
(86, 86, 6, '2025-01-03', '09:00:00', '12:00:00', 162),
(87, 87, 6, '2025-01-03', '12:00:00', '15:00:00', 57),
(88, 88, 6, '2025-01-03', '15:00:00', '18:00:00', 179),
(89, 89, 6, '2025-01-03', '18:00:00', '21:00:00', 118),
(90, 90, 6, '2025-01-03', '21:00:00', '00:00:00', 172),
(91, 91, 1, '2025-01-04', '09:00:00', '12:00:00', 49),
(92, 92, 1, '2025-01-04', '12:00:00', '15:00:00', 61),
(93, 93, 1, '2025-01-04', '15:00:00', '18:00:00', 18),
(94, 94, 1, '2025-01-04', '18:00:00', '21:00:00', 42),
(95, 95, 1, '2025-01-04', '21:00:00', '00:00:00', 34),
(96, 96, 2, '2025-01-04', '09:00:00', '12:00:00', 53),
(97, 97, 2, '2025-01-04', '12:00:00', '15:00:00', 58),
(98, 98, 2, '2025-01-04', '15:00:00', '18:00:00', 53),
(99, 99, 2, '2025-01-04', '18:00:00', '21:00:00', 17),
(100, 100, 2, '2025-01-04', '21:00:00', '00:00:00', 92),
(101, 1, 3, '2025-01-04', '09:00:00', '12:00:00', 54),
(102, 2, 3, '2025-01-04', '12:00:00', '15:00:00', 100),
(103, 3, 3, '2025-01-04', '15:00:00', '18:00:00', 16),
(104, 4, 3, '2025-01-04', '18:00:00', '21:00:00', 98),
(105, 5, 3, '2025-01-04', '21:00:00', '00:00:00', 59),
(106, 6, 4, '2025-01-04', '09:00:00', '12:00:00', 158),
(107, 7, 4, '2025-01-04', '12:00:00', '15:00:00', 136),
(108, 8, 4, '2025-01-04', '15:00:00', '18:00:00', 47),
(109, 9, 4, '2025-01-04', '18:00:00', '21:00:00', 108),
(110, 10, 4, '2025-01-04', '21:00:00', '00:00:00', 112),
(111, 11, 5, '2025-01-04', '09:00:00', '12:00:00', 163),
(112, 12, 5, '2025-01-04', '12:00:00', '15:00:00', 43),
(113, 13, 5, '2025-01-04', '15:00:00', '18:00:00', 133),
(114, 14, 5, '2025-01-04', '18:00:00', '21:00:00', 170),
(115, 15, 5, '2025-01-04', '21:00:00', '00:00:00', 106),
(116, 16, 6, '2025-01-04', '09:00:00', '12:00:00', 182),
(117, 17, 6, '2025-01-04', '12:00:00', '15:00:00', 141),
(118, 18, 6, '2025-01-04', '15:00:00', '18:00:00', 66),
(119, 19, 6, '2025-01-04', '18:00:00', '21:00:00', 115),
(120, 20, 6, '2025-01-04', '21:00:00', '00:00:00', 41),
(121, 21, 1, '2025-01-05', '09:00:00', '12:00:00', 28),
(122, 22, 1, '2025-01-05', '12:00:00', '15:00:00', 88),
(123, 23, 1, '2025-01-05', '15:00:00', '18:00:00', 96),
(124, 24, 1, '2025-01-05', '18:00:00', '21:00:00', 42),
(125, 25, 1, '2025-01-05', '21:00:00', '00:00:00', 47),
(126, 26, 2, '2025-01-05', '09:00:00', '12:00:00', 42),
(127, 27, 2, '2025-01-05', '12:00:00', '15:00:00', 82),
(128, 28, 2, '2025-01-05', '15:00:00', '18:00:00', 67),
(129, 29, 2, '2025-01-05', '18:00:00', '21:00:00', 79),
(130, 30, 2, '2025-01-05', '21:00:00', '00:00:00', 68),
(131, 31, 3, '2025-01-05', '09:00:00', '12:00:00', 36),
(132, 32, 3, '2025-01-05', '12:00:00', '15:00:00', 44),
(133, 33, 3, '2025-01-05', '15:00:00', '18:00:00', 97),
(134, 34, 3, '2025-01-05', '18:00:00', '21:00:00', 64),
(135, 35, 3, '2025-01-05', '21:00:00', '00:00:00', 12),
(136, 36, 4, '2025-01-05', '09:00:00', '12:00:00', 161),
(137, 37, 4, '2025-01-05', '12:00:00', '15:00:00', 42),
(138, 38, 4, '2025-01-05', '15:00:00', '18:00:00', 49),
(139, 39, 4, '2025-01-05', '18:00:00', '21:00:00', 42),
(140, 40, 4, '2025-01-05', '21:00:00', '00:00:00', 95),
(141, 41, 5, '2025-01-05', '09:00:00', '12:00:00', 60),
(142, 42, 5, '2025-01-05', '12:00:00', '15:00:00', 47),
(143, 43, 5, '2025-01-05', '15:00:00', '18:00:00', 57),
(144, 44, 5, '2025-01-05', '18:00:00', '21:00:00', 103),
(145, 45, 5, '2025-01-05', '21:00:00', '00:00:00', 178),
(146, 46, 6, '2025-01-05', '09:00:00', '12:00:00', 195),
(147, 47, 6, '2025-01-05', '12:00:00', '15:00:00', 146),
(148, 48, 6, '2025-01-05', '15:00:00', '18:00:00', 72),
(149, 49, 6, '2025-01-05', '18:00:00', '21:00:00', 32),
(150, 50, 6, '2025-01-05', '21:00:00', '00:00:00', 141),
(151, 51, 1, '2025-02-01', '09:00:00', '12:00:00', 92),
(152, 52, 1, '2025-02-01', '12:00:00', '15:00:00', 25),
(153, 53, 1, '2025-02-01', '15:00:00', '18:00:00', 85),
(154, 54, 1, '2025-02-01', '18:00:00', '21:00:00', 58),
(155, 55, 1, '2025-02-01', '21:00:00', '00:00:00', 90),
(156, 56, 2, '2025-02-01', '09:00:00', '12:00:00', 44),
(157, 57, 2, '2025-02-01', '12:00:00', '15:00:00', 14),
(158, 58, 2, '2025-02-01', '15:00:00', '18:00:00', 77),
(159, 59, 2, '2025-02-01', '18:00:00', '21:00:00', 34),
(160, 60, 2, '2025-02-01', '21:00:00', '00:00:00', 94),
(161, 61, 3, '2025-02-01', '09:00:00', '12:00:00', 93),
(162, 62, 3, '2025-02-01', '12:00:00', '15:00:00', 66),
(163, 63, 3, '2025-02-01', '15:00:00', '18:00:00', 53),
(164, 64, 3, '2025-02-01', '18:00:00', '21:00:00', 35),
(165, 65, 3, '2025-02-01', '21:00:00', '00:00:00', 49),
(166, 66, 4, '2025-02-01', '09:00:00', '12:00:00', 139),
(167, 67, 4, '2025-02-01', '12:00:00', '15:00:00', 59),
(168, 68, 4, '2025-02-01', '15:00:00', '18:00:00', 92),
(169, 69, 4, '2025-02-01', '18:00:00', '21:00:00', 113),
(170, 70, 4, '2025-02-01', '21:00:00', '00:00:00', 84),
(171, 71, 5, '2025-02-01', '09:00:00', '12:00:00', 182),
(172, 72, 5, '2025-02-01', '12:00:00', '15:00:00', 102),
(173, 73, 5, '2025-02-01', '15:00:00', '18:00:00', 63),
(174, 74, 5, '2025-02-01', '18:00:00', '21:00:00', 142),
(175, 75, 5, '2025-02-01', '21:00:00', '00:00:00', 48),
(176, 76, 6, '2025-02-01', '09:00:00', '12:00:00', 75),
(177, 77, 6, '2025-02-01', '12:00:00', '15:00:00', 74),
(178, 78, 6, '2025-02-01', '15:00:00', '18:00:00', 109),
(179, 79, 6, '2025-02-01', '18:00:00', '21:00:00', 100),
(180, 80, 6, '2025-02-01', '21:00:00', '00:00:00', 157),
(181, 81, 1, '2025-02-02', '09:00:00', '12:00:00', 79),
(182, 82, 1, '2025-02-02', '12:00:00', '15:00:00', 61),
(183, 83, 1, '2025-02-02', '15:00:00', '18:00:00', 55),
(184, 84, 1, '2025-02-02', '18:00:00', '21:00:00', 77),
(185, 85, 1, '2025-02-02', '21:00:00', '00:00:00', 74),
(186, 86, 2, '2025-02-02', '09:00:00', '12:00:00', 89),
(187, 87, 2, '2025-02-02', '12:00:00', '15:00:00', 11),
(188, 88, 2, '2025-02-02', '15:00:00', '18:00:00', 92),
(189, 89, 2, '2025-02-02', '18:00:00', '21:00:00', 39),
(190, 90, 2, '2025-02-02', '21:00:00', '00:00:00', 90),
(191, 91, 3, '2025-02-02', '09:00:00', '12:00:00', 64),
(192, 92, 3, '2025-02-02', '12:00:00', '15:00:00', 12),
(193, 93, 3, '2025-02-02', '15:00:00', '18:00:00', 76),
(194, 94, 3, '2025-02-02', '18:00:00', '21:00:00', 19),
(195, 95, 3, '2025-02-02', '21:00:00', '00:00:00', 35),
(196, 96, 4, '2025-02-02', '09:00:00', '12:00:00', 125),
(197, 97, 4, '2025-02-02', '12:00:00', '15:00:00', 199),
(198, 98, 4, '2025-02-02', '15:00:00', '18:00:00', 158),
(199, 99, 4, '2025-02-02', '18:00:00', '21:00:00', 52),
(200, 100, 4, '2025-02-02', '21:00:00', '00:00:00', 124),
(201, 1, 5, '2025-02-02', '09:00:00', '12:00:00', 74),
(202, 2, 5, '2025-02-02', '12:00:00', '15:00:00', 148),
(203, 3, 5, '2025-02-02', '15:00:00', '18:00:00', 27),
(204, 4, 5, '2025-02-02', '18:00:00', '21:00:00', 105),
(205, 5, 5, '2025-02-02', '21:00:00', '00:00:00', 72),
(206, 6, 6, '2025-02-02', '09:00:00', '12:00:00', 136),
(207, 7, 6, '2025-02-02', '12:00:00', '15:00:00', 20),
(208, 8, 6, '2025-02-02', '15:00:00', '18:00:00', 109),
(209, 9, 6, '2025-02-02', '18:00:00', '21:00:00', 52),
(210, 10, 6, '2025-02-02', '21:00:00', '00:00:00', 133),
(211, 11, 1, '2025-02-03', '09:00:00', '12:00:00', 50),
(212, 12, 1, '2025-02-03', '12:00:00', '15:00:00', 72),
(213, 13, 1, '2025-02-03', '15:00:00', '18:00:00', 50),
(214, 14, 1, '2025-02-03', '18:00:00', '21:00:00', 70),
(215, 15, 1, '2025-02-03', '21:00:00', '00:00:00', 75),
(216, 16, 2, '2025-02-03', '09:00:00', '12:00:00', 48),
(217, 17, 2, '2025-02-03', '12:00:00', '15:00:00', 43),
(218, 18, 2, '2025-02-03', '15:00:00', '18:00:00', 91),
(219, 19, 2, '2025-02-03', '18:00:00', '21:00:00', 65),
(220, 20, 2, '2025-02-03', '21:00:00', '00:00:00', 26),
(221, 21, 3, '2025-02-03', '09:00:00', '12:00:00', 63),
(222, 22, 3, '2025-02-03', '12:00:00', '15:00:00', 49),
(223, 23, 3, '2025-02-03', '15:00:00', '18:00:00', 43),
(224, 24, 3, '2025-02-03', '18:00:00', '21:00:00', 60),
(225, 25, 3, '2025-02-03', '21:00:00', '00:00:00', 13),
(226, 26, 4, '2025-02-03', '09:00:00', '12:00:00', 121),
(227, 27, 4, '2025-02-03', '12:00:00', '15:00:00', 47),
(228, 28, 4, '2025-02-03', '15:00:00', '18:00:00', 179),
(229, 29, 4, '2025-02-03', '18:00:00', '21:00:00', 200),
(230, 30, 4, '2025-02-03', '21:00:00', '00:00:00', 55),
(231, 31, 5, '2025-02-03', '09:00:00', '12:00:00', 82),
(232, 32, 5, '2025-02-03', '12:00:00', '15:00:00', 69),
(233, 33, 5, '2025-02-03', '15:00:00', '18:00:00', 100),
(234, 34, 5, '2025-02-03', '18:00:00', '21:00:00', 28),
(235, 35, 5, '2025-02-03', '21:00:00', '00:00:00', 194),
(236, 36, 6, '2025-02-03', '09:00:00', '12:00:00', 96),
(237, 37, 6, '2025-02-03', '12:00:00', '15:00:00', 96),
(238, 38, 6, '2025-02-03', '15:00:00', '18:00:00', 140),
(239, 39, 6, '2025-02-03', '18:00:00', '21:00:00', 80),
(240, 40, 6, '2025-02-03', '21:00:00', '00:00:00', 139),
(241, 41, 1, '2025-02-04', '09:00:00', '12:00:00', 42),
(242, 42, 1, '2025-02-04', '12:00:00', '15:00:00', 83),
(243, 43, 1, '2025-02-04', '15:00:00', '18:00:00', 74),
(244, 44, 1, '2025-02-04', '18:00:00', '21:00:00', 40),
(245, 45, 1, '2025-02-04', '21:00:00', '00:00:00', 39),
(246, 46, 2, '2025-02-04', '09:00:00', '12:00:00', 22),
(247, 47, 2, '2025-02-04', '12:00:00', '15:00:00', 67),
(248, 48, 2, '2025-02-04', '15:00:00', '18:00:00', 33),
(249, 49, 2, '2025-02-04', '18:00:00', '21:00:00', 24),
(250, 50, 2, '2025-02-04', '21:00:00', '00:00:00', 51),
(251, 51, 3, '2025-02-04', '09:00:00', '12:00:00', 88),
(252, 52, 3, '2025-02-04', '12:00:00', '15:00:00', 87),
(253, 53, 3, '2025-02-04', '15:00:00', '18:00:00', 57),
(254, 54, 3, '2025-02-04', '18:00:00', '21:00:00', 49),
(255, 55, 3, '2025-02-04', '21:00:00', '00:00:00', 38),
(256, 56, 4, '2025-02-04', '09:00:00', '12:00:00', 30),
(257, 57, 4, '2025-02-04', '12:00:00', '15:00:00', 88),
(258, 58, 4, '2025-02-04', '15:00:00', '18:00:00', 92),
(259, 59, 4, '2025-02-04', '18:00:00', '21:00:00', 100),
(260, 60, 4, '2025-02-04', '21:00:00', '00:00:00', 63),
(261, 61, 5, '2025-02-04', '09:00:00', '12:00:00', 146),
(262, 62, 5, '2025-02-04', '12:00:00', '15:00:00', 94),
(263, 63, 5, '2025-02-04', '15:00:00', '18:00:00', 140),
(264, 64, 5, '2025-02-04', '18:00:00', '21:00:00', 148),
(265, 65, 5, '2025-02-04', '21:00:00', '00:00:00', 88),
(266, 66, 6, '2025-02-04', '09:00:00', '12:00:00', 24),
(267, 67, 6, '2025-02-04', '12:00:00', '15:00:00', 159),
(268, 68, 6, '2025-02-04', '15:00:00', '18:00:00', 23),
(269, 69, 6, '2025-02-04', '18:00:00', '21:00:00', 60),
(270, 70, 6, '2025-02-04', '21:00:00', '00:00:00', 146),
(271, 71, 1, '2025-02-05', '09:00:00', '12:00:00', 33),
(272, 72, 1, '2025-02-05', '12:00:00', '15:00:00', 73),
(273, 73, 1, '2025-02-05', '15:00:00', '18:00:00', 51),
(274, 74, 1, '2025-02-05', '18:00:00', '21:00:00', 36),
(275, 75, 1, '2025-02-05', '21:00:00', '00:00:00', 56),
(276, 76, 2, '2025-02-05', '09:00:00', '12:00:00', 28),
(277, 77, 2, '2025-02-05', '12:00:00', '15:00:00', 28),
(278, 78, 2, '2025-02-05', '15:00:00', '18:00:00', 73),
(279, 79, 2, '2025-02-05', '18:00:00', '21:00:00', 52),
(280, 80, 2, '2025-02-05', '21:00:00', '00:00:00', 34),
(281, 81, 3, '2025-02-05', '09:00:00', '12:00:00', 77),
(282, 82, 3, '2025-02-05', '12:00:00', '15:00:00', 38),
(283, 83, 3, '2025-02-05', '15:00:00', '18:00:00', 39),
(284, 84, 3, '2025-02-05', '18:00:00', '21:00:00', 70),
(285, 85, 3, '2025-02-05', '21:00:00', '00:00:00', 42),
(286, 86, 4, '2025-02-05', '09:00:00', '12:00:00', 150),
(287, 87, 4, '2025-02-05', '12:00:00', '15:00:00', 151),
(288, 88, 4, '2025-02-05', '15:00:00', '18:00:00', 111),
(289, 89, 4, '2025-02-05', '18:00:00', '21:00:00', 154),
(290, 90, 4, '2025-02-05', '21:00:00', '00:00:00', 39),
(291, 91, 5, '2025-02-05', '09:00:00', '12:00:00', 107),
(292, 92, 5, '2025-02-05', '12:00:00', '15:00:00', 37),
(293, 93, 5, '2025-02-05', '15:00:00', '18:00:00', 54),
(294, 94, 5, '2025-02-05', '18:00:00', '21:00:00', 135),
(295, 95, 5, '2025-02-05', '21:00:00', '00:00:00', 45),
(296, 96, 6, '2025-02-05', '09:00:00', '12:00:00', 154),
(297, 97, 6, '2025-02-05', '12:00:00', '15:00:00', 196),
(298, 98, 6, '2025-02-05', '15:00:00', '18:00:00', 158),
(299, 99, 6, '2025-02-05', '18:00:00', '21:00:00', 53),
(300, 100, 6, '2025-02-05', '21:00:00', '00:00:00', 29),
(301, 1, 1, '2025-03-01', '09:00:00', '12:00:00', 50),
(302, 2, 1, '2025-03-01', '12:00:00', '15:00:00', 29),
(303, 3, 1, '2025-03-01', '15:00:00', '18:00:00', 85),
(304, 4, 1, '2025-03-01', '18:00:00', '21:00:00', 91),
(305, 5, 1, '2025-03-01', '21:00:00', '00:00:00', 79),
(306, 6, 2, '2025-03-01', '09:00:00', '12:00:00', 59),
(307, 7, 2, '2025-03-01', '12:00:00', '15:00:00', 25),
(308, 8, 2, '2025-03-01', '15:00:00', '18:00:00', 17),
(309, 9, 2, '2025-03-01', '18:00:00', '21:00:00', 76),
(310, 10, 2, '2025-03-01', '21:00:00', '00:00:00', 69),
(311, 11, 3, '2025-03-01', '09:00:00', '12:00:00', 64),
(312, 12, 3, '2025-03-01', '12:00:00', '15:00:00', 16),
(313, 13, 3, '2025-03-01', '15:00:00', '18:00:00', 36),
(314, 14, 3, '2025-03-01', '18:00:00', '21:00:00', 74),
(315, 15, 3, '2025-03-01', '21:00:00', '00:00:00', 51),
(316, 16, 4, '2025-03-01', '09:00:00', '12:00:00', 64),
(317, 17, 4, '2025-03-01', '12:00:00', '15:00:00', 104),
(318, 18, 4, '2025-03-01', '15:00:00', '18:00:00', 45),
(319, 19, 4, '2025-03-01', '18:00:00', '21:00:00', 54),
(320, 20, 4, '2025-03-01', '21:00:00', '00:00:00', 68),
(321, 21, 5, '2025-03-01', '09:00:00', '12:00:00', 75),
(322, 22, 5, '2025-03-01', '12:00:00', '15:00:00', 158),
(323, 23, 5, '2025-03-01', '15:00:00', '18:00:00', 166),
(324, 24, 5, '2025-03-01', '18:00:00', '21:00:00', 135),
(325, 25, 5, '2025-03-01', '21:00:00', '00:00:00', 85),
(326, 26, 6, '2025-03-01', '09:00:00', '12:00:00', 164),
(327, 27, 6, '2025-03-01', '12:00:00', '15:00:00', 82),
(328, 28, 6, '2025-03-01', '15:00:00', '18:00:00', 161),
(329, 29, 6, '2025-03-01', '18:00:00', '21:00:00', 156),
(330, 30, 6, '2025-03-01', '21:00:00', '00:00:00', 185),
(331, 31, 1, '2025-03-02', '09:00:00', '12:00:00', 42),
(332, 32, 1, '2025-03-02', '12:00:00', '15:00:00', 22),
(333, 33, 1, '2025-03-02', '15:00:00', '18:00:00', 69),
(334, 34, 1, '2025-03-02', '18:00:00', '21:00:00', 61),
(335, 35, 1, '2025-03-02', '21:00:00', '00:00:00', 21),
(336, 36, 2, '2025-03-02', '09:00:00', '12:00:00', 62),
(337, 37, 2, '2025-03-02', '12:00:00', '15:00:00', 49),
(338, 38, 2, '2025-03-02', '15:00:00', '18:00:00', 51),
(339, 39, 2, '2025-03-02', '18:00:00', '21:00:00', 90),
(340, 40, 2, '2025-03-02', '21:00:00', '00:00:00', 29),
(341, 41, 3, '2025-03-02', '09:00:00', '12:00:00', 76),
(342, 42, 3, '2025-03-02', '12:00:00', '15:00:00', 51),
(343, 43, 3, '2025-03-02', '15:00:00', '18:00:00', 97),
(344, 44, 3, '2025-03-02', '18:00:00', '21:00:00', 52),
(345, 45, 3, '2025-03-02', '21:00:00', '00:00:00', 93),
(346, 46, 4, '2025-03-02', '09:00:00', '12:00:00', 135),
(347, 47, 4, '2025-03-02', '12:00:00', '15:00:00', 123),
(348, 48, 4, '2025-03-02', '15:00:00', '18:00:00', 169),
(349, 49, 4, '2025-03-02', '18:00:00', '21:00:00', 147),
(350, 50, 4, '2025-03-02', '21:00:00', '00:00:00', 64),
(351, 51, 5, '2025-03-02', '09:00:00', '12:00:00', 43),
(352, 52, 5, '2025-03-02', '12:00:00', '15:00:00', 110),
(353, 53, 5, '2025-03-02', '15:00:00', '18:00:00', 175),
(354, 54, 5, '2025-03-02', '18:00:00', '21:00:00', 133),
(355, 55, 5, '2025-03-02', '21:00:00', '00:00:00', 115),
(356, 56, 6, '2025-03-02', '09:00:00', '12:00:00', 72),
(357, 57, 6, '2025-03-02', '12:00:00', '15:00:00', 37),
(358, 58, 6, '2025-03-02', '15:00:00', '18:00:00', 154),
(359, 59, 6, '2025-03-02', '18:00:00', '21:00:00', 113),
(360, 60, 6, '2025-03-02', '21:00:00', '00:00:00', 111),
(361, 61, 1, '2025-03-03', '09:00:00', '12:00:00', 28),
(362, 62, 1, '2025-03-03', '12:00:00', '15:00:00', 28),
(363, 63, 1, '2025-03-03', '15:00:00', '18:00:00', 30),
(364, 64, 1, '2025-03-03', '18:00:00', '21:00:00', 51),
(365, 65, 1, '2025-03-03', '21:00:00', '00:00:00', 30),
(366, 66, 2, '2025-03-03', '09:00:00', '12:00:00', 75),
(367, 67, 2, '2025-03-03', '12:00:00', '15:00:00', 37),
(368, 68, 2, '2025-03-03', '15:00:00', '18:00:00', 47),
(369, 69, 2, '2025-03-03', '18:00:00', '21:00:00', 64),
(370, 70, 2, '2025-03-03', '21:00:00', '00:00:00', 29),
(371, 71, 3, '2025-03-03', '09:00:00', '12:00:00', 19),
(372, 72, 3, '2025-03-03', '12:00:00', '15:00:00', 59),
(373, 73, 3, '2025-03-03', '15:00:00', '18:00:00', 94),
(374, 74, 3, '2025-03-03', '18:00:00', '21:00:00', 85),
(375, 75, 3, '2025-03-03', '21:00:00', '00:00:00', 86),
(376, 76, 4, '2025-03-03', '09:00:00', '12:00:00', 25),
(377, 77, 4, '2025-03-03', '12:00:00', '15:00:00', 89),
(378, 78, 4, '2025-03-03', '15:00:00', '18:00:00', 31),
(379, 79, 4, '2025-03-03', '18:00:00', '21:00:00', 91),
(380, 80, 4, '2025-03-03', '21:00:00', '00:00:00', 200),
(381, 81, 5, '2025-03-03', '09:00:00', '12:00:00', 29),
(382, 82, 5, '2025-03-03', '12:00:00', '15:00:00', 115),
(383, 83, 5, '2025-03-03', '15:00:00', '18:00:00', 154),
(384, 84, 5, '2025-03-03', '18:00:00', '21:00:00', 41),
(385, 85, 5, '2025-03-03', '21:00:00', '00:00:00', 141),
(386, 86, 6, '2025-03-03', '09:00:00', '12:00:00', 148),
(387, 87, 6, '2025-03-03', '12:00:00', '15:00:00', 142),
(388, 88, 6, '2025-03-03', '15:00:00', '18:00:00', 182),
(389, 89, 6, '2025-03-03', '18:00:00', '21:00:00', 35),
(390, 90, 6, '2025-03-03', '21:00:00', '00:00:00', 80),
(391, 91, 1, '2025-03-04', '09:00:00', '12:00:00', 76),
(392, 92, 1, '2025-03-04', '12:00:00', '15:00:00', 92),
(393, 93, 1, '2025-03-04', '15:00:00', '18:00:00', 96),
(394, 94, 1, '2025-03-04', '18:00:00', '21:00:00', 57),
(395, 95, 1, '2025-03-04', '21:00:00', '00:00:00', 98),
(396, 96, 2, '2025-03-04', '09:00:00', '12:00:00', 12),
(397, 97, 2, '2025-03-04', '12:00:00', '15:00:00', 79),
(398, 98, 2, '2025-03-04', '15:00:00', '18:00:00', 33),
(399, 99, 2, '2025-03-04', '18:00:00', '21:00:00', 96),
(400, 100, 2, '2025-03-04', '21:00:00', '00:00:00', 39),
(401, 1, 3, '2025-03-04', '09:00:00', '12:00:00', 27),
(402, 2, 3, '2025-03-04', '12:00:00', '15:00:00', 16),
(403, 3, 3, '2025-03-04', '15:00:00', '18:00:00', 86),
(404, 4, 3, '2025-03-04', '18:00:00', '21:00:00', 12),
(405, 5, 3, '2025-03-04', '21:00:00', '00:00:00', 70),
(406, 6, 4, '2025-03-04', '09:00:00', '12:00:00', 31),
(407, 7, 4, '2025-03-04', '12:00:00', '15:00:00', 129),
(408, 8, 4, '2025-03-04', '15:00:00', '18:00:00', 74),
(409, 9, 4, '2025-03-04', '18:00:00', '21:00:00', 32),
(410, 10, 4, '2025-03-04', '21:00:00', '00:00:00', 129),
(411, 11, 5, '2025-03-04', '09:00:00', '12:00:00', 74),
(412, 12, 5, '2025-03-04', '12:00:00', '15:00:00', 114),
(413, 13, 5, '2025-03-04', '15:00:00', '18:00:00', 170),
(414, 14, 5, '2025-03-04', '18:00:00', '21:00:00', 50),
(415, 15, 5, '2025-03-04', '21:00:00', '00:00:00', 131),
(416, 16, 6, '2025-03-04', '09:00:00', '12:00:00', 71),
(417, 17, 6, '2025-03-04', '12:00:00', '15:00:00', 155),
(418, 18, 6, '2025-03-04', '15:00:00', '18:00:00', 170),
(419, 19, 6, '2025-03-04', '18:00:00', '21:00:00', 57),
(420, 20, 6, '2025-03-04', '21:00:00', '00:00:00', 190),
(421, 21, 1, '2025-03-05', '09:00:00', '12:00:00', 82),
(422, 22, 1, '2025-03-05', '12:00:00', '15:00:00', 23),
(423, 23, 1, '2025-03-05', '15:00:00', '18:00:00', 17),
(424, 24, 1, '2025-03-05', '18:00:00', '21:00:00', 11),
(425, 25, 1, '2025-03-05', '21:00:00', '00:00:00', 81),
(426, 26, 2, '2025-03-05', '09:00:00', '12:00:00', 41),
(427, 27, 2, '2025-03-05', '12:00:00', '15:00:00', 26),
(428, 28, 2, '2025-03-05', '15:00:00', '18:00:00', 66),
(429, 29, 2, '2025-03-05', '18:00:00', '21:00:00', 47),
(430, 30, 2, '2025-03-05', '21:00:00', '00:00:00', 91),
(431, 31, 3, '2025-03-05', '09:00:00', '12:00:00', 68),
(432, 32, 3, '2025-03-05', '12:00:00', '15:00:00', 11),
(433, 33, 3, '2025-03-05', '15:00:00', '18:00:00', 46),
(434, 34, 3, '2025-03-05', '18:00:00', '21:00:00', 86),
(435, 35, 3, '2025-03-05', '21:00:00', '00:00:00', 60),
(436, 36, 4, '2025-03-05', '09:00:00', '12:00:00', 199),
(437, 37, 4, '2025-03-05', '12:00:00', '15:00:00', 134),
(438, 38, 4, '2025-03-05', '15:00:00', '18:00:00', 67),
(439, 39, 4, '2025-03-05', '18:00:00', '21:00:00', 167),
(440, 40, 4, '2025-03-05', '21:00:00', '00:00:00', 107),
(441, 41, 5, '2025-03-05', '09:00:00', '12:00:00', 54),
(442, 42, 5, '2025-03-05', '12:00:00', '15:00:00', 122),
(443, 43, 5, '2025-03-05', '15:00:00', '18:00:00', 152),
(444, 44, 5, '2025-03-05', '18:00:00', '21:00:00', 89),
(445, 45, 5, '2025-03-05', '21:00:00', '00:00:00', 73),
(446, 46, 6, '2025-03-05', '09:00:00', '12:00:00', 65),
(447, 47, 6, '2025-03-05', '12:00:00', '15:00:00', 174),
(448, 48, 6, '2025-03-05', '15:00:00', '18:00:00', 97),
(449, 49, 6, '2025-03-05', '18:00:00', '21:00:00', 194),
(450, 50, 6, '2025-03-05', '21:00:00', '00:00:00', 192),
(451, 51, 1, '2025-04-01', '09:00:00', '12:00:00', 41),
(452, 52, 1, '2025-04-01', '12:00:00', '15:00:00', 74),
(453, 53, 1, '2025-04-01', '15:00:00', '18:00:00', 71),
(454, 54, 1, '2025-04-01', '18:00:00', '21:00:00', 56),
(455, 55, 1, '2025-04-01', '21:00:00', '00:00:00', 54),
(456, 56, 2, '2025-04-01', '09:00:00', '12:00:00', 88),
(457, 57, 2, '2025-04-01', '12:00:00', '15:00:00', 25),
(458, 58, 2, '2025-04-01', '15:00:00', '18:00:00', 99),
(459, 59, 2, '2025-04-01', '18:00:00', '21:00:00', 44),
(460, 60, 2, '2025-04-01', '21:00:00', '00:00:00', 48),
(461, 61, 3, '2025-04-01', '09:00:00', '12:00:00', 82),
(462, 62, 3, '2025-04-01', '12:00:00', '15:00:00', 10),
(463, 63, 3, '2025-04-01', '15:00:00', '18:00:00', 66),
(464, 64, 3, '2025-04-01', '18:00:00', '21:00:00', 54),
(465, 65, 3, '2025-04-01', '21:00:00', '00:00:00', 55),
(466, 66, 4, '2025-04-01', '09:00:00', '12:00:00', 93),
(467, 67, 4, '2025-04-01', '12:00:00', '15:00:00', 105),
(468, 68, 4, '2025-04-01', '15:00:00', '18:00:00', 54),
(469, 69, 4, '2025-04-01', '18:00:00', '21:00:00', 118),
(470, 70, 4, '2025-04-01', '21:00:00', '00:00:00', 137),
(471, 71, 5, '2025-04-01', '09:00:00', '12:00:00', 70),
(472, 72, 5, '2025-04-01', '12:00:00', '15:00:00', 86),
(473, 73, 5, '2025-04-01', '15:00:00', '18:00:00', 135),
(474, 74, 5, '2025-04-01', '18:00:00', '21:00:00', 38),
(475, 75, 5, '2025-04-01', '21:00:00', '00:00:00', 82),
(476, 76, 6, '2025-04-01', '09:00:00', '12:00:00', 143),
(477, 77, 6, '2025-04-01', '12:00:00', '15:00:00', 48),
(478, 78, 6, '2025-04-01', '15:00:00', '18:00:00', 120),
(479, 79, 6, '2025-04-01', '18:00:00', '21:00:00', 27),
(480, 80, 6, '2025-04-01', '21:00:00', '00:00:00', 87),
(481, 81, 1, '2025-04-02', '09:00:00', '12:00:00', 49),
(482, 82, 1, '2025-04-02', '12:00:00', '15:00:00', 55),
(483, 83, 1, '2025-04-02', '15:00:00', '18:00:00', 62),
(484, 84, 1, '2025-04-02', '18:00:00', '21:00:00', 57),
(485, 85, 1, '2025-04-02', '21:00:00', '00:00:00', 35),
(486, 86, 2, '2025-04-02', '09:00:00', '12:00:00', 13),
(487, 87, 2, '2025-04-02', '12:00:00', '15:00:00', 40),
(488, 88, 2, '2025-04-02', '15:00:00', '18:00:00', 41),
(489, 89, 2, '2025-04-02', '18:00:00', '21:00:00', 14),
(490, 90, 2, '2025-04-02', '21:00:00', '00:00:00', 96),
(491, 91, 3, '2025-04-02', '09:00:00', '12:00:00', 76),
(492, 92, 3, '2025-04-02', '12:00:00', '15:00:00', 57),
(493, 93, 3, '2025-04-02', '15:00:00', '18:00:00', 15),
(494, 94, 3, '2025-04-02', '18:00:00', '21:00:00', 69),
(495, 95, 3, '2025-04-02', '21:00:00', '00:00:00', 62),
(496, 96, 4, '2025-04-02', '09:00:00', '12:00:00', 66),
(497, 97, 4, '2025-04-02', '12:00:00', '15:00:00', 159),
(498, 98, 4, '2025-04-02', '15:00:00', '18:00:00', 38),
(499, 99, 4, '2025-04-02', '18:00:00', '21:00:00', 163),
(500, 100, 4, '2025-04-02', '21:00:00', '00:00:00', 75),
(501, 1, 5, '2025-04-02', '09:00:00', '12:00:00', 29),
(502, 2, 5, '2025-04-02', '12:00:00', '15:00:00', 173),
(503, 3, 5, '2025-04-02', '15:00:00', '18:00:00', 183),
(504, 4, 5, '2025-04-02', '18:00:00', '21:00:00', 158),
(505, 5, 5, '2025-04-02', '21:00:00', '00:00:00', 67),
(506, 6, 6, '2025-04-02', '09:00:00', '12:00:00', 72),
(507, 7, 6, '2025-04-02', '12:00:00', '15:00:00', 52),
(508, 8, 6, '2025-04-02', '15:00:00', '18:00:00', 195),
(509, 9, 6, '2025-04-02', '18:00:00', '21:00:00', 26),
(510, 10, 6, '2025-04-02', '21:00:00', '00:00:00', 159),
(511, 11, 1, '2025-04-03', '09:00:00', '12:00:00', 63),
(512, 12, 1, '2025-04-03', '12:00:00', '15:00:00', 77),
(513, 13, 1, '2025-04-03', '15:00:00', '18:00:00', 100),
(514, 14, 1, '2025-04-03', '18:00:00', '21:00:00', 72),
(515, 15, 1, '2025-04-03', '21:00:00', '00:00:00', 52),
(516, 16, 2, '2025-04-03', '09:00:00', '12:00:00', 94),
(517, 17, 2, '2025-04-03', '12:00:00', '15:00:00', 53),
(518, 18, 2, '2025-04-03', '15:00:00', '18:00:00', 64),
(519, 19, 2, '2025-04-03', '18:00:00', '21:00:00', 100),
(520, 20, 2, '2025-04-03', '21:00:00', '00:00:00', 98),
(521, 21, 3, '2025-04-03', '09:00:00', '12:00:00', 17),
(522, 22, 3, '2025-04-03', '12:00:00', '15:00:00', 35),
(523, 23, 3, '2025-04-03', '15:00:00', '18:00:00', 24),
(524, 24, 3, '2025-04-03', '18:00:00', '21:00:00', 17),
(525, 25, 3, '2025-04-03', '21:00:00', '00:00:00', 65),
(526, 26, 4, '2025-04-03', '09:00:00', '12:00:00', 196),
(527, 27, 4, '2025-04-03', '12:00:00', '15:00:00', 112),
(528, 28, 4, '2025-04-03', '15:00:00', '18:00:00', 25),
(529, 29, 4, '2025-04-03', '18:00:00', '21:00:00', 28),
(530, 30, 4, '2025-04-03', '21:00:00', '00:00:00', 160),
(531, 31, 5, '2025-04-03', '09:00:00', '12:00:00', 192),
(532, 32, 5, '2025-04-03', '12:00:00', '15:00:00', 174),
(533, 33, 5, '2025-04-03', '15:00:00', '18:00:00', 178),
(534, 34, 5, '2025-04-03', '18:00:00', '21:00:00', 42),
(535, 35, 5, '2025-04-03', '21:00:00', '00:00:00', 60),
(536, 36, 6, '2025-04-03', '09:00:00', '12:00:00', 181),
(537, 37, 6, '2025-04-03', '12:00:00', '15:00:00', 47),
(538, 38, 6, '2025-04-03', '15:00:00', '18:00:00', 48),
(539, 39, 6, '2025-04-03', '18:00:00', '21:00:00', 143),
(540, 40, 6, '2025-04-03', '21:00:00', '00:00:00', 26),
(541, 41, 1, '2025-04-04', '09:00:00', '12:00:00', 37),
(542, 42, 1, '2025-04-04', '12:00:00', '15:00:00', 87),
(543, 43, 1, '2025-04-04', '15:00:00', '18:00:00', 74),
(544, 44, 1, '2025-04-04', '18:00:00', '21:00:00', 33),
(545, 45, 1, '2025-04-04', '21:00:00', '00:00:00', 98),
(546, 46, 2, '2025-04-04', '09:00:00', '12:00:00', 66),
(547, 47, 2, '2025-04-04', '12:00:00', '15:00:00', 60),
(548, 48, 2, '2025-04-04', '15:00:00', '18:00:00', 47),
(549, 49, 2, '2025-04-04', '18:00:00', '21:00:00', 18),
(550, 50, 2, '2025-04-04', '21:00:00', '00:00:00', 36),
(551, 51, 3, '2025-04-04', '09:00:00', '12:00:00', 87),
(552, 52, 3, '2025-04-04', '12:00:00', '15:00:00', 66),
(553, 53, 3, '2025-04-04', '15:00:00', '18:00:00', 30),
(554, 54, 3, '2025-04-04', '18:00:00', '21:00:00', 34),
(555, 55, 3, '2025-04-04', '21:00:00', '00:00:00', 79),
(556, 56, 4, '2025-04-04', '09:00:00', '12:00:00', 188),
(557, 57, 4, '2025-04-04', '12:00:00', '15:00:00', 131),
(558, 58, 4, '2025-04-04', '15:00:00', '18:00:00', 124),
(559, 59, 4, '2025-04-04', '18:00:00', '21:00:00', 95),
(560, 60, 4, '2025-04-04', '21:00:00', '00:00:00', 35),
(561, 61, 5, '2025-04-04', '09:00:00', '12:00:00', 99),
(562, 62, 5, '2025-04-04', '12:00:00', '15:00:00', 144),
(563, 63, 5, '2025-04-04', '15:00:00', '18:00:00', 90),
(564, 64, 5, '2025-04-04', '18:00:00', '21:00:00', 132),
(565, 65, 5, '2025-04-04', '21:00:00', '00:00:00', 141),
(566, 66, 6, '2025-04-04', '09:00:00', '12:00:00', 53),
(567, 67, 6, '2025-04-04', '12:00:00', '15:00:00', 79),
(568, 68, 6, '2025-04-04', '15:00:00', '18:00:00', 44),
(569, 69, 6, '2025-04-04', '18:00:00', '21:00:00', 75),
(570, 70, 6, '2025-04-04', '21:00:00', '00:00:00', 196),
(571, 71, 1, '2025-04-05', '09:00:00', '12:00:00', 54),
(572, 72, 1, '2025-04-05', '12:00:00', '15:00:00', 79),
(573, 73, 1, '2025-04-05', '15:00:00', '18:00:00', 30),
(574, 74, 1, '2025-04-05', '18:00:00', '21:00:00', 77),
(575, 75, 1, '2025-04-05', '21:00:00', '00:00:00', 58),
(576, 76, 2, '2025-04-05', '09:00:00', '12:00:00', 55),
(577, 77, 2, '2025-04-05', '12:00:00', '15:00:00', 49),
(578, 78, 2, '2025-04-05', '15:00:00', '18:00:00', 85),
(579, 79, 2, '2025-04-05', '18:00:00', '21:00:00', 41),
(580, 80, 2, '2025-04-05', '21:00:00', '00:00:00', 50),
(581, 81, 3, '2025-04-05', '09:00:00', '12:00:00', 37),
(582, 82, 3, '2025-04-05', '12:00:00', '15:00:00', 97),
(583, 83, 3, '2025-04-05', '15:00:00', '18:00:00', 43),
(584, 84, 3, '2025-04-05', '18:00:00', '21:00:00', 44),
(585, 85, 3, '2025-04-05', '21:00:00', '00:00:00', 15),
(586, 86, 4, '2025-04-05', '09:00:00', '12:00:00', 105),
(587, 87, 4, '2025-04-05', '12:00:00', '15:00:00', 188),
(588, 88, 4, '2025-04-05', '15:00:00', '18:00:00', 93),
(589, 89, 4, '2025-04-05', '18:00:00', '21:00:00', 183),
(590, 90, 4, '2025-04-05', '21:00:00', '00:00:00', 189),
(591, 91, 5, '2025-04-05', '09:00:00', '12:00:00', 102),
(592, 92, 5, '2025-04-05', '12:00:00', '15:00:00', 47),
(593, 93, 5, '2025-04-05', '15:00:00', '18:00:00', 61),
(594, 94, 5, '2025-04-05', '18:00:00', '21:00:00', 74),
(595, 95, 5, '2025-04-05', '21:00:00', '00:00:00', 94),
(596, 96, 6, '2025-04-05', '09:00:00', '12:00:00', 132),
(597, 97, 6, '2025-04-05', '12:00:00', '15:00:00', 200),
(598, 98, 6, '2025-04-05', '15:00:00', '18:00:00', 180),
(599, 99, 6, '2025-04-05', '18:00:00', '21:00:00', 161),
(600, 100, 6, '2025-04-05', '21:00:00', '00:00:00', 32),
(601, 1, 1, '2025-05-01', '09:00:00', '12:00:00', 50),
(602, 2, 1, '2025-05-01', '12:00:00', '15:00:00', 57),
(603, 3, 1, '2025-05-01', '15:00:00', '18:00:00', 75),
(604, 4, 1, '2025-05-01', '18:00:00', '21:00:00', 82),
(605, 5, 1, '2025-05-01', '21:00:00', '00:00:00', 27),
(606, 6, 2, '2025-05-01', '09:00:00', '12:00:00', 54),
(607, 7, 2, '2025-05-01', '12:00:00', '15:00:00', 76),
(608, 8, 2, '2025-05-01', '15:00:00', '18:00:00', 29),
(609, 9, 2, '2025-05-01', '18:00:00', '21:00:00', 38),
(610, 10, 2, '2025-05-01', '21:00:00', '00:00:00', 13),
(611, 11, 3, '2025-05-01', '09:00:00', '12:00:00', 41),
(612, 12, 3, '2025-05-01', '12:00:00', '15:00:00', 15),
(613, 13, 3, '2025-05-01', '15:00:00', '18:00:00', 48),
(614, 14, 3, '2025-05-01', '18:00:00', '21:00:00', 78),
(615, 15, 3, '2025-05-01', '21:00:00', '00:00:00', 17),
(616, 16, 4, '2025-05-01', '09:00:00', '12:00:00', 83),
(617, 17, 4, '2025-05-01', '12:00:00', '15:00:00', 76),
(618, 18, 4, '2025-05-01', '15:00:00', '18:00:00', 200),
(619, 19, 4, '2025-05-01', '18:00:00', '21:00:00', 79),
(620, 20, 4, '2025-05-01', '21:00:00', '00:00:00', 114),
(621, 21, 5, '2025-05-01', '09:00:00', '12:00:00', 117),
(622, 22, 5, '2025-05-01', '12:00:00', '15:00:00', 170),
(623, 23, 5, '2025-05-01', '15:00:00', '18:00:00', 140),
(624, 24, 5, '2025-05-01', '18:00:00', '21:00:00', 161),
(625, 25, 5, '2025-05-01', '21:00:00', '00:00:00', 115),
(626, 26, 6, '2025-05-01', '09:00:00', '12:00:00', 76),
(627, 27, 6, '2025-05-01', '12:00:00', '15:00:00', 165),
(628, 28, 6, '2025-05-01', '15:00:00', '18:00:00', 31),
(629, 29, 6, '2025-05-01', '18:00:00', '21:00:00', 171),
(630, 30, 6, '2025-05-01', '21:00:00', '00:00:00', 174),
(631, 31, 1, '2025-05-02', '09:00:00', '12:00:00', 58),
(632, 32, 1, '2025-05-02', '12:00:00', '15:00:00', 89),
(633, 33, 1, '2025-05-02', '15:00:00', '18:00:00', 41),
(634, 34, 1, '2025-05-02', '18:00:00', '21:00:00', 59),
(635, 35, 1, '2025-05-02', '21:00:00', '00:00:00', 76),
(636, 36, 2, '2025-05-02', '09:00:00', '12:00:00', 53),
(637, 37, 2, '2025-05-02', '12:00:00', '15:00:00', 64),
(638, 38, 2, '2025-05-02', '15:00:00', '18:00:00', 14),
(639, 39, 2, '2025-05-02', '18:00:00', '21:00:00', 97),
(640, 40, 2, '2025-05-02', '21:00:00', '00:00:00', 34),
(641, 41, 3, '2025-05-02', '09:00:00', '12:00:00', 32),
(642, 42, 3, '2025-05-02', '12:00:00', '15:00:00', 96),
(643, 43, 3, '2025-05-02', '15:00:00', '18:00:00', 26),
(644, 44, 3, '2025-05-02', '18:00:00', '21:00:00', 63),
(645, 45, 3, '2025-05-02', '21:00:00', '00:00:00', 50),
(646, 46, 4, '2025-05-02', '09:00:00', '12:00:00', 80),
(647, 47, 4, '2025-05-02', '12:00:00', '15:00:00', 198),
(648, 48, 4, '2025-05-02', '15:00:00', '18:00:00', 72),
(649, 49, 4, '2025-05-02', '18:00:00', '21:00:00', 53),
(650, 50, 4, '2025-05-02', '21:00:00', '00:00:00', 112),
(651, 51, 5, '2025-05-02', '09:00:00', '12:00:00', 165),
(652, 52, 5, '2025-05-02', '12:00:00', '15:00:00', 158),
(653, 53, 5, '2025-05-02', '15:00:00', '18:00:00', 23),
(654, 54, 5, '2025-05-02', '18:00:00', '21:00:00', 68),
(655, 55, 5, '2025-05-02', '21:00:00', '00:00:00', 140),
(656, 56, 6, '2025-05-02', '09:00:00', '12:00:00', 71),
(657, 57, 6, '2025-05-02', '12:00:00', '15:00:00', 121),
(658, 58, 6, '2025-05-02', '15:00:00', '18:00:00', 96),
(659, 59, 6, '2025-05-02', '18:00:00', '21:00:00', 170),
(660, 60, 6, '2025-05-02', '21:00:00', '00:00:00', 187),
(661, 61, 1, '2025-05-03', '09:00:00', '12:00:00', 12),
(662, 62, 1, '2025-05-03', '12:00:00', '15:00:00', 72),
(663, 63, 1, '2025-05-03', '15:00:00', '18:00:00', 58),
(664, 64, 1, '2025-05-03', '18:00:00', '21:00:00', 35),
(665, 65, 1, '2025-05-03', '21:00:00', '00:00:00', 98),
(666, 66, 2, '2025-05-03', '09:00:00', '12:00:00', 17),
(667, 67, 2, '2025-05-03', '12:00:00', '15:00:00', 31),
(668, 68, 2, '2025-05-03', '15:00:00', '18:00:00', 35),
(669, 69, 2, '2025-05-03', '18:00:00', '21:00:00', 50),
(670, 70, 2, '2025-05-03', '21:00:00', '00:00:00', 77),
(671, 71, 3, '2025-05-03', '09:00:00', '12:00:00', 23),
(672, 72, 3, '2025-05-03', '12:00:00', '15:00:00', 26),
(673, 73, 3, '2025-05-03', '15:00:00', '18:00:00', 76),
(674, 74, 3, '2025-05-03', '18:00:00', '21:00:00', 38),
(675, 75, 3, '2025-05-03', '21:00:00', '00:00:00', 13),
(676, 76, 4, '2025-05-03', '09:00:00', '12:00:00', 149),
(677, 77, 4, '2025-05-03', '12:00:00', '15:00:00', 31),
(678, 78, 4, '2025-05-03', '15:00:00', '18:00:00', 58),
(679, 79, 4, '2025-05-03', '18:00:00', '21:00:00', 199),
(680, 80, 4, '2025-05-03', '21:00:00', '00:00:00', 189),
(681, 81, 5, '2025-05-03', '09:00:00', '12:00:00', 195),
(682, 82, 5, '2025-05-03', '12:00:00', '15:00:00', 83),
(683, 83, 5, '2025-05-03', '15:00:00', '18:00:00', 152),
(684, 84, 5, '2025-05-03', '18:00:00', '21:00:00', 166),
(685, 85, 5, '2025-05-03', '21:00:00', '00:00:00', 137),
(686, 86, 6, '2025-05-03', '09:00:00', '12:00:00', 180),
(687, 87, 6, '2025-05-03', '12:00:00', '15:00:00', 111),
(688, 88, 6, '2025-05-03', '15:00:00', '18:00:00', 26),
(689, 89, 6, '2025-05-03', '18:00:00', '21:00:00', 161),
(690, 90, 6, '2025-05-03', '21:00:00', '00:00:00', 73),
(691, 91, 1, '2025-05-04', '09:00:00', '12:00:00', 49),
(692, 92, 1, '2025-05-04', '12:00:00', '15:00:00', 92),
(693, 93, 1, '2025-05-04', '15:00:00', '18:00:00', 82),
(694, 94, 1, '2025-05-04', '18:00:00', '21:00:00', 43),
(695, 95, 1, '2025-05-04', '21:00:00', '00:00:00', 84),
(696, 96, 2, '2025-05-04', '09:00:00', '12:00:00', 44),
(697, 97, 2, '2025-05-04', '12:00:00', '15:00:00', 72),
(698, 98, 2, '2025-05-04', '15:00:00', '18:00:00', 83),
(699, 99, 2, '2025-05-04', '18:00:00', '21:00:00', 88),
(700, 100, 2, '2025-05-04', '21:00:00', '00:00:00', 24),
(701, 1, 3, '2025-05-04', '09:00:00', '12:00:00', 69),
(702, 2, 3, '2025-05-04', '12:00:00', '15:00:00', 36),
(703, 3, 3, '2025-05-04', '15:00:00', '18:00:00', 25),
(704, 4, 3, '2025-05-04', '18:00:00', '21:00:00', 43),
(705, 5, 3, '2025-05-04', '21:00:00', '00:00:00', 23),
(706, 6, 4, '2025-05-04', '09:00:00', '12:00:00', 85),
(707, 7, 4, '2025-05-04', '12:00:00', '15:00:00', 144),
(708, 8, 4, '2025-05-04', '15:00:00', '18:00:00', 71),
(709, 9, 4, '2025-05-04', '18:00:00', '21:00:00', 199),
(710, 10, 4, '2025-05-04', '21:00:00', '00:00:00', 44),
(711, 11, 5, '2025-05-04', '09:00:00', '12:00:00', 35),
(712, 12, 5, '2025-05-04', '12:00:00', '15:00:00', 189),
(713, 13, 5, '2025-05-04', '15:00:00', '18:00:00', 130),
(714, 14, 5, '2025-05-04', '18:00:00', '21:00:00', 110),
(715, 15, 5, '2025-05-04', '21:00:00', '00:00:00', 109),
(716, 16, 6, '2025-05-04', '09:00:00', '12:00:00', 154),
(717, 17, 6, '2025-05-04', '12:00:00', '15:00:00', 114),
(718, 18, 6, '2025-05-04', '15:00:00', '18:00:00', 110),
(719, 19, 6, '2025-05-04', '18:00:00', '21:00:00', 159),
(720, 20, 6, '2025-05-04', '21:00:00', '00:00:00', 57),
(721, 21, 1, '2025-05-05', '09:00:00', '12:00:00', 45),
(722, 22, 1, '2025-05-05', '12:00:00', '15:00:00', 44),
(723, 23, 1, '2025-05-05', '15:00:00', '18:00:00', 48),
(724, 24, 1, '2025-05-05', '18:00:00', '21:00:00', 71),
(725, 25, 1, '2025-05-05', '21:00:00', '00:00:00', 17),
(726, 26, 2, '2025-05-05', '09:00:00', '12:00:00', 68),
(727, 27, 2, '2025-05-05', '12:00:00', '15:00:00', 51),
(728, 28, 2, '2025-05-05', '15:00:00', '18:00:00', 58),
(729, 29, 2, '2025-05-05', '18:00:00', '21:00:00', 13),
(730, 30, 2, '2025-05-05', '21:00:00', '00:00:00', 66),
(731, 31, 3, '2025-05-05', '09:00:00', '12:00:00', 54),
(732, 32, 3, '2025-05-05', '12:00:00', '15:00:00', 42),
(733, 33, 3, '2025-05-05', '15:00:00', '18:00:00', 46),
(734, 34, 3, '2025-05-05', '18:00:00', '21:00:00', 12),
(735, 35, 3, '2025-05-05', '21:00:00', '00:00:00', 95),
(736, 36, 4, '2025-05-05', '09:00:00', '12:00:00', 50),
(737, 37, 4, '2025-05-05', '12:00:00', '15:00:00', 145),
(738, 38, 4, '2025-05-05', '15:00:00', '18:00:00', 56),
(739, 39, 4, '2025-05-05', '18:00:00', '21:00:00', 59),
(740, 40, 4, '2025-05-05', '21:00:00', '00:00:00', 124),
(741, 41, 5, '2025-05-05', '09:00:00', '12:00:00', 137),
(742, 42, 5, '2025-05-05', '12:00:00', '15:00:00', 29),
(743, 43, 5, '2025-05-05', '15:00:00', '18:00:00', 161),
(744, 44, 5, '2025-05-05', '18:00:00', '21:00:00', 77),
(745, 45, 5, '2025-05-05', '21:00:00', '00:00:00', 94),
(746, 46, 6, '2025-05-05', '09:00:00', '12:00:00', 167),
(747, 47, 6, '2025-05-05', '12:00:00', '15:00:00', 141),
(748, 48, 6, '2025-05-05', '15:00:00', '18:00:00', 128),
(749, 49, 6, '2025-05-05', '18:00:00', '21:00:00', 71),
(750, 50, 6, '2025-05-05', '21:00:00', '00:00:00', 21);


UPDATE Show
SET MovieID = 
    CASE ABS(CHECKSUM(NEWID())) % 7
        WHEN 0 THEN 16
        WHEN 1 THEN 17
        WHEN 2 THEN 18
        WHEN 3 THEN 30
        WHEN 4 THEN 31
        WHEN 5 THEN 57
        WHEN 6 THEN 61
		ELSE 16
    END
WHERE ShowID BETWEEN 550 AND 750;


Insert Into Booking (CustomerID, BookingDate, TotalAmount, PaymentMethod, PaymentDate) Values
(1, '2024-01-01', 0.00, 'Card', '2024-01-01'),
(2, '2024-01-10', 0.00, 'Card', '2024-01-10'),
(3, '2024-01-06', 0.00, 'Card', '2024-01-06'),
(4, '2024-01-11', 0.00, 'Card', '2024-01-11'),
(5, '2024-01-23', 0.00, 'Cash', '2024-01-23'),
(6, '2024-01-01', 0.00, 'Card', '2024-01-01'),
(7, '2024-01-21', 0.00, 'Card', '2024-01-21'),
(8, '2024-01-04', 0.00, 'Cash', '2024-01-04'),
(9, '2024-01-14', 0.00, 'Cash', '2024-01-14'),
(10, '2024-01-11', 0.00, 'Card', '2024-01-11'),
(11, '2024-01-08', 0.00, 'Card', '2024-01-08'),
(12, '2024-01-21', 0.00, 'Card', '2024-01-21'),
(13, '2024-01-05', 0.00, 'Card', '2024-01-05'),
(14, '2024-01-16', 0.00, 'Cash', '2024-01-16'),
(15, '2024-01-13', 0.00, 'Card', '2024-01-13'),
(16, '2024-01-11', 0.00, 'Cash', '2024-01-11'),
(17, '2024-01-14', 0.00, 'Card', '2024-01-14'),
(18, '2024-01-05', 0.00, 'Cash', '2024-01-05'),
(19, '2024-01-04', 0.00, 'Card', '2024-01-04'),
(20, '2024-01-12', 0.00, 'Card', '2024-01-12'),
(21, '2024-01-14', 0.00, 'Card', '2024-01-14'),
(22, '2024-01-24', 0.00, 'Card', '2024-01-24'),
(23, '2024-01-02', 0.00, 'Card', '2024-01-02'),
(24, '2023-12-30', 0.00, 'Cash', '2023-12-30'),
(25, '2024-01-04', 0.00, 'Cash', '2024-01-04'),
(26, '2024-01-11', 0.00, 'Cash', '2024-01-11'),
(27, '2024-01-18', 0.00, 'Card', '2024-01-18'),
(28, '2024-01-07', 0.00, 'Cash', '2024-01-07'),
(29, '2024-01-06', 0.00, 'Card', '2024-01-06'),
(30, '2024-01-05', 0.00, 'Card', '2024-01-05'),
(31, '2024-01-06', 0.00, 'Cash', '2024-01-06'),
(32, '2024-01-01', 0.00, 'Card', '2024-01-01'),
(33, '2024-01-15', 0.00, 'Card', '2024-01-15'),
(34, '2024-01-09', 0.00, 'Cash', '2024-01-09'),
(35, '2024-01-04', 0.00, 'Card', '2024-01-04'),
(36, '2024-01-10', 0.00, 'Card', '2024-01-10'),
(37, '2024-01-15', 0.00, 'Card', '2024-01-15'),
(38, '2024-01-03', 0.00, 'Card', '2024-01-03'),
(39, '2024-01-16', 0.00, 'Card', '2024-01-16'),
(40, '2024-01-08', 0.00, 'Cash', '2024-01-08'),
(41, '2024-01-16', 0.00, 'Cash', '2024-01-16'),
(42, '2024-01-01', 0.00, 'Cash', '2024-01-01'),
(43, '2024-01-10', 0.00, 'Cash', '2024-01-10'),
(44, '2024-01-16', 0.00, 'Cash', '2024-01-16'),
(45, '2024-01-02', 0.00, 'Card', '2024-01-02'),
(46, '2024-01-17', 0.00, 'Card', '2024-01-17'),
(47, '2024-01-17', 0.00, 'Cash', '2024-01-17'),
(48, '2024-01-01', 0.00, 'Cash', '2024-01-01'),
(49, '2024-01-01', 0.00, 'Cash', '2024-01-01'),
(50, '2024-01-01', 0.00, 'Cash', '2024-01-01'),
(51, '2024-01-02', 0.00, 'Cash', '2024-01-02'),
(52, '2024-01-06', 0.00, 'Cash', '2024-01-06'),
(53, '2024-01-05', 0.00, 'Card', '2024-01-05'),
(54, '2024-01-06', 0.00, 'Cash', '2024-01-06'),
(55, '2024-01-08', 0.00, 'Card', '2024-01-08'),
(56, '2024-01-19', 0.00, 'Cash', '2024-01-19'),
(57, '2024-01-02', 0.00, 'Card', '2024-01-02'),
(58, '2023-12-31', 0.00, 'Card', '2023-12-31'),
(59, '2024-01-15', 0.00, 'Card', '2024-01-15'),
(60, '2024-01-01', 0.00, 'Cash', '2024-01-01'),
(61, '2024-01-11', 0.00, 'Card', '2024-01-11'),
(62, '2024-01-06', 0.00, 'Cash', '2024-01-06'),
(63, '2024-01-12', 0.00, 'Card', '2024-01-12'),
(64, '2024-01-08', 0.00, 'Cash', '2024-01-08'),
(65, '2024-01-24', 0.00, 'Cash', '2024-01-24'),
(66, '2024-01-01', 0.00, 'Card', '2024-01-01'),
(67, '2024-01-10', 0.00, 'Cash', '2024-01-10'),
(68, '2024-01-12', 0.00, 'Card', '2024-01-12'),
(69, '2024-01-17', 0.00, 'Cash', '2024-01-17'),
(70, '2024-01-04', 0.00, 'Card', '2024-01-04'),
(71, '2024-01-18', 0.00, 'Card', '2024-01-18'),
(72, '2024-01-15', 0.00, 'Card', '2024-01-15'),
(73, '2024-01-11', 0.00, 'Cash', '2024-01-11'),
(74, '2024-01-12', 0.00, 'Cash', '2024-01-12'),
(75, '2024-01-25', 0.00, 'Cash', '2024-01-25'),
(76, '2024-01-13', 0.00, 'Cash', '2024-01-13'),
(77, '2024-01-03', 0.00, 'Cash', '2024-01-03'),
(78, '2024-01-10', 0.00, 'Cash', '2024-01-10'),
(79, '2024-01-18', 0.00, 'Cash', '2024-01-18'),
(80, '2024-01-19', 0.00, 'Card', '2024-01-19'),
(81, '2024-01-12', 0.00, 'Card', '2024-01-12'),
(82, '2024-01-21', 0.00, 'Cash', '2024-01-21'),
(83, '2024-01-23', 0.00, 'Card', '2024-01-23'),
(84, '2024-01-18', 0.00, 'Card', '2024-01-18'),
(85, '2023-12-31', 0.00, 'Card', '2023-12-31'),
(86, '2024-01-07', 0.00, 'Cash', '2024-01-07'),
(87, '2024-01-06', 0.00, 'Cash', '2024-01-06'),
(88, '2024-01-16', 0.00, 'Cash', '2024-01-16'),
(89, '2023-12-30', 0.00, 'Cash', '2023-12-30'),
(90, '2024-01-21', 0.00, 'Cash', '2024-01-21'),
(91, '2024-01-04', 0.00, 'Cash', '2024-01-04'),
(92, '2024-01-14', 0.00, 'Cash', '2024-01-14'),
(93, '2024-01-24', 0.00, 'Card', '2024-01-24'),
(94, '2024-01-19', 0.00, 'Card', '2024-01-19'),
(95, '2024-01-07', 0.00, 'Cash', '2024-01-07'),
(96, '2024-01-01', 0.00, 'Card', '2024-01-01'),
(97, '2024-01-02', 0.00, 'Card', '2024-01-02'),
(98, '2024-01-20', 0.00, 'Card', '2024-01-20'),
(99, '2024-01-15', 0.00, 'Cash', '2024-01-15'),
(100, '2024-01-09', 0.00, 'Cash', '2024-01-09'),
(101, '2024-01-13', 0.00, 'Card', '2024-01-13'),
(102, '2023-12-30', 0.00, 'Card', '2023-12-30'),
(103, '2024-01-25', 0.00, 'Cash', '2024-01-25'),
(104, '2024-01-06', 0.00, 'Cash', '2024-01-06'),
(105, '2024-01-02', 0.00, 'Card', '2024-01-02'),
(106, '2024-01-14', 0.00, 'Cash', '2024-01-14'),
(107, '2024-01-01', 0.00, 'Card', '2024-01-01'),
(108, '2023-12-30', 0.00, 'Card', '2023-12-30'),
(109, '2024-01-14', 0.00, 'Cash', '2024-01-14'),
(110, '2023-12-31', 0.00, 'Card', '2023-12-31'),
(111, '2024-01-06', 0.00, 'Card', '2024-01-06'),
(112, '2024-01-09', 0.00, 'Card', '2024-01-09'),
(113, '2024-01-17', 0.00, 'Card', '2024-01-17'),
(114, '2024-01-13', 0.00, 'Card', '2024-01-13'),
(115, '2024-01-15', 0.00, 'Cash', '2024-01-15'),
(116, '2024-01-16', 0.00, 'Card', '2024-01-16'),
(117, '2024-01-18', 0.00, 'Card', '2024-01-18'),
(118, '2024-01-17', 0.00, 'Card', '2024-01-17'),
(119, '2024-01-06', 0.00, 'Cash', '2024-01-06'),
(120, '2024-01-09', 0.00, 'Cash', '2024-01-09'),
(121, '2024-01-14', 0.00, 'Card', '2024-01-14'),
(122, '2024-01-12', 0.00, 'Cash', '2024-01-12'),
(123, '2024-01-20', 0.00, 'Cash', '2024-01-20'),
(124, '2024-01-13', 0.00, 'Card', '2024-01-13'),
(125, '2024-01-10', 0.00, 'Cash', '2024-01-10'),
(126, '2024-01-17', 0.00, 'Card', '2024-01-17'),
(127, '2024-01-15', 0.00, 'Card', '2024-01-15'),
(128, '2024-01-05', 0.00, 'Card', '2024-01-05'),
(129, '2024-01-22', 0.00, 'Cash', '2024-01-22'),
(130, '2024-01-08', 0.00, 'Cash', '2024-01-08'),
(131, '2024-01-19', 0.00, 'Card', '2024-01-19'),
(132, '2024-01-17', 0.00, 'Card', '2024-01-17'),
(133, '2024-01-04', 0.00, 'Cash', '2024-01-04'),
(134, '2024-01-22', 0.00, 'Cash', '2024-01-22'),
(135, '2024-01-22', 0.00, 'Cash', '2024-01-22'),
(136, '2024-01-19', 0.00, 'Cash', '2024-01-19'),
(137, '2023-12-30', 0.00, 'Card', '2023-12-30'),
(138, '2024-01-25', 0.00, 'Cash', '2024-01-25'),
(139, '2024-01-01', 0.00, 'Card', '2024-01-01'),
(140, '2024-01-20', 0.00, 'Cash', '2024-01-20'),
(141, '2024-01-24', 0.00, 'Card', '2024-01-24'),
(142, '2024-01-03', 0.00, 'Card', '2024-01-03'),
(143, '2024-01-07', 0.00, 'Card', '2024-01-07'),
(144, '2024-01-16', 0.00, 'Cash', '2024-01-16'),
(145, '2024-01-08', 0.00, 'Cash', '2024-01-08'),
(146, '2024-01-16', 0.00, 'Cash', '2024-01-16'),
(147, '2024-01-15', 0.00, 'Cash', '2024-01-15'),
(148, '2024-01-23', 0.00, 'Card', '2024-01-23'),
(149, '2024-01-18', 0.00, 'Card', '2024-01-18'),
(150, '2024-01-14', 0.00, 'Card', '2024-01-14'),
(151, '2024-01-09', 0.00, 'Card', '2024-01-09'),
(152, '2024-01-01', 0.00, 'Card', '2024-01-01'),
(153, '2024-01-02', 0.00, 'Card', '2024-01-02'),
(154, '2024-01-20', 0.00, 'Card', '2024-01-20'),
(155, '2024-01-07', 0.00, 'Card', '2024-01-07'),
(156, '2024-01-22', 0.00, 'Card', '2024-01-22'),
(157, '2024-01-23', 0.00, 'Card', '2024-01-23'),
(158, '2024-01-03', 0.00, 'Card', '2024-01-03'),
(159, '2024-01-09', 0.00, 'Cash', '2024-01-09'),
(160, '2024-01-13', 0.00, 'Card', '2024-01-13'),
(161, '2024-01-17', 0.00, 'Card', '2024-01-17'),
(162, '2024-01-20', 0.00, 'Card', '2024-01-20'),
(163, '2024-01-18', 0.00, 'Card', '2024-01-18'),
(164, '2024-01-07', 0.00, 'Card', '2024-01-07'),
(165, '2024-01-21', 0.00, 'Cash', '2024-01-21'),
(166, '2024-01-07', 0.00, 'Cash', '2024-01-07'),
(167, '2024-01-22', 0.00, 'Card', '2024-01-22'),
(168, '2024-01-06', 0.00, 'Card', '2024-01-06'),
(169, '2024-01-22', 0.00, 'Card', '2024-01-22'),
(170, '2024-01-10', 0.00, 'Cash', '2024-01-10'),
(171, '2024-01-20', 0.00, 'Cash', '2024-01-20'),
(172, '2024-01-12', 0.00, 'Card', '2024-01-12'),
(173, '2024-01-21', 0.00, 'Card', '2024-01-21'),
(174, '2024-01-02', 0.00, 'Card', '2024-01-02'),
(175, '2024-01-21', 0.00, 'Cash', '2024-01-21'),
(176, '2024-01-18', 0.00, 'Card', '2024-01-18'),
(177, '2024-01-23', 0.00, 'Card', '2024-01-23'),
(178, '2024-01-02', 0.00, 'Cash', '2024-01-02'),
(179, '2024-01-06', 0.00, 'Cash', '2024-01-06'),
(180, '2024-01-19', 0.00, 'Card', '2024-01-19'),
(181, '2024-01-20', 0.00, 'Cash', '2024-01-20'),
(182, '2024-01-18', 0.00, 'Cash', '2024-01-18'),
(183, '2024-01-17', 0.00, 'Cash', '2024-01-17'),
(184, '2024-01-19', 0.00, 'Cash', '2024-01-19'),
(185, '2024-01-15', 0.00, 'Card', '2024-01-15'),
(186, '2024-01-02', 0.00, 'Cash', '2024-01-02'),
(187, '2024-01-18', 0.00, 'Cash', '2024-01-18'),
(188, '2024-01-22', 0.00, 'Card', '2024-01-22'),
(189, '2024-01-03', 0.00, 'Card', '2024-01-03'),
(190, '2024-01-18', 0.00, 'Cash', '2024-01-18'),
(191, '2024-01-05', 0.00, 'Card', '2024-01-05'),
(192, '2024-01-19', 0.00, 'Cash', '2024-01-19'),
(193, '2024-01-25', 0.00, 'Cash', '2024-01-25'),
(194, '2024-01-12', 0.00, 'Card', '2024-01-12'),
(195, '2024-01-08', 0.00, 'Cash', '2024-01-08'),
(196, '2024-01-13', 0.00, 'Cash', '2024-01-13'),
(197, '2024-01-10', 0.00, 'Card', '2024-01-10'),
(198, '2024-01-08', 0.00, 'Card', '2024-01-08'),
(199, '2024-01-15', 0.00, 'Card', '2024-01-15'),
(200, '2024-01-02', 0.00, 'Cash', '2024-01-02'),
(201, '2024-01-23', 0.00, 'Card', '2024-01-23'),
(202, '2024-01-18', 0.00, 'Cash', '2024-01-18'),
(203, '2024-01-15', 0.00, 'Card', '2024-01-15'),
(204, '2024-01-12', 0.00, 'Card', '2024-01-12'),
(205, '2024-01-12', 0.00, 'Card', '2024-01-12'),
(206, '2024-01-06', 0.00, 'Card', '2024-01-06'),
(207, '2024-01-23', 0.00, 'Card', '2024-01-23'),
(208, '2024-01-05', 0.00, 'Card', '2024-01-05'),
(209, '2024-01-02', 0.00, 'Cash', '2024-01-02'),
(210, '2024-01-21', 0.00, 'Card', '2024-01-21'),
(211, '2024-01-15', 0.00, 'Card', '2024-01-15'),
(212, '2024-01-20', 0.00, 'Card', '2024-01-20'),
(213, '2024-01-05', 0.00, 'Card', '2024-01-05'),
(214, '2024-01-25', 0.00, 'Card', '2024-01-25'),
(215, '2024-01-02', 0.00, 'Cash', '2024-01-02'),
(216, '2024-01-10', 0.00, 'Cash', '2024-01-10'),
(217, '2024-01-05', 0.00, 'Card', '2024-01-05'),
(218, '2024-01-20', 0.00, 'Cash', '2024-01-20'),
(219, '2024-01-10', 0.00, 'Card', '2024-01-10'),
(220, '2024-01-18', 0.00, 'Cash', '2024-01-18'),
(221, '2024-01-13', 0.00, 'Card', '2024-01-13'),
(222, '2024-01-15', 0.00, 'Cash', '2024-01-15'),
(223, '2024-01-12', 0.00, 'Cash', '2024-01-12'),
(224, '2024-01-02', 0.00, 'Cash', '2024-01-02'),
(225, '2024-01-02', 0.00, 'Card', '2024-01-02'),
(226, '2024-01-23', 0.00, 'Card', '2024-01-23'),
(227, '2024-01-01', 0.00, 'Cash', '2024-01-01'),
(228, '2024-01-18', 0.00, 'Card', '2024-01-18'),
(229, '2024-01-24', 0.00, 'Card', '2024-01-24'),
(230, '2024-01-15', 0.00, 'Cash', '2024-01-15'),
(231, '2024-01-24', 0.00, 'Card', '2024-01-24'),
(232, '2024-01-22', 0.00, 'Card', '2024-01-22'),
(233, '2024-01-01', 0.00, 'Card', '2024-01-01'),
(234, '2024-01-14', 0.00, 'Card', '2024-01-14'),
(235, '2024-01-16', 0.00, 'Card', '2024-01-16'),
(236, '2024-01-11', 0.00, 'Card', '2024-01-11'),
(237, '2024-01-13', 0.00, 'Cash', '2024-01-13'),
(238, '2024-01-08', 0.00, 'Card', '2024-01-08'),
(239, '2024-01-10', 0.00, 'Card', '2024-01-10'),
(240, '2024-01-10', 0.00, 'Card', '2024-01-10'),
(241, '2024-01-05', 0.00, 'Card', '2024-01-05'),
(242, '2024-01-12', 0.00, 'Cash', '2024-01-12'),
(243, '2024-01-05', 0.00, 'Card', '2024-01-05'),
(244, '2024-01-06', 0.00, 'Card', '2024-01-06'),
(245, '2024-01-18', 0.00, 'Card', '2024-01-18'),
(246, '2024-01-09', 0.00, 'Card', '2024-01-09'),
(247, '2024-01-03', 0.00, 'Cash', '2024-01-03'),
(248, '2024-01-21', 0.00, 'Cash', '2024-01-21'),
(249, '2024-01-06', 0.00, 'Card', '2024-01-06'),
(250, '2024-01-08', 0.00, 'Cash', '2024-01-08'),
(251, '2024-01-12', 0.00, 'Cash', '2024-01-12'),
(252, '2024-01-01', 0.00, 'Card', '2024-01-01'),
(253, '2024-01-19', 0.00, 'Card', '2024-01-19'),
(254, '2024-01-19', 0.00, 'Card', '2024-01-19'),
(255, '2024-01-19', 0.00, 'Cash', '2024-01-19'),
(256, '2024-01-15', 0.00, 'Cash', '2024-01-15'),
(257, '2024-01-01', 0.00, 'Card', '2024-01-01'),
(258, '2024-01-23', 0.00, 'Cash', '2024-01-23'),
(259, '2024-01-20', 0.00, 'Cash', '2024-01-20'),
(260, '2024-01-12', 0.00, 'Card', '2024-01-12'),
(261, '2024-01-18', 0.00, 'Card', '2024-01-18'),
(262, '2023-12-31', 0.00, 'Cash', '2023-12-31'),
(263, '2024-01-06', 0.00, 'Cash', '2024-01-06'),
(264, '2024-01-09', 0.00, 'Card', '2024-01-09'),
(265, '2024-01-23', 0.00, 'Cash', '2024-01-23'),
(266, '2024-01-18', 0.00, 'Card', '2024-01-18'),
(267, '2024-01-13', 0.00, 'Card', '2024-01-13'),
(268, '2024-01-09', 0.00, 'Cash', '2024-01-09'),
(269, '2024-01-12', 0.00, 'Cash', '2024-01-12'),
(270, '2024-01-01', 0.00, 'Card', '2024-01-01'),
(271, '2024-01-22', 0.00, 'Card', '2024-01-22'),
(272, '2024-01-15', 0.00, 'Card', '2024-01-15'),
(273, '2024-01-04', 0.00, 'Cash', '2024-01-04'),
(274, '2024-01-07', 0.00, 'Card', '2024-01-07'),
(275, '2024-01-08', 0.00, 'Cash', '2024-01-08'),
(276, '2024-01-15', 0.00, 'Cash', '2024-01-15'),
(277, '2024-01-13', 0.00, 'Card', '2024-01-13'),
(278, '2024-01-16', 0.00, 'Cash', '2024-01-16'),
(279, '2024-01-17', 0.00, 'Cash', '2024-01-17'),
(280, '2024-01-19', 0.00, 'Cash', '2024-01-19'),
(281, '2024-01-22', 0.00, 'Cash', '2024-01-22'),
(282, '2024-01-16', 0.00, 'Card', '2024-01-16'),
(283, '2024-01-20', 0.00, 'Cash', '2024-01-20'),
(284, '2024-01-12', 0.00, 'Cash', '2024-01-12'),
(285, '2024-01-24', 0.00, 'Card', '2024-01-24'),
(286, '2024-01-09', 0.00, 'Cash', '2024-01-09'),
(287, '2024-01-18', 0.00, 'Cash', '2024-01-18'),
(288, '2024-01-06', 0.00, 'Cash', '2024-01-06'),
(289, '2024-01-24', 0.00, 'Cash', '2024-01-24'),
(290, '2024-01-07', 0.00, 'Card', '2024-01-07'),
(291, '2024-01-09', 0.00, 'Cash', '2024-01-09'),
(292, '2024-01-17', 0.00, 'Cash', '2024-01-17'),
(293, '2024-01-17', 0.00, 'Card', '2024-01-17'),
(294, '2024-01-04', 0.00, 'Cash', '2024-01-04'),
(295, '2024-01-23', 0.00, 'Cash', '2024-01-23'),
(296, '2024-01-03', 0.00, 'Card', '2024-01-03'),
(297, '2024-01-14', 0.00, 'Cash', '2024-01-14'),
(298, '2024-01-16', 0.00, 'Cash', '2024-01-16'),
(299, '2024-01-08', 0.00, 'Cash', '2024-01-08'),
(300, '2024-01-20', 0.00, 'Card', '2024-01-20'),
(301, '2024-01-21', 0.00, 'Cash', '2024-01-21'),
(302, '2024-01-10', 0.00, 'Card', '2024-01-10'),
(303, '2024-01-12', 0.00, 'Card', '2024-01-12'),
(304, '2024-01-23', 0.00, 'Cash', '2024-01-23'),
(305, '2024-01-11', 0.00, 'Card', '2024-01-11'),
(306, '2024-01-12', 0.00, 'Cash', '2024-01-12'),
(307, '2024-01-17', 0.00, 'Cash', '2024-01-17'),
(308, '2024-01-14', 0.00, 'Cash', '2024-01-14'),
(309, '2024-01-12', 0.00, 'Card', '2024-01-12'),
(310, '2024-01-16', 0.00, 'Card', '2024-01-16'),
(311, '2024-01-09', 0.00, 'Card', '2024-01-09'),
(312, '2024-01-21', 0.00, 'Cash', '2024-01-21'),
(313, '2024-01-14', 0.00, 'Cash', '2024-01-14'),
(314, '2024-01-06', 0.00, 'Card', '2024-01-06'),
(315, '2024-01-13', 0.00, 'Card', '2024-01-13'),
(316, '2024-01-07', 0.00, 'Card', '2024-01-07'),
(317, '2024-01-03', 0.00, 'Card', '2024-01-03'),
(318, '2024-01-01', 0.00, 'Cash', '2024-01-01'),
(319, '2024-01-06', 0.00, 'Card', '2024-01-06'),
(320, '2024-01-09', 0.00, 'Card', '2024-01-09'),
(321, '2023-12-31', 0.00, 'Cash', '2023-12-31'),
(322, '2024-01-11', 0.00, 'Card', '2024-01-11'),
(323, '2024-01-09', 0.00, 'Cash', '2024-01-09'),
(324, '2024-01-10', 0.00, 'Cash', '2024-01-10'),
(325, '2024-01-12', 0.00, 'Cash', '2024-01-12'),
(326, '2024-01-11', 0.00, 'Card', '2024-01-11'),
(327, '2024-01-02', 0.00, 'Cash', '2024-01-02'),
(328, '2024-01-02', 0.00, 'Card', '2024-01-02'),
(329, '2024-01-19', 0.00, 'Cash', '2024-01-19'),
(330, '2024-01-14', 0.00, 'Card', '2024-01-14'),
(331, '2024-01-18', 0.00, 'Card', '2024-01-18'),
(332, '2024-01-04', 0.00, 'Cash', '2024-01-04'),
(333, '2024-01-02', 0.00, 'Card', '2024-01-02'),
(334, '2024-01-03', 0.00, 'Cash', '2024-01-03'),
(335, '2024-01-09', 0.00, 'Cash', '2024-01-09'),
(336, '2024-01-02', 0.00, 'Card', '2024-01-02'),
(337, '2024-01-14', 0.00, 'Cash', '2024-01-14'),
(338, '2024-01-19', 0.00, 'Card', '2024-01-19'),
(339, '2024-01-09', 0.00, 'Card', '2024-01-09'),
(340, '2024-01-01', 0.00, 'Cash', '2024-01-01'),
(341, '2024-01-08', 0.00, 'Cash', '2024-01-08'),
(342, '2024-01-09', 0.00, 'Card', '2024-01-09'),
(343, '2024-01-03', 0.00, 'Cash', '2024-01-03'),
(344, '2024-01-17', 0.00, 'Card', '2024-01-17'),
(345, '2024-01-21', 0.00, 'Card', '2024-01-21'),
(346, '2024-01-16', 0.00, 'Cash', '2024-01-16'),
(347, '2024-01-24', 0.00, 'Card', '2024-01-24'),
(348, '2024-01-05', 0.00, 'Cash', '2024-01-05'),
(349, '2024-01-17', 0.00, 'Cash', '2024-01-17'),
(350, '2024-01-18', 0.00, 'Cash', '2024-01-18'),
(351, '2024-01-16', 0.00, 'Card', '2024-01-16'),
(352, '2024-01-02', 0.00, 'Card', '2024-01-02'),
(353, '2024-01-23', 0.00, 'Card', '2024-01-23'),
(354, '2024-01-15', 0.00, 'Card', '2024-01-15'),
(355, '2024-01-08', 0.00, 'Cash', '2024-01-08'),
(356, '2024-01-20', 0.00, 'Cash', '2024-01-20'),
(357, '2024-01-01', 0.00, 'Cash', '2024-01-01'),
(358, '2024-01-01', 0.00, 'Cash', '2024-01-01'),
(359, '2024-01-15', 0.00, 'Card', '2024-01-15'),
(360, '2024-01-16', 0.00, 'Card', '2024-01-16'),
(361, '2024-01-08', 0.00, 'Card', '2024-01-08'),
(362, '2024-01-10', 0.00, 'Card', '2024-01-10'),
(363, '2024-01-21', 0.00, 'Cash', '2024-01-21'),
(364, '2024-01-15', 0.00, 'Card', '2024-01-15'),
(365, '2024-01-21', 0.00, 'Card', '2024-01-21'),
(366, '2024-01-01', 0.00, 'Card', '2024-01-01'),
(367, '2024-01-04', 0.00, 'Card', '2024-01-04'),
(368, '2024-01-05', 0.00, 'Cash', '2024-01-05'),
(369, '2024-01-06', 0.00, 'Cash', '2024-01-06'),
(370, '2024-01-20', 0.00, 'Cash', '2024-01-20'),
(371, '2024-01-04', 0.00, 'Cash', '2024-01-04'),
(372, '2024-01-16', 0.00, 'Card', '2024-01-16'),
(373, '2024-01-05', 0.00, 'Card', '2024-01-05'),
(374, '2024-01-10', 0.00, 'Cash', '2024-01-10'),
(375, '2024-01-17', 0.00, 'Card', '2024-01-17'),
(376, '2024-01-01', 0.00, 'Cash', '2024-01-01'),
(377, '2024-01-03', 0.00, 'Cash', '2024-01-03'),
(378, '2024-01-09', 0.00, 'Card', '2024-01-09'),
(379, '2024-01-15', 0.00, 'Card', '2024-01-15'),
(380, '2024-01-04', 0.00, 'Cash', '2024-01-04'),
(381, '2024-01-11', 0.00, 'Cash', '2024-01-11'),
(382, '2024-01-04', 0.00, 'Cash', '2024-01-04'),
(383, '2024-01-05', 0.00, 'Card', '2024-01-05'),
(384, '2023-12-30', 0.00, 'Card', '2023-12-30'),
(385, '2024-01-20', 0.00, 'Card', '2024-01-20'),
(386, '2024-01-15', 0.00, 'Cash', '2024-01-15'),
(387, '2024-01-01', 0.00, 'Cash', '2024-01-01'),
(388, '2024-01-13', 0.00, 'Cash', '2024-01-13'),
(389, '2024-01-03', 0.00, 'Card', '2024-01-03'),
(390, '2024-01-07', 0.00, 'Card', '2024-01-07'),
(391, '2024-01-11', 0.00, 'Card', '2024-01-11'),
(392, '2024-01-11', 0.00, 'Cash', '2024-01-11'),
(393, '2024-01-07', 0.00, 'Card', '2024-01-07'),
(394, '2023-12-31', 0.00, 'Cash', '2023-12-31'),
(395, '2024-01-01', 0.00, 'Card', '2024-01-01'),
(396, '2024-01-01', 0.00, 'Card', '2024-01-01'),
(397, '2024-01-15', 0.00, 'Card', '2024-01-15'),
(398, '2024-01-20', 0.00, 'Cash', '2024-01-20'),
(399, '2024-01-03', 0.00, 'Cash', '2024-01-03'),
(400, '2024-01-04', 0.00, 'Cash', '2024-01-04'),
(401, '2024-01-13', 0.00, 'Card', '2024-01-13'),
(402, '2024-01-09', 0.00, 'Cash', '2024-01-09'),
(403, '2024-01-08', 0.00, 'Cash', '2024-01-08'),
(404, '2024-01-14', 0.00, 'Card', '2024-01-14'),
(405, '2024-01-05', 0.00, 'Cash', '2024-01-05'),
(406, '2024-01-05', 0.00, 'Cash', '2024-01-05'),
(407, '2024-01-18', 0.00, 'Cash', '2024-01-18'),
(408, '2024-01-01', 0.00, 'Card', '2024-01-01'),
(409, '2024-01-03', 0.00, 'Card', '2024-01-03'),
(410, '2024-01-03', 0.00, 'Card', '2024-01-03'),
(411, '2024-01-22', 0.00, 'Card', '2024-01-22'),
(412, '2024-01-01', 0.00, 'Card', '2024-01-01'),
(413, '2024-01-18', 0.00, 'Card', '2024-01-18'),
(414, '2024-01-18', 0.00, 'Card', '2024-01-18'),
(415, '2024-01-10', 0.00, 'Cash', '2024-01-10'),
(416, '2024-01-09', 0.00, 'Cash', '2024-01-09'),
(417, '2024-01-03', 0.00, 'Card', '2024-01-03'),
(418, '2024-01-18', 0.00, 'Cash', '2024-01-18'),
(419, '2024-01-16', 0.00, 'Card', '2024-01-16'),
(420, '2024-01-24', 0.00, 'Cash', '2024-01-24'),
(421, '2024-01-11', 0.00, 'Cash', '2024-01-11'),
(422, '2024-01-22', 0.00, 'Card', '2024-01-22'),
(423, '2024-01-24', 0.00, 'Cash', '2024-01-24'),
(424, '2024-01-18', 0.00, 'Cash', '2024-01-18'),
(425, '2024-01-21', 0.00, 'Card', '2024-01-21'),
(426, '2024-01-12', 0.00, 'Cash', '2024-01-12'),
(427, '2024-01-06', 0.00, 'Card', '2024-01-06'),
(428, '2024-01-03', 0.00, 'Card', '2024-01-03'),
(429, '2024-01-16', 0.00, 'Cash', '2024-01-16'),
(430, '2024-01-11', 0.00, 'Cash', '2024-01-11'),
(431, '2024-01-08', 0.00, 'Cash', '2024-01-08'),
(432, '2024-01-20', 0.00, 'Card', '2024-01-20'),
(433, '2024-01-21', 0.00, 'Cash', '2024-01-21'),
(434, '2024-01-10', 0.00, 'Card', '2024-01-10'),
(435, '2024-01-05', 0.00, 'Card', '2024-01-05'),
(436, '2024-01-11', 0.00, 'Card', '2024-01-11'),
(437, '2024-01-09', 0.00, 'Cash', '2024-01-09'),
(438, '2024-01-10', 0.00, 'Card', '2024-01-10'),
(439, '2024-01-18', 0.00, 'Card', '2024-01-18'),
(440, '2024-01-12', 0.00, 'Card', '2024-01-12'),
(441, '2024-01-08', 0.00, 'Card', '2024-01-08'),
(442, '2024-01-01', 0.00, 'Cash', '2024-01-01'),
(443, '2024-01-12', 0.00, 'Cash', '2024-01-12'),
(444, '2024-01-11', 0.00, 'Cash', '2024-01-11'),
(445, '2024-01-13', 0.00, 'Card', '2024-01-13'),
(446, '2024-01-19', 0.00, 'Card', '2024-01-19'),
(447, '2024-01-01', 0.00, 'Cash', '2024-01-01'),
(448, '2024-01-21', 0.00, 'Card', '2024-01-21'),
(449, '2024-01-05', 0.00, 'Card', '2024-01-05'),
(450, '2024-01-12', 0.00, 'Cash', '2024-01-12'),
(451, '2023-12-30', 0.00, 'Card', '2023-12-30'),
(452, '2024-01-06', 0.00, 'Card', '2024-01-06'),
(453, '2024-01-04', 0.00, 'Card', '2024-01-04'),
(454, '2024-01-02', 0.00, 'Cash', '2024-01-02'),
(455, '2024-01-11', 0.00, 'Card', '2024-01-11'),
(456, '2024-01-05', 0.00, 'Cash', '2024-01-05'),
(457, '2024-01-17', 0.00, 'Cash', '2024-01-17'),
(458, '2024-01-03', 0.00, 'Cash', '2024-01-03'),
(459, '2024-01-23', 0.00, 'Cash', '2024-01-23'),
(460, '2024-01-04', 0.00, 'Cash', '2024-01-04'),
(461, '2023-12-30', 0.00, 'Card', '2023-12-30'),
(462, '2024-01-05', 0.00, 'Cash', '2024-01-05'),
(463, '2024-01-20', 0.00, 'Card', '2024-01-20'),
(464, '2024-01-06', 0.00, 'Cash', '2024-01-06'),
(465, '2024-01-02', 0.00, 'Cash', '2024-01-02'),
(466, '2023-12-30', 0.00, 'Card', '2023-12-30'),
(467, '2024-01-08', 0.00, 'Card', '2024-01-08'),
(468, '2024-01-10', 0.00, 'Cash', '2024-01-10'),
(469, '2024-01-17', 0.00, 'Card', '2024-01-17'),
(470, '2024-01-07', 0.00, 'Card', '2024-01-07'),
(471, '2024-01-23', 0.00, 'Cash', '2024-01-23'),
(472, '2024-01-02', 0.00, 'Card', '2024-01-02'),
(473, '2024-01-10', 0.00, 'Card', '2024-01-10'),
(474, '2023-12-30', 0.00, 'Card', '2023-12-30'),
(475, '2024-01-02', 0.00, 'Card', '2024-01-02'),
(476, '2024-01-10', 0.00, 'Card', '2024-01-10'),
(477, '2024-01-11', 0.00, 'Cash', '2024-01-11'),
(478, '2024-01-10', 0.00, 'Cash', '2024-01-10'),
(479, '2024-01-06', 0.00, 'Cash', '2024-01-06'),
(480, '2024-01-11', 0.00, 'Card', '2024-01-11'),
(481, '2024-01-18', 0.00, 'Cash', '2024-01-18'),
(482, '2024-01-09', 0.00, 'Cash', '2024-01-09'),
(483, '2024-01-03', 0.00, 'Cash', '2024-01-03'),
(484, '2024-01-08', 0.00, 'Card', '2024-01-08'),
(485, '2024-01-09', 0.00, 'Cash', '2024-01-09'),
(486, '2024-01-11', 0.00, 'Cash', '2024-01-11'),
(487, '2024-01-23', 0.00, 'Card', '2024-01-23'),
(488, '2024-01-10', 0.00, 'Cash', '2024-01-10'),
(489, '2024-01-11', 0.00, 'Cash', '2024-01-11'),
(490, '2023-12-31', 0.00, 'Card', '2023-12-31'),
(491, '2024-01-24', 0.00, 'Card', '2024-01-24'),
(492, '2024-01-03', 0.00, 'Card', '2024-01-03'),
(493, '2024-01-05', 0.00, 'Cash', '2024-01-05'),
(494, '2024-01-11', 0.00, 'Cash', '2024-01-11'),
(495, '2024-01-08', 0.00, 'Card', '2024-01-08'),
(496, '2024-01-24', 0.00, 'Cash', '2024-01-24'),
(497, '2024-01-02', 0.00, 'Card', '2024-01-02'),
(498, '2024-01-22', 0.00, 'Cash', '2024-01-22'),
(499, '2024-01-16', 0.00, 'Card', '2024-01-16'),
(500, '2024-01-01', 0.00, 'Cash', '2024-01-01');



--INDERIAS
--Inserting Into Ticket Table
DECLARE @myBookingID INT = 1;
DECLARE @myShowID INT = 1;
DECLARE @mySeatID INT = 1;
DECLARE @myTicketsPerBooking INT;

WHILE @myBookingID <= 500  -- For 500 bookings
BEGIN

	-- Randomly assign TicketsPerBooking from (1, 8, 15, 20)
    DECLARE @myrandIndex INT = FLOOR(RAND() * 4); -- random index: 0 to 3

	-- Map index to allowed values
    SET @myTicketsPerBooking = 
        CASE @myrandIndex
            WHEN 0 THEN 1
            WHEN 1 THEN 8
            WHEN 2 THEN 15
            WHEN 3 THEN 20
        END;


    DECLARE @ii INT = 1;
    WHILE @ii <= @myTicketsPerBooking
    BEGIN
        INSERT INTO Ticket (BookingID, ShowID, SeatID)
        VALUES (@myBookingID, @myShowID, @mySeatID);

		-- Move to next seat
        SET @mySeatID = @mySeatID + 1;

        -- If SeatID > 7, go to next ShowID and reset SeatID
        IF @mySeatID > 7
        BEGIN
            SET @myShowID = @myShowID + 1;

			IF @mySeatID > 900
				SET @mySeatID = 1;
        END

        -- Optional safety: wrap ShowID back to 1 if exceeds 750
        IF @myShowID > 750
            SET @myShowID = 1;

        SET @ii = @ii + 1;
    END

    SET @myBookingID = @myBookingID + 1;
END


Update T
Set T.Price = 
    Case 
        When H.FloorNumber = 1 And S.SeatType = 'Premium' Then 1000
        When H.FloorNumber = 1 And S.SeatType = 'Standard' Then 500
        When H.FloorNumber = 2 And S.SeatType = 'Premium' Then 1200
        When H.FloorNumber = 2 And S.SeatType = 'Standard' Then 700
        Else 0
    End
From Ticket T
Join Seat S On T.SeatId = S.SeatId
Join Hall H On S.HallId = H.HallId;


-----------------------------
UPDATE B
SET B.TotalAmount = T.TotalPrice
FROM Booking B
JOIN (
    SELECT BookingID, SUM(Price) AS TotalPrice
    FROM Ticket
    GROUP BY BookingID
) T ON B.BookingID = T.BookingID;

-- Set BookingDate and PaymentDate based on the related ShowDate
UPDATE b
SET 
    b.BookingDate = DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 3), s.ShowDate),
    b.PaymentDate = DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 3), s.ShowDate)
FROM 
    Booking b
JOIN 
    Ticket t ON b.BookingID = t.BookingID
JOIN 
    Show s ON t.ShowID = s.ShowID;


--yashab
DECLARE @CustomerID INT = 1;
DECLARE @OrderID INT = 1;
DECLARE @PaymentMethod VARCHAR(10);
DECLARE @ShoweID INT;
DECLARE @ShowDate DATE;

-- Temporary table to get a valid ShowDate
-- Make sure this table exists or replace it with your actual logic
-- Assuming ShowID ranges from 1 to 750

WHILE @CustomerID <= 500
BEGIN
    -- Two orders per customer
    DECLARE @j INT = 1;
    WHILE @j <= 2
    BEGIN
        -- Random ShowID between 1 and 750
        SET @ShoweID = FLOOR(RAND() * 750) + 1;

        -- Get the show date
        SELECT @ShowDate = ShowDate FROM Show WHERE ShowID = @ShoweID;

        -- Alternate payment method
        SET @PaymentMethod = CASE WHEN @OrderID % 2 = 0 THEN 'Card' ELSE 'Cash' END;

        INSERT INTO [Order] (CustomerID, OrderDate, PaymentMethod)
        VALUES (@CustomerID, @ShowDate, @PaymentMethod);

        SET @OrderID = @OrderID + 1;
        SET @j = @j + 1;
    END

    SET @CustomerID = @CustomerID + 1;
END

-- Make PaymentDate same as BookingDate
UPDATE Booking
SET PaymentDate = BookingDate;


UPDATE Seat
SET Status = 'Booked'
WHERE SeatID IN (
    SELECT DISTINCT SeatID
    FROM Ticket
);

-- Set Order.PaymentMethod to match Booking.PaymentMethod for each customer
UPDATE O
SET O.PaymentMethod = B.PaymentMethod
FROM [Order] O
JOIN Booking B ON O.CustomerID = B.CustomerID;




UPDATE O
SET O.OrderDate = S.ShowDate
FROM [Order] O
JOIN Booking B ON B.CustomerID = O.CustomerID
JOIN Ticket T ON T.BookingID = B.BookingID
JOIN Show S ON S.ShowID = T.ShowID;


--Creation of OrderDetail
DECLARE @z INT = 1;

WHILE @z <= 1000
BEGIN
    INSERT INTO OrderDetail (OrderID, FoodItemID, Quantity)
    VALUES (
        @z,
        FLOOR(RAND(CHECKSUM(NEWID())) * 10) + 1,   -- FoodItemID: 1 to 10
        FLOOR(RAND(CHECKSUM(NEWID())) * 5) + 1     -- Quantity: 1 to 5
    );

    SET @z = @z + 1;
END

--adding area to customer
-- Step 1: Add the Area column (if not already added)
ALTER TABLE Customer ADD Area VARCHAR(100);

-- Step 2: Create and populate the area list
CREATE TABLE #AreaList (
    AreaID INT IDENTITY(1,1),
    AreaName VARCHAR(100)
);

INSERT INTO #AreaList (AreaName)
VALUES 
('DHA Phase 1'), ('DHA Phase 2'), ('DHA Phase 3'), ('DHA Phase 4'), ('DHA Phase 5'),
('DHA Phase 6'), ('DHA Phase 7'), ('DHA Phase 8'), ('DHA Phase 9'), ('DHA Phase 10'),
('Askari Flats'), ('Askari Villas'),
('Askari 1'), ('Askari 2'), ('Askari 3'), ('Askari 4'), ('Askari 5'), ('Askari 6'),
('Askari 7'), ('Askari 8'), ('Askari 9'), ('Askari 10'), ('Askari 11'),
('Walton'), ('Bahria'), ('Model Town'), ('Johar Town'), ('Cantt'), ('Wapda Town'),
('Faisal Town'), ('Izmir Town'), ('Canal Berg'), ('Garhi Shahu'),
('Gulberg 1'), ('Gulberg 2'), ('Gulberg 3'), ('Walled City'), ('DHA EME'), ('DHA Raya');

-- Step 3: Update each customer with a truly random area
;WITH RandomAreas AS (
    SELECT 
        C.CustomerID,
        A.AreaName,
        ROW_NUMBER() OVER (PARTITION BY C.CustomerID ORDER BY NEWID()) AS rn
    FROM Customer C
    CROSS JOIN #AreaList A
)
UPDATE C
SET C.Area = R.AreaName
FROM Customer C
JOIN RandomAreas R ON C.CustomerID = R.CustomerID AND R.rn = 1;

-- Step 4: Clean up
DROP TABLE #AreaList;


--Inserting Feedback


Insert Into Feedback (MovieID, Rating, Comments) VALUES
-- MovieID 1 (5 entries)
(1, 5, 'Absolutely loved every minute of it!'),
(1, 4.9, 'Very well made with great performances.'),
(1, 4.3, 'Enjoyable but not particularly memorable.'),
(1, 5, 'Would definitely watch again and recommend.'),
(1, 4.8, 'it was good.'),

-- MovieID 2 (5 entries)
(2, 5, 'One of the best I''ve seen recently!'),
(2, 4, 'Solid entertainment from start to finish.'),
(2, 3, 'Good enough to pass the time.'),
(2, 1, 'Really disappointing experience.'),
(2, 5, 'Exceeded all my expectations!'),

-- MovieID 3 (5 entries)
(3, 4.1, 'Well-crafted and engaging throughout.'),
(3, 5, 'Perfect in every way - loved it!'),
(3, 5, 'PERFECTO.'),
(3, 3.9, 'very special.'),
(3, 5, 'Instant favorite - so well done!'),

-- MovieID 4 (5 entries)
(4, 1, 'Not my taste at all.'),
(4, 2, 'Had some good moments but mostly weak.'),
(4, 4, 'Surprisingly enjoyable!'),
(4, 3, 'Average - neither good nor bad.'),
(4, 5, 'Why aren''t more people talking about this?'),

-- MovieID 5 (5 entries)
(5, 5, 'Masterfully executed production.'),
(5, 4, 'High quality work all around.'),
(5, 5, 'Flawless from beginning to end.'),
(5, 3, 'Good but not great.'),
(5, 2, 'Expected more from this.'),

-- MovieID 6 (5 entries)
(6, 4, 'Kept me interested the whole time.'),
(6, 5, 'Exceptional - worth watching twice!'),
(6, 5, 'Some good elements but uneven.'),
(6, 2, 'Not as good as I hoped.'),
(6, 1, 'Waste of time unfortunately.'),

-- MovieID 7 (5 entries)
(7, 5, 'Pure entertainment - loved it!'),
(7, 4, 'Very well put together.'),
(7, 3, 'Had its moments.'),
(7, 5, 'Couldn''t have been better!'),
(7, 2, 'Not what I was expecting.'),

-- MovieID 8 (5 entries)
(8, 4, 'Beautifully made production.'),
(8, 5, 'Absolutely perfect in every way.'),
(8, 3, 'Somewhat slow but decent.'),
(8, 2, 'Didn''t live up to the hype.'),
(8, 4, 'Grew on me as it progressed.'),

-- MovieID 9 (5 entries)
(9, 1, 'Really didn''t enjoy this one.'),
(9, 3, 'Had potential but fell short.'),
(9, 4, 'Much better than expected!'),
(9, 2, 'Forgettable experience.'),
(9, 5, 'Why the negative reviews? I adored it!'),

-- MovieID 10 (5 entries)
(10, 5, 'Perfect conclusion to the story.'),
(10, 4, 'Satisfying watch overall.'),
(10, 3, 'Not bad but could be better.'),
(10, 2, 'Disappointing compared to others.'),
(10, 1, 'Really didn''t work for me.'),

-- MovieID 11 (5 entries)
(11, 4, 'Strong performances throughout.'),
(11, 5, 'One of my new favorites!'),
(11, 3, 'Decent but unremarkable.'),
(11, 2, 'Not my cup of tea.'),
(11, 4, 'Surprisingly deep and meaningful.'),

-- MovieID 12 (5 entries)
(12, 5, 'Top-notch quality all around.'),
(12, 4, 'Excellent craftsmanship.'),
(12, 3, 'Worth a single viewing.'),
(12, 2, 'Overrated in my opinion.'),
(12, 1, 'Really didn''t enjoy this.'),

-- MovieID 13 (5 entries)
(13, 5, 'Touching and well-executed.'),
(13, 4, 'Made me think differently.'),
(13, 3, 'Good message but average delivery.'),
(13, 2, 'Too heavy-handed for my taste.'),
(13, 5, 'Will definitely watch again!'),

-- MovieID 14 (5 entries)
(14, 4, 'Great chemistry between actors.'),
(14, 5, 'Perfect for what it is!'),
(14, 3, 'Enjoyable but lightweight.'),
(14, 2, 'Too simplistic for my taste.'),
(14, 1, 'Just didn''t work for me.'),

-- MovieID 15 (5 entries)
(15, 5, 'Brilliantly constructed narrative.'),
(15, 4, 'Kept me engaged throughout.'),
(15, 3, 'Interesting approach but flawed.'),
(15, 2, 'Tried too hard to be clever.'),
(15, 5, 'Exceptional storytelling!'),

-- MovieID 16 (5 entries)
(16, 4, 'Acting saved weaker elements.'),
(16, 3, 'Mediocre overall.'),
(16, 2, 'Not as good as it could be.'),
(16, 1, 'Missed the mark completely.'),
(16, 5, 'Better than expected!'),

-- MovieID 17 (5 entries)
(17, 5, 'Great balance of elements.'),
(17, 4, 'Well-produced and engaging.'),
(17, 3, 'Entertaining but forgettable.'),
(17, 2, 'Too conventional for my taste.'),
(17, 1, 'Technical issues ruined it.'),

-- MovieID 18 (5 entries)
(18, 5, 'New personal favorite!'),
(18, 4, 'Beautifully crafted work.'),
(18, 3, 'Good for casual viewing.'),
(18, 2, 'Not up to usual standards.'),
(18, 5, 'Instant classic in my book!'),

-- MovieID 19 (5 entries)
(19, 4, 'Well-made and informative.'),
(19, 5, 'Thought-provoking experience.'),
(19, 3, 'Educational but slow.'),
(19, 2, 'Too one-sided presentation.'),
(19, 1, 'Not worth the time.'),

-- MovieID 20 (5 entries)
(20, 5, 'Exceptionally well done!'),
(20, 4, 'Kept me on the edge of my seat.'),
(20, 3, 'Good atmosphere but weak finish.'),
(20, 2, 'Didn''t deliver as promised.'),
(20, 1, 'Complete letdown.'),

-- MovieID 21 (5 entries)
(21, 4, 'Really enjoyed this one - solid entertainment.'),
(21, 5, 'Absolutely loved every aspect of it!'),
(21, 3, 'Decent enough to pass the time.'),
(21, 2, 'Had higher expectations for this.'),
(21, 4, 'Surprisingly good - would recommend.'),

-- MovieID 22 (5 entries)
(22, 5, 'One of my new favorites!'),
(22, 3, 'Some good moments but uneven overall.'),
(22, 4, 'Well-made and engaging throughout.'),
(22, 2, 'Not quite my taste.'),
(22, 5, 'Perfect from start to finish!'),

-- MovieID 23 (5 entries)
(23, 4, 'Enjoyed this more than I expected.'),
(23, 3, 'Average but watchable.'),
(23, 5, 'Exceptional quality all around.'),
(23, 2, 'Could have been much better.'),
(23, 1, 'Really didnt work for me.'),

-- MovieID 24 (5 entries)
(24, 5, 'Masterfully done. loved it!'),
(24, 4, 'Solid production values'),
(24, 3, 'Good but not great.'),
(24, 2, 'Disappointing execution.'),
(24, 5, 'Will definitely watch again.'),

-- MovieID 25 (5 entries)
(25, 4, 'Kept me interested the whole time.'),
(25, 5, 'Exceeded all my expectations!'),
(25, 3, 'Had its moments.'),
(25, 2, 'Not as good as it could be.'),
(25, 1, 'Waste of time unfortunately.'),

-- MovieID 26 (5 entries)
(26, 5, 'Pure entertainment fantastic!'),
(26, 4, 'Well put together overall.'),
(26, 3, 'Decent but forgettable.'),
(26, 2, 'Too predictable for my taste.'),
(26, 5, 'Instant classic in my book!'),

-- MovieID 27 (5 entries)
(27, 4, 'Beautifully crafted production.'),
(27, 5, 'Couldnt have been better!'),
(27, 3, 'Somewhat slow in parts.'),
(27, 2, 'Didnt live up to potential.'),
(27, 4, 'Grew on me as it went along.'),

-- MovieID 28 (5 entries)
(28, 1, 'Really didnt enjoy this.'),
(28, 3, 'Had some good elements.'),
(28, 4, 'Much better than I expected!'),
(28, 2, 'Forgettable experience.'),
(28, 5, 'Why the mixed reviews? I loved it!'),

-- MovieID 29 (5 entries)
(29, 5, 'Perfect execution all around.'),
(29, 4, 'Satisfying watch overall.'),
(29, 3, 'Not bad but nothing special.'),
(29, 2, 'Disappointing compared to others.'),
(29, 1, 'Just didnt click with me.'),

-- MovieID 30 (5 entries)
(30, 4, 'Strong performances throughout.'),
(30, 5, 'New personal favorite!'),
(30, 3, 'Average atbest.'),
(30, 2, 'Not my preferred style.'),
(30, 4, 'Surprisingly meaningful.'),

-- MovieID 31 (5 entries)
(31, 5, 'Topp notch quality throughout'),
(31, 4, 'Excellent craftsmanship.'),
(31, 3, 'Worth watching once.'),
(31, 2, 'Overhyped in my opinion.'),
(31, 1, 'Really didnt enjoy this.'),

-- MovieID 32 (5 entries)
(32, 5, 'Touching and wellmade.'),
(32, 4, 'Made me think differently.'),
(32, 3, 'Good intentions but average result.'),
(32, 2, 'Too obvious for my taste.'),
(32, 5, 'Will watch again soon!'),

-- MovieID 33 (5 entries)
(33, 4, 'Great chemistry between cast.'),
(33, 5, 'Perfect for what it aims to be!'),
(33, 3, 'Enjoyable but lightweight.'),
(33, 2, 'Too simplistic overall.'),
(33, 1, 'Just didnt connect with me.'),

-- MovieID 34 (5 entries)
(34, 5, 'Brilliant storytelling!'),
(34, 4, 'Kept me fully engaged.'),
(34, 3, 'Interesting but flawed.'),
(34, 2, 'Tried too hard to impress.'),
(34, 5, 'Exceptional in every way!'),

-- MovieID 35 (5 entries)
(35, 4, 'Acting elevated the material.'),
(35, 3, 'Mediocre overall experience.'),
(35, 2, 'Not as good as promised.'),
(35, 1, 'Complete miss for me.'),
(35, 5, 'Better than I expected!'),

-- MovieID 36 (5 entries)
(36, 5, 'Great balance of elements.'),
(36, 4, 'Well-produced and polished.'),
(36, 3, 'Entertaining but forgettable.'),
(36, 2, 'Too conventional overall.'),
(36, 1, 'Technical issues distracted me.'),

-- MovieID 37 (5 entries)
(37, 5, 'New favorite in this category!'),
(37, 4, 'Beautifully executed work.'),
(37, 3, 'Good casual viewing.'),
(37, 2, 'Below usual standards.'),
(37, 5, 'Instant classic for me!'),

-- MovieID 38 (5 entries)
(38, 4, 'Well-made and thoughtful.'),
(38, 5, 'Deeply moving experience.'),
(38, 3, 'Educational but slow.'),
(38, 2, 'Too one-sided approach.'),
(38, 1, 'Not worth my time.'),

-- MovieID 39 (5 entries)
(39, 5, 'Exceptionally well crafted!'),
(39, 4, 'Kept me thoroughly engaged.'),
(39, 3, 'Good setup but weak ending.'),
(39, 2, 'Didnt deliver as expected.'),
(39, 1, 'Complete disappointment.'),

-- MovieID 40 (5 entries)
(40, 4, 'Really satisfying experience.'),
(40, 5, 'Perfect in every aspect!'),
(40, 3, 'Good but not outstanding.'),
(40, 2, 'Expected more from this.'),
(40, 5, 'Will recommend to everyone!'),

(41, 4, 'Really satisfying experience.'),
(41, 5, 'Perfect in every aspect!'),
(41, 3, 'Good but not outstanding.'),
(41, 2, 'Expected more from this.'),
(41, 5, 'Will recommend to everyone!'),

(42, 3, 'Good but not outstanding.'),
(42, 5, 'Perfect in every aspect!'),
(42, 2, 'Expected more from this.'),
(42, 4, 'Really satisfying experience.'),
(42, 1, 'Not what I expected at all.'),

(43, 2, 'Could have been better.'),
(43, 5, 'Will recommend to everyone!'),
(43, 3, 'Average, but enjoyable.'),
(43, 4, 'Really satisfying experience.'),
(43, 1, 'Not what I expected at all.'),

(44, 5, 'Perfect in every aspect!'),
(44, 3, 'Good but not outstanding.'),
(44, 4, 'Really satisfying experience.'),
(44, 2, 'Expected more from this.'),
(44, 1, 'Not what I expected at all.'),

(45, 3, 'Good but not outstanding.'),
(45, 2, 'Could have been better.'),
(45, 4, 'Really satisfying experience.'),
(45, 5, 'Will recommend to everyone!'),
(45, 1, 'Not what I expected at all.'),

(46, 5, 'Perfect in every aspect!'),
(46, 4, 'Really satisfying experience.'),
(46, 3, 'Good but not outstanding.'),
(46, 2, 'Expected more from this.'),
(46, 1, 'Not what I expected at all.'),

(47, 3, 'Average, but enjoyable.'),
(47, 4, 'Really satisfying experience.'),
(47, 5, 'Perfect in every aspect!'),
(47, 2, 'Could have been better.'),
(47, 1, 'Not what I expected at all.'),

(48, 2, 'Expected more from this.'),
(48, 3, 'Good but not outstanding.'),
(48, 4, 'Really satisfying experience.'),
(48, 5, 'Perfect in every aspect!'),
(48, 1, 'Not what I expected at all.'),

(49, 3, 'Average, but enjoyable.'),
(49, 2, 'Expected more from this.'),
(49, 1, 'Not what I expected at all.'),
(49, 4, 'Really satisfying experience.'),
(49, 5, 'Will recommend to everyone!'),

(50, 5, 'Perfect in every aspect!'),
(50, 3, 'Good but not outstanding.'),
(50, 4, 'Really satisfying experience.'),
(50, 2, 'Could have been better.'),
(50, 1, 'Not what I expected at all.'),

(51, 5, 'Will recommend to everyone!'),
(51, 4, 'Really satisfying experience.'),
(51, 3, 'Average, but enjoyable.'),
(51, 2, 'Expected more from this.'),
(51, 1, 'Not what I expected at all.'),

(52, 3, 'Good but not outstanding.'),
(52, 4, 'Really satisfying experience.'),
(52, 5, 'Perfect in every aspect!'),
(52, 2, 'Could have been better.'),
(52, 1, 'Not what I expected at all.'),

(53, 1, 'Not what I expected at all.'),
(53, 2, 'Expected more from this.'),
(53, 3, 'Good but not outstanding.'),
(53, 4, 'Really satisfying experience.'),
(53, 5, 'Will recommend to everyone!'),

(54, 2, 'Could have been better.'),
(54, 3, 'Average, but enjoyable.'),
(54, 1, 'Not what I expected at all.'),
(54, 4, 'Really satisfying experience.'),
(54, 5, 'Perfect in every aspect!'),

(55, 3, 'Good but not outstanding.'),
(55, 1, 'Not what I expected at all.'),
(55, 2, 'Expected more from this.'),
(55, 4, 'Really satisfying experience.'),
(55, 5, 'Will recommend to everyone!'),

(56, 5, 'Perfect in every aspect!'),
(56, 4, 'Really satisfying experience.'),
(56, 3, 'Average, but enjoyable.'),
(56, 2, 'Expected more from this.'),
(56, 1, 'Not what I expected at all.'),

(57, 2, 'Could have been better.'),
(57, 3, 'Good but not outstanding.'),
(57, 5, 'Will recommend to everyone!'),
(57, 4, 'Really satisfying experience.'),
(57, 1, 'Not what I expected at all.'),

(58, 3, 'Average, but enjoyable.'),
(58, 4, 'Really satisfying experience.'),
(58, 2, 'Expected more from this.'),
(58, 1, 'Not what I expected at all.'),
(58, 5, 'Perfect in every aspect!'),

(59, 4, 'Really satisfying experience.'),
(59, 5, 'Will recommend to everyone!'),
(59, 2, 'Expected more from this.'),
(59, 3, 'Good but not outstanding.'),
(59, 1, 'Not what I expected at all.'),

(60, 5, 'Perfect in every aspect!'),
(60, 4, 'Really satisfying experience.'),
(60, 3, 'Good but not outstanding.'),
(60, 2, 'Could have been better.'),
(60, 1, 'Not what I expected at all.'),

(61, 3, 'Average, but enjoyable.'),
(61, 2, 'Expected more from this.'),
(61, 4, 'Really satisfying experience.'),
(61, 5, 'Will recommend to everyone!'),
(61, 1, 'Not what I expected at all.'),

(62, 5, 'Perfect in every aspect!'),
(62, 2, 'Could have been better.'),
(62, 4, 'Really satisfying experience.'),
(62, 3, 'Good but not outstanding.'),
(62, 1, 'Not what I expected at all.'),

(63, 3, 'Good but not outstanding.'),
(63, 4, 'Really satisfying experience.'),
(63, 5, 'Perfect in every aspect!'),
(63, 2, 'Expected more from this.'),
(63, 1, 'Not what I expected at all.'),

(64, 4, 'Really satisfying experience.'),
(64, 5, 'Will recommend to everyone!'),
(64, 3, 'Average, but enjoyable.'),
(64, 2, 'Could have been better.'),
(64, 1, 'Not what I expected at all.'),

(65, 3, 'Good but not outstanding.'),
(65, 4, 'Really satisfying experience.'),
(65, 5, 'Perfect in every aspect!'),
(65, 2, 'Expected more from this.'),
(65, 1, 'Not what I expected at all.'),

(66, 5, 'Will recommend to everyone!'),
(66, 4, 'Really satisfying experience.'),
(66, 2, 'Could have been better.'),
(66, 3, 'Average, but enjoyable.'),
(66, 1, 'Not what I expected at all.'),

(67, 4, 'Really satisfying experience.'),
(67, 5, 'Perfect in every aspect!'),
(67, 3, 'Good but not outstanding.'),
(67, 2, 'Expected more from this.'),
(67, 1, 'Not what I expected at all.'),

(68, 5, 'Will recommend to everyone!'),
(68, 3, 'Average, but enjoyable.'),
(68, 2, 'Could have been better.'),
(68, 4, 'Really satisfying experience.'),
(68, 1, 'Not what I expected at all.'),

(69, 3, 'Good but not outstanding.'),
(69, 5, 'Perfect in every aspect!'),
(69, 4, 'Really satisfying experience.'),
(69, 2, 'Expected more from this.'),
(69, 1, 'Not what I expected at all.'),

(70, 2, 'Could have been better.'),
(70, 4, 'Really satisfying experience.'),
(70, 5, 'Will recommend to everyone!'),
(70, 3, 'Good but not outstanding.'),
(70, 1, 'Not what I expected at all.'),

(71, 5, 'Perfect in every aspect!'),
(71, 4, 'Really satisfying experience.'),
(71, 3, 'Average, but enjoyable.'),
(71, 2, 'Expected more from this.'),
(71, 1, 'Not what I expected at all.'),

(72, 4, 'Really satisfying experience.'),
(72, 3, 'Good but not outstanding.'),
(72, 2, 'Could have been better.'),
(72, 5, 'Will recommend to everyone!'),
(72, 1, 'Not what I expected at all.'),

(73, 2, 'Expected more from this.'),
(73, 4, 'Really satisfying experience.'),
(73, 3, 'Good but not outstanding.'),
(73, 5, 'Perfect in every aspect!'),
(73, 1, 'Not what I expected at all.'),

(74, 4, 'Really satisfying experience.'),
(74, 2, 'Could have been better.'),
(74, 5, 'Will recommend to everyone!'),
(74, 3, 'Average, but enjoyable.'),
(74, 1, 'Not what I expected at all.'),

(75, 3, 'Good but not outstanding.'),
(75, 4, 'Really satisfying experience.'),
(75, 5, 'Perfect in every aspect!'),
(75, 2, 'Expected more from this.'),
(75, 1, 'Not what I expected at all.'),

(76, 5, 'Will recommend to everyone!'),
(76, 3, 'Average, but enjoyable.'),
(76, 4, 'Really satisfying experience.'),
(76, 2, 'Could have been better.'),
(76, 1, 'Not what I expected at all.'),

(77, 4, 'Really satisfying experience.'),
(77, 5, 'Perfect in every aspect!'),
(77, 3, 'Good but not outstanding.'),
(77, 2, 'Expected more from this.'),
(77, 1, 'Not what I expected at all.'),

(78, 2, 'Could have been better.'),
(78, 3, 'Good but not outstanding.'),
(78, 4, 'Really satisfying experience.'),
(78, 5, 'Perfect in every aspect!'),
(78, 1, 'Not what I expected at all.'),

(79, 5, 'Will recommend to everyone!'),
(79, 3, 'Average, but enjoyable.'),
(79, 2, 'Expected more from this.'),
(79, 4, 'Really satisfying experience.'),
(79, 1, 'Not what I expected at all.'),

(80, 5, 'Perfect in every aspect!'),
(80, 3, 'Good but not outstanding.'),
(80, 4, 'Really satisfying experience.'),
(80, 2, 'Could have been better.'),
(80, 1, 'Not what I expected at all.'),

(81, 4, 'Really satisfying experience.'),
(81, 5, 'Will recommend to everyone!'),
(81, 3, 'Average, but enjoyable.'),
(81, 2, 'Expected more from this.'),
(81, 1, 'Not what I expected at all.'),

(82, 5, 'Perfect in every aspect!'),
(82, 4, 'Really satisfying experience.'),
(82, 3, 'Good but not outstanding.'),
(82, 2, 'Could have been better.'),
(82, 1, 'Not what I expected at all.'),

(83, 3, 'Average, but enjoyable.'),
(83, 2, 'Expected more from this.'),
(83, 5, 'Will recommend to everyone!'),
(83, 4, 'Really satisfying experience.'),
(83, 1, 'Not what I expected at all.'),

(84, 5, 'Perfect in every aspect!'),
(84, 2, 'Could have been better.'),
(84, 4, 'Really satisfying experience.'),
(84, 3, 'Good but not outstanding.'),
(84, 1, 'Not what I expected at all.'),

(85, 4, 'Really satisfying experience.'),
(85, 5, 'Will recommend to everyone!'),
(85, 3, 'Average, but enjoyable.'),
(85, 2, 'Expected more from this.'),
(85, 1, 'Not what I expected at all.'),

(86, 3, 'Good but not outstanding.'),
(86, 4, 'Really satisfying experience.'),
(86, 5, 'Perfect in every aspect!'),
(86, 2, 'Could have been better.'),
(86, 1, 'Not what I expected at all.'),

(87, 5, 'Will recommend to everyone!'),
(87, 2, 'Expected more from this.'),
(87, 4, 'Really satisfying experience.'),
(87, 3, 'Average, but enjoyable.'),
(87, 1, 'Not what I expected at all.'),

(88, 4, 'Really satisfying experience.'),
(88, 3, 'Good but not outstanding.'),
(88, 5, 'Perfect in every aspect!'),
(88, 2, 'Could have been better.'),
(88, 1, 'Not what I expected at all.'),

(89, 5, 'Will recommend to everyone!'),
(89, 4, 'Really satisfying experience.'),
(89, 3, 'Average, but enjoyable.'),
(89, 2, 'Expected more from this.'),
(89, 1, 'Not what I expected at all.'),

(90, 3, 'Good but not outstanding.'),
(90, 5, 'Perfect in every aspect!'),
(90, 4, 'Really satisfying experience.'),
(90, 2, 'Could have been better.'),
(90, 1, 'Not what I expected at all.'),

(91, 4, 'Really satisfying experience.'),
(91, 3, 'Average, but enjoyable.'),
(91, 5, 'Will recommend to everyone!'),
(91, 2, 'Expected more from this.'),
(91, 1, 'Not what I expected at all.'),

(92, 5, 'Perfect in every aspect!'),
(92, 3, 'Good but not outstanding.'),
(92, 4, 'Really satisfying experience.'),
(92, 2, 'Could have been better.'),
(92, 1, 'Not what I expected at all.'),

(93, 3, 'Average, but enjoyable.'),
(93, 4, 'Really satisfying experience.'),
(93, 2, 'Expected more from this.'),
(93, 5, 'Will recommend to everyone!'),
(93, 1, 'Not what I expected at all.'),

(94, 5, 'Perfect in every aspect!'),
(94, 3, 'Good but not outstanding.'),
(94, 4, 'Really satisfying experience.'),
(94, 2, 'Could have been better.'),
(94, 1, 'Not what I expected at all.'),

(95, 4, 'Really satisfying experience.'),
(95, 2, 'Expected more from this.'),
(95, 5, 'Will recommend to everyone!'),
(95, 3, 'Average, but enjoyable.'),
(95, 1, 'Not what I expected at all.'),

(96, 5, 'Perfect in every aspect!'),
(96, 4, 'Really satisfying experience.'),
(96, 3, 'Good but not outstanding.'),
(96, 2, 'Could have been better.'),
(96, 1, 'Not what I expected at all.'),

(97, 3, 'Average, but enjoyable.'),
(97, 5, 'Will recommend to everyone!'),
(97, 4, 'Really satisfying experience.'),
(97, 2, 'Expected more from this.'),
(97, 1, 'Not what I expected at all.'),

(98, 4, 'Really satisfying experience.'),
(98, 3, 'Good but not outstanding.'),
(98, 5, 'Perfect in every aspect!'),
(98, 2, 'Could have been better.'),
(98, 1, 'Not what I expected at all.'),

(99, 5, 'Will recommend to everyone!'),
(99, 4, 'Really satisfying experience.'),
(99, 3, 'Average, but enjoyable.'),
(99, 2, 'Expected more from this.'),
(99, 1, 'Not what I expected at all.');

Insert Into Feedback (MovieID, Rating, Comments) VALUES
(100, 5, 'New favorite in this category!'),
(100, 4, 'Beautifully executed work.'),
(100, 3, 'Good casual viewing.'),
(100, 2, 'Below usual standards.'),
(100, 5, 'Instant classic for me!');



Update Feedback
Set CustomerID = FeedbackID
Where FeedbackID BETWEEN 1 AND 500;


UPDATE Feedback
SET Rating = ROUND(3.5 + (RAND(CHECKSUM(NEWID())) * 1.5), 1)
WHERE MovieID IN (1, 3, 6, 61, 57, 31, 30, 17, 18, 16);



UPDATE F
SET F.MovieID = S.MovieID
FROM Feedback F
JOIN Booking B ON F.CustomerID = B.CustomerID
JOIN Ticket T ON B.BookingID = T.BookingID
JOIN Show S ON T.ShowID = S.ShowID;
------------------

-- Update movies where language is already 'English' 
UPDATE Movie
SET Language = CASE (ABS(CHECKSUM(NEWID())) % 4)
                  WHEN 0 THEN 'English'
                  WHEN 1 THEN 'Urdu'
                  WHEN 2 THEN 'Punjabi'
                  ELSE 'Hindi' -- Acts as default for WHEN 3
              END
WHERE Language = 'English';

--Customer id from 1 to 400 and then ...
UPDATE Booking
SET CustomerID = CASE
    WHEN BookingID BETWEEN 1 AND 400 THEN BookingID
    WHEN BookingID BETWEEN 401 AND 450 THEN BookingID - 400
    WHEN BookingID BETWEEN 451 AND 500 THEN BookingID - 450
    ELSE CustomerID
END;


UPDATE [Order]
SET CustomerID = CASE
    WHEN OrderID BETWEEN 1 AND 800 THEN ((OrderID - 1) / 2 + 1)  -- Customer 1–400 (2 orders each)
    WHEN OrderID BETWEEN 801 AND 900 THEN OrderID - 800         -- Customer 1–50
    WHEN OrderID BETWEEN 901 AND 1000 THEN OrderID - 900        -- Customer 1–50 again
    ELSE CustomerID
END;

UPDATE Feedback
SET CustomerID = CASE
    WHEN FeedbackID BETWEEN 1 AND 400 THEN FeedbackID         -- Customer 1–400
    WHEN FeedbackID BETWEEN 401 AND 450 THEN FeedbackID - 400 -- Customer 1–50
    WHEN FeedbackID BETWEEN 451 AND 500 THEN FeedbackID - 450 -- Customer 1–50 again
    ELSE CustomerID
END;

--delete hundred customers
DELETE FROM Customer
WHERE CustomerID IN (
    SELECT TOP 100 CustomerID
    FROM Customer
    ORDER BY CustomerID DESC
);


-- Select all from Movie
Select * 
From Movie;

-- Select all from Hall
Select * 
From Hall;

-- Select all from Customer
Select * 
From Customer;

-- Select all from FoodItem
Select * 
From FoodItem;

-- Select all from StaffShift
Select * 
From StaffShift;

-- Select all from Seat
Select * 
From Seat;

-- Select all from Staff
Select *
From Staff;

-- Select all from Show
Select * 
From Show;

-- Select all from Booking
Select * 
From Booking;

-- Select all from Order (use brackets because ORDER is a reserved keyword)
Select * 
From [Order];

-- Select all from Ticket
Select * 
From Ticket;

-- Select all from OrderDetail
Select * 
From OrderDetail;

-- Select all from Feedback 
Select * 
From Feedback;


-------------------------------INTERESTING QUERIES-------------------------------
--Obil
--(1) Food order quantity per movie genre
SELECT M.Genre, SUM(OD.Quantity) AS TotalQuantity
FROM Movie M
JOIN Show S ON M.MovieID = S.MovieID
JOIN Ticket T ON S.ShowID = T.ShowID
JOIN Booking B ON T.BookingID = B.BookingID
JOIN [Order] O ON B.CustomerID = O.CustomerID
JOIN OrderDetail OD ON O.OrderID = OD.OrderID
GROUP BY M.Genre;

--(2) Top 5 Customers Who Bought the Most Food
SELECT TOP 5 C.FullName, SUM(F.Price * OD.Quantity) AS TotalSpent
FROM Customer C
JOIN [Order] O ON C.CustomerID = O.CustomerID
JOIN OrderDetail OD ON O.OrderID = OD.OrderID
JOIN FoodItem F ON OD.FoodItemID = F.FoodItemID
GROUP BY C.FullName
ORDER BY TotalSpent DESC;

--(3) 7 Most Popular Food Items for ‘Interstellar’ film
SELECT TOP 7 F.ItemName, SUM(OD.Quantity) AS TotalOrdered
FROM Movie M
JOIN Show S ON M.MovieID = S.MovieID
JOIN Ticket T ON S.ShowID = T.ShowID
JOIN Booking B ON T.BookingID = B.BookingID
JOIN [Order] O ON B.CustomerID = O.CustomerID
JOIN OrderDetail OD ON O.OrderID = OD.OrderID
JOIN FoodItem F ON OD.FoodItemID = F.FoodItemID
WHERE M.Title = 'Interstellar' 
GROUP BY F.ItemName
ORDER BY TotalOrdered DESC;

--(4) Total tickets for each genre and all its seat types
SELECT M.Genre, S.SeatType, COUNT(*) AS TotalTickets
FROM Movie M
JOIN Show SH ON M.MovieID = SH.MovieID
JOIN Ticket T ON SH.ShowID = T.ShowID
JOIN Seat S ON T.SeatID = S.SeatID
GROUP BY M.Genre, S.SeatType
ORDER BY M.Genre;



--Inderias
--(5) Top 10 Highest-Grossing Movies in April and May (Based on Ticket Sales)

SELECT TOP 10 
    M.MovieID,
    M.Title AS MovieTitle,
    COUNT(T.TicketID) AS TicketsSold,
    SUM(T.Price) AS TotalRevenue,
    ROUND(AVG(T.Price), 2) AS AvgTicketPrice
FROM Ticket T
JOIN Show S ON T.ShowID = S.ShowID
JOIN Movie M ON S.MovieID = M.MovieID
JOIN Booking B ON T.BookingID = B.BookingID
WHERE B.PaymentDate IS NOT NULL AND (MONTH(B.BookingDate) = 4 OR MONTH(B.BookingDate) = 5)
GROUP BY M.MovieID, M.Title
ORDER BY TotalRevenue DESC;



-- (6) Most Active Top 5 Customers by AREA (Based on Number of Bookings)
SELECT Top 5
    C.Area,
    C.CustomerID,
    C.FullName,
    SUM(OD.Quantity * FI.Price) AS TotalFoodSpend,
    SUM(B.TotalAmount) AS TotalBookingAmount,
    ROUND(AVG(B.TotalAmount), 2) AS AvgSpendPerBooking
FROM Customer C
JOIN Booking B ON C.CustomerID = B.CustomerID
JOIN Ticket T ON B.BookingID = T.BookingID
JOIN Show S ON T.ShowID = S.ShowID
JOIN [Order] O ON C.CustomerID = O.CustomerID
JOIN OrderDetail OD ON O.OrderID = OD.OrderID
JOIN FoodItem FI ON OD.FoodItemID = FI.FoodItemID
WHERE  B.PaymentDate IS NOT NULL
GROUP BY C.Area, C.CustomerID, C.FullName
ORDER BY  TotalFoodSpend DESC;


--(7) Peak Show Dates in Jan (When Most Tickets Are Sold)
SELECT 
    S.ShowDate,
    COUNT(T.TicketID) AS TotalTicketsSold,
    SUM(T.Price) AS TotalRevenue
FROM Show S
JOIN Ticket T ON S.ShowID = T.ShowID
JOIN Booking B ON T.BookingID = B.BookingID
JOIN Hall H ON S.HallID = H.HallID 
WHERE B.PaymentDate IS NOT NULL AND MONTH(B.BookingDate) = 1
GROUP BY S.ShowDate
ORDER BY TotalTicketsSold DESC, TotalRevenue DESC;



--(8) Movies with Best Average Feedback Ratings
SELECT Top 10
    m.MovieID,
    m.Title, 
	FORMAT(AVG(f.Rating), '0.##') AS AverageRating,
    COUNT(f.FeedbackID) AS TotalFeedbacks
FROM Feedback f
JOIN Customer c ON f.CustomerID = c.CustomerID
JOIN Booking b ON c.CustomerID = b.CustomerID
JOIN Ticket t ON b.BookingID = t.BookingID
JOIN Show s ON t.ShowID = s.ShowID
JOIN Movie m ON s.MovieID = m.MovieID
GROUP BY m.MovieID, m.Title
HAVING COUNT(f.FeedbackID) >= 5
ORDER BY TotalFeedbacks DESC, AverageRating DESC;



--Ebrahim

--(9) Food Preference by Movie Rating
SELECT 
    m.Rating AS MovieRating,
    fi.Category AS FoodCategory,
    SUM(od.Quantity) AS TotalOrdered,
    ROUND(SUM(fi.Price * od.Quantity), 2) AS TotalRevenue
FROM Movie m
JOIN Show s ON m.MovieID = s.MovieID
JOIN Ticket t ON s.ShowID = t.ShowID
JOIN Booking b ON t.BookingID = b.BookingID
JOIN [Order] o ON b.CustomerID = o.CustomerID
JOIN OrderDetail od ON o.OrderID = od.OrderID
JOIN FoodItem fi ON od.FoodItemID = fi.FoodItemID
GROUP BY m.Rating, fi.Category
HAVING SUM(od.Quantity) > 10
ORDER BY m.Rating, TotalOrdered DESC;


--(10) Most Active Time Slots by Food Sales
SELECT 
    Sh.StartTime,
    COUNT(OD.OrderDetailID) AS FoodItemsSold
FROM Show Sh
JOIN Ticket T ON Sh.ShowID = T.ShowID
JOIN Booking B ON T.BookingID = B.BookingID
JOIN [Order] O ON B.CustomerID = O.CustomerID
JOIN OrderDetail OD ON O.OrderID = OD.OrderID
GROUP BY Sh.StartTime
ORDER BY FoodItemsSold DESC;


--(11) Total number of tickets Shah Rukh Khan Booked for Fantasy Movie
SELECT 
    C.FullName,
    M.Genre,
    COUNT(T.TicketID) AS TotalTickets
FROM Ticket T
JOIN Booking B ON T.BookingID = B.BookingID
JOIN Customer C ON B.CustomerID = C.CustomerID
JOIN Show S ON T.ShowID = S.ShowID
JOIN Movie M ON S.MovieID = M.MovieID
WHERE C.FullName = 'Shah Rukh Khan'
  AND M.Genre = 'Fantasy'
GROUP BY C.FullName, M.Genre;


--(12) At which time the most amount of people from Walton watched an action film

SELECT Top 1
    S.StartTime,
    COUNT(*) AS Viewers
FROM Customer C
JOIN Booking B ON C.CustomerID = B.CustomerID
JOIN Ticket T ON B.BookingID = T.BookingID
JOIN Show S ON T.ShowID = S.ShowID
JOIN Movie M ON S.MovieID = M.MovieID
WHERE 
    C.Area = 'Walton'
    AND M.Genre = 'Action'
GROUP BY S.StartTime
ORDER BY Viewers DESC;



--Yashab

--(13)  In which cinema hall was chips ordered the most for 'Wonka' Film
SELECT TOP 1
    H.HallName,
    SUM(OD.Quantity) AS TotalChipsOrdered
FROM Movie M
JOIN Show S ON M.MovieID = S.MovieID
JOIN Hall H ON S.HallID = H.HallID
JOIN Ticket T ON S.ShowID = T.ShowID
JOIN Booking B ON T.BookingID = B.BookingID
JOIN [Order] O ON B.CustomerID = O.CustomerID
JOIN OrderDetail OD ON O.OrderID = OD.OrderID
JOIN FoodItem F ON OD.FoodItemID = F.FoodItemID
WHERE M.Title = 'Wonka' AND F.ItemName = 'Chips'
GROUP BY H.HallName
ORDER BY TotalChipsOrdered DESC;


--(14)  5 Most Watched Movies by customers from 'Izmir Town'
SELECT TOP 5 
    M.Title AS MostWatchedMovie,
    COUNT(T.TicketID) AS TicketsWatched
FROM Customer C
JOIN Booking B ON C.CustomerID = B.CustomerID
JOIN Ticket T ON B.BookingID = T.BookingID
JOIN Show S ON T.ShowID = S.ShowID
JOIN Movie M ON S.MovieID = M.MovieID
WHERE C.Area = 'Izmir Town'
GROUP BY M.Title
ORDER BY TicketsWatched DESC;

--(15) Revenue by ScreenType and Floor
SELECT H.ScreenType, H.FloorNumber, COUNT(T.TicketID) AS TotalTicketsSold,
    SUM(T.Price) AS TotalRevenue,
    ROUND(AVG(T.Price), 2) AS AvgTicketPrice
FROM Ticket T
JOIN Show S ON T.ShowID = S.ShowID
JOIN Hall H ON S.HallID = H.HallID
JOIN Booking B ON T.BookingID = B.BookingID
WHERE B.PaymentDate IS NOT NULL
GROUP BY H.ScreenType, H.FloorNumber
ORDER BY H.ScreenType, H.FloorNumber;

--(16) Which Hall did Aamir Khan book the most tickets at

SELECT TOP 1 H.HallName, COUNT(T.TicketID) AS TicketsBooked
FROM Customer C
JOIN Booking B ON C.CustomerID = B.CustomerID
JOIN Ticket T ON B.BookingID = T.BookingID
JOIN Show S ON T.ShowID = S.ShowID
JOIN Hall H ON S.HallID = H.HallID
WHERE C.FullName = 'Aamir Khan'
GROUP BY H.HallName
ORDER BY TicketsBooked DESC;



