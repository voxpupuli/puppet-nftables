require 'spec_helper'

describe 'nftables::rules::qemu' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default options' do
        it { is_expected.to compile }
        it {
          is_expected.to contain_nftables__rule('default_in-qemu_udp_dns').
            with_content('iifname "virbr0" udp dport 53 accept')
        }
        it {
          is_expected.to contain_nftables__rule('default_in-qemu_tcp_dns').
            with_content('iifname "virbr0" tcp dport 53 accept')
        }
        it {
          is_expected.to contain_nftables__rule('default_in-qemu_dhcpv4').
            with_content('iifname "virbr0" meta l4proto udp udp dport 67 accept')
        }
        it {
          is_expected.to contain_nftables__rule('default_fwd-qemu_oip_v4').
            with_content('oifname "virbr0" ip daddr 192.168.122.0/24 ct state related,established accept')
        }
        it {
          is_expected.to contain_nftables__rule('default_fwd-qemu_iip_v4').
            with_content('iifname "virbr0" ip saddr 192.168.122.0/24 accept')
        }
        it { is_expected.not_to contain_nftables__rule('default_fwd-qemu_oip_v6') }
        it { is_expected.not_to contain_nftables__rule('default_fwd-qemu_iip_v6') }
        it {
          is_expected.to contain_nftables__rule('default_fwd-qemu_io_internal').
            with_content('iifname "virbr0" oifname "virbr0" accept')
        }
        it {
          is_expected.to contain_nftables__rule('POSTROUTING-qemu_ignore_multicast').with(
            content: 'ip saddr 192.168.122.0/24 ip daddr 224.0.0.0/24 return',
            table: 'ip-nat'
          )
        }
        it {
          is_expected.to contain_nftables__rule('POSTROUTING-qemu_ignore_broadcast').with(
            content: 'ip saddr 192.168.122.0/24 ip daddr 255.255.255.255 return',
            table: 'ip-nat'
          )
        }
        it {
          is_expected.to contain_nftables__rule('POSTROUTING-qemu_masq_tcp').with(
            content: 'meta l4proto tcp ip saddr 192.168.122.0/24 ip daddr != 192.168.122.0/24 masquerade to :1024-65535',
            table: 'ip-nat'
          )
        }
        it {
          is_expected.to contain_nftables__rule('POSTROUTING-qemu_masq_udp').with(
            content: 'meta l4proto udp ip saddr 192.168.122.0/24 ip daddr != 192.168.122.0/24 masquerade to :1024-65535',
            table: 'ip-nat'
          )
        }
        it {
          is_expected.to contain_nftables__rule('POSTROUTING-qemu_masq_ip').with(
            content: 'ip saddr 192.168.122.0/24 ip daddr != 192.168.122.0/24 masquerade',
            table: 'ip-nat'
          )
        }
      end

      context 'with all off' do
        let(:params) do
          {
            dns: false,
            dhcpv4: false,
            forward_traffic: false,
            internal_traffic: false,
            masquerade: false,
          }
        end

        it { is_expected.to compile }
        it { is_expected.to have_resource_count(0) }
      end

      context 'ipv6 prefix' do
        let(:params) do
          {
            network_v6: '20ac:cafe:1:1::/64',
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_nftables__rule('default_fwd-qemu_oip_v4').
            with_content('oifname "virbr0" ip daddr 192.168.122.0/24 ct state related,established accept')
        }
        it {
          is_expected.to contain_nftables__rule('default_fwd-qemu_iip_v4').
            with_content('iifname "virbr0" ip saddr 192.168.122.0/24 accept')
        }
        it {
          is_expected.to contain_nftables__rule('default_fwd-qemu_oip_v6').
            with_content('oifname "virbr0" ip6 daddr 20ac:cafe:1:1::/64 ct state related,established accept')
        }
        it {
          is_expected.to contain_nftables__rule('default_fwd-qemu_iip_v6').
            with_content('iifname "virbr0" ip6 saddr 20ac:cafe:1:1::/64 accept')
        }
      end

      context 'change interface' do
        let(:params) do
          {
            interface: 'vfoo0'
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_nftables__rule('default_fwd-qemu_iip_v4').
            with_content('iifname "vfoo0" ip saddr 192.168.122.0/24 accept')
        }
      end

      context 'change ipv4 prefix' do
        let(:params) do
          {
            network_v4: '172.16.0.0/12'
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_nftables__rule('default_fwd-qemu_iip_v4').
            with_content('iifname "virbr0" ip saddr 172.16.0.0/12 accept')
        }
      end
    end
  end
end
