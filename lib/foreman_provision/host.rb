# encoding: UTF-8
require 'foreman_api'
require 'foreman_provision/architecture'
require 'foreman_provision/compute_resource'
require 'foreman_provision/domain'
require 'foreman_provision/environment'
require 'foreman_provision/hostgroup'
require 'foreman_provision/location'
require 'foreman_provision/medium'
require 'foreman_provision/operating_system'
require 'foreman_provision/organization'
require 'foreman_provision/ptable'
require 'foreman_provision/puppetclass'
require 'foreman_provision/smart_proxy'

module Foreman_Provision
  class Host < BaseResource

    # @param [Hash] params
    # @return [Hash]
    def create(params)
      host = {}

      architecture_id = @res_arch.get_by_name(params[:architecture]) || nil
      host['architecture_id'] = architecture_id if architecture_id

      host['build'] = params[:build]

      compute_attributes = params[:compute_attributes] || nil
      host['compute_attributes'] = compute_attributes if compute_attributes

      compute_resource_id = @res_compres.get_by_name(params[:compute_resource]) || nil
      host['compute_resource_id'] = compute_resource_id if compute_resource_id

      domain_id = @res_domain.get_by_name(params[:domain]) || nil
      host['domain_id'] = domain_id if domain_id

      environment_id = @res_env.get_by_name(params[:environment]) || nil
      host['environment_id'] = environment_id if environment_id

      hostgroup_id = @res_hg.get_by_name(params[:hostgroup]) || nil
      host['hostgroup_id'] = hostgroup_id if hostgroup_id

      ip = params[:ip] || nil
      host['ip'] = ip if ip

      location_id = @res_loc.get_by_name(params[:location]) || nil
      host['location_id'] = location_id if location_id

      mac = params[:mac] || nil
      host['mac'] = mac if mac

      medium_id = @res_med.get_by_name(params[:medium]) || nil
      host['medium_id'] = medium_id if medium_id

      host['name'] = params[:name]

      operatingsystem_id = @res_os.get_by_name(params[:operatingsystem]) || nil
      host['operatingsystem_id'] = operatingsystem_id if operatingsystem_id

      organization_id = @res_org.get_by_name(params[:organization]) || nil
      host['organization_id'] = organization_id if organization_id

      provision_method = params[:provision_method] || nil
      host['provision_method'] = provision_method if provision_method

      ptable_id = @res_ptable.get_by_name(params[:ptable]) || nil
      host['ptable_id'] = ptable_id if ptable_id

      puppet_ca_proxy_id = @res_sp.get_by_name(params[:puppet_ca_proxy]) || nil
      host['puppet_ca_proxy_id'] = puppet_ca_proxy_id if puppet_ca_proxy_id

      puppetclass_ids = []
      params[:puppetclasses].each {|i| puppetclass_ids.push(@res_pc.get_by_name(i))}
      host['puppetclass_ids'] = puppetclass_ids if puppetclass_ids

      puppet_proxy_id = @res_sp.get_by_name(params[:puppet_proxy]) || nil
      host['puppet_proxy_id'] = puppet_proxy_id if puppet_proxy_id

      subnet_id = @res_subnet.get_by_name(params[:subnet]) || nil
      host['subnet_id'] = subnet_id if subnet_id

      @_params = {
          'host' => host,
      }

      super
    end


    # @param [Hash] params
    # @return [Hash]
    def destroy(params)
      @_params = {
          'id' => get_by_name(params[:name]),
      }

      super
    end


    # @param [Hash] params
    # @return [Hash]
    def index(params)
      @_params = {
          'search' => params[:search],
      }

      super
    end


    # @param [Hash] params
    # @return [Hash]
    def show(params)
      @_params = {
          'id' => params[:id],
      }

      super
    end


    # @param [Hash] params
    # @return [Hash]
    def update(params)
      @_params = {
          'id' => params[:id],
          'common_parameter' => params[:params]
      }

      super
    end


    # Helper stuff

    # @param [Hash] params
    # @return [Integer]
    def exists(params)
      if !params.key?(:name) || !params[:name].is_a?(String)
        raise(TypeError)
      end

      name = params[:name]
      # work around for non period (non fqdn hostnames in foreman >1.4)
      if !name.include? '.'
        name = "#{params[:name]}.#{params[:domain]}"
      end

      get_by_name(name)
    end


    # Internal stuff

    # @param [Object] credentials
    # @param [Object] logger
    def initialize(credentials, logger)
      super

      @resource = ForemanApi::Resources::Host.new(
          @credentials,
          @credentials[:options],
      )

      @res_arch = Architecture.new(@credentials, @logger)
      @res_compres = ComputeResource.new(@credentials, @logger)
      @res_domain = Domain.new(@credentials, @logger)
      @res_env = Environment.new(@credentials, @logger)
      @res_hg = Hostgroup.new(@credentials, @logger)
      @res_loc = Location.new(@credentials, @logger)
      @res_med = Medium.new(@credentials, @logger)
      @res_org = Organization.new(@credentials, @logger)
      @res_os = OperatingSystem.new(@credentials, @logger)
      @res_pc = Puppetclass.new(@credentials, @logger)
      @res_ptable = Ptable.new(@credentials, @logger)
      @res_sp = SmartProxy.new(@credentials, @logger)
      @res_subnet = Subnet.new(@credentials, @logger)
    end
  end
end
