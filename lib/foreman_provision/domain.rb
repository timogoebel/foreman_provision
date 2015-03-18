# encoding: UTF-8
require 'foreman_api'
require 'foreman_provision/location'
require 'foreman_provision/organization'

module Foreman_Provision
  class Domain < BaseResource

    # @param [Hash] params
    # @return [Hash]
    def create(params)
      location_ids = []
      organization_ids = []

      params.fetch(:locations, []).each { |i| location_ids.push(@res_loc.get_by_name(i)) }
      params.fetch(:organizations, []).each { |i| organization_ids.push(@res_org.get_by_name(i)) }

      @_params = {
          'domain' => {
              'name' => params[:name],
              'dns_id' => @res_sp.get_by_name(params[:dns_proxy]),
          }
      }

      super
    end


    # @param [Hash] params
    # @return [Hash]
    def destroy(params)
      @_params = {
      }

      super
    end


    # @param [Hash] params
    # @return [Hash]
    def index(params)
      @_params = {
      }

      super
    end


    # @param [Hash] params
    # @return [Hash]
    def show(params)
      @_params = {
      }

      super
    end


    # @param [Hash] params
    # @return [Hash]
    def update(params)
      @_params = {
      }

      super
    end


    # Internal stuff

    # @param [Object] credentials
    # @param [Object] logger
    def initialize(credentials, logger)
      super

      @resource = ForemanApi::Resources::Domain.new(
          @credentials,
          @credentials[:options],
      )

      @res_loc = Location.new(@credentials, @logger)
      @res_os = OperatingSystem.new(@credentials, @logger)
      @res_sp = SmartProxy.new(@credentials, @logger)
    end
  end
end
