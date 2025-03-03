
# US HousHold Income Cleaning Data Analysis 

SELECT *
 FROM us_project.us_household_income;

ALTER TABLE us_project.us_household_income_statistics RENAME COLUMN `ï»¿id` TO `id`;

SELECT *
FROM us_project.us_household_income;
 
SELECT *
FROM us_project.us_household_income_statistics;

SELECT *
FROM (
SELECT row_id, 
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
FROM  us_project.us_household_income
) duplicates
WHERE row_num > 1;

DELETE FROM us_project.us_household_income 
WHERE row_id IN (
	SELECT row_id
	FROM (
		SELECT row_id, 
		id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
		FROM  us_project.us_household_income
		) duplicates
WHERE row_num > 1) ;


SELECT id, COUNT(id)
FROM us_project.us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1 ;

SELECT DISTINCT State_name
FROM us_project.us_household_income
ORDER BY 1;

UPDATE us_project.us_household_income
SET State_name = 'Georgia'
WHERE State_name = 'georia';

UPDATE us_project.us_household_income
SET State_name = 'Alabama'
WHERE State_name = 'alabama';

SELECT DISTINCT State_ab
FROM  us_project.us_household_income
ORDER BY 1;

SELECT DISTINCT *
FROM  us_project.us_household_income
WHERE PLACE = ''
ORDER BY 1;

SELECT DISTINCT *
FROM  us_project.us_household_income
WHERE County = 'Autauga County'
ORDER BY 1;

UPDATE us_project.us_household_income
SET Place = ' Autaugaville'
WHERE County = 'Vinemont'
AND City =  'Autauga County';

SELECT Type, COUNT(type)
FROM  us_project.us_household_income
GROUP BY Type;

UPDATE  us_project.us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs';

SELECT Aland, AWater
FROM us_project.us_household_income
WHERE AWater = 0 OR AWater = '' OR AWater IS NULL 
;

SELECT Aland, AWater
FROM us_project.us_household_income
WHERE ALand = 0 OR ALand = '' OR ALand IS NULL 
;
