--represents customer information
CREATE TABLE Customers(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "identificationNumber" TEXT UNIQUE NOT NULL CHECK("identificationNumber" GLOB '*[0-9]*'), 
    "name" VARCHAR(40) NOT NULL,
    "surname" VARCHAR(20) NOT NULL,
    "phoneNumber" TEXT NOT NULL,
    "email" TEXT NOT NULL CHECK("email" LIKE '%@%'),
    "point" INTEGER DEFAULT 0 NOT NULL CHECK("point" >= 0),
    "deleted" INTEGER DEFAULT 0 NOT NULL CHECK("deleted" BETWEEN 0 AND 1)
);

--Represents product categories
CREATE TABLE Categories(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" VARCHAR(50) NOT NULL
);

--Represents products sold
CREATE TABLE Products(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" VARCHAR(100) NOT NULL,
    "stock" INTEGER NOT NULL CHECK("stock" >= 0),
    "trademark" NVARCHAR(30) NOT NULL,   
    "price" NUMERIC NOT NULL CHECK("price" >= 0),
    "categoryId" INTEGER NOT NULL,
    "productStatus" VARCHAR(20) NOT NULL CHECK("productStatus" IN ('sale','not on sale','stock expected')),
    FOREIGN KEY("categoryId") REFERENCES Categories("id")
);

--represents cities
CREATE TABLE Cities(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" VARCHAR(50) NOT NULL
);

--represents Shops
CREATE TABLE Shops(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" VARCHAR(100) NOT NULL,
    "cityId" INTEGER NOT NULL,
    "shopStatus" VARCHAR(20) NOT NULL CHECK("shopStatus" IN('active', 'repair','not active')),
    FOREIGN KEY("cityId") REFERENCES Cities("id")
);

--Represents departments in the store
CREATE TABLE Departments(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" VARCHAR(50) NOT NULL,
    "shopId" INTEGER NOT NULL,
    FOREIGN KEY("shopId") REFERENCES Shops("id")
);

--Represents working teams
CREATE TABLE Teams(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" VARCHAR(50) NOT NULL,
    "DepartmentId" INTEGER NOT NULL,
    FOREIGN KEY("DepartmentId") REFERENCES "Departments"("id")
);

--represents job positions
CREATE TABLE JobPositions(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" VARCHAR(30) NOT NULL
);

--represents employees
CREATE TABLE Employees(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "identificationNumber" TEXT UNIQUE NOT NULL CHECK("identificationNumber" GLOB '*[0-9]*'),
    "name" VARCHAR(50) NOT NULL,
    "surname" VARCHAR(50) NOT NULL,
    "gender" VARCHAR(6) NOT NULL,
    "phoneNumber" TEXT NOT NULL,
    "email" TEXT NOT NULL CHECK("email" LIKE '%@%'),
    "cityId" INTEGER NOT NULL,
    "jobPositionId" INTEGER NOT NULL,
    "teamId" INTEGER NOT NULL,
    "startDate" DATE NOT NULL DEFAULT CURRENT_DATE,
    "numberofSales" INTEGER NOT NULL DEFAULT 0 CHECK("numberofSales" >= 0),
    "salary" NUMERIC NOT NULL CHECK("salary" >= 0),
    "annualLeave" INTEGER NOT NULL DEFAULT 0,
    "workingStatus" VARCHAR(10) NOT NULL CHECK("workingStatus" IN ('work','annual leave','terminated')),
    FOREIGN KEY("cityId") REFERENCES Cities("id"),
    FOREIGN KEY("jobPositionId") REFERENCES JobPositions("id"),
    FOREIGN KEY("teamId") REFERENCES Teams("id")
);

--Represents workers' compensation information
CREATE TABLE Indemnity(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "employeeId" INTEGER NOT NULL,
    "terminationDate" DATE NOT NULL DEFAULT CURRENT_DATE,
    "workingDay" INTEGER NOT NULL,
    "indemnityAmount" NUMERIC NOT NULL CHECK("indemnityAmount" >= 0),
    FOREIGN KEY("employeeId") REFERENCES "Employees"("id")
);

