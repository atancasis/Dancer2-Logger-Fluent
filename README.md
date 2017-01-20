# NAME

Dancer2::Logger::Fluent - Dancer2 logger engine for Fluent::Logger

# VERSION

version 0.04

# SYNOPSIS

    use Dancer2::Logger::Fluent;

# DESCRIPTION

Implements a structured event logger for Fluent via [Fluent::Logger](https://metacpan.org/pod/Fluent::Logger).

When a connection to the `fluentd` agent can't be established, messages
are "queued" internally. These messages will be flushed upon subsequent
calls to `log()`, as soon as a connection is established.

# METHODS

## log($level, $message)

Writes the log message to Fluent.

# CONFIGURATION

The setting **logger** should be set to `Fluent` in order to use this logging
engine in a Dancer2 application.

Below is a simple sample configuration:

    logger: "Fluent"

    engines:
      logger:
        Fluent:
          tag_prefix: "myapp"
          host: "127.0.0.1"
          port: 24224

The full list of allowed options are as follows:

- tag\_prefix

    Tag prepended to every message, defaults to the configured _appname_ or,
    if not defined, to the executable's basename.

- host

    Host running the `fluentd` agent, defaults to '127.0.0.1'.

- port

    Port listened by the `fluentd` agent, defaults to 24224.

- timeout

    Timeout in seconds, defaults to 3.0 as implemented in
    [Fluent::Logger](https://metacpan.org/pod/Fluent::Logger).

- socket

    Socket file location, defaults to undef as implemented in
    [Fluent::Logger](https://metacpan.org/pod/Fluent::Logger).

- prefer\_integer

    Whether integer is preferred as cascaded to
    Data::MessagePack->prefer\_integer.  Defaults to 1.

- event\_time

    Whether event timestamps (includes nanoseconds as supported by
    `fluentd` >= 0.14.0) will be included. Defaults to 0.

- buffer\_limit

    Buffer size limit, defaults to 8388608 (8MB) as implemented in
    [Fluent::Logger](https://metacpan.org/pod/Fluent::Logger).

- buffer\_overflow\_handler

    Custom coderef to handle buffer overflow in the event of connection
    failure, to mitigate loss of data in the event of connection failure.

- truncate\_buffer\_at\_overflow

    When _truncate\_buffer\_at\_overflow_ is true and pending buffer size is
    larger than _buffer\_limit_, pending buffer will still be kept but last
    message will not be sent and will not be appended to the buffer.
    Defaults to 0.

# MESSAGE FORMAT

Messages to `fluentd` will be a hash containing the following:

    {
      env       => $environment,
      timestamp => $current_timestamp,
      host      => $hostname,
      level     => $level,
      message   => $message,
      pid       => $$
    }

# AUTHOR

Arnold Tan Casis <atancasis@cpan.org>

# COPYRIGHT

Copyright 2017- Arnold Tan Casis

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

See [Dancer2](https://metacpan.org/pod/Dancer2) for details about logging in route handlers.

See [http://fluent.github.com](http://fluent.github.com) for details on `fluentd` itself.
