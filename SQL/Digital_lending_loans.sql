-- ============================================================
-- Digital Lending Credit Risk Analysis
-- SQL Analysis File
-- Author: Nikita
-- Database Table: cleaned_loan_data
-- ============================================================

-- ============================================================
-- QUERY 1: Total Loan Applications
-- Business Objective:
-- Find the total number of loan applications received.
-- ============================================================

SELECT COUNT(*) AS Total_Applications
FROM cleaned_loan_data;

-- ============================================================
-- QUERY 2: Total Loan Amount Disbursed
-- Business Objective:
-- Calculate the total amount of loans processed.
-- ============================================================

SELECT
    SUM(Loan_Amount) AS Total_Loan_Amount
FROM cleaned_loan_data;

-- ============================================================
-- QUERY 3: Overall Loan Portfolio KPIs
-- Business Objective:
-- Display key portfolio metrics for management reporting.
-- ============================================================

SELECT
    COUNT(*) AS Total_Applications,
    SUM(Loan_Amount) AS Total_Loan_Amount,
    ROUND(AVG(Loan_Amount),2) AS Average_Loan_Amount,
    ROUND(AVG(Interest_Rate),2) AS Average_Interest_Rate
FROM cleaned_loan_data;

-- ============================================================
-- QUERY 4: Default Count and Default Rate
-- Business Objective:
-- Measure the percentage of customers who defaulted.
-- ============================================================

SELECT
    COUNT(CASE WHEN Default_Status='Default' THEN 1 END) AS Default_Count,
    ROUND(
        COUNT(CASE WHEN Default_Status='Default' THEN 1 END)
        *100.0/COUNT(*),2
    ) AS Default_Rate_Percentage
FROM cleaned_loan_data;


-- ============================================================
-- QUERY 5: Loan Application Status Summary
-- Business Objective:
-- Identify the number of applications by status.
-- ============================================================

SELECT
    Application_Status,
    COUNT(*) AS Total_Applications
FROM cleaned_loan_data
GROUP BY Application_Status
ORDER BY Total_Applications DESC;


-- ============================================================
-- QUERY 6: Approval Rate
-- Business Objective:
-- Calculate the percentage of approved loan applications.
-- ============================================================

SELECT
ROUND(
COUNT(CASE WHEN Application_Status='Approved' THEN 1 END)
*100.0/COUNT(*),2
) AS Approval_Rate
FROM cleaned_loan_data;


-- ============================================================
-- QUERY 7: Loan Purpose Analysis
-- Business Objective:
-- Determine which loan purposes receive the highest number
-- of applications.
-- ============================================================

SELECT
    Loan_Purpose,
    COUNT(*) AS Total_Applications,
    SUM(Loan_Amount) AS Total_Loan_Amount
FROM cleaned_loan_data
GROUP BY Loan_Purpose
ORDER BY Total_Applications DESC;


-- ============================================================
-- QUERY 8: Employment Type Analysis
-- Business Objective:
-- Compare loan distribution across employment categories.
-- ============================================================

SELECT
    Employment_Type,
    COUNT(*) AS Total_Customers,
    ROUND(AVG(Loan_Amount),2) AS Average_Loan,
    ROUND(AVG(Interest_Rate),2) AS Average_Interest
FROM cleaned_loan_data
GROUP BY Employment_Type
ORDER BY Total_Customers DESC;


-- ============================================================
-- QUERY 9: Credit Score Analysis
-- Business Objective:
-- Analyze customer distribution based on credit score.
-- ============================================================

SELECT
    Credit_Score,
    COUNT(*) AS Total_Customers,
    ROUND(AVG(Loan_Amount),2) AS Average_Loan_Amount
FROM cleaned_loan_data
GROUP BY Credit_Score
ORDER BY Credit_Score DESC;


-- ============================================================
-- QUERY 10: Customer Risk Classification using CASE
-- Business Objective:
-- Categorize customers into High, Medium, and Low Risk
-- based on credit score.
-- ============================================================

SELECT
    Customer_ID,
    Credit_Score,

    CASE
        WHEN Credit_Score >= 750 THEN 'Low Risk'
        WHEN Credit_Score BETWEEN 650 AND 749 THEN 'Medium Risk'
        ELSE 'High Risk'
    END AS Risk_Category

FROM cleaned_loan_data
ORDER BY Credit_Score DESC;

-- ============================================================
-- QUERY 11: Default Analysis by Employment Type
-- Business Objective:
-- Identify which employment category has the highest defaults.
-- ============================================================

