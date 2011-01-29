
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
    category TEXT NOT NULL,
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

-- Discussion --

CREATE TABLE topic (

    topic_id INTEGER PRIMARY KEY,
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

CREATE TABLE topic_track (

    track_id INTEGER PRIMARY KEY,
    comment TEXT NOT NULL,
    link TEXT NULL,
    topic INTEGER NOT NULL REFERENCES topic(topic_id),
    datetime INTEGER NOT NULL
);

CREATE TABLE topic_comment (

    comment_id INTEGER PRIMARY KEY,
    comment TEXT NOT NULL,
    topic INTEGER NOT NULL REFERENCES topic(topic_id),
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