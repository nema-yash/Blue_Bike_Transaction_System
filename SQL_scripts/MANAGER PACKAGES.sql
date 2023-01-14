create or replace PACKAGE MANAGER_ACTIONS
AS

    PROCEDURE ADD_EMPLOYEE(
    F_NAME IN EMPLOYEE.FIRST_NAME%TYPE,
    L_NAME IN EMPLOYEE.LAST_NAME%TYPE, 
    MOB_NO IN NUMBER, 
    EMAIL IN EMPLOYEE.EMAIL_ID%TYPE, 
    DOB IN EMPLOYEE.DOB%TYPE, 
    GENDER IN EMPLOYEE.GENDER%TYPE,  
    DESIGNATION IN EMPLOYEE.DESIGNATION%TYPE,
    REPORTING_MANAGER IN NUMBER DEFAULT NULL
    );
    
    PROCEDURE DELETE_BIKE(
    B_ID IN BIKE.BIKE_ID%type
    );
    
    PROCEDURE DELETE_DISCOUNT(
    D_ID IN DISCOUNT.COUPON_ID%type
    );
    
    PROCEDURE DELETE_EMPLOYEE(
    E_ID IN EMPLOYEE.EMPLOYEE_ID%type
    );
    
    PROCEDURE ADD_DISCOUNT(
    C_NAME IN DISCOUNT.COUPON_NAME%TYPE, C_VALUE IN DISCOUNT.COUPON_VALUE%TYPE
    );

END MANAGER_ACTIONS;

