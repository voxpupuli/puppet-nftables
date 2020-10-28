# Files to facilitate Continuous Integration
Files customised for puppet module *it-puppet-module-nftables*.


## Dockerfile
Produces a Docker image suitable to run puppet CI tests.

## Rakefile
Contains methods for running tests.

## Gemfile
List of ruby gems to be installed to run tests.

## boilerplate
Example files that can be copied into the code directory
to get tests up and running.

Typically you should only copy these files over if
gitlab.cern.ch is the true upstream source of the module
and no offsite module exists where the tests would
be better maintained.

* [rspec tests for class *it-puppet-module-nftables*](boilerplate/spec/classes/init_spec.rb)
* [rspec tests for defined type  *it-puppet-module-nftables::mytype*](boilerplate/spec/defines/mytype_spec.rb)
* [boilerplate/spec/default_facts.yml - facts defined for every test](boilerplate/spec/default_facts.yml).
* [boilerplate/spec/spec_helper.rb - top level of test execution](boilerplate/spec/spec_helper.rb).
* [boilerplate/metadata.json - metadata for module including supported OSes](boilerplate/metadata.json).
* [boilerplate/spec/hiera.yaml - hiera definition to use inside tests](boilerplate/spec/hiera.yaml).
* [boilerplate/.fixtures.yml - list and locations of dependencies needed by test dependencies](boilerplate/.fixtures.yml)
* [boilerplate/.rspec - puppet rspec options](boilerplate/.rspec)
* [boilerplate/.rubocop - rubocop configuration](boilerplate/.rubocop)
