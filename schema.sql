CREATE TABLE Customers(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "identificationNumber" INTEGER UNIQUE NOT NULL, 
    "name" VARCHAR(40) NOT NULL,
    "surname" VARCHAR(20) NOT NULL,
    "phoneNumber" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "point" INTEGER DEFAULT 0
);

CREATE TABLE Categories(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" VARCHAR(50) NOT NULL
);

CREATE TABLE Products(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" VARCHAR(100) NOT NULL,
    "stock" INTEGER NOT NULL,
    "price" MONEY NOT NULL,
    "categoryId" INTEGER NOT NULL,
    FOREIGN KEY("categoryId") REFERENCES Categories("id")
);

CREATE TABLE Cities(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" VARCHAR(50) NOT NULL
);

CREATE TABLE Shops(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" VARCHAR(100) NOT NULL,
    "cityId" INTEGER NOT NULL,
    FOREIGN KEY("cityId") REFERENCES Cities("id")
);

CREATE TABLE Departments(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" VARCHAR(50) NOT NULL
);

CREATE TABLE Teams(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" VARCHAR(50) NOT NULL,
    "DepartmentId" INTEGER NOT NULL,
    FOREIGN KEY("DepartmentId") REFERENCES "Departments"("id")
);

CREATE TABLE JobPositions(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" VARCHAR(30) NOT NULL,
    "salary" MONEY NOT NULL
);

CREATE TABLE Employees(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" VARCHAR(50) NOT NULL,
    "surname" VARCHAR(50) NOT NULL,
    "gender" VARCHAR(6) NOT NULL,
    "phoneNumber" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "cityId" INTEGER NOT NULL,
    "jobPositionId" INTEGER NOT NULL,
    "teamId" INTEGER NOT NULL,
    "startDate" DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "numberofSales" INTEGER NOT NULL DEFAULT 0,
    "workingStatus" VARCHAR(10) NOT NULL,
    FOREIGN KEY("cityId") REFERENCES Cities("id"),
    FOREIGN KEY("jobPositionId") REFERENCES JobPositions("id"),
    FOREIGN KEY("teamId") REFERENCES Teams("id")
);

CREATE TABLE Indemnity(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "employeeId" INTEGER NOT NULL,
    "terminationDate " DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "workingDay" INTEGER NOT NULL,
    "indemnityAmount" MONEY NOT NULL
);

CREATE TABLE Orders(
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "customerId" INTEGER NOT NULL,
    "productId" INTEGER NOT NULL,
    "shopId" INTEGER NOT NULL,
    "orderDate" DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "totalPrice" MONEY NOT NULL,
    "pointUsage" MONEY NOT NULL DEFAULT 0,
    "employeeId" INTEGER NOT NULL,
    "orderStatus" VARCHAR(20) NOT NULL,
    FOREIGN KEY("customerId") REFERENCES Customers("id"),
    FOREIGN KEY("productId") REFERENCES Products("id"),
    FOREIGN KEY("shopId") REFERENCES Shops("id"),
    FOREIGN KEY("employeeId") REFERENCES Employees("id")
);

