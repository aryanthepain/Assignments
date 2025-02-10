-- student table
CREATE TABLE
    students (
        Roll_number BIGINT PRIMARY key auto_increment NOT NULL,
        name VARCHAR(25) NOT NULL,
        photo BLOB NOT NULL,
        Phone_no INT (11) NOT NULL
    );

CREATE TABLE
    student_password (
        Roll_number BIGINT PRIMARY key NOT NULL,
        password VARCHAR(20) NOT NULL,
        FOREIGN key (Roll_number) REFERENCES students (Roll_number) ON DELETE cascade
    );

-- examiner table
CREATE TABLE
    examiners (
        EID BIGINT PRIMARY key auto_increment NOT NULL,
        name VARCHAR(25) NOT NULL,
        Phone_no VARCHAR(10) NOT NULL
    );

CREATE TABLE
    examiner_password (
        EID BIGINT PRIMARY key NOT NULL,
        password VARCHAR(20) NOT NULL,
        FOREIGN key (EID) REFERENCES examiners (EID) ON DELETE cascade
    );

-- exam table
CREATE TABLE
    exam (
        Exam_ID BIGINT PRIMARY key auto_increment NOT NULL,
        name VARCHAR(25) NOT NULL,
        fees INT (10) NOT NULL DEFAULT 0
    );

CREATE TABLE
    administered_by (
        EID BIGINT NOT NULL,
        Exam_ID BIGINT NOT NULL,
        FOREIGN KEY (EID) REFERENCES examiners (EID) ON DELETE cascade,
        FOREIGN KEY (Exam_ID) REFERENCES exam (Exam_ID) ON DELETE cascade
    );

-- defining slots
CREATE TABLE
    slot (
        slot_ID BIGINT PRIMARY KEY AUTO_INCREMENT NOT NULL,
        start_time DATETIME NOT NULL,
        duration INT NOT NULL
    );

CREATE TABLE
    available_on_slot (
        slot_ID BIGINT NOT NULL,
        Exam_ID BIGINT NOT NULL,
        FOREIGN KEY (slot_ID) REFERENCES slot (slot_ID) ON DELETE cascade,
        FOREIGN KEY (Exam_ID) REFERENCES exam (Exam_ID) ON DELETE cascade
    );

-- booking exam
CREATE TABLE
    takes_exam (
        booking_ID INT NOT NULL PRIMARY key AUTO_INCREMENT,
        Roll_number BIGINT NOT NULL,
        Exam_ID BIGINT NOT NULL,
        transaction_ID text DEFAULT NULL,
        end_time DATETIME NULL DEFAULT NULL,
        slot_ID BIGINT DEFAULT NULL,
        difficulty_counter INT NOT NULL DEFAULT 0,
        FOREIGN key (Roll_number) REFERENCES students (Roll_number) ON DELETE cascade,
        FOREIGN KEY (slot_ID) REFERENCES slot (slot_ID) ON DELETE SET NULL,
        FOREIGN KEY (Exam_ID) REFERENCES exam (Exam_ID) ON DELETE cascade
    );

-- adding questions
CREATE TABLE
    questions (
        QID INT NOT NULL PRIMARY key AUTO_INCREMENT,
        question text NOT NULL,
        difficulty INT NOT NULL,
        option1 text NOT NULL,
        option2 text NOT NULL,
        option3 text NOT NULL,
        option4 text NOT NULL,
        correct_option INT NOT NULL
    );

CREATE TABLE
    uploaded_by (
        QID INT NOT NULL PRIMARY key,
        EID BIGINT NOT NULL,
        FOREIGN KEY (QID) REFERENCES questions (QID) ON DELETE cascade,
        FOREIGN KEY (EID) REFERENCES examiners (EID) ON DELETE cascade
    );

-- in exam
CREATE TABLE
    in_exam (
        QID INT NOT NULL PRIMARY key,
        Exam_ID BIGINT NOT NULL,
        FOREIGN KEY (QID) REFERENCES questions (QID) ON DELETE cascade,
        FOREIGN KEY (Exam_ID) REFERENCES exam (Exam_ID) ON DELETE cascade
    );

-- results
CREATE TABLE
    exam_results (
        result_ID BIGINT PRIMARY KEY AUTO_INCREMENT,
        booking_ID INT NOT NULL,
        QID INT NOT NULL,
        selected_option INT DEFAULT NULL,
        is_correct BOOLEAN DEFAULT NULL,
        start_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        end_time DATETIME DEFAULT NULL,
        FOREIGN KEY (booking_ID) REFERENCES takes_exam (booking_ID) ON DELETE CASCADE,
        FOREIGN KEY (QID) REFERENCES questions (QID) ON DELETE CASCADE
    );

-- feedback
CREATE TABLE
    feedback (
        feedback_ID INT PRIMARY KEY AUTO_INCREMENT,
        booking_ID INT NOT NULL,
        QID INT NOT NULL,
        EID BIGINT NOT NULL,
        feedback_text TEXT NOT NULL,
        FOREIGN KEY (booking_ID) REFERENCES takes_exam (booking_ID) ON DELETE CASCADE,
        FOREIGN KEY (QID) REFERENCES questions (QID) ON DELETE CASCADE,
        FOREIGN KEY (EID) REFERENCES examiners (EID) ON DELETE CASCADE
    );