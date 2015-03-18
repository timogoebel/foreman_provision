# encoding: UTF-8
require 'foreman_api'
require 'foreman_provision/common_parameter'
require 'foreman_provision/configuration'
require 'foreman_provision/domain'
require 'foreman_provision/host'
require 'foreman_provision/hostgroup'
require 'foreman_provision/parameter'
require 'foreman_provision/smart_proxy'
require 'foreman_provision/subnet'

module Foreman_Provision
  class Provision

    # @param [Object] credentials
    # @param [Object] logger
    # @param [Boolean] test
    def initialize(credentials, logger, test = false)
      @credentials = credentials
      @logger = logger
      @test = test
    end

    # @param [Object] resource
    # @param [Hash] params
    def manage_resource(resource, params)
      exists = resource.exists(params)

      if ['present', 'updated'].include?(params[:state])
        if exists
          if params[:state] == 'updated'
            params[:test] = true
            result = resource.update(params)

            if @test && result['response']['needs_update']
              @logger.info("Would have updated #{resource.class.name.to_s} \"#{params[:name]}\" #{result['response'].inspect}!")
            elsif result['response']['needs_update']
              params[:test] = false
              @logger.info("Updating #{resource.class.name.to_s} \"#{params[:name]}\"")
              resource.update(params)
            else
              @logger.info("Skipping - #{resource.class.name.to_s} \"#{params[:name]}\" already up to date!")
            end
          else
            @logger.info("Skipping - #{resource.class.name.to_s} \"#{params[:name]}\" already exists!")
          end
        else
          if @test
            @logger.info("Would have created #{resource.class.name.to_s} #{params.inspect}")
          else
            @logger.info("Creating #{resource.class.name.to_s} \"#{params[:name]}\"")
            resource.create(params)
          end
        end
      elsif exists
        if @test
          @logger.info("Would have removed #{resource.class.name.to_s} \"#{params[:name]}\"")
        else
          @logger.info("Removing #{resource.class.name.to_s} \"#{params[:name]}\"")
          resource.destroy(params)
        end
      end
    end


    # @param [Hash] config
    # @return [Boolean]
    def run(config)
      if @test
        @logger.info("Running provision in test mode")
      end


      res_cparam = CommonParameter.new(@credentials, @logger)
      res_domain = Domain.new(@credentials, @logger)
      res_hg = Hostgroup.new(@credentials, @logger)
      res_host = Host.new(@credentials, @logger)
      res_param = Parameter.new(@credentials, @logger)
      res_sp = SmartProxy.new(@credentials, @logger)
      res_subnet = Subnet.new(@credentials, @logger)


      #
      # COMMON (GLOBAL) PARAMETERS
      #
      config.fetch(:common_params, []).each do |item|
        params = {}
        params[:name] = item.fetch(:name)
        params[:state] = item.fetch(:ensure, 'present')
        params[:value] = item.fetch(:value)

        manage_resource(res_cparam, params)
      end


      #
      # SUBNETS
      #
      config.fetch(:subnets, []).each do |item|
        params = {}
        params[:dhcp_proxy] = item.fetch(:dhcp_proxy)
        params[:dns_primary] = item.fetch(:dns_primary)
        params[:dns_proxy] = item.fetch(:dns_proxy)
        params[:dns_secondary] = item.fetch(:dns_secondary)
        params[:domain_names] = item.fetch(:domain_names, [])
        params[:from] = item.fetch(:from)
        params[:gateway] = item.fetch(:gateway)
        params[:locations] = item.fetch(:locations, [])
        params[:mask] = item.fetch(:mask)
        params[:name] = item.fetch(:name)
        params[:network] = item.fetch(:network)
        params[:organizations] = item.fetch(:organizations, [])
        params[:state] = item.fetch(:ensure, 'present')
        params[:tftp_proxy] = item.fetch(:tftp_proxy)
        params[:to] = item.fetch(:to)
        params[:vlanid] = item.fetch(:vlanid, '')

        manage_resource(res_subnet, params)
      end


      #
      # DOMAINS
      #
      config.fetch(:domains, []).each do |item|
        params = {}
        params[:dns_proxy] = item.fetch(:dns_proxy)
        params[:locations] = item.fetch(:locations, [])
        params[:name] = item.fetch(:name)
        params[:organizations] = item.fetch(:organizations, [])
        params[:state] = item.fetch(:ensure, 'present')

        manage_resource(res_domain, params)
      end


      #
      # SMART PROXIES
      #
      config.fetch(:proxies, []).each do |item|
        params = {}
        params[:locations] = item.fetch(:locations, [])
        params[:name] = item.fetch(:name)
        params[:organizations] = item.fetch(:organizations, [])
        params[:state] = item.fetch(:ensure, 'present')
        params[:url] = item.fetch(:url)

        manage_resource(res_sp, params)
      end


      #
      # HOSTGROUPS
      #
      config.fetch(:hostgroups, []).each do |item|
        params = {}
        params[:architecture] = item.fetch(:architecture, nil)
        params[:domain] = item.fetch(:domain, nil)
        params[:environment] = item.fetch(:environment, nil)
        params[:locations] = item.fetch(:locations, [])
        params[:medium] = item.fetch(:medium, nil)
        params[:name] = item.fetch(:name)
        params[:operatingsystem] = item.fetch(:operatingsystem, nil)
        params[:organizations] = item.fetch(:organizations, [])
        params[:parent] = item.fetch(:parent, nil)
        params[:ptable] = item.fetch(:ptable, nil)
        params[:puppet_ca_proxy] = item.fetch(:puppet_ca_proxy, nil)
        params[:puppet_proxy] = item.fetch(:puppet_proxy, nil)
        params[:state] = item.fetch(:ensure, 'present')
        params[:subnet] = item.fetch(:subnet, nil)

        manage_resource(res_hg, params)
      end


      #
      # HOSTS
      #
      config.fetch(:hosts, []).each do |item|
        params = {}
        params[:architecture] = item.fetch(:architecture, nil)
        params[:build] = item.fetch(:build, true)
        params[:compute_attributes] = item.fetch(:compute_attributes, nil)
        params[:compute_resource] = item.fetch(:compute_resource, nil)
        params[:domain] = item.fetch(:domain, nil)
        params[:environment] = item.fetch(:environment, nil)
        params[:hostgroup] = item.fetch(:hostgroup, nil)
        params[:ip] = item.fetch(:ip, nil)
        params[:location] = item.fetch(:location, nil)
        params[:mac] = item.fetch(:mac, nil)
        params[:medium] = item.fetch(:medium, nil)
        params[:name] = item.fetch(:name)
        params[:operatingsystem] = item.fetch(:operatingsystem, nil)
        params[:organization] = item.fetch(:organization, nil)
        params[:parent] = item.fetch(:parent_id, nil)
        params[:provision_method] = item.fetch(:provision_method, nil)
        params[:ptable] = item.fetch(:ptable, nil)
        params[:puppet_ca_proxy] = item.fetch(:puppet_ca_proxy, nil)
        params[:puppetclasses] = item.fetch(:puppetclasses, nil)
        params[:puppet_proxy] = item.fetch(:puppet_proxy, nil)
        params[:state] = item.fetch(:ensure, 'present')
        params[:subnet] = item.fetch(:subnet, nil)

        manage_resource(res_host, params)
      end


      #
      # REGULAR PARAMETERS
      #
      config.fetch(:params, []).each do |item|
        item.fetch(:params, []).each do |param|
          params = {item.fetch(:type) => item.fetch(:name)}
          params[:state] = param.fetch(:ensure, item.fetch(:ensure, 'present'))
          params[:name] = param.fetch(:name)
          params[:value] = param.fetch(:value)

          manage_resource(res_param, params)
        end
      end
    end
  end
end
