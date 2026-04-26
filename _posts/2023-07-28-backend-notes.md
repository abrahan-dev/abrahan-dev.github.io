---
layout: post
title: "Backend Notes"
date: 2023-07-28 00:00:00 +0200
categories: ["learning"]
excerpt: ""
---
{% raw %}
Some notes about backend development through a practical example. At the end we get a simple and secured nodejs web application running on a server with nginx, https, some CI and load balancing.

## Command line

The command line is a text interface for the computer's operating system. It is a program that takes commands from the keyboard and gives them to the operating system to perform.

You need to know a few commands to be able to use the command line, out of the scope of this post.

```bash
# Show the current directory
pwd
# List the files in the current directory
ls -la
# Remove a directory and its content
rm -rf foo
# Create a directory arborescence
mkdir -p a/b/c
# Use man to read a program documentation
man ls
# Stop a running process
pkill <process name>
# Test your ssh connection to github
ssh -vT git@github.com
# Save a read only file in vim
:w !sudo tee %
# View permissions as numbers
stat -c '%a' <file name>
# use tail to read the last lines of a file (great for logs)
tail -f <file name>
# use cat to read a file
cat <file name>
# use grep to search for a string in a file
grep <string> <file name>
# you can pipe something to grep
ps aux | grep node
# use find to search for a file
find <file name>
find . -name <file name>
# use less to read a file one page at a time
less <file name>
# use head to read the first lines of a file
head <file name>
# use > to write stdout to a file
echo "hello world" > foo.txt
# use >> to append stdout to a file
echo "hello world" >> foo.txt
# use < to read from stdin
less < foo.txt
# use 2>&1 to redirect stderr to stdout
echo "hello world" 2>&1
# use | to read from stdout
echo "hello world" | less
# find the files that contain a string
grep -r <string> .
# use htop to see the processes and the load on the server
htop
```

## Vim

Use vim to edit files in the command line. It is a text editor that is installed by default on most Unix systems. Again out of the scope of this post. But we need to know a few commands to be able to use it.

```bash
# Open a file
vim foo.txt
# Go to insert mode (edit mode)
i
# Go to command mode
Esc
# Go to the end of the file (in command mode)
G
# Save and quit (in command mode)
:wq
# Quit without saving (in command mode)
:q!
# Undone the last change (in command mode)
:u
```

## Shell

The shell is the program that runs in the terminal and actually executes commands. Example of shells are bash or zsh.

```bash
# Show the current shell
echo $SHELL
```

## Cloud computing

Virtualization is the process of creating a virtual version of something, including virtual computer hardware platforms, storage devices, and computer network resources. Cloud providers divide server resources into virtual computers.

Virtual machine is a digital version of a physical computer.

VPS is a virtual private server.

## Operating system

Once you have a virtual machine, you need to install an operating system on it. The operating system is the software that manages the computer hardware and provides common services for computer programs. The operating system is the interface between the user and the computer hardware.

There are a few kinds of operating systems we can use to serve our applications:

-   Windows
    -   Windows server
-   Unix
    -   Solaris
    -   Linux: Ubuntu, Debian, Red Hat, Fedora, CentOS, Arch Linux, etc.
    -   BSD: FreeBSD -> macOS

Unix systems are made of three parts:

-   Shell: the interface between the user and the kernel
-   Kernel: the core of the operating system
-   Hardware: the physical machine

## SSH

We get into the server using ssh (secure socket shell). It is a cryptographic network protocol for operating network services securely over an unsecured network.

We use hash functions to encrypt the data. A hash function is a function that maps data of arbitrary size to data of fixed size. The result of a hash function is called a hash value, hash code, or simply hash.

An example of hash function is MD5. It is a widely used cryptographic hash function producing a 128-bit hash value. It is used to verify data integrity. But it is not recommended to use it for cryptographic purposes because it has been found to suffer from extensive vulnerabilities. The same input produces the same output, hackers can use a rainbow table to find the input from the output.

