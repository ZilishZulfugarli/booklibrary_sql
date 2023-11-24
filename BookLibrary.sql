USE master

GO

CREATE DATABASE BookLibrary

GO

USE BookLibrary

CREATE TABLE Books(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    BookName NVARCHAR(100) CHECK(LEN(BookName) BETWEEN 2 and 100) NOT NULL,
    PageCount INT NOT NULL
)

INSERT into Books VALUES('The Dark Half', 431),
('The Stand: The Complete & Uncut Edition', 1152),
('Four Past Midnight', 763),
('The Dark Tower III: The Waste Lands', 512),
('Career of Evil', 512),
('Lethal White', 656),
('Troubled Blood', 933),
('The Ink Black Heart', 1462)


SELECT * FROM Books


ALTER TABLE Books
ADD CONSTRAINT PageCount CHECK (PageCount >=10)

GO

CREATE TABLE Authors(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    AuthorName NVARCHAR(255) NOT NULL,
    AuthorSurname NVARCHAR(255) NOT NULL
)

INSERT into Authors VALUES('J.K', 'Rowling'),
('Bextiyar', 'Vahabzade')


select * from Authors

GO

CREATE TABLE AuthorBooks (
    AuthorId INT,
    BookId INT,
    PRIMARY KEY (AuthorId, BookId),
    FOREIGN KEY (AuthorId) REFERENCES Authors(Id),
    FOREIGN KEY (BookId) REFERENCES Books(Id)
);

Insert into AuthorBooks VALUES(1,1),
(1,2),
(1,3),
(1,4),
(2,5),
(2,6),
(2,7),
(2,8)

SELECT * FROM AuthorBooks

GO

CREATE VIEW BookAuthorView
AS
SELECT Books.Id, Books.BookName, Books.PageCount, Authors.AuthorName
FROM Books
INNER JOIN AuthorBooks ON Books.Id = AuthorBooks.BookId
INNER JOIN Authors ON AuthorBooks.AuthorId = Authors.Id;

go

select * from BookAuthorView

go


CREATE PROCEDURE BooksbyName (@AuthorName NVARCHAR(255))
AS
SELECT * FROM BookAuthorView WHERE AuthorName= @AuthorName

GO

EXEC BooksbyName 'Bextiyar'

go

--Insert Procedure
CREATE PROCEDURE AuthorInsert (@AuthorName NVARCHAR(255), @AuthorSurname NVARCHAR(255))
AS
BEGIN
INSERT INTO Authors(
    AuthorName,
    AuthorSurname
)
VALUES(
    @AuthorName,
    @AuthorSurname)
END

GO

EXEC AuthorInsert 'Stephen', 'Hawking';

GO

--Update Procedure
CREATE PROCEDURE AuthorUpdate (@Id INT, @AuthorName NVARCHAR(255), @AuthorSurname NVARCHAR(255))
AS
BEGIN
UPDATE Authors 
SET
    AuthorName=@AuthorName,
    AuthorSurname=@AuthorSurname
WHERE Authors.Id = @Id
END

GO

EXEC AuthorUpdate 2,'Zilish', 'Zulfugarli' 

go

--Select Procedure
CREATE PROCEDURE AuthorSelect (@Id INT)
AS
BEGIN
SELECT * FROM Authors
WHERE Id=@Id
END

GO

EXEC AuthorSelect 2

GO

--Delete Procedure
CREATE PROCEDURE AuthorDelete (@Id INT)
AS
BEGIN
DELETE FROM Authors
WHERE Id=@Id
END

GO

EXEC AuthorDelete 3

SELECT * FROM Authors

GO

CREATE VIEW AuthorInfo AS
SELECT
    a.Id AS AuthorId,
    a.AuthorName + ' ' + a.AuthorSurname AS FullName,
    COUNT(b.Id) AS BooksCount,
    SUM(b.PageCount) AS OverallPageCount
FROM
    Authors a
JOIN
    AuthorBooks AB ON A.Id = AB.AuthorId
JOIN
    Books B ON AB.BookId = B.Id
GROUP BY
    a.Id, a.AuthorName, a.AuthorSurname;

GO
select * from AuthorInfo