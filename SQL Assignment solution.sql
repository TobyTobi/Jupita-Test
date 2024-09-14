-- View the entire table
SELECT * FROM Cyclistic
-- There are 80,128 rows and 13 columns


-- Check for NULL values
SELECT * FROM Cyclistic
WHERE rideable_type IS NULL OR start_station_name IS NULL OR end_station_name IS NULL OR member_casual IS NULL
-- There are no null values


-- Select columns from the table
SELECT ride_id, started_at
FROM Cyclistic


-- Don't see duplicates
Use DISTINCT


-- Check for duplicates
SELECT ride_id, COUNT(*) As duplicate_count
FROM Cyclistic
GROUP BY ride_id
HAVING COUNT(*) > 1


-- Deleting duplicates
-- Method 1
DELETE FROM Cyclistic
WHERE ride_id IN (
    SELECT ride_id
    FROM Cyclistic
    GROUP BY ride_id
    HAVING COUNT(*) > 1
);



-- Method 2
WITH DuplicatesCTE AS (
    SELECT your_column,
           ROW_NUMBER() OVER (PARTITION BY your_column ORDER BY (SELECT NULL)) AS RowNum
    FROM your_table
)
DELETE FROM DuplicatesCTE
WHERE RowNum > 1;


WITH DuplicatesCTE AS (
    SELECT ride_id,
           ROW_NUMBER() OVER (PARTITION BY ride_id ORDER BY (SELECT NULL)) AS RowNumber
    FROM Cyclistic
)
DELETE FROM CTE WHERE RowNumber > 1;


-- Question 1: What is the proportion of member riders to casual riders in January
SELECT member_casual, COUNT(ride_id) AS Count_of_user
FROM Cyclistic
GROUP BY member_casual
-- There are 67,523 active members and 12,605 casual members


-- Question 2: Which rider type took more rides during the month
-- The active members (rider type) took more rides during the month


-- Question 3: Which rideable_type was the most popular among members
SELECT TOP 1 rideable_type, COUNT(*) AS type_of_ride
FROM Cyclistic
WHERE member_casual = 'member'
GROUP BY rideable_type
ORDER BY COUNT(*) DESC
-- The classic bike is the most popular rideable type among active members


-- Question 4: Which rideable type was most popular among casual riders
SELECT TOP 1 rideable_type, COUNT(*) AS type_of_ride
FROM Cyclistic
WHERE member_casual = 'casual'
GROUP BY rideable_type
ORDER BY COUNT(*) DESC
-- The classic bike is the most popular rideable type among casual users


-- Question 5: Which start station had the highest number of rides
SELECT TOP(1) start_station_name, COUNT(ride_id) AS Count
FROM Cyclistic
GROUP BY start_station_name
ORDER BY COUNT(ride_id) DESC
-- Kingsbury St & Kinzie St had the highest number of rides (1047)


-- Question 6: Which end station had the highest number of rides
SELECT TOP(1) end_station_name, COUNT(ride_id) AS Count
FROM Cyclistic
GROUP BY end_station_name
ORDER BY COUNT(ride_id) DESC
-- Kingsbury St & Kinzie St had the highest number of rides (943)


-- Question 7: What are the top 5 stations based on the number of rides that ended there
SELECT TOP(5) end_station_name, COUNT(ride_id) AS Count
FROM Cyclistic
GROUP BY end_station_name
ORDER BY COUNT(ride_id) DESC
/* The top 5 stations based on rides that ended there are:
1. Kingsbury St & Kinzie St
2. Clinton St & Madison St
3. Clark St. & Elm St.
4. Clinton St & Washington Blvd
5. St. Clair St & Erie St
*/



-- Question 8: What is the average ride duration for member and casual riders
SELECT member_casual, AVG(DATEDIFF(mi, starteddate, endeddate)) AS average_duration
FROM Cyclistic
GROUP BY member_casual