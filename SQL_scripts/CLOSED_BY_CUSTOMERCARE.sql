create or replace PROCEDURE CLOSED_BY_CUSTOMERCARE(T_ID IN TICKETING_QUEUE.TICKET_ID%TYPE) AS 
EX_TICKETID_NULL EXCEPTION;
EX_NO_TICKET_FOUND EXCEPTION;
EX_ALREADY_CLOSED EXCEPTION;
TICKET_INCORRECT_ID EXCEPTION;
VAL2 NUMBER;
COUNTER NUMBER;
VAL NUMBER;

BEGIN
  IF T_ID IS NULL THEN
            RAISE EX_NO_TICKET_FOUND;
        END IF;
        SELECT COUNT(TICKET_ID) INTO VAL FROM TICKETING_QUEUE WHERE TICKETING_QUEUE.TICKET_ID = T_ID;
     IF VAL = 0 THEN
        RAISE TICKET_INCORRECT_ID;
    END IF;
 SELECT COUNT (*) INTO COUNTER FROM TICKETING_QUEUE WHERE TICKETING_QUEUE.TICKET_ID = T_ID AND TICKET_STATUS = 'CLOSED';
 IF COUNTER > 0 THEN
    RAISE EX_ALREADY_CLOSED;
 END IF;
UPDATE TICKETING_QUEUE
SET TICKET_STATUS = 'CLOSED' WHERE  TICKETING_QUEUE.TICKET_ID = T_ID;

SELECT TICKET_AGENT INTO VAL2 FROM TICKETING_QUEUE WHERE  TICKETING_QUEUE.TICKET_ID = T_ID;
UPDATE CUSTOMER_TECHNICIAN_STATE 
SET CUSTOMER_TECHNICIAN_STATUS = 'AVAILABLE' WHERE CUSTOMER_TECHNICIAN_STATE.EMPLOYEE_ID = VAL2;
DBMS_OUTPUT.PUT_LINE('Ticket Closed');
 COMMIT;
  EXCEPTION
  WHEN TICKET_INCORRECT_ID THEN
  DBMS_OUTPUT.PUT_LINE('ENTERED TICKET ID IS WRONG');
    WHEN EX_TICKETID_NULL THEN
        DBMS_OUTPUT.PUT_LINE('TICKET ID CANNOT BE EMPTY');
     when EX_NO_TICKET_FOUND then
            dbms_output.put_line('TICKET ID does not exist');
    WHEN EX_ALREADY_CLOSED THEN
        DBMS_OUTPUT.PUT_LINE('Ticket is already closed');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    ROLLBACK;
END CLOSED_BY_CUSTOMERCARE;
