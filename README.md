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
     :hosts:
       - :name: ubuntuhost.domain
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
       - :name: centoshost.domain
         :hostgroup: 'generic kvm hosts'
         :compute_resource: 'kvm_local'
         :architecture: 'x86_64'
         :operatingsystem: 'CentOS 6.5'
         :ptable: 'Kickstart default'
         :medium: 'CentOS mirror (Cached)'
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
Adapt the config to your needs!


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create new Pull Request
