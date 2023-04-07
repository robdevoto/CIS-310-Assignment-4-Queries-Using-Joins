--Rob DeVoto
--CIS 310-76
--SQL A4 uses Staywell_DB_Script
--11-16-2022

--1. For every property, list the management office number, address, monthly rent, 
--owner number, owner’s first name, and owner’s last name.
SELECT OFFICE_NUM, PROPERTY.ADDRESS, MONTHLY_RENT, OWNER.OWNER_NUM, FIRST_NAME, LAST_NAME
FROM PROPERTY, OWNER
WHERE PROPERTY.OWNER_NUM = OWNER.OWNER_NUM;

--2. For every completed or open service request, list the property ID, description, and status.
SELECT PROPERTY_ID, DESCRIPTION, STATUS
FROM SERVICE_REQUEST
WHERE STATUS IN ('COMPLETED', 'OPEN');

--3. For every service request for furniture replacement, list the property ID, 
--management office number, address, estimated hours, spent hours, owner number, and owner’s last name.
SELECT SR.PROPERTY_ID, OFFICE_NUM, P.ADDRESS, EST_HOURS, SPENT_HOURS, O.OWNER_NUM,O.LAST_NAME
FROM SERVICE_REQUEST SR INNER JOIN PROPERTY P 
	ON SR.PROPERTY_ID = P.PROPERTY_ID 
	INNER JOIN OWNER O 
	ON P.OWNER_NUM = O.OWNER_NUM
WHERE CATEGORY_NUMBER = '6'; --CATEGORY NUMBER FOR FURNITURE REPLACEMENT IS 6

--4. List the first and last names of all owners who own a two-bedroom property. 
--Use the IN operator in your query.
SELECT FIRST_NAME, LAST_NAME
FROM OWNER
WHERE OWNER_NUM IN (SELECT OWNER_NUM
						FROM PROPERTY
						WHERE BDRMS =2);

--5. Repeat Exercise 4, but this time use the EXISTS operator in your query.
SELECT FIRST_NAME, LAST_NAME, OWNER_NUM
FROM OWNER
WHERE EXISTS (SELECT *
					FROM PROPERTY
					WHERE OWNER.OWNER_NUM = PROPERTY.OWNER_NUM 
						AND BDRMS = '2');

--6. List the property IDs of any pair of properties that have the same number of bedrooms. 
--For example, one pair would be property ID 2 and property ID 6, because they both have four bedrooms. 
--The first property ID listed should be the major sort key and the second property ID should be the minor sort key.
SELECT P1.PROPERTY_ID, P2.PROPERTY_ID
FROM PROPERTY P1 LEFT JOIN PROPERTY P2 ON P1.PROPERTY_ID = P2.PROPERTY_ID
WHERE EXISTS (SELECT COUNT(*)
				FROM PROPERTY P
				WHERE P.BDRMS = P1.BDRMS
				GROUP BY BDRMS
				HAVING COUNT(*) = 2);

--7. List the square footage, owner number, owner last name, and owner first name 
--for each property managed by the Columbia City office.
SELECT SQR_FT, OW.OWNER_NUM, LAST_NAME, FIRST_NAME
FROM OWNER OW INNER JOIN PROPERTY P
	ON OW.OWNER_NUM = P.OWNER_NUM
	INNER JOIN OFFICE OFFICE
	ON P.OFFICE_NUM = OFFICE.OFFICE_NUM
WHERE P.OFFICE_NUM = 1; --COLUMBIA CITY OFFICE NUMBER IS 1

--8. Repeat Exercise 7, but this time include only those properties with three bedrooms.
SELECT SQR_FT, OW.OWNER_NUM, LAST_NAME, FIRST_NAME, P.BDRMS
FROM OWNER OW INNER JOIN PROPERTY P
	ON OW.OWNER_NUM = P.OWNER_NUM
	INNER JOIN OFFICE OFFICE
	ON P.OFFICE_NUM = OFFICE.OFFICE_NUM
WHERE P.OFFICE_NUM = 1 AND BDRMS = 3; --COLUMBIA CITY OFFICE NUMBER IS 1

--9. List the office number, address, and monthly rent for properties whose owners 
--live in Washington state or own two-bedroom properties.
SELECT OFFICE_NUM, P.ADDRESS, MONTHLY_RENT
FROM OWNER O INNER JOIN PROPERTY P ON O.OWNER_NUM = P.OWNER_NUM
WHERE O.STATE = 'WA' OR P.BDRMS = 2;

--10. List the office number, address, and monthly rent for properties whose owners 
--live in Washington state and own a two-bedroom property.
SELECT OFFICE_NUM, P.ADDRESS, MONTHLY_RENT
FROM OWNER O INNER JOIN PROPERTY P ON O.OWNER_NUM = P.OWNER_NUM
WHERE O.STATE = 'WA' AND P.BDRMS = 2;

--11. List the office number, address, and monthly rent for properties whose owners 
--live in Washington state but do not own two-bedroom properties.
SELECT OFFICE_NUM, P.ADDRESS, MONTHLY_RENT
FROM OWNER O INNER JOIN PROPERTY P ON O.OWNER_NUM = P.OWNER_NUM
WHERE O.STATE = 'WA' AND P.BDRMS <> 2;

--12. Find the service ID and property ID for each service request whose estimated hours 
--are greater than the number of estimated hours of at least one service request on which 
--the category number is 5.
SELECT SERVICE_ID, PROPERTY_ID
FROM SERVICE_REQUEST
WHERE EST_HOURS > ANY (SELECT EST_HOURS
							FROM SERVICE_REQUEST
							WHERE CATEGORY_NUMBER = 5);

--13. Find the service ID and property ID for each service request whose estimated hours 
--are greater than the number of estimated hours on every service request on which 
--the category number is 5.
SELECT SERVICE_ID, PROPERTY_ID
FROM SERVICE_REQUEST
WHERE EST_HOURS > ALL (SELECT EST_HOURS
							FROM SERVICE_REQUEST
							WHERE CATEGORY_NUMBER = 5);

--14. List the address, square footage, owner number, service ID, number of estimated hours, 
--and number of spent hours for each service request on which the category number is 4.
SELECT ADDRESS, SQR_FT, OWNER_NUM, SERVICE_ID, EST_HOURS, SPENT_HOURS
FROM PROPERTY P INNER JOIN SERVICE_REQUEST SR ON P.PROPERTY_ID = SR.PROPERTY_ID
WHERE CATEGORY_NUMBER = 4;

--15. Repeat Exercise 14, but this time be sure each property is included regardless of whether 
--the property currently has any service requests for category 4.
SELECT ADDRESS, SQR_FT, OWNER_NUM, SERVICE_ID, EST_HOURS, SPENT_HOURS
FROM PROPERTY P INNER JOIN SERVICE_REQUEST SR ON P.PROPERTY_ID = SR.PROPERTY_ID;
