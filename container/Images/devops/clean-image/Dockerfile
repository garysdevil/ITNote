FROM ubuntu:18.04

copy ./cronjob.parms /root

RUN apt-get update \
    && apt-get install -y cron \
    && rm -rf /var/cache

    # && touch /var/spool/cron/crontabs/root \
    # && chown root.crontab /var/spool/cron/crontabs/root \
    
# docker build --no-cache --network=host -f Dockerfile -t garysdevil/devops:clean-image .

# docker run  -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker garysdevil/devops:clean-image /bin/bash -c  "/etc/init.d/cron start;crontab -u root /root/cronjob.parms;touch /tmp/clean-docker.log;tail -f /tmp/clean-docker.log"