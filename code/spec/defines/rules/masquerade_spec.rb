require 'spec_helper'

describe 'nftables::rules::masquerade' do
  let(:title) { 'foobar' }
  let(:pre_condition) { 'include nftables' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with default parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_nftables__rule('POSTROUTING-foobar').with_content('masquerade') }
      end
      context 'with dport specified' do
        let(:params) do
          {
            dport: 1000
          }
        end

        it { is_expected.to contain_nftables__rule('POSTROUTING-foobar').with_content('tcp dport 1000 masquerade') }
      end
    end
  end
end
