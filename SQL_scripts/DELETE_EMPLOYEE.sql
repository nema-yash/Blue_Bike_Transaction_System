create or replace PROCEDURE DELETE_EMPLOYEE(E_ID IN EMPLOYEE.EMPLOYEE_ID%type) AS 
    ex_null_employee_id EXCEPTION;
    ex_NO_EMPLOYEE_FOUND EXCEPTION;
    ex_INVALID EXCEPTION;
    ex_CANNOT_DELETE_EMP EXCEPTION;
    EMP_INCORRECT_ID EXCEPTION;
    VAL NUMBER;
    VAL2 VARCHAR(10);
BEGIN
    IF E_ID IS NULL THEN
        raise ex_null_employee_id;
    end if;
    
    
    SELECT COUNT(EMPLOYEE_ID) INTO VAL FROM EMPLOYEE WHERE EMPLOYEE.EMPLOYEE_ID = E_ID;
    IF VAL = 0 THEN
        RAISE EMP_INCORRECT_ID;
    END IF;
    
    SELECT TICKETING_QUEUE.TICKET_STATUS INTO VAL2 FROM TICKETING_QUEUE WHERE TICKETING_QUEUE.TICKET_AGENT = E_ID;
    IF VAL2 = 'ASSIGNED' THEN
        raise ex_CANNOT_DELETE_EMP;
    ELSE
        UPDATE EMPLOYEE SET EMPLOYEE_STATUS = 'RESIGNED' WHERE EMPLOYEE_ID = E_ID;
        DELETE FROM CUSTOMER_TECHNICIAN_STATE WHERE EMPLOYEE_ID = E_ID;
        dbms_output.put_line('EMPLOYEE_ID: '|| E_ID || ' updated resigned status sucessfully!');
        commit;
           
    END IF;
       
  
    EXCEPTION
        WHEN EMP_INCORRECT_ID THEN
             DBMS_OUTPUT.PUT_LINE('ENTERED EMPLOYEE ID IS WRONG');
        when ex_null_employee_id then
            dbms_output.put_line('EMPLOYEE_ID cannot be null');
        when ex_NO_EMPLOYEE_FOUND then
            dbms_output.put_line('EMPLOYEE ID does not exist');
        WHEN ex_CANNOT_DELETE_EMP THEN
            DBMS_OUTPUT.PUT_LINE('Employee has a ticket assigned, cannot be deleted');
        when others then
            dbms_output.put_line('Error Message: ' || SQLERRM);
     ROLLBACK;
END DELETE_EMPLOYEE;
