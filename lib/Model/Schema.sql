CREATE TABLE user (

    user_id INTEGER PRIMARY KEY,
    facebook_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    gender TEXT NOT NULL,
    link TEXT NOT NULL,
    email TEXT NOT NULL,
    location TEXT NOT NULL,
    timezone TEXT NOT NULL
);

CREATE TABLE place (

    place_id INTEGER PRIMARY KEY,
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
