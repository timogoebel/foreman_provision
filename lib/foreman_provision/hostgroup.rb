# encoding: UTF-8
require 'foreman_api'
require 'foreman_provision/architecture'
require 'foreman_provision/domain'
require 'foreman_provision/environment'
require 'foreman_provision/location'
require 'foreman_provision/medium'
require 'foreman_provision/operating_system'
require 'foreman_provision/organization'
require 'foreman_provision/ptable'
require 'foreman_provision/smart_proxy'

module Foreman_Provision
  class Hostgroup < BaseResource

    # @param [Hash] params
    # @return [Hash]
    def create(params)
      architecture_id = @res_arch.get_by_name(params[:architecture]) || nil
      domain_id = @res_domain.get_by_name(params[:domain]) || nil
      environment_id = @res_env.get_by_name(params[:environment]) || nil
      location_ids = []
      medium_id = @res_med.get_by_name(params[:medium]) || nil
      operatingsystem_id = @res_os.get_by_name(params[:operatingsystem]) || nil
      organization_ids = []
      parent_id = get_by_name(params[:parent]) || nil
      ptable_id = @res_ptable.get_by_name(params[:ptable]) || nil
      puppet_ca_proxy_id = @res_sp.get_by_name(params[:puppet_ca_proxy]) || nil
      puppet_proxy_id = @res_sp.get_by_name(params[:puppet_proxy]) || nil
      subnet_id = @res_subnet.get_by_name(params[:subnet]) || nil

      params[:locations].each { |i| location_ids.push(@res_loc.get_by_name(i)) }
      params[:organizations].each { |i| organization_ids.push(@res_org.get_by_name(i)) }

      @_params = {
          'hostgroup' => {
              'architecture_id' => architecture_id,
              'domain_id' => domain_id,
              'environment_id' => environment_id,
              'location_ids' => location_ids,
              'medium_id' => medium_id,
              'name' => params[:name],
              'operatingsystem_id' => operatingsystem_id,
              'organization_ids' => organization_ids,
              'parent_id' => parent_id,
              'ptable_id' => ptable_id,
              'puppet_ca_proxy_id' => puppet_ca_proxy_id,
              'puppet_proxy_id' => puppet_proxy_id,
              'subnet_id' => subnet_id,
          }
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
          'common_parameter' => params[:params] #TODO common_parameter?
      }

      super
    end


    # Internal stuff

    # @param [Object] credentials
    # @param [Object] logger
    def initialize(credentials, logger)
      super

      @resource = ForemanApi::Resources::Hostgroup.new(
          @credentials,
          @credentials[:options],
      )

      @res_arch = Architecture.new(@credentials, @logger)
      @res_domain = Domain.new(@credentials, @logger)
      @res_env = Environment.new(@credentials, @logger)
      @res_med = Medium.new(@credentials, @logger)
      @res_loc = Location.new(@credentials, @logger)
      @res_os = OperatingSystem.new(@credentials, @logger)
      @res_org = Organization.new(@credentials, @logger)
      @res_ptable = Ptable.new(@credentials, @logger)
      @res_sp = SmartProxy.new(@credentials, @logger)
      @res_subnet = Subnet.new(@credentials, @logger)
    end
  end
end
