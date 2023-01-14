create or replace PROCEDURE DELETE_DISCOUNT(D_ID IN DISCOUNT.COUPON_ID%type) AS 
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
END DELETE_DISCOUNT;
