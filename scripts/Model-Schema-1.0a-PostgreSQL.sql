-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Fri May  6 02:15:44 2011
-- 
--
-- Table: person
--
DROP TABLE "person" CASCADE;
CREATE TABLE "person" (
  "person_id" serial NOT NULL,
  "name" character varying(100) NOT NULL,
  "password" character varying(1000) NOT NULL,
  "first_name" character varying(50),
  "last_name" character varying(50),
  "gender" character varying(25),
  "birthday" character varying(25),
  "email" character varying(100) NOT NULL,
  "city" character varying(50) NOT NULL,
  "region" character varying(25) NOT NULL,
  "country" character varying(25) NOT NULL,
  "lat" numeric(50) NOT NULL,
  "lng" numeric(50) NOT NULL,
  "avatar" character varying(500),
  "blurb" character varying(1000),
  "tracking" timestamp(6),
  "datetime" timestamp(6) NOT NULL,
  PRIMARY KEY ("person_id")
);

--
-- Table: classified
--
DROP TABLE "classified" CASCADE;
CREATE TABLE "classified" (
  "classified_id" serial NOT NULL,
  "category" character varying(100) NOT NULL,
  "title" character varying(100) NOT NULL,
  "about" character varying(1000) NOT NULL,
  "price" integer NOT NULL,
  "street_address" character varying(50) NOT NULL,
  "city" character varying(50) NOT NULL,
  "region" character varying(25) NOT NULL,
  "country" character varying(25) NOT NULL,
  "lat" numeric(25) NOT NULL,
  "lng" numeric(25) NOT NULL,
  "datetime" timestamp(6) NOT NULL,
  "person" integer NOT NULL,
  PRIMARY KEY ("classified_id")
);
CREATE INDEX "classified_idx_person" on "classified" ("person");

--
-- Table: discussion
--
DROP TABLE "discussion" CASCADE;
CREATE TABLE "discussion" (
  "discussion_id" serial NOT NULL,
  "category" character varying(100) NOT NULL,
  "title" character varying(100) NOT NULL,
  "about" character varying(1000) NOT NULL,
  "street_address" character varying(50) NOT NULL,
  "city" character varying(50) NOT NULL,
  "region" character varying(25) NOT NULL,
  "country" character varying(25) NOT NULL,
  "lat" numeric(25) NOT NULL,
  "lng" numeric(25) NOT NULL,
  "datetime" timestamp(6) NOT NULL,
  "person" integer NOT NULL,
  PRIMARY KEY ("discussion_id")
);
CREATE INDEX "discussion_idx_person" on "discussion" ("person");

--
-- Table: event
--
DROP TABLE "event" CASCADE;
CREATE TABLE "event" (
  "event_id" serial NOT NULL,
  "title" character varying(100) NOT NULL,
  "about" character varying(1000) NOT NULL,
  "street_address" character varying(50) NOT NULL,
  "city" character varying(50) NOT NULL,
  "region" character varying(25) NOT NULL,
  "country" character varying(25) NOT NULL,
  "lat" numeric(25) NOT NULL,
  "lng" numeric(25) NOT NULL,
  "start_datetime" timestamp(6) NOT NULL,
  "stop_datetime" timestamp(6) NOT NULL,
  "datetime" timestamp(6) NOT NULL,
  "person" integer NOT NULL,
  PRIMARY KEY ("event_id")
);
CREATE INDEX "event_idx_person" on "event" ("person");

--
-- Table: person_track
--
DROP TABLE "person_track" CASCADE;
CREATE TABLE "person_track" (
  "track_id" serial NOT NULL,
  "comment" character varying(100) NOT NULL,
  "link" character varying(100) NOT NULL,
  "person" integer NOT NULL,
  "datetime" timestamp(6) NOT NULL,
  PRIMARY KEY ("track_id")
);
CREATE INDEX "person_track_idx_person" on "person_track" ("person");

--
-- Table: place
--
DROP TABLE "place" CASCADE;
CREATE TABLE "place" (
  "place_id" serial NOT NULL,
  "category" character varying(100) NOT NULL,
  "title" character varying(100) NOT NULL,
  "about" character varying(1000) NOT NULL,
  "street_address" character varying(50) NOT NULL,
  "city" character varying(50) NOT NULL,
  "region" character varying(25) NOT NULL,
  "country" character varying(25) NOT NULL,
  "lat" numeric(25) NOT NULL,
  "lng" numeric(25) NOT NULL,
  "person" integer NOT NULL,
  "datetime" timestamp(6) NOT NULL,
  PRIMARY KEY ("place_id")
);
CREATE INDEX "place_idx_person" on "place" ("person");

--
-- Table: classified_comment
--
DROP TABLE "classified_comment" CASCADE;
CREATE TABLE "classified_comment" (
  "comment_id" serial NOT NULL,
  "comment" character varying(100) NOT NULL,
  "datetime" timestamp(6) NOT NULL,
  "classified" integer NOT NULL,
  "person" integer NOT NULL,
  PRIMARY KEY ("comment_id")
);
CREATE INDEX "classified_comment_idx_classified" on "classified_comment" ("classified");
CREATE INDEX "classified_comment_idx_person" on "classified_comment" ("person");

