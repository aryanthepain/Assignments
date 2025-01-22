UPDATE Departments
SET
    ManagerID = 2
WHERE
    DepartmentID = 1;

UPDATE Departments
SET
    ManagerID = 3
WHERE
    DepartmentID = 2;

UPDATE Departments
SET
    ManagerID = 1
WHERE
    DepartmentID = 3;