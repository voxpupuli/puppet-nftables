# This file is maintained via modulesync.
#
#  Docker file we use for puppet module ci builds.
#
#
FROM gitlab-registry.cern.ch/linuxsupport/cc7-base
#
# # Docker really has no HERE doc?
#
#
RUN mkdir -p ~/.ssh && echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config
#

RUN yum clean all && yum -y update && \
     yum -y install centos-release-scl \
     yum -y install rh-ruby25-rubygem-rake rh-ruby25-rubygem-bundler rh-ruby25-ruby-devel rh-ruby24-rubygem-rake rh-ruby24-rubygem-bundler rh-ruby24-ruby-devel rubygem-bundler git ruby-devel gcc-c++ make augeas-devel openssh-clients git libxslt-devel rubygem-nokogiri openldap-devel unzip  && \
     yum install --nogpgcheck -y http://linuxsoft.cern.ch/internal/repos/ai7-stable/x86_64/os/Packages/rubygem-yaml-lint-0.0.4-2.ai7.noarch.rpm && \
     yum -y install dmidecode which && \
     yum clean all

COPY . /it-puppet-module-nftables

RUN cd /it-puppet-module-nftables/code && \
  rm -f ../ci/Gemfile.lock; \
  BUNDLE_GEMFILE=../ci/Gemfile PUPPET_VERSION='~> 5.5.19' scl enable rh-ruby24 'bundle install --full-index' ; \
  rm -f ../ci/Gemfile.lock; \
  BUNDLE_GEMFILE=../ci/Gemfile PUPPET_VERSION='~> 6.15.0' scl enable rh-ruby25 'bundle install --full-index' ; \
  rm -f ../ci/Gemfile.lock; \
  BUNDLE_GEMFILE=../ci/Gemfile PUPPET_VERSION='~> 6.0' scl enable rh-ruby25 'bundle install --full-index' ; \
  rm -f ../ci/Gemfile.lock ; \
  ln -s /opt/rh/rh-ruby24/root/usr/local/bin/puppet /opt/rh/rh-ruby24/root/usr/bin/puppet

