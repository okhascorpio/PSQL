#!/bin/bash
PSQL="psql -A -t -U freecodecamp -d periodic_table -c"

# if no argument is provided
if [ $# -eq 0 ]
  then  
    echo "Please provide an element as an argument."
    exit
fi


# if argument is a number
if [[ $1 =~ ^[0-9]+$ ]] 
  then
    ELEMENT_DATA=$($PSQL "select * from elements inner join properties using(atomic_number) where atomic_number=$1")
  
  # if argument is text
  else
    ELEMENT_DATA=$($PSQL "select * from elements inner join properties using(atomic_number) where name='$1' or symbol='$1'")
  
fi

# if element is not found in database
if [[ -z $ELEMENT_DATA ]]
  then
    echo "I could not find that element in the database."

  # if element is found in database
  else
  # extract individual data from the ELEMENT_DATA
  echo "$ELEMENT_DATA" | while IFS="|" read AT_NUM SYMB NAME AT_MASS MELT_PT BOIL_PT TYPE_ID
  do
    # find element type 
    EL_TYPE=$($PSQL "select type from types where type_id='$TYPE_ID'")
  
    # print the final message
    echo "The element with atomic number $AT_NUM is $NAME ($SYMB). It's a $EL_TYPE, with a mass of $AT_MASS amu. $NAME has a melting point of $MELT_PT celsius and a boiling point of $BOIL_PT celsius."
  done
fi
