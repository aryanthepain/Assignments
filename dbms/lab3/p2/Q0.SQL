-- CREATE Employees TABLE
CREATE TABLE
    Employees (
        EmployeeID INT PRIMARY KEY NOT NULL,
        FirstName VARCHAR(50) NOT NULL,
        LastName VARCHAR(50) NOT NULL,
        DepartmentID INT NOT NULL,
        JobTitle VARCHAR(50) NOT NULL,
        HireDate DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
        Salary DECIMAL(10, 2) NOT NULL
    );

-- CREATE Departments TABLE
CREATE TABLE
    Departments (
        DepartmentID INT PRIMARY KEY NOT NULL,
        DepartmentName VARCHAR(100) NOT NULL,
        ManagerID INT,
        FOREIGN KEY (ManagerID) REFERENCES Employees (EmployeeID) ON DELETE SET NULL
    );

-- CREATE Projects TABLE
CREATE TABLE
    Projects (
        ProjectID INT PRIMARY KEY NOT NULL,
        ProjectName VARCHAR(100) NOT NULL,
        StartDate DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
        EndDate DATE DEFAULT NULL,
        Budget DECIMAL(15, 2) NOT NULL
    );

-- CREATE EmployeeProjects TABLE
CREATE TABLE
    EmployeeProjects (
        EmployeeID INT,
        ProjectID INT,
        HoursWorked DECIMAL(5, 2) DEFAULT NULL,
        FOREIGN KEY (EmployeeID) REFERENCES Employees (EmployeeID) ON DELETE SET NULL,
        FOREIGN KEY (ProjectID) REFERENCES Projects (ProjectID) ON DELETE SET NULL
    );