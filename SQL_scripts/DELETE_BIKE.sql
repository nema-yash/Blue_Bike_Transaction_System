create or replace PROCEDURE DELETE_BIKE(B_ID IN BIKE.BIKE_ID%type) AS 
    ex_null_bike_id EXCEPTION;
    ex_NO_BIKE_FOUND EXCEPTION;
    ex_INVALID EXCEPTION;
    BIKE_INCORRECT_ID EXCEPTION;
    VAL NUMBER;
    
BEGIN
IF B_ID IS NULL THEN
        raise ex_null_bike_id;
    end if;
        
        SELECT COUNT(BIKE_ID) INTO VAL FROM BIKE WHERE BIKE.BIKE_ID = B_ID;
     IF VAL = 0 THEN
        RAISE BIKE_INCORRECT_ID;
    END IF;

             UPDATE BIKE SET BIKE_STATUS = 'INACTIVE' WHERE BIKE_ID = B_ID;
                dbms_output.put_line('BIKE_ID: '|| B_ID || ' deleted sucessfully!');
                commit;
            
        

  EXCEPTION
          WHEN BIKE_INCORRECT_ID THEN
          DBMS_OUTPUT.PUT_LINE('ENTERED BIKE ID IS WRONG');
        when ex_null_bike_id then
            dbms_output.put_line('BIKE_ID cannot be null');
        when ex_NO_BIKE_FOUND then
            dbms_output.put_line('BIKE ID does not exist');
        when others then
            dbms_output.put_line('Error Message: ' || SQLERRM);

END DELETE_BIKE;
