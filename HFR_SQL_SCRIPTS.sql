SELECT 
    State,
    Region,
    SUM(No_Of_Doctors + No_Of_Nurses + No_Of_Lab_Scientists + Midwifes + 
        Lab_Technicians + Nurse_Midwife + HIM_Officers + 
        Community_Health_Officer + Community_Extension_Workers + 
        Jun_Community_Extension_Worker + Dental_Technicians + 
        Env_Health_Officers) AS Total_Health_Professionals
FROM 
    NHFR
GROUP BY 
    State, Region
ORDER BY 
    Total_Health_Professionals DESC;



SELECT State, SUM(No_Of_Doctors) AS Total_Doctors, 
       SUM(No_Of_Nurses) AS Total_Nurses, 
       SUM(No_Of_Lab_Scientists) AS Total_Lab_Scientists
FROM NHFR
GROUP BY State;



SELECT AVG(No_Of_Beds) AS Average_Beds_Per_Facility
FROM NHFR;

SELECT Facility_Name, State
FROM NHFR
WHERE No_Of_Beds = 0;



SELECT Start_Year, COUNT(*) as num_facilities 
FROM NHFR
GROUP BY Start_Year
ORDER BY num_facilities DESC
LIMIT 1;



SELECT Ownership, AVG(No_Of_Health_Personnel) AS Avg_Health_Personnel
FROM NHFR
GROUP BY Ownership;



SELECT State, COUNT(*) AS Private_Facilities
FROM NHFR
WHERE Ownership = 'Private'
GROUP BY State
ORDER BY Private_Facilities DESC;



SELECT 
    Region, Facility_Name, Facility_Level, Ownership_Type, Start_Year, No_Of_Health_Personnel 
FROM 
    NHFR 
WHERE 
    No_Of_Health_Personnel = 0;



SELECT Facility_Name, Operation_Hour
FROM NHFR
WHERE Operation_Hour IN (
    SELECT MIN(Operation_Hour)
    FROM NHFR
);




SELECT State, COUNT(*) as Unlicensed_Facilities
FROM NHFR
WHERE License_Status = 'Unlicensed'
GROUP BY State
ORDER BY Unlicensed_Facilities DESC
LIMIT 1;



SELECT State, COUNT(*) AS Num_Licensed_Facilities
FROM NHFR
WHERE License_Status = 'Licensed'
GROUP BY State
ORDER BY Num_Licensed_Facilities DESC;



SELECT State, SUM(No_Of_Doctors) / SUM(No_Of_Nurses) AS Doctor_To_Nurse_Ratio
FROM NHFR
GROUP BY State;



SELECT f1.Facility_Name, f1.Latitude, f1.Longitude, f2.Facility_Name, f2.Latitude, f2.Longitude, 
(6371 * acos(cos(radians(f1.Latitude)) * cos(radians(f2.Latitude)) * cos(radians(f2.Longitude) - radians(f1.Longitude)) + sin(radians(f1.Latitude)) * sin(radians(f2.Latitude)))) AS distance
FROM NHFR f1
JOIN NHFR f2 ON f1.LGA = f2.LGA AND f1.id != f2.id
WHERE (6371 * acos(cos(radians(f1.Latitude)) * cos(radians(f2.Latitude)) * cos(radians(f2.Longitude) - radians(f1.Longitude)) + sin(radians(f1.Latitude)) * sin(radians(f2.Latitude)))) < 1
ORDER BY f1.LGA, distance;



SELECT LGA, MIN(Start_Date) AS First_Established_Facility
FROM NHFR
GROUP BY LGA;



SELECT LGA, Ward, COUNT(*) AS facilities, 
       SUM(COUNT(*)) OVER (PARTITION BY LGA) AS total_lga,
       SUM(COUNT(*)) OVER (PARTITION BY LGA, Ward) AS total_ward
FROM NHFR
GROUP BY LGA, Ward;



SELECT NHFR.*, 
DATEDIFF(NOW(), STR_TO_DATE(CONCAT(Start_Month, '/', Start_Year), '%m/%Y'))/30 AS Tenure_in_Months,
(SELECT AVG(DATEDIFF(NOW(), STR_TO_DATE(CONCAT(Start_Month, '/', Start_Year), '%m/%Y')))/30 
FROM NHFR AS f2 WHERE f2.LGA = NHFR.LGA AND f2.Ward = NHFR.Ward) AS Average_Tenure_in_Months
FROM NHFR
WHERE DATEDIFF(NOW(), STR_TO_DATE(CONCAT(Start_Month, '/', Start_Year), '%m/%Y'))/30 > 
(SELECT AVG(DATEDIFF(NOW(), STR_TO_DATE(CONCAT(Start_Month, '/', Start_Year), '%m/%Y')))/30 
FROM NHFR AS f2 WHERE f2.LGA = NHFR.LGA AND f2.Ward = NHFR.Ward)
ORDER BY NHFR.LGA, NHFR.Ward;



SELECT Ward, MIN(Start_Date) AS Earliest_Facility, MAX(Start_Date) AS Latest_Facility
FROM NHFR
GROUP BY Ward;



SELECT NHFR.LGA, NHFR.Ward, 
  MAX(Start_Date) - MIN(Start_Date) AS Duration
FROM NHFR
GROUP BY NHFR.LGA, NHFR.Ward;



SELECT 
    State,
    AVG(COUNT(*)) OVER (PARTITION BY State ORDER BY Start_Date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Moving_Avg
FROM NHFR
GROUP BY State, Start_Date;



SELECT LGA, 
       AVG(DATEDIFF(month, Start_Date, GETDATE())) AS Avg_Months_To_Establish 
FROM NHFR 
GROUP BY LGA;

