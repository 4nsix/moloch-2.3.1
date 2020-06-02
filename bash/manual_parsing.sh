#!/bin/bash

#Parse all pcaps manual, recursively and add a tag.
for pcap_filepath in `find /data/pcap/ -exec file {} \; | grep "tcpdump capture" | awk -F: '{print $1}'`; do tag=$(echo $pcap_filepath | cut -d/ -f4) && /data/moloch/bin/moloch-capture --pcapfile $pcap_filepath --skip --tag $tag; done
