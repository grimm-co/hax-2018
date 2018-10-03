FROM ubuntu

COPY sHELL.bash /bin/sHELL
COPY flag.txt /flag.txt
COPY entry.sh /entry.sh

RUN useradd trap -m -s /bin/sHELL
RUN chmod 644 /flag.txt

ENTRYPOINT /entry.sh
