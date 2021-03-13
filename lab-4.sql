-- Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłki dostarczała firma United Package.

-- USE Northwind
-- SELECT CompanyName, Phone
-- FROM Customers
-- WHERE CustomerID IN (
--     SELECT CustomerID
--     FROM Orders
--     WHERE YEAR(ShippedDate) = 1997 AND ShipVia = (
--         SELECT ShipperId 
--         FROM Shippers 
--         WHERE CompanyName = 'United Package'
--         )
-- )

-- Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłek nie dostarczała firma United Package.

-- SELECT CompanyName, Phone
-- FROM Customers
-- WHERE CustomerID NOT IN (
--     SELECT CustomerID
--     FROM Orders
--     WHERE YEAR(ShippedDate) = 1997 AND ShipVia = (
--         SELECT ShipperId 
--         FROM Shippers 
--         WHERE CompanyName = 'United Package'
--         )
-- )

-- Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii Confections..
-- SELECT cu.CompanyName, cu.Phone 
-- FROM Customers cu
-- WHERE cu.CustomerID IN (
--     SELECT o.CustomerID
--     FROM Orders o
--     WHERE o.OrderID IN (
--         SELECT od.OrderID
--         FROM [Order Details] od
--         WHERE od.ProductID IN (
--             SELECT p.ProductID
--             FROM Products p
--             WHERE p.CategoryID IN (
--                 SELECT c.CategoryId
--                 FROM Categories c
--                 WHERE c.CategoryName = 'Confections'
--             )
--         )
--     )
-- )

-- Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produktów z kategorii Confections.
-- SELECT cu.CompanyName, cu.Phone 
-- FROM Customers cu
-- WHERE cu.CustomerID NOT IN (
--     SELECT o.CustomerID
--     FROM Orders o
--     INNER JOIN [Order Details] od
--     ON o.OrderID = od.OrderID
--     INNER JOIN Products p
--     ON p.ProductID = od.ProductID
--     INNER JOIN Categories cat
--     ON cat.CategoryID = p.CategoryID AND cat.CategoryName = 'Confections'
-- );

-- Dla każdego produktu podaj maksymalną liczbę zamówionych jednostek

-- SELECT p.ProductName, MAX(od.quantity) as 'Max quantity'
-- FROM Products p
-- INNER JOIN [Order Details] od
-- ON od.ProductID = p.ProductID
-- GROUP BY p.ProductName
-- ORDER BY MAX(od.quantity) DESC

-- Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktu
-- SELECT p.ProductName, p.UnitPrice, (SELECT DISTINCT AVG(p.UnitPrice) FROM Products p) as 'Average'
-- FROM Products p
-- GROUP BY UnitPrice, ProductName
-- HAVING UnitPrice < (SELECT DISTINCT AVG(p.UnitPrice) FROM Products p)
-- ORDER BY p.UnitPrice DESC

-- Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktu danej kategorii
-- SELECT DISTINCT ProductName, UnitPrice
-- FROM (
--     SELECT DISTINCT p.ProductName, p.UnitPrice, cat.CategoryName, p.CategoryID
--     FROM Products p, Categories cat
--     WHERE p.UnitPrice < (
--         SELECT AVG(p2.UnitPrice) 
--         FROM Products p2
--         GROUP BY p2.CategoryID
--         HAVING p2.CategoryID = p.CategoryID
--     )
-- ) as temp

-- Dla każdego produktu podaj jego nazwę, cenę, średnią cenę wszystkich 
--produktów oraz różnicę między ceną produktu a średnią ceną wszystkich produktów
-- SELECT p.ProductName, p.UnitPrice, (
--     SELECT AVG(p2.UnitPrice) FROM
--         Products p2
--     ) as 'Average',
--     (p.UnitPrice - (
--         SELECT AVG(p2.UnitPrice) FROM
--             Products p2
--         )
--     ) as 'Diff'
-- FROM Products p

