require 'spec_helper'

describe 'nftables::rules::icmp' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default options' do
        it { is_expected.to compile }
        it {
          is_expected.to contain_nftables__rule('default_in-accept_icmpv4').with(
            content: 'ip protocol icmp accept',
            order: '10',
          )
        }
        it {
          is_expected.to contain_nftables__rule('default_in-accept_icmpv6').with(
            content: 'ip6 nexthdr ipv6-icmp accept',
            order: '10',
          )
        }
      end

      context 'with custom ICMP types (v4 only)' do
        let(:params) do
          {
            v4_types: ['echo-request limit rate 4/second', 'echo-reply'],
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_nftables__rule('default_in-accept_icmpv4_echo_request').with(
            content: 'ip protocol icmp icmp type echo-request limit rate 4/second accept',
            order: '10',
          )
        }
        it {
          is_expected.to contain_nftables__rule('default_in-accept_icmpv4_echo_reply').with(
            content: 'ip protocol icmp icmp type echo-reply accept',
            order: '10',
          )
        }
        it {
          is_expected.to contain_nftables__rule('default_in-accept_icmpv6').with(
            content: 'ip6 nexthdr ipv6-icmp accept',
            order: '10',
          )
        }
      end

      context 'with custom ICMP types (both v4 and v6)' do
        let(:params) do
          {
            v4_types: ['echo-request limit rate 4/second', 'echo-reply'],
            v6_types: ['echo-reply', 'nd-router-advert'],
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_nftables__rule('default_in-accept_icmpv4_echo_request').with(
            content: 'ip protocol icmp icmp type echo-request limit rate 4/second accept',
            order: '10',
          )
        }
        it {
          is_expected.to contain_nftables__rule('default_in-accept_icmpv4_echo_reply').with(
            content: 'ip protocol icmp icmp type echo-reply accept',
            order: '10',
          )
        }
        it {
          is_expected.to contain_nftables__rule('default_in-accept_icmpv6_echo_reply').with(
            content: 'ip6 nexthdr ipv6-icmp icmpv6 type echo-reply accept',
            order: '10',
          )
        }
        it {
          is_expected.to contain_nftables__rule('default_in-accept_icmpv6_nd_router_advert').with(
            content: 'ip6 nexthdr ipv6-icmp icmpv6 type nd-router-advert accept',
            order: '10',
          )
        }
      end
    end
  end
end
