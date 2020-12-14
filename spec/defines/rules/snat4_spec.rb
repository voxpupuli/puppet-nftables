require 'spec_helper'

describe 'nftables::rules::snat4' do
  let(:title) { 'foobar' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with snat specified' do
        let(:params) do
          {
            snat: 'sausage',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_nftables__rule('POSTROUTING-foobar').with_content('snat sausage') }
        context 'with dport specified' do
          let(:params) do
            super().merge(dport: 1234)
          end

          it { is_expected.to contain_nftables__rule('POSTROUTING-foobar').with_content('tcp dport 1234 snat sausage') }
        end
      end
    end
  end
end
