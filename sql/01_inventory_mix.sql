-- Inventory mix: what is on the market, and at what price point?
-- Table `listings` is created by the notebook from data/toyota.csv (duplicates removed).
SELECT
    model,
    COUNT(*)                                        AS listings,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS share_pct,
    ROUND(AVG(price))                               AS avg_price,
    ROUND(AVG(2020 - year), 1)                      AS avg_age_years,
    ROUND(AVG(mileage))                             AS avg_mileage,
    ROUND(100.0 * AVG(fuelType = 'Hybrid'), 1)      AS hybrid_pct
FROM listings
GROUP BY model
HAVING COUNT(*) >= 50
ORDER BY listings DESC;
