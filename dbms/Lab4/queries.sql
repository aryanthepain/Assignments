-- b
INSERT INTO
    students (name, photo, Phone_no)
VALUES
    ('Aryan Sharma', test, '9876543210');

-- ====================================
-- c
-- insert slot
INSERT INTO
    slot (start_time, duration)
VALUES
    ('2025-02-15 10:00:00', 90);

-- insert exam slot
INSERT INTO
    available_on_slot (slot_ID, Exam_ID)
VALUES
    (2, 2);

-- insert examiner/administrator
INSERT INTO
    examiners (name, Phone_no)
VALUES
    ('Dr. Neha Verma', 9988776655);

-- insert exam
INSERT INTO
    exam (name, fees)
VALUES
    ('Computer Science', 800);

INSERT INTO
    administered_by (EID, Exam_ID)
VALUES
    (1, 2);

-- insert question
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
    (
        'What is the time complexity of binary search?',
        2,
        'O(log n)',
        'O(n)',
        'O(n^2)',
        'O(1)',
        1
    );

-- insert question in exam
INSERT INTO
    in_exam (QID, Exam_ID)
VALUES
    (1, 2);

-- ====================================
-- d
-- Insert exam booking by a student
INSERT INTO
    takes_exam (Roll_number, Exam_ID)
VALUES
    (123456, 2);

-- Update fees payment for the student booking
UPDATE takes_exam
SET
    transaction_ID = 'txntest'
WHERE
    booking_ID = [1];

-- ====================================
-- e
-- Update slot
UPDATE takes_exam
SET
    transaction_ID = 'txntest'
WHERE
    booking_ID = [1];

-- ====================================
-- g
-- Calculate the exam duration for a particular booking
SELECT
    SEC_TO_TIME (
        TIMESTAMPDIFF (
            SECOND,
            NOW (),
            DATE_ADD (start_time, INTERVAL duration MINUTE)
        )
    ) AS remaining_time
FROM
    slot
WHERE
    slot_ID = (
        SELECT
            slot_ID
        FROM
            takes_exam
        WHERE
            booking_ID = [5]
    );


-- ====================================
-- i
-- adaptive questioning
-- Update difficulty_counter based on correctness
UPDATE takes_exam
SET difficulty_counter = CASE
    WHEN is_correct = TRUE THEN difficulty_counter + (SELECT difficulty FROM questions WHERE question_ID = [question_ID])
    WHEN is_correct = FALSE THEN difficulty_counter - (SELECT difficulty FROM questions WHERE question_ID = [question_ID])
    ELSE difficulty_counter
END
WHERE booking_ID = [Booking_ID];

-- Select the next question based on the difficulty_counter
SELECT *
FROM questions
WHERE difficulty = 
    CASE
        WHEN difficulty_counter < 5 THEN 1  -- Easy
        WHEN difficulty_counter < 10 and difficulty_counter>4 THEN 1  -- Easy
        WHEN difficulty_counter > 15 THEN 3  -- Hard (max difficulty)
        ELSE difficulty_counter
    END
ORDER BY RAND()
LIMIT 1;

-- ====================================
-- j
SELECT
    booking_ID,
    COUNT(*) AS total_questions,
    SUM(CASE WHEN is_correct THEN 1 ELSE 0 END) AS correct_answers,
    (SUM(CASE WHEN is_correct THEN 1 ELSE 0 END) / COUNT(*) * 100) AS score_percentage
FROM
    exam_results
WHERE
    booking_ID = [5]  
GROUP BY
    booking_ID;

-- feedback
SELECT
    r.booking_ID,
    r.QID,
    q.question,
    r.is_correct,
    f.feedback_text
FROM
    exam_results r
JOIN
    questions q ON r.QID = q.QID
LEFT JOIN
    feedback f ON r.booking_ID = f.booking_ID AND r.QID = f.QID
WHERE
    r.booking_ID = 5;

-- ====================================
-- k
-- according to difficulty
SELECT
    booking_ID,
    COUNT(CASE WHEN difficulty <= 2 AND is_correct THEN 1 ELSE NULL END) AS easy_strength,
    COUNT(CASE WHEN difficulty >= 3 AND is_correct THEN 1 ELSE NULL END) AS medium_strength,
    COUNT(CASE WHEN difficulty > 4 AND is_correct THEN 1 ELSE NULL END) AS hard_strength,
    COUNT(CASE WHEN difficulty <= 2 AND NOT is_correct THEN 1 ELSE NULL END) AS easy_weakness,
    COUNT(CASE WHEN difficulty >= 3 AND NOT is_correct THEN 1 ELSE NULL END) AS medium_weakness,
    COUNT(CASE WHEN difficulty > 4 AND NOT is_correct THEN 1 ELSE NULL END) AS hard_weakness
FROM
    exam_results er
JOIN
    questions q ON er.QID = q.QID
WHERE
    Exam_ID = [1]
GROUP BY
    booking_ID;

SELECT
    difficulty,
    SUM(CASE WHEN is_correct THEN 1 ELSE 0 END) AS correct_answers,
    SUM(CASE WHEN NOT is_correct THEN 1 ELSE 0 END) AS incorrect_answers,
    COUNT(DISTINCT booking_ID) AS total_students
FROM
    exam_results er
JOIN
    questions q ON er.QID = q.QID
WHERE
    Exam_ID = 1  -- Replace with your Exam ID
GROUP BY
    difficulty;

-- ====================================
-- l
-- percentile
SELECT
    booking_ID,
    percentage_score,
    rank,
    (rank - 1) * 100.0 / (total_students - 1) AS percentile
FROM
    (
        SELECT
            booking_ID,
            percentage_score,
            RANK() OVER (ORDER BY percentage_score DESC) AS rank
        FROM
            (
                SELECT
                    booking_ID,
                    SUM(CASE WHEN is_correct THEN 1 ELSE 0 END) AS correct_answers,
                    COUNT(*) AS total_questions,
                    (SUM(CASE WHEN is_correct THEN 1 ELSE 0 END) / COUNT(*) * 100) AS percentage_score
                FROM
                    exam_results
                WHERE
                    Exam_ID = [1]
                GROUP BY
                    booking_ID
            ) AS scores
    ) AS ranked_scores,
    (
        SELECT
            COUNT(DISTINCT booking_ID) AS total_students
        FROM
            exam_results
        WHERE
            Exam_ID = [1]
    ) AS total_count;

-- ====================================
-- m
-- time spent on each question
SELECT 
    er.booking_ID,
    er.QID,
    q.question,
    TIMESTAMPDIFF(SECOND, er.start_time, er.end_time) AS time_spent_seconds
FROM 
    exam_results er
JOIN 
    questions q ON er.QID = q.QID
WHERE 
    er.booking_ID = [1];  
