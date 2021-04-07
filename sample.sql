CREATE INDEX name_index ON student USING btree (name, surname);
CREATE INDEX name_index ON student USING hash (name, surname);
CREATE INDEX name_index ON student USING gin (name, surname);
CREATE INDEX name_index ON student USING gist (name, surname);

INSERT INTO student (name, surname, dob, primary_skill, created_datetime)
SELECT left(md5(i::text), 10),
       md5(random()::text),
       date((current_date - '15 years'::interval) +
            trunc(random() * 365) * '1 day'::interval +
            trunc(random() * 14) * '1 year'::interval),
       left(md5(random()::text), 4),
       now()
FROM generate_series(1, 100000) s(i);

INSERT INTO student (name, surname, dob, primary_skill, created_datetime)
SELECT left(md5(i::text), 10),
       md5(random()::text),
       date((current_date - '15 years'::interval) +
            trunc(random() * 365) * '1 day'::interval +
            trunc(random() * 14) * '1 year'::interval),
       left(md5(random()::text), 4),
       now()
FROM generate_series(1, 1000) s(i);

INSERT INTO student (name, surname, dob, primary_skill, created_datetime)
SELECT left(md5(i::text), 10),
       md5(random()::text),
       date((current_date - '15 years'::interval) +
            trunc(random() * 365) * '1 day'::interval +
            trunc(random() * 14) * '1 year'::interval),
       left(md5(random()::text), 4),
       now()
FROM generate_series(1, 1000000) s(i);
