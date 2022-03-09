# frozen_string_literal: true

require 'spec_helper'

describe 'nftables' do
  before do
    Facter.clear
    allow(Process).to receive(:uid).and_return(0)
    allow(Facter::Util::Resolution).to receive(:which).with('nft').and_return('/usr/sbin/nft')
    allow(Facter::Core::Execution).to receive(:execute).with('/usr/sbin/nft list tables').and_return(nft_tables_result)
    allow(Facter::Core::Execution).to receive(:execute).with('/usr/sbin/nft --version').and_return(nft_version_result)
  end

  context 'nft present' do
    let(:nft_tables_result) { "table inet firewalld\ntable ip firewalld\n" }
    let(:nft_version_result) { "nftables v0.9.15 (Topsy)\n" }

    it 'returns valid fact' do
      expect(Facter.fact('nftables').value).to eq('tables' => %w[inet-firewalld ip-firewalld], 'version' => '0.9.15')
    end
  end

  context 'nft fails' do
    let(:nft_tables_result) { :failed }
    let(:nft_version_result) { :failed }

    it 'does not return a fact' do
      allow(Facter::Core::Execution).to receive(:execute).with('/usr/sbin/nft --version', onfail: :failed).and_return(:failed)
      allow(Facter::Core::Execution).to receive(:execute).with('/usr/sbin/nft list tables', onfail: :failed).and_return(:failed)

      expect(Facter.fact('nftables').value).to be_nil
    end
  end
end
