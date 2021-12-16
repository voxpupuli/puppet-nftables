# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::rules::docker_ce' do
  let(:pre_condition) { 'include nftables' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include nftables' }

      context 'default options' do
        it { is_expected.to compile }
        it { is_expected.to contain_nftables__chain('DOCKER') }
        it { is_expected.to contain_nftables__chain('DOCKER_ISOLATION_STAGE_1') }
        it { is_expected.to contain_nftables__chain('DOCKER_ISOLATION_STAGE_2') }
        it { is_expected.to contain_nftables__chain('DOCKER_USER') }

        it {
          expect(subject).to contain_nftables__chain('DOCKER-nat').with(
            chain: 'DOCKER',
            table: 'ip-nat'
          )
        }

        it {
          expect(subject).to contain_nftables__chain('OUTPUT-nat').with(
            chain: 'OUTPUT',
            table: 'ip-nat'
          )
        }

        it {
          expect(subject).to contain_nftables__chain('INPUT-nat').with(
            chain: 'INPUT',
            table: 'ip-nat'
          )
        }

        it { is_expected.to contain_nftables__rule('DOCKER_ISOLATION_STAGE_1-iifname').with_content('iifname "docker0" oifname != "docker0" counter jump DOCKER_ISOLATION_STAGE_2') }
        it { is_expected.to contain_nftables__rule('DOCKER_ISOLATION_STAGE_1-counter').with_content('counter return') }
        it { is_expected.to contain_nftables__rule('DOCKER_ISOLATION_STAGE_2-drop').with_content('oifname "docker0" counter drop') }
        it { is_expected.to contain_nftables__rule('DOCKER_ISOLATION_STAGE_2-counter').with_content('counter return') }
        it { is_expected.to contain_nftables__rule('DOCKER_USER-counter').with_content('counter return') }
        it { is_expected.to contain_nftables__rule('default_fwd-jump_docker_user').with_content('counter jump DOCKER_USER') }
        it { is_expected.to contain_nftables__rule('default_fwd-jump_docker_isolation_stage_1').with_content('counter jump DOCKER_ISOLATION_STAGE_1') }
        it { is_expected.to contain_nftables__rule('default_fwd-out_docker_accept').with_content('oifname "docker0" ct state established,related counter accept') }
        it { is_expected.to contain_nftables__rule('default_fwd-jump_docker').with_content('oifname "docker0" counter jump DOCKER') }
        it { is_expected.to contain_nftables__rule('default_fwd-idocker_onot_accept').with_content('iifname "docker0" oifname != "docker0" counter accept') }
        it { is_expected.to contain_nftables__rule('default_fwd-idocker_odocker_accept').with_content('iifname "docker0" oifname "docker0" counter accept') }

        it {
          expect(subject).to contain_nftables__rule('POSTROUTING-docker').with(
            content: 'oifname != "docker0" ip saddr 172.17.0.0/16 counter masquerade',
            table: 'ip-nat'
          )
        }

        it {
          expect(subject).to contain_nftables__rule('PREROUTING-docker').with(
            content: 'fib daddr type local counter jump DOCKER',
            table: 'ip-nat'
          )
        }

        it {
          expect(subject).to contain_nftables__rule('OUTPUT-jump_docker@ip-nat').with(
            rulename: 'OUTPUT-jump_docker',
            content: 'ip daddr != 127.0.0.0/8 fib daddr type local counter jump DOCKER',
            table: 'ip-nat'
          )
        }

        it {
          expect(subject).to contain_nftables__rule('DOCKER-counter').with(
            content: 'iifname "docker0" counter return',
            table: 'ip-nat'
          )
        }

        it {
          expect(subject).to contain_nftables__rule('INPUT-type@ip-nat').with(
            rulename: 'INPUT-type',
            content: 'type nat hook input priority 100',
            table: 'ip-nat'
          )
        }

        it {
          expect(subject).to contain_nftables__rule('INPUT-policy@ip-nat').with(
            rulename: 'INPUT-policy',
            content: 'policy accept',
            table: 'ip-nat'
          )
        }
      end

      context 'with base chain management false' do
        let(:params) do
          {
            manage_base_chains: false,
          }
        end

        it { is_expected.to compile }

        it { is_expected.to contain_nftables__chain('DOCKER') }
        it { is_expected.to contain_nftables__chain('DOCKER_ISOLATION_STAGE_1') }
        it { is_expected.to contain_nftables__chain('DOCKER_ISOLATION_STAGE_2') }
        it { is_expected.to contain_nftables__chain('DOCKER_USER') }
        it { is_expected.to contain_nftables__chain('DOCKER-nat') }

        it { is_expected.not_to contain_nftables__chain('OUTPUT-nat') }
        it { is_expected.not_to contain_nftables__chain('INPUT-nat') }
      end

      context 'with docker chain management false' do
        let(:params) do
          {
            manage_docker_chains: false,
          }
        end

        it { is_expected.to compile }

        it { is_expected.not_to contain_nftables__chain('DOCKER') }
        it { is_expected.not_to contain_nftables__chain('DOCKER_ISOLATION_STAGE_1') }
        it { is_expected.not_to contain_nftables__chain('DOCKER_ISOLATION_STAGE_2') }
        it { is_expected.not_to contain_nftables__chain('DOCKER_USER') }
        it { is_expected.not_to contain_nftables__chain('DOCKER-nat') }

        it { is_expected.to contain_nftables__chain('OUTPUT-nat') }
        it { is_expected.to contain_nftables__chain('INPUT-nat') }
      end

      context 'with custom interface and subnet' do
        let(:params) do
          {
            docker_interface: 'ifdo0',
            docker_prefix: '192.168.4.0/24',
          }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_nftables__rule('DOCKER_ISOLATION_STAGE_1-iifname').with_content('iifname "ifdo0" oifname != "ifdo0" counter jump DOCKER_ISOLATION_STAGE_2') }
        it { is_expected.to contain_nftables__rule('DOCKER_ISOLATION_STAGE_2-drop').with_content('oifname "ifdo0" counter drop') }
        it { is_expected.to contain_nftables__rule('default_fwd-out_docker_accept').with_content('oifname "ifdo0" ct state established,related counter accept') }
        it { is_expected.to contain_nftables__rule('default_fwd-jump_docker').with_content('oifname "ifdo0" counter jump DOCKER') }
        it { is_expected.to contain_nftables__rule('default_fwd-idocker_onot_accept').with_content('iifname "ifdo0" oifname != "ifdo0" counter accept') }
        it { is_expected.to contain_nftables__rule('default_fwd-idocker_odocker_accept').with_content('iifname "ifdo0" oifname "ifdo0" counter accept') }

        it {
          expect(subject).to contain_nftables__rule('POSTROUTING-docker').with(
            content: 'oifname != "ifdo0" ip saddr 192.168.4.0/24 counter masquerade',
            table: 'ip-nat'
          )
        }

        it {
          expect(subject).to contain_nftables__rule('DOCKER-counter').with(
            content: 'iifname "ifdo0" counter return',
            table: 'ip-nat'
          )
        }
      end
    end
  end
end
