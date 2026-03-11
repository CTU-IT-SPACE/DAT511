-- ================================================================
-- Activity Setup
-- ================================================================

-- Creating Database
CREATE DATABASE LibraryDB;
GO

-- Using DB for Session
USE LibraryDB;
GO

-- Verifying Database Creation
SELECT name FROM sys.databases;

-- ================================================================
-- Activity Part A (DDL)
-- ================================================================

-- ===========================
-- Activity 1 - Creating DB Tables
-- ===========================

-- A1.1 | Creating Books Table
CREATE TABLE Books (
	book_id				INT					PRIMARY KEY,
	title				NVARCHAR(150)		NOT NULL,
	author				NVARCHAR(100)		NOT NULL,
	isbn				NVARCHAR(20)		UNIQUE NOT NULL,
	genre				NVARCHAR(50),
	year_published		INT,
	copies_available	INT					DEFAULT 1
);
GO

-- A1.2 | Creating Members Table
CREATE TABLE Members (
	member_id			INT					PRIMARY KEY,
	full_name			NVARCHAR(100)		NOT NULL,
	email				NVARCHAR(100)		UNIQUE NOT NULL,
	phone				NVARCHAR(15),
	membership_date		DATE				NOT NULL
);
GO

-- A1.3 | Creating Loans Table
CREATE TABLE Loans (
	loan_id				INT					PRIMARY KEY,
	member_id			INT					NOT NULL,
	book_id				INT					NOT NULL,
	loan_date			DATE				NOT NULL,
	return_date			DATE
);
GO

-- ===========================
-- Activity 2 - Modifying Tables
-- ===========================

-- A2.1 | Adding fine_amount to Loans
ALTER TABLE Loans
ADD fine_amount DECIMAL(6, 2);
GO

-- A2.2 | Adding city to Members
ALTER TABLE Members
ADD city NVARCHAR(50);
GO

-- A2.3 | Removing phone from Members
ALTER TABLE Members
DROP COLUMN phone;
GO

-- A2.4 | Verify Changes to Loans
EXEC sp_help 'Loans';
GO

-- ================================================================
-- Activity Part B (Populating Tables)
-- ================================================================

-- B2.1 | Inserting Books Data
INSERT INTO Books (book_id, title, author, isbn, genre, year_published, copies_available)
VALUES (1, 'The Art of SQL', 'Stephane Faroult', '978-0-596-00894-8', 'Technology', 2006, 3);

INSERT INTO Books (book_id, title, author, isbn, genre, year_published, copies_available)
VALUES (2, 'Learning SQL', 'Alan Beaulieu', '978-0-596-52083-0', 'Technology', 2009, 2);

INSERT INTO Books (book_id, title, author, isbn, genre, year_published, copies_available)
VALUES (3, 'Long Walk to Freedom', 'Nelson Mandela', '978-0-316-54818-3', 'Biography', 1994, 5);

INSERT INTO Books (book_id, title, author, isbn, genre, year_published, copies_available)
VALUES (4, 'Nervous Conditions', 'Tsitsi Dangarembga', '978-0-954-56439-6', 'Fiction', 1988, 4);

INSERT INTO Books (book_id, title, author, isbn, genre, year_published, copies_available)
VALUES (5, 'Database Design for Mere Mortals', 'Michael Hernandez', '978-0-321-70468-4', 'Technology', 2013, 2);
GO

-- B2.2 | Inserting Members Data
INSERT INTO Members (member_id, full_name, email, membership_date, city)
VALUES (101, 'Thabo Nkosi', 'thabo.nkosi@email.co.za', '2023-01-15', 'Pretoria');

INSERT INTO Members (member_id, full_name, email, membership_date, city)
VALUES (102, 'Amahle Dlamini', 'amahle.d@mail.co.za', '2023-03-22', 'Johannesburg');

INSERT INTO Members (member_id, full_name, email, membership_date, city)
VALUES (103, 'Sipho Mthembu', 'sipho.m@webmail.co.za', '2022-11-08', 'Pretoria');

