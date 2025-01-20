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
        Roll_number INT (9),
        issue_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        return_date DATETIME NULL,
        FOREIGN key (book_id) REFERENCES books (book_id) ON DELETE CASCADE,
        FOREIGN key (Roll_number) REFERENCES students (Roll_number) ON DELETE SET NULL
    );