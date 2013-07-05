# `exportfact`: Publish and share facts between nodes

This module enables nodes to publish information about themselves
using custom facts, which are then exported to other nodes.

## Example

Suppose you have a node, `alice`, that you configure
as an HTTP proxy server. And you want all your other nodes to use
that node's IP address as their HTTP proxy.

First, you could make sure that your proxy server sets an exported
fact, let's call it `http_proxy_host`:

```puppet
node alice {
  include exportfact

  exportfact::export { 'http_proxy_host':
    value => $hostname,
    category => "http_proxy"
  }
}
```

The `category` is a logical grouping of facts.

Then, say every other node should know about the facts in the `http_proxy`
category:

```puppet
include exportfact

exportfact::import { 'http_proxy': }
```

Once the configuration has been applied on both the exporting and the
importing nodes, `facter -p http_proxy` on the importing node will
produce the `$hostname` of the exporting node
(in the example, `alice`).

Of course, you might also export other information about the service.
`$ipaddress` or `$fqdn` come to mind, for example.


## Background

On the exporting node, `exportfact::export` creates a file named
`<category>.txt` in the `facts.d` directory (normally,
`/etc/facter/facts.d`). Within this file, it uses Augeas to create
`name=value` pairs. It is the Augeas resource, not the full contents
of the file, that is exported.

On the importing node, in `exportfact::import` it's again Augeas that
sets the exported value in the `category.txt` file, such that Facter
can pick it up as a custom fact on its next run.

Note that `exportfact::export` exports a single fact, while
`exportfact::import` imports _all facts_ within a given category.
This distinction is deliberate.

## Prerequisites

As this module uses exported resources, it only works when
Stored Configuration is enabled:

```ini
[master]
storeconfigs = true
```

See the Puppet (and PuppetDB) documentation for more information about
Stored Configuration.
