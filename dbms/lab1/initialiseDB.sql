CREATE TABLE
    students (
        Roll_number BIGINT PRIMARY key auto_increment NOT NULL,
        First_name VARCHAR(25) NOT NULL,
        Last_name VARCHAR(25) NOT NULL,
        DOB DATE NOT NULL,
        branch VARCHAR(10) NOT NULL,
        Phone_no INT NOT NULL,
        Hostel VARCHAR(50) NOT NULL,
        GPA FLOAT NOT NULL
    );