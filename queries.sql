--Lists the 5 most expensive orders in 2023
SELECT * FROM "Orders"
WHERE ("orderDate" BETWEEN "2023-01-01" AND "2023-12-31") AND "orderStatus" = "delivered"
ORDER BY "totalPrice" DESC limit 5;

--It lists the number of days of leave used by employees on leave and employee information.
SELECT "Employees"."id", "Employees"."name", "Employees"."surname", "Annual_Leave"."annualLeaveUsed" FROM "Annual_Leave"
INNER JOIN "Employees" ON "Annual_Leave"."employeeId" = "Employees"."id"
WHERE "Employees"."workingStatus" = "annual leave";

--Lists employee compensation information based on employee information
SELECT * FROM "Indemnity"
WHERE "employeeId" = (
    SELECT "id" FROM "Employees"
    WHERE "name" = "Gabriel" AND "surname" = "Phillips"
);

--Lists the 5 employees with the highest sales in 2022
SELECT "Employees"."name",SUM("Employees"."numberofSales") AS "total sales" FROM "Employees"
INNER JOIN "Orders" ON "Employees"."id" = "Orders"."employeeId"
WHERE "Orders"."orderDate" BETWEEN "2022-01-01" AND 2022-12-31
GROUP BY "Employees"."name"
ORDER BY "total sales" DESC lIMIT 5;

--Lists employees who are on leave
SELECT * FROM "Employees"
WHERE "workingStatus" = "annual leave";

--Lists employees in the electronics team
SELECT * FROM "Employees"
WHERE "teamId" = (
    SELECT "id" FROM "Teams"
    WHERE "name" = "electronics team"
);

--Lists all employees with electronic engineer positions
SELECT * FROM "Employees"
WHERE "jobPositionId" = (
    SELECT "id" FROM "JobPositions" 
    WHERE "name" = "Electronics Engineer"
);

--Lists the names of teams in the home appliance department
SELECT "name" FROM "Teams"
WHERE "DepartmentId" = (
    SELECT "id" FROM "Departments"
    WHERE "name" = "Household appliances"
);

--Lists the name of departments at Electronics Store NY
SELECT "name" FROM "Departments"
WHERE "shopId" = (
    SELECT "id" FROM "Shops"
    WHERE "name" = "Electronics Store NY"
);

--Lists active stores in New York
SELECT * FROM "Shops"
WHERE "cityId" IN (
    SELECT "id" FROM "Cities"
    WHERE "name" = "New York"
) AND "shopStatus" = "active";

--Lists products in the technology category
SELECT * FROM "Products"
WHERE "categoryId" = (
    SELECT "id" FROM "Categories"
    WHERE "name" = "technology"
);

--Find all all orders given customer name and surname
SELECT * FROM "Orders"
WHERE "customerId" IN (
    SELECT "id" FROM "Customers"
    WHERE "name" = "Carson" AND "surname" = "Bennett"
);

--Lists city and store information (View)
SELECT * FROM "shop_city";

--Returns employee compensation information for the given employee information (View)
SELECT * FROM "employee_indemnity"
WHERE "employee_id" = (
    SELECT "id" FROM "Employees"
    WHERE "name" = "Harper" AND "surname" = "Wright"
);

--Lists products and category information sold in Game and Entertainment Systems (View)
SELECT * FROM "product_category"
WHERE "category_name" = (
    SELECT "id" FROM "Categories"
    WHERE "name" = "Game and Entertainment Systems"
);

--Shows team department information in the city of Oswego (View)
SELECT * FROM "team_department_city"
WHERE "city_id" = (
    SELECT "id" FROM "Cities"
    WHERE "name" = "Oswego"
);

--Shows information about a specific user (View)
SELECT * FROM "employee_information"
WHERE "employee_id" = (
    SELECT "id" FROM "Employees"
    WHERE "name" = "Zoey" AND "surname" = "Jenkins"
);

--Lists orders received from the "Electronics Store Owg" store (View)
SELECT * FROM "order_imformation"
WHERE "shop_id" = (
    SELECT "id" FROM "Shops"
    WHERE "name" = "Electronics Store Owg"
);