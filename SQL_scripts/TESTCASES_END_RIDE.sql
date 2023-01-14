
SET SERVEROUTPUT ON;

UPDATE RENT 
SET PAYMENT_STATUS = NULL, DROP_TIME = NULL, PICKUP_TIME = CURRENT_DATE - INTERVAL '63' MINUTE
WHERE RENT_ID = 1000006 ;
EXECUTE END_RIDE('BRENDA.ROBINSON@GMAIL.COM',100,'BEBLUE');



SELECT * FROM CUSTOMER;
SELECT * FROM RENT;
SELECT * FROM BIKE;

--Sucessfully paid,Test case where ride has been started (pickup time is recorded, drop_time and payment_status are NULL) with coupon 
EXECUTE END_RIDE('BRENDA.ROBINSON@GMAIL.COM',100,'BEBLUE');

--Sucessfully paid,Test case where ride has been started (pickup time is recorded, drop_time and payment_status are NULL) without coupon
EXECUTE END_RIDE('BRENDA.ROBINSON@GMAIL.COM',100,NULL);

-- null email
EXECUTE END_RIDE(NULL,100,'BEBLUE');

--null dock id
EXECUTE END_RIDE('BRENDA.ROBINSON@GMAIL.COM',NULL,'BEBLUE');

--wrong dockid
EXECUTE END_RIDE('BRENDA.ROBINSON@GMAIL.COM',454,'BEBLUE'); 

--wrong coupon id
EXECUTE END_RIDE('BRENDA.ROBINSON@GMAIL.COM',100,'BUE');

--wrong emailid
EXECUTE END_RIDE('NEMO.ERTYUN@GMAIL.COM',100,'BEBLUE');

--email id in wrong format 
EXECUTE END_RIDE('BRENDA.ROBINSONMAIL.COM',102,'BEBLUE');

--person who has not started the ride
EXECUTE END_RIDE('YASH.NEMA@GMAIL.COM',103,'BEBLUE');

--Paid person tries again
EXECUTE END_RIDE('JOE.ROBINSON@GMAIL.COM',101,'SAVE05');

--PERSON TRIES TO Pay with inactive coupon status
EXECUTE END_RIDE('BRENDA.ROBINSON@GMAIL.COM',103,'TEST4');

--Person without membership 
UPDATE CUSTOMER 
SET MEMBERSHIP_ID = NULL,MEMBERSHIP_END_DATE = NULL WHERE CUSTOMER_ID = 10001 ;
EXECUTE END_RIDE('BRENDA.ROBINSON@GMAIL.COM',103,'BEBLUE')
