# Alexa music livetracker with database

I wrote a script based on [Alexa Remote Control](https://github.com/thorsten-gehrig/alexa-remote-control) to display the current music title played by my Echo device / Alexa on my website. It also writes the content to a MySQL database.

***Set up the Alexa Remote Control script***

Visit [Alexa Remote Control](https://github.com/thorsten-gehrig/alexa-remote-control) on Github and set up the script. Also set up MFA, otherwise your script will suddenly stop working after a while.

***Set up the database***

![databaseERM](https://lunetikk.de/lib/exe/fetch.php?cache=&media=linux:ubuntu:pasted:20191124-223313.png)

Check amazonmusic.sql for the code

***copyTracksinSQL.sh***

The script will execute Alexa Remote Control and write all the received data to $TMPFILE. $TMPFILE contains alot of data, I just search for the current state, artist, title, album, albumimageURL. This data will be written to $WEBFILE and to your database, $WEBFILE is used to display your music on a website. 

Make sure the script is executeable

```chmod +x copyTracksinSQL.sh```

***Display the music on a website***

Use an iframe to display the content of $WEBFILE (audio.php)

```<iframe id="frame1" src="audio.php" width="650" height="100"></iframe>```

![livetracker](https://lunetikk.de/lib/exe/fetch.php?cache=&media=linux:ubuntu:pasted:20191005-132910.png)

***Automation***

Setup a cronjob to execute the script every 2 minutes

```*/2 * * * * /alexa-remote-control/copyTrackinSQL.sh >/dev/null 2>&1```
