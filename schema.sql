--To enable foreign key
PRAGMA foreign_keys = ON;

--represents customer information
CREATE TABLE Customers(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" VARCHAR(40) NOT NULL,
    "surname" VARCHAR(20) NOT NULL,
    "phoneNumber" TEXT NOT NULL UNIQUE CHECK("phoneNumber" GLOB '*[0-9]*'),
    "email" TEXT NOT NULL UNIQUE CHECK("email" LIKE '%@%'),
    "address" NVARCHAR(70) NOT NULL,
    "deleted" INTEGER DEFAULT 0 NOT NULL CHECK("deleted" BETWEEN 0 AND 1)
);

--Represents product trademarks
CREATE TABLE Trademarks(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" VARCHAR(50) NOT NULL UNIQUE
);

--Represents product categories
CREATE TABLE Categories(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" VARCHAR(50) NOT NULL UNIQUE
);

--Represents products sold
CREATE TABLE  Products(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" VARCHAR(50) NOT NULL,
    "stock" INTEGER NOT NULL CHECK("stock" >= 0),
    "categoryId" INTEGER NOT NULL,
    "trademarkId" INTEGER NOT NULL,   
    "price" NUMERIC NOT NULL CHECK("price" > 0),
    "productStatus" VARCHAR(20) NOT NULL CHECK("productStatus" IN ('sale','not on sale','stock expected')),
    FOREIGN KEY("trademarkId") REFERENCES Trademarks("id"),
    FOREIGN KEY("categoryId") REFERENCES categories("id"),
    CONSTRAINT unique_product_trademark UNIQUE ("trademarkId", "name")
);

--represents cities
CREATE TABLE Cities(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" VARCHAR(50) NOT NULL
);

--represents Shops
CREATE TABLE Shops(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" VARCHAR(50) NOT NULL,
    "cityId" INTEGER NOT NULL,
    "shopStatus" VARCHAR(12) NOT NULL CHECK("shopStatus" IN('active', 'repair','not active')),
    FOREIGN KEY("cityId") REFERENCES Cities("id")
);

--Represents departments in the store
CREATE TABLE Departments(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" VARCHAR(30) NOT NULL
);

--represents job positions
CREATE TABLE JobPositions(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" VARCHAR(50) NOT NULL UNIQUE
);

--represents employees
CREATE TABLE Employees(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "identificationNumber" TEXT UNIQUE NOT NULL CHECK("identificationNumber" GLOB '*[0-9]*'),
    "name" VARCHAR(50) NOT NULL,
    "surname" VARCHAR(50) NOT NULL,
    "gender" VARCHAR(15) NOT NULL,
    "phoneNumber" TEXT NOT NULL UNIQUE,
    "email" TEXT NOT NULL UNIQUE CHECK("email" LIKE '%@%'),
    "address" VARCHAR(70) NOT NULL,
    "jobPositionId" INTEGER NOT NULL,
    "departmentId" INTEGER NOT NULL,
    "shopId" INTEGER NOT NULL,
    "startDate" DATE NOT NULL DEFAULT CURRENT_DATE,
    "salary" NUMERIC NOT NULL CHECK("salary" > 0),
    "annualLeave" INTEGER NOT NULL DEFAULT 0,
    "workingStatus" VARCHAR(10) NOT NULL DEFAULT 'work' CHECK("workingStatus" IN ('work','annual leave','terminated')),
    FOREIGN KEY("jobPositionId") REFERENCES JobPositions("id"),
    FOREIGN KEY("departmentId") REFERENCES Departments("id"),
    FOREIGN KEY("shopId") REFERENCES Shops("id")
);

--Represents workers' compensation information
CREATE TABLE Indemnity(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "employeeId" INTEGER NOT NULL,
    "terminationDate" DATE NOT NULL DEFAULT CURRENT_DATE,
    "workingDay" INTEGER DEFAULT 0,
    "indemnityAmount" NUMERIC NOT NULL DEFAULT 0 CHECK("indemnityAmount" >= 0),
    FOREIGN KEY("employeeId") REFERENCES Employees("id")
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
    "shopId" INTEGER NOT NULL,
    "orderDate" DATE NOT NULL DEFAULT CURRENT_DATE,
    "employeeId" INTEGER NOT NULL,
    FOREIGN KEY("customerId") REFERENCES Customers("id"),
    FOREIGN KEY("shopId") REFERENCES Shops("id"),
    FOREIGN KEY("employeeId") REFERENCES Employees("id")
);

