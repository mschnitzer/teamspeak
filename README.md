# TeamSpeak 3 Query Library

[![Gem Version](https://badge.fury.io/rb/teamspeak3.svg)](http://badge.fury.io/rb/teamspeak3)

**NOTE: This library is currently being developed and should not be used for production purposes!**

An OOP library to query and manage TeamSpeak 3 servers in Ruby.

## Installation

```
gem install teamspeak3
```

## Getting Started

```ruby
require 'teamspeak3'

server = TeamSpeak3::Server.new('127.0.0.1', 10011)
server.login 'serveradmin', 'password'
```
