-- MySQL Workbench schema for Defect Tracking System

CREATE DATABASE IF NOT EXISTS dts_db;
USE dts_db;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS defects;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE users (
    id INT PRIMARY KEY,
    full_name VARCHAR(120) NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    password VARCHAR(120) NOT NULL,
    role VARCHAR(30) NOT NULL,
    CHECK (role IN ('ADMIN', 'TEST_ENGINEER', 'DEVELOPER', 'PROJECT_MANAGER'))
);

CREATE TABLE defects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    severity VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_by INT NOT NULL,
    assigned_to INT NULL,
    resolution_notes TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CHECK (severity IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    CHECK (status IN ('NEW', 'ASSIGNED', 'FIXED', 'PENDING', 'RE-OPEN')),
    CONSTRAINT fk_defect_created_by FOREIGN KEY (created_by) REFERENCES users(id),
    CONSTRAINT fk_defect_assigned_to FOREIGN KEY (assigned_to) REFERENCES users(id)
);

ALTER TABLE defects AUTO_INCREMENT = 1001;

INSERT INTO users (id, full_name, email, password, role) VALUES (1, 'System Admin', 'admin@dts.com', 'admin123', 'ADMIN');
INSERT INTO users (id, full_name, email, password, role) VALUES (2, 'QA Tester', 'tester@dts.com', 'test123', 'TEST_ENGINEER');
INSERT INTO users (id, full_name, email, password, role) VALUES (3, 'Software Developer', 'dev@dts.com', 'dev123', 'DEVELOPER');
INSERT INTO users (id, full_name, email, password, role) VALUES (4, 'Project Manager', 'pm@dts.com', 'pm123', 'PROJECT_MANAGER');

INSERT INTO defects (title, description, severity, status, created_by, assigned_to, resolution_notes)
VALUES ('Login button not working', 'Clicking login button does nothing on Chrome 123.', 'HIGH', 'NEW', 2, NULL, NULL);
