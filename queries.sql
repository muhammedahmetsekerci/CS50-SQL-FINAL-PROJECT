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