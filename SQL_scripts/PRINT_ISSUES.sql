create or replace PROCEDURE PRINT_ISSUE_OPTIONS IS
BEGIN
  DBMS_OUTPUT.PUT_LINE('Select the kind of issue you are facing ');
   DBMS_OUTPUT.PUT_LINE('1.Registration issue ');
   DBMS_OUTPUT.PUT_LINE('2.Wallet setup ');
   DBMS_OUTPUT.PUT_LINE('3.Payment Deduction issue');
   DBMS_OUTPUT.PUT_LINE('4.Booking issue');
   DBMS_OUTPUT.PUT_LINE('5.Coupon issue');
   DBMS_OUTPUT.PUT_LINE('6.Discount usage issue');
   DBMS_OUTPUT.PUT_LINE('7.Bike availability issue');
   DBMS_OUTPUT.PUT_LINE('8.Bike condition issue');
   DBMS_OUTPUT.PUT_LINE('9.Membership renewal issues');
   DBMS_OUTPUT.PUT_LINE('10.Other Issues');
END;
