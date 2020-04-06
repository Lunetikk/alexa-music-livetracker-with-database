CREATE TABLE `album` (
  `artist_id` smallint(5) NOT NULL DEFAULT '0',
  `album_id` smallint(5) NOT NULL AUTO_INCREMENT,
  `album_name` char(128) DEFAULT NULL,
  `album_cover` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (album_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
 
CREATE TABLE `artist` (
  `artist_id` smallint(5) NOT NULL AUTO_INCREMENT,
  `artist_name` char(128) DEFAULT NULL,
  PRIMARY KEY (artist_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
 
CREATE TABLE `played` (
  `artist_id` smallint(5) NOT NULL DEFAULT '0',
  `album_id` smallint(5) NOT NULL DEFAULT '0',
  `track_id` smallint(5) NOT NULL DEFAULT '0',
  `played` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
 
CREATE TABLE `track` (
  `track_id` smallint(5) NOT NULL AUTO_INCREMENT,
  `track_name` char(255) DEFAULT NULL,
  `artist_id` smallint(5) NOT NULL DEFAULT '0',
  `album_id` smallint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (track_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
