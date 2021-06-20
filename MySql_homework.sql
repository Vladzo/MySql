USE bank;

-- 1. +Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.
SELECT * FROM client WHERE length(firstname) < 6;

-- 2. +Вибрати львівські відділення банку.+
SELECT * FROM department WHERE DepartmentCity = "Lviv";

-- 3. +Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
SELECT * FROM client WHERE Education = "high" ORDER BY LastName;

-- 4. +Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.
SELECT * FROM application ORDER BY idApplication DESC LIMIT 5;

-- 5. +Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA.
SELECT * FROM client WHERE LastName LIKE "%OV" OR LastName LIKE "%OVA";

-- 6. +Вивести клієнтів банку, які обслуговуються київськими відділеннями.
SELECT * FROM client WHERE Department_idDepartment IN (SELECT idDepartment FROM department WHERE DepartmentCity = "Kyiv");

-- 7. +Вивести імена клієнтів та їхні номера телефону, погрупувавши їх за іменами. ---- ??? Нема номерів
SELECT FirstName FROM client ORDER BY FirstName;

-- 8. +Вивести дані про клієнтів, які мають кредит більше ніж на 5000 тисяч гривень.
SELECT * FROM client WHERE idClient IN (SELECT Client_idClient FROM application WHERE Sum > 5000 AND Currency = "Gryvnia");

-- 9. +Порахувати кількість клієнтів усіх відділень та лише львівських відділень.
SELECT COUNT(idClient) FROM client
UNION
SELECT COUNT(idClient) FROM client WHERE Department_idDepartment IN (SELECT idDepartment FROM department WHERE DepartmentCity = "Lviv");

-- 10. Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.
SELECT FirstName, MAX(Sum) FROM client JOIN application ON idClient = Client_idClient GROUP BY Client_idClient;

-- 11. Визначити кількість заявок на крдеит для кожного клієнта.
select Client_idClient, count(idApplication) from application group by Client_idClient;

-- 12. Визначити найбільший та найменший кредити.
select max(Sum), min(Sum) From application;

-- 13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.
select idClient, Count(Client_idClient) From client  Join application ON idClient = Client_idClient Where Education = "high" group by idClient;

-- 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.
SELECT a.Client_idClient, c.FirstName, c.Age, AVG(Sum) FROM application a
JOIN client c ON a.Client_idClient = c.idClient GROUP BY a.Client_idClient 
ORDER BY AVG(SUM) DESC LIMIT 1;

-- 15. Вивести відділення, яке видало в кредити найбільше грошей
SELECT idDepartment, DepartmentCity, SUM(Sum) AS sum
FROM department
JOIN client ON Department_idDepartment = idDepartment
JOIN application  ON idClient = Client_idClient
GROUP BY idDepartment
ORDER BY MAX(sum) DESC LIMIT 1;

-- 16. Вивести відділення, яке видало найбільший кредит.
SELECT idDepartment, DepartmentCity, MAX(Sum)
FROM department
JOIN client ON Department_idDepartment = idDepartment
JOIN application  ON idClient = Client_idClient
GROUP BY idDEpartment
ORDER BY MAX(Sum) DESC LIMIT 1;

-- 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.
UPDATE application SET Sum = 6000, Currency = "Gryvnia" WHERE 
Client_idClient IN (SELECT idClient FROM client WHERE Education = "high");

-- 18. Усіх клієнтів київських відділень пересилити до Києва.
UPDATE client SET city = "Kyiv" 
WHERE Department_idDepartment
IN (SELECT idDepartment FROM department WHERE DepartmentCity = "Kyiv");

-- 19. Видалити усі кредити, які є повернені.
DELETE FROM application WHERE CreditState = "Returned";

-- 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.
DELETE FROM application WHERE Client_idClient IN 
(SELECT idClient FROM client WHERE (
	FirstName LIKE "_a%" OR 
	FirstName LIKE "_o%" OR 
	FirstName LIKE "_e%" OR 
	FirstName LIKE "_i%" OR 
	FirstName LIKE "_u%" 
));

-- Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000
SELECT idDepartment, DepartmentCity FROM department d
JOIN client ON Department_idDepartment = idDepartment
JOIN application  ON idClient = Client_idClient
GROUP BY idDepartment
HAVING (d.DepartmentCity = "Lviv" AND Sum(Sum) > 5000);

-- Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000
SELECT idClient, Sum FROM client 
JOIN application ON idClient = Client_idClient
WHERE Sum > 5000 AND CREDITSTATE = "Returned";

-- /* Знайти максимальний неповернений кредит.*/
SELECT idApplication, Sum FROM application 
WHERE CreditState = "Not returned"
ORDER BY Sum DESC LIMIT 1;

-- /*Знайти клієнта, сума кредиту якого найменша*/
SELECT idClient, MIN(Sum) FROM client 
JOIN application ON idClient = Client_idClient;

-- /*Знайти кредити, сума яких більша за середнє значення усіх кредитів*/
SELECT idApplication, Sum FROM application
WHERE Sum > (SELECT AVG(Sum) FROM application);

-- /*Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів*/
SELECT idClient, FirstName FROM client
JOIN application ON idClient = Client_idClient
WHERE city = (SELECT city FROM client JOIN application ON idClient = Client_idClient ORDER BY SUM  LIMIT 1) GROUP BY idClient; 

-- #місто чувака який набрав найбільше кредитів
SELECT city FROM client
WHERE idClient = (SELECT Client_idClient FROM application ORDER BY Sum DESC LIMIT 1);

