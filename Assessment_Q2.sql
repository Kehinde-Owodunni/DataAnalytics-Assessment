WITH monthly_transactions AS (
  SELECT 
    s.owner_id,
    DATE_FORMAT(s.created_on, '%Y-%m') AS transaction_month,
      COUNT(*) AS transaction_count
    FROM 
      savings_savingsaccount s
    WHERE 
      s.confirmed_amount > 0
    GROUP BY 
      s.owner_id, DATE_FORMAT(s.created_on, '%Y-%m')
),

avg_transactions_per_customer AS (
  SELECT 
    m.owner_id,
      AVG(m.transaction_count) AS avg_transaction_per_month
    FROM 
      monthly_transactions m
    GROUP BY 
      m.owner_id
),

categorized_customers AS (
  SELECT 
    a.owner_id,
    a.avg_transaction_per_month,
    CASE 
      WHEN a.avg_transaction_per_month >= 10 THEN 'High Frequency'
      WHEN a.avg_transaction_per_month >= 3 THEN 'Medium Frequency'
      ELSE 'Low Frequency'
      END AS frequency_category
    FROM 
    avg_transactions_per_customer a
)

SELECT 
  frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transaction_per_month), 1) AS avg_transactions_per_month
  FROM 
    categorized_customers
  GROUP BY 
    frequency_category
  ORDER BY 
    avg_transactions_per_month DESC;
