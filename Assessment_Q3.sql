-- ============================================================
-- Query: Identify Inactive Savings and Investment Plans
-- Description:
-- This query returns all non-deleted, non-archived plans 
-- (either savings or investment) that have been inactive for 
-- over 365 days or have never had a transaction.
-- Output includes:
--   - Plan ID and owner ID
--   - Plan type (Savings or Investment)
--   - Last transaction date
--   - Days since last activity
-- ============================================================

SELECT
  p.id AS plan_id,
  p.owner_id,

  -- Determine the plan type based on flags
  CASE 
    WHEN p.is_regular_savings = 1 THEN 'Savings'
    WHEN p.is_a_fund = 1 THEN 'Investment'
    ELSE 'Unknown'
  END AS type,

  -- Most recent transaction date for the plan
  sa.last_transaction_date,

  -- Days since the last transaction (or since plan creation if no transactions)
  DATEDIFF(CURDATE(), sa.last_transaction_date) AS inactivity_days

FROM plans_plan p

-- Subquery to find the last transaction date for each plan
LEFT JOIN (
  SELECT
    plan_id,
    MAX(transaction_date) AS last_transaction_date
  FROM
    savings_savingsaccount
  GROUP BY
    plan_id
) sa ON p.id = sa.plan_id

-- Filter for active, relevant plans only
WHERE
  p.is_deleted = 0
  AND p.is_archived = 0
  AND (p.is_regular_savings = 1 OR p.is_a_fund = 1)

  -- Inactivity condition: either no transactions or over 365 days old
  AND (
    sa.last_transaction_date IS NULL
    OR sa.last_transaction_date < CURDATE() - INTERVAL 365 DAY
  );
