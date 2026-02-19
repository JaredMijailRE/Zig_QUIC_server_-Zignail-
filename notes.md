# Sockets
## theory
https://beej.us/guide/bgnet/html/split/what-is-a-socket.html#what-is-a-socket

-  everything in linux is a file, for communication over the internet we use a file descriptor
- to get a file descriptor we use, socket(), we could use read() and write() because it is a file, but better to use send() and recv()
- there are many sockets, DARPA (internet sockets), Unix sockets...
- there are many types of internet sockets
  - stream sockets: SOCK_STREAM, use by ssh, telnet, all arrives in the same order, error-free
    HTTP, uses stream sockets to get pages
    It uses TCP/IP, TCP makes sure data is error-free and in order, IP deals with routing
  - datagram sockets: SOCK_DGRAM, also call connectionless sockets
    all packages may not arrive, and they arrive in desorder, use by tftp and dhcpcd
    build on top of UDP/IP, it is faster, you dont have to mantain an open connection

- OSI, data is wrapped, in many layers, that encapsulat the data in headers

## practice
so how do we create a socket in Zig? https://ziglang.org/documentation/master/std/#std.os.linux

also some help from this vlog because kind of not good zig docs: https://blog.reilly.dev/creating-udp-server-from-scratch-in-zig

in this case only for linux, we use the standar library, os.linux, where the sockets are.

*socket*: (domain: ip address family, socket_type: stream or datagram, protocol: when we support multiple protocol)

domain: for domain we have the types, AF.INET and AF.INET6
socket_type: SOCK.DGRAM, there is not a quick one, but it uses the UDP datagram so i am guessing it is right


Note: i just learn of ossification, so fck UDP and TCP, i am doing QUIC

# IP and Other concepts
## Theory 

- Ipv4 and IPv6

There are 2^32 possible Ipv4, to few, so there are 2^128 possible Ipv4 much better

     - loop back address ::1 == 127.0.0.1
     - IPv6 with many 0 can be compressed
       2001:0db8:ab00:0000:0000:0000:0000:0000
       2001:db8:ab00::
     - IPv4-compatibility you use the notation 
       ::ffff:192.0.2.33

- Subnet

A subnet is made of a base IP(network) and a subnet mask(hosts)

the subnet mask is a bunch of 1...10...0, they can be written as decimal, or the number of #1 (n) that identifies the net /n. So they look like:

    - 255.255.255.0 = /24
    - 255.255.255.128 = /25

So if you got 192.168.1.0/24, that tells you 24 bits identify the net, and you can use 8 bits for the hosts.

And for IPv6 you got the 128 bits to play with




