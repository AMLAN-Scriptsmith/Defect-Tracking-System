# Defect Tracking System (DTS)

A JSP + JDBC + MySQL based web application to record, track, assign, and resolve software defects.

## Modules Implemented

1. Authentication and role-based access
2. Test Engineer can register defects
3. Project Manager can assign defects to developers
4. Developer can update status to FIXED / PENDING / RE-OPEN
5. Admin can delete employee accounts (non-admin)
6. Search defects by ID or status
7. Project Manager can view status report

## Roles

- ADMIN
- TEST_ENGINEER
- DEVELOPER
- PROJECT_MANAGER

## Defect Status Flow

- NEW
- ASSIGNED
- FIXED
- PENDING
- RE-OPEN

## Tech Stack

- HTML
- CSS
- JSP / Servlet
- JDBC
- MySQL Workbench / MySQL Server
- Maven

## Project Structure

- `src/main/java/com/dts` Java source code
- `src/main/webapp` JSP and static files
- `database/mysql-schema.sql` DB script
- `src/main/resources/db.properties` DB connection config

## Setup Steps

0. Ensure Java 21 and Maven are installed and available on PATH.

1. Create schema objects in MySQL Workbench by running `database/mysql-schema.sql`.
2. Update DB values in `src/main/resources/db.properties`.
3. Build project:

```bash
mvn clean package
```

4. Deploy generated WAR (`target/defect-tracking-system.war`) to Tomcat 10+.
5. Open app URL:

```text
http://localhost:8080/defect-tracking-system/
```

## Sample Login Users

- admin@dts.com / admin123
- tester@dts.com / test123
- dev@dts.com / dev123
- pm@dts.com / pm123

## Notes

- Passwords are plain text for demo purposes only.
- Replace with hashing (BCrypt/Argon2) in production.
- Add validation and CSRF protection for production use.