--Products in orders are kept
CREATE TABLE Order_Item(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "orderId" INTEGER NOT NULL,
    "productId" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL CHECK("quantity" > 0),
    "price" NUMERIC NOT NULL CHECK("price" > 0),
    "orderItemStatus" VARCHAR(20) NOT NULL DEFAULT 'getting ready' CHECK("orderItemStatus" IN ('getting ready','delivered','refunded','cancelled')),
    FOREIGN KEY("orderId") REFERENCES Orders("id"),
    FOREIGN KEY("productId") REFERENCES Products("id")
);

--indexes created
CREATE INDEX "customer_search" ON "Customers"("name","surname","email","address");
CREATE INDEX "product_search" ON "Products"("name");
CREATE INDEX "city_search" ON "Cities"("name");
CREATE INDEX "shop_search" ON "Shops"("name");
CREATE INDEX "employee_search" ON "Employees"("name","surname","email","address");

--view tables

--employee compensation view chart
CREATE VIEW "employee_indemnity" AS 
SELECT "Employees"."id" AS "employee_id", "Employees"."name", "Employees"."surname", "Indemnity"."terminationDate", "Indemnity"."workingDay", "Indemnity"."indemnityAmount" FROM "Employees"
JOIN "Indemnity" ON "Indemnity"."id" = "Employees"."id";

--table view with order information
CREATE VIEW "order_content" AS 
SELECT "Order_Item"."orderId" AS 'order_id', "Order_Item"."productId" AS 'product_id', "Orders"."customerId" AS 'customer_id', "Order_Item"."orderItemStatus",("quantity"*"price") AS "price",SUM("quantity"*"price") AS "total_order_price" FROM "Orders"
INNER JOIN "Order_Item" ON "Orders"."id" = "Order_Item"."orderId"
GROUP BY "Order_Item"."id";


--table view with order total price
CREATE VIEW "order_totalprice" AS 
SELECT "Order_Item"."orderId" AS 'order_id',"Orders"."customerId" AS 'customer_id',SUM("quantity"*"price") AS "total_order_price" FROM "Orders"
INNER JOIN "Order_Item" ON "Orders"."id" = "Order_Item"."orderId"
GROUP BY "Order_Item"."orderId";

--view with city store information
CREATE VIEW "shop_city" AS
SELECT "Shops"."id" AS "shop_id", "Shops"."name" AS "shop_name", "Cities"."id" AS "city_id", "Cities"."name" AS "city_name" FROM "Shops"
JOIN "Cities" ON "Shops"."cityId" = "Cities"."id";

--Shows the leave information used by employees
CREATE VIEW "employee_annualleave" AS
SELECT "Employees"."id" AS "employee_id", "Employees"."name", "Employees"."surname", SUM("Annual_Leave"."annualLeaveUsed") AS 'annualLeaveUsed' FROM "Employees"
JOIN "Annual_Leave" ON "Employees"."id" = "Annual_Leave"."employeeId"
GROUP BY "Annual_Leave"."employeeId";

--Shows employee information
CREATE VIEW "employee_information" AS 
SELECT "Employees"."id" AS "employee_id", "Employees"."name", "Employees"."surname", "JobPositions"."name" AS "job_position", "Departments"."name" AS "department_name","Shops"."name" AS 'shop_name', "Employees"."startDate", "Employees"."workingStatus", "Employees"."salary" FROM "Employees" 
JOIN "JobPositions" ON "Employees"."jobPositionId" = "JobPositions"."id"
JOIN "Departments" ON "Employees"."departmentId" = "Departments"."id"
JOIN "Shops" ON "Employees"."shopId" = "Shops"."id"
WHERE "Employees"."workingStatus" = 'work' OR  "Employees"."workingStatus" = 'annual leave';

