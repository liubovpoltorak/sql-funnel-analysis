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
),
monthly_reach_camp AS (
    SELECT
        TO_CHAR(ad_date, 'YYYY-MM') AS ad_month,
        campaign_name,
        COALESCE(SUM(reach), 0)::numeric(18,4) AS monthly_reach
    FROM all_ads_data
    GROUP BY 1, 2
)
SELECT
    ad_month,
    campaign_name,
    monthly_reach,
    monthly_reach - COALESCE(
        LAG(monthly_reach) OVER (PARTITION BY campaign_name ORDER BY ad_month), 
        0
    ) AS monthly_growth
FROM monthly_reach_camp
ORDER BY monthly_growth DESC
LIMIT 1;