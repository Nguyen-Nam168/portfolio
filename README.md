# Data Analyst

#### Technical Skills: Python, SQL

## Education
- Foreign Trade University

## 📊 SQL Queries for Piano Learning App Analysis

These SQL queries were designed to extract valuable product insights from a simulated dataset of user behavior in a piano learning app.

---

### 🎯 1. Premium vs Free Users: Engagement & Learning

```sql
SELECT Subscription_Status,
       ROUND(AVG(Session_Length_Minutes), 2) AS avg_session_time,
       ROUND(AVG(Lesson_Completed), 2) AS avg_lessons_completed
FROM oreca.piano_app_user_sessions
GROUP BY Subscription_Status;


