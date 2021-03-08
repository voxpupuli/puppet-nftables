require 'spec_helper'

describe 'nftables::rules::docker_ce' do
  let(:pre_condition) { 'include nftables' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'default options' do
        it { is_expected.to compile }
        it { is_expected.to contain_nftables__chain('DOCKER') }
        it { is_expected.to contain_nftables__chain('DOCKER_ISOLATION_STAGE_1') }
        it { is_expected.to contain_nftables__chain('DOCKER_ISOLATION_STAGE_2') }
        it { is_expected.to contain_nftables__chain('DOCKER_USER') }
        it {
          is_expected.to contain_nftables__chain('DOCKER-nat').with(
            chain: 'DOCKER',
            table: 'ip-nat',
          )
        }
        it {
          is_expected.to contain_nftables__chain('OUTPUT-nat').with(
            chain: 'OUTPUT',
            table: 'ip-nat',
          )
        }
        it {
          is_expected.to contain_nftables__chain('INPUT-nat').with(
            chain: 'INPUT',
            table: 'ip-nat',
          )
        }
        it { is_expected.to contain_nftables__rule('DOCKER_ISOLATION_STAGE_2-drop').with_content('oifname "docker0" counter drop') }
        it {
          is_expected.to contain_nftables__rule('POSTROUTING-docker').with(
            content: 'oifname != "docker0" ip saddr 172.17.0.0/16 counter masquerade',
            table: 'ip-nat',
          )
        }
      end

      context 'with custom interface and subnet' do
        let(:params) do
          {
            docker_interface: 'ifdo0',
            docker_prefix: '192.168.4.0/24',
          }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('DOCKER_ISOLATION_STAGE_2-drop').with_content('oifname "ifdo0" counter drop') }
        it {
          is_expected.to contain_nftables__rule('POSTROUTING-docker').with(
            content: 'oifname != "ifdo0" ip saddr 192.168.4.0/24 counter masquerade',
            table: 'ip-nat',
          )
        }
      end
    end
  end
end