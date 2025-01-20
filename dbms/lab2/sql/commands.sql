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
        firstName,
        lastName,
        dob,
        branch,
        phone_no,
        hostel,
        CPI
    );

SELECT
    *
FROM
    students
WHERE
    Roll_number = 1;

CREATE TABLE
    students (
        Roll_number INT (9) PRIMARY key NOT NULL,
        first_name VARCHAR(25) NOT NULL
    );

CREATE TABLE
    books (
        book_id INT (5) PRIMARY key NOT NULL,
        book_name VARCHAR(25) NOT NULL
    );

CREATE TABLE
    has_issued (
        transaction_id INT PRIMARY key NOT NULL auto_increment,
        book_id INT (5) NOT NULL,
        Roll_number INT (9) NOT NULL,
        issue_date TIME NOT NULL,
        return_date TIME NULL,
        FOREIGN key (book_id) REFERENCES books (book_id),
        FOREIGN key (Roll_number) REFERENCES students (Roll_number)
    );

SELECT
    *
FROM
    students
WHERE
    Roll_number = 1;

INSERT INTO
    students (first_name, Roll_number)
VALUES
    (firstName, roll);

ALTER TABLE has_issued MODIFY COLUMN issue_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;

SELECT
    book_id
FROM
    has_issued
WHERE
    book_id = 1
    AND return_date IS NULL
INSERT INTO
    `has_issued` (`book_id`, `Roll_number`)
VALUES
    ('[value-1]', '[value-2]');