# encoding: UTF-8
require 'foreman_api'
require 'foreman_provision/domain'
require 'foreman_provision/location'
require 'foreman_provision/organization'
require 'foreman_provision/smart_proxy'

module Foreman_Provision
  class Subnet < BaseResource

    # @param [Hash] params
    # @return [Hash]
    def create(params)
      dhcp_id = @res_sp.get_by_name(params[:dhcp_proxy]) || nil
      dns_id =  @res_sp.get_by_name(params[:dns_proxy]) || nil
      dns_primary = params[:dns_primary] || nil
      dns_secondary = params[:dns_secondary] || nil
      domain_ids = []
      from =  params[:from] || nil
      gateway =  params[:gateway] || nil
      location_ids = []
      organization_ids = []
      tftp_id =  @res_sp.get_by_name(params[:tftp_proxy]) || nil
      to =  params[:to] || nil
      vlanid =  params[:vlanid] || nil

      params[:domain_names].each {|i| domain_ids.push(@res_domain.get_by_name(i))}
      params[:locations].each {|i| location_ids.push(@res_loc.get_by_name(i))}
      params[:organizations].each {|i| organization_ids.push(@res_org.get_by_name(i))}

      @_params = {
          'subnet' => {
              'dhcp_id' => dhcp_id,
              'dns_id' => dns_id,
              'dns_primary' => dns_primary,
              'dns_secondary' => dns_secondary,
              'domain_ids' => domain_ids,
              'from' => from,
              'gateway' => gateway,
              'location_ids' => location_ids,
              'mask' => params[:mask],
              'name' => params[:name],
              'network' => params[:network],
              'organization_ids' => organization_ids,
              'tftp_id' => tftp_id,
              'to' => to,
              'vlanid' => vlanid,
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
          'common_parameter' => params[:params]
      }

      super
    end


    # Internal stuff

    # @param [Object] credentials
    # @param [Object] logger
    def initialize(credentials, logger)
      super

      @resource = ForemanApi::Resources::Subnet.new(
          @credentials,
          @credentials[:options],
      )

      @res_domain = Domain.new(@credentials, @logger)
      @res_loc = Location.new(@credentials, @logger)
      @res_org = Organization.new(@credentials, @logger)
      @res_sp = SmartProxy.new(@credentials, @logger)
    end
  end
end
