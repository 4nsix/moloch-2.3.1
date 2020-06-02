FROM ubuntu:18.04
MAINTAINER dwesthuis <info@denniswesthuis.nl>

#Install required packages
RUN apt-get -qq update && \
apt-get -qq update && \
apt-get install -yq  wget curl libpcre3-dev uuid-dev libmagic-dev pkg-config g++ flex bison zlib1g-dev libffi-dev gettext libgeoip-dev make libjson-perl libbz2-dev libwww-perl libpng-dev xz-utils libffi-dev python libssl-dev libyaml-dev ethtool cron nano && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Set arguments
ARG MOLOCH_VERSION=2.3.0-1_amd64
ARG UBUNTU_VERSION=18.04
ARG ES_HOST=elasticsearch
ARG ES_PORT=9200
ARG MOLOCH_PASSWORD=CHANGEPASSWORD!!
ARG MOLOCH_INTERFACE=eth0
ARG CAPTURE=off
ARG VIEWER=on
ARG CRON=on
ARG INITALIZEDB=false
ARG CLEANDB=false

#Set environment variables
ENV ES_HOST $ES_HOST
ENV ES_PORT $ES_PORT
ENV MOLOCH_LOCALELASTICSEARCH no
ENV MOLOCH_ELASTICSEARCH "http://"$ES_HOST":"$ES_PORT
ENV MOLOCH_INTERFACE $MOLOCH_INTERFACE
ENV MOLOCH_PASSWORD $MOLOCH_PASSWORD
ENV MOLOCHDIR "/data/moloch"
ENV CAPTURE $CAPTURE
ENV VIEWER $VIEWER
ENV INITALIZEDB $INITALIZEDB
ENV CLEANDB=$WIPEDB
ENV CRON $CRON

#Install moloch
RUN mkdir -p /data
RUN cd /data && curl -C - -O "https://files.molo.ch/builds/ubuntu-"$UBUNTU_VERSION"/moloch_"$MOLOCH_VERSION".deb"
RUN cd /data && dpkg -i "moloch_"$MOLOCH_VERSION".deb"

#Add bash files
ADD /bash /data/
ADD /etc /data/moloch/etc/
RUN chmod 755 /data/start_services.sh
RUN chmod 755 /data/clean_moloch.sh
RUN chmod 755 /data/manual_parsing.sh
RUN chmod 755 /data/automatic_parsing.sh

# ADD /cron.d /etc/cron.d/
RUN echo "*/5 * * * * root /data/automatic_parsing.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/automatic_parsing
RUN chmod +x /etc/cron.d/automatic_parsing

#RUN touch /var/log/cron.log
#CMD cron && tail -f /var/log/cron.log
#RUN service cron start

ENV PATH="/data:/data/moloch/bin:${PATH}"
EXPOSE 8005
WORKDIR /data/moloch
ENTRYPOINT ["/data/start_services.sh"]
