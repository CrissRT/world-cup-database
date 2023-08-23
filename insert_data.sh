#! /bin/bash

PSQL="psql --username=postgres --dbname=worldcup -t --no-align -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

$PSQL "CREATE TABLE teams(
    team_id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL
)"


$PSQL "CREATE TABLE games(
    game_id SERIAL PRIMARY KEY,
    round VARCHAR(255) NOT NULL,
    year INT NOT NULL,
    winner_id INT REFERENCES teams(team_id) NOT NULL,
    opponent_id INT REFERENCES teams(team_id) NOT NULL,
    winner_goals INT NOT NULL,
    opponent_goals INT NOT NULL
)"

echo $($PSQL "TRUNCATE TABLE games, teams")

while IFS=',' read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS; do
  OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

  if [[ $YEAR != "year" ]]
  then
    if [[ -z $WINNER_TEAM_ID ]]
    then
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted in teams table, winner: $WINNER
    fi

    if [[ -z $OPPONENT_TEAM_ID ]]
    then
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted in teams table, opponent: $OPPONENT
    fi

    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, winner_goals, opponent_goals, round, winner_id, opponent_id) VALUES($YEAR, $WINNER_GOALS, $OPPONENT_GOALS, '$ROUND', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID)")

    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted in games table: $YEAR, $WINNER_GOALS, $OPPONENT_GOALS, $ROUND, $WINNER_TEAM_ID, $OPPONENT_TEAM_ID
    fi
  fi
done < games.csv
./queries.sh