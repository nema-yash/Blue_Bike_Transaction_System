SET SERVEROUTPUT ON;

--TESTING UPDATE_CUSTOMER_DETAILS

--NORMAL DETAILS
EXECUTE update_customer_details('JOE.ROBINSON@GMAIL.COM','LAST NAME','JAMESON');

--FIRST NAME EXCEPTION
EXECUTE update_customer_details('NANCY.BAKER@GMAIL.COM','FIRST NAME','');

--LAST NAME NULL
EXECUTE update_customer_details('NANCY.BAKER@GMAIL.COM','LAST NAME','');

--MOBILE NUMBER FAULTY
EXECUTE update_customer_details('NANCY.BAKER@GMAIL.COM','MOBILE NUMBER',88775554);

--EMAIL ID ISSUE
EXECUTE update_customer_details('NANCY.BAKER@GMAIL.COM','EMAIL ID','NAN.BAKERGMAIL.COM');

--INVALID ISSUE
EXECUTE update_customer_details('NANCY.BAKER@GMAIL.COM','OTHER','');