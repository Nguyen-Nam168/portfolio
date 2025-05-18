-- Chọn tất cả dữ liệu trong dataset 
select * from piano_app_user_sessions; 

-- Tỉ lệ phần trăm người dùng ngừng sử dụng hoặc tương tác với ứng dụng (churned): Tỷ lệ rời bỏ (churn rate) của người dùng Premium là 9.46%, cao hơn so với người dùng Free là 8.41%. Mặc dù thường kỳ vọng người dùng trả phí sẽ trung thành hơn, dữ liệu cho thấy họ có xu hướng rời bỏ nhiều hơn. Người dùng Premium có tỷ lệ rời bỏ cao hơn người dùng Free (9.46% so với 8.41%), cho thấy họ có thể chưa thấy đủ giá trị từ dịch vụ trả phí hoặc kỳ vọng không được đáp ứng. 
SELECT Subscription_Status,
       COUNT(*) AS total_users,
       SUM(CASE WHEN Churned = 1 THEN 1 ELSE 0 END) AS churned_users,
       ROUND(100.0 * SUM(CASE WHEN Churned = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_pct
FROM piano_app_user_sessions
GROUP BY Subscription_Status;

-- Tỉ lệ rời bỏ theo loại thiết bị. Người dùng máy tính bảng có tỷ  lệ hủy cao nhất. Điều này cho thấy họ có xu hướng rời bỏ dịch vụ nhiều hơn so với người dùng thiết bị di động. Để giảm tỷ lệ hủy, cần cải thiện trải nghiệm người dùng trên máy tính bảng (UX/UI) hoặc cung cấp các ưu đãi nhằm giữ chân họ. Ngoài ra, nên triển khai các chương trình khuyến mãi hoặc giảm giá độc quyền dành cho người dùng máy tính bảng cao cấp để tăng cường sự gắn bó và giảm tỷ lệ hủy.
SELECT
  Device_Type,
  Subscription_Status,
  COUNT(*) AS total_users,
  SUM(CASE WHEN Churned = 1 THEN 1 ELSE 0 END) AS churned_users,
  ROUND(100.0 * SUM(CASE WHEN Churned = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_pct
FROM
  piano_app_user_sessions
GROUP BY
  Device_Type,
  Subscription_Status
ORDER BY
  Device_Type,
  Subscription_Status;


-- Tỉ lệ rời bỏ theo đất nước
SELECT
  Subscription_Status,
  Country,
  COUNT(*) AS total_users,
  SUM(CASE WHEN Churned = 1 THEN 1 ELSE 0 END) AS churned_users,
  ROUND(100.0 * SUM(CASE WHEN Churned = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_pct
FROM
  piano_app_user_sessions
GROUP BY
  Country,
  Subscription_Status
ORDER BY
  Country ASC,
  Subscription_Status ASC;


-- Top 3 các nước có Rating cao nhất (chỉ xét người dùng Premium)
SELECT Country,
       ROUND(AVG(Rating), 2) AS avg_rating
FROM piano_app_user_sessions
WHERE Subscription_Status = 'Premium'
GROUP BY Country
ORDER BY avg_rating DESC
LIMIT 3;

-- Top 3 các nước có Rating cao nhất (chỉ xét người dùng Free)
SELECT Country,
       ROUND(AVG(Rating), 2) AS avg_rating
FROM piano_app_user_sessions
WHERE Subscription_Status = 'Free'
GROUP BY Country
ORDER BY avg_rating DESC
LIMIT 3;


-- Các loại thiết bị và việc liệu có tương quan giữa hành động tương tác với tính năng của app và lượng piano lesson được hoàn thành hay không?
SELECT 
  Device_Type,
  Interacted_With_Feature,
  SUM(Lesson_Completed) AS total_lessons_completed
FROM piano_app_user_sessions
GROUP BY Device_Type, Interacted_With_Feature
ORDER BY 
  Device_Type,
  CASE 
    WHEN Interacted_With_Feature = 'Yes' THEN 0 
    ELSE 1 
  END;

-- Ai là những người dùng tiềm năng với tỉ lệ rời bỏ app thấp? 
	SELECT User_ID, Country, Device_Type, Subscription_Status,
		   ROUND(AVG(Session_Length_Minutes), 2) AS avg_time,
		   SUM(Lesson_Completed) AS total_lessons
	FROM piano_app_user_sessions
	WHERE Churned = 0 AND Rating >= 4.5 AND Lesson_Completed > 0
	GROUP BY User_ID, Country, Device_Type, Subscription_Status
	ORDER BY total_lessons DESC
	LIMIT 10;
    
-- Top 10 người dùng có thời gian cao nhất
SELECT 
  User_ID,
  Country,
  Device_Type,
  Subscription_Status,
  SUM(Session_Length_Minutes) AS total_time_minutes
FROM piano_app_user_sessions
GROUP BY 
  User_ID, 
  Country, 
  Device_Type, 
  Subscription_Status
ORDER BY total_time_minutes DESC
LIMIT 10;

-- Top 10 người dùng có tổng  số lesson đc hoàn  thành nhiều nhất
SELECT 
  User_ID,
  Country,
  Device_Type,
  Subscription_Status,
  SUM(Lesson_Completed) AS total_lessons_completed
FROM piano_app_user_sessions
GROUP BY 
  User_ID, 
  Country, 
  Device_Type, 
  Subscription_Status
ORDER BY total_lessons_completed DESC
LIMIT 10;

