create or replace PROCEDURE CUSTOMER_REGISTRATION(F_NAME IN CUSTOMER.FIRST_NAME%TYPE,L_NAME IN CUSTOMER.LAST_NAME%TYPE, MOB_NO IN CUSTOMER.MOBILE_NUMBER%TYPE, EMAIL IN CUSTOMER.EMAIL_ID%TYPE) AS
    C_ID CUSTOMER.CUSTOMER_ID%TYPE;
    VAL CUSTOMER.CUSTOMER_ID%TYPE;
    VAL1 NUMBER;
    W_ID WALLET.WALLET_ID%TYPE;
    EX_FNAME_NULL EXCEPTION;
    EX_LNAME_NULL EXCEPTION;
    USER_EXISTS_EXCEP EXCEPTION;
    MOB_NO_FORMAT EXCEPTION;
    EMAIL_ISSUE EXCEPTION;
BEGIN
    EXECUTE IMMEDIATE ('SELECT COUNT(*) FROM CUSTOMER') INTO VAL;
    IF VAL=0 THEN
        C_ID:=10000;

    ELSIF VAL>0 THEN
        SELECT CUSTOMER_ID INTO C_ID FROM CUSTOMER WHERE CUSTOMER_ID=(SELECT MAX(CUSTOMER_ID) FROM CUSTOMER);
        C_ID:=C_ID+1;
    END IF;

    IF LENGTH(UPPER(F_NAME)) IS NULL THEN
        RAISE EX_FNAME_NULL;
    END IF;

    IF LENGTH(UPPER(L_NAME)) IS NULL THEN
        RAISE EX_LNAME_NULL;
    END IF;

    IF MOB_NO < 1000000000 OR MOB_NO>9999999999 THEN
        RAISE MOB_NO_FORMAT;
    END IF;

    EXECUTE IMMEDIATE ('SELECT COUNT(*) from (SELECT 1 from dual where REGEXP_LIKE ('''||EMAIL||''', ''^[A-Za-z]+[A-Za-z0-9.]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$''))') INTO VAL1;

    IF LENGTH(UPPER(EMAIL)) IS NULL OR VAL1<1 THEN
        RAISE EMAIL_ISSUE;
    END IF;

    EXECUTE IMMEDIATE ('SELECT COUNT(*) FROM CUSTOMER WHERE UPPER(EMAIL_ID)=UPPER('''||EMAIL||''')') INTO VAL1;

    IF VAL1>0 THEN
        RAISE USER_EXISTS_EXCEP;
    END IF;

    WALLET_REGISTRATION(W_ID);

    --DBMS_OUTPUT.PUT_LINE('INSERT INTO WALLET VALUES ('||W_ID||',0)');
    --DBMS_OUTPUT.PUT_LINE('INSERT INTO CUSTOMER VALUES ('||C_ID||','''||F_NAME||''','''||L_NAME||''','||MOB_NO||','''||EMAIL||''',0,'||W_ID||')');
    EXECUTE IMMEDIATE('INSERT INTO WALLET VALUES ('||W_ID||',0)');
    EXECUTE IMMEDIATE('INSERT INTO CUSTOMER VALUES ('||C_ID||','''||F_NAME||''','''||L_NAME||''','||MOB_NO||','''||EMAIL||''',NULL,NULL,'||W_ID||')');
    --INSERT INTO CUSTOMER VALUES (C_ID,F_NAME,L_NAME,MOB_NO,EMAIL,0,W_ID);

    COMMIT;

    EXCEPTION
    WHEN EX_FNAME_NULL THEN
        DBMS_OUTPUT.PUT_LINE('FIRST NAME CANNOT BE EMPTY');
    WHEN EX_LNAME_NULL THEN
        DBMS_OUTPUT.PUT_LINE('LAST NAME CANNOT BE EMPTY');
    WHEN USER_EXISTS_EXCEP THEN
        DBMS_OUTPUT.PUT_LINE('USER ALREADY EXISTS, CANNOT BE REGISTERED AS NEW USER');
    WHEN MOB_NO_FORMAT THEN
        DBMS_OUTPUT.PUT_LINE('MOBILE NUMBER CANNOT BE NEGATIVE OR GREATER THAN 10 DIGITS');
    WHEN EMAIL_ISSUE THEN
        DBMS_OUTPUT.PUT_LINE('PLEASE ENTER EMAIL IN VALID FORMAT');
   -- WHEN OTHERS THEN
     --   DBMS_OUTPUT.PUT_LINE('ENTER VALID INPUTS');
    ROLLBACK;
END;