SELECT
    Employment_Type,
    COUNT(*) AS Total_Loans,
    SUM(CASE WHEN Default_Status='Default' THEN 1 ELSE 0 END) AS Default_Count,
    ROUND(
        SUM(CASE WHEN Default_Status='Default' THEN 1 ELSE 0 END) * 100.0 /
        COUNT(*),2
    ) AS Default_Rate
FROM cleaned_loan_data
GROUP BY Employment_Type
ORDER BY Default_Rate DESC;


-- ============================================================
-- QUERY 12: Default Analysis by Loan Purpose
-- Business Objective:
-- Determine which loan purpose has the highest default rate.
-- ============================================================

SELECT
    Loan_Purpose,
    COUNT(*) AS Total_Loans,
    SUM(CASE WHEN Default_Status='Default' THEN 1 ELSE 0 END) AS Default_Count,
    ROUND(
        SUM(CASE WHEN Default_Status='Default' THEN 1 ELSE 0 END) *100.0/
        COUNT(*),2
    ) AS Default_Rate
FROM cleaned_loan_data
GROUP BY Loan_Purpose
ORDER BY Default_Rate DESC;


-- ============================================================
-- QUERY 13: State-wise Loan Portfolio
-- Business Objective:
-- Compare loan performance across different states.
-- ============================================================

SELECT
    State,
    COUNT(*) AS Total_Loans,
    SUM(Loan_Amount) AS Total_Loan_Amount,
    ROUND(AVG(Loan_Amount),2) AS Average_Loan
FROM cleaned_loan_data
GROUP BY State
ORDER BY Total_Loan_Amount DESC;


-- ============================================================
-- QUERY 14: Branch Performance Analysis
-- Business Objective:
-- Evaluate lending performance across branches.
-- ============================================================

SELECT
    Branch,
    COUNT(*) AS Total_Loans,
    SUM(Loan_Amount) AS Total_Loan_Amount,
    ROUND(AVG(Interest_Rate),2) AS Average_Interest_Rate
FROM cleaned_loan_data
GROUP BY Branch
ORDER BY Total_Loan_Amount DESC;


-- ============================================================
-- QUERY 15: Existing Loans Analysis
-- Business Objective:
-- Check whether customers with more existing loans are more
-- likely to default.
-- ============================================================

SELECT
    Existing_Loans,
    COUNT(*) AS Customers,
    SUM(CASE WHEN Default_Status='Default' THEN 1 ELSE 0 END) AS Default_Count
FROM cleaned_loan_data
GROUP BY Existing_Loans
ORDER BY Existing_Loans;


-- ============================================================
-- QUERY 16: Debt-to-Income Ratio Analysis
-- Business Objective:
-- Measure average debt burden across employment types.
-- ============================================================

SELECT
    Employment_Type,
    ROUND(AVG(Debt_to_Income_Ratio),2) AS Average_DTI
FROM cleaned_loan_data
GROUP BY Employment_Type
ORDER BY Average_DTI DESC;


-- ============================================================
-- QUERY 17: High Loan Amount Categories (HAVING)
-- Business Objective:
-- Show loan purposes where the total sanctioned amount
-- exceeds 5,000,000.
-- ============================================================

SELECT
    Loan_Purpose,
    SUM(Loan_Amount) AS Total_Loan_Amount
FROM cleaned_loan_data
GROUP BY Loan_Purpose
HAVING SUM(Loan_Amount) > 5000000
ORDER BY Total_Loan_Amount DESC;


-- ============================================================
-- QUERY 18: Customers with Above Average Loan Amount
-- Business Objective:
-- Identify customers who borrowed more than the average loan.
-- ============================================================

SELECT
    Customer_ID,
    Loan_Amount
FROM cleaned_loan_data
WHERE Loan_Amount >
(
    SELECT AVG(Loan_Amount)
    FROM cleaned_loan_data
)
ORDER BY Loan_Amount DESC;


-- ============================================================
-- QUERY 19: Common Table Expression (CTE)
-- Business Objective:
-- Identify high-risk customers based on low credit score.
-- ============================================================

WITH High_Risk_Customers AS
(
    SELECT
        Customer_ID,
        Credit_Score,
        Loan_Amount,
        Default_Status
    FROM cleaned_loan_data
    WHERE Credit_Score < 650
)

SELECT *
FROM High_Risk_Customers
ORDER BY Credit_Score;


-- ============================================================
-- QUERY 20: Top 10 Highest Loan Amounts
-- Business Objective:
-- Identify customers with the highest sanctioned loans.
-- ============================================================

SELECT
    Customer_ID,
    Loan_Amount,
    Loan_Purpose,
    State
FROM cleaned_loan_data
ORDER BY Loan_Amount DESC
LIMIT 10;

