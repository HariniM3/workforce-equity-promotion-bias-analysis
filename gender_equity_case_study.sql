/*
Project: Workforce Equity & Promotion Bias Analysis
Author: Harini M
Description:
This project analyzes gender-based disparities in pay, promotion, attrition, 
and leadership representation using HR workforce data.

Key focus areas:
- Gender pay gap (overall + role-adjusted + level-adjusted)
- Promotion probability and career progression
- Attrition risk by gender and seniority
- Leadership pipeline representation

Tools: MySQL, Excel, Power BI
*/

SELECT VERSION();
SELECT COUNT(*) FROM employees;
SHOW TABLES;
USE workforce_equity;
DROP TABLE employees;
SELECT COUNT(*) FROM employees;
SELECT * FROM employees LIMIT 10;
DESCRIBE employees;
SELECT COUNT(*) AS total,
SUM(Gender IS NULL) AS gender_nulls,
SUM(JobLevel IS NULL) AS joblevel_nulls,
SUM(MonthlyIncome IS NULL) AS income_nulls,
SUM(Attrition IS NULL) AS attrition_nulls
FROM employees;
SELECT DISTINCT Gender FROM employees;
SELECT DISTINCT Attrition FROM employees;

-- Overall workforce composition
SELECT 
    Gender,
    COUNT(*) AS employee_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM employees), 2) AS percent_of_workforce
FROM employees
GROUP BY Gender;

-- Leadership pipeline
SELECT 
    JobLevel,
    Gender,
    COUNT(*) AS employees
FROM employees
GROUP BY JobLevel, Gender
ORDER BY JobLevel, Gender;

SELECT 
    JobLevel,
    Gender,
    COUNT(*) AS employees,
    ROUND(
      100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY JobLevel),
      2
    ) AS percent_within_level
FROM employees
GROUP BY JobLevel, Gender
ORDER BY JobLevel, Gender;

-- Attrition risk by gender

SELECT 
    Gender,
    Attrition,
    COUNT(*) AS employees
FROM employees
GROUP BY Gender, Attrition
ORDER BY Gender, Attrition;

-- Attrition rate 

SELECT 
    Gender,
    ROUND(100.0 * SUM(Attrition = 'Yes') / COUNT(*), 2) AS attrition_rate_pct
FROM employees
GROUP BY Gender;

-- Attrition by job level & gender

SELECT 
    JobLevel,
    Gender,
    ROUND(100.0 * SUM(Attrition = 'Yes') / COUNT(*), 2) AS attrition_rate_pct,
    COUNT(*) AS total_employees
FROM employees
GROUP BY JobLevel, Gender
ORDER BY JobLevel, Gender;

-- Promotion & mobility

SELECT 
    Gender,
    ROUND(AVG(YearsSinceLastPromotion), 2) AS avg_years_since_promo,
    ROUND(AVG(YearsAtCompany), 2) AS avg_tenure,
    ROUND(AVG(JobLevel), 2) AS avg_job_level
FROM employees
GROUP BY Gender;

-- And promotion likelihood:
SELECT 
    Gender,
    ROUND(100.0 * SUM(Promoted_Recently = 'Yes') / COUNT(*), 2) AS promotion_rate_pct
FROM employees
GROUP BY Gender;

-- Role-adjusted pay gap
-- overall :
SELECT 
    Gender,
    ROUND(AVG(MonthlyIncome), 2) AS avg_income
FROM employees
GROUP BY Gender;
-- By role
SELECT 
    JobRole,
    Gender,
    ROUND(AVG(MonthlyIncome), 2) AS avg_income
FROM employees
GROUP BY JobRole, Gender
ORDER BY JobRole, Gender;
-- Leadership pay gap
SELECT 
    JobLevel,
    Gender,
    ROUND(AVG(MonthlyIncome), 2) AS avg_income
FROM employees
GROUP BY JobLevel, Gender
ORDER BY JobLevel, Gender;


