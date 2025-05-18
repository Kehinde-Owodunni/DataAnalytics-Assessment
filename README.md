<a name="readme-top"></a>

<div align="center">
  <img src="sql_logo.png" alt="logo" width="140"  height="auto" />
  <br/>

  <h3><b>DataAnalytic-Assessment</b></h3>
</div>

# 📗 Table of Contents

- [📖 About the Project](#about-project)
    - [Key Features](#key-features)
  - [📝 Approach for Each Task](#approach-for-each-task)
- [💻 Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Setup](#setup)

# 📖 SQL Analytics Tasks <a name="about-project"></a>

**SQL Analytics Tasks** is a data exploration and business intelligence project consisting of four SQL queries. These scripts analyze customer behavior, transaction activity, and financial engagement to support data-driven decision-making for a financial platform.

## 🛠 Built With <a name="built-with"></a>

<details>
<summary>Database</summary>
<ul>
  <li><a href="https://www.mysql.com/">MySQL</a></li>
</ul>
</details>

### Key Features <a name="key-features"></a>

- 🧮 Calculate estimated Customer Lifetime Value (CLV)
- 🧾 Identify dual-type users (savers & investors)
- 📉 Detect inactive saving/investment plans
- 📊 Categorize customers by transaction frequency

## 📝 Approach for Each Task <a name="approach-for-each-task"></a>

### Task 1: High-Value Customer with Multiple Product
- **Approach:** I add up all confirmed deposits for each user and connect this with their plans to find out which are savings or investment accounts.
- Count how many accounts they have of each type and add the total deposits. We divide the total by 100 to change the amount from small units (kobo) to the main money unit (Naira).
- Include users who have deposits in both savings and investments to focus on active customers.
- **Challenge:** It was tricky to count accounts correctly using conditions and to make sure the money amounts were converted right.

### Task 2: Transaction Frequency Analysis
- **Approach:** 
- I Calculate total confirmed transactions per customer per month.
- Compute average monthly transaction count for each customer. 
- Categorize customers based on their transaction frequency High, Low and Medium.
- Count customers in each category and calculate average frequency.
- **Challenge:** Writing the steps clearly and grouping transactions by month correctly took some care.

### Task 3: Identify Dual-Type User Deposits
- **Approach:**
- Determine the plan type based on savings and investment
- Most recent transaction date for the plan.
- Days since the last transaction (or since plan creation if no transactions).
- Subquery to find the last transaction date for each plan.
- Filter for active, relevant plans only.
- Inactivity condition: either no transactions or over 365 days old
- **Challenge:** It was hard to make sure users with both types were found without counting them more than once.

### Task 4: Customer Lifetime Value (CLV) Estimation Query
- **Approach:**
- Concatenate first and last name for name.
- Calculate account tenure in months
- Count of savings transactions for this user.
- Estimated CLV calculation.
- Join with savings transactions, Only include active and undeleted users, Group results by user, Sort by estimated CLV in descending order
- **Challenge:** Handling plans with no transactions (no dates) and calculating how long it has been since the last transaction was a bit tricky.


<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 💻 Getting Started <a name="getting-started"></a>

Clone the repository and run the SQL files within a MySQL-compatible database.

### Prerequisites

- MySQL or compatible SQL environment
- SQL client or DBMS (e.g., MySQL Workbench, DBeaver)

### Setup

```sh
git clone https://github.com/Kehinde-Owodunni/DataAnalytics-Assessment.git
cd DataAnalytics-Assessment
