# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::rules::nomad' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default options' do
        it { is_expected.to compile }

        it {
          is_expected.to contain_nftables__set('nomad_ip').with(
            {
              type: 'ipv4_addr',
              elements: ['127.0.0.1'],
            }
          )
        }

        it {
          is_expected.to contain_nftables__set('nomad_ip6').with(
            {
              type: 'ipv6_addr',
              elements: ['::1'],
            }
          )
        }

        it {
          is_expected.to contain_nftables__rule('default_in-nomad_http').with_content('tcp dport 4646')
          is_expected.to contain_nftables__rule('default_in-nomad_rpc_ip6').with_content('tcp dport 4647 ip6 saddr @nomad_ip6 accept')
          is_expected.to contain_nftables__rule('default_in-nomad_rpc_ip').with_content('tcp dport 4647 ip saddr @nomad_ip accept')
          is_expected.to contain_nftables__rule('default_in-nomad_serf_tcp_ip6').with_content('tcp dport 4648 ip6 saddr @nomad_ip6 accept')
          is_expected.to contain_nftables__rule('default_in-nomad_serf_tcp_ip').with_content('tcp dport 4648 ip saddr @nomad_ip accept')
          is_expected.to contain_nftables__rule('default_in-nomad_serf_udp_ip6').with_content('udp dport 4648 ip6 saddr @nomad_ip6 accept')
          is_expected.to contain_nftables__rule('default_in-nomad_serf_udp_ip').with_content('udp dport 4648 ip saddr @nomad_ip accept')
        }
      end

      context 'with ports set' do
        let(:params) do
          {
            http: 1000,
            rpc: 2000,
            serf: 3000,
          }
        end

        it { is_expected.to compile }

        it {
          is_expected.to contain_nftables__set('nomad_ip')
          is_expected.to contain_nftables__set('nomad_ip6')
        }

        it {
          is_expected.to contain_nftables__rule('default_in-nomad_http').with_content('tcp dport 1000')
          is_expected.to contain_nftables__rule('default_in-nomad_rpc_ip6').with_content('tcp dport 2000 ip6 saddr @nomad_ip6 accept')
          is_expected.to contain_nftables__rule('default_in-nomad_rpc_ip').with_content('tcp dport 2000 ip saddr @nomad_ip accept')
          is_expected.to contain_nftables__rule('default_in-nomad_serf_tcp_ip6').with_content('tcp dport 3000 ip6 saddr @nomad_ip6 accept')
          is_expected.to contain_nftables__rule('default_in-nomad_serf_tcp_ip').with_content('tcp dport 3000 ip saddr @nomad_ip accept')
          is_expected.to contain_nftables__rule('default_in-nomad_serf_udp_ip6').with_content('udp dport 3000 ip6 saddr @nomad_ip6 accept')
          is_expected.to contain_nftables__rule('default_in-nomad_serf_udp_ip').with_content('udp dport 3000 ip saddr @nomad_ip accept')
        }
      end

      context 'with ipv4 hosts only' do
        let(:params) do
          {
            cluster_elements: ['127.0.0.1', '127.0.0.2']
          }
        end

        it {
          is_expected.to contain_nftables__set('nomad_ip').with(
            {
              type: 'ipv4_addr',
              elements: ['127.0.0.1', '127.0.0.2'],
            }
          )
        }

        it { is_expected.not_to contain_nftables__set('nomad_ip6') }

        it {
          is_expected.to contain_nftables__rule('default_in-nomad_http').with_content('tcp dport 4646')
          is_expected.not_to contain_nftables__rule('default_in-nomad_rpc_ip6')
          is_expected.to contain_nftables__rule('default_in-nomad_rpc_ip').with_content('tcp dport 4647 ip saddr @nomad_ip accept')
          is_expected.not_to contain_nftables__rule('default_in-nomad_serf_tcp_ip6')
          is_expected.to contain_nftables__rule('default_in-nomad_serf_tcp_ip').with_content('tcp dport 4648 ip saddr @nomad_ip accept')
          is_expected.not_to contain_nftables__rule('default_in-nomad_serf_udp_ip6')
          is_expected.to contain_nftables__rule('default_in-nomad_serf_udp_ip').with_content('udp dport 4648 ip saddr @nomad_ip accept')
        }
      end
    end
  end
end
