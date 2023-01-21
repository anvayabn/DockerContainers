# DockerContainers
This is a LAB assignment for Course : Cloud Computing and Cloud Networking 

# Problem Statement 
In this assignment, you have to use a client-server socket program using TCP sockets
from Assignment 1 and containerize your applications. There will be two containers, one
for the server and another for the client application. You can create two containers in the
same machine.

# Solution/Steps 

Step 1:

Login to your VM and clone the github repo 

```
git clone https://github.com/anvayabn/DockerContainers.git
```

Step 2: 
If docker is not installed in your VM use thhe following commands 
```
sudo apt update 
sudo apt install docker.io 
```

Step 3: 
Change the permissions of the `run_server.sh` and `run_client.sh`
```
chmod 766 DockerContainers/Server/run_server.sh
chmod 766 DockerContainers/Client/run_client.sh
```

# Create Server Socket Container

1) Jump to `Server` directory and run the `run_server.sh` 
```
cd DockerContainers/Server/
./run_server.sh
```

2) After Running the script you will see the following output 
```
.
.
.
 ---> Running in a8645ea45a87
Removing intermediate container a8645ea45a87
 ---> f93db3013aed
Step 13/13 : CMD python3 server.py --bind_ip $bindip --bind_port $bindport
 ---> Running in a8052e7a041c
Removing intermediate container a8052e7a041c
 ---> 10aaf2191de4
Successfully built 10aaf2191de4
Successfully tagged serverimage:latest

```

3) Keep the terminal open as the server is listening for connection

# Create IPTABLES for communication Between Containers
1) OPEN AN OTHER TERMINAL 
2) Since the Containers will be deployed on different docker networks, it is necessary to allow communication through the `IPTABLES` command on the host. 
3) First get the server interface as follows 
```
an001@docker:~$ ifconfig
br-0bb7177e3f12: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.23.0.1  netmask 255.255.255.0  broadcast 172.23.0.255
        ether 02:42:c9:e5:a1:0b  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

br-1e8f44d03f7d: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.22.0.1  netmask 255.255.255.0  broadcast 172.22.0.255
        inet6 fe80::42:31ff:fef9:1894  prefixlen 64  scopeid 0x20<link>
        ether 02:42:31:f9:18:94  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 5  bytes 526 (526.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```
Note: In the `run_server.sh` we created 2 docker networks with `subnet 172.22.0.0/24` for the client container and `subnet 172.23.0.0/24`. 

4) From the output we can identify the respective interface for the server and client container. 
For example `Server Interface : br-1e8f44d03f7d` AND `Client Interface : br-0bb7177e3f12`

5) Add the IPTABLES for the same using the commands.
```
sudo iptables -I DOCKER-USER -i <ServerInterface> -o <ClientInterface> -j ACCEPT
sudo iptables -I DOCKER-USER -i <ClientInterface> -o <ServerInterface> -j ACCEPT

For Example:
sudo iptables -I DOCKER-USER -i br-1e8f44d03f7d -o br-0bb7177e3f12 -j ACCEPT
sudo iptables -I DOCKER-USER -i br-0bb7177e3f12 -o br-1e8f44d03f7d -j ACCEPT
```

# Creating Client Socket Container 

1) Jump to client directory and run the `run_client.sh` script.
```
cd DockerContainers/Client/
./run_client.sh
```
2) After running the script the client container runs and exits after receiving the file. 

```
.
.
.
Removing intermediate container c808073ebfb1
 ---> ef18c8eb235b
Step 11/12 : CMD /bin/bash
 ---> Running in 1d618184037f
Removing intermediate container 1d618184037f
 ---> a74da77e48c4
Step 12/12 : CMD python3 client.py --server_ip $SERVERIP --server_port $SERVERPORT --client_ip $CLIENTIP --client_port $CLIENTPORT
 ---> Running in b8235121983c
Removing intermediate container b8235121983c
 ---> 127c620edbf1
Successfully built 127c620edbf1
Successfully tagged clientimage:latest

```

# Check File Transfer

1) First check the absolute path of the volumes using the command 
```
an001@docker:~/DockerContainers/Client$ sudo docker volume ls
DRIVER    VOLUME NAME
local     client_persistent_storage
local     server_persistent_storage

an001@docker:~/DockerContainers/Client$ sudo docker volume inspect client_persistent_storage
[
    {
        "CreatedAt": "2023-01-21T20:52:39Z",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/client_persistent_storage/_data",
        "Name": "client_persistent_storage",
        "Options": {},
        "Scope": "local"
    }
]
an001@docker:~/DockerContainers/Client$ sudo docker volume inspect server_persistent_storage
[
    {
        "CreatedAt": "2023-01-21T20:34:36Z",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/server_persistent_storage/_data",
        "Name": "server_persistent_storage",
        "Options": {},
        "Scope": "local"
    }
]

```

2) Navigate to the path and check the checksum of the data files. command shown as follows 

```
an001@docker:~/DockerContainers/Client$ sudo -i
root@docker:~# cd /var/lib/docker/volumes/server_persistent_storage/_data
root@docker:/var/lib/docker/volumes/server_persistent_storage/_data# ls
Hash.txt  createRandomfile.py  mydata.txt  server.py
root@docker:/var/lib/docker/volumes/server_persistent_storage/_data# md5sum mydata.txt
cffe5d5389ceaf17a4c807ffa421c697  mydata.txt
root@docker:/var/lib/docker/volumes/server_persistent_storage/_data# cat Hash.txt
cffe5d5389ceaf17a4c807ffa421c697


an001@docker:~/DockerContainers/Client$ sudo -i
root@docker:~# cd /var/lib/docker/volumes/client_persistent_storage/_data
root@docker:/var/lib/docker/volumes/client_persistent_storage/_data# md5sum mydata_client_copy.txt
cffe5d5389ceaf17a4c807ffa421c697  mydata_client_copy.txt

```
3) Verify the checksum (Should be same)




