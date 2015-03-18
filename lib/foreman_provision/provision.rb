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

      if ['present', 'updated'].include?(params[:ensure])
        if exists
          if params[:ensure] == 'updated'
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
        keys = [
          :name,
          :ensure,
          :value,
        ]

        keys.each do |key|
          if key == :ensure
            params[key] = item.fetch(key, 'present')
          else
            params[key] = item.fetch(key, nil)
          end
        end

        manage_resource(res_cparam, params)
      end


      #
      # SUBNETS
      #
      config.fetch(:subnets, []).each do |item|
        params = {}
        keys = [
          :dhcp_proxy,
          :dns_primary,
          :dns_proxy,
          :dns_secondary,
          :domain_names,
          :from,
          :gateway,
          :locations,
          :mask,
          :name,
          :network,
          :organizations,
          :ensure,
          :tftp_proxy,
          :to,
          :vlanid,
        ]

        keys.each do |key|
          if key == :ensure
            params[key] = item.fetch(key, 'present')
          else
            params[key] = item.fetch(key, nil)
          end
        end

        manage_resource(res_subnet, params)
      end


      #
      # DOMAINS
      #
      config.fetch(:domains, []).each do |item|
        params = {}
        keys = [
          :dns_proxy,
          :locations,
          :name,
          :organizations,
          :ensure,
        ]

        keys.each do |key|
          if key == :ensure
            params[key] = item.fetch(key, 'present')
          else
            params[key] = item.fetch(key, nil)
          end
        end

        manage_resource(res_domain, params)
      end


      #
      # SMART PROXIES
      #
      config.fetch(:proxies, []).each do |item|
        params = {}
        keys = [
          :locations,
          :name,
          :organizations,
          :ensure,
          :url,
        ]

        keys.each do |key|
          if key == :ensure
            params[key] = item.fetch(key, 'present')
          else
            params[key] = item.fetch(key, nil)
          end
        end

        manage_resource(res_sp, params)
      end


      #
      # HOSTGROUPS
      #
      config.fetch(:hostgroups, []).each do |item|
        params = {}
        keys = [
          :architecture,
          :domain,
          :environment,
          :locations,
          :medium,
          :name,
          :operatingsystem,
          :organizations,
          :parent,
          :ptable,
          :puppet_ca_proxy,
          :puppet_proxy,
          :ensure,
          :subnet,
        ]

        keys.each do |key|
          if key == :ensure
            params[key] = item.fetch(key, 'present')
          else
            params[key] = item.fetch(key, nil)
          end
        end

        manage_resource(res_hg, params)
      end


      #
      # HOSTS
      #
      config.fetch(:hosts, []).each do |item|
        params = {}
        keys = [
          :architecture,
          :build,
          :compute_attributes,
          :compute_resource,
          :domain,
          :environment,
          :hostgroup,
          :ip,
          :location,
          :mac,
          :medium,
          :name,
          :operatingsystem,
          :organization,
          :parent,
          :provision_method,
          :ptable,
          :puppet_ca_proxy,
          :puppetclasses,
          :puppet_proxy,
          :ensure,
          :subnet,
        ]

        keys.each do |key|
          if key == :ensure
            params[key] = item.fetch(key, 'present')
          elsif key == :build
            params[key] = item.fetch(key, true)
          else
            params[key] = item.fetch(key, nil)
          end
        end

        manage_resource(res_host, params)
      end


      #
      # REGULAR PARAMETERS
      #
      config.fetch(:params, []).each do |item|
        item.fetch(:params, []).each do |param|
          params = {item.fetch(:type) => item.fetch(:name)}
          keys = [
            :ensure,
            :name,
            :value,
          ]

          keys.each do |key|
            if key == :ensure
              params[key] = param.fetch(:ensure, item.fetch(:ensure, 'present'))
            else
              params[key] = item.fetch(key, nil)
            end
          end

          manage_resource(res_param, params)
        end
      end
    end
  end
end
