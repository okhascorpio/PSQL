#!/bin/bash
PSQL="psql -t --username=freecodecamp --dbname=salon -c"
#$($PSQL "TRUNCATE customers,appointments")


echo -e "\n~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?\n"

MAIN_MENU(){
  echo -e "\n 
    1) Facial
    2) Menicure
    3) Pedicure
    
  Please enter Service id"

  read SERVICE_ID_SELECTED
  
  case $SERVICE_ID_SELECTED in
    1) echo Facial ;;
    2) echo Menicure ;;
    3) echo Pedicure ;;
    *) MAIN_MENU ;;
  esac
    SERVICE_NAME=$($PSQL "select name from services where service_id=' $SERVICE_ID_SELECTED'")
}

MAIN_MENU
echo "Please enter phone number"
read CUSTOMER_PHONE

# find customer id in database, if any
#CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
     
# if not found
  if [[ -z $CUSTOMER_ID ]]
  then
    echo "Customer not found"
    echo "Please enter name"
    read CUSTOMER_NAME 
    # Enter customer 
    INSERT_CUSTOMER_RESULT=$($PSQL "insert into customers(name,phone) values('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    # get new customer id
    CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
    CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
     
  fi 
echo "please enter time"
read SERVICE_TIME

# insert appointment
INSERT_APPOINTMENT_RESULT=$($PSQL "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")

# appointment created message
echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME.\n"
