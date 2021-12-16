# frozen_string_literal: true

require 'spec_helper'

describe 'Nftables::Addr' do
  it { is_expected.to allow_value('127.0.0.1') }
  it { is_expected.to allow_value('172.16.1.0/24') }
  it { is_expected.to allow_value('2001:1458::/32') }
  it { is_expected.to allow_value('2001:1458::3') }
  it { is_expected.to allow_value('@set_name') }
  it { is_expected.not_to allow_value('anything') }
  it { is_expected.not_to allow_value(43) }
  it { is_expected.not_to allow_value(['127.0.0.1']) }
end
