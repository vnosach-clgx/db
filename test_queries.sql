-- a. Find user by name (exact match)
SELECT *
FROM student
WHERE name = ?;

-- b. Find user by surname (partial match)
SELECT *
FROM student
WHERE surname like '%' + ? + '%';

-- c. Find user by phone number (partial match)
SELECT *
FROM student
         JOIN phone p on student.id = p.student_id
WHERE number like '%' + ? + '%';

-- d. Find user with marks by user surname (partial match)
SELECT *
FROM student
         JOIN exam_result er on student.id = er.student_id
WHERE name like '%' + ? + '%';
