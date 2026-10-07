-- Year-over-year value loss by model, using window functions.
-- Average price per model and age, then LAG to compare each age with the year before.
-- Cells with fewer than 15 listings are dropped to keep the averages stable.
WITH by_age AS (
    SELECT
        model,
        2020 - year      AS age,
        COUNT(*)         AS n,
        AVG(price)       AS avg_price,
        AVG(mileage)     AS avg_mileage
    FROM listings
    WHERE 2020 - year BETWEEN 1 AND 7
    GROUP BY model, 2020 - year
    HAVING COUNT(*) >= 15
)
SELECT
    model,
    age,
    n,
    ROUND(avg_price)                                                     AS avg_price,
    ROUND(avg_mileage)                                                   AS avg_mileage,
    ROUND(100.0 * (avg_price / LAG(avg_price) OVER w - 1), 1)            AS yoy_change_pct,
    ROUND(100.0 * avg_price / FIRST_VALUE(avg_price) OVER w, 1)          AS value_index_vs_age1
FROM by_age
WINDOW w AS (PARTITION BY model ORDER BY age)
ORDER BY model, age;
