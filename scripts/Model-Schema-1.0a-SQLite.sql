-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Fri May  6 02:15:44 2011
-- 

BEGIN TRANSACTION;

--
-- Table: person
--
DROP TABLE person;

CREATE TABLE person (
  person_id INTEGER PRIMARY KEY NOT NULL,
  name varchar(100) NOT NULL,
  password varchar(1000) NOT NULL,
  first_name varchar(50),
  last_name varchar(50),
  gender varchar(25),
  birthday varchar(25),
  email varchar(100) NOT NULL,
  city varchar(50) NOT NULL,
  region varchar(25) NOT NULL,
  country varchar(25) NOT NULL,
  lat float(50) NOT NULL,
  lng float(50) NOT NULL,
  avatar varchar(500),
  blurb varchar(1000),
  tracking datetime(50),
  datetime datetime(50) NOT NULL
);

--
-- Table: classified
--
DROP TABLE classified;

CREATE TABLE classified (
  classified_id INTEGER PRIMARY KEY NOT NULL,
  category varchar(100) NOT NULL,
  title varchar(100) NOT NULL,
  about varchar(1000) NOT NULL,
  price int(10) NOT NULL,
  street_address varchar(50) NOT NULL,
  city varchar(50) NOT NULL,
  region varchar(25) NOT NULL,
  country varchar(25) NOT NULL,
  lat float(25) NOT NULL,
  lng float(25) NOT NULL,
  datetime datetime(50) NOT NULL,
  person int NOT NULL
);

CREATE INDEX classified_idx_person ON classified (person);

--
-- Table: discussion
--
DROP TABLE discussion;

CREATE TABLE discussion (
  discussion_id INTEGER PRIMARY KEY NOT NULL,
  category varchar(100) NOT NULL,
  title varchar(100) NOT NULL,
  about varchar(1000) NOT NULL,
  street_address varchar(50) NOT NULL,
  city varchar(50) NOT NULL,
  region varchar(25) NOT NULL,
  country varchar(25) NOT NULL,
  lat float(25) NOT NULL,
  lng float(25) NOT NULL,
  datetime datetime(50) NOT NULL,
  person int NOT NULL
);

CREATE INDEX discussion_idx_person ON discussion (person);

--
-- Table: event
--
DROP TABLE event;

CREATE TABLE event (
  event_id INTEGER PRIMARY KEY NOT NULL,
  title varchar(100) NOT NULL,
  about varchar(1000) NOT NULL,
  street_address varchar(50) NOT NULL,
  city varchar(50) NOT NULL,
  region varchar(25) NOT NULL,
  country varchar(25) NOT NULL,
  lat float(25) NOT NULL,
  lng float(25) NOT NULL,
  start_datetime datetime(50) NOT NULL,
  stop_datetime datetime(50) NOT NULL,
  datetime datetime(50) NOT NULL,
  person INTEGER NOT NULL
);

CREATE INDEX event_idx_person ON event (person);

--
-- Table: person_track
--
DROP TABLE person_track;

CREATE TABLE person_track (
  track_id INTEGER PRIMARY KEY NOT NULL,
  comment varchar(100) NOT NULL,
  link varchar(100) NOT NULL,
  person int NOT NULL,
  datetime datetime(50) NOT NULL
);

CREATE INDEX person_track_idx_person ON person_track (person);

--
-- Table: place
--
DROP TABLE place;

CREATE TABLE place (
  place_id INTEGER PRIMARY KEY NOT NULL,
  category varchar(100) NOT NULL,
  title varchar(100) NOT NULL,
  about varchar(1000) NOT NULL,
  street_address varchar(50) NOT NULL,
  city varchar(50) NOT NULL,
  region varchar(25) NOT NULL,
  country varchar(25) NOT NULL,
  lat float(25) NOT NULL,
  lng float(25) NOT NULL,
  person int NOT NULL,
  datetime datetime(50) NOT NULL
);

CREATE INDEX place_idx_person ON place (person);

--
-- Table: classified_comment
--
DROP TABLE classified_comment;

CREATE TABLE classified_comment (
  comment_id INTEGER PRIMARY KEY NOT NULL,
  comment varchar(100) NOT NULL,
  datetime datetime(50) NOT NULL,
  classified int NOT NULL,
  person int NOT NULL
);

CREATE INDEX classified_comment_idx_classified ON classified_comment (classified);

CREATE INDEX classified_comment_idx_person ON classified_comment (person);

--
-- Table: classified_track
--
DROP TABLE classified_track;

CREATE TABLE classified_track (
  track_id INTEGER PRIMARY KEY NOT NULL,
  comment varchar(100) NOT NULL,
  link varchar(100) NOT NULL,
  datetime datetime(50) NOT NULL,
  classified int NOT NULL
);

CREATE INDEX classified_track_idx_classified ON classified_track (classified);

--
-- Table: discussion_comment
--
DROP TABLE discussion_comment;

CREATE TABLE discussion_comment (
  comment_id INTEGER PRIMARY KEY NOT NULL,
  comment varchar(100) NOT NULL,
  datetime datetime(50) NOT NULL,
  discussion int NOT NULL,
  person int NOT NULL
);

CREATE INDEX discussion_comment_idx_discussion ON discussion_comment (discussion);

CREATE INDEX discussion_comment_idx_person ON discussion_comment (person);

--
-- Table: discussion_track
--
DROP TABLE discussion_track;

CREATE TABLE discussion_track (
  track_id INTEGER PRIMARY KEY NOT NULL,
  comment varchar(100) NOT NULL,
  link varchar(100) NOT NULL,
  datetime datetime(50) NOT NULL,
  discussion int NOT NULL
);

CREATE INDEX discussion_track_idx_discussion ON discussion_track (discussion);

--
-- Table: event_comment
--
DROP TABLE event_comment;

CREATE TABLE event_comment (
  comment_id INTEGER PRIMARY KEY NOT NULL,
  comment varchar(100) NOT NULL,
  datetime datetime(50) NOT NULL,
  event int NOT NULL,
  person int NOT NULL
);

CREATE INDEX event_comment_idx_event ON event_comment (event);

CREATE INDEX event_comment_idx_person ON event_comment (person);

--
-- Table: event_track
--
DROP TABLE event_track;

CREATE TABLE event_track (
  track_id INTEGER PRIMARY KEY NOT NULL,
  comment varchar(100) NOT NULL,
  link varchar(100) NOT NULL,
  datetime datetime(50) NOT NULL,
  event int NOT NULL
);

CREATE INDEX event_track_idx_event ON event_track (event);

--
-- Table: place_comment
--
DROP TABLE place_comment;

CREATE TABLE place_comment (
  comment_id INTEGER PRIMARY KEY NOT NULL,
  comment varchar(100) NOT NULL,
  datetime datetime(50) NOT NULL,
  place int NOT NULL,
  person int NOT NULL
);

CREATE INDEX place_comment_idx_person ON place_comment (person);

CREATE INDEX place_comment_idx_place ON place_comment (place);

--
-- Table: place_track
--
DROP TABLE place_track;

CREATE TABLE place_track (
  track_id INTEGER PRIMARY KEY NOT NULL,
  comment varchar(100) NOT NULL,
  link varchar(100) NOT NULL,
  datetime datetime(50) NOT NULL,
  place int NOT NULL
);

CREATE INDEX place_track_idx_place ON place_track (place);

COMMIT;
