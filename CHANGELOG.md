## Release 0.0.5 (unknown)

* Add `TeamSpeak3::QueryAccount` to modify the logged in query account. (Accessible via `TeamSpeak3::Server#query_account`)

## Release 0.0.4 (2018-03-11)

* Add `TeamSpeak3::VERSION` to fetch the current version of this library.
* Add `TeamSpeak3::Client#send_message` to allow to send messages directly via the client object
  without going all the way down to the `TeamSpeak3::Server#send_message`
* Add `TeamSpeak3::VirtualServer#execute` method which is basically a wrapper for `TeamSpeak3::Server#execute`
  but it always sets the active virtual server correctly.
* EOF errors will now be handled on connection attempts. (an EOF error will be raised when a connection has
  been established but gets closed immediately)
* Command execution on TeamSpeak 3 servers (TeamSpeak3::Server#execute) has been refactored.
* Add `TeamSpeak3::Server#prepare_command` to build a command that can be executed safely (internally used by
  `TeamSpeak3::Server#execute`)
* Add `TeamSpeak3::ChannelCollection` that represents an array of channels for a virtual server (abstraction of `Array`)
* `TeamSpeak3::VirtualServer#channels` now returns an instance of `TeamSpeak3::ChannelCollection`
* Channels can now be created through `TeamSpeak3::ChannelCollection#create`
* Channels can now be found with their ID via `TeamSpeak3::ChannelCollection#find`

## Release 0.0.3 (cancelled/skipped)

- This version has been cancelled and skipped -

## Release 0.0.2 (2018-03-05)

* `TeamSpeak3::VirtualServer` class was added to handle virtual servers.
* `TeamSpeak3::Channel` class was added to handle channels on virtual servers.
* `TeamSpeak3::Client` class was added to act on clients.
* New `attr_reader`'s were added to `TeamSpeak3::Server` (`ip_address` and `query_port`)
* Added `send_message_to` to class `TeamSpeak3::Server` to send messages to different targets (available targets: server, client, channel)
* Added method `kick_client!` to `TeamSpeak3::Server` which is being used by the `TeamSpeak3::Client` class to kick clients from servers or channels.
* Added `select_server` to `TeamSpeak3::Server` to select the current active virtual servers (this is required by the query interface of TeamSpeak 3). In general it should not be required to use this method at all because it's handled by the methods internally.

## Release 0.0.1 (2018-03-04)

* Add basic TeamSpeak 3 server connection handling
