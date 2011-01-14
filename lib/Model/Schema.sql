
-- Person --

CREATE TABLE person (

    person_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    password TEXT NOT NULL,
    first_name TEXT NULL,
    last_name TEXT NULL,
    gender TEXT NULL,
    birthday TEXT NULL,
    email TEXT NOT NULL,
    city TEXT NOT NULL,
    region TEXT NOT NULL,
    country TEXT NOT NULL,
    lat FLOAT NOT NULL,
    lng FLOAT NOT NULL,
    avatar TEXT NULL,
    blurb TEXT NULL,
    popularity INTEGER NULL,
    tracking TEXT NULL
);

CREATE TABLE person_track (

    track_id INTEGER PRIMARY KEY,
    date TEXT NOT NULL,
    time TEXT NOT NULL,
    comment TEXT NOT NULL,
    link TEXT NULL,
    person INTEGER NOT NULL REFERENCES person(person_id)
);

-- Event --

CREATE TABLE event (

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
    street_address TEXT NOT NULL,
    city TEXT NOT NULL,
    region TEXT NOT NULL,
    country TEXT NOT NULL,
    lat FLOAT NOT NULL,
    lng FLOAT NOT NULL,
    popularity INTEGER NULL,
    person INTEGER NOT NULL REFERENCES person(person_id)
);

CREATE TABLE event_comment (

    comment_id INTEGER PRIMARY KEY,
    date TEXT NOT NULL,
    time TEXT NOT NULL,
    comment TEXT NOT NULL,
    event INTEGER NOT NULL REFERENCES event(event_id),
    person INTEGER NOT NULL REFERENCES person(person_id)
);

-- Discussion --

CREATE TABLE discussion (

    discussion_id INTEGER PRIMARY KEY,
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
    person INTEGER NOT NULL REFERENCES person(person_id)
);

CREATE TABLE discussion_comment (

    comment_id INTEGER PRIMARY KEY,
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
    person INTEGER NOT NULL REFERENCES person(person_id)
);

-- Classified --

CREATE TABLE classified (

    classified_id INTEGER PRIMARY KEY,
    category TEXT NOT NULL,
    title TEXT NOT NULL,
    about TEXT NOT NULL,
    date TEXT NOT NULL,
    time TEXT NOT NULL,
    street_address TEXT NOT NULL,
    city TEXT NOT NULL,
    region TEXT NOT NULL,
    country TEXT NOT NULL,
    lat FLOAT NOT NULL,
    lng FLOAT NOT NULL,
    popularity INTEGER NOT NULL,
    person INTEGER NOT NULL REFERENCES person(person_id)
);

CREATE TABLE classified_comment (

    comment_id INTEGER PRIMARY KEY,
    date TEXT NOT NULL,
    time TEXT NOT NULL,
    comment TEXT NOT NULL,
    classified INTEGER NOT NULL REFERENCES classified(classified_id),
    person INTEGER NOT NULL REFERENCES person(person_id)
);