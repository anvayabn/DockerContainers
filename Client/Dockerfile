FROM ubuntu:latest

RUN apt update -y
RUN apt install python3 -y
RUN mkdir /client_storage

ADD client.py /client_storage/

ENV SERVERIP="172.22.0.2"
ENV SERVERPORT="5000"
ENV CLIENTIP="172.23.0.2"
ENV CLIENTPORT="4000"


WORKDIR /client_storage/

CMD /bin/bash
CMD python3 client.py --server_ip $SERVERIP --server_port $SERVERPORT --client_ip $CLIENTIP --client_port $CLIENTPORT
