WITH fb AS (
    SELECT 
        fa.adset_name,
        f.ad_date::date AS d
    FROM public.facebook_ads_basic_daily f
    JOIN public.facebook_adset fa ON f.adset_id = fa.adset_id
    WHERE f.spend > 0
    GROUP BY fa.adset_name, f.ad_date
),
ga AS (
    SELECT 
        adset_name,
        ad_date::date AS d
    FROM public.google_ads_basic_daily
    WHERE spend > 0
    GROUP BY adset_name, ad_date
),
combined AS (
    SELECT DISTINCT adset_name, d FROM fb
    UNION
    SELECT DISTINCT adset_name, d FROM ga
),
sequenced AS (
    SELECT 
        adset_name,
        d,
        (d - ROW_NUMBER() OVER (PARTITION BY adset_name ORDER BY d)::int) AS grp
    FROM combined
),
streaks AS (
    SELECT 
        adset_name,
        MIN(d) AS start_date,
        MAX(d) AS end_date,
        COUNT(*) AS duration_days
    FROM sequenced
    GROUP BY adset_name, grp
)
SELECT 
    adset_name,
    start_date,
    end_date,
    duration_days
FROM streaks
ORDER BY duration_days DESC, adset_name
LIMIT 1;