-- View 1: Channel KPIs
CREATE VIEW marketing_kpi_channel AS
SELECT channel, SUM(impressions) AS total_impressions,
SUM(clicks) AS total_clicks, SUM(cost) AS total_cost,
SUM(conversions) AS total_conversions,
SUM(conversion_value) AS total_conversion_value,
ROUND(SUM(cost)::NUMERIC / NULLIF(SUM(clicks), 0), 4) AS avg_cpc,
ROUND(SUM(clicks)::NUMERIC / NULLIF(SUM(impressions), 0) * 100, 2) AS ctr_percent,
ROUND(SUM(cost)::NUMERIC / NULLIF(SUM(conversions), 0), 2) AS cpa,
ROUND(SUM(conversion_value)::NUMERIC / NULLIF(SUM(cost), 0), 2) AS roas
FROM ads_combined WHERE channel IS NOT NULL
GROUP BY channel ORDER BY total_cost DESC;

-- View 2: Traffic Source KPIs
CREATE VIEW marketing_kpi_traffic_source AS
SELECT traffic_source,
COUNT(DISTINCT date) AS num_days,
SUM(sessions) AS total_sessions,
SUM(users) AS total_users,
SUM(revenue) AS total_revenue,
SUM(transactions) AS total_transactions,
ROUND(SUM(revenue)::NUMERIC / NULLIF(SUM(sessions), 0), 2) AS revenue_per_session,
ROUND(SUM(revenue)::NUMERIC / NULLIF(SUM(users), 0), 2) AS revenue_per_user
FROM ga4_simulated WHERE traffic_source IS NOT NULL
GROUP BY traffic_source ORDER BY total_revenue DESC;

-- View 3: Daily KPIs
CREATE VIEW marketing_kpi_daily AS
SELECT a.date, a.channel, a.impressions, a.clicks, a.cost,
a.conversions, a.conversion_value,
COALESCE(o.total_revenue, 0.0) AS order_revenue,
COALESCE(o.total_transactions, 0) AS transactions,
CASE WHEN a.clicks > 0 THEN ROUND((a.cost::NUMERIC / a.clicks), 4) ELSE 0 END AS cpc,
CASE WHEN a.impressions > 0 THEN ROUND((a.clicks::NUMERIC / a.impressions * 100), 2) ELSE 0 END AS ctr_percent,
CASE WHEN a.conversions > 0 THEN ROUND((a.cost::NUMERIC / a.conversions), 2) ELSE 0 END AS cpa,
CASE WHEN a.cost > 0 THEN ROUND((a.conversion_value::NUMERIC / a.cost), 2) ELSE 0 END AS roas
FROM ads_combined a
LEFT JOIN orders_daily o ON a.date = o.date
ORDER BY a.date DESC;
