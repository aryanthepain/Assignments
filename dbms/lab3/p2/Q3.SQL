SELECT
    *
FROM
    Employees
WHERE
    DepartmentID = (
        SELECT
            DepartmentID
        FROM
            Departments
        WHERE
            DepartmentName = 'IT'
    );