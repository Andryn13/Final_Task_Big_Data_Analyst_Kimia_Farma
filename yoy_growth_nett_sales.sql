CREATE OR REPLACE VIEW `rakamin-kf-analytics-476709.kimia_farma.kf_yoy_revenue` AS
SELECT
    year, dates,
    total_nett_sales,
    LAG(total_nett_sales) OVER (ORDER BY year) AS prev_year_nett_sales,
    total_nett_sales - LAG(total_nett_sales) OVER (ORDER BY year) AS yoy_change,
    ROUND(
        SAFE_DIVIDE(
            total_nett_sales - LAG(total_nett_sales) OVER (ORDER BY year),
            LAG(total_nett_sales) OVER (ORDER BY year)
        ) * 100,
        2
    ) AS yoy_percentage
FROM (
    SELECT
        EXTRACT(YEAR FROM dates) AS year,
        SUM(nett_sales) AS total_nett_sales
    FROM `rakamin-kf-analytics-476709.kimia_farma.analisa`
    GROUP BY EXTRACT(YEAR FROM dates)
) AS yearly_sales
ORDER BY year;
