WITH all_ads_data AS (
    SELECT
        f.ad_date,
        fc.campaign_name,
        fa.adset_name,
        f.spend,
        f.impressions,
        f.clicks,
        f.value,
        f.reach,
        'Facebook' AS ad_source
    FROM public.facebook_ads_basic_daily f
    LEFT JOIN public.facebook_adset fa ON f.adset_id = fa.adset_id
    LEFT JOIN public.facebook_campaign fc ON f.campaign_id = fc.campaign_id

    UNION ALL

    SELECT
        g.ad_date,
        g.campaign_name,
        g.adset_name,
        g.spend,
        g.impressions,
        g.clicks,
        g.value,
        g.reach,
        'Google' AS ad_source
    FROM public.google_ads_basic_daily g
)
SELECT
    DATE_TRUNC('week', ad_date)::DATE AS week_start,
    campaign_name,
    SUM(value)::numeric(18,4) AS weekly_value
FROM all_ads_data
GROUP BY 1, 2
HAVING SUM(value) > 0
ORDER BY weekly_value DESC
LIMIT 1;