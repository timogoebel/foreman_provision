# ForemanProvision

Gem to provision foreman hosts using a config hash containing host data either read form file of from code

## Installation

Add this line to your application's Gemfile:

    gem 'foreman_provision'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install foreman_provision

## Usage

You can use this Gem either from your own code:

    #!/usr/bin/env ruby

    require 'foreman_provision'
    require 'logger'

    logger = ForemanProvision::Configuration.instance.set_logger('/tmp/provision.log', Logger::DEBUG)
    # see conf/foreman.yaml.sample for sample data
    credentials = ForemanProvision::Configuration.instance.load_credentials('./conf/foreman.yaml')
    # see conf/config.yaml for sample data
    config = ForemanProvision::Configuration.instance.load_config('./conf/config.yaml')
    provisioner = ForemanProvision::Provision.new(credentials, logger)
    provisioner.run(config)

Or by using the foreman-provision script:

    $ ./bin/foreman-provision -v -a conf/config.yaml -c examples/
    I, [2015-03-14T01:43:40.252855 #24829]  INFO -- : Skipping - ForemanProvision::Hostgroup "DE-TESTGROUP" already exists!
    I, [2015-03-14T01:43:40.445141 #24829]  INFO -- : Skipping - ForemanProvision::Hostgroup "DE-TESTGROUP-SBX" already exists!
    I, [2015-03-14T01:43:40.634460 #24829]  INFO -- : Skipping - ForemanProvision::Host "tst-fprovisioner-01" already exists!
    I, [2015-03-14T01:43:41.829353 #24829]  INFO -- : Skipping - ForemanProvision::Parameter "sample_param1" already up to date!
    I, [2015-03-14T01:43:43.504911 #24829]  INFO -- : Skipping - ForemanProvision::Parameter "configure.LIVE_HOST" already up to date!
    I, [2015-03-14T01:43:44.801499 #24829]  INFO -- : Skipping - ForemanProvision::Parameter "configure.DB_URL" already up to date!

You can add ``-t`` to run in test mode, if desired:

    $ ./bin/foreman-provision -v -a conf/config.yaml -c examples/ -t
    I, [2015-03-18T14:28:14.819170 #34248]  INFO -- : Running provision in test mode
    I, [2015-03-18T14:28:14.909404 #34248]  INFO -- : Skipping - ForemanProvision::CommonParameter "sample_global_param_foo" already exists!
    I, [2015-03-18T14:28:14.976404 #34248]  INFO -- : Would have created ForemanProvision::Subnet {:dhcp_proxy=>"foreman.local.venv.de", :dns_primary=>"10.1.1.10", :dns_proxy=>"foreman.local.venv.de", :dns_secondary=>"10.1.1.11", :domain_names=>["local.venv.de"], :from=>"10.1.1.100", :gateway=>"10.1.1.1", :locations=>["local"], :mask=>"255.255.255.0", :name=>"test", :network=>"10.1.1.0", :organizations=>[], :ensure=>"present", :tftp_proxy=>"foreman.local.venv.de", :to=>"10.1.1.150", :vlanid=>""}
    I, [2015-03-18T14:28:15.073105 #34248]  INFO -- : Would have created ForemanProvision::Domain {:dns_proxy=>"foreman.local.venv.de", :locations=>["local"], :name=>"local2.venv.de", :organizations=>[], :ensure=>"present"}
    I, [2015-03-18T14:28:15.141529 #34248]  INFO -- : Would have created ForemanProvision::SmartProxy {:locations=>["local"], :name=>"foo2.local", :organizations=>[], :ensure=>"present", :url=>"https://foo2.local.venv.de:8443"}
    I, [2015-03-18T14:28:15.213934 #34248]  INFO -- : Would have created ForemanProvision::Hostgroup {:architecture=>"x86_64", :domain=>"local.venv.de", :environment=>"production", :locations=>["local"], :medium=>nil, :name=>"myhosts", :operatingsystem=>"ubuntu 12.04", :organizations=>[], :parent=>nil, :ptable=>"Preseed default", :puppet_ca_proxy=>"foreman.local.venv.de", :puppet_proxy=>"foreman.local.venv.de", :ensure=>"present", :subnet=>"local kvm subnet"}
    I, [2015-03-18T14:28:15.286239 #34248]  INFO -- : Would have created ForemanProvision::Host {:architecture=>"x86_64", :build=>1, :compute_attributes=>{:cpus=>1, :start=>"1", :cluster=>"ESX", :path=>"/Datencenter/TEST/prod", :memory_mb=>768, :interfaces_attributes=>{0=>{:network=>"dvportgroup-100404"}}, :volumes_attributes=>{0=>{:datastore=>"MY_SAN", :name=>"Hard disk", :size_gb=>5, :thin=>true}}}, :compute_resource=>"vsphere_local", :domain=>"local.venv.de", :environment=>"production", :hostgroup=>"vsphere", :ip=>nil, :location=>"LAN", :mac=>nil, :medium=>nil, :name=>"test11.local.venv.de", :operatingsystem=>"RedHat 6.5", :organization=>nil, :parent=>nil, :provision_method=>nil, :ptable=>"RedHat LVM", :puppet_ca_proxy=>nil, :puppetclasses=>["stdlib"], :puppet_proxy=>nil, :ensure=>"present", :subnet=>"local network"}
    I, [2015-03-18T14:28:15.357802 #34248]  INFO -- : Would have created ForemanProvision::Parameter {"hostgroup"=>"Testsystems", :ensure=>"present", :name=>"sample_param1", :value=>"some_value1"}
    I, [2015-03-18T14:28:15.423885 #34248]  INFO -- : Would have created ForemanProvision::Parameter {"hostgroup"=>"Testsystems", :ensure=>"present", :name=>"sample_param2", :value=>"some_value1"}

### Sample foreman credential data:

    cat conf/foreman.yaml.sample
    ---
    :base_url: https://127.0.0.1
    :oauth:
      :consumer_key:  <your consumer key>
      :consumer_secret: <your consumer secret>
    :headers:
      :foreman_user: <foreman user>

Adapt the config to your needs!


### Sample host config data:

See ``examples/`` directory to see example YAML files.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create new Pull Request
