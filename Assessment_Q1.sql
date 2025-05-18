SELECT 
  u.id AS owner_id,
  CONCAT(u.first_name, ' ', u.last_name) AS name,
  COUNT(CASE WHEN p.is_regular_savings = 1 THEN 1 END) AS savings_count,
  COUNT(CASE WHEN p.is_a_fund = 1 THEN 1 END) AS investment_count,
  ROUND(SUM(sa.confirmed_amount) / 100.0, 2) AS total_deposits
FROM 
  users_customuser u
JOIN 
  savings_savingsaccount sa ON u.id = sa.owner_id
JOIN 
  plans_plan p ON sa.plan_id = p.id
WHERE 
  sa.confirmed_amount > 0
  AND u.id IN (
    SELECT s1.owner_id
      FROM savings_savingsaccount s1
        JOIN plans_plan p1 ON s1.plan_id = p1.id
          WHERE p1.is_regular_savings = 1
            AND s1.confirmed_amount > 0
    )
    AND u.id IN (
      SELECT s2.owner_id
        FROM savings_savingsaccount s2
          JOIN plans_plan p2 ON s2.plan_id = p2.id
            WHERE p2.is_a_fund = 1
            AND s2.confirmed_amount > 0
)
GROUP BY 
  u.id, u.first_name, u.last_name
ORDER BY 
  total_deposits DESC;
