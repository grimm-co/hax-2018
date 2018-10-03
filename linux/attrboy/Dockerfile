FROM ubuntu:latest

RUN apt-get update && apt-get install -y cron sudo libcap2-bin

COPY flag.txt /root/flag.txt

RUN chmod 400 /root/flag.txt
RUN useradd -m -s /bin/bash attrboy
RUN echo "HAX{this_isn't_the_real_flag}" > /flag.txt 
RUN echo "* * * * *   root   cat /root/flag.txt > /flag.txt" >> /etc/crontab
RUN setcap 'CAP_LINUX_IMMUTABLE+eip' /usr/bin/chattr

ENTRYPOINT chown attrboy:attrboy /flag.txt && chmod 666 /flag.txt && chattr +i /flag.txt && cron -f
