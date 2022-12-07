#!/bin/bash
# database
PSQL="psql -A -t -U freecodecamp -d number_guess -c"
echo "Enter your username: "
read N
  if [[ ${#N} -le 22 ]]
    then
    USER=$N
    else exit
  fi

MAIN(){
USER_ID=$($PSQL "select user_id from users where user_name='$USER'")
  # if no user found
  if [[ $USER_ID ]] 
    then
  
  # User found
        username=$($PSQL "select user_name from users where user_id=$USER_ID")
        GAMES_PLAYED=$($PSQL "select count(game_id) from games where user_id=$USER_ID")
        BEST_SCORE=$($PSQL "select min(guesses) from games where user_id=$USER_ID")
        echo -e "Welcome back, $username! You have played $GAMES_PLAYED games, and your best game took $BEST_SCORE guesses."
  
  # User not found
    else
      echo -e "Welcome, $USER! It looks like this is your first time here." 
      INSURT_USER=$($PSQL "insert into users(user_name) values('$USER')")
      USER_ID=$($PSQL "select user_id from users where user_name='$USER'")
  fi
  
  # call game function
  GAME 
}


GAME(){
  
# SECRET=secret random number to be guesses
# TRIES=How many tries have been
# GUESS=current guess value
# GUESSED=number guessed or not ? 

# Defaults
SECRET=$(($RANDOM % 1000 +1))
TRIES=0
GUESSED=false

# player instruction
echo "Guess the secret number between 1 and 1000: " 

while ! $GUESSED 
  do
    read GUESS
    # if GUESS is a number
    if [[ $GUESS =~ ^[0-9]+$ ]]
    then
        
        # guess is lower than the secret
        if [[ $GUESS -lt $SECRET ]]
        then 
          echo "It's higher than that, guess again:" 
          ((TRIES++))
        
        # guess is grater than the secret
        elif [[ $GUESS -gt $SECRET ]]
        then
          echo "It's lower than that, guess again:" 
          ((TRIES++))
        
        # guess is equal to the secret
        else 
          ((TRIES++))
          GUESSED=true # end loop
          INSERT_GAME=$($PSQL "insert into games(guesses,user_id) values($TRIES,$USER_ID)")
          echo -e "\nYou guessed it in $TRIES tries. The secret number was $SECRET. Nice job!\n"
        fi

    # the guess is not an integer
    else 
      echo "That is not an integer, guess again:"
    fi
  done
}

MAIN
