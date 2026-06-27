-- Create table students:
create table students(
student_id serial primary key,
first_name varchar(50) not null,
last_name varchar(50) not null,
enrollment_date date default current_date
);

-- Create table courses:
create table courses(
course_id serial primary key,
course_name varchar(100) not null,
credits int not null
);

-- Create table enrollments:
create table enrollments(
enrollment_id serial primary key,
student_id int references students(student_id) on delete cascade,
course_id int references courses(course_id) on delete cascade,
semester varchar(20) not null,
score numeric(5,2) check(score>=0 and score<=100)
);

-- Now inserting the values in the tables:
-- Insert Courses
INSERT INTO courses (course_name, credits) VALUES 
('Mathematics 101', 4),
('Introduction to Computer Science', 4),
('World History', 3),
('English Literature', 3);

-- Insert Students
INSERT INTO students (first_name, last_name, enrollment_date) VALUES 
('Alice', 'Smith', '2025-09-01'),
('Bob', 'Johnson', '2025-09-01'),
('Charlie', 'Brown', '2025-09-01'),
('Diana', 'Prince', '2025-09-01'),
('Evan', 'Wright', '2025-09-01');

-- Insert Enrollments with Scores
INSERT INTO enrollments (student_id, course_id, semester, score) VALUES 
(1, 1, 'Fall 2025', 88.50), (1, 2, 'Fall 2025', 92.00), (1, 3, 'Fall 2025', 79.00),
(2, 1, 'Fall 2025', 45.00), (2, 2, 'Fall 2025', 61.00), (2, 4, 'Fall 2025', 55.00),
(3, 1, 'Fall 2025', 95.00), (3, 3, 'Fall 2025', 89.00), (3, 4, 'Fall 2025', 91.50),
(4, 2, 'Fall 2025', 72.00), (4, 3, 'Fall 2025', 48.00), (4, 4, 'Fall 2025', 85.00),
(5, 1, 'Fall 2025', 64.00), (5, 2, 'Fall 2025', 35.00), (5, 4, 'Fall 2025', 70.00);

-- Displaying the tables:
select * from students;
select * from courses;
select * from enrollments;

-- performing some questions:
-- Q1. High-Level Overview (Average Scores & Total Students):
select
count(student_id) As total_students,
count(course_id) As total_courses,
round(avg(score),2) As institutional_average
from enrollments;

-- Q2. Course-by-Course Performance Breakdown:
-- Perfect for building bar charts or tables to see which subjects students struggle with the most.
select c.course_name,
count(e.student_id) As student_enrolled,
round(avg(e.score),2) As average_score,
max(e.score) As highest_score,
min(e.score) As lowest_score
from courses c
left join enrollments e on c.course_id = e.course_id
group by c.course_id,c.course_name
order by average_score desc;

-- Q3. Pass/Fail Statistics (Assuming Pass >= 60):
select
c.course_name,
count(e.enrollment_id) As total_graded_items,
Sum(Case when e.score >= 60.00 then 1 else 0 end) As total_passes,
Sum(Case when e.score < 60.00 then 1 else 0 end) As total_fails,
Round((Sum(Case when e.score >= 60.00 then 1 else 0 end)::Numeric / count(e.enrollment_id)) * 100,
2 ) As pass_rate_percentage
from courses c 
join enrollments e on c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
ORDER BY pass_rate_percentage DESC;

-- Q4. Top Performers (Leaderboard):
WITH student_ranks AS (
    SELECT 
        s.student_id,
        CONCAT(s.first_name, ' ', s.last_name) AS student_name,
        ROUND(AVG(e.score), 2) AS overall_average,
        DENSE_RANK() OVER (ORDER BY AVG(e.score) DESC) as academic_rank
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    GROUP BY s.student_id, s.first_name, s.last_name
)
SELECT academic_rank, student_name, overall_average
FROM student_ranks
WHERE academic_rank <= 3; -- Filters for Top 3 performers
