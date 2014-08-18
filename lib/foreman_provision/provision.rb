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
        @credentials, @credentials[:options]
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
        @credentials, @credentials[:options]
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
        @credentials, @credentials[:options]
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
        @credentials, @credentials[:options]
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
        @credentials, @credentials[:options]
      )
      res = computeresource.index()[0]['results'].select{|entry| entry["name"]==name }
      res[0]['id'] if res.any?
    end

    # Method to get computeprofile id from computeprofile name
    #
    # * *Example* :
    #  id = get_computeprofile_id_by_name('KVM-Small')
    # * *Args*    :
    #   - +name+ -> +String+ computeprofile Name
    # * *Returns* :
    #   - +Integer+ computeprofile id
    #
    def get_computeprofile_id_by_name(name)
      # TODO: not implemented
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
        @credentials, @credentials[:options]
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
        @credentials, @credentials[:options]
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
        @credentials, @credentials[:options]
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
        @credentials, @credentials[:options]
      )
      res = medium.index()[0]['results'].select{|entry| entry["name"]==name }
      res[0]['id'] if res.any?
    end

    # Method to get subnet id from subnet name
    #
    # * *Example* :
    #  id = get_subnet_id_by_name('backend A')
    # * *Args*    :
    #   - +name+ -> +String+ subnet Name
    # * *Returns* :
    #   - +Integer+ subnet id
    #
    def get_subnet_id_by_name(name)
      subnet = ForemanApi::Resources::Subnet.new(
        @credentials, @credentials[:options]
      )
      res = subnet.index()[0]['results'].select{|entry| entry["name"]==name }
      res[0]['id'] if res.any?
    end

    # Method to get smartproxy id from smartproxy name
    #
    # * *Example* :
    #  id = get_proxy_id_by_name('smartproxy.domain')
    # * *Args*    :
    #   - +name+ -> +String+ smartproxy Name
    # * *Returns* :
    #   - +Integer+ smartproxy id
    #
    def get_proxy_id_by_name(name)
      proxy = ForemanApi::Resources::SmartProxy.new(
        @credentials, @credentials[:options]
      )
      res = proxy.index()[0]['results'].select{|entry| entry["name"]==name }
      res[0]['id'] if res.any?
    end

    # Method to get domain id from domain name
    #
    # * *Example* :
    #  id = get_domain_id_by_name('domain.com')
    # * *Args*    :
    #   - +name+ -> +String+ domain Name
    # * *Returns* :
    #   - +Integer+ domain id
    #
    def get_domain_id_by_name(name)
      domain = ForemanApi::Resources::Domain.new(
        @credentials, @credentials[:options]
      )
      res = domain.index()[0]['results'].select{|entry| entry["name"]==name }
      res[0]['id'] if res.any?
    end

    # Method to get param id from param name
    #
    # * *Example* :
    #  id = get_param_id_by_name('sample_param')
    # * *Args*    :
    #   - +name+ -> +String+ param Name
    # * *Returns* :
    #   - +Integer+ param id
    #
    def get_param_id_by_name(name)
      param = ForemanApi::Resources::CommonParameter.new(
        @credentials, @credentials[:options]
      )
      res = param.index()[0]['results'].select{|entry| entry["name"]==name }
      res[0]['id'] if res.any?
    end

    # Method to get organization id from param name
    #
    # * *Example* :
    #  id = get_org_id_by_name('my company')
    # * *Args*    :
    #   - +name+ -> +String+ organization Name
    # * *Returns* :
    #   - +Integer+ organization id
    #
    def get_org_id_by_name(name)
      org = ForemanApi::Resources::Organization.new(
        @credentials, @credentials[:options]
      )
      res = org.index()[0]['results'].select{|entry| entry["name"]==name }
      res[0]['id'] if res.any?
    end

    # Method to get location id from location name
    #
    # * *Example* :
    #  id = get_location_id_by_name('my site')
    # * *Args*    :
    #   - +name+ -> +String+ location Name
    # * *Returns* :
    #   - +Integer+ location id
    #
    def get_location_id_by_name(name)
      location = ForemanApi::Resources::Location.new(
        @credentials, @credentials[:options]
      )
      res = location.index()[0]['results'].select{|entry| entry["name"]==name }
      res[0]['id'] if res.any?
    end

    # Method to validate if host exist
    #
    # * *Example* :
    #  id = is_host('host.domain')
    # * *Args*    :
    #   - +name+ -> +String+ host Name
    # * *Returns* :
    #   - +Boolean+ returns true if host exists in foreman
    #
    def is_host(name)
      get_host_id_by_name(name)
    end

    # Method to validate if subnet exist
    #
    # * *Example* :
    #  id = is_subnet('backend A')
    # * *Args*    :
    #   - +name+ -> +String+ subnet Name
    # * *Returns* :
    #   - +Boolean+ returns true if subnet exists in foreman
    #
    def is_subnet(name)
      get_subnet_id_by_name(name)
    end

    # Method to validate if smart proxy exist
    #
    # * *Example* :
    #  id = is_proxy('smartproxy.domain')
    # * *Args*    :
    #   - +name+ -> +String+ smart proxy  Name
    # * *Returns* :
    #   - +Boolean+ returns true if smart proxy  exists in foreman
    #
    def is_proxy(name)
      get_proxy_id_by_name(name)
    end

    # Method to validate if domain exist
    #
    # * *Example* :
    #  id = is_domain('domain.com')
    # * *Args*    :
    #   - +name+ -> +String+ domain Name
    # * *Returns* :
    #   - +Boolean+ returns true if domain exists in foreman
    #
    def is_domain(name)
      get_domain_id_by_name(name)
    end

    # Method to validate if a parameter exist
    #
    # * *Example* :
    #  id = is_param('sample_param')
    # * *Args*    :
    #   - +name+ -> +String+ parameter Name
    # * *Returns* :
    #   - +Boolean+ returns true if parameter exists in foreman
    #
    def is_param(name)
      get_param_id_by_name(name)
    end

    # Method to validate if an organization exist
    #
    # * *Example* :
    #  id = is_org('my company')
    # * *Args*    :
    #   - +name+ -> +String+ organization Name
    # * *Returns* :
    #   - +Boolean+ returns true if organization exists in foreman
    #
    def is_org(name)
      get_org_id_by_name(name)
    end

    # Method to validate if a hostgroup exist
    #
    # * *Example* :
    #  id = is_hostgroup('my hosts')
    # * *Args*    :
    #   - +name+ -> +String+ hostgroup Name
    # * *Returns* :
    #   - +Boolean+ returns true if hostgroup exists in foreman
    #
    def is_hostgroup(name)
      get_hostgroup_id_by_name(name)
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

    # Method to resolve array of domain names to array of ids
    #
    # * *Example* :
    #  domain_ids = resolve_domain_names(domainnames)
    # * *Args*    :
    #   - +domainnames+ -> +Array+ of domain names
    # * *Returns* :
    #   - +Array+ of domainname ids
    #
    def resolve_domain_names(domainnames)
      raise TypeError unless domainnames.is_a? Array
      res = []
      domainnames.each do |domainname|
        res.push(get_domain_id_by_name(domainname))
      end
      return res
    end

    # Method to resolve array of location names to array of ids
    #
    # * *Example* :
    #  location_ids = resolve_location_names(locationnames)
    # * *Args*    :
    #   - +locationnames+ -> +Array+ of location names
    # * *Returns* :
    #   - +Array+ of location ids
    #
    def resolve_location_names(locationnames)
      raise TypeError unless locationnames.is_a? Array
      res = []
      locationnames.each do |locationname|
        res.push(get_location_id_by_name(locationname))
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
        @credentials, @credentials[:options]
      )
      host.create({:host => hostdata})
      puts "Created Host \"#{hostdata[:name]}\" in foreman"
    end

    # Method to create a HostGroup in foreman
    #
    # * *Example* :
    #  create_hostgroup(hostgroupdata)
    # * *Args*    :
    #   - +hostgroupdata+ -> +Hash+ containing the hostgroup configuration data
    # * *Returns* :
    #   - +Boolean+ if hostgroup created successfully
    #
    def create_hostgroup(hostgroupdata)
      hostgroup = ForemanApi::Resources::Hostgroup.new(
        @credentials, @credentials[:options]
      )
      hostgroup.create({:hostgroup => hostgroupdata})
      puts "Created Hostgroup \"#{hostgroupdata[:name]}\" in foreman"
    end

    # Method to create a Subnet in foreman
    #
    # * *Example* :
    #  create_subnet(subnetdata)
    # * *Args*    :
    #   - +subnetdata+ -> +Hash+ containing the subnet configuration data
    # * *Returns* :
    #   - +Boolean+ true if subnet created successfully
    #
    def create_subnet(subnetdata)
      subnet = ForemanApi::Resources::Subnet.new(
        @credentials, @credentials[:options]
      )
      subnet.create({:subnet => subnetdata})
      puts "Created Subnet \"#{subnetdata[:name]}\" in foreman"
    end

    # Method to create a smart proxy in foreman
    #
    # * *Example* :
    #  create_proxy(proxydata)
    # * *Args*    :
    #   - +proxydata+ -> +Hash+ containing the proxy configuration data
    # * *Returns* :
    #   - +Boolean+ true if proxy created successfully
    #
    def create_proxy(proxydata)
      proxy = ForemanApi::Resources::SmartProxy.new(
        @credentials, @credentials[:options]
      )
      proxy.create({:smart_proxy => proxydata})
      puts "Created Smart-Proxy \"#{proxydata[:name]}\" in foreman"
    end

    # Method to create a domain in foreman
    #
    # * *Example* :
    #  create_domain(domaindata)
    # * *Args*    :
    #   - +domaindata+ -> +Hash+ containing the domain configuration data
    # * *Returns* :
    #   - +Boolean+ true if domain created successfully
    #
    def create_domain(domaindata)
      domain = ForemanApi::Resources::Domain.new(
        @credentials, @credentials[:options]
      )
      domain.create({:domain => domaindata})
      puts "Created Domain \"#{domaindata[:name]}\" in foreman"
    end

    # Method to create a parameter  in foreman
    #
    # * *Example* :
    #  create_param(paramdata)
    # * *Args*    :
    #   - +paramdata+ -> +Hash+ containing the parameter configuration data
    # * *Returns* :
    #   - +Boolean+ true if parameter created successfully
    #
    def create_param(paramdata)
      param = ForemanApi::Resources::CommonParameter.new(
        @credentials, @credentials[:options]
      )
      param.create({:common_parameter => paramdata})
      puts "Created Parameter \"#{paramdata[:name]}\" in foreman"
    end

    # Method to create a set of Objects in foreman
    #
    # * *Example* :
    #  run(config)
    # * *Args*    :
    #   - +config+ -> +Hash+ containing the configuration data of hosts, subnets, proxies of domains
    # * *Returns* :
    #   - +Boolean+ true if finished successfully
    #
    def run(config)

      config.fetch(:params, []).each do |param|
        @logger.debug("creating global Parameter using data \"#{param}\"")
        if param.fetch(:name, false)
          is_param(param[:name]) ? (puts "Skipping - global Parameter \"#{param[:name]}\" already exists!") : create_param(param)
        end
      end if config.fetch(:params, false)

      config.fetch(:proxies, []).each do |proxy|
        # TODO: implement organizations
        # TODO: validate / implement param support
        @logger.debug("creating Smart-Proxy using data \"#{proxy}\"")
        proxy[:location_ids] = resolve_location_names(proxy.delete(:locations)) if proxy.fetch(:locations, false)
        if proxy.fetch(:name, false)
          is_proxy(proxy[:name]) ? (puts "Skipping - Smart-Proxy \"#{proxy[:name]}\" already exists!") : create_proxy(proxy)
        end
      end if config.fetch(:proxies, false)

      config.fetch(:domains, []).each do |domain|
        # TODO: implement organizations
        # TODO: validate / implement param support
        @logger.debug("creating Domain using data \"#{domain}\"")
        domain[:dns_id] = get_proxy_id_by_name(domain.delete(:dns_proxy)) if domain.fetch(:dns_proxy, false)
        domain[:location_ids] = resolve_location_names(domain.delete(:locations)) if domain.fetch(:locations, false)
        if domain.fetch(:name, false)
          is_domain(domain[:name]) ? (puts "Skipping - Domain \"#{domain[:name]}\" already exists!") : create_domain(domain)
        end
      end if config.fetch(:domains, false)

      config.fetch(:subnets, []).each do |subnet|
        # TODO: implement organizations
        # TODO: validate / implement param support
        @logger.debug("creating Subnet using data \"#{subnet}\"")
        subnet[:dns_id] = get_proxy_id_by_name(subnet.delete(:dns_proxy)) if subnet.fetch(:dns_proxy, false)
        subnet[:dhcp_id] = get_proxy_id_by_name(subnet.delete(:dhcp_proxy)) if subnet.fetch(:dhcp_proxy, false)
        subnet[:tftp_id] = get_proxy_id_by_name(subnet.delete(:tftp_proxy)) if subnet.fetch(:tftp_proxy, false)
        subnet[:domain_ids] = resolve_domain_names(subnet.delete(:domain_names)) if subnet.fetch(:domain_names, false)
        subnet[:location_ids] = resolve_location_names(subnet.delete(:locations)) if subnet.fetch(:locations, false)

        if subnet.fetch(:name, false)
          is_subnet(subnet[:name]) ? (puts "Skipping - Subnet \"#{subnet[:name]}\" already exists!") : create_subnet(subnet)
        end
      end if config.fetch(:subnets, false)

      config.fetch(:hostgroups, []).each do |hostgroup|
        # TODO: implement organizations
        # TODO: validate / implement param support
        @logger.debug("creating Hostgroup using data \"#{hostgroup}\"")
        hostgroup[:parent_id] = get_hostgroup_id_by_name(hostgroup.delete(:parent)) if hostgroup.fetch(:parent, false)
        hostgroup[:architecture_id] = get_architecture_id_by_name(hostgroup.delete(:architecture)) if hostgroup.fetch(:architecture, false)
        hostgroup[:operatingsystem_id] = get_os_id_by_name(hostgroup.delete(:operatingsystem)) if hostgroup.fetch(:operatingsystem, false)
        hostgroup[:environment_id] = get_environment_id_by_name(hostgroup.delete(:environment)) if hostgroup.fetch(:environment, false)
        hostgroup[:ptable_id] = get_ptable_id_by_name(hostgroup.delete(:ptable)) if hostgroup.fetch(:ptable, false)
        hostgroup[:medium_id] = get_medium_id_by_name(hostgroup.delete(:medium)) if hostgroup.fetch(:medium, false)
        hostgroup[:subnet_id] = get_subnet_id_by_name(hostgroup.delete(:subnet)) if hostgroup.fetch(:subnet, false)
        hostgroup[:domain_id] = get_domain_id_by_name(hostgroup.delete(:domain)) if hostgroup.fetch(:domain, false)
        hostgroup[:puppet_ca_proxy_id] = get_proxy_id_by_name(hostgroup.delete(:puppet_ca_proxy)) if hostgroup.fetch(:puppet_ca_proxy, false)
        hostgroup[:puppet_proxy_id] = get_proxy_id_by_name(hostgroup.delete(:puppet_proxy)) if hostgroup.fetch(:puppet_proxy, false)
        hostgroup[:puppetclass_ids] = resolve_puppetclass_names(hostgroup.delete(:puppetclasses)) if hostgroup.fetch(:puppetclasses, false)
        hostgroup[:location_ids] = resolve_location_names(hostgroup.delete(:locations)) if hostgroup.fetch(:locations, false)


        if hostgroup.fetch(:name, false)
          is_hostgroup(hostgroup[:name]) ? (puts "Skipping - Hostgroup \"#{hostgroup[:name]}\" already exists!") : create_hostgroup(hostgroup)
        end
      end if config.fetch(:hostgroups, false)

      config.fetch(:hosts, []).each do |host|
        # TODO: implement organizations
        # TODO: validate / implement param support
        @logger.debug("creating Host using data \"#{host}\"")
        host[:hostgroup_id] = get_hostgroup_id_by_name(host.delete(:hostgroup)) if host.fetch(:hostgroup, false)
        host[:compute_resource_id] = get_computeresource_id_by_name(host.delete(:compute_resource)) if host.fetch(:compute_resource, false)
        host[:architecture_id] = get_architecture_id_by_name(host.delete(:architecture)) if host.fetch(:architecture, false)
        host[:operatingsystem_id] = get_os_id_by_name(host.delete(:operatingsystem)) if host.fetch(:operatingsystem, false)
        host[:environment_id] = get_environment_id_by_name(host.delete(:environment)) if host.fetch(:environment, false)
        host[:ptable_id] = get_ptable_id_by_name(host.delete(:ptable)) if host.fetch(:ptable, false)
        host[:medium_id] = get_medium_id_by_name(host.delete(:medium)) if host.fetch(:medium, false)
        host[:domain_id] = get_domain_id_by_name(host[:domain]) if host.fetch(:domain, false)
        host[:subnet_id] = get_subnet_id_by_name(host.delete(:subnet)) if host.fetch(:subnet, false)
        host[:location_id] = get_location_id_by_name(host.delete(:location)) if host.fetch(:location, false)
        host[:puppetclass_ids] = resolve_puppetclass_names(host.delete(:puppetclasses)) if host.fetch(:puppetclasses, false)

        if host.fetch(:name, false)
          # work around for non period (non fqdn hostnames in foreman >1.4)
          if host.fetch(:name, '').include? '.'
            if is_host(host[:name])
	      puts "Skipping - Host \"#{host[:name]}\" already exists!"
	    else
              host.delete(:domain) if host.fetch(:domain, false)
	      create_host(host)
	    end
          else
            if is_host("#{host[:name]}.#{host[:domain]}")
	      puts "Skipping - Host \"#{host[:name]}.#{host[:domain]}\" already exists!"
	    else
              host.delete(:domain) if host.fetch(:domain, false)
	      create_host(host)
	    end
          end
        end
      end if config.fetch(:hosts, false)
    end
  end
end
