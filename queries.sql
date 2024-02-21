--lists deleted customers
SELECT * FROM "Customers" 
WHERE "deleted" = 1;

--lists departed employees
SELECT * FROM "Employees"
WHERE "workingStatus" = 'terminated';

--The employee who placed the most orders was listed
SELECT "employeeId", "Employees"."name","Employees"."surname", COUNT("employeeId") AS 'number of sales' FROM "Orders"
JOIN "Employees" ON "Orders"."employeeId" = "Employees"."id"
GROUP BY "employeeId"
ORDER BY "number of sales" DESC LIMIT 1;

--Lists stores in San Francisco
SELECT * FROM Shops 
WHERE "cityId" IN (
    SELECT "id" FROM "cities"
    WHERE "name" = 'San Francisco'
);

--Products from the Computer category are listed
SELECT * FROM "Products"
WHERE "categoryId" IN (
    SELECT "id" FROM "categories"
    WHERE "name" = 'Computer'
);

--Lists employees in the Mobile Phones and Accessories department
SELECT * FROM "Employees"
WHERE "departmentId" IN (
    SELECT "id" FROM "departments"
    WHERE "name" = 'Mobile Phones and Accessories'
);

--Lists the total number of leaves used by the employee whose ID number is entered
SELECT SUM("annualLeaveUsed") AS 'total used permission
' FROM "Annual_Leave"
WHERE "employeeId" IN (
    SELECT "id" FROM "Employees"
    WHERE "identificationNumber" = 16666
);

--Lists products that are not on sale
SELECT * FROM "Products"
WHERE "productStatus" != 'sale';

--Lists orders placed by store name
SELECT * FROM "Orders"
WHERE "shopId" IN (
    SELECT "id" FROM "Shops"
    WHERE "name" = 'Techno New York'
);

--Shows the products ordered by the customer by name and surname
SELECT * FROM Order_Item
WHERE "orderId" IN (
    SELECT "id" FROM "Orders"
    WHERE "customerId" IN (
        SELECT "id" FROM "Customers"
        WHERE "name" = 'Olivia' AND "surname" = 'Johnson'
    )
);

--Shows employees working in job positions
SELECT * FROM "Employees"
WHERE "jobPositionId" IN (
    SELECT "id" FROM "JobPositions"
    WHERE "name" = 'Sales Representative'
) AND "workingStatus" = 'work';

--Provides compensation information for the employee whose ID number is entered)
SELECT * FROM "Indemnity"
WHERE employeeId = (
    SELECT "id" FROM "Employees"
    WHERE "identificationNumber" = '1332222222'
);

--Shows the contents of order number 3 (View)
SELECT * FROM "order_content"
WHERE "order_id" IN (
    SELECT "id" FROM "Orders"
    WHERE "id" = 3
);

--Lists total cost by order number (View)
SELECT * FROM "order_totalprice"
WHERE "order_id" IN (
    SELECT "id" FROM "Orders"
    WHERE "id" = 3
);

--Lists stores when city information is given (View)
SELECT * FROM "shop_city"
WHERE "city_name" = 'New York';

--Collect lists of employees who have not left their jobs by employee ID
SELECT * FROM "employee_information"
WHERE "employee_id" = 6;

--Lists information by order number (View)
SELECT * FROM "order_information"
WHERE "order_id" = 3;

--Lists the products of the entered brand (View)
SELECT * FROM  "product_details"
WHERE "trademark_name" = 'Sony';

--Lists products when given category name (View)
SELECT * FROM "product_details"
WHERE "category_name" = 'Phone';

--Shows the compensation information of the employee whose employee number is entered
SELECT * FROM "employee_indemnity"
WHERE "employee_id" = 1;

--Shows permission information based on the entered ID
SELECT * FROM "employee_annualleave"
WHERE "employee_id" = 6;

--DATA ADDITIONS

INSERT INTO Customers("name","surname","phoneNumber","email","address") VALUES ('Alexander','Mitchell',5555555555,'alex.mitchell@example.com','123 Main Street, USA');
INSERT INTO Customers("name","surname","phoneNumber","email","address") VALUES ('Ethan ','Clark',5555555551,'ethan.clark@example.com','456 Oak Avenue, USA');
UPDATE Customers SET "address" = 'New York, USA' WHERE "id" = 1;
UPDATE Customers SET "deleted" = 1 WHERE "id" = 1;

