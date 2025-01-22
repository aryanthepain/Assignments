SELECT
    d.DepartmentName AS DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount
FROM
    Employees e
    JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY
    d.DepartmentID
HAVING
    COUNT(e.EmployeeID) > 2;