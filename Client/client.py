import socket

def main(server_ip, server_port, client_ip, client_port):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        # Bind the client socket to a specific IP and port
        s.bind((client_ip, client_port))
        # Connect to the server
        s.connect((server_ip, server_port))
        with open('mydata_client_copy.txt', 'wb') as f:
            while True:
                data = s.recv(1024)
                if not data:
                    break
                f.write(data)
        s.close()    

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--server_ip", required=True)
    parser.add_argument("--server_port", type=int, required=True)
    parser.add_argument("--client_ip", required=True)
    parser.add_argument("--client_port", type=int, required=True)
    args = parser.parse_args()
    main(args.server_ip, args.server_port, args.client_ip, args.client_port)