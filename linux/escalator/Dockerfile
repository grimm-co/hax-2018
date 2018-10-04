FROM ubuntu:latest

# install required packages
RUN apt-get update && apt-get install -y sudo nfs-common net-tools inetutils-ping cron python3 openssh-client

# add users
RUN useradd escalator -m -s /bin/bash && \
    useradd escalator-1 -m -s /bin/bash && \
    useradd escalator-2 -m -s /bin/bash --uid 5000

# copy flags, change permissions
COPY flag1.txt /home/escalator-1/flag.txt
RUN chown escalator-1 /home/escalator-1/flag.txt && chmod 400 /home/escalator-1/flag.txt

COPY flag2.txt /home/escalator-2/flag.txt
RUN chown escalator-2 /home/escalator-2/flag.txt && chmod 400 /home/escalator-2/flag.txt

# challenge one
RUN echo 'escalator ALL=(escalator-1) NOPASSWD: /usr/bin/find' > /etc/sudoers.d/e1

# challenge two
RUN mkdir /backup /source
RUN chown -R escalator-2 /source /backup && chmod 777 /source
RUN /bin/echo '* * * * *   escalator-2  cd /source && cp * /backup && chmod -R a+rwx /backup && find /backup/ -mindepth 100 -type f -exec chmod u+s {} +' >> /etc/crontab
RUN chmod -R a+rx /var/spool/cron/crontabs

# challenge three
RUN echo 'escalator-2 ALL=(ALL:ALL) NOPASSWD: /bin/mount -t nfs *, /sbin/showmount, /bin/umount' > /etc/sudoers.d/e2

# run services
CMD cron -f
