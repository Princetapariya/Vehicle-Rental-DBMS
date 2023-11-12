#Vehicle Model Popularity Analysis
SELECT
    Vehicle_Model,
    COUNT(*) AS RentalCount,
    SUM(Running_Distance_Km) AS TotalDistance
FROM
    rentvehicle
GROUP BY
    Vehicle_Model
ORDER BY
    RentalCount DESC, TotalDistance DESC;

#Customer Verification Proof Analysis
SELECT
    Verification_Proof,
    COUNT(*) AS ProofCount
FROM
    rentvehicle
WHERE
    Verification_Proof IS NOT NULL
    AND Verification_Proof != ''
GROUP BY
    Verification_Proof
ORDER BY
    ProofCount DESC;

#Customer Spending Trends Over Weekdays
SELECT
    WEEKDAY(Date_of_Issue) AS RentalWeekday,
    AVG(Total_Cost) AS AvgCost
FROM
    rentvehicle
GROUP BY
    RentalWeekday
ORDER BY
    RentalWeekday;

#Rental Duration by Vehicle Type
SELECT
    Vehicle_Type,
    AVG(DATEDIFF(Received_Date, Date_of_Issue)) AS AvgRentalDuration
FROM
    rentservice.rentvehicle
WHERE
    Received_Date IS NOT NULL
GROUP BY
    Vehicle_Type
ORDER BY
    AvgRentalDuration DESC;
    
#)Seasonal Trends in Rental Count and Average Running Distance
WITH MonthlyRentalStats AS (
    SELECT
        EXTRACT(MONTH FROM Date_of_issue) AS month,
        CASE
            WHEN EXTRACT(MONTH FROM Date_of_issue) IN (12, 1, 2) THEN 'Winter'
            WHEN EXTRACT(MONTH FROM Date_of_issue) IN (3, 4, 5) THEN 'Spring'
            WHEN EXTRACT(MONTH FROM Date_of_issue) IN (6, 7, 8) THEN 'Summer'
            WHEN EXTRACT(MONTH FROM Date_of_issue) IN (9, 10, 11) THEN 'Fall'
        END AS season,
        COUNT(*) AS rental_count,
        AVG(Running_Distance_Km) AS average_running_distance
    FROM
        rentservice.rentvehicle
    GROUP BY
        month, season
)

SELECT
    month,
    season,
    rental_count,
    ROUND(average_running_distance, 2) AS average_running_distance
FROM
    MonthlyRentalStats
ORDER BY
    month;
    
#Predictive Analysis of Daily Rental Demand
WITH DailyDemand AS (
    SELECT
        Date_of_issue,
        COUNT(*) AS daily_rental_count
    FROM
        rentservice.rentvehicle
    GROUP BY
        Date_of_issue
)

SELECT
    Date_of_issue,
    daily_rental_count,
    AVG(daily_rental_count) OVER (ORDER BY Date_of_issue ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS avg_weekly_rental
FROM
    DailyDemand
ORDER BY 
	Date_of_issue;

    
    
    
#) Profitability Analysis by Vehicle Category
SELECT
    vehicle_type,
    AVG(Total_Cost - Total_Price) / AVG(Total_Cost) * 100 AS profit_margin
FROM rentservice.rentvehicle
GROUP BY vehicle_type
ORDER BY profit_margin DESC;


#) Utilization Efficiency Analysis
SELECT
    vehicle_id,
    SUM(DATEDIFF(Received_Date, Date_of_issue)) / 30 AS utilization_percentage
FROM rentservice.rentvehicle
WHERE Received_Date IS NOT NULL AND Date_of_issue >= CURRENT_DATE - INTERVAL '1' MONTH
GROUP BY vehicle_id
ORDER BY utilization_percentage DESC;


#vehicle Rental Cost Analysis by Weekday, Model, and Name 
SELECT
    Weekday,
    Vehicle_Model,
    Vehicle_Name,
    SUM(Total_Cost) AS TotalCostPerDay
FROM
    rentvehicle
GROUP BY
    Weekday,
    Vehicle_Model,
    Vehicle_Name
ORDER BY
    Weekday, Vehicle_Model, Vehicle_Name;
    
    
#Dynamic Pricing Strategy for Vehicle Rentals
-- Price Sensitivity Analysis
SELECT
    Vehicle_Model,
    Weekday,
    AVG(Total_Cost) AS AvgCost,
    COUNT(DISTINCT Customer_Name) AS UniqueCustomers,
    AVG(Total_Cost) / COUNT(DISTINCT Customer_Name) AS AvgCostPerCustomer
FROM
    rentvehicle
GROUP BY
    Vehicle_Model,
    Weekday
ORDER BY
    Vehicle_Model, Weekday;


#) Vehicle Rental Trend Analysis for Marketing Strategy
SELECT
    Vehicle_Model,
    COUNT(*) AS RentalCount
FROM
    rentvehicle
GROUP BY
    Vehicle_Model
ORDER BY
    RentalCount DESC;

-- Peak Rental Days
SELECT
    Weekday,
    COUNT(*) AS RentalCount
FROM
    rentvehicle
GROUP BY
    Weekday
ORDER BY
    RentalCount DESC;

-- Customer Segmentation
SELECT
    Customer_Name,
    AVG(Total_Cost) AS AverageCost
FROM
    rentvehicle
GROUP BY
    Customer_Name
ORDER BY
    AverageCost DESC;

-- Promotional Opportunities
SELECT
    Weekday,
    Vehicle_Model,
    COUNT(*) AS RentalCount
FROM
    rentvehicle
GROUP BY
    Weekday,
    Vehicle_Model
HAVING
    RentalCount < 10
ORDER BY
    Weekday, Vehicle_Model;
    
    