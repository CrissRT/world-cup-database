CREATE TABLE teams(
    team_id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE games(
    game_id SERIAL PRIMARY KEY,
    round VARCHAR(255) NOT NULL,
    year INT NOT NULL,
    winner_id INT REFERENCES teams(team_id) NOT NULL,
    opponent_id INT REFERENCES teams(team_id) NOT NULL,
    winner_goals INT NOT NULL,
    opponent_goals INT NOT NULL
);

