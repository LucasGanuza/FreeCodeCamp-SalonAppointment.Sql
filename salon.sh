#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t -c" 
#--no-align
#--tuples-only
#-t

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"
 
MAIN_MENU() {
  if [[ $1 ]]
  then 
    echo -e "\n$1"
  fi

  echo -e "1) cut\n2) color\n3) dreadlocks"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in 
    1) ADD_APPOINTMENT 1;;
    2) ADD_APPOINTMENT 2;;
    3) ADD_APPOINTMENT 3;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac

}

ADD_APPOINTMENT () {
  
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

  if [[ -z $CUSTOMER_NAME ]] 
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    INSERT_NEW_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
  read SERVICE_TIME

  APPOINTMENT_ADDED=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  
  echo -e "\nI have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU
