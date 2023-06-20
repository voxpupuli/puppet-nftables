# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v3.0.1](https://github.com/voxpupuli/puppet-nftables/tree/v3.0.1) (2023-06-20)

[Full Changelog](https://github.com/voxpupuli/puppet-nftables/compare/v3.0.0...v3.0.1)

**Closed issues:**

- rspec tests fail on docker again. [\#167](https://github.com/voxpupuli/puppet-nftables/issues/167)

**Merged pull requests:**

- add ldap and active directory rules [\#177](https://github.com/voxpupuli/puppet-nftables/pull/177) ([SimonHoenscheid](https://github.com/SimonHoenscheid))
- Increased puppet/systemd upper limit to \< 6.0.0 [\#176](https://github.com/voxpupuli/puppet-nftables/pull/176) ([canihavethisone](https://github.com/canihavethisone))

## [v3.0.0](https://github.com/voxpupuli/puppet-nftables/tree/v3.0.0) (2023-05-25)

[Full Changelog](https://github.com/voxpupuli/puppet-nftables/compare/v2.6.1...v3.0.0)

**Breaking changes:**

- Drop puppet 6 support [\#173](https://github.com/voxpupuli/puppet-nftables/pull/173) ([traylenator](https://github.com/traylenator))

**Implemented enhancements:**

- Raise puppetlabs/concat upper limit to \< 9.0.0 [\#170](https://github.com/voxpupuli/puppet-nftables/pull/170) ([canihavethisone](https://github.com/canihavethisone))

**Merged pull requests:**

- Refresh REFERENCE [\#171](https://github.com/voxpupuli/puppet-nftables/pull/171) ([traylenator](https://github.com/traylenator))
- Fix typo in icinga2 rule documentation [\#169](https://github.com/voxpupuli/puppet-nftables/pull/169) ([baldurmen](https://github.com/baldurmen))

## [v2.6.1](https://github.com/voxpupuli/puppet-nftables/tree/v2.6.1) (2023-03-24)

[Full Changelog](https://github.com/voxpupuli/puppet-nftables/compare/v2.6.0...v2.6.1)

**Implemented enhancements:**

- Add bridge as a valid family for chain tables [\#165](https://github.com/voxpupuli/puppet-nftables/pull/165) ([luisfdez](https://github.com/luisfdez))
- Add Rocky 8 and 9 support [\#161](https://github.com/voxpupuli/puppet-nftables/pull/161) ([bastelfreak](https://github.com/bastelfreak))
- Declare AlmaLinux8 and AlmaLinux9 support [\#160](https://github.com/voxpupuli/puppet-nftables/pull/160) ([nbarrientos](https://github.com/nbarrientos))
- bump puppet/systemd to \< 5.0.0 [\#159](https://github.com/voxpupuli/puppet-nftables/pull/159) ([jhoblitt](https://github.com/jhoblitt))
- Allow netdev as table family in defined type nftables::chain [\#149](https://github.com/voxpupuli/puppet-nftables/pull/149) ([hugendudel](https://github.com/hugendudel))

**Fixed bugs:**

- Align filemode on RedHat to distro default [\#157](https://github.com/voxpupuli/puppet-nftables/pull/157) ([duritong](https://github.com/duritong))

**Closed issues:**

- failing to setup a basic firewall [\#158](https://github.com/voxpupuli/puppet-nftables/issues/158)

**Merged pull requests:**

- README improvements [\#162](https://github.com/voxpupuli/puppet-nftables/pull/162) ([anarcat](https://github.com/anarcat))

## [v2.6.0](https://github.com/voxpupuli/puppet-nftables/tree/v2.6.0) (2022-10-25)

[Full Changelog](https://github.com/voxpupuli/puppet-nftables/compare/v2.5.0...v2.6.0)

**Implemented enhancements:**

- Add class for outgoing HKP firewalling [\#153](https://github.com/voxpupuli/puppet-nftables/pull/153) ([bastelfreak](https://github.com/bastelfreak))
- Add Ubuntu support [\#152](https://github.com/voxpupuli/puppet-nftables/pull/152) ([bastelfreak](https://github.com/bastelfreak))
- split conntrack management into dedicated classes  [\#148](https://github.com/voxpupuli/puppet-nftables/pull/148) ([duritong](https://github.com/duritong))
- New nftables::file type to include raw file [\#147](https://github.com/voxpupuli/puppet-nftables/pull/147) ([traylenator](https://github.com/traylenator))

**Closed issues:**

- Add ability to include completely raw files [\#146](https://github.com/voxpupuli/puppet-nftables/issues/146)
- Add support for Debian [\#65](https://github.com/voxpupuli/puppet-nftables/issues/65)

## [v2.5.0](https://github.com/voxpupuli/puppet-nftables/tree/v2.5.0) (2022-08-26)

[Full Changelog](https://github.com/voxpupuli/puppet-nftables/compare/v2.4.0...v2.5.0)

**Implemented enhancements:**

- Add all nftables families as a valid noflush pattern [\#142](https://github.com/voxpupuli/puppet-nftables/pull/142) ([luisfdez](https://github.com/luisfdez))

**Fixed bugs:**

- Properly escape bridge in rulename [\#144](https://github.com/voxpupuli/puppet-nftables/pull/144) ([duritong](https://github.com/duritong))

**Closed issues:**

- nftables::bridges creates invalid rule names when bridge devices have multiple IP addresses [\#143](https://github.com/voxpupuli/puppet-nftables/issues/143)

## [v2.4.0](https://github.com/voxpupuli/puppet-nftables/tree/v2.4.0) (2022-07-11)

[Full Changelog](https://github.com/voxpupuli/puppet-nftables/compare/v2.3.0...v2.4.0)

**Implemented enhancements:**

- Add rule to allow outgoing whois queries [\#140](https://github.com/voxpupuli/puppet-nftables/pull/140) ([bastelfreak](https://github.com/bastelfreak))
- chrony: Allow filtering for outgoing NTP servers [\#139](https://github.com/voxpupuli/puppet-nftables/pull/139) ([bastelfreak](https://github.com/bastelfreak))
- Add class for pxp-agent firewalling [\#138](https://github.com/voxpupuli/puppet-nftables/pull/138) ([bastelfreak](https://github.com/bastelfreak))

## [v2.3.0](https://github.com/voxpupuli/puppet-nftables/tree/v2.3.0) (2022-07-06)

[Full Changelog](https://github.com/voxpupuli/puppet-nftables/compare/v2.2.1...v2.3.0)

**Implemented enhancements:**

- systemctl: Use relative path [\#136](https://github.com/voxpupuli/puppet-nftables/pull/136) ([bastelfreak](https://github.com/bastelfreak))
- Add Debian support [\#134](https://github.com/voxpupuli/puppet-nftables/pull/134) ([bastelfreak](https://github.com/bastelfreak))
- make path to echo configureable [\#133](https://github.com/voxpupuli/puppet-nftables/pull/133) ([bastelfreak](https://github.com/bastelfreak))
- make path to `nft` binary configureable [\#132](https://github.com/voxpupuli/puppet-nftables/pull/132) ([bastelfreak](https://github.com/bastelfreak))

## [v2.2.1](https://github.com/voxpupuli/puppet-nftables/tree/v2.2.1) (2022-05-02)

[Full Changelog](https://github.com/voxpupuli/puppet-nftables/compare/v2.2.0...v2.2.1)

**Merged pull requests:**

- rspec mock systemd process on docker [\#128](https://github.com/voxpupuli/puppet-nftables/pull/128) ([traylenator](https://github.com/traylenator))

## [v2.2.0](https://github.com/voxpupuli/puppet-nftables/tree/v2.2.0) (2022-02-27)

[Full Changelog](https://github.com/voxpupuli/puppet-nftables/compare/v2.1.0...v2.2.0)

**Implemented enhancements:**

- Add support for Arch Linux [\#124](https://github.com/voxpupuli/puppet-nftables/pull/124) ([hashworks](https://github.com/hashworks))
- Declare support for RHEL9, CentOS9 and OL9 [\#120](https://github.com/voxpupuli/puppet-nftables/pull/120) ([nbarrientos](https://github.com/nbarrientos))
- Rubocop corrections for rubocop 1.22.3 [\#118](https://github.com/voxpupuli/puppet-nftables/pull/118) ([traylenator](https://github.com/traylenator))
- Use protocol number instead of label [\#112](https://github.com/voxpupuli/puppet-nftables/pull/112) ([keachi](https://github.com/keachi))

**Fixed bugs:**

- Ensure that nftables.service remains active after it exits [\#125](https://github.com/voxpupuli/puppet-nftables/pull/125) ([hashworks](https://github.com/hashworks))

**Merged pull requests:**

- Fix typos in initial reference examples [\#122](https://github.com/voxpupuli/puppet-nftables/pull/122) ([hashworks](https://github.com/hashworks))

## [v2.1.0](https://github.com/voxpupuli/puppet-nftables/tree/v2.1.0) (2021-09-14)

[Full Changelog](https://github.com/voxpupuli/puppet-nftables/compare/v2.0.0...v2.1.0)

**Implemented enhancements:**

- nftables::set can only be assigned to 1 table [\#100](https://github.com/voxpupuli/puppet-nftables/issues/100)
- support a different table name for 'nat' [\#107](https://github.com/voxpupuli/puppet-nftables/pull/107) ([figless](https://github.com/figless))
- Allow declaring the same set in several tables [\#102](https://github.com/voxpupuli/puppet-nftables/pull/102) ([nbarrientos](https://github.com/nbarrientos))

**Fixed bugs:**

- fix datatype for $table and $dport [\#104](https://github.com/voxpupuli/puppet-nftables/pull/104) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- Allow stdlib 8.0.0 [\#106](https://github.com/voxpupuli/puppet-nftables/pull/106) ([smortex](https://github.com/smortex))
- switch from camptocamp/systemd to voxpupuli/systemd [\#103](https://github.com/voxpupuli/puppet-nftables/pull/103) ([bastelfreak](https://github.com/bastelfreak))
- pull fixtures from git and not forge [\#99](https://github.com/voxpupuli/puppet-nftables/pull/99) ([bastelfreak](https://github.com/bastelfreak))

## [v2.0.0](https://github.com/voxpupuli/puppet-nftables/tree/v2.0.0) (2021-06-03)

[Full Changelog](https://github.com/voxpupuli/puppet-nftables/compare/v1.3.0...v2.0.0)

**Breaking changes:**

- Drop Puppet 5, puppetlabs/concat 7.x, puppetlabs/stdlib 7.x, camptocamp/systemd: 3.x [\#92](https://github.com/voxpupuli/puppet-nftables/pull/92) ([traylenator](https://github.com/traylenator))
- Drop Puppet 5 support [\#79](https://github.com/voxpupuli/puppet-nftables/pull/79) ([kenyon](https://github.com/kenyon))

**Implemented enhancements:**

- Ability to set base chains [\#95](https://github.com/voxpupuli/puppet-nftables/issues/95)
- puppetlabs/concat: Allow 7.x [\#91](https://github.com/voxpupuli/puppet-nftables/pull/91) ([bastelfreak](https://github.com/bastelfreak))
- puppetlabs/stdlib: Allow 7.x [\#90](https://github.com/voxpupuli/puppet-nftables/pull/90) ([bastelfreak](https://github.com/bastelfreak))
- camptocamp/systemd: allow 3.x [\#89](https://github.com/voxpupuli/puppet-nftables/pull/89) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- Fix IPv4 source address type detection [\#93](https://github.com/voxpupuli/puppet-nftables/pull/93) ([nbarrientos](https://github.com/nbarrientos))

**Closed issues:**

- Class\[Nftables::Bridges\]\['bridgenames'\] contains a Regexp value. It will be converted to the String '/^br.+/' [\#83](https://github.com/voxpupuli/puppet-nftables/issues/83)

**Merged pull requests:**

- Allow creating a totally empty firewall [\#96](https://github.com/voxpupuli/puppet-nftables/pull/96) ([nbarrientos](https://github.com/nbarrientos))
- Amend link to Yasnippets [\#88](https://github.com/voxpupuli/puppet-nftables/pull/88) ([nbarrientos](https://github.com/nbarrientos))

## [v1.3.0](https://github.com/voxpupuli/puppet-nftables/tree/v1.3.0) (2021-03-25)

[Full Changelog](https://github.com/voxpupuli/puppet-nftables/compare/v1.2.0...v1.3.0)

**Implemented enhancements:**

- Add rules for QEMU/libvirt guests \(bridged virtual networking\) [\#85](https://github.com/voxpupuli/puppet-nftables/pull/85) ([nbarrientos](https://github.com/nbarrientos))
- Add nftables.version to structured fact. [\#84](https://github.com/voxpupuli/puppet-nftables/pull/84) ([traylenator](https://github.com/traylenator))
- Add rules for Apache ActiveMQ [\#82](https://github.com/voxpupuli/puppet-nftables/pull/82) ([nbarrientos](https://github.com/nbarrientos))
- Add Docker-CE default rules [\#80](https://github.com/voxpupuli/puppet-nftables/pull/80) ([luisfdez](https://github.com/luisfdez))

**Closed issues:**

- Increase puppetlabs/concat version in metadata [\#78](https://github.com/voxpupuli/puppet-nftables/issues/78)

**Merged pull requests:**

- Fix sections and add a pointer to code snippets for Emacs [\#81](https://github.com/voxpupuli/puppet-nftables/pull/81) ([nbarrientos](https://github.com/nbarrientos))

## [v1.2.0](https://github.com/voxpupuli/puppet-nftables/tree/v1.2.0) (2021-03-03)

[Full Changelog](https://github.com/voxpupuli/puppet-nftables/compare/v1.1.1...v1.2.0)

**Implemented enhancements:**

- start declaring the 'global' chain with module resources [\#73](https://github.com/voxpupuli/puppet-nftables/pull/73) ([lelutin](https://github.com/lelutin))

**Fixed bugs:**

- nftables service is broken after reboot [\#74](https://github.com/voxpupuli/puppet-nftables/issues/74)
- fix \#74 - ensure table are initialized before flushing them [\#75](https://github.com/voxpupuli/puppet-nftables/pull/75) ([duritong](https://github.com/duritong))

## [v1.1.1](https://github.com/voxpupuli/puppet-nftables/tree/v1.1.1) (2021-01-29)

[Full Changelog](https://github.com/voxpupuli/puppet-nftables/compare/v1.1.0...v1.1.1)

**Fixed bugs:**

- Simplerule: wrong IP protocol version filter statement for IPv6 traffic [\#69](https://github.com/voxpupuli/puppet-nftables/issues/69)
- Fix IP version filter for IPv6 traffic [\#70](https://github.com/voxpupuli/puppet-nftables/pull/70) ([nbarrientos](https://github.com/nbarrientos))

**Merged pull requests:**

- Improve nftables::rule's documentation [\#68](https://github.com/voxpupuli/puppet-nftables/pull/68) ([nbarrientos](https://github.com/nbarrientos))

## [v1.1.0](https://github.com/voxpupuli/puppet-nftables/tree/v1.1.0) (2021-01-25)

[Full Changelog](https://github.com/voxpupuli/puppet-nftables/compare/v1.0.0...v1.1.0)

**Implemented enhancements:**

- Enable parameter\_documentation lint [\#64](https://github.com/voxpupuli/puppet-nftables/pull/64) ([traylenator](https://github.com/traylenator))
- Add Samba in rules [\#62](https://github.com/voxpupuli/puppet-nftables/pull/62) ([glpatcern](https://github.com/glpatcern))
- Add some mail related outgoing rules [\#60](https://github.com/voxpupuli/puppet-nftables/pull/60) ([duritong](https://github.com/duritong))

**Fixed bugs:**

- nftables::simplerule should follow the same rules as nftables::rule [\#58](https://github.com/voxpupuli/puppet-nftables/issues/58)
- Align simplerule and rule rulename requirements [\#59](https://github.com/voxpupuli/puppet-nftables/pull/59) ([nbarrientos](https://github.com/nbarrientos))

**Closed issues:**

- Get it under the voxpupuli umbrella [\#35](https://github.com/voxpupuli/puppet-nftables/issues/35)

**Merged pull requests:**

- Add badges to README [\#63](https://github.com/voxpupuli/puppet-nftables/pull/63) ([traylenator](https://github.com/traylenator))
- Check that all the predefined rules are declared in the all rules acceptance test [\#53](https://github.com/voxpupuli/puppet-nftables/pull/53) ([nbarrientos](https://github.com/nbarrientos))

## [v1.0.0](https://github.com/voxpupuli/puppet-nftables/tree/v1.0.0) (2020-12-15)

[Full Changelog](https://github.com/voxpupuli/puppet-nftables/compare/0ba57c66a35ed4e9b570d8a6315a33a1c4ba3181...v1.0.0)

**Breaking changes:**

- switch the server naming [\#42](https://github.com/voxpupuli/puppet-nftables/pull/42) ([duritong](https://github.com/duritong))

**Implemented enhancements:**

- Use Stdlib::Port everywhere in place of Integer [\#56](https://github.com/voxpupuli/puppet-nftables/pull/56) ([traylenator](https://github.com/traylenator))
- Enable Puppet 7 support [\#51](https://github.com/voxpupuli/puppet-nftables/pull/51) ([bastelfreak](https://github.com/bastelfreak))
- Several fixes for nftables::config [\#48](https://github.com/voxpupuli/puppet-nftables/pull/48) ([nbarrientos](https://github.com/nbarrientos))
- rubocop corrections  [\#41](https://github.com/voxpupuli/puppet-nftables/pull/41) ([traylenator](https://github.com/traylenator))
- Add basic configuration validation acceptance test [\#38](https://github.com/voxpupuli/puppet-nftables/pull/38) ([traylenator](https://github.com/traylenator))
- Remove duplicate flush on reload [\#34](https://github.com/voxpupuli/puppet-nftables/pull/34) ([traylenator](https://github.com/traylenator))
- Add nftables::simplerule [\#33](https://github.com/voxpupuli/puppet-nftables/pull/33) ([nbarrientos](https://github.com/nbarrientos))
- Add Ceph and NFS rules [\#32](https://github.com/voxpupuli/puppet-nftables/pull/32) ([dvanders](https://github.com/dvanders))
- New parameter noflush\_tables to selectivly skip flush [\#31](https://github.com/voxpupuli/puppet-nftables/pull/31) ([traylenator](https://github.com/traylenator))
- Scientific Linux 8 will never exist [\#30](https://github.com/voxpupuli/puppet-nftables/pull/30) ([traylenator](https://github.com/traylenator))
- Enable conntrack in FORWARD [\#29](https://github.com/voxpupuli/puppet-nftables/pull/29) ([keachi](https://github.com/keachi))
- Do not test nftables::rules repeatadly [\#28](https://github.com/voxpupuli/puppet-nftables/pull/28) ([traylenator](https://github.com/traylenator))
- Allow sourcing sets from Hiera [\#26](https://github.com/voxpupuli/puppet-nftables/pull/26) ([nbarrientos](https://github.com/nbarrientos))
- Allow disabling default NAT tables and chains [\#25](https://github.com/voxpupuli/puppet-nftables/pull/25) ([nbarrientos](https://github.com/nbarrientos))
- Set a customisable rate limit to the logging rules [\#22](https://github.com/voxpupuli/puppet-nftables/pull/22) ([nbarrientos](https://github.com/nbarrientos))
- Make masking Service\['firewalld'\] optional [\#20](https://github.com/voxpupuli/puppet-nftables/pull/20) ([nbarrientos](https://github.com/nbarrientos))
- Move ICMP stuff to separate classes allowing better customisation [\#16](https://github.com/voxpupuli/puppet-nftables/pull/16) ([nbarrientos](https://github.com/nbarrientos))
- Move conntrack rules from global to INPUT and OUTPUT [\#14](https://github.com/voxpupuli/puppet-nftables/pull/14) ([nbarrientos](https://github.com/nbarrientos))
- Add comments for all the nftable::rules entries [\#13](https://github.com/voxpupuli/puppet-nftables/pull/13) ([traylenator](https://github.com/traylenator))
- Allow tables to add comments to $log\_prefix [\#12](https://github.com/voxpupuli/puppet-nftables/pull/12) ([nbarrientos](https://github.com/nbarrientos))
- Reload rules atomically and verify rules before deploy [\#10](https://github.com/voxpupuli/puppet-nftables/pull/10) ([traylenator](https://github.com/traylenator))
- Allow raw sets and dashes in set names [\#8](https://github.com/voxpupuli/puppet-nftables/pull/8) ([nbarrientos](https://github.com/nbarrientos))
- Add a parameter to control the fate of discarded traffic [\#7](https://github.com/voxpupuli/puppet-nftables/pull/7) ([nbarrientos](https://github.com/nbarrientos))
- Add rules for afs3\_callback in and out rules for kerberos and openafs. [\#6](https://github.com/voxpupuli/puppet-nftables/pull/6) ([traylenator](https://github.com/traylenator))
- Allow customising the log prefix [\#5](https://github.com/voxpupuli/puppet-nftables/pull/5) ([nbarrientos](https://github.com/nbarrientos))
- Add classes encapsulating rules for DHCPv6 client traffic \(in/out\) [\#4](https://github.com/voxpupuli/puppet-nftables/pull/4) ([nbarrientos](https://github.com/nbarrientos))
- Add support for named sets [\#3](https://github.com/voxpupuli/puppet-nftables/pull/3) ([nbarrientos](https://github.com/nbarrientos))
- New parameter out\_all, default false [\#1](https://github.com/voxpupuli/puppet-nftables/pull/1) ([traylenator](https://github.com/traylenator))

**Fixed bugs:**

- Correct nfs3 invalid udp /tcp matching rule and more tests [\#50](https://github.com/voxpupuli/puppet-nftables/pull/50) ([traylenator](https://github.com/traylenator))
- Prefix custom tables with custom- so they're loaded [\#47](https://github.com/voxpupuli/puppet-nftables/pull/47) ([nbarrientos](https://github.com/nbarrientos))
- Correct bad merge [\#15](https://github.com/voxpupuli/puppet-nftables/pull/15) ([traylenator](https://github.com/traylenator))

**Closed issues:**

- deploying custom tables is broken [\#45](https://github.com/voxpupuli/puppet-nftables/issues/45)
- Switch to Stdlib::Port everywhere [\#37](https://github.com/voxpupuli/puppet-nftables/issues/37)
- Add set definition from Hiera [\#24](https://github.com/voxpupuli/puppet-nftables/issues/24)
- Add an option to disable NAT [\#23](https://github.com/voxpupuli/puppet-nftables/issues/23)
- Add an option to limit the rate of logged messages [\#19](https://github.com/voxpupuli/puppet-nftables/issues/19)
- Rule API [\#17](https://github.com/voxpupuli/puppet-nftables/issues/17)
- Publish to forge.puppet.com [\#11](https://github.com/voxpupuli/puppet-nftables/issues/11)
- The global chain contains INPUT specific rules [\#9](https://github.com/voxpupuli/puppet-nftables/issues/9)
- The fate of forbidden packets should be configurable [\#2](https://github.com/voxpupuli/puppet-nftables/issues/2)

**Merged pull requests:**

- Docs for nftables::set [\#55](https://github.com/voxpupuli/puppet-nftables/pull/55) ([traylenator](https://github.com/traylenator))
- Remove a blank separating the doc string and the code [\#52](https://github.com/voxpupuli/puppet-nftables/pull/52) ([nbarrientos](https://github.com/nbarrientos))
- Release 1.0.0 [\#49](https://github.com/voxpupuli/puppet-nftables/pull/49) ([traylenator](https://github.com/traylenator))
- Correct layout of ignore table example [\#44](https://github.com/voxpupuli/puppet-nftables/pull/44) ([traylenator](https://github.com/traylenator))
- Fix typos and formatting in the README [\#43](https://github.com/voxpupuli/puppet-nftables/pull/43) ([nbarrientos](https://github.com/nbarrientos))
- Comment why firewalld\_enable parameter is required [\#40](https://github.com/voxpupuli/puppet-nftables/pull/40) ([traylenator](https://github.com/traylenator))
- modulesync  4.0.0 [\#36](https://github.com/voxpupuli/puppet-nftables/pull/36) ([traylenator](https://github.com/traylenator))
- Refresh REFERENCE [\#27](https://github.com/voxpupuli/puppet-nftables/pull/27) ([traylenator](https://github.com/traylenator))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