-- ============================================================
-- QUERY 21: Rank Customers by Loan Amount
-- Business Objective:
-- Assign a unique rank to each customer based on loan amount.
-- SQL Concept: ROW_NUMBER()
-- ============================================================

SELECT
    Customer_ID,
    Loan_Amount,
    ROW_NUMBER() OVER (ORDER BY Loan_Amount DESC) AS Loan_Rank
FROM cleaned_loan_data;


-- ============================================================
-- QUERY 22: Rank Customers by Interest Rate
-- Business Objective:
-- Rank customers based on interest rate.
-- SQL Concept: RANK()
-- ============================================================

SELECT
    Customer_ID,
    Interest_Rate,
    RANK() OVER (ORDER BY Interest_Rate DESC) AS Interest_Rank
FROM cleaned_loan_data;


-- ============================================================
-- QUERY 23: Dense Ranking of Loan Amount
-- Business Objective:
-- Rank customers by loan amount without gaps in ranking.
-- SQL Concept: DENSE_RANK()
-- ============================================================

SELECT
    Customer_ID,
    Loan_Amount,
    DENSE_RANK() OVER (ORDER BY Loan_Amount DESC) AS Dense_Rank
FROM cleaned_loan_data;


-- ============================================================
-- QUERY 24: Top Loan Amount in Each State
-- Business Objective:
-- Identify the customer with the highest loan amount in every state.
-- SQL Concept: ROW_NUMBER() with PARTITION BY
-- ============================================================

WITH State_Ranking AS
(
    SELECT
        Customer_ID,
        State,
        Loan_Amount,
        ROW_NUMBER() OVER
        (
            PARTITION BY State
            ORDER BY Loan_Amount DESC
        ) AS RN
    FROM cleaned_loan_data
)

SELECT *
FROM State_Ranking
WHERE RN = 1;


-- ============================================================
-- QUERY 25: Running Total of Loan Amount
-- Business Objective:
-- Calculate cumulative loan amount.
-- SQL Concept: SUM() OVER()
-- ============================================================

SELECT
    Loan_ID,
    Loan_Amount,
    SUM(Loan_Amount) OVER
    (
        ORDER BY Loan_Amount
    ) AS Running_Total
FROM cleaned_loan_data;


-- ============================================================
-- QUERY 26: Previous Loan Amount
-- Business Objective:
-- Compare current loan amount with previous loan amount.
-- SQL Concept: LAG()
-- ============================================================

SELECT
    Loan_ID,
    Loan_Amount,
    LAG(Loan_Amount)
    OVER (ORDER BY Loan_Amount) AS Previous_Loan
FROM cleaned_loan_data;


-- ============================================================
-- QUERY 27: Next Loan Amount
-- Business Objective:
-- Compare current loan amount with next loan amount.
-- SQL Concept: LEAD()
-- ============================================================

SELECT
    Loan_ID,
    Loan_Amount,
    LEAD(Loan_Amount)
    OVER (ORDER BY Loan_Amount) AS Next_Loan
FROM cleaned_loan_data;


-- ============================================================
-- QUERY 28: Loan Amount Quartiles
-- Business Objective:
-- Divide customers into four loan amount groups.
-- SQL Concept: NTILE()
-- ============================================================

SELECT
    Customer_ID,
    Loan_Amount,
    NTILE(4)
    OVER (ORDER BY Loan_Amount DESC) AS Loan_Quartile
FROM cleaned_loan_data;


-- ============================================================
-- QUERY 29: High-Risk Customers
-- Business Objective:
-- Identify customers with low credit scores and loan defaults.
-- ============================================================

SELECT
    Customer_ID,
    Credit_Score,
    Loan_Amount,
    Default_Status
FROM cleaned_loan_data
WHERE Credit_Score < 650
AND Default_Status = 'Default'
ORDER BY Credit_Score ASC;


-- ============================================================
-- QUERY 30: Executive Portfolio Summary
-- Business Objective:
-- Generate a summary of the loan portfolio for management.
-- ============================================================

SELECT

COUNT(*) AS Total_Applications,

SUM(Loan_Amount) AS Total_Loan_Amount,

ROUND(AVG(Loan_Amount),2) AS Average_Loan_Amount,

ROUND(AVG(Interest_Rate),2) AS Average_Interest_Rate,

SUM(CASE WHEN Default_Status='Default'
THEN 1 ELSE 0 END) AS Default_Count,

ROUND(
SUM(CASE WHEN Default_Status='Default'
THEN 1 ELSE 0 END)
*100.0/COUNT(*),2
) AS Default_Rate

FROM cleaned_loan_data;