require 'spec_helper'

describe 'nftables' do
  let(:pre_condition) { 'Exec{path => "/bin"}' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      context 'with bridge interfaces br0 and br1-2' do
        let(:facts) do
          os_facts.merge(
            networking:
              { interfaces:
                {
                  'lo' => {},
                  'br0' => {},
                  'br1-2' => {},
                } },
          )
        end

        it { is_expected.to compile }
        it { is_expected.not_to contain_nftables__rule('default_fwd-bridge_lo_lo') }

        it {
          is_expected.to contain_nftables__rule('default_fwd-bridge_br0_br0').with(
            order: '08',
            content: 'iifname br0 oifname br0 accept',
          )
        }

        it { is_expected.to contain_nftables__rule('default_fwd-bridge_br1_br1') }
        it {
          is_expected.to contain_nftables__rule('default_fwd-bridge_br1_br1').with(
            order: '08',
            content: 'iifname br1 oifname br1 accept',
          )
        }
      end
    end
  end
end
