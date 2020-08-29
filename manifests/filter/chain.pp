# register a filter chain
# Name should match the following pattern:
#
#  MASTERCHAIN-new_chain_name
define nftables::filter::chain(
  Pattern[/^[a-z0-9]+\-[a-z0-9_]+$/]
    $chain_name = $title,
  Pattern[/^\d{2}$/]
    $order      = '50',
){
  $data = split($chain_name,'-')
  nftables::config{
    "filter-${data[0]}-chains-${order}-${data[1]}":
      content => "jump ${data[1]}\n",
  }
  nftables::chain_file{
    "filter@${data[1]}":;
  }
}
