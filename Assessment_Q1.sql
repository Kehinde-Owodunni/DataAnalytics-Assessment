-- ========================================================
-- Query: Users with Both Savings and Investment Accounts
-- Description:
-- This query lists all users who have made deposits in:
--   - At least one regular savings plan
--   - At least one investment (fund) plan
-- The output includes:
--   - User ID and name
--   - Number of savings and investment plans
--   - Total deposits (converted from kobo to Naira)
-- ========================================================

SELECT 
  u.id AS owner_id,

  -- Combine first and last name for user display
  CONCAT(u.first_name, ' ', u.last_name) AS name,

  -- Count number of regular savings plans per user
  COUNT(CASE WHEN p.is_regular_savings = 1 THEN 1 END) AS savings_count,

  -- Count number of investment plans per user
  COUNT(CASE WHEN p.is_a_fund = 1 THEN 1 END) AS investment_count,

  -- Sum of confirmed deposits (converted from kobo to Naira)
  ROUND(SUM(sa.confirmed_amount) / 100.0, 2) AS total_deposits

FROM 
  users_customuser u

-- Join to get all savings account transactions
JOIN 
  savings_savingsaccount sa ON u.id = sa.owner_id

-- Join to determine the type of plan (savings or fund)
JOIN 
  plans_plan p ON sa.plan_id = p.id

-- Only include transactions that are actual deposits
WHERE 
  sa.confirmed_amount > 0

-- Ensure the user has at least one regular savings plan deposit
AND u.id IN (
  SELECT s1.owner_id
  FROM savings_savingsaccount s1
  JOIN plans_plan p1 ON s1.plan_id = p1.id
  WHERE p1.is_regular_savings = 1
    AND s1.confirmed_amount > 0
)

-- Ensure the user has at least one investment (fund) plan deposit
AND u.id IN (
  SELECT s2.owner_id
  FROM savings_savingsaccount s2
  JOIN plans_plan p2 ON s2.plan_id = p2.id
  WHERE p2.is_a_fund = 1
    AND s2.confirmed_amount > 0
)

-- Group results by user
GROUP BY 
  u.id, u.first_name, u.last_name

-- Sort by highest total deposit amount
ORDER BY 
  total_deposits DESC;
