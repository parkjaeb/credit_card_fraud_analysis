SELECT 
    state,
    COUNT(*) AS transaction_count,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS fraud_count,
    ROUND(SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS fraud_rate
FROM 
    'Credit_card_fraud_excel.csv'
GROUP BY 
    state
ORDER BY 
    transaction_count DESC
LIMIT 5;

/* Insights : 
Texas (TX) has the highest transaction volume (40,393) but a relatively low fraud rate of 0.28%. 
New York (NY) has fewer transactions (35,918) but the highest fraud count (175) 
and a significantly higher fraud rate of 0.49%. This suggests that fraud in New York is 
proportionally more common compared to other high-transaction states. */