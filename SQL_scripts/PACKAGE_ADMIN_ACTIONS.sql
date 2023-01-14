create or replace PACKAGE ADMIN_ACTIONS
AS

    PROCEDURE CREATETABLES;

    PROCEDURE DELETE_OBJECTS(OBJNAME VARCHAR2,OBJTYPE VARCHAR2);

END ADMIN_ACTIONS;

create or replace PACKAGE BODY ADMIN_ACTIONS AS

    PROCEDURE CREATETABLES IS
       V_COUNTER NUMBER := 1;
       CURRENT_USER VARCHAR(10);
       EX_INCORRECT_USER EXCEPTION;
    BEGIN
        SELECT USER INTO CURRENT_USER FROM DUAL;
        IF (CURRENT_USER <> 'NAGPALM') THEN
            RAISE EX_INCORRECT_USER;
        END IF;
        SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'DISCOUNT' AND TABLESPACE_NAME = 'DATA';

        IF V_COUNTER = 0 THEN         

        EXECUTE IMMEDIATE '
        CREATE TABLE DISCOUNT(
        COUPON_ID NUMBER(2) PRIMARY KEY,
        COUPON_NAME VARCHAR(32) NOT NULL UNIQUE,
        COUPON_VALUE NUMBER(6,2) NOT NULL,
        COUPON_STATUS VARCHAR(10) DEFAULT ON NULL ''ACTIVE'' CHECK(COUPON_STATUS = ''ACTIVE'' OR COUPON_STATUS = ''INACTIVE'')
        )';

        EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM DISCOUNT FOR NAGPALM.DISCOUNT';

        END IF;

        SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'WALLET' AND TABLESPACE_NAME = 'DATA';

        IF V_COUNTER = 0 THEN         

        EXECUTE IMMEDIATE '
        CREATE TABLE WALLET(
        WALLET_ID NUMBER(6) PRIMARY KEY,
        BALANCE NUMBER(6,2) NOT NULL
        )';

        EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM WALLET FOR NAGPALM.WALLET';

        END IF;

        SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'DOCK' AND TABLESPACE_NAME = 'DATA';

        IF V_COUNTER = 0 THEN         

        EXECUTE IMMEDIATE '
        CREATE TABLE DOCK(
        DOCK_ID NUMBER(3) PRIMARY KEY,
        DOCK_NAME VARCHAR(256) NOT NULL,
        CITY VARCHAR(32) NOT NULL,
        STATE VARCHAR(32) NOT NULL,
        ZIP_CODE VARCHAR(5) NOT NULL,
        LATITUDE NUMBER(8,6) NOT NULL,
        LONGITUDE NUMBER(9,6) NOT NULL
        )';

        EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM DOCK FOR NAGPALM.DOCK';

        END IF;

        SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'BIKE' AND TABLESPACE_NAME = 'DATA';

        IF V_COUNTER = 0 THEN         

        EXECUTE IMMEDIATE '
        CREATE TABLE BIKE(
        BIKE_ID NUMBER(4) PRIMARY KEY,
        BIKE_MODEL VARCHAR(32) NOT NULL,
        DOCK_ID NUMBER(3) NOT NULL,
        FOREIGN KEY (DOCK_ID) REFERENCES DOCK (DOCK_ID),
        BIKE_STATUS VARCHAR(32) DEFAULT ON NULL ''AVAILABLE'' CHECK(BIKE_STATUS = ''AVAILABLE'' OR BIKE_STATUS = ''UNAVAILABLE'' OR BIKE_STATUS = ''INACTIVE'')
        )';

        EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM BIKE FOR NAGPALM.BIKE';

        END IF;

        SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'MEMBERSHIP' AND TABLESPACE_NAME = 'DATA';

        IF V_COUNTER = 0 THEN         

        EXECUTE IMMEDIATE '
        CREATE TABLE MEMBERSHIP(
        MEMBERSHIP_ID NUMBER(1) PRIMARY KEY,
        MEMBERSHIP_TYPE VARCHAR(32) NOT NULL CHECK(MEMBERSHIP_TYPE = ''WEEKLY'' OR MEMBERSHIP_TYPE = ''MONTHLY'' OR MEMBERSHIP_TYPE = ''YEARLY''),
        MEMBERSHIP_AMOUNT NUMBER(6,2) NOT NULL
        )';

        EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM MEMBERSHIP FOR NAGPALM.MEMBERSHIP';

        END IF;

        SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'CUSTOMER' AND TABLESPACE_NAME = 'DATA';

        IF V_COUNTER = 0 THEN         

        EXECUTE IMMEDIATE '
        CREATE TABLE CUSTOMER(
        CUSTOMER_ID NUMBER(5) PRIMARY KEY,
        FIRST_NAME VARCHAR(32) NOT NULL,
        LAST_NAME VARCHAR(32) NOT NULL,
        MOBILE_NUMBER NUMBER(10) NOT NULL,
        EMAIL_ID VARCHAR(32) NOT NULL UNIQUE,
        MEMBERSHIP_ID NUMBER(1),
        MEMBERSHIP_END_DATE DATE,
        CONSTRAINT FK_MEMBERSHIP FOREIGN KEY (MEMBERSHIP_ID)
        REFERENCES MEMBERSHIP (MEMBERSHIP_ID),
        WALLET_ID NUMBER(6) NOT NULL,
        CONSTRAINT FK_WALLET FOREIGN KEY (WALLET_ID)
        REFERENCES WALLET (WALLET_ID)
        )';

        EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM CUSTOMER FOR NAGPALM.CUSTOMER';

        END IF;

        SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'RENT' AND TABLESPACE_NAME = 'DATA';

        IF V_COUNTER = 0 THEN         

        EXECUTE IMMEDIATE '
        CREATE TABLE RENT(
        RENT_ID NUMBER(7) PRIMARY KEY,
        PICKUP_TIME DATE NOT NULL,
        DROP_TIME DATE,
        BIKE_ID NUMBER(4) NOT NULL,
        CONSTRAINT FK_BIKE FOREIGN KEY (BIKE_ID)
        REFERENCES BIKE (BIKE_ID),
        CUSTOMER_ID NUMBER(5) NOT NULL,
        CONSTRAINT FK_CUSTOMER FOREIGN KEY (CUSTOMER_ID)
        REFERENCES CUSTOMER (CUSTOMER_ID),
        COUPON_ID NUMBER(2),
        CONSTRAINT FK_COUPONID FOREIGN KEY (COUPON_ID)
        REFERENCES DISCOUNT (COUPON_ID),
        PAYMENT_STATUS VARCHAR(10) CHECK(PAYMENT_STATUS = ''PAID'' OR PAYMENT_STATUS = ''UNPAID'')
        )';

        EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM RENT FOR NAGPALM.RENT';

        END IF;

        SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'EMPLOYEE' AND TABLESPACE_NAME = 'DATA';

        IF V_COUNTER = 0 THEN         

        EXECUTE IMMEDIATE '
        CREATE TABLE EMPLOYEE(
        EMPLOYEE_ID NUMBER(8) PRIMARY KEY,
        FIRST_NAME VARCHAR(256) NOT NULL,
        LAST_NAME VARCHAR(256) NOT NULL,
        EMAIL_ID VARCHAR(256) NOT NULL UNIQUE,
        MOBILE_NUMBER NUMBER(10) NOT NULL,
        DOB DATE NOT NULL,
        GENDER VARCHAR(6) NOT NULL CHECK(GENDER = ''MALE'' OR GENDER = ''FEMALE'' OR GENDER = ''OTHER''),
        DESIGNATION VARCHAR(256) NOT NULL,
        REPORTING_MANAGER NUMBER(8),
        EMPLOYEE_STATUS VARCHAR(20) DEFAULT ON NULL ''AVAILABLE'' CHECK(EMPLOYEE_STATUS = ''AVAILABLE'' OR EMPLOYEE_STATUS = ''RESIGNED'')
        )';

        EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM EMPLOYEE FOR NAGPALM.EMPLOYEE';

        END IF;

        SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'TICKETING_QUEUE' AND TABLESPACE_NAME = 'DATA';

        IF V_COUNTER = 0 THEN         

        EXECUTE IMMEDIATE '
        CREATE TABLE TICKETING_QUEUE(
        TICKET_ID NUMBER(9) PRIMARY KEY,
        CUSTOMER_ID NUMBER(5) NOT NULL,
        CONSTRAINT FK_CUSTOMERS FOREIGN KEY (CUSTOMER_ID)
        REFERENCES CUSTOMER (CUSTOMER_ID),
        TICKET_AGENT NUMBER(8) NOT NULL,
        CONSTRAINT FK_AGENTS FOREIGN KEY (TICKET_AGENT)
        REFERENCES EMPLOYEE (EMPLOYEE_ID),
        TICKET_DESC VARCHAR(32) NOT NULL,
        TICKET_STATUS VARCHAR(10) NOT NULL CHECK(TICKET_STATUS = ''ASSIGNED'' OR TICKET_STATUS = ''CLOSED'')
        )';

        EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM TICKETING_QUEUE FOR NAGPALM.TICKETING_QUEUE';

        END IF;

        SELECT COUNT(*) INTO V_COUNTER FROM ALL_TABLES WHERE TABLE_NAME = 'EMPLOYEE_STATE' AND TABLESPACE_NAME = 'DATA';

        IF V_COUNTER = 0 THEN         

        EXECUTE IMMEDIATE '
        CREATE TABLE CUSTOMER_TECHNICIAN_STATE(
        EMPLOYEE_ID NUMBER(8) NOT NULL UNIQUE,
        CONSTRAINT FK_AGENT FOREIGN KEY (EMPLOYEE_ID)
        REFERENCES EMPLOYEE (EMPLOYEE_ID),
        CUSTOMER_TECHNICIAN_STATUS VARCHAR(32) DEFAULT ON NULL ''AVAILABLE'' CHECK(CUSTOMER_TECHNICIAN_STATUS = ''AVAILABLE'' OR CUSTOMER_TECHNICIAN_STATUS = ''UNAVAILABLE'')
        )';

        EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM CUSTOMER_TECHNICIAN_STATE FOR NAGPALM.CUSTOMER_TECHNICIAN_STATE';

        END IF;

        COMMIT;

        EXCEPTION
        WHEN EX_INCORRECT_USER THEN
            DBMS_OUTPUT.PUT_LINE('YOU CANNOT DO THIS ACTION. PLEASE CONTACT ADMIN');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
        ROLLBACK;

    END CREATETABLES;

    PROCEDURE DELETE_OBJECTS(OBJNAME VARCHAR2,OBJTYPE VARCHAR2)
