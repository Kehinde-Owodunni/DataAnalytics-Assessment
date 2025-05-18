SELECT
  p.id AS plan_id,
  p.owner_id,
  CASE 
    WHEN p.is_regular_savings = 1 THEN 'Savings'
    WHEN p.is_a_fund = 1 THEN 'Investment'
      ELSE 'Unknown'
    END AS type,
    sa.last_transaction_date,
    DATEDIFF(CURDATE(), sa.last_transaction_date) AS inactivity_days
    FROM
      plans_plan p
      LEFT JOIN (
        SELECT
          plan_id,
          MAX(transaction_date) AS last_transaction_date
            FROM
              savings_savingsaccount
              GROUP BY
                plan_id
      ) sa ON p.id = sa.plan_id
      WHERE
        p.is_deleted = 0
          AND p.is_archived = 0
          AND (p.is_regular_savings = 1 OR p.is_a_fund = 1)
          AND (
            sa.last_transaction_date IS NULL
            OR sa.last_transaction_date < CURDATE() - INTERVAL 365 DAY
          );
