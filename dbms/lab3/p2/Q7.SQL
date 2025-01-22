SELECT
    *
FROM
    Employees
WHERE
    EmployeeID = ANY (
        SELECT
            EmployeeID
        FROM
            EmployeeProjects
    );