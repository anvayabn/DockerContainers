FROM ubuntu:latest 

RUN apt update -y
RUN apt install python3 -y 

RUN mkdir /server_storage

ADD server.py /server_storage/

ADD createRandomfile.py /server_storage/

WORKDIR /server_storage/

RUN python3 createRandomfile.py >> Hash.txt


ENV bindport="5000"
ENV bindip="172.22.0.2"
CMD /bin/bash

CMD MACHINE_IP=$(hostname -I | awk '{print $1}')


CMD python3 server.py --bind_ip $bindip --bind_port $bindport
