# Размеры групп
SELECT 
    version,
    COUNT(*) AS users,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM experiment_data), 4) AS pct
FROM experiment_data
GROUP BY version;

# Средние метрики по группам
SELECT 
    version,
    COUNT(*) AS users,
    ROUND(AVG(sum_gamerounds), 2) AS avg_rounds,
    ROUND(AVG(retention_1) * 100, 2) AS ret1_pct,
    ROUND(AVG(retention_7) * 100, 2) AS ret7_pct
FROM experiment_data
GROUP BY version;

# Распределение sum_gamerounds по бакетам
SELECT 
    version,
    CASE 
        WHEN sum_gamerounds = 0 THEN '0'
        WHEN sum_gamerounds BETWEEN 1 AND 10 THEN '1-10'
        WHEN sum_gamerounds BETWEEN 11 AND 50 THEN '11-50'
        WHEN sum_gamerounds BETWEEN 51 AND 100 THEN '51-100'
        WHEN sum_gamerounds BETWEEN 101 AND 500 THEN '101-500'
        ELSE '500+'
    END AS bucket,
    COUNT(*) AS users
FROM experiment_data
GROUP BY version, bucket
ORDER BY version, 
    CASE bucket
        WHEN '0' THEN 1
        WHEN '1-10' THEN 2
        WHEN '11-50' THEN 3
        WHEN '51-100' THEN 4
        WHEN '101-500' THEN 5
        ELSE 6
    END;


# Retention через CASE WHEN
SELECT 
    version,
    COUNT(*) AS users,
    SUM(CASE WHEN retention_1 = 1 THEN 1 ELSE 0 END) AS ret1_users,
    SUM(CASE WHEN retention_7 = 1 THEN 1 ELSE 0 END) AS ret7_users,
    ROUND(SUM(CASE WHEN retention_1 = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ret1_pct,
    ROUND(SUM(CASE WHEN retention_7 = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ret7_pct
FROM experiment_data
GROUP BY version;

# Топ-10 игроков
SELECT userid, version, sum_gamerounds, retention_1, retention_7
FROM experiment_data
ORDER BY sum_gamerounds DESC
LIMIT 10;

# «Киты» (> 1000 раундов)
sql
SELECT 
    version,
    COUNT(*) AS whales
FROM experiment_data
WHERE sum_gamerounds > 1000
GROUP BY version;
