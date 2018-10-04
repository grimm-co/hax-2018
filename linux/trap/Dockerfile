FROM ubuntu

COPY sHELL.bash /bin/sHELL
COPY flag.txt /flag.txt

RUN useradd trap -m -s /bin/sHELL
RUN chmod 644 /flag.txt
