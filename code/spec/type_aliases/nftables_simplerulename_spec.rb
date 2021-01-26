require 'spec_helper'

describe 'Nftables::SimpleRuleName' do
  it { is_expected.to allow_value('rule') }
  it { is_expected.to allow_value('Rule_name') }
  it { is_expected.to allow_value('rule_name-3') }
  it { is_expected.to allow_value('rule_name-33') }
  it { is_expected.to allow_value('3') }
  it { is_expected.not_to allow_value('rule_name-') }
  it { is_expected.not_to allow_value('rule_name-3b') }
  it { is_expected.not_to allow_value('rule_name-foo') }
end
