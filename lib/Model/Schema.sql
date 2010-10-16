
-- User Information --

CREATE TABLE user (

    user_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    first_name TEXT NULL,
    last_name TEXT NULL,
    gender TEXT NULL,
    birthday TEXT NULL,
    email TEXT NOT NULL,
    timezone TEXT NULL,
    city TEXT NULL,
    region TEXT NULL,
    country TEXT NULL,
    lat FLOAT NOT NULL,
    lng FLOAT NOT NULL,
    avatar TEXT NULL,
    about TEXT NULL,
    popularity INTEGER NULL
);

-- Place Related Information --

CREATE TABLE place (

    place_id INTEGER PRIMARY KEY,
    category TEXT NOT NULL,
    title TEXT NOT NULL,
    date TEXT NOT NULL,
    time TEXT NOT NULL,
    street_address TEXT NOT NULL,
    city TEXT NOT NULL,
    region TEXT NOT NULL,
    country TEXT NOT NULL,
    lat FLOAT NOT NULL,
    lng FLOAT NOT NULL,
    popularity INTEGER NULL,
    user INTEGER NOT NULL REFERENCES user(user_id)
);

CREATE TABLE place_event (

    event_id INTEGER PRIMARY KEY,
    category TEXT NOT NULL,
    title TEXT NOT NULL,
    start_date TEXT NOT NULL,
    stop_date TEXT NOT NULL,
    start_time TEXT NOT NULL,
    stop_time TEXT NOT NULL,
    about TEXT NOT NULL,
    date TEXT NOT NULL,
    time TEXT NOT NULL,
    popularity INTEGER NULL,
    place INTEGER NOT NULL REFERENCES place(place_id),
    user INTEGER NOT NULL REFERENCES user(user_id)
);
