CREATE TABLE teachers (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    subject VARCHAR(50),
    experience INT,
    salary DECIMAL(10, 2)
);

INSERT INTO teachers (id, name, subject, experience, salary) VALUES
(1, 'Ashly', 'Maths', 5, 45000),
(2, 'Jibin', 'Science', 12, 50000),
(3, 'Goshal', 'English', 3, 40000),
(4, 'Richu', 'History', 8, 48000),
(5, 'Mebin', 'Physics', 10, 53000),
(6, 'Jonhy', 'Biology', 6, 47000),
(7, 'Gopika', 'Chemistry', 2, 38000),
(8, 'George', 'Geography', 15, 60000);

select*from teachers;

DELIMITER //

CREATE TRIGGER before_insert_teacher
BEFORE INSERT ON teachers
FOR EACH ROW
BEGIN
    IF NEW.salary < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary cannot be negative';
    END IF;
END //

DELIMITER ;

INSERT INTO teachers (id, name, subject, experience, salary)
VALUES (9, 'Mariya', 'Economics', 7, -10000);

CREATE TABLE teacher_log (
    teacher_id INT,
    action VARCHAR(50),
    log_timestamp DATETIME
);
DELIMITER //

CREATE TRIGGER after_insert_teacher
AFTER INSERT ON teachers
FOR EACH ROW
BEGIN
    INSERT INTO teacher_log (teacher_id, action, log_timestamp)
    VALUES (NEW.id, 'INSERT', NOW());
END //

DELIMITER ;

INSERT INTO teachers (id, name, subject, experience, salary)
VALUES (9, 'Mariya', 'Economics', 7, 55000);

SELECT * FROM teacher_log;


DELIMITER //

CREATE TRIGGER before_delete_teacher
BEFORE DELETE ON teachers
FOR EACH ROW
BEGIN
    IF OLD.experience > 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete ones with more than 10 years exp';
    END IF;
END //

DELIMITER ;

DELETE FROM teachers WHERE id = 8;

DELIMITER //

CREATE TRIGGER after_delete_teacher
AFTER DELETE ON teachers
FOR EACH ROW
BEGIN
    INSERT INTO teacher_log (teacher_id, action, log_timestamp)
    VALUES (OLD.id, 'DELETE', NOW());
END //

DELIMITER ;


DELETE FROM teachers WHERE id = 4;

SELECT * FROM teacher_log;