--shows order information 
CREATE VIEW "order_information" AS 
SELECT "Orders"."id" AS "order_id", "Customers"."id" AS "customer_id" ,"Customers"."name" AS "customer_name", "Shops"."id" AS "shop_id", "Shops"."name" AS "shop_name", "Employees"."id" AS "employee_id" ,"Employees"."name" AS "employee_name",SUM("quantity"*"price") AS "total_order_price" FROM "Orders"
JOIN "Customers" ON "Orders"."customerId" = "Customers"."id"
JOIN "Shops" ON "Orders"."shopId" = "Shops"."id"
JOIN "Employees" ON "Orders"."employeeId" = "Employees"."id"
JOIN "Order_Item" ON "Orders"."id" = "Order_Item"."OrderId";

--lists product information
CREATE VIEW "product_details" AS
SELECT "Products"."id" AS "product_id","Products"."name" AS "product_name", "Products"."stock", "Products"."price" , "Products"."productStatus" , "Trademarks"."name" AS "trademark_name", "Categories"."name" AS "category_name" FROM "Products"
JOIN "Trademarks" ON "Trademarks"."id" = "Products"."trademarkId"
JOIN "Categories" ON "Categories"."id" = "Products"."categoryId";

--TRIGGERS

--Checks whether the Shop is active or not
CREATE TRIGGER employee_active_shop_control
BEFORE INSERT ON Employees
FOR EACH ROW 
WHEN NEW.shopId IN (SELECT "id" FROM "Shops" WHERE "shopStatus" != 'active') 
BEGIN
    SELECT RAISE(ABORT,'store is not active');
END;

--If there is no department it gives an error
CREATE TRIGGER employee_department_control
BEFORE INSERT ON Employees
FOR EACH ROW
WHEN NEW.departmentId NOT IN (SELECT "id" FROM "Departments")
BEGIN
    SELECT RAISE(ABORT,'department does not exist');
END;

--If there is no job position it gives an error
CREATE TRIGGER employee_jobPosition_control
BEFORE INSERT ON Employees
FOR EACH ROW
WHEN NEW.jobPositionId NOT IN (SELECT "id" FROM "JobPositions")
BEGIN
    SELECT RAISE(ABORT,'job position not available');
END;


--Checks if there is a store or not
CREATE TRIGGER employee_shop_control
BEFORE INSERT ON Employees
FOR EACH ROW 
WHEN NEW.shopId NOT IN (SELECT "id" FROM Shops)
BEGIN
    SELECT RAISE(ABORT,'There is no such store');
END;

--performs employee control
CREATE TRIGGER annual_leave_employee_check
BEFORE INSERT ON Annual_Leave
FOR EACH ROW
WHEN NEW.employeeId NOT IN (SELECT "id" FROM Employees) OR (SELECT "workingStatus" FROM "Employees" WHERE "id" = NEW.employeeId) = 'terminated'
BEGIN
    SELECT RAISE(ABORT,'There is no such employee');
END;

--Checks whether the employee has enough leave to use
CREATE TRIGGER annual_leave_check
BEFORE INSERT ON Annual_Leave
FOR EACH ROW
WHEN  NEW.annualLeaveUsed > (SELECT "annualLeave" FROM "Employees" WHERE "id" = NEW.employeeId) OR NEW.annualLeaveUsed = 0
BEGIN
    SELECT RAISE(ABORT,'The employee does not have enough leaves or the number of leaves is 0 entered');
END;


--When annual leave is used, it is deducted from your annual leave.
CREATE TRIGGER 	use_annual_leave
AFTER INSERT ON Annual_Leave
FOR EACH ROW
BEGIN
    UPDATE "Employees" SET "annualLeave" = annualLeave-NEW.annualLeaveUsed,"workingStatus" = 'annual leave' 
    WHERE "id" = NEW.employeeId;
END;

--Checks the employee and his/her status when the employee is leaving
CREATE TRIGGER indemnity_employee_controls
BEFORE INSERT ON Indemnity
FOR EACH ROW
WHEN NEW.employeeId IN (SELECT "id" FROM "Employees" WHERE "workingStatus" = 'terminated')
     OR NEW.employeeId NOT IN (SELECT "id" FROM "Employees")
BEGIN 
    SELECT RAISE(ABORT,'the employee has already left or no such employee exists');
END;

