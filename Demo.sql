-- Chọn tất cả dữ liệu trong dataset 
select * from piano_app_user_sessions; 

-- Tỉ lệ phần trăm người dùng ngừng sử dụng hoặc tương tác với ứng dụng (churned)
SELECT Subscription_Status,
       COUNT(*) AS total_users,
       SUM(CASE WHEN Churned = 1 THEN 1 ELSE 0 END) AS churned_users,
       ROUND(100.0 * SUM(CASE WHEN Churned = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_pct
FROM piano_app_user_sessions
GROUP BY Subscription_Status;

-- Xu hướng tương tác qua các tuần 
SELECT 
    DATE_SUB(Session_Date, INTERVAL WEEKDAY(Session_Date) DAY) AS week_start,
    ROUND(AVG(Session_Length_Minutes), 2) AS avg_session_time
FROM piano_app_user_sessions
GROUP BY week_start
ORDER BY week_start;

-- Top 3 các nước có Rating cao nhất (chỉ xét người dùng Premium)
SELECT Country,
       ROUND(AVG(Rating), 2) AS avg_rating
FROM piano_app_user_sessions
WHERE Subscription_Status = 'Premium'
GROUP BY Country
ORDER BY avg_rating DESC
LIMIT 3;

-- Các loại thiết bị và việc liệu có tương quan giữa việc tương tác với tính năng của app và lượng piano lesson được hoàn thành hay không?
SELECT Device_Type,
       Interacted_With_Feature,
       ROUND(AVG(Lesson_Completed), 2) AS avg_lessons_completed
FROM piano_app_user_sessions
GROUP BY Device_Type, Interacted_With_Feature;

-- Ai là những người dùng tiềm năng với tỉ lệ rời bỏ app thấp? 
SELECT User_ID, Country, Device_Type, Subscription_Status,
       ROUND(AVG(Session_Length_Minutes), 2) AS avg_time,
       SUM(Lesson_Completed) AS total_lessons
FROM piano_app_user_sessions
WHERE Churned = 0 AND Rating >= 4.5 AND Lesson_Completed > 0
GROUP BY User_ID, Country, Device_Type, Subscription_Status
ORDER BY total_lessons DESC
LIMIT 10;


