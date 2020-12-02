require 'spec_helper'

describe 'nftables' do
  before(:each) do
    Facter.clear
    Process.stubs(:uid).returns(0)
    Facter::Util::Resolution.stubs(:which).with('nft').returns('/usr/sbin/nft')
    Facter::Core::Execution.stubs(:execute).with('/usr/sbin/nft list tables').returns(nft_result)
  end

  context 'nft rules present' do
    let(:nft_result) { "table inet firewalld\ntable ip firewalld\n" }

    it 'returns valid tables' do
      expect(Facter.fact('nftables').value).to eq('tables' => ['inet-firewalld', 'ip-firewalld'])
    end
  end

  context 'nft fails' do
    let(:nft_result) { :failed }

    it 'does not return a fact' do
      Facter::Core::Execution.stubs(:execute).with('/usr/sbin/nft list tables', on_fail: :failed).returns(:failed)

      expect(Facter.fact('nftables').value).to be_nil
    end
  end
end
