require 'spec_helper'

describe 'nftables::rule' do
  let(:title) { 'out-foo' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with title set to <CHAIN_NAME>-<RULE>' do
        let(:title) { 'CHAIN_NAME-RULE' }

        context 'with source and content both unset' do
          it { is_expected.not_to compile }
        end
        context 'with source and content both set' do
          let(:params) do
            {
              source: 'foo',
              content: 'puppet:///modules/foo/bar',
            }
          end

          it {
            pending('Setting source and content should be made to fail')
            is_expected.not_to compile
          }
        end

        context 'with content parameter set' do
          let(:params) do
            {
              content: 'port 22 allow',
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-CHAIN_NAME-rule-RULE') }
          it {
            is_expected.to contain_concat__fragment('nftables-inet-filter-chain-CHAIN_NAME-rule-RULE_header').with
            {
              order: '50nftables-inet-filter-chain-CHAIN_NAME-rule-RULEa',
              target: 'nftables-inet-filter-chain-CHAIN_NAME',
              content: %r{^#.*$},
            }
          }
          it {
            is_expected.to contain_concat__fragment('nftables-inet-filter-chain-CHAIN_NAME-rule-RULE').with
            {
              order: '50nftables-inet-filter-chain-CHAIN_NAME-rule-RULEb',
              target: 'nftables-inet-filter-chain-CHAIN_NAME',
              content: '  port 22 allow',
            }
          }
          context 'with optional parameters set' do
            let(:params) do
              super().merge(order: '85',
                            table: 'TABLE')
            end

            it {
              is_expected.to contain_concat__fragment('nftables-TABLE-chain-CHAIN_NAME-rule-RULE_header').with
              {
                order: '85nftables-TABLE-chain-CHAIN_NAME-rule-RULEa',
                target: 'nftables-TABLE-chain-CHAIN_NAME',
                content: %r{^#.*$},
              }
            }
            it { is_expected.to contain_concat__fragment('nftables-TABLE-chain-CHAIN_NAME-rule-RULE') }
            it {
              is_expected.to contain_concat__fragment('nftables-TABLE-chain-CHAIN_NAME-rule-RULE').with
              {
                order: '85nftables-TABLE-chain-CHAIN_NAME-rule-RULEb',
                target: 'nftables-TABLE-chain-CHAIN_NAME',
                content: '  port 22 allow',
              }
            }
          end
        end

        context 'with source parameter set' do
          let(:params) do
            {
              source: 'puppet:///modules/foo/bar',
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-CHAIN_NAME-rule-RULE') }
          it {
            is_expected.to contain_concat__fragment('nftables-inet-filter-chain-CHAIN_NAME-rule-RULE_header').with
            {
              order: '50nftables-inet-filter-chain-CHAIN_NAME-rule-RULEa',
              target: 'nftables-inet-filter-chain-CHAIN_NAME',
              content: %r{^#.*$},
            }
          }
          it {
            is_expected.to contain_concat__fragment('nftables-inet-filter-chain-CHAIN_NAME-rule-RULE').with
            {
              order: '50nftables-inet-filter-chain-CHAIN_NAME-rule-RULEb',
              target: 'nftables-inet-filter-chain-CHAIN_NAME',
              source: 'puppet:///modules/foo/bar',
            }
          }
          context 'with optional parameters set' do
            let(:params) do
              super().merge(order: '85',
                            table: 'TABLE')
            end

            it {
              is_expected.to contain_concat__fragment('nftables-TABLE-chain-CHAIN_NAME-rule-RULE_header').with
              {
                order: '85nftables-TABLE-chain-CHAIN_NAME-rule-RULEa',
                target: 'nftables-TABLE-chain-CHAIN_NAME',
                content: %r{^#.*$},
              }
            }
            it { is_expected.to contain_concat__fragment('nftables-TABLE-chain-CHAIN_NAME-rule-RULE') }
            it {
              is_expected.to contain_concat__fragment('nftables-TABLE-chain-CHAIN_NAME-rule-RULE').with
              {
                order: '85nftables-TABLE-chain-CHAIN_NAME-rule-RULEb',
                target: 'nftables-TABLE-chain-CHAIN_NAME',
                source: 'puppet:///modules/foo/bar',
              }
            }
          end
        end
      end

      context 'with title set to <CHAIN_NAME>-<RULE>-22' do
        let(:title) { 'CHAIN_NAME-RULE-22' }

        context 'with content parameter set' do
          let(:params) do
            {
              content: 'port 22 allow',
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_concat__fragment('nftables-inet-filter-chain-CHAIN_NAME-rule-RULE-22') }
          it {
            is_expected.to contain_concat__fragment('nftables-inet-filter-chain-CHAIN_NAME-rule-RULE-22_header').with
            {
              order: '50nftables-inet-filter-chain-CHAIN_NAME-rule-RULE-22a',
              target: 'nftables-inet-filter-chain-CHAIN_NAME',
              content: %r{^#.*$},
            }
          }
          it {
            is_expected.to contain_concat__fragment('nftables-inet-filter-chain-CHAIN_NAME-rule-RULE-22').with
            {
              order: '50nftables-inet-filter-chain-CHAIN_NAME-rule-RULE-22b',
              target: 'nftables-inet-filter-chain-CHAIN_NAME',
              content: '  port 22 allow',
            }
          }
        end
      end
    end
  end
end
