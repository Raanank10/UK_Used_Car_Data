-- Hybrid vs petrol premium, compared like for like.
-- A raw average would mix models and ages, so we only compare hybrids and petrols
-- of the SAME model and SAME registration year, where both groups have >= 10 listings.
WITH cell AS (
    SELECT
        model,
        year,
        AVG(CASE WHEN fuelType = 'Hybrid' THEN price END)   AS hybrid_avg,
        AVG(CASE WHEN fuelType = 'Petrol' THEN price END)   AS petrol_avg,
        SUM(fuelType = 'Hybrid')                            AS hybrid_n,
        SUM(fuelType = 'Petrol')                            AS petrol_n,
        AVG(CASE WHEN fuelType = 'Hybrid' THEN mileage END) AS hybrid_miles,
        AVG(CASE WHEN fuelType = 'Petrol' THEN mileage END) AS petrol_miles
    FROM listings
    GROUP BY model, year
)
SELECT
    model,
    year,
    hybrid_n,
    petrol_n,
    ROUND(hybrid_avg)                              AS hybrid_avg_price,
    ROUND(petrol_avg)                              AS petrol_avg_price,
    ROUND(100.0 * (hybrid_avg / petrol_avg - 1), 1) AS hybrid_premium_pct,
    ROUND(hybrid_miles - petrol_miles)             AS mileage_gap
FROM cell
WHERE hybrid_n >= 10 AND petrol_n >= 10
ORDER BY model, year;
