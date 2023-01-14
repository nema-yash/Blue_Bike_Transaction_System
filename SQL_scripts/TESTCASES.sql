SET SERVEROUTPUT ON;

-- Test ADD_BALANCE PROCEDURE
-- Successfully adds balance
EXECUTE ADD_BALANCE('DIANE.EVANS@YAHOO.COM',50); 

-- Null email id
EXECUTE ADD_BALANCE(NULL,50); 

-- Negative Balance
EXECUTE ADD_BALANCE('DIANE.EVANS@YAHOO.COM',-50); 

-- NULL Balance
EXECUTE ADD_BALANCE('DIANE.EVANS@YAHOO.COM',NULL); 

-- Test ADD_EMPLOYEE PROCEDURE
-- Successfully add employee
EXECUTE ADD_EMPLOYEE('SAMUEL','TUCKER',8572307645,'SAMUEL.TUCKER@BBIKES.COM','19-JUN-90', 'MALE','CUSTOMER TECHNICIAN', 10000000);

--Null First Name
EXECUTE ADD_EMPLOYEE(NULL,'TUCKER',8572307645,'SAMUEL.TUCKER@BBIKES.COM','19-JUN-90', 'MALE','CUSTOMER TECHNICIAN', 10000000);

--Null Last Name
EXECUTE ADD_EMPLOYEE('SAMUEL',NULL,8572307645,'SAMUEL.TUCKER@BBIKES.COM','19-JUN-90', 'MALE','CUSTOMER TECHNICIAN', 10000000);

--Same Employee cannot be added again
EXECUTE ADD_EMPLOYEE('SAMUEL','TUCKER',8572307645,'SAMUEL.TUCKER@BBIKES.COM','19-JUN-90', 'MALE','CUSTOMER TECHNICIAN', 10000000);

--Incorrect Mobile Number
EXECUTE ADD_EMPLOYEE('EMANUEL','KIPS',99999999999,'EMANUEL.KIPS@BBIKES.COM','29-JUN-85', 'MALE','CUSTOMER TECHNICIAN', 10000000);

--Null Email id
EXECUTE ADD_EMPLOYEE('SAMUEL','TUCKER',8572307645,NULL,'19-JUN-90', 'MALE','CUSTOMER TECHNICIAN', 10000000);

--Null Designation
EXECUTE ADD_EMPLOYEE('EMANUEL','KIPS',8572307645,'EMANUEL.KIPS@BBIKES.COM','29-JUN-85', 'MALE',NULL, 10000000);

--Future Date of birth
EXECUTE ADD_EMPLOYEE('EMANUEL','KIPS',8572307645,'EMANUEL.KIPS@BBIKES.COM','29-MAY-22', 'MALE','CUSTOMER TECHNICIAN', 10000000);

-- Test TICKET_CREATION PROCEDURE
--Successful Ticket Creation
EXECUTE TICKET_CREATION('BENJAMIN.RUSSELL@CHARTER.NET','BIKE CONDITION ISSUE');

--Null Ticket Issue
EXECUTE TICKET_CREATION('BRENDA.ROBINSON@GMAIL.COM',NULL);

-- Null Email ID
EXECUTE TICKET_CREATION(NULL,NULL);

-- Spelling mistake of Ticket Issue
EXECUTE TICKET_CREATION('BRENDA.ROBINSON@GMAIL.COM','COUPON ISSUEE');


-- Test CLOSED_BY_CUSTOMERCARE PROCEDURE
-- Successfully closed ticket
EXECUTE CLOSED_BY_CUSTOMERCARE(100000004);

-- Pass Null ticket
EXECUTE CLOSED_BY_CUSTOMERCARE(NULL);

--Pass wrong ticket id
EXECUTE CLOSED_BY_CUSTOMERCARE(1000000043);


--Test CUSTOMER_REGISTRATION PROCEDURE
--Successfully register customer
EXECUTE CUSTOMER_REGISTRATION('YASH','NEMA',8450997531,'YASH.NEMA@GMAIL.COM');

--Same customer cannot be registered again
EXECUTE CUSTOMER_REGISTRATION('YASH','NEMA',8450997531,'YASH.NEMA@GMAIL.COM');

--Null First Name
EXECUTE CUSTOMER_REGISTRATION(NULL,'NEMA',8450997531,'YASH.NEMA@GMAIL.COM');

--Null Last Name
EXECUTE CUSTOMER_REGISTRATION('YASH',NULL,8450997531,'YASH.NEMA@GMAIL.COM');

--Incorrect Mobile number
EXECUTE CUSTOMER_REGISTRATION('YASH','NEMA',84590997531,'YASH.NEMA@GMAIL.COM');

--Null EmailID
EXECUTE CUSTOMER_REGISTRATION('YASH','NEMA',8450997531,NULL);


--Test DELETE_EMPLOYEE PROCEDURE
--Test Agent who has Ticket Status Assigned
EXECUTE DELETE_EMPLOYEE(10000008);

--Successful delete test
EXECUTE DELETE_EMPLOYEE(10000002);


--Pass Wrong Employee ID
EXECUTE DELETE_EMPLOYEE(1000001278);

--Pass Null Employee ID
EXECUTE DELETE_EMPLOYEE(NULL);