-- Dla każdego produktu podaj jego nazwę kategorii,
-- nazwę produktu, cenę, średnią cenę wszystkich produktów danej kategorii 
-- oraz różnicę między ceną produktu a średnią ceną wszystkich produktów danej kategorii
-- SELECT cat.CategoryName, p.ProductName, p.UnitPrice, (
--     SELECT AVG(p2.UnitPrice)
--     FROM Products p2
--     GROUP BY p2.CategoryID
--     HAVING p2.CategoryID = p.CategoryID
-- ) as 'Average of Category',
-- (p.UnitPrice - (
--     SELECT AVG(p2.UnitPrice)
--     FROM Products p2
--     GROUP BY p2.CategoryID
--     HAVING p2.CategoryID = p.CategoryID
-- )) as 'Diff'
-- FROM Products p
-- INNER JOIN Categories cat
-- ON p.CategoryID = cat.CategoryID

-- Podaj łączną wartość zamówienia o numerze 10250 (uwzględnij cenę za przesyłkę)
-- SELECT temp.Price as 'Price (freight included)', temp.OrderId 
-- FROM (
--     SELECT SUM((od.UnitPrice * od.Quantity) * (1 - od.Discount)) + o.Freight as 'Price', o.OrderID
--     FROM [Order Details] od
--     INNER JOIN Orders o
--     ON o.OrderID = od.OrderID
--     INNER JOIN Products p
--     ON p.ProductID = od.ProductID
--     GROUP BY o.OrderID, o.Freight
-- ) as temp
-- WHERE temp.OrderID = 10250

 -- 1265 + 77 + 214,2 + 65,83 = 1618,43 (Weryfikacja wyniku na kalkulatorze)

--  Podaj łączną wartość zamówień każdego zamówienia (uwzględnij cenę za przesyłkę)
-- SELECT SUM((od.UnitPrice * od.Quantity) * (1 - od.Discount)) + o.Freight as 'Order price (freight included)', o.OrderID
-- FROM [Order Details] od
-- INNER JOIN Orders o
-- ON o.OrderID = od.OrderID
-- INNER JOIN Products p
-- ON p.ProductID = od.ProductID
-- GROUP BY o.OrderID, o.Freight
-- ORDER BY o.OrderID

-- Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku,
--  jeśli tak to pokaż ich dane adresowe
-- SELECT cu.CompanyName, cu.Country, cu.PostalCode, cu.City, cu.Address
-- FROM Customers cu
-- WHERE cu.CustomerID NOT IN (
--     SELECT DISTINCT o.CustomerID
--     FROM Orders o
--     WHERE YEAR(o.OrderDate) = 1997
-- )

-- Podaj produkty kupowane przez więcej niż jednego klienta
-- SELECT temp.ProductName, COUNT(temp.CustomerID) as 'Liczba klientów'
-- FROM (
--     SELECT DISTINCT o.CustomerID, od.ProductID, p.ProductName
--     FROM Orders o
--     INNER JOIN [Order Details] od
--     ON od.OrderID = o.OrderID
--     INNER JOIN Products p
--     ON p.ProductID = od.ProductID
-- ) as temp
-- GROUP BY temp.ProductName
-- HAVING COUNT(temp.CustomerID) > 1
-- ORDER BY 'Liczba klientów'