create or replace PACKAGE BODY MANAGER_ACTIONS AS
        
        PROCEDURE ADD_EMPLOYEE(
        F_NAME IN EMPLOYEE.FIRST_NAME%TYPE,
        L_NAME IN EMPLOYEE.LAST_NAME%TYPE, 
        MOB_NO IN NUMBER, 
        EMAIL IN EMPLOYEE.EMAIL_ID%TYPE, 
        DOB IN EMPLOYEE.DOB%TYPE, 
        GENDER IN EMPLOYEE.GENDER%TYPE,  
        DESIGNATION IN EMPLOYEE.DESIGNATION%TYPE,
        REPORTING_MANAGER IN NUMBER DEFAULT NULL) 
    AS
        E_ID NUMBER;
        EX_FNAME_NULL EXCEPTION;
        EX_LNAME_NULL EXCEPTION;
        USER_EXISTS_EXCEP EXCEPTION;
        VAL EMPLOYEE.EMPLOYEE_ID%TYPE;
        EMAIL_ISSUE EXCEPTION;
        MOB_NO_FORMAT EXCEPTION;
        INVALID_APPT_DATE EXCEPTION;
        EX_DESN_NULL EXCEPTION;
        EX_MANAGER_NULL EXCEPTION;
        TODAYS_DATE DATE := SYSDATE;
        VAL1 NUMBER;
        VAL2 EMPLOYEE.DOB%TYPE;
        appt_date DATE;
    
    BEGIN
        EXECUTE IMMEDIATE ('SELECT COUNT(*) FROM EMPLOYEE') INTO VAL;
    
        IF VAL=0 THEN
            E_ID:=10000000;
        ELSIF VAL>0 THEN
            SELECT EMPLOYEE_ID INTO E_ID FROM EMPLOYEE WHERE EMPLOYEE_ID=(SELECT MAX(EMPLOYEE_ID) FROM EMPLOYEE);
            E_ID:=E_ID+1;
        END IF;
    
    
        IF LENGTH(UPPER(F_NAME)) IS NULL THEN
            RAISE EX_FNAME_NULL;
        END IF;
    
    
        IF LENGTH(UPPER(L_NAME)) IS NULL THEN
            RAISE EX_LNAME_NULL;
        END IF;
    
    
        EXECUTE IMMEDIATE ('SELECT COUNT(*) FROM EMPLOYEE WHERE UPPER(EMAIL_ID)=UPPER('''||EMAIL||''') ') INTO VAL1;
    
        IF VAL1>0 THEN
            RAISE USER_EXISTS_EXCEP;
        END IF;
    
    
        IF MOB_NO < 1000000000 OR MOB_NO>9999999999 THEN
            RAISE MOB_NO_FORMAT;
        END IF;
    
        EXECUTE IMMEDIATE ('SELECT COUNT(*) from (SELECT 1 from dual where REGEXP_LIKE ('''||EMAIL||''', ''^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$''))') INTO VAL1;
    
    
        IF LENGTH(UPPER(EMAIL)) IS NULL OR VAL1<1 THEN
            RAISE EMAIL_ISSUE;
        END IF;
    
    
        IF LENGTH(UPPER(DESIGNATION)) IS NULL THEN
            RAISE EX_DESN_NULL;
        END IF;    
    
        IF trunc(DOB) > trunc(sysdate) THEN
            RAISE INVALID_APPT_DATE;
        END IF;
    
    
        INSERT INTO EMPLOYEE VALUES (E_ID,F_NAME,L_NAME,EMAIL,MOB_NO,DOB,GENDER,DESIGNATION,REPORTING_MANAGER,'AVAILABLE');
    
        IF DESIGNATION='CUSTOMER TECHNICIAN' THEN
            INSERT INTO CUSTOMER_TECHNICIAN_STATE VALUES (E_ID,'AVAILABLE');
        END IF;
    
        COMMIT;
    
        EXCEPTION
        WHEN EX_FNAME_NULL THEN
            DBMS_OUTPUT.PUT_LINE('FIRST NAME CANNOT BE EMPTY');
        WHEN EX_LNAME_NULL THEN
            DBMS_OUTPUT.PUT_LINE('LAST NAME CANNOT BE EMPTY');
        WHEN USER_EXISTS_EXCEP THEN
            DBMS_OUTPUT.PUT_LINE('EMPLOYEE ALREADY EXISTS, CANNOT BE REGISTERED AS NEW EMPLOYEE');
        WHEN MOB_NO_FORMAT THEN
            DBMS_OUTPUT.PUT_LINE('MOBILE NUMBER CANNOT BE NEGATIVE OR GREATER THAN 10 DIGITS');
        WHEN EMAIL_ISSUE THEN
            DBMS_OUTPUT.PUT_LINE('PLEASE ENTER EMAIL IN VALID FORMAT');
        WHEN INVALID_APPT_DATE THEN
             DBMS_OUTPUT.PUT_LINE('PLEASE ENTER DATE OF BIRTH NO FUTURE VALUES ALLOWED' );
        WHEN EX_DESN_NULL THEN
            DBMS_OUTPUT.PUT_LINE('DESIGNATION CANNOT BE EMPTY');
        WHEN EX_MANAGER_NULL THEN
            DBMS_OUTPUT.PUT_LINE('REPORTING MANAGER CANNOT BE EMPTY');    
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ENTER VALID INPUTS ');
        ROLLBACK;
    END ADD_EMPLOYEE;
    
        PROCEDURE DELETE_BIKE(B_ID IN BIKE.BIKE_ID%type) AS 
            ex_null_bike_id EXCEPTION;
            ex_NO_BIKE_FOUND EXCEPTION;
            ex_INVALID EXCEPTION;
            BIKE_INCORRECT_ID EXCEPTION;
            BIKE_UNAVAILABLE EXCEPTION;
            VAL NUMBER;
        
        BEGIN
        IF B_ID IS NULL THEN
                raise ex_null_bike_id;
            end if;
                
                SELECT COUNT(BIKE_ID) INTO VAL FROM BIKE WHERE BIKE.BIKE_ID = B_ID;
             IF VAL = 0 THEN
                RAISE BIKE_INCORRECT_ID;
            END IF;
            
            SELECT COUNT(BIKE_ID) INTO VAL FROM BIKE WHERE BIKE.BIKE_ID = B_ID AND BIKE_STATUS = 'UNAVAILABLE';
            IF VAL > 0 THEN
                RAISE BIKE_UNAVAILABLE;
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
                when BIKE_UNAVAILABLE then
                    dbms_output.put_line('BIKE IS BEING USED CANNOT DELETE IT');
                when others then
                    dbms_output.put_line('Error Message: ' || SQLERRM);
                ROLLBACK;
        
        END DELETE_BIKE;
        
        PROCEDURE DELETE_DISCOUNT(D_ID IN DISCOUNT.COUPON_ID%type) AS 
            ex_null_coupon_id EXCEPTION;
            ex_NO_COUPON_FOUND EXCEPTION;
            ex_INVALID EXCEPTION;
            DISCOUNT_INCORRECT_ID EXCEPTION;
            VAL NUMBER;
        BEGIN
         
                IF D_ID IS NULL THEN
                    raise ex_null_coupon_id;
                END IF;
                 SELECT COUNT(COUPON_ID) INTO VAL FROM DISCOUNT WHERE DISCOUNT.COUPON_ID = D_ID;
             IF VAL = 0 THEN
                RAISE DISCOUNT_INCORRECT_ID;
            END IF;
                UPDATE DISCOUNT SET COUPON_STATUS = 'INACTIVE' WHERE COUPON_ID = D_ID;
                dbms_output.put_line('COUPON_ID: '|| D_ID || ' updated INACTIVE status sucessfully!');
                commit;
        
          EXCEPTION
                WHEN DISCOUNT_INCORRECT_ID THEN
                     dbms_output.put_line('ENTERED DISCOUNT ID IS WRONG');
                when ex_null_coupon_id then
                    dbms_output.put_line('COUPON_ID cannot be null');
                when others then
                    dbms_output.put_line('Error Message: ' || SQLERRM);
                ROLLBACK;
        END DELETE_DISCOUNT;
        
        PROCEDURE DELETE_EMPLOYEE(E_ID IN EMPLOYEE.EMPLOYEE_ID%type) AS 
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
        
        PROCEDURE ADD_DISCOUNT(C_NAME IN DISCOUNT.COUPON_NAME%TYPE, C_VALUE IN DISCOUNT.COUPON_VALUE%TYPE) IS
            V_COUNTER NUMBER := 0;
            C_AMOUNT NUMBER;
            CURRENT_USER VARCHAR(10);
            EX_INCORRECT_USER EXCEPTION;
            EX_NO_TABLE EXCEPTION;
            EX_C_NAME_EXISTS EXCEPTION;
            EX_C_NAME_NULL EXCEPTION;
            EX_AMOUNT_NEGATIVE EXCEPTION;
            EX_AMOUNT_NULL EXCEPTION;
        BEGIN
            SELECT USER INTO CURRENT_USER FROM DUAL;
            IF (CURRENT_USER <> 'NAGPALM' OR CURRENT_USER <>'MNGR') THEN
                RAISE EX_INCORRECT_USER;
            END IF;
        
            SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'DISCOUNT' AND TABLESPACE_NAME = 'DATA';
            IF V_COUNTER = 0 THEN
                RAISE EX_NO_TABLE;
            END IF;
        
            IF C_NAME IS NULL THEN
                RAISE EX_C_NAME_NULL;
            END IF;
        
            IF C_VALUE IS NULL OR C_VALUE>100 THEN
                RAISE EX_AMOUNT_NULL;
            END IF;
        
            SELECT COUNT(*) INTO V_COUNTER FROM DISCOUNT WHERE COUPON_NAME = C_NAME;
            IF V_COUNTER > 0 THEN
                SELECT COUPON_VALUE INTO C_AMOUNT FROM DISCOUNT WHERE COUPON_NAME = C_NAME;
                IF C_AMOUNT = C_VALUE THEN
                    RAISE EX_C_NAME_EXISTS;
                ELSE
                    UPDATE DISCOUNT SET COUPON_VALUE = C_VALUE WHERE COUPON_NAME = C_NAME;
                    SELECT COUPON_VALUE INTO C_AMOUNT FROM DISCOUNT WHERE COUPON_NAME = C_NAME;
                    DBMS_OUTPUT.PUT_LINE('COUPON UPDATED: ' || C_NAME || ' UPDATED VALUE: ' || C_AMOUNT);
                END IF;
            ELSE
                INSERT INTO DISCOUNT VALUES(((SELECT MAX(COUPON_ID) FROM DISCOUNT) + 1),C_NAME,C_VALUE,'ACTIVE');
                SELECT COUPON_VALUE INTO C_AMOUNT FROM DISCOUNT WHERE COUPON_NAME = C_NAME;
                DBMS_OUTPUT.PUT_LINE('COUPON ADDED: ' || C_NAME || ' VALUE: ' || C_AMOUNT);
            END IF;
        
            COMMIT;
        EXCEPTION
            WHEN EX_INCORRECT_USER THEN
                DBMS_OUTPUT.PUT_LINE('YOU CANNOT DO THIS ACTION. PLEASE CONTACT ADMIN');
            WHEN EX_NO_TABLE THEN
                DBMS_OUTPUT.PUT_LINE('TABLE DOES NOT EXIST. PLEAE CONTACT ADMIN');
            WHEN EX_C_NAME_EXISTS THEN
                DBMS_OUTPUT.PUT_LINE('COUPON NAME ALREADY EXIST');
            WHEN EX_AMOUNT_NULL THEN
                DBMS_OUTPUT.PUT_LINE('COUPON VALUE CANNOT BE EMPTY OR GREATER THAN 100%');
            WHEN EX_C_NAME_NULL THEN
                DBMS_OUTPUT.PUT_LINE('COUPON VALUE CANNOT BE EMPTY OR NULL');
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
            ROLLBACK;
        END ADD_DISCOUNT;

END MANAGER_ACTIONS;

CREATE OR REPLACE PUBLIC SYNONYM MANAGER_ACTIONS for NAGPALM.MANAGER_ACTIONS;