INSERT INTO Categories("name") VALUES ('Phone');
INSERT INTO Categories("name") VALUES ('Computer');
INSERT INTO Categories("name") VALUES ('TV, Image and Sound');
INSERT INTO Categories("name") VALUES ('Accessory');

INSERT INTO Trademarks("name") VALUES ('Sony');
INSERT INTO Trademarks("name") VALUES ('Philips');
INSERT INTO Trademarks("name") VALUES ('Apple');
INSERT INTO Trademarks("name") VALUES ('Samsung');

INSERT INTO Products("name","stock","categoryId","trademarkId","price","productStatus") VALUES ('Notebook',10,2,1,1000,'sale');
INSERT INTO Products("name","stock","categoryId","trademarkId","price","productStatus") VALUES ('Iphone 15',10,1,3,1500,'sale');
INSERT INTO Products("name","stock","categoryId","trademarkId","price","productStatus") VALUES ('Samsung TV',5,3,4,5000,'sale');
UPDATE Products SET "stock" = "stock" + 15 WHERE "id" = 1;
UPDATE Products SET "productStatus" = 'not on sale' WHERE "id" = 1;

INSERT INTO Cities("name") VALUES ('New York');
INSERT INTO Cities("name") VALUES ('Los Angeles');
INSERT INTO Cities("name") VALUES ('Chicago');
INSERT INTO Cities("name") VALUES ('Houston');

INSERT INTO Departments ("name") VALUES ('Computers and Laptops');
INSERT INTO Departments ("name") VALUES ('Mobile Phones and Accessories');
INSERT INTO Departments ("name") VALUES ('Television and Sound Systems');
INSERT INTO Departments ("name") VALUES ('Games and Entertainment');

INSERT INTO Shops("name","CityId","shopStatus") VALUES ('TecnoMarkt New York',1,'active');
INSERT INTO Shops("name","CityId","shopStatus") VALUES ('TecnoMarkt Los Angeles',2,'repair');
INSERT INTO Shops("name","CityId","shopStatus") VALUES ('TecnoMakrt Houston',3,'active');
INSERT INTO Shops("name","CityId","shopStatus") VALUES ('TechnoMarkt',4,'active');

INSERT INTO JobPositions("name") VALUES('Computer Sales Representative');
INSERT INTO JobPositions("name") VALUES('Technical Support Specialist');
INSERT INTO JobPositions("name") VALUES('Mobile Phone Sales Consultant');
INSERT INTO JobPositions("name") VALUES('Television Sales Representatives');
INSERT INTO JobPositions("name") VALUES('Sound Systems Specialist');
INSERT INTO JobPositions("name") VALUES('Game Console Sales Representatives');
INSERT INTO JobPositions("name") VALUES('Game and Entertainment Department Manager');

INSERT INTO Employees("identificationNumber","name","surname","gender","phoneNumber","email","address","jobPositionId","departmentId","shopId","salary","workingStatus") VALUES ('GB123456','John', 'Doe', 'Male', '555555776', 'john.doe@example.com', '123 Oak Street, New York', 1, 1, 1, 5000, 'work');
INSERT INTO Employees("identificationNumber","name","surname","gender","phoneNumber","email","address","jobPositionId","departmentId","shopId","salary","workingStatus") VALUES ('GB234567', 'Emma', 'Smith', 'Female', '555555811', 'emma.smith@example.com', '456 Maple New York', 1, 1, 1, 5500, 'work');
INSERT INTO Employees("identificationNumber","name","surname","gender","phoneNumber","email","address","jobPositionId","departmentId","shopId","salary","workingStatus") VALUES ('GB345678', 'William', 'Jones', 'Male', '555555888', 'william.jones@example.com', '789 Birch Street, New York', 2, 1, 3, 6000, 'work');
INSERT INTO Employees("identificationNumber","name","surname","gender","phoneNumber","email","address","jobPositionId","departmentId","shopId","salary","workingStatus") VALUES ('GB456789', 'Sophie', 'Wilson', 'Female', '555555999', 'sophie.wilson@example.com', '101 Pine Road, New York', 2, 2, 3, 5200, 'work');
INSERT INTO Employees("identificationNumber","name","surname","gender","phoneNumber","email","address","jobPositionId","departmentId","shopId","salary","workingStatus") VALUES  ('GB567890', 'Oliver', 'Taylor', 'Male', '555555512', 'oliver.taylor@example.com', '202 Cedar Lane, Los Angeles', 3, 2, 3, 5800, 'work');
INSERT INTO Employees("identificationNumber","name","surname","gender","phoneNumber","email","address","jobPositionId","departmentId","shopId","salary","workingStatus") VALUES ('GB678901', 'Ava', 'Brown', 'Female', '555555509', 'ava.brown@example.com', '303 Elm Street, Los Angeles', 4, 3, 4, 5300, 'work');
INSERT INTO Employees("identificationNumber","name","surname","gender","phoneNumber","email","address","jobPositionId","departmentId","shopId","salary","workingStatus") VALUES  ('GB789012', 'Mason', 'Evans', 'Male', '555555519', 'mason.evans@example.com', '404 Oak Avenue, Chicago', 4, 3, 1, 5700, 'work');
INSERT INTO Employees("identificationNumber","name","surname","gender","phoneNumber","email","address","jobPositionId","departmentId","shopId","salary","workingStatus") VALUES  ('GB890123', 'Isabella', 'Thomas', 'Female', '555555501', 'isabella.thomas@example.com', '505 Chicago, Houston', 5, 3, 3, 5100, 'work');
INSERT INTO Employees("identificationNumber","name","surname","gender","phoneNumber","email","address","jobPositionId","departmentId","shopId","salary","workingStatus") VALUES  ('GB901234', 'Ethan', 'Clark', 'Male', '555555987', 'ethan.clark@example.com', '606 Pine Road, Houston', 6, 4, 4, 5900, 'work');
INSERT INTO Employees("identificationNumber","name","surname","gender","phoneNumber","email","address","jobPositionId","departmentId","shopId","salary","workingStatus") VALUES  ('GB012345', 'Mia', 'Miller', 'Female', '555555120', 'mia.miller@example.com', '707 Cedar Lane, Houston', 7, 4, 4, 5400, 'work');
UPDATE Employees SET "workingStatus" = 'work' WHERE id=1;
UPDATE Customers SET "deleted" = 1 WHERE "id" = 1;

INSERT INTO Orders ("customerId","shopId","employeeId") VALUES (1,1,1);
INSERT INTO Order_Item("orderId","productId","quantity","price") VALUES (1,1,1,1000);
INSERT INTO Order_Item("orderId","productId","quantity","price") VALUES (1,2,1,1500);
UPDATE Order_Item SET "orderItemStatus" = 'cancelled' WHERE "orderId" = 1;

INSERT INTO Orders ("customerId","shopId","employeeId") VALUES (1,1,2);
INSERT INTO Order_Item("orderId","productId","quantity","price") VALUES (2,1,1,1000);
INSERT INTO Order_Item("orderId","productId","quantity","price") VALUES (2,3,1,5000);

INSERT INTO Orders ("customerId","shopId","employeeId") VALUES (2,3,3);
INSERT INTO Order_Item("orderId","productId","quantity","price") VALUES (3,1,2,2000);

INSERT INTO Orders ("customerId","shopId","employeeId") VALUES (2,3,4);
INSERT INTO Order_Item("orderId","productId","quantity","price") VALUES (4,1,1,1000);
INSERT INTO Order_Item("orderId","productId","quantity","price") VALUES (4,2,1,1500);
INSERT INTO Order_Item("orderId","productId","quantity","price") VALUES (4,3,1,5000);

INSERT INTO Annual_Leave("employeeId","annualLeaveUsed") VALUES (1,10);

INSERT INTO Indemnity("employeeId","workingDay","indemnityAmount") VALUES (1,3650,50000);