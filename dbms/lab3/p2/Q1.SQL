INSERT INTO
    Departments (DepartmentID, DepartmentName, ManagerID)
VALUES
    (1, 'IT', 1),
    (2, 'Finance', 2),
    (3, 'HR', 3);

INSERT INTO
    Employees (
        EmployeeID,
        FirstName,
        LastName,
        DepartmentID,
        JobTitle,
        HireDate,
        Salary
    )
VALUES
    (
        1,
        'John',
        'Doe',
        1,
        'Developer',
        '2020-05-15',
        66000.00
    ),
    (
        2,
        'Jane',
        'Smith',
        2,
        'Accountant',
        '2018-03-10',
        60500.00
    ),
    (
        3,
        'Alice',
        'Johnson',
        3,
        'HR Manager',
        '2017-09-20',
        71500.00
    ),
    (
        4,
        'Bob',
        'Brown',
        1,
        'System Analyst',
        '2021-07-01',
        55000.00
    );

INSERT INTO
    Projects (
        ProjectID,
        ProjectName,
        StartDate,
        EndDate,
        Budget
    )
VALUES
    (
        1,
        'Project A',
        '2023-01-01',
        '2023-12-31',
        82500.00
    ),
    (
        2,
        'Project B',
        '2022-06-01',
        '2023-06-01',
        33000.00
    ),
    (3, 'Project C', '2023-03-01', NULL, 132000.00);

INSERT INTO
    EmployeeProjects (EmployeeID, ProjectID, HoursWorked)
VALUES
    (1, 1, 132.50),
    (2, 2, 88.00),
    (1, 3, 165.00),
    (4, 3, 66.00);