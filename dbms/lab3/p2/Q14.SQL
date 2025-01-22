SELECT
    e.EmployeeID AS ID,
    e.FirstName AS FirstName,
    e.LastName AS LastName
FROM
    Employees e
WHERE
    e.EmployeeID IN (
        SELECT
            ep.EmployeeID
        FROM
            EmployeeProjects ep
        WHERE
            ep.HoursWorked > 100
    )