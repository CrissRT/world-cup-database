#! /bin/bash

PSQL="psql --username=postgres --dbname=worldcup -t --no-align -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

$($PSQL "CREATE TABLE teams(
    team_id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    round VARCHAR(255) NOT NULL
  )"
)

$($PSQL "CREATE TABLE games(
    game_id SERIAL PRIMARY KEY,
    year INT NOT NULL,
    winner_id INT REFERENCES teams(team_id),
    opponent_id INT REFERENCES teams(team_id),
    winner_goals INT NOT NULL,
    opponent_goals INT NOT NULL
  )"
)



./queries.sh