-- 1 Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
-- obsłużonych przez tego pracownika (przy obliczaniu wartości zamówień
-- uwzględnij cenę za przesyłkę_

-- SELECT e.FirstName, e.LastName, (
--     SUM((od.UnitPrice * od.Quantity) * (1 - od.Discount)) + MAX(o.Freight) 
-- ) as 'Value of orders', COUNT(o.OrderID) as 'Quantity of orders'
-- FROM Employees e
-- INNER JOIN Orders o
-- ON o.EmployeeID = e.EmployeeID
-- INNER JOIN [Order Details] od
-- ON od.OrderId = o.OrderID
-- GROUP BY e.EmployeeID, e.FirstName, e.LastName

-- Który z pracowników był najaktywniejszy 
-- (obsłużył zamówienia o największej wartości) w 1997r, 
-- podaj imię i nazwisko takiego pracownika

-- SELECT TOP 1 e.FirstName, e.LastName, (
--     SUM((od.UnitPrice * od.Quantity) * (1 - od.Discount)) + MAX(o.Freight) 
-- ) as 'Value of orders'
-- FROM Employees e
-- INNER JOIN Orders o
-- ON o.EmployeeID = e.EmployeeID
-- INNER JOIN [Order Details] od
-- ON od.OrderId = o.OrderID
-- WHERE YEAR(o.OrderDate) = 1997
-- GROUP BY e.EmployeeID, e.FirstName, e.LastName
-- ORDER BY 'Value of orders' DESC

-- 3 - Ogranicz wynik z pkt 1 
-- tylko do pracowników 
-- a) którzy mają podwładnych 
-- b) którzy nie mają podwładnych


-- A
-- SELECT temp.FirstName, temp.LastName
-- FROM (
--     SELECT e.FirstName, e.LastName, e.EmployeeID, e.ReportsTo, (
--         SUM((od.UnitPrice * od.Quantity) * (1 - od.Discount)) + MAX(o.Freight) 
--     ) as 'Value of orders', COUNT(o.OrderID) as 'Quantity of orders'
--     FROM Employees e
--     INNER JOIN Orders o
--     ON o.EmployeeID = e.EmployeeID
--     INNER JOIN [Order Details] od
--     ON od.OrderId = o.OrderID
--     GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.ReportsTo
-- ) as temp
-- WHERE temp.reportsTo IS NOT NULL

-- B
-- SELECT temp.FirstName, temp.LastName
-- FROM (
--     SELECT e.FirstName, e.LastName, e.EmployeeID, e.ReportsTo, (
--         SUM((od.UnitPrice * od.Quantity) * (1 - od.Discount)) + MAX(o.Freight) 
--     ) as 'Value of orders', COUNT(o.OrderID) as 'Quantity of orders'
--     FROM Employees e
--     INNER JOIN Orders o
--     ON o.EmployeeID = e.EmployeeID
--     INNER JOIN [Order Details] od
--     ON od.OrderId = o.OrderID
--     GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.ReportsTo
-- ) as temp
-- WHERE temp.reportsTo IS NULL

-- Zmodyfikuj rozwiązania z pkt 3 tak,
-- aby dla pracowników pokazać jeszcze datę ostatnio obsłużonego zamówienia

-- A
-- SELECT temp.FirstName, temp.LastName, temp.[Last order]
-- FROM (
--     SELECT e.FirstName, e.LastName, e.EmployeeID, e.ReportsTo, (
--         SUM((od.UnitPrice * od.Quantity) * (1 - od.Discount)) + MAX(o.Freight) 
--     ) as 'Value of orders', COUNT(o.OrderID) as 'Quantity of orders',
--     MAX(o.OrderDate) as 'Last order'
--     FROM Employees e
--     INNER JOIN Orders o
--     ON o.EmployeeID = e.EmployeeID
--     INNER JOIN [Order Details] od
--     ON od.OrderId = o.OrderID
--     GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.ReportsTo
-- ) as temp
-- WHERE temp.reportsTo IS NOT NULL

-- B
-- SELECT temp.FirstName, temp.LastName, temp.[Last order]
-- FROM (
--     SELECT e.FirstName, e.LastName, e.EmployeeID, e.ReportsTo, (
--         SUM((od.UnitPrice * od.Quantity) * (1 - od.Discount)) + MAX(o.Freight) 
--     ) as 'Value of orders', COUNT(o.OrderID) as 'Quantity of orders',
--     MAX(o.OrderDate) as 'Last order'
--     FROM Employees e
--     INNER JOIN Orders o
--     ON o.EmployeeID = e.EmployeeID
--     INNER JOIN [Order Details] od
--     ON od.OrderId = o.OrderID
--     GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.ReportsTo
-- ) as temp
-- WHERE temp.reportsTo IS NULL