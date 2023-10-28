# frozen_string_literal: true

require 'spec_helper'

describe 'nftables::services::openafs_client' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'normal behaviour' do
        it { is_expected.to contain_class('nftables::rules::afs3_callback') }
        it { is_expected.to contain_class('nftables::rules::out::openafs_client') }
      end

      context 'out_all enabled' do
        let(:pre_condition) { 'class{\'nftables\': out_all => true}' }

        it { is_expected.not_to compile }
      end
    end
  end
end
