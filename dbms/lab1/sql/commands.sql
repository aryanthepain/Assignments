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

INSERT INTO
    students (
        First_name,
        Last_name,
        DOB,
        branch,
        Phone_no,
        Hostel,
        GPA
    )
VALUES
    (
        'Aryan',
        'Gupta',
        '2005-04-26',
        'DSAI',
        4512354898,
        'Umiam',
        8.5
    ),
    (
        'Jane',
        'Smith',
        '1996-05-22',
        'DSAI',
        0987654321,
        'B2',
        9.0
    ),
    (
        'Sam',
        'Brown',
        '1997-06-15',
        'DSAI',
        1122334455,
        'C3',
        8.0
    );

INSERT INTO students (First_name,Last_name,DOB,branch,Phone_no,Hostel,GPA)
VALUES(:firstName,:lastName,:dob,:branch,:phone_no,:hostel,:CPI);

SELECT * FROM students WHERE Roll_number=1;