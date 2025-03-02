SELECT Country, MIN('Life expectancy'), MAX('Life expectancy')
FROM WorldLifeExpectancy
GROUP BY Country
ORDER BY Country DESC;
--change
SELECT Country, MIN([Life expectancy]) AS Min_LifeExpectancy, MAX([Life expectancy]) AS Max_LifeExpectancy
FROM WorldLifeExpectancy
GROUP BY Country 
ORDER BY Country DESC;

SELECT Country, 
       MIN(CAST([Life expectancy] AS FLOAT)) AS Min_LifeExpectancy, 
       MAX(CAST([Life expectancy] AS FLOAT)) AS Max_LifeExpectancy,
       ROUND(MAX(CAST([Life expectancy] AS FLOAT)) - MIN(CAST([Life expectancy] AS FLOAT)), 1) AS Life_Increase_15_years
FROM WorldLifeExpectancy
GROUP BY Country
HAVING MIN(CAST([Life expectancy] AS FLOAT)) <> 0 
   AND MAX(CAST([Life expectancy] AS FLOAT)) <> 0
ORDER BY Life_Increase_15_years DESC;


SELECT year, ROUND(CAST(AVG([Life expectancy] AS FLOAT)),2)
FROM WorldLifeExpectancy 
GROUP BY Year
ORDER BY Year
--- change
SELECT Year, 
       ROUND(AVG(CAST([Life expectancy] AS FLOAT)), 2) AS Avg_LifeExpectancy
FROM WorldLifeExpectancy 
GROUP BY Year
HAVING MIN(CAST([Life expectancy] AS FLOAT)) <> 0 
   AND MAX(CAST([Life expectancy] AS FLOAT)) <> 0
ORDER BY Year;

SELECT *
FROM WorldLifeExpectancy;

SELECT 
    Country, 
    ROUND(AVG(CAST([Life expectancy] AS FLOAT)), 1) AS Avg_LifeExpectancy, 
    ROUND(AVG(CAST(GDP AS FLOAT)),1) AS GDP
FROM WorldLifeExpectancy
GROUP BY Country
HAVING AVG(CAST([Life expectancy] AS FLOAT)) > 0
   AND AVG(CAST(GDP AS FLOAT)) > 0
ORDER BY GDP DESC
;

SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
AVG(CASE WHEN GDP >= 1500 THEN CAST([Life expectancy] AS FLOAT) ELSE NULL END) LOW_GDP_Life_Expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
AVG(CASE WHEN GDP <= 1500 THEN CAST([Life expectancy] AS FLOAT) ELSE NULL END) LOW_GDP_Life_Expectancy
FROM WorldLifeExpectancy;

SELECT Status, ROUND(AVG(CAST([Life expectancy] AS FLOAT)),1) as Avg_Life
FROM WorldLifeExpectancy
GROUP BY Status;

SELECT Status, COUNT(DISTINCT Country), ROUND(AVG(CAST([Life expectancy] AS FLOAT)),1) as Avg_Life
FROM WorldLifeExpectancy
GROUP BY Status;
-- findings of skewed averages due to large quantity of developed countries 


SELECT 
    Country, 
    ROUND(AVG(CAST([Life expectancy] AS FLOAT)), 1) AS Avg_LifeExpectancy, 
    ROUND(AVG(CAST([ BMI ] AS FLOAT)), 1) AS Avg_BMI
FROM WorldLifeExpectancy
GROUP BY Country
HAVING AVG(CAST([Life expectancy] AS FLOAT)) > 0
   AND AVG(CAST([ BMI ] AS FLOAT)) > 0
ORDER BY Avg_BMI ASC;

SELECT [ BMI ]
FROM WorldLifeExpectancy

SELECT COUNTRY,
YEAR,
[Life expectancy],
[Adult Mortality], 
SUM(CAST([Adult Mortality] AS FLOAT)) OVER(PARTITION BY Country ORDER BY YEAR) as ROLLING_TOTAL
FROM WorldLifeExpectancy
WHERE Country LIKE '%United%'
;