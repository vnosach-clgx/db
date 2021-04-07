ALTER TABLE student
    ADD PRIMARY KEY (id),
    ALTER COLUMN name SET NOT NULL,
    ALTER COLUMN surname SET NOT NULL,
    ALTER COLUMN dob SET NOT NULL,
    ALTER COLUMN created_datetime SET NOT NULL;

ALTER TABLE phone
    ADD PRIMARY KEY (id),
    ADD CONSTRAINT student_fk
        FOREIGN KEY (student_id)
            REFERENCES student (id) ON DELETE CASCADE,
    ALTER COLUMN number SET NOT NULL;

ALTER TABLE subject
    ADD PRIMARY KEY (id),
    ALTER COLUMN name SET NOT NULL,
    ALTER COLUMN tutor SET NOT NULL;

ALTER TABLE exam_result
    ADD PRIMARY KEY (id),
    ADD CONSTRAINT student_fk
        FOREIGN KEY (student_id)
            REFERENCES student (id) ON DELETE CASCADE,
    ADD CONSTRAINT subject_fk
        FOREIGN KEY (subject_id)
            REFERENCES subject (id) ON DELETE CASCADE,
    ALTER COLUMN mark SET NOT NULL;

