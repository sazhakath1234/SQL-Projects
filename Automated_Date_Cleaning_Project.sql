# Automated Data Cleaning Project


SELECT *
FROM us_household_income ;

SELECT * FROM us_project.us_household_income_cleaned;



-- First, drop the existing procedure (No delimiter needed)
DROP PROCEDURE IF EXISTS Copy_and_Clean_Data;

DELIMITER $$

-- Now, create the procedure
CREATE PROCEDURE Copy_and_Clean_Data()
BEGIN
    -- CREATE TABLE IF IT DOESN'T EXIST
    CREATE TABLE IF NOT EXISTS us_household_income_Cleaned (
        row_id INT DEFAULT NULL,
        id INT DEFAULT NULL,
        State_Code INT DEFAULT NULL,
        State_Name TEXT,
        State_ab TEXT,
        County TEXT,
        City TEXT,
        Place TEXT,
        Type TEXT,
        `Primary` TEXT,  -- Use backticks since PRIMARY is a reserved keyword
        Zip_Code INT DEFAULT NULL,
        Area_Code INT DEFAULT NULL,
        ALand INT DEFAULT NULL,
        AWater INT DEFAULT NULL,
        Lat DOUBLE DEFAULT NULL,
        Lon DOUBLE DEFAULT NULL,
        TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

    -- COPY DATA TO NEW TABLE
    INSERT INTO us_household_income_Cleaned
    SELECT *, CURRENT_TIMESTAMP
    FROM us_project.us_household_income;
    
    
    -- DATA CLEANING STEPS
    
    
    
    -- Remove Duplicates
DELETE FROM us_household_income_Cleaned
WHERE 
	row_id IN (
	SELECT row_id
FROM (
	SELECT row_id, id,
		ROW_NUMBER() OVER (
			PARTITION BY id
			ORDER BY id) AS row_num
	FROM 
		us_household_income_Cleaned
) duplicates
WHERE 
	row_num > 1
);

-- Fixing some data quality issues by fixing typos and general standardization
UPDATE us_household_income_Cleaned
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

UPDATE us_household_income_Cleaned
SET County = UPPER(County);

UPDATE us_household_income_Cleaned
SET City = UPPER(City);

UPDATE us_household_income_Cleaned
SET Place = UPPER(Place);

UPDATE us_household_income_Cleaned
SET State_Name = UPPER(State_Name);

UPDATE us_household_income_Cleaned
SET `Type` = 'CDP'
WHERE `Type` = 'CPD';

UPDATE us_household_income_Cleaned
SET `Type` = 'Borough'
WHERE `Type` = 'Boroughs';


END $$

DELIMITER ;

CALL Copy_and_Clean_Data();

-- CREATE EVENT 

DROP EVENT raw_data_cleaning;
CREATE EVENT raw_data_cleaning
	ON SCHEDULE EVERY 30 DAY
    DO CALL Copy_and_Clean_Data();


-- DEBUGGING OR CEHCKING SP WORKS

SELECT row_id, id, row_num
FROM (
	SELECT row_id, id,
		ROW_NUMBER() OVER (
			PARTITION BY id, `TimeStamp`
			ORDER BY id, `TimeStamp`) AS row_num
	FROM 
		us_household_income_cleaned
) duplicates
WHERE 
	row_num > 1 ;

SELECT COUNT(row_id)
FROM us_household_income_cleaned;

SELECT State_Name, COUNT(State_Name)
FROM us_household_income_cleaned
GROUP BY State_Name;


