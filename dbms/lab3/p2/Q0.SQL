-- CREATE Employees TABLE
CREATE TABLE
    Employees (
        EmployeeID INT PRIMARY KEY,
        FirstName VARCHAR(50),
        LastName VARCHAR(50),
        DepartmentID INT,
        JobTitle VARCHAR(50),
        HireDate DATE,
        Salary DECIMAL(10, 2)
    );

-- CREATE Departments TABLE
CREATE TABLE
    Departments (
        DepartmentID INT PRIMARY KEY,
        DepartmentName VARCHAR(100),
        ManagerID INT,
        FOREIGN KEY (ManagerID) REFERENCES Employees (EmployeeID)
    );

-- CREATE Projects TABLE
CREATE TABLE
    Projects (
        ProjectID INT PRIMARY KEY,
        ProjectName VARCHAR(100),
        StartDate DATE,
        EndDate DATE,
        Budget DECIMAL(15, 2)
    );

-- CREATE EmployeeProjects TABLE
CREATE TABLE
    EmployeeProjects (
        EmployeeID INT,
        ProjectID INT,
        HoursWorked DECIMAL(5, 2),
        FOREIGN KEY (EmployeeID) REFERENCES Employees (EmployeeID),
        FOREIGN KEY (ProjectID) REFERENCES Projects (ProjectID),
        PRIMARY KEY (EmployeeID, ProjectID)
    );