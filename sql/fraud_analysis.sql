/* Goal : 
Understand the balance between fraduluent (1) and non-fradulent (0) 
transactions (imbalanced data may require special handling). */

SELECT 
	is_fraud, 
	COUNT(*) AS transaction_count
FROM
	'Credit_card_fraud_excel.csv'
GROUP BY 1;

/* Insight :
The dataset is highly inbalanced, with 553,574 legitimate transactions (99.6%) and only 2,145 fraudulent transactions (0.4%). 
This imbalance highlights the rarity of fraud cases, making it critical to apply techniques like oversampling, undersampling, or 
class weighting to ensure the model accurately detects fraud without being biased toward the majority class. */


/* Goal : Find the categories with the most fraud cases and their average transaction amount. */

SELECT
	category,
	COUNT(*) AS fraud_count,
	ROUND(AVG(amt), 2) AS avg_fraud_amount
FROM 
	'Credit_card_fraud_excel.csv'
WHERE 
	is_fraud = 1
GROUP BY 1	
ORDER BY 2 DESC
LIMIT 5;

/* Insight: 
Online shopping _(shopping_net)_ has the most fraud cases (506) with a high average amount ($994.32), 
suggesting a focus on fraud prevention for online transactions. */

/* Goal : 
Identify categories with the highest proportion of fradulent transactions, not just raw counts. */

SELECT 
	category,
	COUNT(CASE WHEN is_fraud = 1 THEN 1 END) AS fraud_count,
	COUNT(*) AS total_transaction,
	ROUND(COUNT(CASE WHEN is_fraud = 1 THEN 1 END) * 100.0 / COUNT(*), 2) AS fraud_rate
FROM 
	'Credit_card_fraud_excel.csv'
GROUP BY 1
ORDER BY 4 DESC
LIMIT 5;

/* Insight
Shopping_net has the highest fraud rate (1.21%) among all categorie , followed by misc_net (0.98%). Despite having a lower fraud rate (0.92%), grocery_pos has a high volumn of transactions, 
making it a significant contributor to overall fraud risk. */

/* Goal : 
Understand which transaction amounts are most frequently linked to fraud and their average value. */

SELECT
	CASE 
		WHEN amt < 50 THEN 'Under $50'
		WHEN amt BETWEEN 50 AND 100 THEN '$50-$100'
		WHEN amt BETWEEN 101 AND 500 THEN '$101-500'
		WHEN amt > 500 THEN 'Over $500'
	END AS amount_range,
	COUNT(*) AS fraud_count,
	ROUND(AVG(amt), 2) AS avg_fraud_amount
FROM 
	'Credit_card_fraud_excel.csv'
WHERE is_fraud = 1
GROUP BY amount_range
ORDER BY fraud_count DESC;

/* Insight :
Transactions over 500 have the highest fraud count (1,036) and the largest average fraud amount (905.49), while lower transaction ranges, such as Under 50, have significantly fewer 
fraud cases (462) and a much smaller average fraud amount of ($15.56) */

/* Goal : 
Determine which combinations of product category and transactions amount are most associated with fraud. */

SELECT 
    category,
    CASE 
        WHEN amt < 50 THEN 'Under $50'
        WHEN amt BETWEEN 50 AND 100 THEN '$50-$100'
        WHEN amt BETWEEN 101 AND 500 THEN '$101-$500'
        WHEN amt > 500 THEN 'Over $500'
    END AS amount_range,
    COUNT(*) AS fraud_count,
    ROUND(AVG(amt), 2) AS avg_fraud_amount
FROM 
    'Credit_card_fraud_excel.csv'
WHERE 
    is_fraud = 1
GROUP BY 
    category, amount_range
ORDER BY 
    fraud_count DESC
LIMIT 5;

/* Insight :
High-value transactons over 500 in categories like shopping_net (506 cases, 994.32 average fraud)
and misc_net (267 cases, 804.28 average fraud) are most prone to fraud. Low-value transactions, like gas_transport under 50, have fewer fraud cases (154)
and minimal financial impact ($12 average fraud). */

/* Feature Engineering */

SELECT
	hour(STRPTIME(trans_date_trans_time, '%m/%d/%Y %H:%M')) AS hour,
	is_fraud,
	COUNT(*) AS frequency
FROM 'Credit_card_fraud_excel.csv'
WHERE is_fraud = 1
GROUP BY 1,2
ORDER BY 3 DESC;

/* Insights :
Fraudulent transactions are most frequent during the 22nd hour (10PM) with 550 cases, followed by 23rd hour (11PM) with 538 cases, and 
3rd hour (3AM) with 194 cases. This suggests that fraudulent activity peaks late at night, possibly targeting less monitored hours. */


