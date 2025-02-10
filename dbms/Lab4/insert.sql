-- Insert students
INSERT INTO
    students (Roll_number, name, photo, Phone_no)
VALUES
    (
        1,
        'Amit Sharma',
        'dummy_photo_data_1',
        '9876543210'
    ),
    (
        2,
        'Riya Patel',
        'dummy_photo_data_2',
        '8765432109'
    ),
    (
        3,
        'Vikram Mehta',
        'dummy_photo_data_3',
        '7654321098'
    ),
    (
        4,
        'Sonal Verma',
        'dummy_photo_data_4',
        '9988776655'
    ),
    (
        5,
        'Rahul Das',
        'dummy_photo_data_5',
        '8877665544'
    );

-- Insert student passwords
INSERT INTO
    student_password (Roll_number, password)
VALUES
    (1, 'amit123'),
    (2, 'riya456'),
    (3, 'vikram789'),
    (4, 'sonal999'),
    (5, 'rahul777');

-- Insert examiners
INSERT INTO
    examiners (name, Phone_no)
VALUES
    ('Dr. Sinha', '9988776655'),
    ('Prof. Gupta', '8877665544'),
    ('Dr. Bose', '7788991122');

-- Insert examiner passwords
INSERT INTO
    examiner_password (EID, password)
VALUES
    (1, 'sinha123'),
    (2, 'gupta456'),
    (3, 'bose999');

-- Insert exams
INSERT INTO
    exam (name, fees)
VALUES
    ('Mathematics', 500),
    ('Physics', 600),
    ('Chemistry', 700);

-- Link examiners with exams
INSERT INTO
    administered_by (EID, Exam_ID)
VALUES
    (1, 1),
    (2, 2),
    (3, 3);

-- Insert exam slots
INSERT INTO
    slot (start_time, duration)
VALUES
    ('2025-02-15 10:00:00', 120),
    ('2025-02-16 14:00:00', 90),
    ('2025-02-17 09:30:00', 150);

-- Link exams to slots
INSERT INTO
    available_on_slot (slot_ID, Exam_ID)
VALUES
    (1, 1),
    (2, 2),
    (3, 3);

-- Insert bookings (students taking exams)
INSERT INTO
    takes_exam (
        Roll_number,
        Exam_ID,
        transaction_ID,
        end_time,
        slot_ID
    )
VALUES
    (1, 1, 'TXN12345', '2025-02-15 12:00:00', 1),
    (2, 2, 'TXN67890', '2025-02-16 15:30:00', 2),
    (3, 3, 'TXN99999', '2025-02-17 12:00:00', 3),
    (4, 1, 'TXN56789', '2025-02-15 12:00:00', 1),
    (5, 2, 'TXN34567', '2025-02-16 15:30:00', 2);

-- Insert questions
INSERT INTO
    questions (
        question,
        difficulty,
        option1,
        option2,
        option3,
        option4,
        correct_option
    )
VALUES
    ('What is 2+2?', 1, '1', '2', '3', '4', 4),
    (
        'What is Newton’s second law?',
        2,
        'F=ma',
        'E=mc^2',
        'PV=nRT',
        'W=Fd',
        1
    ),
    (
        'What is the chemical formula of water?',
        1,
        'H2O',
        'CO2',
        'O2',
        'NaCl',
        1
    ),
    ('Solve: 5x = 25', 1, '2', '3', '5', '10', 3),
    (
        'What is the speed of light?',
        3,
        '299792458 m/s',
        '150000000 m/s',
        '3x10^8 m/s',
        'None',
        3
    );

-- Link questions to examiners
INSERT INTO
    uploaded_by (QID, EID)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 1),
    (5, 2);

-- Link questions to exams
INSERT INTO
    in_exam (QID, Exam_ID)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 1),
    (5, 2);

-- Insert exam results (students answering questions)
INSERT INTO
    exam_results (booking_ID, QID, selected_option, is_correct)
VALUES
    (1, 1, 4, TRUE), -- Amit answered Q1 correctly
    (1, 4, 3, TRUE), -- Amit answered Q4 correctly
    (2, 2, 3, FALSE), -- Riya answered Q2 incorrectly
    (2, 5, 3, TRUE), -- Riya answered Q5 correctly
    (3, 3, 1, TRUE), -- Vikram answered Q3 correctly
    (4, 1, 3, FALSE), -- Sonal answered Q1 incorrectly
    (4, 4, 2, FALSE), -- Sonal answered Q4 incorrectly
    (5, 2, 1, TRUE), -- Rahul answered Q2 correctly
    (5, 5, 2, FALSE);

-- Rahul answered Q5 incorrectly
-- Insert feedback from examiners
INSERT INTO
    feedback (booking_ID, QID, EID, feedback_text)
VALUES
    (1, 1, 1, 'Good job! Correct answer.'),
    (1, 4, 1, 'Well done! You solved it correctly.'),
    (2, 2, 2, 'Needs improvement. Incorrect answer.'),
    (2, 5, 2, 'Correct, but try to be more precise.'),
    (3, 3, 3, 'Excellent, correct answer.'),
    (4, 1, 1, 'Revise the basics. You got it wrong.'),
    (4, 4, 1, 'Try again. This needs more practice.'),
    (5, 2, 2, 'Correct answer! Keep it up.'),
    (5, 5, 2, 'Incorrect. Be careful next time.');