<b>Quickstart:</b>

<b>1. do a git clone moloch-2.3.1 from github:</b>
<br>git clone https://github.com/dwesthuis/moloch-2.3.1.git

<b>2a. Change your Moloch password in the docker-compose.yml:</b>
<br>MOLOCH_PASSWORD=CHANGE_PASSWORD!!

<b>2b. Change your SMB password, username and path in the docker-compose.yml:</b>
<br> SMB_USER=CHANGE_SMB_USERNAME!!
<br> SMB_PASSWORD=CHANGE_SMB_PASSWORD!!
<br> SMB_SHARE=CHANGE_SMB_SHARE!!

<b>3. Use docker-compose to compose the images:</b>
<br>docker-compose up

<b>4. Start using moloch: </b> 
<br>enter http://localhost:8005/ in your browser

<b>5. put your pcap files in the /pcap directory (automatic parsing in 5 minutes) </b>
