# encoding: UTF-8
require 'foreman_api'
require 'foreman_provision/configuration'
module Foreman_Provision
  # Class to Provision foreman Hosts via yaml data
  #
  # @author: Nils Domrose
  #
  # * *Example* :
  #  config = Foreman_Provision::Provision(credentials, logger)
  class Provision
    # Constructor of provision class
    #
    # * *Example* :
    #  config = Foreman_Provision::Provision(credentials, logger)
    # * *Args*    :
    #   - +credentials+ -> +Hash+ containing the foreman API credentials
    #   - +logger+ -> +Logger+ instance
    #
    def initialize(credentials, logger)
      @credentials = credentials
      @logger = logger

    end

    # Method to get operatingsystem id from operatingsystem name
    #
    # * *Example* :
    #  id = get_os_id_by_name('ubuntu 12.04')
    # * *Args*    :
    #   - +name+ -> +String+ Operating System Name
    # * *Returns* :
    #   - +Integer+ operatingsystem id
    #
    def get_os_id_by_name(name)
      os = ForemanApi::Resources::OperatingSystem.new(
        @credentials
      )
      res = os.index({:search => "name=#{name.split[0]}"})[0]['results'].select{|entry| entry["fullname"]==name }
      res[0]['id'] if res.any?
    end

    # Method to get hostgroup id from hostgroup name
    #
    # * *Example* :
    #  id = get_hostgroup_id_by_name('my_hosts')
    # * *Args*    :
    #   - +name+ -> +String+ Hostgroup Name
    # * *Returns* :
    #   - +Integer+ hostgroup id
    #
    def get_hostgroup_id_by_name(name)
      hostgroup = ForemanApi::Resources::Hostgroup.new(
        @credentials
      )
      res = hostgroup.index({:search => "name=" + '"' + name + '"'})[0]['results'].select{|entry| entry["name"]==name }
      res[0]['id'] if res.any?
    end

    # Method to get host id from host name
    #
    # * *Example* :
    #  id = get_host_id_by_name('host.domain')
    # * *Args*    :
    #   - +name+ -> +String+ Host Name
    # * *Returns* :
    #   - +Integer+ host id
    #
    def get_host_id_by_name(name)
      host = ForemanApi::Resources::Host.new(
        @credentials
      )
      res = host.index({:search => "name=#{name}"})[0]['results'].select{|entry| entry["name"]==name }
      res[0]['id'] if res.any?
    end

    # Method to get puppetclass id from puppetclass name
    #
    # * *Example* :
    #  id = get_puppetclass_id_by_name('ntp')
    # * *Args*    :
    #   - +name+ -> +String+ puppetclass Name
    # * *Returns* :
    #   - +Integer+ puppetclass id
    #
    def get_puppetclass_id_by_name(name)
      puppetclass = ForemanApi::Resources::Puppetclass.new(
        @credentials
      )
      results = puppetclass.index({:search => "name=#{name}"})[0]['results']
      results.key?(name) ? res = results[name].select{|entry| entry["name"]==name } : res = {}
      res[0]['id'] if res.any?
    end

    # Method to get computeresource id from computeresource name
    #
    # * *Example* :
    #  id = get_computeresource_id_by_name('kvm_libvirt')
    # * *Args*    :
    #   - +name+ -> +String+ computeresource Name
    # * *Returns* :
    #   - +Integer+ computeresource id
    #
    def get_computeresource_id_by_name(name)
      computeresource = ForemanApi::Resources::ComputeResource.new(
        @credentials
      )
      res = computeresource.index()[0]['results'].select{|entry| entry["name"]==name }
      res[0]['id'] if res.any?
    end

    # Method to get architecture id from architecture name
    #
    # * *Example* :
    #  id = get_architecture_id_by_name('x86_64')
    # * *Args*    :
    #   - +name+ -> +String+ architecture Name
    # * *Returns* :
    #   - +Integer+ architecture id
    #
    def get_architecture_id_by_name(name)
      architecture = ForemanApi::Resources::Architecture.new(
        @credentials
      )
      res = architecture.index()[0]['results'].select{|entry| entry["name"]==name }
      res[0]['id'] if res.any?
    end

    # Method to get environment id from environment name
    #
    # * *Example* :
    #  id = get_environment_id_by_name('production')
    # * *Args*    :
    #   - +name+ -> +String+ environment Name
    # * *Returns* :
    #   - +Integer+ environment id
    #
    def get_environment_id_by_name(name)
      environment = ForemanApi::Resources::Environment.new(
        @credentials
      )
      res = environment.index()[0]['results'].select{|entry| entry["name"]==name }
      res[0]['id'] if res.any?
    end

    # Method to get partition table id from partition table name
    #
    # * *Example* :
    #  id = get_ptable_id_by_name('Preseed Default')
    # * *Args*    :
    #   - +name+ -> +String+ partition table Name
    # * *Returns* :
    #   - +Integer+ partition table id
    #
    def get_ptable_id_by_name(name)
      ptable = ForemanApi::Resources::Ptable.new(
        @credentials
      )
      res = ptable.index()[0]['results'].select{|entry| entry["name"]==name }
      res[0]['id'] if res.any?
    end

    # Method to get medium id from medium name
    #
    # * *Example* :
    #  id = get_medium_id_by_name('Centos Mirror')
    # * *Args*    :
    #   - +name+ -> +String+ medium Name
    # * *Returns* :
    #   - +Integer+ medium id
    #
    def get_medium_id_by_name(name)
      medium = ForemanApi::Resources::Medium.new(
        @credentials
      )
      res = medium.index()[0]['results'].select{|entry| entry["name"]==name }
      res[0]['id'] if res.any?
    end

    # Method to validate if host exist
    #
    # * *Example* :
    #  id = is_host('host.domain')
    # * *Args*    :
    #   - +name+ -> +String+ host Name
    # * *Returns* :
    #   - +Boolean+ returns true is host exists in foreman
    #
    def is_host(name)
      get_host_id_by_name(name)
    end

    # Method to resolve array of puppet class names to array of ids
    #
    # * *Example* :
    #  puppetclass_ids = resolve_puppetclass_names(puppetclasses)
    # * *Args*    :
    #   - +puppetclasses+ -> +Array+ of puppetclass names
    # * *Returns* :
    #   - +Array+ of puppetclass ids
    #
    def resolve_puppetclass_names(puppetclasses)
      raise TypeError unless puppetclasses.is_a? Array
      res = []
      puppetclasses.each do |puppetclass|
        res.push(get_puppetclass_id_by_name(puppetclass))
      end
      return res
    end

    # Method to create a Host in foreman
    #
    # * *Example* :
    #  create_host(hostdata)
    # * *Args*    :
    #   - +hostdata+ -> +Hash+ containing the host configuration data
    # * *Returns* :
    #   - +Boolean+ if host created successfully
    #
    def create_host(hostdata)
      host = ForemanApi::Resources::Host.new(
          @credentials
      )
      host.create(hostdata)
      puts "Created Host \"#{hostdata[:name]}\" in foreman"
    end

    # Method to create a set of Host in foreman
    #
    # * *Example* :
    #  run(config)
    # * *Args*    :
    #   - +config+ -> +Hash+ containing the configuration data of several hosts
    # * *Returns* :
    #   - +Boolean+ if host created successfully
    #
    def run(config)
      config.fetch(:hosts, []).each do |host|
        @logger.debug("creating Host using data \"#{host}\"")
        host[:hostgroup_id] = get_hostgroup_id_by_name(host.delete(:hostgroup)) if host.fetch(:hostgroup, false)
        host[:compute_resource_id] = get_computeresource_id_by_name(host.delete(:compute_resource)) if host.fetch(:compute_resource, false)
        host[:architecture_id] = get_architecture_id_by_name(host.delete(:architecture)) if host.fetch(:architecture, false)
        host[:operatingsystem_id] = get_os_id_by_name(host.delete(:operatingsystem)) if host.fetch(:operatingsystem, false)
        host[:environment_id] = get_environment_id_by_name(host.delete(:environment)) if host.fetch(:environment, false)
        host[:ptable_id] = get_ptable_id_by_name(host.delete(:ptable)) if host.fetch(:ptable, false)
        host[:medium_id] = get_medium_id_by_name(host.delete(:medium)) if host.fetch(:medium, false)
        host[:puppetclass_ids] = resolve_puppetclass_names(host.delete(:puppetclasses)) if host.fetch(:puppetclasses, false)

        if host.fetch(:name, false)
          raise "Host \"#{host[:name]}\" already exists!" if is_host(host[:name])
          create_host(host)
        end
      end
    end
  end
end