We prefer to hash with salt. Salt is a random data that is used as an additional input to a one-way function that hashes data, a password or passphrase. Salts are used to safeguard passwords in storage.

The golden standard now is SHA-256. It is a cryptographic hash function that takes an input of any length and returns a 256-bit fixed-length hash value.

If we want to hash a file, we can use the following command:

```bash
openssl sha256 file.txt
```

ssh uses public-key cryptography. It is a cryptographic system that uses pairs of keys: public keys which may be disseminated widely, and private keys which are known only to the owner. The generation of such keys depends on cryptographic algorithms based on mathematical problems to produce one-way functions. Effective security requires keeping the private key private; the public key can be openly distributed without compromising security.

How to access the server:

```bash
ssh -i ~/.ssh/id_rsa.pub user@ip
```

The first connection is made with the user `root`, not a good idea. Check below.

You can add your key to the keychain so you don't have to type your password every time you connect to the server.

Verify your .ssh/config file contains the following:

```bash
Host *
  AddKeysToAgent yes
  UseKeychain yes
```

And add your key to the keychain (the flag is only for macOS):

```bash
# we may need to start the ssh-agent before
eval `ssh-agent -s`
# add the key to the keychain
ssh-add --apple-use-keychain ~/.ssh/id_rsa
```

From now on, you can connect to the server with:

```bash
ssh user@ip
# alternatively you can use the -i flag to specify the path to the key
```

## Internet

How the internet works:

-   It is built on cooperation and rules: We agree on standards and protocols.
-   A simple diagram:
    -   Computer -> Network Card -> Router -> ISP -> Tier 1 ISP (Backbones) -> Datacenter -> Server cluster -> Load balancer -> Server
-   The internet is a network of networks
-   An intranet is a private network
-   LAN is a local area network (no latency)
-   WAN is a wide area network
-   IP is the internet protocol
-   IP address is a unique identifier for a computer on a network, there are two versions: IPv4 and IPv6

How to check the status of a network host:

```bash
ping google.com
```

How to follow the path of a request:

```bash
traceroute google.com
```

How to show the network status:

```bash
netstat -lt | less
```

TCP/UDP:

-   TCP is the transmission control protocol
-   UDP is the user datagram protocol
-   ICMP is the internet control message protocol: on top of tcp or udp, used for diagnostic and control purposes
-   Packet is a small amount of data transmitted over a network

The differences between TCP and UDP:

-   TCP is connection-oriented (handshake), UDP is connectionless
-   TCP is reliable (verifies data get its destination), UDP is unreliable
-   TCP is ordered, UDP is unordered
-   TCP is heavyweight, UDP is lightweight
-   UDP is usefull for streaming and faster than TCP

DNS/Nameserver:

-   DNS is the domain name system
-   Nameserver holds the DNS records to translate domain names into IP addresses

The computer talks to the nameserver to get the IP address of the domain name I want to access.

DNS records:

-   A record: maps a domain name to an IP address
-   CNAME record: maps a domain name to another domain name

We can look up the nameservers for a domain name with the following command:

```bash
nslookup google.com
```

We can look up the DNS records of a domain name with the following command:

```bash
dig google.com
```

Anatomy of an URL:

Url means uniform resource locator. It is a reference to a web resource that specifies its location on a computer network and a mechanism for retrieving it. A URL is a specific type of URI, although many people use the two terms interchangeably.

-   Protocol: http, https, ftp, etc.
-   Subdomain: www, api, etc.
-   Domain name: google, facebook, etc.
-   Top level domain: com, org, etc.
-   Port: 80, 443, etc.
-   Path: /, /about, etc.
-   Query string: ?q=hello, etc.
-   Fragment: #about, etc.

## Configure the server

Once you get a server and you can ssh into it, it is time to configure it. For this matter my server has Ubuntu 22 LTS installed.

First we upgrade and update the server:

```bash
apt update
apt upgrade
```

Then we shut down and restart the server:

```bash
shutdown -r now
```

Create a new user:

