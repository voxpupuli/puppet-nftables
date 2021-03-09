# nftables puppet module

[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/nftables.svg)](https://forge.puppetlabs.com/puppet/nftables)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/nftables.svg)](https://forge.puppetlabs.com/puppet/nftables)
[![puppetmodule.info docs](http://www.puppetmodule.info/images/badge.png)](http://www.puppetmodule.info/m/puppet-nftables)
[![Apache-2.0 License](https://img.shields.io/github/license/voxpupuli/puppet-nftables.svg)](LICENSE)

This module manages an opinionated nftables configuration.

By default it sets up a firewall that drops every incoming
and outgoing connection.

It only allows outgoing dns, ntp and web and ingoing ssh
traffic, although this can be overridden using parameters.

The config file has a inet filter and a ip nat table setup.

Additionally, the module comes with a basic infrastructure
to hook into different places.

## Configuration

The main configuration file loaded by the nftables service
will be `files/config/puppet.nft`, all other files created
by that module go into `files/config/puppet` and will also
be purged if not managed anymore.

The main configuration file includes dedicated files for
the filter and nat tables, as well as processes any
`custom-*.nft` files before hand.

The filter and NAT tables both have all the master chains
(INPUT, OUTPUT, FORWARD in case of filter and PREROUTING
and POSTROUTING in case of NAT) configured, to which you
can hook in your own chains that can contain specific
rules.

All filter masterchains drop by default.
By default we have a set of default_MASTERCHAIN chains
configured to which you can easily add your custom rules.

For specific needs you can add your own chain.

There is a global chain, that defines the default behavior
for all masterchains. This chain is empty by default.

INPUT and OUTPUT to the loopback device is allowed by
default, though you could restrict it later.

## Rules Validation

Initially puppet deploys all configuration to
`/etc/nftables/puppet-preflight/` and
`/etc/nftables/puppet-preflight.nft`. This is validated with
`nfc -c -L /etc/nftables/puppet-preflight/ -f /etc/nftables/puppet-preflight.nft`.
If and only if successful the configuration will be copied to
the real locations before the service is reloaded.

## Basic types

### nftables::config

Manages a raw file in `/etc/nftables/puppet/${name}.nft`

Use this for any custom table files.

### nftables::chain

Prepares a chain file as a `concat` file to which you will
be able to add dedicated rules through `nftables::rule`.

The name must be unique for all chains. The inject
parameter can be used to directly add a jump to a
masterchain. inject must follow the pattern
`ORDER-MASTERCHAIN`, where order references a 2-digit
number which defines the rule order (by default use e.g. 20)
and masterchain references the chain to hook in the new
chain. It's possible to specify the in-interface name and
out-interface name for the inject rule.

### nftables::rule

A simple way to add rules to any chain. The name must be:
`CHAIN_NAME-rulename`, where CHAIN_NAME refers to your
chain and an arbitrary name for your rule.
The rule will be a `concat::fragment` to the chain
`CHAIN_NAME`.

You can define the order by using the `order` param.

Before defining your own rule, take a look to the list of ready-to-use rules
available in the
[REFERENCE](https://github.com/voxpupuli/puppet-nftables/blob/master/REFERENCE.md),
somebody might have encapsulated a rule definition for you already.

### nftables::set

Adds a named set to a given table. It allows composing the
set using individual parameters but also takes raw input
via the content and source parameters.

### nftables::simplerule

Allows expressing firewall rules without having to use nftables's language by
adding an abstraction layer a-la-Firewall. It's rather limited how far you can
go so if you need rather complex rules or you can speak nftables it's
recommended to use `nftables::rule` directly.