--
-- Table: classified_track
--
DROP TABLE "classified_track" CASCADE;
CREATE TABLE "classified_track" (
  "track_id" serial NOT NULL,
  "comment" character varying(100) NOT NULL,
  "link" character varying(100) NOT NULL,
  "datetime" timestamp(6) NOT NULL,
  "classified" integer NOT NULL,
  PRIMARY KEY ("track_id")
);
CREATE INDEX "classified_track_idx_classified" on "classified_track" ("classified");

--
-- Table: discussion_comment
--
DROP TABLE "discussion_comment" CASCADE;
CREATE TABLE "discussion_comment" (
  "comment_id" serial NOT NULL,
  "comment" character varying(100) NOT NULL,
  "datetime" timestamp(6) NOT NULL,
  "discussion" integer NOT NULL,
  "person" integer NOT NULL,
  PRIMARY KEY ("comment_id")
);
CREATE INDEX "discussion_comment_idx_discussion" on "discussion_comment" ("discussion");
CREATE INDEX "discussion_comment_idx_person" on "discussion_comment" ("person");

--
-- Table: discussion_track
--
DROP TABLE "discussion_track" CASCADE;
CREATE TABLE "discussion_track" (
  "track_id" serial NOT NULL,
  "comment" character varying(100) NOT NULL,
  "link" character varying(100) NOT NULL,
  "datetime" timestamp(6) NOT NULL,
  "discussion" integer NOT NULL,
  PRIMARY KEY ("track_id")
);
CREATE INDEX "discussion_track_idx_discussion" on "discussion_track" ("discussion");

--
-- Table: event_comment
--
DROP TABLE "event_comment" CASCADE;
CREATE TABLE "event_comment" (
  "comment_id" serial NOT NULL,
  "comment" character varying(100) NOT NULL,
  "datetime" timestamp(6) NOT NULL,
  "event" integer NOT NULL,
  "person" integer NOT NULL,
  PRIMARY KEY ("comment_id")
);
CREATE INDEX "event_comment_idx_event" on "event_comment" ("event");
CREATE INDEX "event_comment_idx_person" on "event_comment" ("person");

--
-- Table: event_track
--
DROP TABLE "event_track" CASCADE;
CREATE TABLE "event_track" (
  "track_id" serial NOT NULL,
  "comment" character varying(100) NOT NULL,
  "link" character varying(100) NOT NULL,
  "datetime" timestamp(6) NOT NULL,
  "event" integer NOT NULL,
  PRIMARY KEY ("track_id")
);
CREATE INDEX "event_track_idx_event" on "event_track" ("event");

--
-- Table: place_comment
--
DROP TABLE "place_comment" CASCADE;
CREATE TABLE "place_comment" (
  "comment_id" serial NOT NULL,
  "comment" character varying(100) NOT NULL,
  "datetime" timestamp(6) NOT NULL,
  "place" integer NOT NULL,
  "person" integer NOT NULL,
  PRIMARY KEY ("comment_id")
);
CREATE INDEX "place_comment_idx_person" on "place_comment" ("person");
CREATE INDEX "place_comment_idx_place" on "place_comment" ("place");

--
-- Table: place_track
--
DROP TABLE "place_track" CASCADE;
CREATE TABLE "place_track" (
  "track_id" serial NOT NULL,
  "comment" character varying(100) NOT NULL,
  "link" character varying(100) NOT NULL,
  "datetime" timestamp(6) NOT NULL,
  "place" integer NOT NULL,
  PRIMARY KEY ("track_id")
);
CREATE INDEX "place_track_idx_place" on "place_track" ("place");

--
-- Foreign Key Definitions
--

ALTER TABLE "classified" ADD FOREIGN KEY ("person")
  REFERENCES "person" ("person_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "discussion" ADD FOREIGN KEY ("person")
  REFERENCES "person" ("person_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "event" ADD FOREIGN KEY ("person")
  REFERENCES "person" ("person_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "person_track" ADD FOREIGN KEY ("person")
  REFERENCES "person" ("person_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "place" ADD FOREIGN KEY ("person")
  REFERENCES "person" ("person_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "classified_comment" ADD FOREIGN KEY ("classified")
  REFERENCES "classified" ("classified_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "classified_comment" ADD FOREIGN KEY ("person")
  REFERENCES "person" ("person_id") DEFERRABLE;

ALTER TABLE "classified_track" ADD FOREIGN KEY ("classified")
  REFERENCES "classified" ("classified_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "discussion_comment" ADD FOREIGN KEY ("discussion")
  REFERENCES "discussion" ("discussion_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "discussion_comment" ADD FOREIGN KEY ("person")
  REFERENCES "person" ("person_id") DEFERRABLE;

ALTER TABLE "discussion_track" ADD FOREIGN KEY ("discussion")
  REFERENCES "discussion" ("discussion_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "event_comment" ADD FOREIGN KEY ("event")
  REFERENCES "event" ("event_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "event_comment" ADD FOREIGN KEY ("person")
  REFERENCES "person" ("person_id") DEFERRABLE;

ALTER TABLE "event_track" ADD FOREIGN KEY ("event")
  REFERENCES "event" ("event_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "place_comment" ADD FOREIGN KEY ("person")
  REFERENCES "person" ("person_id") DEFERRABLE;

ALTER TABLE "place_comment" ADD FOREIGN KEY ("place")
  REFERENCES "place" ("place_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE "place_track" ADD FOREIGN KEY ("place")
  REFERENCES "place" ("place_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

