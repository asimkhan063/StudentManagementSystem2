-- Create Students Table
CREATE TABLE students (
                          id BIGINT AUTO_INCREMENT PRIMARY KEY,
                          name VARCHAR(255) NOT NULL,
                          age INT NOT NULL,
                          grade VARCHAR(10),
                          email VARCHAR(255) UNIQUE,
                          admission_date DATE DEFAULT CURRENT_DATE
);

-- Insert Sample Data into Students Table
INSERT INTO students (name, age, grade, email) VALUES
                                                   ('John Doe', 15, '10th', 'john.doe@example.com'),
                                                   ('Jane Smith', 14, '9th', 'jane.smith@example.com'),
                                                   ('Alice Johnson', 16, '11th', 'alice.johnson@example.com');

-- Create Teachers Table
CREATE TABLE teachers (
                          id BIGINT AUTO_INCREMENT PRIMARY KEY,
                          name VARCHAR(255) NOT NULL,
                          subject VARCHAR(50),
                          email VARCHAR(255) UNIQUE,
                          hire_date DATE DEFAULT CURRENT_DATE
);

-- Insert Sample Data into Teachers Table
INSERT INTO teachers (name, subject, email) VALUES
                                                ('Mr. Brown', 'Mathematics', 'mr.brown@example.com'),
                                                ('Ms. Green', 'Science', 'ms.green@example.com'),
                                                ('Mrs. Blue', 'English', 'mrs.blue@example.com');

-- Create Attendance Table
CREATE TABLE attendance (
                            id BIGINT AUTO_INCREMENT PRIMARY KEY,
                            student_id BIGINT NOT NULL,
                            date DATE NOT NULL,
                            status ENUM('Present', 'Absent') DEFAULT 'Absent',
                            FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

-- Insert Sample Data into Attendance Table
INSERT INTO attendance (student_id, date, status) VALUES
                                                      (1, '2025-01-05', 'Present'),
                                                      (2, '2025-01-05', 'Absent'),
                                                      (3, '2025-01-05', 'Present');

-- Create Assignments Table
CREATE TABLE assignments (
                             id BIGINT AUTO_INCREMENT PRIMARY KEY,
                             teacher_id BIGINT NOT NULL,
                             title VARCHAR(255),
                             description TEXT,
                             due_date DATE,
                             FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE CASCADE
);

-- Insert Sample Data into Assignments Table
INSERT INTO assignments (teacher_id, title, description, due_date) VALUES
                                                                       (1, 'Algebra Homework', 'Complete the algebra worksheet', '2025-01-10'),
                                                                       (2, 'Science Experiment', 'Prepare for the volcano experiment', '2025-01-12'),
                                                                       (3, 'Essay Writing', 'Write an essay on your favorite book', '2025-01-15');