#
# Produce an array of nftables.
# nft list tables
# table inet filter
# table ip nat
# table ip6 nat
# table inet f2b-table
#
Facter.add(:nftables) do
  @nft_cmd = Facter::Util::Resolution.which('nft')
  confine { @nft_cmd }

  setcode do
    tables = []
    table_result = Facter::Core::Execution.execute(%(#{@nft_cmd} list tables))
    table_result.each_line do |line|
      tables.push(line.split(' ')[1, 2].join('-'))
    end
    { 'tables' => tables }
  end
end
