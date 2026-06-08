-- ==========================================
-- E-Commerce Return Cost & Customer Dissatisfaction Analysis
-- SQL Business Analysis Queries
-- ==========================================

-- 1. Overall Return Rate Analysis

-- 2. Category-wise Return Analysis

-- 3. Category-wise Profit Analysis

-- 4. Category-wise Return Cost Analysis

-- 5. Discount Bucket Analysis

-- 6. Risk Classification Analysis

SELECT
    COUNT(*) AS total_orders,
    SUM(
        CASE
            WHEN Return_Status = 'Returned' THEN 1
            ELSE 0
        END
    ) AS total_returns,
    ROUND(
        SUM(
            CASE
                WHEN Return_Status = 'Returned' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS return_rate
FROM ecommerce_returns;

-- Category-wise Return Rate

SELECT
    Product_Category,
    COUNT(*) AS total_orders,
    SUM(
        CASE
            WHEN Return_Status = 'Returned' THEN 1
            ELSE 0
        END
    ) AS total_returns,
    ROUND(
        SUM(
            CASE
                WHEN Return_Status = 'Returned' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS return_rate
FROM ecommerce_returns
GROUP BY Product_Category
ORDER BY return_rate DESC;

-- Category-wise Profit
SELECT
    Product_Category,
    ROUND(SUM(Profit_Loss),2) AS total_profit
FROM ecommerce_returns
GROUP BY Product_Category
ORDER BY total_profit DESC;

-- Category-wise Return Cost

SELECT
    Product_Category,
    ROUND(SUM(Return_Cost),2) AS total_return_cost
FROM ecommerce_returns
GROUP BY Product_Category
ORDER BY total_return_cost DESC;

-- Discount Bucket Profit Analysis
SELECT
CASE
    WHEN Discount_Applied <= 10 THEN '0-10%'
    WHEN Discount_Applied <= 20 THEN '11-20%'
    WHEN Discount_Applied <= 30 THEN '21-30%'
    WHEN Discount_Applied <= 40 THEN '31-40%'
    ELSE '41-50%'
END AS Discount_Bucket,

ROUND(SUM(Profit_Loss),2) AS Total_Profit

FROM ecommerce_returns

GROUP BY Discount_Bucket

ORDER BY Total_Profit DESC;

-- Risk Classification
SELECT

Product_Category,

ROUND(
SUM(
CASE
WHEN Return_Status='Returned'
THEN 1
ELSE 0
END
)*100.0/COUNT(*),
2
) AS Return_Rate,

CASE

WHEN ROUND(
SUM(
CASE
WHEN Return_Status='Returned'
THEN 1
ELSE 0
END
)*100.0/COUNT(*),
2
) > 35

THEN 'High Risk'

ELSE 'Low Risk'

END AS Risk_Level

FROM ecommerce_returns

GROUP BY Product_Category;

