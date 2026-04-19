SELECT 
    u.UserID,
    u.Name,
    u.Surname,
    u.Gender,
    u.Race,
    u.Age,

    -- Age grouping
    CASE 
        WHEN u.Age < 18 THEN 'Under 18 (Teenager)'
        WHEN u.Age BETWEEN 18 AND 24 THEN '18-24 (Youth)'
        WHEN u.Age BETWEEN 25 AND 34 THEN '25-34 (Young Adult)'
        WHEN u.Age BETWEEN 35 AND 44 THEN '35-44 (Adult)'
        ELSE '45+ (elder)'
    END AS age_group,

    --  Province
    CASE 
        WHEN u.Province IS NULL THEN 'Unknown'
        WHEN LOWER(u.Province) = 'none' THEN 'Unknown'
        ELSE u.Province
    END AS Province,

    -- Channel
    CASE 
        WHEN v.Channel2 IS NULL THEN 'No Activity'
        ELSE v.Channel2
    END AS channel,

    --  SA Time 
    date_format(v.RecordDate2 + INTERVAL 2 HOURS, 'dd MMM yyyy HH:mm') AS sa_time,

    -- Clean Date
    date_format(v.RecordDate2 + INTERVAL 2 HOURS, 'yyyy-MM-dd') AS view_date,

    -- Day of week 
    date_format(v.RecordDate2 + INTERVAL 2 HOURS, 'EEEE') AS day_of_week,

    -- Time of day grouping
    CASE 
        WHEN HOUR(v.RecordDate2 + INTERVAL 2 HOURS) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(v.RecordDate2 + INTERVAL 2 HOURS) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN HOUR(v.RecordDate2 + INTERVAL 2 HOURS) BETWEEN 18 AND 22 THEN 'Evening'
        ELSE 'Night'
    END AS time_of_day,

    --  Duration (minutes)
    CASE 
        WHEN v.`Duration 2` IS NULL THEN 0
        ELSE ROUND(
            (HOUR(v.`Duration 2`) * 60 
            + MINUTE(v.`Duration 2`) 
            + SECOND(v.`Duration 2`) / 60.0), 
        2)
    END AS duration_minutes,

    -- User activity 
    CASE 
        WHEN v.UserID0 IS NULL THEN 'Inactive'
        ELSE 'Active'
    END AS user_status

FROM workspace.default.bright_tv_dataset u
LEFT JOIN workspace.default.bright_tv_dataset_1 v
    ON u.UserID = v.UserID0;