--When the employee leaves the job, the job status changes to terminated
CREATE TRIGGER indemnity_employee_workstatus
AFTER INSERT ON Indemnity
FOR EACH ROW
BEGIN 
    UPDATE "Employees" SET "workingStatus" = 'terminated' WHERE "id" = NEW.employeeId;
END;

--Checks if the store is active
CREATE TRIGGER sales_shop_active_control
BEFORE INSERT ON "Orders"
FOR EACH ROW
WHEN (SELECT "shopStatus" FROM "Shops" WHERE "id" = NEW.shopId) != 'active' 
BEGIN
    SELECT RAISE(ABORT,'store is not active');
END;

--Checks if there is a store or not
CREATE TRIGGER sales_shop_control
BEFORE INSERT ON "Orders"
FOR EACH ROW
WHEN NEW.shopId NOT IN (SELECT "id" FROM "Shops")
BEGIN
    SELECT RAISE(ABORT,'There is no such store');
END;

--Checks the status of the employee while making a sale
CREATE TRIGGER sales_employee_control
BEFORE INSERT ON "Orders"
FOR EACH ROW
WHEN (SELECT "workingStatus" FROM "Employees" WHERE "id" = NEW.employeeId) != 'work' 
OR NEW.employeeId NOT IN (SELECT "id" FROM Employees)
BEGIN
    SELECT RAISE(ABORT,'There does not appear to be such an employee');
END;

--Checks whether there is a customer or not
CREATE TRIGGER sales_customer_control
BEFORE INSERT ON "Orders"
FOR EACH ROW
WHEN  NEW.customerId NOT IN (SELECT "id" FROM Customers)
      OR (SELECT "deleted" FROM "Customers" WHERE "id" = NEW.customerId) = 1
BEGIN
    SELECT RAISE (ABORT,'customer does not exist');
END;

--Checks whether the product is available or not
CREATE TRIGGER product_control
BEFORE INSERT ON Order_Item
FOR EACH ROW
WHEN NEW.productId NOT IN (SELECT "id" FROM "Products") OR 'sale' != (SELECT "productStatus" FROM "Products" WHERE "id" = NEW.productId)
BEGIN 
    SELECT RAISE (ABORT,'such a product is not on sale');
END;

--Checks product stock status
CREATE TRIGGER product_stock_control
BEFORE INSERT ON Order_Item
FOR EACH ROW
WHEN(SELECT "stock" FROM "Products" WHERE "id" = NEW.productId) < NEW.quantity
BEGIN 
    SELECT RAISE (ABORT,'no product stock');
END;

--Refunds canceled or returned orders
CREATE TRIGGER order_cancellation_refund_procedures
AFTER UPDATE OF "orderItemStatus" ON Order_Item
FOR EACH ROW
WHEN NEW.orderItemStatus = 'cancelled'
BEGIN
    UPDATE "Products" SET "stock" = stock + NEW.quantity WHERE "id" = (SELECT "productId" FROM "Order_Item" WHERE "orderId" = NEW.orderId AND "id" = NEW.id);
END;


CREATE TRIGGER order_delivery_transactions
AFTER UPDATE OF "orderItemStatus" ON Order_Item
FOR EACH ROW
WHEN NEW.orderItemStatus = 'delivered'
BEGIN
    UPDATE "Products" SET "stock" = "stock" - NEW.quantity WHERE "id" = NEW.productId;
END;

--Changes order status if product is out of stock after sale
CREATE TRIGGER product_stock_end
AFTER UPDATE OF "stock" ON Products
FOR EACH ROW
WHEN NEW.stock = 0
BEGIN
    UPDATE "Products" SET "productStatus" = 'stock expected' 
    WHERE "id" = NEW.id;
END;

--When product stock is added
CREATE TRIGGER adding_product_stock
AFTER UPDATE OF "stock" ON Products
FOR EACH ROW
WHEN NEW.stock > 0
BEGIN
    UPDATE "Products" SET "productStatus" = 'sale' 
    WHERE "id" = NEW.id;
END;


--When the ordered products are delivered
CREATE TRIGGER order_state_update
AFTER INSERT ON Order_Item
BEGIN
  UPDATE Order_Item
  SET "orderItemStatus" = 'delivered'
  WHERE orderId = NEW.orderId AND productId = NEW.productId;
END;
