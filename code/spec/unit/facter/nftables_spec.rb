require 'spec_helper'

describe 'nftables' do
  before do
    Facter.clear
    Process.stubs(:uid).returns(0)
    Facter::Util::Resolution.stubs(:which).with('nft').returns('/usr/sbin/nft')
    Facter::Core::Execution.stubs(:execute).with('/usr/sbin/nft list tables').returns(nft_tables_result)
    Facter::Core::Execution.stubs(:execute).with('/usr/sbin/nft --version').returns(nft_version_result)
  end

  context 'nft present' do
    let(:nft_tables_result) { "table inet firewalld\ntable ip firewalld\n" }
    let(:nft_version_result) { "nftables v0.9.15 (Topsy)\n" }

    it 'returns valid fact' do
      expect(Facter.fact('nftables').value).to eq('tables' => ['inet-firewalld', 'ip-firewalld'], 'version' => '0.9.15')
    end
  end

  context 'nft fails' do
    let(:nft_tables_result) { :failed }
    let(:nft_version_result) { :failed }

    it 'does not return a fact' do
      Facter::Core::Execution.stubs(:execute).with('/usr/sbin/nft --version', on_fail: :failed).returns(:failed)
      Facter::Core::Execution.stubs(:execute).with('/usr/sbin/nft list tables', on_fail: :failed).returns(:failed)

      expect(Facter.fact('nftables').value).to be_nil
    end
  end
end
