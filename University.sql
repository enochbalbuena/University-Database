-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema University
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema University
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `University` DEFAULT CHARACTER SET utf8 ;
USE `University` ;

-- -----------------------------------------------------
-- Table `University`.`College`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `University`.`College` (
  `college_id` INT NOT NULL AUTO_INCREMENT,
  `college_name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`college_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `University`.`Department`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `University`.`Department` (
  `department_id` INT NOT NULL AUTO_INCREMENT,
  `department_name` VARCHAR(100) NOT NULL,
  `department_code` VARCHAR(20) NOT NULL,
  `college_id` INT NOT NULL,
  PRIMARY KEY (`department_id`),
  INDEX `fk_Department_College_idx` (`college_id` ASC) VISIBLE,
  CONSTRAINT `fk_Department_College`
    FOREIGN KEY (`college_id`)
    REFERENCES `University`.`College` (`college_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `University`.`Course`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `University`.`Course` (
  `course_id` INT NOT NULL AUTO_INCREMENT,
  `course_num` VARCHAR(20) NOT NULL,
  `course_title` VARCHAR(100) NOT NULL,
  `credits` INT NOT NULL,
  `department_id` INT NOT NULL,
  PRIMARY KEY (`course_id`),
  INDEX `fk_Course_Department1_idx` (`department_id` ASC) VISIBLE,
  CONSTRAINT `fk_Course_Department1`
    FOREIGN KEY (`department_id`)
    REFERENCES `University`.`Department` (`department_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `University`.`Faculty`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `University`.`Faculty` (
  `faculty_id` INT NOT NULL AUTO_INCREMENT,
  `faculty_fname` VARCHAR(100) NOT NULL,
  `faculty_lname` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`faculty_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `University`.`Section`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `University`.`Section` (
  `section_id` INT NOT NULL AUTO_INCREMENT,
  `year` YEAR(4) NOT NULL,
  `term` VARCHAR(20) NOT NULL,
  `section_num` INT NOT NULL,
  `capacity` INT NOT NULL,
  `faculty_id` INT NOT NULL,
  `course_id` INT NOT NULL,
  PRIMARY KEY (`section_id`),
  INDEX `fk_Section_Faculty1_idx` (`faculty_id` ASC) VISIBLE,
  INDEX `fk_Section_Course1_idx` (`course_id` ASC) VISIBLE,
  CONSTRAINT `fk_Section_Faculty1`
    FOREIGN KEY (`faculty_id`)
    REFERENCES `University`.`Faculty` (`faculty_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Section_Course1`
    FOREIGN KEY (`course_id`)
    REFERENCES `University`.`Course` (`course_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `University`.`Student`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `University`.`Student` (
  `student_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(100) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `gender` CHAR(1) NOT NULL,
  `city` VARCHAR(100) NOT NULL,
  `state` VARCHAR(100) NOT NULL,
  `birthdate` DATE NOT NULL,
  PRIMARY KEY (`student_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `University`.`Enrollment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `University`.`Enrollment` (
  `section_id` INT NOT NULL,
  `student_id` INT NOT NULL,
  PRIMARY KEY (`section_id`, `student_id`),
  INDEX `fk_Section_has_Student_Student1_idx` (`student_id` ASC) VISIBLE,
  INDEX `fk_Section_has_Student_Section1_idx` (`section_id` ASC) VISIBLE,
  CONSTRAINT `fk_Section_has_Student_Section1`
    FOREIGN KEY (`section_id`)
    REFERENCES `University`.`Section` (`section_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Section_has_Student_Student1`
    FOREIGN KEY (`student_id`)
    REFERENCES `University`.`Student` (`student_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

USE University;

INSERT INTO College (college_name) VALUES
('College of Physical Science and Engineering'),
('College of Business and Communication'),
('College of Language and Letters');

INSERT INTO Department (department_name, department_code, college_id) VALUES
('Computer Information Technology', 'ITM', 1),
('Economics', 'ECON', 2),
('Humanities and Philosophy', 'HUM', 3);

INSERT INTO Course (course_num, course_title, credits, department_id) VALUES
('111', 'Intro to Databases', 3, 1),
('388', 'Econometrics', 4, 2),
('150', 'Micro Economics', 3, 2),
('376', 'Classical Heritage', 2, 3);

INSERT INTO Faculty (faculty_fname, faculty_lname) VALUES
('Marty', 'Morring'),
('Nate', 'Norris'),
('Ben', 'Barrus'),
('John', 'Jensen'),
('Bill', 'Barney');

INSERT INTO Section (year, term, course_id, section_num, faculty_id, capacity) VALUES
(2019, 'Fall', (SELECT course_id FROM Course WHERE course_num = '111'), 1, (SELECT faculty_id FROM Faculty WHERE faculty_fname = 'Marty' AND faculty_lname = 'Morring'), 30),
(2019, 'Fall', (SELECT course_id FROM Course WHERE course_num = '150'), 1, (SELECT faculty_id FROM Faculty WHERE faculty_fname = 'Nate' AND faculty_lname = 'Norris'), 50),
(2019, 'Fall', (SELECT course_id FROM Course WHERE course_num = '150'), 2, (SELECT faculty_id FROM Faculty WHERE faculty_fname = 'Nate' AND faculty_lname = 'Norris'), 50),
(2019, 'Fall', (SELECT course_id FROM Course WHERE course_num = '388'), 1, (SELECT faculty_id FROM Faculty WHERE faculty_fname = 'Ben' AND faculty_lname = 'Barrus'), 35),
(2019, 'Fall', (SELECT course_id FROM Course WHERE course_num = '376'), 1, (SELECT faculty_id FROM Faculty WHERE faculty_fname = 'John' AND faculty_lname = 'Jensen'), 30),
(2018, 'Winter', (SELECT course_id FROM Course WHERE course_num = '111'), 2, (SELECT faculty_id FROM Faculty WHERE faculty_fname = 'Marty' AND faculty_lname = 'Morring'), 30),
(2018, 'Winter', (SELECT course_id FROM Course WHERE course_num = '111'), 3, (SELECT faculty_id FROM Faculty WHERE faculty_fname = 'Bill' AND faculty_lname = 'Barney'), 35),
(2018, 'Winter', (SELECT course_id FROM Course WHERE course_num = '150'), 1, (SELECT faculty_id FROM Faculty WHERE faculty_fname = 'Nate' AND faculty_lname = 'Norris'), 50),
(2018, 'Winter', (SELECT course_id FROM Course WHERE course_num = '150'), 2, (SELECT faculty_id FROM Faculty WHERE faculty_fname = 'Nate' AND faculty_lname = 'Norris'), 50),
(2018, 'Winter', (SELECT course_id FROM Course WHERE course_num = '376'), 1, (SELECT faculty_id FROM Faculty WHERE faculty_fname = 'John' AND faculty_lname = 'Jensen'), 30);

INSERT INTO Student (first_name, last_name, gender, city, state, birthdate) VALUES
('Paul', 'Miller', 'M', 'Dallas', 'TX', '1996-02-22'),
('Katie', 'Smith', 'F', 'Provo', 'UT', '1995-07-22'),
('Kelly', 'Jones', 'F', 'Provo', 'UT', '1998-06-22'),
('Devon', 'Merrill', 'M', 'Mesa', 'AZ', '2000-07-22'),
('Mandy', 'Murdock', 'F', 'Topeka', 'KS', '1996-11-22'),
('Alece', 'Adams', 'F', 'Rigby', 'ID', '1997-05-22'),
('Bryce', 'Carlson', 'M', 'Bozeman', 'MT', '1997-11-22'),
('Preston', 'Larsen', 'M', 'Decatur', 'TN', '1996-09-22'),
('Julia', 'Madsen', 'F', 'Rexburg', 'ID', '1998-09-22'),
('Susan', 'Sorensen', 'F', 'Mesa', 'AZ', '1998-08-09');

INSERT INTO Enrollment (student_id, section_id) VALUES
((SELECT student_id FROM Student WHERE first_name = 'Alece' AND last_name = 'Adams'), (SELECT section_id FROM Section WHERE course_id = (SELECT course_id FROM Course WHERE course_num = '111') AND term = 'Winter' AND year = 2018 AND section_num = 3)),
((SELECT student_id FROM Student WHERE first_name = 'Bryce' AND last_name = 'Carlson'), (SELECT section_id FROM Section WHERE course_id = (SELECT course_id FROM Course WHERE course_num = '111') AND term = 'Winter' AND year = 2018 AND section_num = 2)),
((SELECT student_id FROM Student WHERE first_name = 'Bryce' AND last_name = 'Carlson'), (SELECT section_id FROM Section WHERE course_id = (SELECT course_id FROM Course WHERE course_num = '150') AND term = 'Winter' AND year = 2018 AND section_num = 1)),
((SELECT student_id FROM Student WHERE first_name = 'Bryce' AND last_name = 'Carlson'), (SELECT section_id FROM Section WHERE course_id = (SELECT course_id FROM Course WHERE course_num = '376') AND term = 'Winter' AND year = 2018 AND section_num = 1)),
((SELECT student_id FROM Student WHERE first_name = 'Devon' AND last_name = 'Merrill'), (SELECT section_id FROM Section WHERE course_id = (SELECT course_id FROM Course WHERE course_num = '376') AND term = 'Fall' AND year = 2019 AND section_num = 1)),
((SELECT student_id FROM Student WHERE first_name = 'Julia' AND last_name = 'Madsen'), (SELECT section_id FROM Section WHERE course_id = (SELECT course_id FROM Course WHERE course_num = '150') AND term = 'Winter' AND year = 2018 AND section_num = 2)),
((SELECT student_id FROM Student WHERE first_name = 'Katie' AND last_name = 'Smith'), (SELECT section_id FROM Section WHERE course_id = (SELECT course_id FROM Course WHERE course_num = '388') AND term = 'Fall' AND year = 2019 AND section_num = 1)),
((SELECT student_id FROM Student WHERE first_name = 'Kelly' AND last_name = 'Jones'), (SELECT section_id FROM Section WHERE course_id = (SELECT course_id FROM Course WHERE course_num = '388') AND term = 'Fall' AND year = 2019 AND section_num = 1)),
((SELECT student_id FROM Student WHERE first_name = 'Mandy' AND last_name = 'Murdock'), (SELECT section_id FROM Section WHERE course_id = (SELECT course_id FROM Course WHERE course_num = '388') AND term = 'Fall' AND year = 2019 AND section_num = 1)),
((SELECT student_id FROM Student WHERE first_name = 'Mandy' AND last_name = 'Murdock'), (SELECT section_id FROM Section WHERE course_id = (SELECT course_id FROM Course WHERE course_num = '376') AND term = 'Fall' AND year = 2019 AND section_num = 1)),
((SELECT student_id FROM Student WHERE first_name = 'Paul' AND last_name = 'Miller'), (SELECT section_id FROM Section WHERE course_id = (SELECT course_id FROM Course WHERE course_num = '111') AND term = 'Fall' AND year = 2019 AND section_num = 1)),
((SELECT student_id FROM Student WHERE first_name = 'Paul' AND last_name = 'Miller'), (SELECT section_id FROM Section WHERE course_id = (SELECT course_id FROM Course WHERE course_num = '150') AND term = 'Fall' AND year = 2019 AND section_num = 2)),
((SELECT student_id FROM Student WHERE first_name = 'Preston' AND last_name = 'Larsen'), (SELECT section_id FROM Section WHERE course_id = (SELECT course_id FROM Course WHERE course_num = '150') AND term = 'Winter' AND year = 2018 AND section_num = 2)),
((SELECT student_id FROM Student WHERE first_name = 'Susan' AND last_name = 'Sorensen'), (SELECT section_id FROM Section WHERE course_id = (SELECT course_id FROM Course WHERE course_num = '111') AND term = 'Winter' AND year = 2018 AND section_num = 2));

-- 1. Students born in September
SELECT first_name AS fname, last_name AS lname, 
DATE_FORMAT(birthdate, '%M %d, %Y') AS 'Sept Birthdays'
FROM Student
WHERE MONTH(birthdate) = 9
ORDER BY last_name;

-- 2. Student's age in years and days as of Jan. 5, 2017
SELECT last_name AS lname, first_name AS fname, 
FLOOR(DATEDIFF('2017-01-05', birthdate) / 365) AS Years,
MOD(DATEDIFF('2017-01-05', birthdate), 365) AS Days,
CONCAT(FLOOR(DATEDIFF('2017-01-05', birthdate) / 365), ' - Yrs, ', 
MOD(DATEDIFF('2017-01-05', birthdate), 365), ' - Days') AS 'Years and Days'
FROM Student
ORDER BY Years DESC, Days DESC;

-- 3. Students taught by John Jensen
SELECT s.first_name AS fname, s.last_name AS lname
FROM Student s
JOIN Enrollment e ON s.student_id = e.student_id
JOIN Section sec ON e.section_id = sec.section_id
JOIN Faculty f ON sec.faculty_id = f.faculty_id
WHERE f.faculty_fname = 'John' AND f.faculty_lname = 'Jensen'
ORDER BY s.last_name;

-- 4. Instructors Bryce will have in Winter 2018
SELECT f.faculty_fname AS fname, f.faculty_lname AS lname
FROM Faculty f
JOIN Section sec ON f.faculty_id = sec.faculty_id
JOIN Enrollment e ON sec.section_id = e.section_id
JOIN Student s ON e.student_id = s.student_id
WHERE s.first_name = 'Bryce' AND s.last_name = 'Carlson' AND sec.term = 'Winter' AND sec.year = 2018
GROUP BY f.faculty_fname, f.faculty_lname
ORDER BY f.faculty_lname;

-- 5. Students that take Econometrics in Fall 2019
SELECT s.first_name AS fname, s.last_name AS lname
FROM Student s
JOIN Enrollment e ON s.student_id = e.student_id
JOIN Section sec ON e.section_id = sec.section_id
JOIN Course c ON sec.course_id = c.course_id
WHERE c.course_title = 'Econometrics' AND sec.term = 'Fall' AND sec.year = 2019
ORDER BY s.last_name;

-- 6. All of Bryce Carlson's courses for Winter 2018
SELECT d.department_code, c.course_num, c.course_title AS name
FROM Course c
JOIN Department d ON c.department_id = d.department_id
JOIN Section sec ON c.course_id = sec.course_id
JOIN Enrollment e ON sec.section_id = e.section_id
JOIN Student s ON e.student_id = s.student_id
WHERE s.first_name = 'Bryce' AND s.last_name = 'Carlson' AND sec.term = 'Winter' AND sec.year = 2018
ORDER BY c.course_title;

-- 7. The number of students enrolled for Fall 2019
SELECT sec.term, sec.year, COUNT(e.student_id) AS Enrollment
FROM Enrollment e
JOIN Section sec ON e.section_id = sec.section_id
WHERE sec.term = 'Fall' AND sec.year = 2019
GROUP BY sec.term, sec.year;

-- 8. The number of courses in each college
SELECT col.college_name AS Colleges, COUNT(c.course_id) AS Courses
FROM College col
JOIN Department d ON col.college_id = d.college_id
JOIN Course c ON d.department_id = c.department_id
GROUP BY col.college_name
ORDER BY col.college_name;

-- 9. Total number of students each professor can teach in Winter 2018
SELECT f.faculty_fname AS fname, f.faculty_lname AS lname, SUM(sec.capacity) AS TeachingCapacity
FROM Faculty f
JOIN Section sec ON f.faculty_id = sec.faculty_id
WHERE sec.term = 'Winter' AND sec.year = 2018
GROUP BY f.faculty_fname, f.faculty_lname
ORDER BY TeachingCapacity;

-- 10. Each student's total credit load for Fall 2019 (only students with credit load greater than 3)
SELECT s.last_name AS lname, s.first_name AS fname, SUM(c.credits) AS Credits
FROM Student s
JOIN Enrollment e ON s.student_id = e.student_id
JOIN Section sec ON e.section_id = sec.section_id
JOIN Course c ON sec.course_id = c.course_id
WHERE sec.term = 'Fall' AND sec.year = 2019
GROUP BY s.last_name, s.first_name
HAVING Credits > 3
ORDER BY Credits DESC;
