#!/bin/sh

#Wait for ElasticSearch status Yellow
echo "Giving ElasticSearch time to start..."
sleep 10
until curl -sS "http://$ES_HOST:$ES_PORT/_cluster/health?wait_for_status=yellow"
do
    echo "Waiting for ES to start"
    sleep 1
done
echo

#Configure Moloch to Run
if [ ! -f /data/configured ]; then
	touch /data/configured
	/data/moloch/bin/Configure
fi

#Give option to init ElasticSearch
if [ "$INITALIZEDB" = "true" ] ; then
	echo INIT | /data/moloch/db/db.pl http://$ES_HOST:$ES_PORT init
	/data/moloch/bin/moloch_add_user.sh admin "Admin User" $MOLOCH_PASSWORD --admin
fi

#Give option to wipe ElasticSearch
if [ "$WIPEDB" = "true" ]; then
	/data/clean_moloch.sh
fi

echo "Look at log files for errors"
echo "  /data/moloch/logs/viewer.log"
echo "  /data/moloch/logs/capture.log"
echo "Visit http://127.0.0.1:8005 with your favorite browser."
echo "  user: admin"
echo "  password: $MOLOCH_PASSWORD"

if [ "$CAPTURE" = "on" ]
then
    echo "Launch capture..."
    if [ "$VIEWER" = "on" ]
    then
        # Background execution
        $MOLOCHDIR/bin/moloch-capture >> $MOLOCHDIR/logs/capture.log 2>&1 &
    else
        # If only capture, foreground execution
        $MOLOCHDIR/bin/moloch-capture |tee -a $MOLOCHDIR/logs/capture.log 2>&1
    fi
fi

if [ "$CRON" = "on" ]
then
   echo "Launch Cron daemon..."
   service cron start 
fi 

if [ "$SMB" = "on" ]
then
    echo "Launch SMB connection..."
    echo "username="$SMB_USER'\n'"password="$SMB_PASSWORD'\n'"domain="$SMB_DOMAIN'\n'> /data/.smbcredentials
    chmod 600 /data/.smbcredentials
    echo $SMB_SHARE" /data/pcap cifs rw,credentials=/data/.smbcredentials 0 0" >> /etc/fstab
    mount -a
fi 

if [ "$VIEWER" = "on" ]
then
    echo "Launch viewer..."
   /bin/sh -c 'cd $MOLOCHDIR/viewer; $MOLOCHDIR/bin/node viewer.js -c $MOLOCHDIR/etc/config.ini | tee -a $MOLOCHDIR/logs/viewer.log 2>&1' 
fi 
