#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\nwelcome to salon\n"

CHOICE_INPUT(){
  read SERVICE_ID_SELECTED
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    HOME "invalid choice select again"
  else
    SERVICE_NAME="$($PSQL "select name from services where service_id='$SERVICE_ID_SELECTED'")"
    if [[ -z $SERVICE_NAME ]]
    then
      HOME "That service is currently not available select one of the available ones"
    else
      echo "please enter your phone number to proceed"
      read CUSTOMER_PHONE
      CUSTOMER_NAME="$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")"
      echo $CUSTOMER_NAME
      if [[ -z $CUSTOMER_NAME ]]
      then
        echo "please enter your name to proceed"
        read CUSTOMER_NAME
        NEW_C="$($PSQL "insert into customers (phone, name) values('$CUSTOMER_PHONE','$CUSTOMER_NAME')")"
      fi
      echo "please enter the time youll come"
      read SERVICE_TIME
      CUSTOMER_ID="$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")"
      NEW_S="$($PSQL "insert into appointments (customer_id, service_id,time) values('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")"
      echo I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME.
    fi
  fi
}

HOME(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo "$($PSQL "select * from services")" | 
  while IFS="|" read SERVICE_ID SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  CHOICE_INPUT
}

HOME "select a service"