CREATE TABLE Annual_Leave(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "employeeId" INTEGER NOT NULL,
    "annualLeaveUsed" int NOT NULL,
    FOREIGN KEY("employeeId") REFERENCES "Employees"("id")
);

--represents orders
CREATE TABLE Orders(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "customerId" INTEGER NOT NULL,
    "productId" INTEGER NOT NULL,
    "shopId" INTEGER NOT NULL,
    "orderDate" DATE NOT NULL DEFAULT CURRENT_DATE,
    "totalPrice" NUMERIC NOT NULL CHECK("totalPrice" >= 0),
    "pointUsage" INTEGER NOT NULL DEFAULT 0,
    "employeeId" INTEGER NOT NULL,
    "orderStatus" VARCHAR(20) NOT NULL CHECK("orderStatus" IN ('delivered','refunded','cancelled')),
    FOREIGN KEY("customerId") REFERENCES Customers("id"),
    FOREIGN KEY("productId") REFERENCES Products("id"),
    FOREIGN KEY("shopId") REFERENCES Shops("id"),
    FOREIGN KEY("employeeId") REFERENCES Employees("id")
);

--indexes created
CREATE INDEX "customer_search" ON "Customers"("name","surname","email");
CREATE INDEX "product_search" ON "Products"("name");
CREATE INDEX "city_search" ON "Cities"("name");
CREATE INDEX "shop_search" ON "Shops"("name");
CREATE INDEX "employee_search" ON "Employees"("name","surname","email");

--view tables

--Represents product category information
CREATE VIEW "product_category" AS
SELECT "Products"."id" AS "product_id", "Products"."name" AS "product_name", "Categories"."id" AS "category_id", "Categories"."name" AS "category_name" FROM "Products"
INNER JOIN "Categories" ON "Products"."categoryId" = "Categories"."id";

--represents store city information
CREATE VIEW "shop_city" AS
SELECT "Shops"."id" AS "shop_id", "Shops"."name" AS "shop_name", "Cities"."id" AS "city_id", "Cities"."name" AS "city_name" FROM "Shops"
INNER JOIN "Cities" ON "Shops"."cityId" = "Cities"."id";

--team represents departmental knowledge
CREATE VIEW "team_department_city" AS
SELECT "Teams"."id" AS "team_id", "Teams"."name" AS "team_name", "Departments"."id" AS "department_id", "Departments"."name" AS "department_name", "Departments"."cityId" AS "city_id"  FROM "Teams"
INNER JOIN "Departments" ON "Teams"."DepartmentId" = "Departments"."id";

--Represents employee name, surname, city, job position and team information.
CREATE VIEW "employee_information" AS 
SELECT "Employees"."id" AS "employee_id", "Employees"."identificationNumber" AS "identificationNumber", "Employees"."name" AS "employee_name", "Employees"."surname" AS "employee_surname","Cities"."name" AS "home_city", "JobPositions"."name" AS "job_position", "Teams"."name" AS "team_name" FROM "Employees" 
INNER JOIN "Cities" ON "Employees"."cityId" = "Cities"."id"
INNER JOIN "JobPositions" ON "Employees"."jobPositionId" = "JobPositions"."id"
INNER JOIN "Teams" ON "Employees"."teamId" = "Teams"."id";

--Represents employee Indemnity information
CREATE VIEW "employee_indemnity" AS
SELECT "Employees"."id" AS "employee_id", "Employees"."name" AS "employee_name", "Employees"."surname" AS "employee_surname", "Indemnity"."id" AS "indemnity_id", "Indemnity"."indemnityAmount" AS "indemnity_amount" FROM "Employees"
INNER JOIN "Indemnity" ON "Employees"."id" = "Indemnity"."employeeId";

