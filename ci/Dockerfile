# This file is maintained via modulesync.
#
#  Docker file we use for puppet module ci builds.
#
#
FROM gitlab-registry.cern.ch/linuxsupport/c8-base
#
# # Docker really has no HERE doc?
#
#
RUN mkdir -p ~/.ssh && echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config
#

RUN dnf clean all && dnf -y update && \
  dnf -y install epel-release redhat-rpm-config rubygem-rake rubygem-bundler ruby-devel \
    git gcc-c++ make augeas-devel openssh-clients git libxslt-devel openldap-devel unzip \
    dmidecode which && \
  dnf -y install rubygem-yaml-lint && \
  dnf clean all

COPY . /it-puppet-module-nftables

RUN cd /it-puppet-module-nftables/code && \
  rm -f ../ci/Gemfile.lock; \
  BUNDLE_GEMFILE=../ci/Gemfile FACTER_GEM_VERSION='~> 4.0' PUPPET_VERSION='~> 7.0' bundle install --full-index ; \
  rm -f ../ci/Gemfile.lock; \
  BUNDLE_GEMFILE=../ci/Gemfile PUPPET_VERSION='~> 6.15.0' bundle install --full-index ; \
  rm -f ../ci/Gemfile.lock; \
  BUNDLE_GEMFILE=../ci/Gemfile PUPPET_VERSION='~> 6.0' bundle install --full-index ; \
  rm -f ../ci/Gemfile.lock ; \

