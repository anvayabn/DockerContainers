import socket

def main(bind_ip, bind_port):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        # Bind the socket to a specific IP and port
        s.bind((bind_ip, bind_port))
        # Listen for incoming connections
        s.listen(5)
        while True:
            # Accept a connection
            conn, addr = s.accept()
            with conn:
                print(f'Connected by {addr}')
                while True:
                    # Receive data from the client
                    with open('mydata.txt', 'rb') as f:
                        data = f.read()
                        conn.send(data)
                    conn.close()    

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--bind_ip", required=True)
    parser.add_argument("--bind_port", type=int, required=True)
    args = parser.parse_args()
    main(args.bind_ip, args.bind_port)