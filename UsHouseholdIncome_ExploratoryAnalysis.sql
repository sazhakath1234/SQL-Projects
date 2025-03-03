#US HousHold Income Exploratory Data Analysis 

SELECT *
FROM us_project.us_household_income;
 
SELECT *
FROM us_project.us_household_income_statistics;


SELECT State_Name, SUM(Aland), SUM(Awater)
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10;

SELECT u.State_name, County, Type, `Primary`, Mean, Median
FROM us_project.us_household_income u 
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id 
WHERE mean <> 0;

SELECT u.State_name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u 
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id 
WHERE mean <> 0
GROUP BY u.State_name
ORDER BY 3 
LIMIT 10;

SELECT type, COUNT(TYPE), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u 
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id 
WHERE mean <> 0
GROUP BY 1
ORDER BY 4 DESC
LIMIT 20;

SELECT * 
FROM us_project.us_household_income
WHERE type = 'Community';

SELECT type, COUNT(TYPE), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_project.us_household_income u 
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id 
WHERE mean <> 0
GROUP BY 1
HAVING count(Type) > 100
ORDER BY 4 DESC
LIMIT 20;


SELECT u.state_name, city, round(AVG(Mean),1),  round(AVG(Median),1) 
FROM us_project.us_household_income u 
INNER JOIN us_project.us_household_income_statistics us
	ON u.id = us.id 
GROUP BY u.state_name, city
ORDER BY 3 DESC;
    
    
    