SELECT 
    ad_date::date AS report_date,
    'facebook' AS platform,
    AVG(spend)::numeric(18,4) AS avg_spend,
    MAX(spend)::numeric(18,4) AS max_spend,
    MIN(spend)::numeric(18,4) AS min_spend
FROM public.facebook_ads_basic_daily
GROUP BY ad_date

UNION ALL

SELECT 
    ad_date::date AS report_date,
    'google' AS platform,
    AVG(spend)::numeric(18,4) AS avg_spend,
    MAX(spend)::numeric(18,4) AS max_spend,
    MIN(spend)::numeric(18,4) AS min_spend
FROM public.google_ads_basic_daily
GROUP BY ad_date
ORDER BY report_date, platform;