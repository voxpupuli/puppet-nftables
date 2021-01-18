require 'spec_helper'

describe 'Nftables::RuleName' do
  it { is_expected.to allow_value('chain-rule') }
  it { is_expected.to allow_value('Chain_name-Rule_name') }
  it { is_expected.to allow_value('chain5_name0-rule_name-3') }
  it { is_expected.to allow_value('chain_name-rule2_name-33') }
  it { is_expected.to allow_value('chainname-3') }
  it { is_expected.not_to allow_value('-rule_name-') }
  it { is_expected.not_to allow_value('rule_name') }
  it { is_expected.not_to allow_value('chain_name-rule_name-') }
  it { is_expected.not_to allow_value('chain_name-rule_name-3b') }
  it { is_expected.not_to allow_value('chain_name-rule_name-foo') }
end
