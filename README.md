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

## Contribution

If you want to suggest new features or report bugs, feel free to open an issue [here](https://github.com/mschnitzer/teamspeak3/issues/new).

If you want to contribute to the code base:

1. Fork this repository
2. Create a new branch
3. Do your changes
4. Push them to GitHub
5. Open a pull request against the `master` branch
