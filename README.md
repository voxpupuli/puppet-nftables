# nftables puppet module

This module manages an opinionated nftables configuration

By default it sets up a firewall that drops every incoming
and outgoing connection.

It only allows outgoing dns,ntp and web traffic.

The config file has a inet filter and a ip nat table setup.

Additionally, the module comes with a basic infrastrcuture
to hook into different places.

## nftables config

The main configuration file loaded by the nftables service
will be `files/config/puppet.nft`, all other files created
by that module go into `files/config/puppet` and will also
be purged if not managed anymore.

The main configuration file includes dedicated files for
the filter and nat tables, as well as processes any
`custom-*.nft` files before hand.

The filter and NAT tables both have all the master chains
(INPUT,OUTPUT,FORWARD) configured, to which you can hook
in your own chains that can contain specific rules.

All filter masterchains drop by default.
By default we have a set of default_MASTERCHAIN chains
configured to which you can easily add your custom rules.

For specific needs you can add your own chain.

There is a global chain, that defines the default behavior
for all masterchains.

INPUT and OUTPUT to the loopback device is allowed by default,
though you could restrict it later.

### nftables::config

Manages a raw file in `/etc/nftables/puppet/${name}.nft`

Use this for any custom table files.

## nftables::chain_file

Prepares a chain file as a `concat` file to which you will be
able to add dedicated rules through `concat::fragments`.

The name must follow the pattern `TABLE@chain_name`, e.g.
`filter@my_chain`. This will a) prepare a snippet defining
the chain, that will be included in the filter table.

This define is more intended as a helper to setup chains
that will be used for the different tables, through their
own defines. See `nftables::filter::chain` as an example.

## nftables::filter::chain

This setups a chain for the filter table. You will be able
to add rules to that chain by using `nftables::filter::chain::rule`.

The name must follow the pattern: `MASTERCHAIN-new_chain_name`, which
defines to which masterchain that custom chain should be hooked into.

new_chain_name must be unique for all chains.

There is automatically a `jump` instruction added to the masterchain,
with the order preference.

## nftables::filter::chain::rule

A simple way to add rules to your custom chain. The name must be:
`CHAIN_NAME-rulename`, where CHAIN_NAME refers to your chain and
an arbitrary name for your rule.
The rule will be a `concat::fragment` to the chain `concat`.

You can define the order by using the `order` param.
