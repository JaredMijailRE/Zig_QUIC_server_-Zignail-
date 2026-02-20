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
https://beej.us/guide/bgnet/html/split/ip-addresses-structs-and-data-munging.html 

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

    - *Port Numbers*: There are other addresses, different to the IP, use by UDP and TCP, the port number a *16-bit number* 
      different services in the internet have different port numbers, they could use any but are associated with one
      is like other division in top of the ip address of your host


- Byte order

Sane people use Big-Endian, which is ther normal order to read an hex number, b34f is b3 4f, but there is also Little-Endian, by intel, b34f is 4f b3.
The important thing is Big-Endian is also *Network Byte Order* so before sending something in the net you must check the order is right or CAST it.

- NAT

Usually networks have a NAT, a firewall that hides the network for the rest of the world, translates internal IP to external, Network Address Translation, so usually yout network only has one ip address
for how it works, if you send something it changes the ip you send, for your public ip, and also changes the port, so when something comes back for you it can lock up a table (where the keys are ip and port) to translate again the original ip and port

# System Calls or Bust

https://beej.us/guide/bgnet/html/split/system-calls-or-bust.html

This is more of a practical chapter, so i will identify the concepts and then search for theme in Zig, the syscalls needed should be the same so it is espected to be almost equivalent

- getaddrinfo(): a function that given an (IP or domain, service or port number, addrinfo struct relevant information about host addr (a socket address), gives you back the informatin neeeded to establish a connection (a socket address))

- socket(): get the file descriptor, in C got the same arguments as Zig

- bind(): you must associate the socket with a port(this transalates to an socket address, addrinfo strucut) in your local machine, to listen() for  incomming connection in an specific port
          The port number is used by the kernel to match an incoming packet to a certain process's socket descriptor, if you are a client, this is not needed

now again the struct addrinfo, is the same as a socket address, and that is the information neccesary to stablish a connection or others stablish connections to you

- connect(): (sockfd: socket file descriptor of host, serv_addr: strucut sockaddr contains the destination port and IP Address, addrlen: lenght in bytes server address structure)
    the sockaddr, is part of the struct addrinfo
    if you dont bind the socket, the kernel will bind it for you in some port

- listen(): (sockfd: socket file descriptor, backlog: number of connections allowed on incoming queue), incoming connection wait in a queue until they are accepted
          For this function you need to bind otherwhise you don't know the port where you will recive connections

- accept(): when you accept a connection from the queue, you will get another socket file descriptor, ready to send() and recv(), the original one will be still listening
          (sockfd: the listening socket descriptor,struct sockaddr: information of who you want to accept, socklen_t: lenght of sockaddr)
          
