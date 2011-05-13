-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Fri May  6 02:15:44 2011
-- 
SET foreign_key_checks=0;

DROP TABLE IF EXISTS `person`;

--
-- Table: `person`
--
CREATE TABLE `person` (
  `person_id` integer NOT NULL auto_increment,
  `name` varchar(100) NOT NULL,
  `password` text NOT NULL,
  `first_name` varchar(50),
  `last_name` varchar(50),
  `gender` varchar(25),
  `birthday` varchar(25),
  `email` varchar(100) NOT NULL,
  `city` varchar(50) NOT NULL,
  `region` varchar(25) NOT NULL,
  `country` varchar(25) NOT NULL,
  `lat` float(50, 0) NOT NULL,
  `lng` float(50, 0) NOT NULL,
  `avatar` text,
  `blurb` text,
  `tracking` datetime,
  `datetime` datetime NOT NULL,
  PRIMARY KEY (`person_id`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `classified`;

--
-- Table: `classified`
--
CREATE TABLE `classified` (
  `classified_id` integer NOT NULL auto_increment,
  `category` varchar(100) NOT NULL,
  `title` varchar(100) NOT NULL,
  `about` text NOT NULL,
  `price` integer(10) NOT NULL,
  `street_address` varchar(50) NOT NULL,
  `city` varchar(50) NOT NULL,
  `region` varchar(25) NOT NULL,
  `country` varchar(25) NOT NULL,
  `lat` float(25, 0) NOT NULL,
  `lng` float(25, 0) NOT NULL,
  `datetime` datetime NOT NULL,
  `person` integer NOT NULL,
  INDEX `classified_idx_person` (`person`),
  PRIMARY KEY (`classified_id`),
  CONSTRAINT `classified_fk_person` FOREIGN KEY (`person`) REFERENCES `person` (`person_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `discussion`;

--
-- Table: `discussion`
--
CREATE TABLE `discussion` (
  `discussion_id` integer NOT NULL auto_increment,
  `category` varchar(100) NOT NULL,
  `title` varchar(100) NOT NULL,
  `about` text NOT NULL,
  `street_address` varchar(50) NOT NULL,
  `city` varchar(50) NOT NULL,
  `region` varchar(25) NOT NULL,
  `country` varchar(25) NOT NULL,
  `lat` float(25, 0) NOT NULL,
  `lng` float(25, 0) NOT NULL,
  `datetime` datetime NOT NULL,
  `person` integer NOT NULL,
  INDEX `discussion_idx_person` (`person`),
  PRIMARY KEY (`discussion_id`),
  CONSTRAINT `discussion_fk_person` FOREIGN KEY (`person`) REFERENCES `person` (`person_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `event`;

--
-- Table: `event`
--
CREATE TABLE `event` (
  `event_id` integer NOT NULL auto_increment,
  `title` varchar(100) NOT NULL,
  `about` text NOT NULL,
  `street_address` varchar(50) NOT NULL,
  `city` varchar(50) NOT NULL,
  `region` varchar(25) NOT NULL,
  `country` varchar(25) NOT NULL,
  `lat` float(25, 0) NOT NULL,
  `lng` float(25, 0) NOT NULL,
  `start_datetime` datetime NOT NULL,
  `stop_datetime` datetime NOT NULL,
  `datetime` datetime NOT NULL,
  `person` INTEGER NOT NULL,
  INDEX `event_idx_person` (`person`),
  PRIMARY KEY (`event_id`),
  CONSTRAINT `event_fk_person` FOREIGN KEY (`person`) REFERENCES `person` (`person_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `person_track`;

--
-- Table: `person_track`
--
CREATE TABLE `person_track` (
  `track_id` integer NOT NULL auto_increment,
  `comment` varchar(100) NOT NULL,
  `link` varchar(100) NOT NULL,
  `person` integer NOT NULL,
  `datetime` datetime NOT NULL,
  INDEX `person_track_idx_person` (`person`),
  PRIMARY KEY (`track_id`),
  CONSTRAINT `person_track_fk_person` FOREIGN KEY (`person`) REFERENCES `person` (`person_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `place`;

--
-- Table: `place`
--
CREATE TABLE `place` (
  `place_id` integer NOT NULL auto_increment,
  `category` varchar(100) NOT NULL,
  `title` varchar(100) NOT NULL,
  `about` text NOT NULL,
  `street_address` varchar(50) NOT NULL,
  `city` varchar(50) NOT NULL,
  `region` varchar(25) NOT NULL,
  `country` varchar(25) NOT NULL,
  `lat` float(25, 0) NOT NULL,
  `lng` float(25, 0) NOT NULL,
  `person` integer NOT NULL,
  `datetime` datetime NOT NULL,
  INDEX `place_idx_person` (`person`),
  PRIMARY KEY (`place_id`),
  CONSTRAINT `place_fk_person` FOREIGN KEY (`person`) REFERENCES `person` (`person_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `classified_comment`;

--
-- Table: `classified_comment`
--
CREATE TABLE `classified_comment` (
  `comment_id` integer NOT NULL auto_increment,
  `comment` varchar(100) NOT NULL,
  `datetime` datetime NOT NULL,
  `classified` integer NOT NULL,
  `person` integer NOT NULL,
  INDEX `classified_comment_idx_classified` (`classified`),
  INDEX `classified_comment_idx_person` (`person`),
  PRIMARY KEY (`comment_id`),
  CONSTRAINT `classified_comment_fk_classified` FOREIGN KEY (`classified`) REFERENCES `classified` (`classified_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `classified_comment_fk_person` FOREIGN KEY (`person`) REFERENCES `person` (`person_id`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `classified_track`;

--
-- Table: `classified_track`
--
CREATE TABLE `classified_track` (
  `track_id` integer NOT NULL auto_increment,
  `comment` varchar(100) NOT NULL,
  `link` varchar(100) NOT NULL,
  `datetime` datetime NOT NULL,
  `classified` integer NOT NULL,
  INDEX `classified_track_idx_classified` (`classified`),
  PRIMARY KEY (`track_id`),
  CONSTRAINT `classified_track_fk_classified` FOREIGN KEY (`classified`) REFERENCES `classified` (`classified_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `discussion_comment`;

--
-- Table: `discussion_comment`
--
CREATE TABLE `discussion_comment` (
  `comment_id` integer NOT NULL auto_increment,
  `comment` varchar(100) NOT NULL,
  `datetime` datetime NOT NULL,
  `discussion` integer NOT NULL,
  `person` integer NOT NULL,
  INDEX `discussion_comment_idx_discussion` (`discussion`),
  INDEX `discussion_comment_idx_person` (`person`),
  PRIMARY KEY (`comment_id`),
  CONSTRAINT `discussion_comment_fk_discussion` FOREIGN KEY (`discussion`) REFERENCES `discussion` (`discussion_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `discussion_comment_fk_person` FOREIGN KEY (`person`) REFERENCES `person` (`person_id`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `discussion_track`;

--
-- Table: `discussion_track`
--
CREATE TABLE `discussion_track` (
  `track_id` integer NOT NULL auto_increment,
  `comment` varchar(100) NOT NULL,
  `link` varchar(100) NOT NULL,
  `datetime` datetime NOT NULL,
  `discussion` integer NOT NULL,
  INDEX `discussion_track_idx_discussion` (`discussion`),
  PRIMARY KEY (`track_id`),
  CONSTRAINT `discussion_track_fk_discussion` FOREIGN KEY (`discussion`) REFERENCES `discussion` (`discussion_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `event_comment`;

--
-- Table: `event_comment`
--
CREATE TABLE `event_comment` (
  `comment_id` integer NOT NULL auto_increment,
  `comment` varchar(100) NOT NULL,
  `datetime` datetime NOT NULL,
  `event` integer NOT NULL,
  `person` integer NOT NULL,
  INDEX `event_comment_idx_event` (`event`),
  INDEX `event_comment_idx_person` (`person`),
  PRIMARY KEY (`comment_id`),
  CONSTRAINT `event_comment_fk_event` FOREIGN KEY (`event`) REFERENCES `event` (`event_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `event_comment_fk_person` FOREIGN KEY (`person`) REFERENCES `person` (`person_id`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `event_track`;

--
-- Table: `event_track`
--
CREATE TABLE `event_track` (
  `track_id` integer NOT NULL auto_increment,
  `comment` varchar(100) NOT NULL,
  `link` varchar(100) NOT NULL,
  `datetime` datetime NOT NULL,
  `event` integer NOT NULL,
  INDEX `event_track_idx_event` (`event`),
  PRIMARY KEY (`track_id`),
  CONSTRAINT `event_track_fk_event` FOREIGN KEY (`event`) REFERENCES `event` (`event_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `place_comment`;

--
-- Table: `place_comment`
--
CREATE TABLE `place_comment` (
  `comment_id` integer NOT NULL auto_increment,
  `comment` varchar(100) NOT NULL,
  `datetime` datetime NOT NULL,
  `place` integer NOT NULL,
  `person` integer NOT NULL,
  INDEX `place_comment_idx_person` (`person`),
  INDEX `place_comment_idx_place` (`place`),
  PRIMARY KEY (`comment_id`),
  CONSTRAINT `place_comment_fk_person` FOREIGN KEY (`person`) REFERENCES `person` (`person_id`),
  CONSTRAINT `place_comment_fk_place` FOREIGN KEY (`place`) REFERENCES `place` (`place_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `place_track`;

--
-- Table: `place_track`
--
CREATE TABLE `place_track` (
  `track_id` integer NOT NULL auto_increment,
  `comment` varchar(100) NOT NULL,
  `link` varchar(100) NOT NULL,
  `datetime` datetime NOT NULL,
  `place` integer NOT NULL,
  INDEX `place_track_idx_place` (`place`),
  PRIMARY KEY (`track_id`),
  CONSTRAINT `place_track_fk_place` FOREIGN KEY (`place`) REFERENCES `place` (`place_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

SET foreign_key_checks=1;

