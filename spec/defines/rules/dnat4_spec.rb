require 'spec_helper'

describe 'nftables::rules::dnat4' do
  let(:title) { 'foobar' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with minumum parameters' do
        let(:params) do
          {
            daddr: '127.127.127.127',
            port: 100,
          }
        end

        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
