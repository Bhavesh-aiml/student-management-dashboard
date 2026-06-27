# Student Management Dashboard (PostgreSQL)

A consolidated database script designed to build, populate, and analyze a student management system. This project sets up a structured relational PostgreSQL database, seeds it with mock data, and executes core analytical queries to power a student performance dashboard.

## 📂 Repository Contents
* `student_dashboard.sql` — The complete, all-in-one script containing database schema creation, mock data, and KPI analytics queries.

## 📊 Analytics Covered
1.  **High-Level KPI Summary:** Overall student count and institutional grade average.
2.  **Course Performance:** Grade breakdowns (highest, lowest, and average scores) per course.
3.  **Pass/Fail Analysis:** Dynamic pass rate percentages per subject calculated using precise decimal casting (`::NUMERIC`).
4.  **Student Leaderboard:** Top 3 academic performers ranked cleanly using the `DENSE_RANK()` window function.

---

## 🛠️ Deployment Instructions

### Prerequisites
* PostgreSQL installed locally or an account on a cloud provider (e.g., Supabase, Neon).
* A database GUI client (like pgAdmin or DBeaver) or the `psql` command line tool.

### How to Run the Project
1. Create a fresh database instance:
   ```sql
   CREATE DATABASE student_dashboard;
