
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
    tracking TEXT NULL,
    datetime INTEGER NOT NULL
);

CREATE TABLE person_track (

    track_id INTEGER PRIMARY KEY,
    comment TEXT NOT NULL,
    link TEXT NULL,
    person INTEGER NOT NULL REFERENCES person(person_id),
    datetime INTEGER NOT NULL
);

-- Event --

CREATE TABLE event (

    event_id INTEGER PRIMARY KEY,
    start_datetime INTEGER NOT NULL,
    stop_datetime INTEGER NOT NULL,
    title TEXT NOT NULL,
    about TEXT NOT NULL,
    street_address TEXT NOT NULL,
    city TEXT NOT NULL,
    region TEXT NOT NULL,
    country TEXT NOT NULL,
    lat FLOAT NOT NULL,
    lng FLOAT NOT NULL,
    person INTEGER NOT NULL REFERENCES person(person_id),
    datetime INTEGER NOT NULL
);

CREATE TABLE event_track (

    track_id INTEGER PRIMARY KEY,
    comment TEXT NOT NULL,
    link TEXT NULL,
    event INTEGER NOT NULL REFERENCES event(event_id),
    datetime INTEGER NOT NULL
);

CREATE TABLE event_comment (

    comment_id INTEGER PRIMARY KEY,
    comment TEXT NOT NULL,
    event INTEGER NOT NULL REFERENCES event(event_id),
    person INTEGER NOT NULL REFERENCES person(person_id),
    datetime INTEGER NOT NULL
);

-- Place --

CREATE TABLE place (

    place_id INTEGER PRIMARY KEY,
    category TEXT NOT NULL,
    title TEXT NOT NULL,
    about TEXT NOT NULL,
    street_address TEXT NOT NULL,
    city TEXT NOT NULL,
    region TEXT NOT NULL,
    country TEXT NOT NULL,
    lat FLOAT NOT NULL,
    lng FLOAT NOT NULL,
    person INTEGER NOT NULL REFERENCES person(person_id),
    datetime INTEGER NOT NULL
);

CREATE TABLE place_track (

    track_id INTEGER PRIMARY KEY,
    comment TEXT NOT NULL,
    link TEXT NULL,
    place INTEGER NOT NULL REFERENCES place(place_id),
    datetime INTEGER NOT NULL
);

CREATE TABLE place_comment (

    comment_id INTEGER PRIMARY KEY,
    comment TEXT NOT NULL,
    place INTEGER NOT NULL REFERENCES place(place_id),
    person INTEGER NOT NULL REFERENCES person(person_id),
    datetime INTEGER NOT NULL
);

-- Discussion --

CREATE TABLE discussion (

    discussion_id INTEGER PRIMARY KEY,
    category TEXT NOT NULL,
    title TEXT NOT NULL,
    about TEXT NOT NULL,
    street_address TEXT NOT NULL,
    city TEXT NOT NULL,
    region TEXT NOT NULL,
    country TEXT NOT NULL,
    lat FLOAT NOT NULL,
    lng FLOAT NOT NULL,
    person INTEGER NOT NULL REFERENCES person(person_id),
    datetime INTEGER NOT NULL
);

CREATE TABLE discussion_track (

    track_id INTEGER PRIMARY KEY,
    comment TEXT NOT NULL,
    link TEXT NULL,
    discussion INTEGER NOT NULL REFERENCES discussion(discussion_id),
    datetime INTEGER NOT NULL
);

CREATE TABLE discussion_comment (

    comment_id INTEGER PRIMARY KEY,
    comment TEXT NOT NULL,
    discussion INTEGER NOT NULL REFERENCES discussion(discussion_id),
    person INTEGER NOT NULL REFERENCES person(person_id),
    datetime INTEGER NOT NULL
);

-- Classified --

CREATE TABLE classified (

    classified_id INTEGER PRIMARY KEY,
    category TEXT NOT NULL,
    title TEXT NOT NULL,
    about TEXT NOT NULL,
    street_address TEXT NOT NULL,
    city TEXT NOT NULL,
    region TEXT NOT NULL,
    country TEXT NOT NULL,
    lat FLOAT NOT NULL,
    lng FLOAT NOT NULL,
    price INTEGER NOT NULL,
    person INTEGER NOT NULL REFERENCES person(person_id),
    datetime INTEGER NOT NULL
);

CREATE TABLE classified_track (

    track_id INTEGER PRIMARY KEY,
    comment TEXT NOT NULL,
    link TEXT NULL,
    classified INTEGER NOT NULL REFERENCES classified(classified_id),
    datetime INTEGER NOT NULL
);

CREATE TABLE classified_comment (

    comment_id INTEGER PRIMARY KEY,
    comment TEXT NOT NULL,
    classified INTEGER NOT NULL REFERENCES classified(classified_id),
    person INTEGER NOT NULL REFERENCES person(person_id),
    datetime INTEGER NOT NULL
);