`root` is the default user, it has all the privileges. It is not a good idea to use it for security reasons.

We create a new user and give it the sudo (super user do) privileges so we can run programs and commands as root.

```bash
adduser john
# we add the new user to the sudo group
usermod -aG sudo john
# we switch to the new user (su)
su john
# we check the privileges running a command that requires sudo
sudo cat /var/log/auth.log
```

Once we have the new user, we can disable the root access:

-   We create a file .ssh/authorized_keys in the new user home directory.
-   We copy the public key of the user into the file.
-   We exit the server and try to connect with the new user.
-   We change the file permissions of the authorized_keys file to 644. `chmod 644 .ssh/authorized_keys`
-   We disable the root access. `sudo vim /etc/ssh/sshd_config`
-   We change the line `PermitRootLogin yes` to `PermitRootLogin no`
-   We restart the ssh service. `sudo service sshd restart`
-   We can use root again with `sudo -i`
-   Now can can exit twice and test that we cannot connect with root anymore. Also test that we can connect with the new user.

## Setup nginx

Nginx (engine-x) is a web server write in C that can also be used as a reverse proxy or forward proxy.

A reverse proxy is a server that sits in front of web servers and forwards client requests to those web servers. Reverse proxies are typically implemented to help increase security, performance, and reliability.

We need first to instal nginx in our server:

```bash
sudo apt install nginx
sudo service nginx start
```

If we go to the ip address of our server, we should see the nginx welcome page.

We can check out the nginx default site config file:

```bash
cat /etc/nginx/sites-available/default
```

