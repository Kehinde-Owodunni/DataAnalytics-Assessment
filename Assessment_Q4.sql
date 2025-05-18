-- ================================================
-- Customer Lifetime Value (CLV) Estimation Query
-- Description:
-- Calculates CLV for each active user based on their
-- transaction history using savings_savingsaccount.
-- 
-- CLV Formula:
-- CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction
-- Where profit_per_transaction = 0.1% of confirmed_amount (in Naira)
-- ================================================

SELECT 
  u.id AS customer_id,
  
  -- Concatenate first and last name for name
  CONCAT(u.first_name, ' ', u.last_name) AS name,

  -- Calculate account tenure in months
  TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,

  -- Count of savings transactions for this user
  COUNT(s.id) AS total_transactions,

  -- Estimated CLV calculation
  ROUND(
    IF(
      TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) = 0, 
      0, 
      (
        (COUNT(s.id) / TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE())) 
        * 12 
        * (0.001 * AVG(s.confirmed_amount / 100)) -- 0.1% of confirmed_amount in Naira
      )
    ), 2
  ) AS estimated_clv

FROM users_customuser u

-- Join with savings transactions
JOIN savings_savingsaccount s 
  ON u.id = s.owner_id

-- Only include active and undeleted users
WHERE u.is_active = 1 
  AND u.is_account_deleted = 0

-- Group results by user
GROUP BY u.id, u.name, u.date_joined

-- Sort by estimated CLV in descending order
ORDER BY estimated_clv DESC;
