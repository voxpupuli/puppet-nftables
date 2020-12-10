require 'spec_helper'

describe 'Nftables::Port' do
  it { is_expected.to allow_value(53) }
  it { is_expected.to allow_value([1, 1985, 65_535]) }
  it { is_expected.to allow_value('53-55') }
  it { is_expected.not_to allow_value('53') }
  it { is_expected.not_to allow_value([]) }
end
