FROM ubuntu:latest

RUN apt-get update && apt-get install -y cron netcat

RUN useradd netcatter-priv && useradd netcatter -m -s /bin/bash
COPY netcatter /usr/bin/netcatter
RUN chown netcatter-priv /usr/bin/netcatter

COPY netcatter.c  /home/netcatter/netcatter.c
RUN chmod 744 /home/netcatter/netcatter.c

COPY flag.txt /flag.txt
RUN chown netcatter-priv /flag.txt && chmod 400 /flag.txt

RUN mkdir /netcatter && chown netcatter-priv /netcatter && chmod 733 /netcatter
RUN echo '* * * * *  netcatter-priv  /usr/bin/netcatter /netcatter' >> /etc/crontab

CMD cron -f
