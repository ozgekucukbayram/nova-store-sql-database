-- NovaStore Proje SQL Dosyası

-- DATABASE
CREATE DATABASE NovaStoreDB;
GO
USE NovaStoreDB;
GO

-- TABLES
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL
);

CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(50),
    City VARCHAR(20),
    Email VARCHAR(100) UNIQUE
);

CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2),
    Stock INT DEFAULT 0,
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderDetails (
    DetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- INSERT
INSERT INTO Categories (CategoryName) VALUES
('Elektronik'), ('Giyim'), ('Kitap'), ('Kozmetik'), ('Ev ve Yaşam');

INSERT INTO Customers (FullName, City, Email) VALUES
('Ahmet Yılmaz','İstanbul','ahmet@gmail.com'),
('Ayşe Demir','Ankara','ayse@gmail.com'),
('Mehmet Kaya','İzmir','mehmet@gmail.com'),
('Zeynep Aydın','Bursa','zeynep@gmail.com'),
('Can Öztürk','Antalya','can@gmail.com');

INSERT INTO Products (ProductName, Price, Stock, CategoryID) VALUES
('Laptop',25000,10,1),
('Telefon',15000,5,1),
('Kulaklık',500,18,1),
('T-Shirt',300,50,2),
('Pantolon',700,20,2),
('Roman Kitap',120,40,3),
('Şampuan',80,30,4),
('Krem',150,25,4),
('Kahve Makinesi',2000,8,5),
('Tabak Seti',600,15,5);

INSERT INTO Orders (CustomerID, TotalAmount) VALUES
(1,25500),(2,300),(1,120),(3,700),(4,1500),(5,600);

INSERT INTO OrderDetails (OrderID, ProductID, Quantity) VALUES
(1,1,1),(1,3,1),(2,4,1),(3,6,1),(4,5,1),(5,9,1),(6,10,1);

-- SORGULAR

-- 1
SELECT ProductName, Stock
FROM Products
WHERE Stock < 20
ORDER BY Stock DESC;

-- 2
SELECT Customers.FullName, Customers.City, Orders.OrderDate, Orders.TotalAmount
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

-- 3
SELECT Customers.FullName, Products.ProductName, Products.Price, Categories.CategoryName
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
WHERE Customers.FullName = 'Ahmet Yılmaz';

-- 4
SELECT Categories.CategoryName, COUNT(Products.ProductID) AS UrunSayisi
FROM Categories
LEFT JOIN Products ON Categories.CategoryID = Products.CategoryID
GROUP BY Categories.CategoryName;

-- 5
SELECT Customers.FullName, SUM(Orders.TotalAmount) AS ToplamCiro
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.FullName
ORDER BY ToplamCiro DESC;

-- 6
SELECT OrderID, OrderDate, DATEDIFF(DAY, OrderDate, GETDATE()) AS GecenGun
FROM Orders;

-- VIEW
CREATE VIEW vw_SiparisOzet AS
SELECT Customers.FullName, Orders.OrderDate, Products.ProductName, OrderDetails.Quantity
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID;

-- BACKUP
-- (Klasör oluştur: C:\Yedek)
BACKUP DATABASE NovaStoreDB
TO DISK = 'C:\Yedek\NovaStoreDB.bak';