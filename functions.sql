-- 5. Add trigger that will update column updated_datetime to current date in case of updating any of student.
CREATE OR REPLACE FUNCTION student_update_datetime() RETURNS TRIGGER AS
$after_update_token$
BEGIN
    NEW.updated_datetime = NOW();
    RETURN NEW;
END;
$after_update_token$ LANGUAGE plpgsql;

CREATE TRIGGER student_update
    BEFORE UPDATE
    ON student
    FOR EACH ROW
EXECUTE PROCEDURE student_update_datetime();

-- 6. Add validation on DB level that will check username on special characters (reject student name with next characters '@', '#', '$')
ALTER TABLE student
    DROP CONSTRAINT IF EXISTS spec_symbol_check,
    ADD CONSTRAINT spec_symbol_check CHECK (name !~ '(\#|\$|\%)');

-- 7. Create snapshot that will contain next data: student name, student surname, subject name, mark (snapshot means that in case of changing some data in source table – your snapshot should not change).
CREATE DATABASE cdp_program_snapshot WITH TEMPLATE cdp_program;

-- 8. Create function that will return average mark for input user.
DROP FUNCTION IF EXISTS average_student_marks;
CREATE OR REPLACE FUNCTION average_student_marks(student_name varchar(255))
    RETURNS TABLE
            (
                id      int,
                name    varchar(255),
                surname varchar(255),
                mark    numeric
            )
    language plpgsql
as
$$
begin
    return query
        SELECT s.id, s.name, s.surname, avg(er.mark)
        FROM student s
                 LEFT JOIN exam_result er ON s.id = er.student_id
        WHERE s.name like '%' || student_name || '%'
        GROUP BY s.id, s.name, s.surname;
end;
$$;

--  9. Create function that will return avarage mark for input subject name.
DROP FUNCTION IF EXISTS average_subject_marks;
CREATE OR REPLACE FUNCTION average_subject_marks(subject_name varchar(255))
    RETURNS TABLE
            (
                id   int,
                name varchar(255),
                mark numeric
            )
    language plpgsql
as
$$
begin
    return query
        SELECT s.id, s.name, avg(er.mark)
        FROM subject s
                 LEFT JOIN exam_result er ON s.id = er.subject_id
        WHERE s.name like '%' || subject_name || '%'
        GROUP BY s.id, s.name;
end;
$$;

-- 10. Create function that will return student at "red zone" (red zone means at least 2 marks <=3).
DROP FUNCTION IF EXISTS student_red_zone;
CREATE OR REPLACE FUNCTION student_red_zone()
    RETURNS TABLE
            (
                id            int,
                name          varchar(255),
                surname       varchar(255),
                dob           date,
                primary_skill varchar(255)
            )
    language plpgsql
as
$$
begin
    return query
        SELECT s.id, s.name, s.surname, s.dob, s.primary_skill
        FROM student s
                 LEFT JOIN (SELECT count(*) red_cnt, er.student_id
                            FROM exam_result er
                            WHERE mark <= 3
                            GROUP BY student_id
        ) er
                           ON s.id = er.student_id
        WHERE red_cnt >= 2;
end;
$$;
