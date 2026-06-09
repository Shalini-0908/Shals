SELECT * FROM bank_churn_analysis.bank_customers;
SELECT COUNT(*) AS total_customers
FROM bank_customers;

#Customer Distribution by Country

SELECT
    country,
    COUNT(*) AS total_customers
FROM bank_customers
GROUP BY country
ORDER BY total_customers DESC;

#Customer Churn by Country

SELECT country,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned_customers,
    ROUND((SUM(churn) * 100.0 / COUNT(*)), 2) AS churn_rate_percent
FROM bank_customers
GROUP BY country
ORDER BY churn_rate_percent DESC;

#Churn Analysis by Gender

SELECT gender, COUNT(*) AS total_customers,
    SUM(churn) AS churned_customers,
    ROUND((SUM(churn) * 100.0 / COUNT(*)), 2) AS churn_rate_percent
FROM bank_customers
GROUP BY gender
ORDER BY churn_rate_percent DESC;

#Churn Analysis by Age Group

SELECT CASE
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Above 50'
    END AS age_group,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned_customers,
    ROUND((SUM(churn) * 100.0 / COUNT(*)), 2) AS churn_rate_percent
FROM bank_customers
GROUP BY age_group
ORDER BY churn_rate_percent DESC;

#Active vs Inactive Customers

SELECT
    CASE
        WHEN active_member = 1 THEN 'Active'
        ELSE 'Inactive'
    END AS customer_status,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned_customers,
    ROUND((SUM(churn) * 100.0 / COUNT(*)), 2) AS churn_rate_percent
FROM bank_customers
GROUP BY customer_status
ORDER BY churn_rate_percent DESC;

#Churn by Number of Products

SELECT
    products_number,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned_customers,
    ROUND((SUM(churn) * 100.0 / COUNT(*)), 2) AS churn_rate_percent
FROM bank_customers
GROUP BY products_number
ORDER BY products_number;

#Credit Score Analysis

SELECT CASE
        WHEN credit_score < 600 THEN 'Poor'
        WHEN credit_score BETWEEN 600 AND 750 THEN 'Average'
        ELSE 'Good'
    END AS credit_category,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned_customers,
    ROUND((SUM(churn) * 100.0 / COUNT(*)), 2) AS churn_rate_percent
FROM bank_customers
GROUP BY credit_category
ORDER BY churn_rate_percent DESC;

#Customer Balance Analysis

SELECT CASE
        WHEN balance = 0 THEN 'Zero Balance'
        WHEN balance < 100000 THEN 'Low Balance'
        ELSE 'High Balance'
    END AS balance_category,
    COUNT(*) AS total_customers,
    SUM(churn) AS churned_customers,
    ROUND((SUM(churn) * 100.0 / COUNT(*)), 2) AS churn_rate_percent
FROM bank_customers
GROUP BY balance_category
ORDER BY churn_rate_percent DESC;