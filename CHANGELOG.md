## Release 0.0.3 (unknown)

* Add `TeamSpeak3::VERSION` to fetch the current version of this library.

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
