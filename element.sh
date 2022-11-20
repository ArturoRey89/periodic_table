#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
else 
  # check input type is int
  if [[ $1 =~ ^[1-9][0-9]* ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  else

    # check input type is symbol
    if [[ $1 =~ ^[A-Z][a-z]?$ ]]
    then 
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
    else

      # check input type is name
      if [[ $1 =~ ^[A-Z][a-z]+$ ]]
      then
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
      fi
    fi
  fi

  # If atomic number not found
  if [[ ! $ATOMIC_NUMBER || -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database." 
  
  # Return information
  else
    QUERY_SPECS="atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius"
    ELEMENT=$($PSQL "SELECT $QUERY_SPECS FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
    echo $ELEMENT | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELTING_POINT BAR BOILING_POINT
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi
