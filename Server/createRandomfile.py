import random
import hashlib

#create a file with random content

with open("mydata.txt", "wb") as f:
    data = bytearray(random.getrandbits(8) for i in range(1024))
    f.write(data)

#compute the hash 

hash_md5 = hashlib.md5()
with open("mydata.txt", "rb") as f:
    for chunk in iter(lambda: f.read(4096), b""):
        hash_md5.update(chunk)
print(hash_md5.hexdigest())