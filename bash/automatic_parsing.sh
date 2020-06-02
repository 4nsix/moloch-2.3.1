 #!/bin/bash

#Parse all pcaps automatic, recursively and add a tag.
#Only if the pcaps are a valid tcpdump captures and the moloch-capture process isn't running.

SERVICE="moloch-capture"
if pgrep -x "$SERVICE" >/dev/null
then
    echo "$SERVICE is running"
else
    echo "$SERVICE stopped"
    for pcap_filepath in `find /data/pcap/ -exec file {} \; | grep "tcpdump capture" | awk -F: '{print $1}'`; do tag=$(echo $pcap_filepath | cut -d/ -f4) && /data/moloch/bin/moloch-capture --pcapfile $pcap_filepath --skip --tag $tag; done
fi