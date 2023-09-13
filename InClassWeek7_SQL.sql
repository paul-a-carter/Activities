-- SELECT "Make", "Model", "Electric Range"
-- FROM evRegistry

-- SELECT DISTINCT "City"
-- FROM EvRegistry

-- SELECT *
-- FROM evRegistry

-- SELECT DISTINCT "City", "State"
-- FROM evRegistry
-- WHERE Model = "MODEL 3"

-- SELECT DISTINCT "Make", "Model", "Electric Range"
-- FROM evRegistry
-- WHERE "Electric Range" > 250

INSERT INTO evRegistry (State, PostalCode, ModelYear, StateID)
VALUES('PA',19130,2020,290)

-- Using the LIKE Operator, find the vehicle, and all its info, that  has a VIN that starts with: 1N4AZ

SELECT *
FROM evRegistry;

SELECT *
FROM evRegistry
WHERE VIN LIKE "1N4AZ%"

-- Using the LIKE Operator, find the vehicle, and all its info, that has 'GDEE' within the VIN number.

SELECT *
FROM evRegistry
WHERE VIN LIKE "%GDEE%"

-- How many Nulls are there in Make?

INSERT INTO evRegistry (State, "Postal Code", "Model Year", StateID)
VALUES('PA',19130,2020,290)

SELECT *
FROM evRegistry
WHERE Make IS NULL

-- How many different makes of vehicle have the word "Model" in them? (Should return a list of Models)

SELECT DISTINCT Make, Model
FROM evRegistry
WHERE Model LIKE "%Model%"

-- Select the Model Year, make, model, type, and range of the Tesla vehicles in the registry.
-- Order the result set by Make as well as Model year in **DESCENDING** order.

SELECT "Model Year", Make, Model, "Electric Vehicle Type", "Electric Range"
FROM evRegistry
WHERE Make = "TESLA"
ORDER BY Make, Model DESC

-- Select the Model Year, make, model, type, and range of the Tesla vehicles in the registry.
-- Order the result set by Make as well as Model year in **ASCENDING** order. Limit your result set to 10 rows.

SELECT "Model Year", Make, Model, "Electric Vehicle Type", "Electric Range"
FROM evRegistry
WHERE Make = "TESLA"
ORDER BY Make, Model ASC
Limit 10

-- Using EVCharging, Let's find out how many user's there are.

SELECT DISTINCT userID, COUNT(userID)
FROM evCharge
GROUP BY userID

SELECT COUNT(DISTINCT userID)
FROM evCharge

-- Using EVCharging, How many different stations did each user use. Show me the top ten users.

SELECT DISTINCT userID, COUNT(DISTINCT stationID)
FROM evCharge
GROUP BY userID
ORDER BY COUNT(DISTINCT stationID) DESC
Limit 10

SELECT userID, MAX(chargeTimeHrs)
FROM evCharge
GROUP BY userID
ORDER BY MAX(chargeTimeHrs) DESC

SELECT userID, MIN(chargeTimeHrs)
FROM evCharge
GROUP BY userID
ORDER BY MIN(chargeTimeHrs)

-- Each Charging location has multiple charging stations. Using the EVCharging table, Reveal the locationId and 
-- Find out how many charging stations there are at each Charging location and rename this column numStations.
-- Order the result set so the location with the most stations appears first. Limit the output to 20.

SELECT locationId, COUNT(DISTINCT stationId) as numStations
FROM evCharge
GROUP BY locationId
ORDER BY COUNT(DISTINCT stationId) DESC
LIMIT 20

-- Using the EVCharging table, I would like to know the average power consumption per user.
-- Please list the user identification and rename the aggregation column to avgPower. Round this number to 2 decimal places.

SELECT userId, ROUND(AVG(kwhTotal),2) as avgPower
FROM evCharge
GROUP BY userId

-- Using the EVCharging table, Find the total power output from each charging location. You list the location identification and 
-- rename other column to totalpowerKWH Round the answer to 2 decimal points and list the out put in highest to lowest order. 
-- Limit the order to the top 10.

SELECT locationId, ROUND(SUM(kwhTotal),2) AS totalpowerKWH
FROM evCharge
GROUP BY locationId
ORDER BY totalpowerKWH DESC
LIMIT 10

-- We previously found out how many many times those stations charged a vehicle. Let’s change the result set to only include 
-- the stations who charged more than 100 electric vehicles. Order the ouput to show the highest number first.

SELECT stationId, COUNT(sessionId)
FROM evCharge
GROUP BY stationId
HAVING COUNT(sessionId) > 100
ORDER BY COUNT(sessionId) DESC

-- Lets find the User’s who have a total power consumption over 1000kwh. Round the answer to 2 deciaml points and list the output 
-- in highest to lowest order. Show the top power consumer first. Also, display the userid and totalPower in the output columns.

SELECT userId, ROUND(SUM(kwhTotal),2) AS totalPower
FROM evCharge
GROUP BY userId
HAVING totalPower > 1000
ORDER BY totalPower DESC

-- Using the EVCharging table, Find the total time spent charging and total power output for each user. You should have three columns: 
-- userId, totalTimeHrs, and totalPwrKWH. Order the output from largest to smallest power consumption and limit the results to the top 5.

SELECT userId, SUM(ChargeTimeHrs) AS totalTimeHrs, SUM(kwhTotal) AS totalPwrKWH
FROM evCharge
GROUP BY userId
ORDER BY totalPwrKWH DESC
LIMIT 5

-- Using the EVCharging Table, Find the total time spent charging (totalTimeHrs), and the total power consumed(totalPwrKwh) 
-- from charging EV’s by each User on Thursdays. Round the answer to 2 deciaml points and list the out put in highest to lowest order. 
-- Limit the order to the top 25 users.

SELECT userId, ROUND(SUM(chargeTimeHrs),2) AS totalTimeHrs, ROUND(SUM(kwhTotal),2) AS totalPwrKWH
FROM evCharge
WHERE weekday = "Thu"
GROUP BY userId
ORDER BY totalPwrKWH DESC
LIMIT 25

-- The EV charging firm is wondering which charging Stations are being used the least. They would like to move these stations to a place 
-- with a greater need. Please find the total number of hours (sumTotalHrs) that each station is used. 
-- The output should contain all of the stations that have a total usage of less than 5 hours.

SELECT stationId, SUM(chargeTimeHrs) AS sumTotalHrs
FROM evCharge
GROUP BY stationId
HAVING sumTotalHrs < 5
ORDER BY sumTotalHrs ASC

-- Using factCharge and dimDay, find out which day of the week has the highest average charging time? Return dayOfWeek and avgChargeTime. 
-- Please round avgChargeTime to two decimal places and order the result set from highest to lowest avgChargeTime.

SELECT dimDay.dayOfWeek, ROUND(AVG(chargeTimeHrs),2) AS avgChargeTime
FROM factcharge
INNER JOIN dimDay
ON factcharge.dayID = dimDay.dateKey
GROUP BY dayID
ORDER BY avgChargeTime DESC

-- Using dimUser and factCharge, which app platform had the most amount of charging sessions. Return appPlatform and numCharges. 
-- Order the result set from highest to lowest number of charges.

SELECT dimUser.appPlatform, COUNT(sessionId) AS numCharges
FROM factCharge
INNER JOIN dimUser
ON factCharge.userId = dimUser.userId
GROUP BY appPlatform
ORDER BY numCharges DESC