Now we can install nodejs LTS version in our server using [nodesource](https://github.com/nodesource/distributions):

```bash
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - &&\
sudo apt-get install -y nodejs
```

Now we change the ownership of the `/var/www/` directory to the new user so we do not need to sudo every time:

```bash
sudo chown -R $USER:$USER /var/www
```

Then we create a new directory for our app, we cd into it, initialize a new git repository and initialize a new npm project:

```bash
mkdir /var/www/app
cd /var/www/app
git init
npm init
```

We create a new file `app.js` with a basic nodejs server using http package:

```js
const http = require('http')

const server = http.createServer((req, res) => {
    res.end('Hello world!')
})

server.listen(3000)
console.log('Server listening on port 3000')
```

Now we need to tell nginx to proxy the requests to our nodejs server using the proxy pass directive.

We create a file for the virtual server in the sites-enabled directory:

```bash
sudo vim /etc/nginx/sites-enabled/app
```

The content of the file is something like this:

```nginx
server {
  listen 80 default_server;
  listen [::]:80 default_server;

  server_name example.com;

  location / {
    proxy_pass http://localhost:3000;
  }
}
```

We replace example.com with our domain name.  
[::]:80 is the ipv6 localhost address.

We can check if the nginx config is correct with:

```bash
sudo nginx -t
```

In that case we still need to point nginx to our new virtual server.

```bash
sudo vim /etc/nginx/nginx.conf
```

And include the new virtual server:

```nginx
##
# Virtual Host Configs
##

include /etc/nginx/conf.d/*.conf;
include /etc/nginx/sites-enabled/app; #we modify this line
```

If you need to redirect with nginx you can go like this:

```nginx
server {
  location /about {
    return 301 https://example.com/about;
  }
}
```

If you want to gzip using nginx you can edit the file /etc/nginx/nginx.conf and add the following lines:

```nginx
gzip on;
```

We test again the nginx config:

```bash
sudo nginx -t
```

And if the config is ok we restart nginx:

```bash
sudo service nginx restart
```

And we run our nodejs server:

```bash
node app.js
```

But if we close the terminal now, our nodejs server will stop. We need to run it as a service, for that we will install pm2.

```bash
sudo npm install -g pm2
```

And run our nodejs server with pm2:

```bash
# we can add the flat --watch so that pm2 restarts the server when we change the code
pm2 start app.js --watch
# we can check the list of processes with
pm2 list
# we can restart the process with
pm2 restart app
```

If we restart the server we want our application to run automatically. For that we need to save the pm2 processes and run them on startup:

```bash
pm2 save
pm2 startup
# copy and paste the command that pm2 gives us
```

## Version control

At this point we need to create a repository for our application. We can use github or gitlab for that. We create a new repository and push our code to it. This way we can work on our code locally and push it to the repository. Then we can pull the changes from the repository to the server.

-   Create a repository in github
-   Create an ssh key in the server and add it to the github repository
-   Add the remote to the local repository on the server
-   Make sure your ssh key is used when you push to the repository:

```bash
# create a config file in the .ssh directory without sudo ⚠️
vim ~/.ssh/config
```

Then we map github.com to our ssh key within this file (assuming the key is named gh_key):

```bash
Host github.com
  Hostname github.com
  IdentityFile ~/.ssh/gh_key
```

Now we can push the code to the repository:

```bash
git push -u origin main
```

And then clone it into your local machine:

```bash
git clone git@github.com:github-account-name/repo-name.git
```

## Secure the server

The moment a server is connected to the internet, it is under attack. We need to secure it.

Check the auth.log to see who is trying to connect to the server:

```bash
cat /var/log/auth.log
```

A few points to consider:

-   SSH
-   Firewall
-   Updates
-   Two factor authentication
-   VPN

### Ports

A port is a communication endpoint. It is a number between 0 and 65535. They maps to specific processes or network services running on a computer.

See well known (reserved) ports:

```bash
less /etc/services
```

We can see the open ports of a server using nmap:

```bash
sudo apt install nmap
# the flag -sV is for extra information
nmap -sV <your server ip>
```

In that case, if we are running our app in port 3000 we should see something like this:

```
PORT     STATE    SERVICE
22/tcp   open     ssh
80/tcp   open     http
3000/tcp open     ppp
```

But we already have nginx to serve our application in port 80 so we do not need to open port 3000 to the public. We can close it using a firewall like ufw:

```bash
sudo ufw deny 3000
```

The difference between ufw "deny" and ufw "reject" is that "deny" will silently reject you, while "reject" sends messages back.

We can just allow ssh and http:

```bash
sudo ufw status # should output inactive
sudo ufw allow ssh
sudo ufw allow http
sudo ufw enable
```

If we execute status again, we should see something like this:

```bash
To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere
80/tcp                     ALLOW       Anywhere
22/tcp (v6)                ALLOW       Anywhere (v6)
80/tcp (v6)                ALLOW       Anywhere (v6)
```

### CHMOD

Sometimes we need to change the permissions of a file or directory. We can do that with chmod.

```bash
# change the permissions of a file
chmod 644 file.txt
# change the permissions of a directory
chmod 755 directory
```

-   4 stands for read
-   2 stands for write
-   1 stands for execute

We can add those numbers to get the permissions we want. The general rule is: apply the less permissions possible.

### Updates

We need to keep our server up to date automatically. We can do that with unattended-upgrades.

```bash
sudo apt install unattended-upgrades
# the enable upgrade flag is for automatic upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

## CI/CD

Continuous integration: is the practice of merging all developers' working copies to a shared mainline several times a day.

Continuous delivery: is a software engineering approach in which teams produce software in short cycles, ensuring that the software is automatically built and ready for production.

Continuous deployment: is a software release process that uses automated testing to validate if changes to a codebase are correct and stable for immediate autonomous deployment to a production environment.

We can build a CI/CD pipeline with github actions or other many tools like spinnaker depending on our needs. Also we can use a simple bash script to automate the deployment and use it cron to automate the process (just for fun).

We can create a bash script thats pull the changes from the main branch using git. We can execute `which bash` (in my case is `/usr/bin/bash`) to see where bash is installed. Then we can create a script.sh file with the following content:

```bash
#!/usr/bin/bash
# cd into the app directory
cd /var/www/app/
# pull the changes from the main branch
git pull origin main --ff-only
# install npm dependencies if any
npm install
```

The we can create a cron that executes that script every 2 minutes:

```bash
# edit the crontab file
crontab -e
# add the following line to execute the script every 2 minutes and log the output using logger
*/2 * * * * sh /var/www/app/github.sh 2>&1 | logger -t github.sh
```

You can go to [crontab guru](https://crontab.guru/) to see how to set up the cron.

We should set the appropiate permissions to the script:

```bash
chmod 700 github.sh
```

How do we know if a cronjob is running? We can check the cron log:

```bash
cat /var/log/syslog | grep CRON
# or maybe using tail
tail -f /var/log/syslog
```

:warning: You may need to configure keychain on ubuntu if you are connecting to the git server using a pair of public/private keys and the ssh-agent.

The ssh config `UseKeyChain yes` will not work on ubuntu, only on MacOs in the dev environment. You can install and configure keychain package and do not forget to add `source $HOME/.keychain/${HOSTNAME}-sh` into your cron bash script at the beginning otherwise the cron will run without the appropriate environment and it will not find your ssh keys.

### Create a subdomain

First we can create a new A record for the subdomain in the DNS records of our domain name.

Then we can create a new virtual server in nginx:

```bash
sudo vim /etc/nginx/sites-enabled/blog
```

The content of the file is something like this:

```nginx
server {
  listen 80;
  listen [::]:80;

  server_name blog.example.com;

  location / {
    proxy_pass http://localhost:3000;
  }
}
```

Next, include the new virtual server in the nginx config file:

```bash
sudo vim /etc/nginx/nginx.conf
# include /etc/nginx/sites-enabled/blog;
```

Then we test the nginx config and restart nginx:

```bash
sudo service nginx restart
```

## Websockets

A websocket is a computer communications protocol, providing full-duplex communication channels over a single TCP connection.

We can use websockets to send and receive data from the server in real time. We can use it to build a chat app, a multiplayer game, etc.

To enable websockets in our nginx configuration we need to add the following lines to the virtual server (assuming the server is running locally in port 3000, over http):

```nginx
server {
  listen 80;
  listen [::]:80;

  server_name myservername.com;

  location / {
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_pass http://localhost:3000;
  }
}
```

Then we can create a simple express.js server that uses websockets as this example shows (or maybe using another library like socket.io):

```js
const express = require('express')
const server = require('http').createServer()
const app = express()
const PORT = 3000

app.get('/', function (req, res) {
    res.sendFile('index.html', { root: __dirname })
})

server.on('request', app)

server.listen(PORT, function () {
    console.log('Listening on ' + PORT)
})

/** Websocket **/
const WebSocketServer = require('ws').Server

const wss = new WebSocketServer({ server: server })

wss.on('connection', function connection(ws) {
    const numClients = wss.clients.size

    console.log('clients connected: ', numClients)

    wss.broadcast(`Current visitors: ${numClients}`)

    if (ws.readyState === ws.OPEN) {
        ws.send('welcome!')
    }

    ws.on('close', function close() {
        wss.broadcast(`Current visitors: ${wss.clients.size}`)
        console.log('A client has disconnected')
    })

    ws.on('error', function error() {
        //
    })
})

/**
 * Broadcast data to all connected clients
 * @param  {Object} data
 * @void
 */
wss.broadcast = function broadcast(data) {
    console.log('Broadcasting: ', data)
    wss.clients.forEach(function each(client) {
        client.send(data)
    })
}
/** End Websocket **/
```

If the github script works, the code will be pulled from the repository and pm2 with the flag --watch will restart the server.

With `pm2 save` we save the processes.

## Database

We can use a database to store data. We can use a relational database like MySQL, SQLite, PostgreSQL. Those have strict structure that we access using SQL (Structured Query Language). Another kind of databases are non-relational databases like MongoDB, Redis, etc. Those are more flexible and we access them using a query language like MQL (MongoDB Query Language).

For the purpose of this post we will use SQLite. It is a relational database management system contained in a C library. In contrast to many other database management systems, SQLite is not a client–server database engine. Rather, it is embedded into the end program.

An example of initialization with SQLite:

```js
const sqlite3 = require('sqlite3').verbose()
const db = new sqlite3.Database(':memory:')

// we create a visitors table to store the count of
// visitors connected to the websocket.
db.serialize(function () {
    db.run(`CREATE TABLE visitors (
    count INTEGER
    time TEXT
  )`)
})

function getCounts() {
    db.get('SELECT * FROM visitors', function (err, row) {
        console.log(row)
    })
}

function shutdownDb() {
    getCounts()
    console.log('Shutting down database')
    db.close()
}
```

## HTTPS

HTTPS is a protocol for secure communication over a computer network which is widely used on the Internet. HTTPS consists of communication over Hypertext Transfer Protocol (HTTP) within a connection encrypted by Transport Layer Security (TLS).

Some common headers we send with HTTPS requests are:

-   Content-Type: application/json
-   Content-Length: 123
-   User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36
-   Accept: _/_
-   Accept-Encoding: gzip, deflate, br
-   Accept-Language: en-US,en;q=0.9,es;q=0.8,fr;q=0.7
-   Set-Cookie: foo=bar
-   X-: Is a custom header

The response typically has a status code and a body:

-   Status code: 200, 404, 500, etc.
-   Body: HTML, JSON, etc.

### TLS

With https we encrypt the data we send over the network. We can use [certbot](https://certbot.eff.org/instructions) to get a certificate for free.

The instructions there are pretty straightforward and the package automatically modify the nginx config file to use the certificate and redirect http(80) connection to https (443).

But we still need to open the port 443 using our firewall:

```bash
sudo ufw allow https
```

### http2

Lastly we can add support to http2.

We just need to add `http2` to the listen directive in the nginx config file:

```nginx
listen [::]:443 http2 ssl ipv6only=on; # managed by Certbot
listen 443 http2 ssl; # managed by Certbot
```

Then we check if the config is ok and restart nginx:

```bash
sudo nginx -t
sudo service nginx restart
```

## Containers

Microservices are small, autonomous services that work together. They are small, highly decoupled and focus on doing a small task.

Monolith is a single tiered software application in which the user interface and data access code are combined into a single program from a single platform.

We can use containers to deploy our microservices. A container is a standard unit of software that packages up code and all its dependencies so the application runs quickly and reliably from one computing environment to another. With containers we decouple the application and the infrastructure.

Docker is a very well known solution for containerization.

We need to create a docker file in the root of our project:

```docker
FROM node:19-alpine3.16
RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app
WORKDIR /home/node/app
COPY --chown=node:node package*.json ./
USER node
RUN npm install
COPY --chown=node:node . .
EXPOSE 3000
CMD [ "node", "app.js" ]
```

We install docker:

```bash
sudo apt install docker.io
```

Then we can build the image:

```bash
docker build -t image-name .
# we can see the images with
docker images
```

Then we can run the container:

```bash
docker run -d -p 3000:3000 image-name
```

We can create more containers changing the port.

```bash
docker run -d -p 3001:3000 image-name
docker run -d -p 3002:3000 image-name
```

### Orchestration and load balancing

We use tools like kubernetes, docker swarm, Amazon EKS... to orchestrate the containers. We can use a load balancer to distribute the traffic between the containers.

In that case we are using nginx as a load balancer. There are different algorithms to distribute the traffic between the containers. We can use round robin, least connections, ip hash, etc. Default in nginx is round robin.

If we are not sure about the load on one of the processes we can use the command `htop` to see the processes and the load on the server.

So we just need to update the nginx config file to use the load balancer:

```nginx
# nginx file
upstream app {
  server localhost:3000;
  server localhost:3001;
  server localhost:3002;
}

# site enabled file
server {
  listen 80;
  listen [::]:80;

  server_name myservername.com;

  location / {
    proxy_pass http://app;
  }
}
```
{% endraw %}
