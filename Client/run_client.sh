#run_client.sh

#!/bin/bash

echo "################ Running Client Script ###########################"
CLIENT_PORT=4000 
CLIENT_IP=172.23.0.2
SERVERPORT=5000
echo "The client will connect on port $CLIENT_PORT"
#Create a new client network
#echo "The subnet created will be $SUBNET"
#sudo docker network create client_network --subnet $SUBNET 
#create a new client volume 
sudo docker volume create client_persistent_storage
#Get server IP address
CONTAINER_ID=$(sudo docker ps -a | grep server | awk '{ print $1 }')
SERVERIP=$(sudo docker inspect $CONTAINER_ID -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')
#Build client image 
sudo docker build -t clientimage .
#Run the container
sudo docker run --rm -it -p $CLIENT_PORT:$CLIENT_PORT --ip $CLIENT_IP -v client_persistent_storage:/client_storage/ --network client_network -e SERVERIP=$SERVERIP -e SERVERPORT=$SERVERPORT -e CLIENTIP=$CLIENT_IP -e CLIENTPORT=$CLIENT_PORT --name client clientimage 