INSERT INTO Members (member_id, full_name, email, membership_date, city)
VALUES (104, 'Lerato Sithole', 'lerato.s@email.co.za', '2024-02-01', 'Centurion');
GO

-- B2.3 | Inserting Loans Data
INSERT INTO Loans (loan_id, member_id, book_id, loan_date, return_date, fine_amount)
VALUES (1001, 101, 2, '2024-04-01', '2024-04-15', NULL);

INSERT INTO Loans (loan_id, member_id, book_id, loan_date, return_date, fine_amount)
VALUES (1002, 102, 3, '2024-04-05', NULL, NULL);

INSERT INTO Loans (loan_id, member_id, book_id, loan_date, return_date, fine_amount)
VALUES (1003, 103, 1, '2024-04-10', NULL, NULL);

INSERT INTO Loans (loan_id, member_id, book_id, loan_date, return_date, fine_amount)
VALUES (1004, 104, 5, '2024-03-20', '2024-04-20', 15.50);
GO

-- Verify Books Data Was Added
SELECT * FROM Books
GO

-- ================================================================
-- Activity Part C (Manipulating Data)
-- ================================================================

-- ===========================
-- Activity 1 - Updating Data
-- ===========================

-- C1.1 | A book was returned
UPDATE Loans
SET return_date = '2024-05-02'
WHERE loan_id = 1002;

-- C1.2 | Fine Applied for late return
UPDATE Loans
SET fine_amount = 25.00
WHERE loan_id = 1003;

-- C1.3 | Update member's email address
UPDATE Members
SET email = 'lerato.sithole@newmail.co.za'
WHERE member_id = 104;

-- C1.4 | Increase Available copies
UPDATE Books
SET copies_available = copies_available + 2
WHERE book_id = 3;
GO

-- ===========================
-- Activity 2 - Deleting Data
-- ===========================

-- C2.1 | Removing a completed loan
SELECT * FROM Loans WHERE loan_id = 1001;
DELETE FROM Loans WHERE loan_id = 1001;

-- C2.2 | Cancel a membership
SELECT * FROM Loans WHERE member_id = 103;
DELETE FROM Loans WHERE member_id = 103;

SELECT * FROM Members WHERE member_id = 103;
DELETE FROM Members WHERE member_id = 103;

-- C2.3 | Remove all loans that have been returned
SELECT * FROM Loans WHERE return_date IS NOT NULL;
DELETE FROM Loans WHERE return_date IS NOT NULL;
GO

-- ================================================================
-- Extension Challenges
-- ================================================================

-- Find Books with fewer than 3 copies available
SELECT * FROM Books WHERE copies_available < 3;

-- Apply 10% fine increase to All Loans with existing fines
UPDATE Loans
SET fine_amount *= 1.1
WHERE fine_amount > 0;
GO

-- Making Staff Table
CREATE TABLE Staff (
	staff_id			INT					PRIMARY KEY,
	full_name			NVARCHAR(100)		NOT NULL,
	work_email				NVARCHAR(100)		UNIQUE NOT NULL,
	position			NVARCHAR(50)		NOT NULL,
	employment_date		DATE				NOT NULL
);
GO

-- Populating Staff Table
INSERT INTO Staff (staff_id, full_name, work_email, position, employment_date)
VALUES (111, 'Micheal Myers', 'm.myers@library.com', 'Librarian', '1978-10-27');

INSERT INTO Staff (staff_id, full_name, work_email, position, employment_date)
VALUES (112, 'Freddy Kruger', 'f.kruger@library.com', 'Accountant', '1984-11-09');

INSERT INTO Staff (staff_id, full_name, work_email, position, employment_date)
VALUES (113, 'Jason Voorhees', 'j.voorhees@library.com', 'Janitor', '1980-05-09');
GO

-- Assigning Foreign Keys to Loans
ALTER TABLE Loans
ADD CONSTRAINT fk_member_id
FOREIGN KEY (member_id) REFERENCES Members(member_id);

ALTER TABLE Loans
ADD CONSTRAINT fk_book_id
FOREIGN KEY (book_id) REFERENCES Books(book_id);
GO