#run_server.sh

#!/bin/bash

echo "################ Running Server Script ###########################"
SERVER_SUBNET=172.22.0.0/24
CLIENT_SUBNET=172.23.0.0/24
SERVER_PORT=5000 
SERVER_IP=172.22.0.2
echo "The server will listen on port $SERVER_PORT"
#Create a new server network
echo "The subnet created will be $SERVER_SUBNET"
sudo docker network create server_network --subnet $SERVER_SUBNET
#Create a new client network
echo "The client subnet is $CLIENT_SUBNET"
sudo docker network create client_network --subnet $CLIENT_SUBNET
#create a new server volume 
sudo docker volume create server_persistent_storage
#Build server image 
sudo docker build -t serverimage .
#Run the container
sudo docker run --rm -it -p $SERVER_PORT:$SERVER_PORT --ip $SERVER_IP -v server_persistent_storage:/server_storage/ --network server_network -e bindport=$SERVER_PORT -e bindip=$SERVER_IP --name server serverimage 