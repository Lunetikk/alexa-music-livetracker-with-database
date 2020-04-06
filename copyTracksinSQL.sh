#!/bin/bash
 
#Login MySQL
LOGIN="local"
 
#Database MySQL
DB=amazonmusic
 
#Temp- and Webfile
TMPFILE=/tmp/audio.txt
WEBFILE=/var/www/mysite/audio.php
WEBFILE2=/var/www/mysite/audio2.php
 
#Execute Alexa Remote Control to get the current data and write into $TMPFILE
/alexa/alexa-remote-control/alexa_remote_control.sh -q > $TMPFILE
 
#Get the necessary data from $TMPFILE
OFFLINE=`grep -m1 'message' $TMPFILE | awk 'BEGIN{FS=" "}{gsub(",",""); print $2}'`
STATE=`grep -m1 'state' $TMPFILE | cut -d '"' -f 4`
STATECUT=`grep -m1 'state' /tmp/audio.txt | awk 'BEGIN{FS=" "}{gsub(",",""); print $2}'`
ARTIST=`grep -m1 'subText1' $TMPFILE | cut -d '"' -f 4`
TITLE=`grep -m1 'title' $TMPFILE | cut -d '"' -f 4`
ALBUM=`grep -m1 'subText2' $TMPFILE | cut -d '"' -f 4`
IMG=`grep -m1 'url' $TMPFILE | cut -d '"' -f 4`
 
#If $WEBFILE exists, make a copy of it ($WEBFILE2) and empty $WEBFILE, else create an empty $WEBFILE
if [ -f $WEBFILE ]; then
   cp -a $WEBFILE $WEBFILE2
   echo "" > $WEBFILE
else
   echo "" > $WEBFILE
fi
 
#If $OFFLINE isnt null and $STATECUT isnt null, write all the data to $WEBFILE, else you are not listening to music
if [ "$OFFLINE" != "null" ] && [ "$STATECUT" != "null" ]; then
   echo "<table style='width:100%'><col style='width:90%'><col style='width:10%'><tr><td>" >> $WEBFILE
   echo "State: $STATE </br>" >> $WEBFILE
   echo "Artist: $ARTIST </br>" >> $WEBFILE
   echo "Title: $TITLE </br>" >> $WEBFILE
   echo "Album: $ALBUM" >> $WEBFILE
   echo "</td><td>" >> $WEBFILE
   echo "<img src='$IMG' alt='albumcover' style='width:64px;height:64px;'>" >> $WEBFILE
   echo "</td></tr></table>" >> $WEBFILE
else
   echo "Iam not listening to music right now..." >> $WEBFILE
fi
 
#The following section compares the $WEBFILEs to make sure you dont write data multiple times for the same track
#Use cmp if it works for you or just use MD5 like I did
 
#HASH="$(cmp --silent $WEBFILE $WEBFILE2; echo $?)"  #"$?" gives exit status for each comparison
#If a FILE is '-' or missing, read standard input. Exit status is 0 if inputs are the same, 1 if different, 2 if trouble.
#cmp showed 2 (error) all the time, even in cli, feel free to use if it works for you...
 
#MD5 Hash of both webfiles to compare
HASHONE=$(md5sum $WEBFILE | cut -d " " -f1)
HASHTWO=$(md5sum $WEBFILE2 | cut -d " " -f1)
 
#if [ "$HASH" -eq 1 ] #use this if you use cmp, if status is equal to 1 (different), then execute code
if [ "$HASHONE" != "$HASHTWO" ] #compare md5 hashes, if different, then execute code
then  
 
#Look for the current track, artist, album, if not in database, insert, else dont insert
DBTRACK=$(mysql --login-path=$LOGIN -D $DB -se "SELECT track_id FROM track WHERE track_name = '$TITLE'")
DBARTIST=$(mysql --login-path=$LOGIN -D $DB -se "SELECT artist_id FROM artist WHERE artist_name = '$ARTIST'")
DBALBUM=$(mysql --login-path=$LOGIN -D $DB -se "SELECT album_id FROM album WHERE album_name = '$ALBUM'")
 
if [ -z "$DBTITLE" ]
then
        if [ -z "$DBALBUM" ]
        then
                if [ -z "$DBARTIST" ]
                then
mysql --login-path=$LOGIN -D $DB << EOFMYSQL
INSERT INTO artist (artist_name)
VALUES ('$ARTIST');
EOFMYSQL
                fi
mysql --login-path=$LOGIN -D $DB  << EOFMYSQL
INSERT INTO album (album_name,album_cover,artist_id)
VALUES ('$ALBUM','$IMG',(SELECT artist_id FROM artist WHERE artist_name = '$ARTIST'));
EOFMYSQL
        fi
mysql --login-path=$LOGIN -D $DB << EOFMYSQL
INSERT INTO track (track_name,album_id,artist_id)
VALUES ('$TITLE',(SELECT album_id FROM album WHERE album_name = '$ALBUM'),(SELECT artist_id FROM artist WHERE artist_name = '$ARTIST'));
EOFMYSQL
fi
 
mysql --login-path=$LOGIN -D $DB << EOFMYSQL
INSERT INTO played (artist_id,track_id,album_id)
VALUES ((SELECT artist_id FROM artist WHERE artist_name = '$ARTIST'),(SELECT track_id FROM track WHERE track_name = '$TITLE'),(SELECT album_id FROM album WHERE album_name = '$ALBUM'));
EOFMYSQL
fi
