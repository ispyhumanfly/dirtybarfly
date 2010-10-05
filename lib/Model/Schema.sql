
-- User Information --

CREATE TABLE user (

    user_id INTEGER PRIMARY KEY,
    facebook_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    gender TEXT NOT NULL,
    birthday TEXT NOT NULL,
    email TEXT NOT NULL,
    timezone TEXT NOT NULL,
    location TEXT NOT NULL,
    city TEXT NOT NULL,
    region TEXT NOT NULL,
    country TEXT NOT NULL,
    lat FLOAT NOT NULL,
    lng FLOAT NOT NULL
);

CREATE TABLE place (

    place_id INTEGER PRIMARY KEY,
    category TEXT NOT NULL,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    date TEXT NOT NULL,
    time TEXT NOT NULL,
    street_address TEXT NOT NULL,
    city TEXT NOT NULL,
    region TEXT NOT NULL,
    country TEXT NOT NULL,
    lat FLOAT NOT NULL,
    lng FLOAT NOT NULL,
    user INTEGER NOT NULL REFERENCES user(user_id)
);

CREATE TABLE place_image (

    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    url TEXT NOT NULL,
    width TEXT NOT NULL,
    height TEXT NOT NULL,
    place INTEGER NOT NULL REFERENCES place(place_id)
);

CREATE TABLE event (

    event_id INTEGER PRIMARY KEY,
    category TEXT NOT NULL,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    date TEXT NOT NULL,
    time TEXT NOT NULL,
    user INTEGER NOT NULL REFERENCES user(user_id)
);

CREATE TABLE story (

    story_id INTEGER PRIMARY KEY,
    category TEXT NOT NULL,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    date TEXT NOT NULL,
    time TEXT NOT NULL,
    user INTEGER NOT NULL REFERENCES user(user_id)
);

CREATE TABLE ad (

    ad_id INTEGER PRIMARY KEY,
    category TEXT NOT NULL,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    date TEXT NOT NULL,
    time TEXT NOT NULL,
    user INTEGER NOT NULL REFERENCES user(user_id)
);

CREATE TABLE ad_comment (

    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    date TEXT NOT NULL,
    time TEXT NOT NULL,
    ad INTEGER NOT NULL REFERENCES ad(ad_id)
);

CREATE TABLE ad_popularity (

    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    date TEXT NOT NULL,
    time TEXT NOT NULL,
    ad INTEGER NOT NULL REFERENCES ad(ad_id)
);