--Represents order id, customer name, product name, store name, employee name information
CREATE VIEW "order_imformation" AS 
SELECT "Orders"."id" AS "order_id", "Customers"."id" AS "customer_id" ,"Customers"."name" AS "customer_name", "Products"."id" AS "product_id", "Products"."name" AS "product_name", "Shops"."id" AS "shop_id", "Shops"."name" AS "shop_name", "Employees"."name" AS "employee_id" ,"Employees"."name" AS "employee_name" FROM "Orders"
INNER JOIN "Customers" ON "Orders"."customerId" = "Customers"."id"
INNER JOIN "Products" ON "Orders"."productId" = "Products"."id"
INNER JOIN "Shops" ON "Orders"."shopId" = "Shops"."id"
INNER JOIN "Employees" ON "Orders"."employeeId" = "Employees"."id";

--TRIGGERS

--Pre-sale stock control warns you that if stock is not sufficient, the transaction will not go through.
CREATE TRIGGER 	sales_stock_control
BEFORE INSERT ON "Orders"
FOR EACH ROW
WHEN (SELECT "stock" FROM  "Products" WHERE "id" = NEW.productId) = 0
BEGIN
    SELECT RAISE (ABORT,'stock is not enough');
END;

--Pre-sale score control warns you that if the score is not sufficient, the transaction will not be carried out.
CREATE TRIGGER sales_point_control
BEFORE INSERT ON "Orders"
FOR EACH ROW
WHEN (SELECT "point" FROM "Customers" WHERE "id" = NEW.customerId) < NEW.pointUsage
BEGIN
    SELECT RAISE (ABORT,'point are not enough');
END;

--store activity control
CREATE TRIGGER sales_shop_control
BEFORE INSERT ON "Orders"
FOR EACH ROW
WHEN (SELECT "shopStatus" FROM "Shops" WHERE id = NEW.shopId) = "repair" OR (SELECT "shopStatus" FROM "Shops" WHERE id = NEW.shopId) = "not active" 
BEGIN
    SELECT RAISE(ABORT,'shop is not active');
END;

--Makes additions to necessary tables after sales (Stok-1),(numberofSales+1),(point-pointusage),("orderStatus"="delivered")
CREATE TRIGGER after_sale
AFTER INSERT ON "Orders"
FOR EACH ROW
BEGIN
    UPDATE "Products" SET "stock" = stock-1 WHERE "id" = NEW.productId;
    UPDATE "Employees" SET "numberofSales" = numberofSales+1 WHERE "id" = NEW.employeeId;
    UPDATE "Customers" SET "point" = point-NEW.pointUsage WHERE "id" = NEW.customerId;
    UPDATE "Orders" SET "orderStatus" = "delivered" WHERE "id" = NEW.id;
    UPDATE "Customers" SET "point" = (NEW.totalPrice*0.01) + point WHERE "id" = NEW.customerId;
END;

--Changes stock status when product is out of stock
CREATE TRIGGER product_stock
AFTER UPDATE OF "stock" ON "Products"
FOR EACH ROW
WHEN (SELECT "stock" FROM  "Products" WHERE id = NEW.id) = 0
BEGIN
    UPDATE "Products" SET "productStatus" = "stock expected" WHERE id = NEW.id;
END;

--employee changes work status when leaving work
CREATE TRIGGER indemnity_employee
AFTER INSERT ON Indemnity
FOR EACH ROW
BEGIN 
    UPDATE "Employees" SET "workingStatus" = "terminated" WHERE id = NEW.employeeId;
END;

--control when taking annual leave
CREATE TRIGGER annual_leave_check
BEFORE INSERT ON Annual_Leave
FOR EACH ROW
WHEN NEW.annualLeaveUsed > (SELECT "annualLeave" FROM "Employees" WHERE id = NEW.employeeId)
BEGIN
    SELECT RAISE (ABORT,'annual leave is insufficient');
END;

--updates required columns when annual leave is used
CREATE TRIGGER 	use_annual_leave
AFTER INSERT ON Annual_Leave
FOR EACH ROW
BEGIN
    UPDATE "Employees" SET "annualLeave" = annualLeave-NEW.annualLeaveUsed WHERE id = NEW.employeeId;
    UPDATE "Employees" SET "workingStatus" = "annual leave" WHERE id = NEW.employeeId;
END;