IS
    V_COUNTER NUMBER := 0;
    CURRENT_USER VARCHAR(10);
    EX_INCORRECT_USER EXCEPTION;
BEGIN
    SELECT USER INTO CURRENT_USER FROM DUAL;
    IF (CURRENT_USER <> 'NAGPALM') THEN
        RAISE EX_INCORRECT_USER;
    END IF;
    IF OBJTYPE = 'SEQUENCE' THEN
        SELECT COUNT(*) INTO V_COUNTER FROM USER_SEQUENCES WHERE SEQUENCE_NAME = UPPER(OBJNAME);
            IF V_COUNTER > 0 THEN          
                EXECUTE IMMEDIATE 'DROP SEQUENCE ' || OBJNAME;        
            END IF; 
    END IF;
    IF OBJTYPE = 'USER' THEN
        SELECT COUNT(*) INTO V_COUNTER FROM ALL_USERS WHERE USERNAME = UPPER(OBJNAME);
            IF V_COUNTER > 0 THEN          
                EXECUTE IMMEDIATE 'DROP USER ' || OBJNAME;        
            END IF; 
    END IF;
    COMMIT;
    EXCEPTION
    WHEN EX_INCORRECT_USER THEN
        DBMS_OUTPUT.PUT_LINE('YOU CANNOT DO THIS ACTION. PLEASE CONTACT ADMIN');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    ROLLBACK;
END DELETE_OBJECTS;    

END ADMIN_ACTIONS;