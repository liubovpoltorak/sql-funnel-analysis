WITH all_days AS (
    SELECT ad_date::date AS report_date, spend::numeric AS spend, value::numeric AS value
    FROM public.facebook_ads_basic_daily
    UNION ALL
    SELECT ad_date::date AS report_date, spend::numeric AS spend, value::numeric AS value
    FROM public.google_ads_basic_daily
),
agg AS (
    SELECT report_date, SUM(spend) AS total_spend, SUM(value) AS total_value
    FROM all_days
    GROUP BY report_date
)
SELECT 
    report_date,
    ROUND( (total_value - total_spend) / NULLIF(total_spend,0), 4 ) AS romi
FROM agg
ORDER BY romi DESC NULLS LAST
LIMIT 5;