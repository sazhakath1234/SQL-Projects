SELECT *
FROM WorldLifeExpectancy


SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year)) AS count
FROM WorldLifeExpectancy
GROUP BY Country, Year, CONCAT(Country, Year)
having COUNT(CONCAT(Country, Year)) > 1

SELECT *
FROM (
	SELECT Row_ID,
	CONCAT(country,Year) , 
	ROW_NUMBER() OVER (PARTITION BY CONCAT(country,Year) ORDER BY CONCAT(Country, Year)) as Row_Num
	FROM WorldLifeExpectancy
	) AS Row_Table
;


SELECT *
FROM (
    SELECT 
        Row_ID,
        CONCAT(country, Year) AS CountryYear, -- Provide an alias for the concatenated column
        ROW_NUMBER() OVER (
            PARTITION BY CONCAT(country, Year) 
            ORDER BY CONCAT(Country, Year)
        ) AS Row_Num
    FROM WorldLifeExpectancy
) AS Row_Table
WHERE Row_Num > 1
;


DELETE FROM WorldLifeExpectancy
WHERE 
	Row_ID IN (
	SELECT  Row_ID
FROM (
    SELECT
        Row_ID,
        CONCAT(country, Year) AS CountryYear, -- Provide an alias for the concatenated column
        ROW_NUMBER() OVER (
            PARTITION BY CONCAT(country, Year) 
            ORDER BY CONCAT(Country, Year)
        ) AS Row_Num
    FROM WorldLifeExpectancy
) AS Row_Table
WHERE Row_Num > 1
)
;

SELECT DISTINCT(Status)
FROM WorldLifeExpectancy
WHERE Status <> '' ;

SELECT DISTINCT(Country)
FROM WorldLifeExpectancy
Where Status = 'Developing'

UPDATE WorldLifeExpectancy
SET Status = 'Developing'
WHERE Country IN ( SELECT DISTINCT(Country)
				FROM WorldLifeExpectancy
				Where Status = 'Developing');


SELECT *
FROM WorldLifeExpectancy
WHERE Country = 'United States of America' 

UPDATE WorldLifeExpectancy
SET Status = 'Developed'
WHERE Country IN ( SELECT DISTINCT(Country)
				FROM WorldLifeExpectancy
				Where Status = 'Developed');

SELECT *
FROM WorldLifeExpectancy
WHERE [Life expectancy]='';

SELECT Country, Year, [Life expectancy]
FROM WorldLifeExpectancy
;

SELECT 
    t1.Country, t1.Year, t1.[Life expectancy], 
    t2.Country, t2.Year, t2.[Life expectancy],  
    t3.Country, t3.Year, t3.[Life expectancy],
    ROUND((t2.[Life expectancy] + t3.[Life expectancy]) / 2.0, 1) AS Avg_LifeExpectancy -- Fixed: Added AS alias for the computed column and corrected ROUND syntax
FROM WorldLifeExpectancy t1
JOIN WorldLifeExpectancy t2
    ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN WorldLifeExpectancy t3
    ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.[Life expectancy] = ''; -- Fixed: Removed trailing space in column name


SELECT 
    t1.Country, t1.Year, t1.[Life expectancy], 
    t2.Country, t2.Year, t2.[Life expectancy],  
    t3.Country, t3.Year, t3.[Life expectancy],
    ROUND(
        (CAST(t2.[Life expectancy] AS FLOAT) + CAST(t3.[Life expectancy] AS FLOAT)) / 2.0, 
        1
    ) AS Avg_LifeExpectancy -- Fixed: Convert Life expectancy to numeric before calculations
FROM WorldLifeExpectancy t1
JOIN WorldLifeExpectancy t2
    ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN WorldLifeExpectancy t3
    ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.[Life expectancy] = ''; -- Ensure this filters valid rows


UPDATE WorldLifeExpectancy t1
JOIN WorldLifeExpectancy t2
    ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN WorldLifeExpectancy t3
    ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.[Life expectancy] =  ROUND((CAST(t2.[Life expectancy] AS FLOAT) + CAST(t3.[Life expectancy] AS FLOAT)) / 2.0, 1) 
WHERE t1.[Life expectancy] = ''
;

UPDATE t1
SET t1.[Life expectancy] = ROUND((CAST(t2.[Life expectancy] AS FLOAT) + CAST(t3.[Life expectancy] AS FLOAT)) / 2.0, 1)
FROM WorldLifeExpectancy t1
JOIN WorldLifeExpectancy t2
    ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN WorldLifeExpectancy t3
    ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.[Life expectancy] = '';
