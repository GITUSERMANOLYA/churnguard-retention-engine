-- 1. Overall churn
SELECT COUNT(*) AS customers, SUM(churn_value) AS churned,
       ROUND(AVG(churn_value) * 100, 1) AS churn_pct
FROM predictions;

-- 2. Churn by contract
SELECT contract, COUNT(*) AS customers, ROUND(AVG(churn_value) * 100, 1) AS churn_pct
FROM predictions GROUP BY contract ORDER BY churn_pct DESC;

-- 3. Churn by payment method
SELECT payment_method, COUNT(*) AS customers, ROUND(AVG(churn_value) * 100, 1) AS churn_pct
FROM predictions GROUP BY payment_method ORDER BY churn_pct DESC;

-- 4. Churn by internet service
SELECT internet_service, COUNT(*) AS customers, ROUND(AVG(churn_value) * 100, 1) AS churn_pct
FROM predictions GROUP BY internet_service ORDER BY churn_pct DESC;

-- 5. Early churn by tenure band
SELECT CASE WHEN tenure_months <= 6 THEN '0-6'
            WHEN tenure_months <= 12 THEN '7-12'
            WHEN tenure_months <= 24 THEN '13-24'
            ELSE '25+' END AS tenure_band,
       COUNT(*) AS customers, ROUND(AVG(churn_value) * 100, 1) AS churn_pct
FROM predictions GROUP BY tenure_band ORDER BY MIN(tenure_months);

-- 6. Lifetime value lost to churn, by contract
SELECT contract, SUM(cltv) AS cltv_lost
FROM predictions WHERE churn_value = 1
GROUP BY contract ORDER BY cltv_lost DESC;

-- 7. Risk tiers and revenue at risk
SELECT risk_tier, COUNT(*) AS customers, ROUND(SUM(revenue_at_risk)) AS revenue_at_risk
FROM predictions GROUP BY risk_tier;

-- 8. Targeted customers and expected profit, by contract
SELECT contract, COUNT(*) AS targeted, ROUND(SUM(expected_net)) AS expected_profit
FROM predictions WHERE target = 1
GROUP BY contract ORDER BY expected_profit DESC;

-- 9. Top 10 customers to contact first
SELECT customerid, contract, ROUND(churn_prob, 2) AS churn_prob,
       cltv, ROUND(expected_net) AS expected_net, recommended_action
FROM predictions WHERE target = 1
ORDER BY expected_net DESC LIMIT 10;

-- 10. Most common top churn reason among targeted customers
SELECT top_reason, COUNT(*) AS customers
FROM predictions WHERE target = 1
GROUP BY top_reason ORDER BY customers DESC;