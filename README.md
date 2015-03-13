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

    logger = Foreman_Provision::Configuration.instance.set_logger('/tmp/provision.log', Logger::DEBUG)
    # see conf/foreman.yaml.sample for sample data
    credentials = Foreman_Provision::Configuration.instance.load_credentials('./conf/foreman.yaml')
    # see conf/config.yaml for sample data
    config = Foreman_Provision::Configuration.instance.load_config('./conf/config.yaml')
    provisioner = Foreman_Provision::Provision.new(credentials, logger)
    provisioner.run(config)

Or by using the foreman-provision script:

    Usage: foreman-provision -c conf/config.yaml -a conf/foreman.yaml -v -d
        -c, --config_file FILE           location of the configuration file
        -a, --auth_credentials FILE      location of the foreman auth credentials YAML file
        -v, --[no-]verbose               Run verbosely
        -l, --log_file FILE              location of the log file
        -d, --[no-]debug                 Run in debug mode

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

    cat conf/config.yaml.sample
    ---
    # kvm libvirt host
    :hosts:
      - :name: test10.local.venv.de
        :hostgroup: 'generic kvm hosts'
        :compute_resource: 'kvm_local'
        :architecture: 'x86_64'
        :operatingsystem: 'ubuntu 12.04'
        :environment: 'production'
        :build: 1
        :compute_attributes:
          :cpus: 1
          :start: "1"
          :power_action: start
          :memory: 805306368
          :nics_attributes:
            0:
              :type: :bridge
              :bridge: virbr0
              :model: virtio
          :volumes_attributes:
            0:
              :pool_name: virtimages
              :capacity: 5G
              :allocation: 0G
              :format_type: raw
        :puppetclasses:
          - stdlib
        :location: local

    # vmware vsphere
      - :name: test11.local.venv.de
        :hostgroup: 'vsphere'
        :compute_resource: 'vsphere_local'
        :architecture: 'x86_64'
        :ptable: 'RedHat LVM'
        :domain: local.venv.de
        :subnet: 'local network'
        :operatingsystem: 'RedHat 6.5'
        :environment: 'production'
        :build: 1
        :compute_attributes:
          :cpus: 1
          :start: "1"
          :cluster: 'ESX'
          :path: '/Datencenter/TEST/prod' # from compute_resource edit screen view source
          :memory_mb: 768
          :interfaces_attributes:
            0:
              :network: 'dvportgroup-100404' # from compute_resource edit screen view source
          :volumes_attributes:
            0:
              :datastore: MY_SAN
              :name: 'Hard disk'
              :size_gb: 5
              :thin: true
        :puppetclasses:
          - stdlib
        :location: LAN
    :subnets:
      - :name: test
        :network: 10.1.1.0
        :mask: 255.255.255.0
        :gateway: 10.1.1.1
        :from: 10.1.1.100
        :to: 10.1.1.150
        :dns_primary: 10.1.1.10
        :dns_secondary: 10.1.1.11
        :dhcp_proxy: foreman.local.venv.de
        :tftp_proxy: foreman.local.venv.de
        :dns_proxy: foreman.local.venv.de
        :vlanid: ''
        :domain_names:
          - local.venv.de
        :locations:
          - local
    :domains:
      - :name: local2.venv.de
        :dns_proxy: foreman.local.venv.de
        :fullname: 'My second local network'
        :locations:
          - local
    :proxies:
      - :name: foo2.local
        :url: https://foo2.local.venv.de:8443
        :locations:
          - local
    :params:
      - :hostgroup: Testsystems
        :parameter:
        :name: sample_param
        :value: some_value
      - :host: testhost.local.venv.de
        :parameter:
        :name: sample_param
        :value: some_value
      - :domain: foreman.local.venv.de
        :parameter:
        :name: sample_param
        :value: some_value
    :hostgroups:
      - :name: myhosts
        :architecture: 'x86_64'
        :operatingsystem: 'ubuntu 12.04'
        :ptable: 'Preseed default'
        :environment: 'production'
        :puppetclasses:
          - stdlib
        :subnet: 'local kvm subnet'
        :domain: 'local.venv.de'
        :puppet_proxy: foreman.local.venv.de
        :puppet_ca_proxy: foreman.local.venv.de
        :locations:
          - local
    :cparams:
      - :name: sample_global_param
        :value: sample value

Adapt the config to your needs!


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create new Pull Request
