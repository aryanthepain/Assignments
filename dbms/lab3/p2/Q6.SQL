SELECT
    e.EmployeeID AS ID,
    e.FirstName AS FirstName,
    e.LastName AS LastName,
    d.DepartmentName AS DepartmentName
FROM
    Employees e
    JOIN Departments d ON e.DepartmentID = d.DepartmentID;