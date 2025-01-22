UPDATE Employees
SET
    Salary = Salary * 1.10
WHERE
    DepartmentID = (
        SELECT
            DepartmentID
        FROM
            Departments
        WHERE
            DepartmentName = 'Finance'
    );