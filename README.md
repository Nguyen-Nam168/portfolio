# Data Analyst

#### Technical Skills: Python, SQL

## Education
- Foreign Trade University

SELECT Subscription_Status,
       ROUND(AVG(Session_Length_Minutes), 2) AS avg_session_time,
       ROUND(AVG(Lesson_Completed), 2) AS avg_lessons_completed
FROM piano_app_user_sessions
GROUP BY Subscription_Status;

