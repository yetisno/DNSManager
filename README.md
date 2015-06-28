# DNSManager

Easy way to build own DNS, this support base function like [A, CNAME, MX, NS, SOA] and user management.

![DNSManager](https://github.com/yetisno/DNSManager/blob/master/dnsmanager.png?raw=true)
 
for detail install and use, see [DNSAdmin](https://github.com/yetisno/DNSAdmin/blob/master/README.md) and [DNService](https://github.com/yetisno/DNService/blob/master/README.md)

# Fast start

## 1. Install Ruby and Bundle

### For Ubuntu
```bash
sudo apt-get install -y curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev
mkdir /tmp/ruby && cd /tmp/ruby
curl -L --progress http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.1.tar.gz | tar xz
cd ruby-2.2.1
./configure --disable-install-rdoc
make
sudo make install
sudo gem install bundler --no-ri --no-rdoc
```

### Install from RVM
```bash
# for Linux
curl -sSL https://get.rvm.io | bash -s stable --ruby=2.2.1 --rails

# for Mac OSX
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
curl -sSL https://get.rvm.io | bash -s stable --ruby=2.2.1 --rails
```

## 2. Start Service
Enter `DNSManager` directory, run `start.sh`!

# Setting
## DNService

Change the parameter or set environment variable to your own, see [DNService/config/dnservice.yml](DNService/config/dnservice.yml)

```yaml
bind-ip: DNService's IP
bind-port: DNService's Port
ttl:  Record's TTL
recursive-query: Use forwarder to handle unhosted domain?
forwarder-ip: Forwarder's IP
forwarder-port: Forwarder's Port
db-connection-string: Record Database connection string
reload-key: Use to force reload record from database
```

## DNSAdmin

Change the parameter or set environment variable to your own, see [DNService/config/dnsadmin.yml](DNService/config/dnsadmin.yml)

```yaml
dnsadmin:
    bind-ip: web bind ip
    bind-port: web bind port
dnservice:
    ip: DNService' ip
    port: DNService' port
    reload-key: DNService's reload key
```

# Usage
    start.sh    # Start Service
    stop.sh     # Stop Service

# Default Login Account
    admin/password      # administrator account
    user/password       # normal user account

#### Contributor:

1. Yeti Sno (yeti@yetiz.org)
2. Cake Ant \[Gloria Lin\] (ant@yetiz.org)
