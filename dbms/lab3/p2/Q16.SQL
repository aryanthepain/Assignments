CREATE VIEW
    DepartmentSalarySummary AS
SELECT
    d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount,
    SUM(e.Salary) AS TotalSalary,
    AVG(e.Salary) AS AverageSalary
FROM
    Employees e
    JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY
    d.DepartmentName;